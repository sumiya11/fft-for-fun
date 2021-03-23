### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 9b7ade00-8b74-11eb-051e-bff228d61e2a
begin
	import WAV
	import Plots
	import FFTW
	using WAV
	using FFTW
	using Plots
end

# ╔═╡ 6463f900-8b75-11eb-10be-cdbb2c7f79a0
md"
##### Load data first

sounds filenames"

# ╔═╡ a2c08d00-8b73-11eb-3706-81bf79eb5825
filenames = [
	"ow_runaway_melody.wav",
	"ow_runaway_based_bass.wav",
	"ow_runaway_full.wav"
]

# ╔═╡ 56cd9440-8b75-11eb-1466-7ba8d8edc019
md"do some magic with filenames"

# ╔═╡ 0b2dd682-8b75-11eb-159e-0bda57afaf6e
files = map(
	name -> replace("$(normpath(joinpath(@__FILE__, "..", "..")))data/"*name,
    		"\\" => "/"),
	filenames)

# ╔═╡ 9b115150-8b75-11eb-02ac-eb733a4c8bcf
md"parse and get acoustic samples"

# ╔═╡ 83304ce0-8b74-11eb-1a08-ed1beebb0039
parsed = [wavread(name)[1] for name in files]

# ╔═╡ b1be3800-8b75-11eb-12fe-f5f1cadebf8b
md"due to documentation, the first returned value is the data"

# ╔═╡ 05747760-8b77-11eb-3db4-39a116ea93fa
length(parsed[1])

# ╔═╡ a621bc90-8b77-11eb-1fd1-1d7809060dcf
md"thats too l0ng sound, cut smth off  

15157334 == 180 s.

  336000 == 4 s.
"

# ╔═╡ cc94e050-8b77-11eb-3f7b-39c3365cb34a
begin
	sz = 336000
	shrink = [
		p[1:sz] for p in parsed
	]
end

# ╔═╡ 943af0d0-8b74-11eb-0758-39e65ecfe2f7
sounds = (
	melody=shrink[1],
	bass  =shrink[2],
	full  =shrink[3]
);

# ╔═╡ 2349e820-8b76-11eb-3b8d-d3374c9ed1ff
md"lets plot melody and bass waves"

# ╔═╡ 32bf6d20-8b76-11eb-3fd0-03484aa516c7
plot([sounds.melody, sounds.bass], layout=2)

# ╔═╡ 34d6b460-8b76-11eb-1fb2-659e40e0b435
md"and full, mixed up"

# ╔═╡ 348cda20-8b76-11eb-0a5b-2da0098b6b04
plot(sounds.full)

# ╔═╡ 3447e1e0-8b76-11eb-214c-e31c343ebe92
md"##### now we can FFT

историческая справка: преобразование Фурье переводит содержимое *.wav файла в формат частот 
"

# ╔═╡ 33a7350e-8b76-11eb-1b06-bd934c9e01aa
frequencies = fft.(shrink)

# ╔═╡ ff300460-8b7a-11eb-2c84-f334e9a6764d
md"draw melody and bass freqs separately..

*примечание*
- рисуем в первых 10000 единиц времени, т.к судя по рисункам выше, 10к -- это период функций, и дальше все поввторяется
- рисуем модули чисел, т.к не хотим возиться с комплексными числами
"

# ╔═╡ 54136400-8b7a-11eb-2259-139e15ac25f9
plot([abs.(frequencies[1]), abs.(frequencies[2])], layout=2, x_lims=(1, 10000))

# ╔═╡ 2aab74d0-8b7b-11eb-155a-bd7564a84390
md"then draw the sum of melody and bass freqs.."

# ╔═╡ 2c60029e-8b7b-11eb-1938-bf807ad54cf0
plot(abs.(frequencies[1] + frequencies[2]), x_lims=(1, 10000))

# ╔═╡ 5d6e7392-8b7b-11eb-1c60-3bdf638d02b1
md"and finally check on the result of FFT.."

# ╔═╡ 54cfd630-8b7a-11eb-2287-0fd6a6038423
plot(abs.(frequencies[3]), x_lims=(1, 10000))

# ╔═╡ 55b246ee-8b7a-11eb-04a6-5fa4c7464f6b
md"Таким образом, алгос:

- Делаем преобразование Фурье песни
- *куча деталей и подводных камней*
- получаем набор частот
- конец
"

# ╔═╡ Cell order:
# ╟─9b7ade00-8b74-11eb-051e-bff228d61e2a
# ╟─6463f900-8b75-11eb-10be-cdbb2c7f79a0
# ╟─a2c08d00-8b73-11eb-3706-81bf79eb5825
# ╟─56cd9440-8b75-11eb-1466-7ba8d8edc019
# ╠═0b2dd682-8b75-11eb-159e-0bda57afaf6e
# ╟─9b115150-8b75-11eb-02ac-eb733a4c8bcf
# ╠═83304ce0-8b74-11eb-1a08-ed1beebb0039
# ╟─b1be3800-8b75-11eb-12fe-f5f1cadebf8b
# ╠═05747760-8b77-11eb-3db4-39a116ea93fa
# ╟─a621bc90-8b77-11eb-1fd1-1d7809060dcf
# ╠═cc94e050-8b77-11eb-3f7b-39c3365cb34a
# ╠═943af0d0-8b74-11eb-0758-39e65ecfe2f7
# ╟─2349e820-8b76-11eb-3b8d-d3374c9ed1ff
# ╠═32bf6d20-8b76-11eb-3fd0-03484aa516c7
# ╟─34d6b460-8b76-11eb-1fb2-659e40e0b435
# ╠═348cda20-8b76-11eb-0a5b-2da0098b6b04
# ╟─3447e1e0-8b76-11eb-214c-e31c343ebe92
# ╠═33a7350e-8b76-11eb-1b06-bd934c9e01aa
# ╟─ff300460-8b7a-11eb-2c84-f334e9a6764d
# ╠═54136400-8b7a-11eb-2259-139e15ac25f9
# ╟─2aab74d0-8b7b-11eb-155a-bd7564a84390
# ╠═2c60029e-8b7b-11eb-1938-bf807ad54cf0
# ╟─5d6e7392-8b7b-11eb-1c60-3bdf638d02b1
# ╠═54cfd630-8b7a-11eb-2287-0fd6a6038423
# ╟─55b246ee-8b7a-11eb-04a6-5fa4c7464f6b

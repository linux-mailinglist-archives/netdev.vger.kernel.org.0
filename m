Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8603A421540
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhJDRkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233295AbhJDRke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 13:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F99861039;
        Mon,  4 Oct 2021 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633369125;
        bh=vcQOWft8YyK8G9vfHFK98UPIv9tG7OaSrrVrX8sQrhE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y88spcJG+1LcIHU7C459RDYgNfuFpyp/y5GAfZN5aXa6tyTEi3KX3QZsHUgrSuAOu
         pjz1cm9jVUXEl5luknhTnxbgp0eHT5Yp2xbfy8kcErKDYX8kjtzHLSUdJag22Q/jnV
         Q1YIG1KH73JtXNxsIDnQPdnaqw70XrgLySn7/qycv9I1v5jbi7g+11L265iXKoBSSK
         jPJ7xzAOXuK2I5b9bNDhr4vEJAWRasLenfLbqt67TZ/PqV+ByWG6FO1qHTZ60EXfEs
         CQt3dALYIusjay1hj5g8J/crwpLb7UNbaIRNr0lQwDhQcXJfNbSPcPcg0kcqp7i7vO
         rVtkpghhspZ3w==
Received: by mail-lf1-f44.google.com with SMTP id j5so69875404lfg.8;
        Mon, 04 Oct 2021 10:38:45 -0700 (PDT)
X-Gm-Message-State: AOAM531211q+rUz+UpbaIHDn2Gj1Pjoq54EwBzKTRwVXxJ5VP2wcmgG2
        jaloeKv32VjdeH1SaFHEbXCJ1TfJVwWdMB3o2yE=
X-Google-Smtp-Source: ABdhPJyLNC4iLSWVhl04gcInvNEty4nDGK4M6dUsYAmU4yMBZBeSKqvys0v4lvdFXTCa/XgWTxltSe5b9+YBqWca0jw=
X-Received: by 2002:ac2:5182:: with SMTP id u2mr15086254lfi.676.1633369122842;
 Mon, 04 Oct 2021 10:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <YVnfFTL/3T6jOwHI@krava>
In-Reply-To: <YVnfFTL/3T6jOwHI@krava>
From:   Song Liu <song@kernel.org>
Date:   Mon, 4 Oct 2021 10:38:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5UBAvFx+Ndi2ycZiP0jOMAUVXLZsaS57zhgK+3+Ja-_A@mail.gmail.com>
Message-ID: <CAPhsuW5UBAvFx+Ndi2ycZiP0jOMAUVXLZsaS57zhgK+3+Ja-_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftest/bpf: Switch recursion test to use htab_map_delete_elem
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 9:58 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Currently the recursion test is hooking __htab_map_lookup_elem
> function, which is invoked both from bpf_prog and bpf syscall.
>
> But in our kernel build, the __htab_map_lookup_elem gets inlined
> within the htab_map_lookup_elem, so it's not trigered and the
> test fails.
>
> Fixing this by using htab_map_delete_elem, which is not inlined
> for bpf_prog calls (like htab_map_lookup_elem is) and is used
> directly as pointer for map_delete_elem, so it won't disappear
> by inlining.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/prog_tests/recursion.c | 10 +++++-----
>  tools/testing/selftests/bpf/progs/recursion.c      |  9 +++------
>  2 files changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/recursion.c b/tools/testing/selftests/bpf/prog_tests/recursion.c
> index 0e378d63fe18..f3af2627b599 100644
> --- a/tools/testing/selftests/bpf/prog_tests/recursion.c
> +++ b/tools/testing/selftests/bpf/prog_tests/recursion.c
> @@ -20,18 +20,18 @@ void test_recursion(void)
>                 goto out;
>
>         ASSERT_EQ(skel->bss->pass1, 0, "pass1 == 0");
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash1), &key, 0);
> +       bpf_map_delete_elem(bpf_map__fd(skel->maps.hash1), &key);
>         ASSERT_EQ(skel->bss->pass1, 1, "pass1 == 1");
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash1), &key, 0);
> +       bpf_map_delete_elem(bpf_map__fd(skel->maps.hash1), &key);
>         ASSERT_EQ(skel->bss->pass1, 2, "pass1 == 2");
>
>         ASSERT_EQ(skel->bss->pass2, 0, "pass2 == 0");
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash2), &key, 0);
> +       bpf_map_delete_elem(bpf_map__fd(skel->maps.hash2), &key);
>         ASSERT_EQ(skel->bss->pass2, 1, "pass2 == 1");
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash2), &key, 0);
> +       bpf_map_delete_elem(bpf_map__fd(skel->maps.hash2), &key);
>         ASSERT_EQ(skel->bss->pass2, 2, "pass2 == 2");
>
> -       err = bpf_obj_get_info_by_fd(bpf_program__fd(skel->progs.on_lookup),
> +       err = bpf_obj_get_info_by_fd(bpf_program__fd(skel->progs.on_delete),
>                                      &prog_info, &prog_info_len);
>         if (!ASSERT_OK(err, "get_prog_info"))
>                 goto out;
> diff --git a/tools/testing/selftests/bpf/progs/recursion.c b/tools/testing/selftests/bpf/progs/recursion.c
> index 49f679375b9d..3c2423bb19e2 100644
> --- a/tools/testing/selftests/bpf/progs/recursion.c
> +++ b/tools/testing/selftests/bpf/progs/recursion.c
> @@ -24,8 +24,8 @@ struct {
>  int pass1 = 0;
>  int pass2 = 0;
>
> -SEC("fentry/__htab_map_lookup_elem")
> -int BPF_PROG(on_lookup, struct bpf_map *map)
> +SEC("fentry/htab_map_delete_elem")
> +int BPF_PROG(on_delete, struct bpf_map *map)
>  {
>         int key = 0;
>
> @@ -35,10 +35,7 @@ int BPF_PROG(on_lookup, struct bpf_map *map)
>         }
>         if (map == (void *)&hash2) {
>                 pass2++;
> -               /* htab_map_gen_lookup() will inline below call
> -                * into direct call to __htab_map_lookup_elem()
> -                */
> -               bpf_map_lookup_elem(&hash2, &key);
> +               bpf_map_delete_elem(&hash2, &key);
>                 return 0;
>         }
>
> --
> 2.31.1
>

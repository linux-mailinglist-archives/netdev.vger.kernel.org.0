Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CF4355D2
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhJTWVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhJTWVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:21:31 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34500C06161C;
        Wed, 20 Oct 2021 15:19:16 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i84so14473949ybc.12;
        Wed, 20 Oct 2021 15:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2cQZj1e5vJAdxpSKsjPDkNiKYKpcEjmrgKs4b0IylE=;
        b=HrIBWZqr8jP3MDBHAt7pFSvT2Y3xFrHlUSF7F/Y7uJSz5cmdZKqEZzmcK0makwzoBc
         mIrGMeYRl2i+dqvTer/H4FJxKAanFDnPCeJ6CqYNtBDuDxWmGUyJOIPvJY96K4E25TsP
         3BCsN3qCxSEuEwfLC+W9THCnQts9GBJfji9ztKO3G2O1uyytn4cC02vpxui3NKuAzFTd
         F/6NMiQr9v5H5J4z5YFT7ffcD2brGvTwXt3a8TosQXPCSfnND4KOEngR5sU5JVF+DlLu
         mzjgsv77bqsQuKp6aLdkKKL6QVIupLbnPN6ORwOz19tfPX/ECWjRXUiEhzqJU7NPZKeB
         U67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2cQZj1e5vJAdxpSKsjPDkNiKYKpcEjmrgKs4b0IylE=;
        b=DA6b4nWY/8xHhSXkI0Vy5tNE/lduykBXkc/PqaNfiBmcd7cUr2v/nFYa2AA7wNYMtB
         vaooXjT5AL9EUAi2Nqfgi/HROd0hEUzsop3XOPPLGHrWnsX421mfo8IHNjAdgZNRCALX
         4B9VmTjY3D+CT/2/S2zr4DgOmuLFo5H3TLSIK565gmdhctJjgzlgu/+lSIXKjT6EJ107
         NXWajeCaIOmhLbOOci0u7xxUhzSfLU8p10ZhSzJrgnITqvXTQMEUOZXZP1FtBUf+o8ng
         lQBV7Fq0Asf9eZaCHyzTGgxy17BGOTyF+Bm/FVKc39IvFENIQ+5VddPyTxuTmWUCxY/W
         fa7w==
X-Gm-Message-State: AOAM530iu3NeDgErGEjM/X3MQqhIXrlRqOyJaibkIeq53UtYV+3I6yWU
        mveA2jRZq9W6PucjmUnq3ao1MrQSW2JxfuNo6f4=
X-Google-Smtp-Source: ABdhPJymbcTRLj3cdfQ7yzBFDTlPv8vWH8PSc61BRxk5YpOmSQ+P/8HHtN5N6KdrhF/1C3cBQyprhLxzMrMLEwZS/Vg=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr2035545ybk.2.1634768355513;
 Wed, 20 Oct 2021 15:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211020191526.2306852-1-memxor@gmail.com> <20211020191526.2306852-8-memxor@gmail.com>
In-Reply-To: <20211020191526.2306852-8-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 15:19:04 -0700
Message-ID: <CAEf4Bzbg-GiH9qM_BcRbi=wKqFwh3txb04DaL2dhz8EM5GZhGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 7/8] selftests/bpf: Fix fd cleanup in
 sk_lookup test
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Similar to the fix in commit:
> e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
>
> We use designated initializer to set fds to -1 without breaking on
> future changes to MAX_SERVER constant denoting the array size.
>
> The particular close(0) occurs on non-reuseport tests, so it can be seen
> with -n 115/{2,3} but not 115/4. This can cause problems with future
> tests if they depend on BTF fd never being acquired as fd 0, breaking
> internal libbpf assumptions.
>
> Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> index aee41547e7f4..cbee46d2d525 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> @@ -598,7 +598,7 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
>
>  static void run_lookup_prog(const struct test *t)
>  {
> -       int server_fds[MAX_SERVERS] = { -1 };
> +       int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };

if you have this, why do you need early break logic below?

>         int client_fd, reuse_conn_fd = -1;
>         struct bpf_link *lookup_link;
>         int i, err;
> @@ -663,8 +663,9 @@ static void run_lookup_prog(const struct test *t)
>         if (reuse_conn_fd != -1)
>                 close(reuse_conn_fd);
>         for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
> -               if (server_fds[i] != -1)
> -                       close(server_fds[i]);
> +               if (server_fds[i] == -1)
> +                       break;
> +               close(server_fds[i]);
>         }
>         bpf_link__destroy(lookup_link);
>  }
> @@ -1053,7 +1054,7 @@ static void run_sk_assign(struct test_sk_lookup *skel,
>                           struct bpf_program *lookup_prog,
>                           const char *remote_ip, const char *local_ip)
>  {
> -       int server_fds[MAX_SERVERS] = { -1 };
> +       int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
>         struct bpf_sk_lookup ctx;
>         __u64 server_cookie;
>         int i, err;
> @@ -1097,8 +1098,9 @@ static void run_sk_assign(struct test_sk_lookup *skel,
>
>  close_servers:
>         for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
> -               if (server_fds[i] != -1)
> -                       close(server_fds[i]);
> +               if (server_fds[i] == -1)
> +                       break;
> +               close(server_fds[i]);
>         }
>  }
>
> --
> 2.33.1
>

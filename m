Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F102A0B89
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgJ3Qnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3Qnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 12:43:50 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A94220727;
        Fri, 30 Oct 2020 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076229;
        bh=+c90p9MaJzJuRoN3BvzXiKmnGAJxiR0Sa0P4b8aUQzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t88tlPU/NUroEniVPjW4TqLnvWhrIfH7ontb/tEW1sdRT1FnoiQWKwy+fSUx68sT0
         rs+vZHx9YuNZDX4RlYGkx+PYCs8BQegue4RXJCYXSWqtTEusaM36gdfe9y47LRbpYq
         RMWf3ILhVtq4udvvmC0MqjaXWbCMgZYZmibfi+A8=
Received: by mail-lj1-f171.google.com with SMTP id m8so1531797ljj.0;
        Fri, 30 Oct 2020 09:43:48 -0700 (PDT)
X-Gm-Message-State: AOAM532qaDsqxVA3X6h99Ub1b4JpHMEpTene47Fd6aJCiygLTnVKTH25
        8iOmZ1CUJAdzTQ7nWT7BrCHiR26dDKFN1loC/f4=
X-Google-Smtp-Source: ABdhPJxm9sgEJSwmgM8hEzqnta7s9o9UIZv9ydY0U2OJxGGE0P5Itz/d9cN8+Gju9yF5FTpwjHbDKtASYlPQqQbzWVY=
X-Received: by 2002:a05:651c:1341:: with SMTP id j1mr1556651ljb.41.1604076227193;
 Fri, 30 Oct 2020 09:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-3-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-3-andrii@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 30 Oct 2020 09:43:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6DxoRjBPJEgwzEtmVt-Uunw-MAmAF2tgh-ksjcKuJ4Bw@mail.gmail.com>
Message-ID: <CAPhsuW6DxoRjBPJEgwzEtmVt-Uunw-MAmAF2tgh-ksjcKuJ4Bw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/11] selftest/bpf: relax btf_dedup test checks
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 1:40 AM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Remove the requirement of a strictly exact string section contents. This used
> to be true when string deduplication was done through sorting, but with string
> dedup done through hash table, it's no longer true. So relax test harness to
> relax strings checks and, consequently, type checks, which now don't have to
> have exactly the same string offsets.
>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf.c | 34 +++++++++++---------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index 93162484c2ca..2ccc23b2a36f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -6652,7 +6652,7 @@ static void do_test_dedup(unsigned int test_num)
>         const void *test_btf_data, *expect_btf_data;
>         const char *ret_test_next_str, *ret_expect_next_str;
>         const char *test_strs, *expect_strs;
> -       const char *test_str_cur, *test_str_end;
> +       const char *test_str_cur;
>         const char *expect_str_cur, *expect_str_end;
>         unsigned int raw_btf_size;
>         void *raw_btf;
> @@ -6719,12 +6719,18 @@ static void do_test_dedup(unsigned int test_num)
>                 goto done;
>         }
>
> -       test_str_cur = test_strs;
> -       test_str_end = test_strs + test_hdr->str_len;
>         expect_str_cur = expect_strs;
>         expect_str_end = expect_strs + expect_hdr->str_len;
> -       while (test_str_cur < test_str_end && expect_str_cur < expect_str_end) {
> +       while (expect_str_cur < expect_str_end) {
>                 size_t test_len, expect_len;
> +               int off;
> +
> +               off = btf__find_str(test_btf, expect_str_cur);
> +               if (CHECK(off < 0, "exp str '%s' not found: %d\n", expect_str_cur, off)) {
> +                       err = -1;
> +                       goto done;
> +               }
> +               test_str_cur = btf__str_by_offset(test_btf, off);
>
>                 test_len = strlen(test_str_cur);
>                 expect_len = strlen(expect_str_cur);
> @@ -6741,15 +6747,8 @@ static void do_test_dedup(unsigned int test_num)
>                         err = -1;
>                         goto done;
>                 }
> -               test_str_cur += test_len + 1;
>                 expect_str_cur += expect_len + 1;
>         }
> -       if (CHECK(test_str_cur != test_str_end,
> -                 "test_str_cur:%p != test_str_end:%p",
> -                 test_str_cur, test_str_end)) {
> -               err = -1;
> -               goto done;
> -       }
>
>         test_nr_types = btf__get_nr_types(test_btf);
>         expect_nr_types = btf__get_nr_types(expect_btf);
> @@ -6775,10 +6774,15 @@ static void do_test_dedup(unsigned int test_num)
>                         err = -1;
>                         goto done;
>                 }
> -               if (CHECK(memcmp((void *)test_type,
> -                                (void *)expect_type,
> -                                test_size),
> -                         "type #%d: contents differ", i)) {

I guess test_size and expect_size are not needed anymore?

> +               if (CHECK(btf_kind(test_type) != btf_kind(expect_type),
> +                         "type %d kind: exp %d != got %u\n",
> +                         i, btf_kind(expect_type), btf_kind(test_type))) {
> +                       err = -1;
> +                       goto done;
> +               }
> +               if (CHECK(test_type->info != expect_type->info,
> +                         "type %d info: exp %d != got %u\n",
> +                         i, expect_type->info, test_type->info)) {

btf_kind() returns part of ->info, so we only need the second check, no?

IIUC, test_type and expect_type may have different name_off now. Shall
we check ->size matches?


>                         err = -1;
>                         goto done;
>                 }
> --
> 2.24.1
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75384231935
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 07:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG2Fra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 01:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgG2Fr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 01:47:29 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586E82076E;
        Wed, 29 Jul 2020 05:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596001648;
        bh=+WB5S4EUSYj9U8GerYyzIfJZ+GbBnDojCyo18cw1w58=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iVB83wrjNVIir5RzuS/9oqjU+7rkKUod7nsc8eN8DhXXD9+BsVOVYgZn2i1DCA5Hb
         WMyBlDbATfNAO0DVZQF/J4EN4JatHWE/oMOoZcSTXlThoaQ/2q2v1LZckTVNBKX1A4
         Nx+8+nK/JCIjMZOqXrPydIFSokuf5RcOjY4B+wsA=
Received: by mail-lj1-f178.google.com with SMTP id f5so23679351ljj.10;
        Tue, 28 Jul 2020 22:47:28 -0700 (PDT)
X-Gm-Message-State: AOAM530K/WDU2NECdJAhiaCb3PBhpeTgJywUQr9xSW03NyLse1wLbPov
        GrIqx+A4TEb6s/mwOaBRXh5740kJLEme2Xi3BRA=
X-Google-Smtp-Source: ABdhPJwKdPkRubAu9u5iSNjP8Oj0EuibB46fjzf+3bu4c8wQI/AJyuCMgUjGo0jbxkkpJr+im9XquhGPfaCAnxpCtmc=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr14093989ljk.27.1596001646642;
 Tue, 28 Jul 2020 22:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200729045056.3363921-1-andriin@fb.com>
In-Reply-To: <20200729045056.3363921-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Jul 2020 22:47:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5e5B8AShod0frVaDdDA_5f3xeyd6gr9sTqUSy4YM1pBA@mail.gmail.com>
Message-ID: <CAPhsuW5e5B8AShod0frVaDdDA_5f3xeyd6gr9sTqUSy4YM1pBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: don't destroy failed link
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 9:54 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Check that link is NULL or proper pointer before invoking bpf_link__destroy().
> Not doing this causes crash in test_progs, when cg_storage_multi selftest
> fails.
>
> Cc: YiFei Zhu <zhuyifei@google.com>
> Fixes: 3573f384014f ("selftests/bpf: Test CGROUP_STORAGE behavior on shared egress + ingress")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

btw: maybe we can move the IS_ERR() check to bpf_link__destroy()?

> ---
>  .../bpf/prog_tests/cg_storage_multi.c         | 42 ++++++++++++-------
>  1 file changed, 28 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
> index c67d8c076a34..643dfa35419c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
> @@ -147,8 +147,10 @@ static void test_egress_only(int parent_cgroup_fd, int child_cgroup_fd)
>                 goto close_bpf_object;
>
>  close_bpf_object:
> -       bpf_link__destroy(parent_link);
> -       bpf_link__destroy(child_link);
> +       if (!IS_ERR(parent_link))
> +               bpf_link__destroy(parent_link);
> +       if (!IS_ERR(child_link))
> +               bpf_link__destroy(child_link);
>
>         cg_storage_multi_egress_only__destroy(obj);
>  }
> @@ -262,12 +264,18 @@ static void test_isolated(int parent_cgroup_fd, int child_cgroup_fd)
>                 goto close_bpf_object;
>
>  close_bpf_object:
> -       bpf_link__destroy(parent_egress1_link);
> -       bpf_link__destroy(parent_egress2_link);
> -       bpf_link__destroy(parent_ingress_link);
> -       bpf_link__destroy(child_egress1_link);
> -       bpf_link__destroy(child_egress2_link);
> -       bpf_link__destroy(child_ingress_link);
> +       if (!IS_ERR(parent_egress1_link))
> +               bpf_link__destroy(parent_egress1_link);
> +       if (!IS_ERR(parent_egress2_link))
> +               bpf_link__destroy(parent_egress2_link);
> +       if (!IS_ERR(parent_ingress_link))
> +               bpf_link__destroy(parent_ingress_link);
> +       if (!IS_ERR(child_egress1_link))
> +               bpf_link__destroy(child_egress1_link);
> +       if (!IS_ERR(child_egress2_link))
> +               bpf_link__destroy(child_egress2_link);
> +       if (!IS_ERR(child_ingress_link))
> +               bpf_link__destroy(child_ingress_link);
>
>         cg_storage_multi_isolated__destroy(obj);
>  }
> @@ -367,12 +375,18 @@ static void test_shared(int parent_cgroup_fd, int child_cgroup_fd)
>                 goto close_bpf_object;
>
>  close_bpf_object:
> -       bpf_link__destroy(parent_egress1_link);
> -       bpf_link__destroy(parent_egress2_link);
> -       bpf_link__destroy(parent_ingress_link);
> -       bpf_link__destroy(child_egress1_link);
> -       bpf_link__destroy(child_egress2_link);
> -       bpf_link__destroy(child_ingress_link);
> +       if (!IS_ERR(parent_egress1_link))
> +               bpf_link__destroy(parent_egress1_link);
> +       if (!IS_ERR(parent_egress2_link))
> +               bpf_link__destroy(parent_egress2_link);
> +       if (!IS_ERR(parent_ingress_link))
> +               bpf_link__destroy(parent_ingress_link);
> +       if (!IS_ERR(child_egress1_link))
> +               bpf_link__destroy(child_egress1_link);
> +       if (!IS_ERR(child_egress2_link))
> +               bpf_link__destroy(child_egress2_link);
> +       if (!IS_ERR(child_ingress_link))
> +               bpf_link__destroy(child_ingress_link);
>
>         cg_storage_multi_shared__destroy(obj);
>  }
> --
> 2.24.1
>

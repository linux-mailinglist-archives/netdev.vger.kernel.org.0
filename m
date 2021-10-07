Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A7B425D9D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhJGUf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhJGUf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DA76103B;
        Thu,  7 Oct 2021 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633638842;
        bh=ojiQz4xt9XvyqRAI7SPg+IotnOkxn/xUE/EnqwfLZlE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GvcCMCY6wE2RZ7cLLdMrWQabY4BTzAMdhBtJvZEp+CeHUCRXhjMAn2uRxUZs+bjCR
         4aEFoBOBM5WnkxTYMBvtM9dS77/mppcFfFHFmxQGgBc/VAsuK4OhrHm6OD03tYfBmE
         pcJ9R5jtrS0OZZeqIclV83nRced4URviTZLoSbzTPcUT+rAe4kFtPR1cS72kOBvpIL
         /2NsH6p8D47AsgbiUXQ3/IjslR0dgr1R5b/lltSKgFxeGn8hO1udtt+h5A/ogzOkum
         peVUP6TdlUfFEt3dSZCmNmE5Brjkqay7YtEEeYEcMAn8pI0BgiBsBNxoMD6HY9gfme
         l1tszehJybQAQ==
Received: by mail-lf1-f47.google.com with SMTP id y15so30049735lfk.7;
        Thu, 07 Oct 2021 13:34:02 -0700 (PDT)
X-Gm-Message-State: AOAM533BKiX+wC1mSeHZONZUQg8zF0ZoxaFgZsOFxeps8/4X2OgG+ay2
        hCH/U97UyUf/Pnj5S4Bqmk8amDQPeP59deNYGn8=
X-Google-Smtp-Source: ABdhPJxntQLeFaPde6qOADYmFg9uO4W8d25DWPIPdc5BrZ2Ed8kx9cluZ1AymMKS5zZkbqXFV/g9XYDerVbqpRP9U8I=
X-Received: by 2002:a2e:3907:: with SMTP id g7mr6899558lja.285.1633638840629;
 Thu, 07 Oct 2021 13:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-5-memxor@gmail.com>
In-Reply-To: <20211006002853.308945-5-memxor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 13:33:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com>
Message-ID: <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 4/6] bpf: selftests: Move test_ksyms_weak test
 to lskel, add libbpf test
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> Create a file for testing libbpf skeleton as well, so that both
> gen_loader and libbpf get tested.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[...]
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> new file mode 100644
> index 000000000000..b75725e28647
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include "test_ksyms_weak.skel.h"
> +
> +void test_ksyms_weak_libbpf(void)

This is (almost?) the same as test_weak_syms(), right? Why do we need both?

> +{
> +       struct test_ksyms_weak *skel;
> +       struct test_ksyms_weak__data *data;
> +       int err;
> +
> +       skel = test_ksyms_weak__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
> +               return;

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> index 5f8379aadb29..521e7b99db08 100644
> --- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> @@ -21,7 +21,6 @@ __u64 out__non_existent_typed = -1;
>  extern const struct rq runqueues __ksym __weak; /* typed */
>  extern const void bpf_prog_active __ksym __weak; /* typeless */
>
> -
>  /* non-existent weak symbols. */
>
>  /* typeless symbols, default to zero. */
> @@ -38,7 +37,7 @@ int pass_handler(const void *ctx)
>         /* tests existing symbols. */
>         rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
>         if (rq)
> -               out__existing_typed = rq->cpu;
> +               out__existing_typed = 0;

Why do we need this change?

>         out__existing_typeless = (__u64)&bpf_prog_active;
>
>         /* tests non-existent symbols. */
> --
> 2.33.0
>

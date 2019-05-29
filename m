Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CF2E2BA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfE2RBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:01:32 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39911 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfE2RBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:01:32 -0400
Received: by mail-qt1-f194.google.com with SMTP id i34so3495929qta.6;
        Wed, 29 May 2019 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDg5s41H/Le6Vky7GnMK/Onoij5YEoC450y0nZXn5Zg=;
        b=QNmDO3R/fG533Yb5gbmEk3SpaATJT5yzl9lrHaOe+xR2pN/RzIvl3i7ACuX7SPRoth
         lVMh4ceBSJ7abRq3kgos6A8L+X0CwVtU/cJIQXMNfR4ShEhiSlESLkRVmge0SCtCZ7s0
         b23nDkUNfvCtWkL4qaTT8+sZ0N2/IqnIYvJPrA25SQizz1ktE3ExQ7Aud4sYpOPoxFKE
         hQzV7NmZsVQrmnKp/OinG6nCIGWiW5BDCAdmjaiZm353umjSn5wLpZWsG83/SzweW2rV
         jP66q+6cukCgcWEJUTf1gWO65SV9JJkLxnr3genGVwOM6lj/v5BNIb0ip4gR1j+mVANC
         NCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDg5s41H/Le6Vky7GnMK/Onoij5YEoC450y0nZXn5Zg=;
        b=M6sFCa1vpi8EiYPT3qSQIfPP13H5DmBohzl8QI24xmeCCZVxmHxNhgavPPDw8Fq3ZY
         Ysls4Yr6HgDmARzTDM56IKzOHE4RRozze2QRBvD9JieP8P1HiYRFhT3YZj64zxcwKKjV
         gBeDzu5dyXTWYxdrHjDYcK/1so8fnrKTjzgHlK01oiUncec7a9pZpg09ab2qH6/3AbqI
         SvKd8qj604+yY5v5qge0I6JkQPRvBUewrbKzZffBtjvrJNSj3jv01W+mzejwDHAStkgi
         NYvJcb/+kj5PTPQIJB+CeHnc2MRtijqTtJcx/n9afrHjJe1RANfcjs3t/l2jCB274W1d
         n+ag==
X-Gm-Message-State: APjAAAU8ZyLp6EogG104y6j4RJv0dRDJgpTOCDbyBCL/R7De3j/gz5gL
        xE/DP3nUZXHWy9HYdrPZipy0zb01oW0+O34h8ns=
X-Google-Smtp-Source: APXvYqxjmlaJMlLo6JJnOpJ77hvyEMtIkkDr1X+axmuBBnQcal6HE5G7RY/U19m/Tdk9V8juCXwfdbWoWuoUd2BCb60=
X-Received: by 2002:ac8:2af4:: with SMTP id c49mr82844115qta.83.1559149291448;
 Wed, 29 May 2019 10:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-2-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-2-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:01:20 -0700
Message-ID: <CAPhsuW7zZ=QQs2wpR46+0hydSzRYza2_7kSAr0a1nBChSHbu6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] libbpf: fix detection of corrupted BPF
 instructions section
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Ensure that size of a section w/ BPF instruction is exactly a multiple
> of BPF instruction size.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ca4432f5b067..05a73223e524 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -349,8 +349,11 @@ static int
>  bpf_program__init(void *data, size_t size, char *section_name, int idx,
>                   struct bpf_program *prog)
>  {
> -       if (size < sizeof(struct bpf_insn)) {
> -               pr_warning("corrupted section '%s'\n", section_name);
> +       const size_t bpf_insn_sz = sizeof(struct bpf_insn);
> +
> +       if (size < bpf_insn_sz || size % bpf_insn_sz) {

how about
           if (!size || size % bpf_insn_sz)

> +               pr_warning("corrupted section '%s', size: %zu\n",
> +                          section_name, size);
>                 return -EINVAL;
>         }
>
> @@ -376,9 +379,8 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
>                            section_name);
>                 goto errout;
>         }
> -       prog->insns_cnt = size / sizeof(struct bpf_insn);
> -       memcpy(prog->insns, data,
> -              prog->insns_cnt * sizeof(struct bpf_insn));
> +       prog->insns_cnt = size / bpf_insn_sz;
> +       memcpy(prog->insns, data, prog->insns_cnt * bpf_insn_sz);

Given the check above, we can just use size in memcpy, right?

Thanks,
Song

>         prog->idx = idx;
>         prog->instances.fds = NULL;
>         prog->instances.nr = -1;
> --
> 2.17.1
>

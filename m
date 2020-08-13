Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76651244007
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHMUqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMUqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:46:35 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE1DC061757;
        Thu, 13 Aug 2020 13:46:34 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x10so3995491ybj.13;
        Thu, 13 Aug 2020 13:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4YqrEj5VRWDiRt2Idp5zIwlFmoyUZaY/uAgM+dXmFH4=;
        b=tqikhG8E5NukICJvqeaDLtEal+Gvsucc9DJUqflCvDbAUQZ9aTOa7jItS5MvTH8wrf
         n+VE/NGS2m8Rv/OZ1wJOmKHD0b9gBZyUqybKYliB2dwor+RgkUOnFTxxB7GXzgn+bXsT
         2prqk1aOgtas4azQAjKbIxBGGQDghgXoLnvTkY3Dj/blpBN3ndlC2S6J9AIhyE+iEJ40
         SF4Mo1w9QOaTuOelK1f/ibUw+xoo/U+RSIVflbkQ8LMH7zsRm96/nA6wOooyGQ+B0HFZ
         9JoS/0Dx3pF3S8eONkiZQi3qq8NxI3F2PMuMTme1615CKkvBMbtrfSXvccl4jQjfDxq3
         F1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4YqrEj5VRWDiRt2Idp5zIwlFmoyUZaY/uAgM+dXmFH4=;
        b=H3Ri1NzvZjJTauw3DK/+IIDa6/9AiHIlnHrKG3079gSkziCvmgJeZNuu5iYhCeWnrG
         j8x2UjjjbuYB6z3KldpFKbIaaWwBNJ1rVrzpbUt2dJ+7/pWCZpZK9xPdilktltpj9Srv
         MDWm5/sYwaBSwELGqSquzzccKWVTv6njqSbGvDcAKdS2xZLSn8nk4NgpZInva76XaTMD
         I2PT+oWMmB2yAqtnx6nw6H+0Ls7akzAyGWy6WmQ4Sl0fpbknsml0mi2cHfAwA5WgklMA
         h6QV/hE1YQX1VpqEg4HAG8L0ErL5EaSlxS5zWyRx9934L4JPvTAYTxOum3vs/oF2L03i
         rgaA==
X-Gm-Message-State: AOAM5330Pgm1SSLH4rh1h4o2iYj4l/T1RzS+iRZEm4qfV8O/6aneaR4s
        cETk5KWqwjLxE7h0U8DvJP4hTOXFvqjA8MQerPgPdQ==
X-Google-Smtp-Source: ABdhPJydVgPplLHFHTfNVor8TInwj6C9QLDzkQ0ei87thQcdZTMMUOLqUxGlwl88rzbm1Ys5ysIAI5nydZVKLK/rm7k=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr8656916ybk.230.1597351594148;
 Thu, 13 Aug 2020 13:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200813203930.978141-1-andriin@fb.com> <20200813203930.978141-5-andriin@fb.com>
In-Reply-To: <20200813203930.978141-5-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Aug 2020 13:46:23 -0700
Message-ID: <CAEf4BzZMDf2gcjMESy-umCr80N5BDMtrtCSz2EisEPz8qf79kw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 4/9] libbpf: handle BTF pointer sizes more carefully
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 1:39 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> With libbpf and BTF it is pretty common to have libbpf built for one
> architecture, while BTF information was generated for a different architecture
> (typically, but not always, BPF). In such case, the size of a pointer might
> differ betweem architectures. libbpf previously was always making an
> assumption that pointer size for BTF is the same as native architecture
> pointer size, but that breaks for cases where libbpf is built as 32-bit
> library, while BTF is for 64-bit architecture.
>
> To solve this, add heuristic to determine pointer size by searching for `long`
> or `unsigned long` integer type and using its size as a pointer size. Also,
> allow to override the pointer size with a new API btf__set_pointer_size(), for
> cases where application knows which pointer size should be used. User
> application can check what libbpf "guessed" by looking at the result of
> btf__pointer_size(). If it's not 0, then libbpf successfully determined a
> pointer size, otherwise native arch pointer size will be used.
>
> For cases where BTF is parsed from ELF file, use ELF's class (32-bit or
> 64-bit) to determine pointer size.
>
> Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/btf.c      | 83 ++++++++++++++++++++++++++++++++++++++--
>  tools/lib/bpf/btf.h      |  2 +
>  tools/lib/bpf/btf_dump.c |  4 +-
>  tools/lib/bpf/libbpf.map |  2 +
>  4 files changed, 87 insertions(+), 4 deletions(-)
>

[...]

>
> +       switch (gelf_getclass(elf)) {
> +       case ELFCLASS32:
> +               btf__set_pointer_size(btf, 4);
> +               break;
> +       case ELFCLASS64:
> +               btf__set_pointer_size(btf, 8);
> +               break;
> +       default:
> +               pr_warn("failed to get ELF class (bitness) for %s\n", path);
> +               goto done;

This is not right, it should have been a break, not sure what
happened. I'll send v3, maybe the cover letter also won't go missing
this time.

> +       }
> +
>         if (btf_ext && btf_ext_data) {
>                 *btf_ext = btf_ext__new(btf_ext_data->d_buf,
>                                         btf_ext_data->d_size);

[...]

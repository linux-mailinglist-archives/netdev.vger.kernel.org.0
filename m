Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0EA41F7C0
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356068AbhJAWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356037AbhJAWtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EAF761AEF;
        Fri,  1 Oct 2021 22:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633128488;
        bh=mBaX3QTNk2scTBHegmVBefwtlIjH/j0Hhlrs71kf7dY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ds4inlZhKpYgcXA4xCT+Xp7pKMFM8OMXzdt2ZJNMz4OFpFOBz2rrSAf/KZ6jDujPM
         4nbubkJfxuCHT/1fOCaEGerzu7PokoMnc20FxT5yByTcijbfcdwDZlaHWoDt0JNngr
         glniZBrErN8pQoM/b0gydlIA4LBEJoSs2/YaTCXe+S1YuZUoaoFc+ND7ZOoVf6YuYJ
         ttR65qB6XJXraHf5kzvacS4UMahJmSOxTBKWwhBq0n4677eTl+vsnBpPDYIsajq8UY
         5XcC8KXTD/KzimCv840+IO3kqqvy+e8nGNG4w6g+MDJHDw25gE73Ijj3eujtiWbjau
         qNkSwp+iMREFw==
Received: by mail-lf1-f49.google.com with SMTP id u18so44474127lfd.12;
        Fri, 01 Oct 2021 15:48:08 -0700 (PDT)
X-Gm-Message-State: AOAM530KXhE1FX4T+OKYBJPB5EM94oWkS2NkBqQcvvGkB3orJiUMS1MY
        5XbazL9Y5lBGCnf0d9+M+IxGwvsS9gvSsG4P/w4=
X-Google-Smtp-Source: ABdhPJxI0JJOMcsNFwNexF/7q2fdRkuG2eu2Rmm33RtoqbciQCV+vQR/0FY+xKZ99ewyq6UhHeJaCRawW9YTKDVpuWk=
X-Received: by 2002:ac2:5582:: with SMTP id v2mr606121lfg.143.1633128486649;
 Fri, 01 Oct 2021 15:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211001215858.1132715-1-joannekoong@fb.com> <20211001215858.1132715-2-joannekoong@fb.com>
In-Reply-To: <20211001215858.1132715-2-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 1 Oct 2021 15:47:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4KVXE0UYVee2F7OR_A6C8pNOvPbXM1wDPFNwiUDeOMGg@mail.gmail.com>
Message-ID: <CAPhsuW4KVXE0UYVee2F7OR_A6C8pNOvPbXM1wDPFNwiUDeOMGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/3] bpf/xdp: Add bpf_load_hdr_opt support for xdp
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 3:04 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> This patch enables XDP programs to use the bpf_load_hdr_opt helper
> function to load header options.
>
> The upper 16 bits of "flags" is used to denote the offset to the tcp
> header. No other flags are, at this time, used by XDP programs.
> In the future, more flags can be included to support other types of
> header options.
>
> Much of the logic for loading header options can be shared between
> sockops and xdp programs. In net/core/filter.c, this common shared
> logic is refactored into a separate function both sockops and xdp
> use.
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>

Looks good over all.

Acked-by: Song Liu <songliubraving@fb.com>

Just a nitpick below.

> ---
>  include/uapi/linux/bpf.h       | 26 ++++++----
>  net/core/filter.c              | 88 ++++++++++++++++++++++++++--------
>  tools/include/uapi/linux/bpf.h | 26 ++++++----
>  3 files changed, 103 insertions(+), 37 deletions(-)
>

[...]

> +
> +BPF_CALL_4(bpf_xdp_load_hdr_opt, struct xdp_buff *, xdp,
> +          void *, search_res, u32, len, u64, flags)
> +{
> +       const void *op, *opend;
> +       struct tcphdr *th;
> +
> +       /* The upper 16 bits of flags contain the offset to the tcp header.
> +        * No other bits should be set.
> +        */
> +       if (flags & 0xffffffffffff)

Maybe use (1ULL << BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT) - 1

> +               return -EINVAL;
> +
> +       th = xdp->data + (flags >> BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT);
> +       op = (void *)th + sizeof(struct tcphdr);
> +       if (unlikely(op > xdp->data_end))
> +               return -EINVAL;

[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAE731CB97
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBPOJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBPOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:09:43 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEAEC061756;
        Tue, 16 Feb 2021 06:09:03 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id a9so3417749plh.8;
        Tue, 16 Feb 2021 06:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ur2GGfNGty4D5sfBPMgdwf/iq0sjY8YMRufZGls/mL4=;
        b=O9/Un4wqLI5QVCgODlBo+ANgEJ8254C73PyLhrYptt1XTuXiG8PTXnqGrbDFIvHUj6
         q4E4t+R8gCRQkdcTlV3mZT6NAVTd7N/fEloHVVrPCGp/iW0dsO9Ouh+QneMTzORgHiwn
         Xa0hhIaTTCJwEexnwPcKpgF3pVCI22hIrPxebqfjTSZyw+xGQJ9NvqOcr5ykveho3JUJ
         pAfM/U61oNgOrLGH2raHYVrTfxTwzHenZUjA1uB96t1jA5u7zCH98RwBFnwHns+9/puw
         nY0LnRz1+rItxY909GZBkI7ODnHbIHN7vAY2LcoQBQz7uPIOKI3UDmkdqK9CulOtpYSJ
         QDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ur2GGfNGty4D5sfBPMgdwf/iq0sjY8YMRufZGls/mL4=;
        b=FFJ/UoTmW0kPsLKAnPx7l1g76X5PaIuzda1pTaEmZGjUQiU5NFCrMjgsxEt3q2HEWm
         YtqD/IPHWHC4mu87z6nag2g+ss/glYOslpSsIVmF2OCpw2s8gXBWC10f+s7zghziNQ7y
         nvVR43TcyxfT/GVeZTA2DBEiIbNTHLQeVbF72IwRGzeR6GpC8l+j8YgIToyZwMhNIxzJ
         zzCRgsMZvf0p/YTIiV/yLzssVEQJSZeiu/RcbdQJr2m0ScklCT+w6el4gQPj9ePhWlS1
         3ZSc2DxpDrlM2jGZdAtYHmlCF89+l49LP5sImXPYJweuIl9HsyRoxKUgXQbgh0vVXb6q
         AyVw==
X-Gm-Message-State: AOAM530pS7BlX9QCuUW91eL2Sd/Cn2uOqF+W7xPO2bAKpgv4UJOnLCCc
        dD7nX3RpZiSRPMuqC8GYQ3ljFmo4uWfJTr5d2YY=
X-Google-Smtp-Source: ABdhPJxwQgKzCV6u0vMxVuPH9XLB4h56OPkZBENnng0yconZsNhbf/CgQoo4zNy+/IUWGGEOsEyIeoVXpCF8VPgsf7s=
X-Received: by 2002:a17:902:aa4b:b029:e2:bb4b:a63 with SMTP id
 c11-20020a170902aa4bb02900e2bb4b0a63mr20060894plr.7.1613484542811; Tue, 16
 Feb 2021 06:09:02 -0800 (PST)
MIME-Version: 1.0
References: <20210216113740.62041-1-alobakin@pm.me> <20210216113740.62041-6-alobakin@pm.me>
In-Reply-To: <20210216113740.62041-6-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 16 Feb 2021 15:08:51 +0100
Message-ID: <CAJ8uoz2LQvhfar+wqgWBRq9sh_EGvx-VeEXA03=_-G+HNJBJVw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/6] xsk: respect device's headroom and
 tailroom on generic xmit path
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 12:44 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> xsk_generic_xmit() allocates a new skb and then queues it for
> xmitting. The size of new skb's headroom is desc->len, so it comes
> to the driver/device with no reserved headroom and/or tailroom.
> Lots of drivers need some headroom (and sometimes tailroom) to
> prepend (and/or append) some headers or data, e.g. CPU tags,
> device-specific headers/descriptors (LSO, TLS etc.), and if case
> of no available space skb_cow_head() will reallocate the skb.
> Reallocations are unwanted on fast-path, especially when it comes
> to XDP, so generic XSK xmit should reserve the spaces declared in
> dev->needed_headroom and dev->needed tailroom to avoid them.
>
> Note on max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom)):
>
> Usually, output functions reserve LL_RESERVED_SPACE(dev), which
> consists of dev->hard_header_len + dev->needed_headroom, aligned
> by 16.
> However, on XSK xmit hard header is already here in the chunk, so
> hard_header_len is not needed. But it'd still be better to align
> data up to cacheline, while reserving no less than driver requests
> for headroom. NET_SKB_PAD here is to double-insure there will be
> no reallocations even when the driver advertises no needed_headroom,
> but in fact need it (not so rare case).
>
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> ---
>  net/xdp/xsk.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 4faabd1ecfd1..143979ea4165 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -454,12 +454,16 @@ static int xsk_generic_xmit(struct sock *sk)
>         struct sk_buff *skb;
>         unsigned long flags;
>         int err = 0;
> +       u32 hr, tr;
>
>         mutex_lock(&xs->mutex);
>
>         if (xs->queue_id >= xs->dev->real_num_tx_queues)
>                 goto out;
>
> +       hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
> +       tr = xs->dev->needed_tailroom;
> +
>         while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
>                 char *buffer;
>                 u64 addr;
> @@ -471,11 +475,13 @@ static int xsk_generic_xmit(struct sock *sk)
>                 }
>
>                 len = desc.len;
> -               skb = sock_alloc_send_skb(sk, len, 1, &err);
> +               skb = sock_alloc_send_skb(sk, hr + len + tr, 1, &err);
>                 if (unlikely(!skb))
>                         goto out;
>
> +               skb_reserve(skb, hr);
>                 skb_put(skb, len);
> +
>                 addr = desc.addr;
>                 buffer = xsk_buff_raw_get_data(xs->pool, addr);
>                 err = skb_store_bits(skb, 0, buffer, len);
> --
> 2.30.1
>
>

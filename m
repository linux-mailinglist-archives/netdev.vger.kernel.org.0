Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162373B69FD
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhF1VIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbhF1VIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 17:08:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E620FC061574;
        Mon, 28 Jun 2021 14:05:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l24so2984926ejq.11;
        Mon, 28 Jun 2021 14:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSDrQI55PB7nEOHMqwZIcytnnCkvMaB4GbC+4XlI3S0=;
        b=HJ9yta653GJGmMG+RUIh44BNmEtzZKzXrGVSL7vt+vfXMaMloURcGruXv1Hu+JoVlo
         ek6fWVq2hCYQbK+u1vghIpb6zlGdOfBQXhr7v3YfRORHEpZkeXX3PsLFym/s67L/fQxP
         7Rb1aB4N72utred8t1W+65m6jszkzkHBRc80SwSVbwIGdR3BYHQpaimN9pV/y7769ZOu
         bB71Fxhg5cr0TnLmdvhyQU7y6x8csiw921sb/jPzkaLOeUMXpi5qUvGPpHzcjfZwGDHB
         gAXDw5B+wu2ekDZRNZH6ZjtF6yHlbkOxO0A7LkTwPAPzEH39rJu12R/NJEyhseJRYk1j
         N9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSDrQI55PB7nEOHMqwZIcytnnCkvMaB4GbC+4XlI3S0=;
        b=mV7oxV8KwukQM/TbC1bEqRbBgSDbIsWacys73PSZuGQmqOXTcjYfhUxVtjeCbbNjEz
         oSAUkY/NobIjgQLvtW30bBypwwOsl+zMamdU/1ZKN8I/LUVLWnRGgjFwVo9bPSlXQt9L
         yiIzXe2mrK5ly1ogF94WYnK/hSxfXkQLaqqSj6yWIz05GygWm+armb/g4GsUXpZSvIBs
         tAqqeZPBaUQ9ZcfwnTeAn1tspHx+opjzf5P0PPX8fhEjuAq4qmm5hZqVuBiVZsooxNcp
         cHS4UEbVZovNgmxaHcmZ67mkeZMIxseudZL+Wvt4NAr4WGCyJp1XhcswgwaYk02P5x2R
         YmKw==
X-Gm-Message-State: AOAM5301IG/h35xrouKHfrZwlYuZgCcCP9lP2XCB7yEWO2tsZjFM/uuW
        HwCgik1roaK4Fh3kh9QnimmZk6GMrFczYmJRF4g=
X-Google-Smtp-Source: ABdhPJx/Q1Ch1QWdDp/MHfuw1NEtPmcLdB7+4nJIBdUcPfDaqoA0MjN35w5gCpL9P4dfqP3GEiMXku1vM2RGKdWd9ho=
X-Received: by 2002:a17:907:3e1b:: with SMTP id hp27mr25777856ejc.470.1624914353373;
 Mon, 28 Jun 2021 14:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <7f61f8f7d38cf819383db739c14c874ccd3b53e2.1623674025.git.lorenzo@kernel.org>
In-Reply-To: <7f61f8f7d38cf819383db739c14c874ccd3b53e2.1623674025.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Jun 2021 14:05:42 -0700
Message-ID: <CAKgT0Ue=74BPWFDFYtWEA9DnNj35PgigDZAwCc5N6X=QpKz4GA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 07/14] net: xdp: add multi-buff support to xdp_build_skb_from_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 5:51 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce xdp multi-buff support to
> __xdp_build_skb_from_frame/xdp_build_skb_from_frame
> utility routines.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/core/xdp.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index f61c63115c95..71bedf6049a1 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -582,9 +582,15 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>                                            struct sk_buff *skb,
>                                            struct net_device *dev)
>  {
> +       struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
>         unsigned int headroom, frame_size;
> +       int i, num_frags = 0;
>         void *hard_start;
>
> +       /* xdp multi-buff frame */
> +       if (unlikely(xdp_frame_is_mb(xdpf)))
> +               num_frags = sinfo->nr_frags;
> +
>         /* Part of headroom was reserved to xdpf */
>         headroom = sizeof(*xdpf) + xdpf->headroom;
>
> @@ -603,6 +609,13 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>         if (xdpf->metasize)
>                 skb_metadata_set(skb, xdpf->metasize);
>
> +       for (i = 0; i < num_frags; i++)
> +               skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> +                               skb_frag_page(&sinfo->frags[i]),
> +                               skb_frag_off(&sinfo->frags[i]),
> +                               skb_frag_size(&sinfo->frags[i]),
> +                               xdpf->frame_sz);
> +

So this is assuming the header frame and all of the frags are using
the same size. Rather than reading the frags out and then writing them
back, why not just directly rewrite the nr_frags, add the total size
to skb->len and skb->data_len, and then update the truesize?

Actually, I think you might need to store the truesize somewhere in
addition to the data_len that you were storing in the shared info.

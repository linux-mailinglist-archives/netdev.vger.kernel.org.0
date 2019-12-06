Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6FC1157D0
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfLFTcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:32:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51284 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfLFTcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:32:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id g206so8999002wme.1;
        Fri, 06 Dec 2019 11:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMdeye52yCnU5ERIaKF+U114ssIb2T9i0IRHv/eVpQo=;
        b=IisY13CS2U4O3SjK3dXQ3yJ6vOvBlrkbottbpNnKr5pwlA42ZNWLxzBsFkQfs4OxAZ
         rvqSua4fQRUFLQR1P8bfF0synE3mcty1y5PJR9llDj+n8CHqWLMGI9uSiIjZ4z6pjMIe
         tKoHLNU304FX+P7LfFf3qhYr4vdAAKE9ys5h1nMQT2GY5cRcAxM7yjZiLt8RGLvrNMgq
         SYdaihKCPdmBclwYgaOea49O24WSnfOL2w//lytDZjWC7pl1jWpmUGCeQTodJjVD5tG/
         4IG1nj7qnlaNZsMILwqE6hyh3CiMYJcAaVCupdItJs8osL0GkBQ4tKmya0n8z3lXX0Bq
         GdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMdeye52yCnU5ERIaKF+U114ssIb2T9i0IRHv/eVpQo=;
        b=E+V5mNu6OI8U0KfLgvH5H7jP/bSVGFYtPpYW45YxibRx+/BOHKGfYr6py0OKAf1+XV
         bHdjr1lnu9Dzlh3ia7osxnlCz84FY5NXUZ5/gdG46kI/+EQkcDmoZKD3ci4aGLJBsUY9
         mj+lc12zB8FPi9W2NMkTR5jNNKRjY/dKl6g+AUIkyAQOWyKxRjgfq7IaBAi/hIR2qG6s
         1awkkZCdGm7927Re5Z/Oo4WSJOOawrwyVJuKneGgjKrNuI1nRqsWZdxCxO7jzM/NecuH
         6FIknrfw3jLxBG7OaxgNXlGtmjtKakMBIei564g9BA4O030WGYJGwchQb6meUsBiMMFQ
         BdSw==
X-Gm-Message-State: APjAAAU4U0DsET9TT/RLzL8JrpsX00e7GqypdnlWa1q00epgk/vWs/QI
        G5XNw8EJ0tolOgG5AJ0RHUq4lQPiPltTJM11Zn8=
X-Google-Smtp-Source: APXvYqzv+VXCGeJecYsDhUUuSMrK6oChGu8FCsguroHIRKZJZj5tQjLqnRtXu/0Jqjr3mg53G53OpGDUJnDg9cpSERg=
X-Received: by 2002:a1c:c90e:: with SMTP id f14mr12006852wmb.47.1575660760432;
 Fri, 06 Dec 2019 11:32:40 -0800 (PST)
MIME-Version: 1.0
References: <20191205100235.14195-1-alobakin@dlink.ru>
In-Reply-To: <20191205100235.14195-1-alobakin@dlink.ru>
From:   Rainer Sickinger <rainersickinger.official@gmail.com>
Date:   Fri, 6 Dec 2019 20:32:29 +0100
Message-ID: <CAD9cdQ68Ye8wuO5N_PZG04htFeqFPCMuNgYWJVRdnHw47fnqqA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That is a really great improvement!

Am Do., 5. Dez. 2019 um 11:04 Uhr schrieb Alexander Lobakin <alobakin@dlink.ru>:
>
> Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
> ability to override protocol and network offset during flow dissection
> for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
> in order to fix skb hashing for RPS on Rx path.
>
> However, skb_hash() and added part of code can be invoked not only on
> Rx, but also on Tx path if we have a multi-queued device and:
>  - kernel is running on UP system or
>  - XPS is not configured.
>
> The call stack in this two cases will be like: dev_queue_xmit() ->
> __dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
> skb_tx_hash() -> skb_get_hash().
>
> The problem is that skbs queued for Tx have both network offset and
> correct protocol already set up even after inserting a CPU tag by DSA
> tagger, so calling tag_ops->flow_dissect() on this path actually only
> breaks flow dissection and hashing.
>
> This can be observed by adding debug prints just before and right after
> tag_ops->flow_dissect() call to the related block of code:
>
> Before the patch:
>
> Rx path (RPS):
>
> [   19.240001] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   19.244271] tag_ops->flow_dissect()
> [   19.247811] Rx: proto: 0x0800, nhoff: 8      /* ETH_P_IP */
>
> [   19.215435] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   19.219746] tag_ops->flow_dissect()
> [   19.223241] Rx: proto: 0x0806, nhoff: 8      /* ETH_P_ARP */
>
> [   18.654057] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   18.658332] tag_ops->flow_dissect()
> [   18.661826] Rx: proto: 0x8100, nhoff: 8      /* ETH_P_8021Q */
>
> Tx path (UP system):
>
> [   18.759560] Tx: proto: 0x0800, nhoff: 26     /* ETH_P_IP */
> [   18.763933] tag_ops->flow_dissect()
> [   18.767485] Tx: proto: 0x920b, nhoff: 34     /* junk */
>
> [   22.800020] Tx: proto: 0x0806, nhoff: 26     /* ETH_P_ARP */
> [   22.804392] tag_ops->flow_dissect()
> [   22.807921] Tx: proto: 0x920b, nhoff: 34     /* junk */
>
> [   16.898342] Tx: proto: 0x86dd, nhoff: 26     /* ETH_P_IPV6 */
> [   16.902705] tag_ops->flow_dissect()
> [   16.906227] Tx: proto: 0x920b, nhoff: 34     /* junk */
>
> After:
>
> Rx path (RPS):
>
> [   16.520993] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   16.525260] tag_ops->flow_dissect()
> [   16.528808] Rx: proto: 0x0800, nhoff: 8      /* ETH_P_IP */
>
> [   15.484807] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   15.490417] tag_ops->flow_dissect()
> [   15.495223] Rx: proto: 0x0806, nhoff: 8      /* ETH_P_ARP */
>
> [   17.134621] Rx: proto: 0x00f8, nhoff: 0      /* ETH_P_XDSA */
> [   17.138895] tag_ops->flow_dissect()
> [   17.142388] Rx: proto: 0x8100, nhoff: 8      /* ETH_P_8021Q */
>
> Tx path (UP system):
>
> [   15.499558] Tx: proto: 0x0800, nhoff: 26     /* ETH_P_IP */
>
> [   20.664689] Tx: proto: 0x0806, nhoff: 26     /* ETH_P_ARP */
>
> [   18.565782] Tx: proto: 0x86dd, nhoff: 26     /* ETH_P_IPV6 */
>
> In order to fix that we can add the check 'proto == htons(ETH_P_XDSA)'
> to prevent code from calling tag_ops->flow_dissect() on Tx.
> I also decided to initialize 'offset' variable so tagger callbacks can
> now safely leave it untouched without provoking a chaos.
>
> Fixes: 43e665287f93 ("net-next: dsa: fix flow dissection")
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> ---
>  net/core/flow_dissector.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 69395b804709..d524a693e00f 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -969,9 +969,10 @@ bool __skb_flow_dissect(const struct net *net,
>                 nhoff = skb_network_offset(skb);
>                 hlen = skb_headlen(skb);
>  #if IS_ENABLED(CONFIG_NET_DSA)
> -               if (unlikely(skb->dev && netdev_uses_dsa(skb->dev))) {
> +               if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
> +                            proto == htons(ETH_P_XDSA))) {
>                         const struct dsa_device_ops *ops;
> -                       int offset;
> +                       int offset = 0;
>
>                         ops = skb->dev->dsa_ptr->tag_ops;
>                         if (ops->flow_dissect &&
> --
> 2.24.0
>

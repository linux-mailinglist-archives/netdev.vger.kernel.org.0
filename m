Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BBB1E0673
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 07:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgEYFlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 01:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgEYFlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 01:41:39 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E615C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:41:39 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so7796244ybn.11
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SaxzSHKZP4NlOXFPgocTcAXqz7tuNOGiL801SvZLmxE=;
        b=agfAFbs+vxfpjPMEvt0c+AJwJ7kXEV2t1pPfy5wE/rLUBxJ7y+CeHg6wqqYoqh4+Rv
         EXCX5ATVYk7zvuMe4qvKuTtI/bj/3b8GgwPHQ6d/NX4ATOmT8MH4z+1ekAG4ObZD0aLp
         cDSwUnlwMcG/J1EsukvDuFihzVXXnTIFPE1uNtZcz5DXHv3ohzS2VC85fssByDzLjxhR
         KEz7kLRP32G8qh7hdOgRm3pDMylcbm1dbolKQIli9cS3RZn1uAo+YmGwVNQiieMd++os
         pOy6yx0CTFj1dPLgErdezRkad6bdkJbVYzscb+MEHkJdv2a65RebvDXxlBoC3GA22F/t
         nc6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SaxzSHKZP4NlOXFPgocTcAXqz7tuNOGiL801SvZLmxE=;
        b=poeVwBnnaGKT8v4QBsLqFDMbNjtr9qvt+O76F+s9yGsbJq0Hcs3qh+8Ufwn58udNZC
         X89GZcxXPMvvl0wCjj3Ed2gbeqGjftkUHMw0l5lnlHgmiS76a44E99K/hpUVxPz4CkPt
         wOZ5Gjrozrg4+H39pB7SpO2nwpl0vJ5h07GTQ+gz61AU3w4CazymP3syayY0Y7sFYlpX
         a45SJLlPc7lc5RLpe9MBo9Y07PdxkUbJAwJlkK/uIiliBEGJo08CL2tP058+Qw8llvJq
         pHk90ALH9YHLPP4tHWoHTU9/k965FW5kcUE1v4wm5Lu9wZwQ7JHVpe4NLjol1A/oAE4m
         dBiw==
X-Gm-Message-State: AOAM530I0mcd3HzjnatjtG15qIDLLcki4enkojhGEaUxQaZ/8vQZOxbd
        DgFo/z3oM6rpWRXTw1lO6odoengjRpChppwM8ppJFvpY
X-Google-Smtp-Source: ABdhPJyIs7mjV9+olFdH3TedbDM4r6UB2whNC6KWMuAOn1SPquX3tas8d5m8dJejEifwPy1ayzrALfWqSyEBsrNiq4g=
X-Received: by 2002:a25:f309:: with SMTP id c9mr38243203ybs.364.1590385297846;
 Sun, 24 May 2020 22:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
In-Reply-To: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 24 May 2020 22:41:26 -0700
Message-ID: <CANn89iLdfOzRuhC--MALZuTDSoU6ncX7Xu_0iJnjZs1-9_gwmQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Avoid spurious rx_dropped increases with
 tap and rx_handler
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 10:02 PM Benjamin Poirier
<bpoirier@cumulusnetworks.com> wrote:
>
> Consider an skb which doesn't match a ptype_base/ptype_specific handler. If
> this skb is delivered to a ptype_all handler, it does not count as a drop.
> However, if the skb is also processed by an rx_handler which returns
> RX_HANDLER_PASS, the frame is now counted as a drop because pt_prev was
> reset. An example of this situation is an LLDP frame received on a bridge
> port while lldpd is listening on a packet socket with ETH_P_ALL (ex. by
> specifying `lldpd -c`).
>
> Fix by adding an extra condition variable to record if the skb was
> delivered to a packet tap before running an rx_handler.
>
> The situation is similar for RX_HANDLER_EXACT frames so their accounting is
> also changed. OTOH, the behavior is unchanged for RX_HANDLER_ANOTHER frames
> - they are accounted according to what happens with the new skb->dev.
>
> Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")

I disagree.

> Message-Id: <20200522011420.263574-1-bpoirier@cumulusnetworks.com>
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
> ---
>  net/core/dev.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index ae37586f6ee8..07957a0f57e6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5061,11 +5061,11 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
>  static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>                                     struct packet_type **ppt_prev)
>  {
> +       bool deliver_exact = false, rx_tapped = false;
>         struct packet_type *ptype, *pt_prev;
>         rx_handler_func_t *rx_handler;
>         struct sk_buff *skb = *pskb;
>         struct net_device *orig_dev;
> -       bool deliver_exact = false;
>         int ret = NET_RX_DROP;
>         __be16 type;
>
> @@ -5158,12 +5158,14 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>                 if (pt_prev) {
>                         ret = deliver_skb(skb, pt_prev, orig_dev);
>                         pt_prev = NULL;
> +                       rx_tapped = true;
>                 }
>                 switch (rx_handler(&skb)) {
>                 case RX_HANDLER_CONSUMED:
>                         ret = NET_RX_SUCCESS;
>                         goto out;
>                 case RX_HANDLER_ANOTHER:
> +                       rx_tapped = false;
>                         goto another_round;
>                 case RX_HANDLER_EXACT:
>                         deliver_exact = true;
> @@ -5234,11 +5236,13 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>                         goto drop;
>                 *ppt_prev = pt_prev;
>         } else {
> +               if (!rx_tapped) {
>  drop:
> -               if (!deliver_exact)
> -                       atomic_long_inc(&skb->dev->rx_dropped);
> -               else
> -                       atomic_long_inc(&skb->dev->rx_nohandler);
> +                       if (!deliver_exact)
> +                               atomic_long_inc(&skb->dev->rx_dropped);
> +                       else
> +                               atomic_long_inc(&skb->dev->rx_nohandler);
> +               }

This does not make sense to me.

Here we call kfree_skb() meaning this packet is _dropped_.
I understand it does not please some people, because they do not
always understand the meaning of this counter, but it is a mere fact.

Fact that a packet capture made a clone of this packet should not
matter, tcpdump should not hide that a packet is _dropped_.

>                 kfree_skb(skb);
>                 /* Jamal, now you will not able to escape explaining
>                  * me how you were going to use this. :-)


Can we please not add code in the fast path ?

Why are LLDP packets so special, why are they not consumed ?

I would suggest fixing the layer that handles LLDP packets so that we
do not have to workaround this issue in a critical fast path.

Thanks.

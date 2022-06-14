Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1154B222
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbiFNNQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 09:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244522AbiFNNQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 09:16:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD393701C;
        Tue, 14 Jun 2022 06:16:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gd1so8465489pjb.2;
        Tue, 14 Jun 2022 06:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mq0+ED07IK4ulYrQkEH8DfbENVLVGZC0c/jxfIXlP9k=;
        b=RRbD1IscvQESvnufjfYnCqshdgUeMeymkZ92ACgpyhWtCqgL9+BuKAwHZV96sX3Nlh
         raTIB6pYc4bQvEfp2NHKjVrhU6baQsGOqmVPPCj0Nw8odVkfg+Qf6KNochwkpGc43KIA
         YiHAIIe4VBjxm4uFeAKkE+qtTlyCIyQnQdOsX18ep4BpSyVEwwnYg62O3yRFGazhppVF
         Yrmt/jkz15m0HeLRozs7ZRpk5UmVQOGIW1d9VlfBsmElG5I5N8FaQMVt6MVGCgJlv2i1
         4F1fhEs4tTT7prrwUyhdyO2c0LUDoIbHLqXcgmbnZISFj1SPY4zoIWM0kpZSF3MeTcTa
         yNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mq0+ED07IK4ulYrQkEH8DfbENVLVGZC0c/jxfIXlP9k=;
        b=wnXS/ph+DBzqJa2eWGDRBXwrZ4wrfN6ACqO4UNQ74Ye0lLJkbsRiPmVOf3yb3tSWII
         qC88Y0T6gt5h1lzKpZHQqH9g1N/wpnoGEFCYzhTAExatquNfNWgVSgo0/n9j/NNADsKJ
         UO8oNSH9V8i5N3Uk7IN+1hSKmfQbNNp+wPpYXcdBQ1RRrm6snGZkHpmGAVuiuA7Trrr/
         PnSdV+jII66KHOOa2Kqyf2E9YPQ6WOJ8wG/vdGZvYy7douLuwJ1yLg5LXVuURfXJMPPz
         TmlBvxYaEayFQ8QLk4rudYRAQAGF5ii5qTHtguHLp6/fUwPPmp9AAeGQHxuH+jqdA93i
         BceQ==
X-Gm-Message-State: AJIora/gHUMVUQrjm3lt3HLRY0UHdNwBsf1CuWAQG/fhl/3jaSihwpKI
        XhmL6isLTneuGrdB7yVyTzF8mRUOFXpT9TugJdU=
X-Google-Smtp-Source: AGRyM1thdHKwV0sozTLz4ZuVER5IhlAa3z/NvSF4uU2MdOaRrByWhJXZXwYcGBhabgFvrzZtg1Fb+R0aJhwEV4IM9IE=
X-Received: by 2002:a17:90a:4897:b0:1c7:5fce:cbcd with SMTP id
 b23-20020a17090a489700b001c75fcecbcdmr4598271pjh.45.1655212572706; Tue, 14
 Jun 2022 06:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220614070746.8871-1-ciara.loftus@intel.com>
In-Reply-To: <20220614070746.8871-1-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 14 Jun 2022 15:16:01 +0200
Message-ID: <CAJ8uoz0VK9tcQEv1tieGbL34Xq4W=mEcms-mG5OQx1HmZwDw7A@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix generic transmit when completion queue
 reservation fails
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 9:09 AM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Two points of potential failure in the generic transmit function are:
> 1. completion queue (cq) reservation failure.
> 2. skb allocation failure
>
> Originally the cq reservation was performed first, followed by the skb
> allocation. Commit 675716400da6 ("xdp: fix possible cq entry leak")
> reversed the order because at the time there was no mechanism available to
> undo the cq reservation which could have led to possible cq entry leaks in
> the event of skb allocation failure. However if the skb allocation is
> performed first and the cq reservation then fails, the xsk skb destructor
> is called which blindly adds the skb address to the already full cq leading
> to undefined behavior.
>
> This commit restores the original order (cq reservation followed by skb
> allocation) and uses the xskq_prod_cancel helper to undo the cq reserve in
> event of skb allocation failure.

Thanks for fixing this Ciara.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 675716400da6 ("xdp: fix possible cq entry leak")
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  net/xdp/xsk.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 19ac872a6624..09002387987e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -538,12 +538,6 @@ static int xsk_generic_xmit(struct sock *sk)
>                         goto out;
>                 }
>
> -               skb = xsk_build_skb(xs, &desc);
> -               if (IS_ERR(skb)) {
> -                       err = PTR_ERR(skb);
> -                       goto out;
> -               }
> -
>                 /* This is the backpressure mechanism for the Tx path.
>                  * Reserve space in the completion queue and only proceed
>                  * if there is space in it. This avoids having to implement
> @@ -552,11 +546,19 @@ static int xsk_generic_xmit(struct sock *sk)
>                 spin_lock_irqsave(&xs->pool->cq_lock, flags);
>                 if (xskq_prod_reserve(xs->pool->cq)) {
>                         spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> -                       kfree_skb(skb);
>                         goto out;
>                 }
>                 spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>
> +               skb = xsk_build_skb(xs, &desc);
> +               if (IS_ERR(skb)) {
> +                       err = PTR_ERR(skb);
> +                       spin_lock_irqsave(&xs->pool->cq_lock, flags);
> +                       xskq_prod_cancel(xs->pool->cq);
> +                       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> +                       goto out;
> +               }
> +
>                 err = __dev_direct_xmit(skb, xs->queue_id);
>                 if  (err == NETDEV_TX_BUSY) {
>                         /* Tell user-space to retry the send */
> --
> 2.25.1
>

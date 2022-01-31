Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AFC4A41BF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359537AbiAaLFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:05:49 -0500
Received: from mail-yb1-f178.google.com ([209.85.219.178]:38507 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359071AbiAaLES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:04:18 -0500
Received: by mail-yb1-f178.google.com with SMTP id i62so39136141ybg.5;
        Mon, 31 Jan 2022 03:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53rlh+7XFoapmofgJ2m8CThJPRXRbfFhRqyaBk2y+/g=;
        b=VAYDJkguc9e3DZ6aGxEk+NuUp5xGgQ9ShP3X1+B3UPauiOq1lk/NeEdTwBkYi+TJYZ
         pXkEMdE66Cte+ZGIFVKd25WYasy3Qvo+lJ4m9/VO1wTnx29lowBJsec+oLLDPqiXpDQT
         uKdWeWs8RrQZqtTnpAIbVYFhULSGlD+7ewhd5ftMW9HBZ8oXmsx+Zlrbiasg/9sH1UpX
         PmpnO+p1XQ1UorqwCs+jwSngsQs07J/WAmtzAB0yLS3GgzIDKhe26wBTb8aQ/zGXGxVn
         Gx33XMPUK9EbWkXiiGlFrfMcDEajpN5fOQ3+Z4pOi0v/RRe9vwIJ0mjNaJw37Bbmq8T7
         Qcug==
X-Gm-Message-State: AOAM533r0d8YJmqHsIU/i0aZG2Sx0M1+ziCRwv0rTwCYsX6gMvJAb2YM
        mawjd9MZ1u45Rj+5KGCXJBnHGT4lXIJt84iaX/0=
X-Google-Smtp-Source: ABdhPJyiHUKvUmZG+u0eCM0vjpo1ftDYzQS7yLTfUWnkKtL4TBWnAWvJScPQrzEn9tyqpLhFOh3OE7FMM7c8sUh5mlI=
X-Received: by 2002:a5b:3cc:: with SMTP id t12mr7194072ybp.397.1643627057630;
 Mon, 31 Jan 2022 03:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-3-uli+renesas@fpond.eu>
In-Reply-To: <20220111162231.10390-3-uli+renesas@fpond.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 31 Jan 2022 20:04:06 +0900
Message-ID: <CAMZ6Rq+o6Di8wAQeAB4_yq+jNBoWvGTZ297+5jCc1=KSC9f0EA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, socketcan@hartkopp.net,
        geert@linux-m68k.org, kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Two more comments!

On Mon. 12 Jan 2022 at 01:22, Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
>
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
>
> Inspired by BSP patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 231 ++++++++++++++++++++----------
>  1 file changed, 153 insertions(+), 78 deletions(-)
>
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index ff9d0f5ae0dd..b1c9870d2a82 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c

...

> @@ -1488,22 +1543,29 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
>  static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
>  {
>         struct net_device_stats *stats = &priv->ndev->stats;
> +       struct rcar_canfd_global *gpriv = priv->gpriv;
>         struct canfd_frame *cf;
>         struct sk_buff *skb;
>         u32 sts = 0, id, dlc;
>         u32 ch = priv->channel;
>         u32 ridx = ch + RCANFD_RFFIFO_IDX;
>
> -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> +           gpriv->chip_id == RENESAS_R8A779A0) {
>                 id = rcar_canfd_read(priv->base, RCANFD_F_RFID(ridx));
>                 dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(ridx));
>
>                 sts = rcar_canfd_read(priv->base, RCANFD_F_RFFDSTS(ridx));
> -               if (sts & RCANFD_RFFDSTS_RFFDF)
> -                       skb = alloc_canfd_skb(priv->ndev, &cf);
> -               else
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +                       if (sts & RCANFD_RFFDSTS_RFFDF)
> +                               skb = alloc_canfd_skb(priv->ndev, &cf);
> +                       else
> +                               skb = alloc_can_skb(priv->ndev,
> +                                                   (struct can_frame **)&cf);
> +               } else {
>                         skb = alloc_can_skb(priv->ndev,
>                                             (struct can_frame **)&cf);

It seems to me that we can factorize the two alloc_can_skb() calls:

+               if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) &&
+                   sts & RCANFD_RFFDSTS_RFFDF)
+                       skb = alloc_canfd_skb(priv->ndev, &cf);
+               else
+                       skb = alloc_can_skb(priv->ndev, (struct
can_frame **)&cf);

> +               }
>         } else {
>                 id = rcar_canfd_read(priv->base, RCANFD_C_RFID(ridx));
>                 dlc = rcar_canfd_read(priv->base, RCANFD_C_RFPTR(ridx));
> @@ -1541,10 +1603,16 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
>                 }
>         } else {
>                 cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
> -               if (id & RCANFD_RFID_RFRTR)
> +               if (id & RCANFD_RFID_RFRTR) {
>                         cf->can_id |= CAN_RTR_FLAG;
> -               else
> -                       rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));
> +               } else {
> +                       if (gpriv->chip_id == RENESAS_R8A779A0)
> +                               rcar_canfd_get_data(priv, cf,
> +                                                   RCANFD_F_RFDF(ridx, 0));
> +                       else
> +                               rcar_canfd_get_data(priv, cf,
> +                                                   RCANFD_C_RFDF(ridx, 0));
> +               }

Put the else if on a single line and remove one level of indentation:

+               else if (gpriv->chip_id == RENESAS_R8A779A0)
+                       rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(ridx, 0));
+               else
+                       rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));

Also, a global comment, once you turn IS_V3U to an inline
function, you can use it in place of the many
"gpriv->chip_id == RENESAS_R8A779A0" checks.


Yours sincerely,
Vincent Mailhol

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB694A406F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbiAaKrL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 31 Jan 2022 05:47:11 -0500
Received: from mail-yb1-f177.google.com ([209.85.219.177]:46687 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiAaKrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:47:11 -0500
Received: by mail-yb1-f177.google.com with SMTP id p5so38917459ybd.13;
        Mon, 31 Jan 2022 02:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i9+eEHQW1ORSwlp0bAOJ+94PJqUvgHl4YYHHLLuPPBk=;
        b=UX0faKmEdn0qGkNR+7/BvyyfllQuG/vIrforcxrIbrTV0TvSb2XYpx+QRfIzt3XPpt
         Mfejf+zG5p7P73qpiLxQZJPuZyytxVsDjH+aSjdwuNN7UWCkbO01Zv9eWwY5ho/VCRBx
         VpP9gXulufDWa8J0W3u7XToSxwgcIDwqxsjjinyyQcGzqTlyliwg1uvysD3tQ2s7QbJn
         MgKZUKa3LUC120f7ELWMIIaESwmyxdYXOEHCrlYsJixrf3gVQtpOuFGwmzHJ98J8Fhr6
         8a3RCowoF+lY3u4dBXVwEg9P2jREAyfTKMsYa3ZOVrPuLq/PqrbswBhAqZEO4sjilVG/
         juNg==
X-Gm-Message-State: AOAM530TEMO+GYg6CevJjEm2swvK57rjhz3tFZ/X5d+0MgpuVWDmzeMr
        AmZEWhVwd4e8g8UvJ7XyNm5lX+c77aNHdW6Vhto=
X-Google-Smtp-Source: ABdhPJwr3q76P8Wfti+PcbPWAxAOzgkvpi6L/rCvvb7BxyRD3pdJEaRJvG3yzRBfCMsIBvgSMozjzNimjBYs+FPr9nc=
X-Received: by 2002:a05:6902:1503:: with SMTP id q3mr29062325ybu.305.1643626030600;
 Mon, 31 Jan 2022 02:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-3-uli+renesas@fpond.eu>
 <CAMZ6RqKr06KSMrKaB2h7iSDzOtgVKS+grPtf+bVrfpFaBai74w@mail.gmail.com> <1747432551.1166887.1643621068539@webmail.strato.com>
In-Reply-To: <1747432551.1166887.1643621068539@webmail.strato.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 31 Jan 2022 19:46:59 +0900
Message-ID: <CAMZ6RqLEO8JQV8f=xW1n9+UAgNMPp0z6W9vv6Kajh9Tvyu5vrA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, socketcan@hartkopp.net,
        geert@linux-m68k.org, kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 31 Jan 2022 at 18:24, Ulrich Hecht <uli@fpond.eu> wrote:
>
> Thanks for your review.
>
> > On 01/31/2022 3:08 AM Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:
> > > @@ -1435,13 +1488,15 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
> > >
> > >         dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
> > >
> > > -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> > > +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> > > +           gpriv->chip_id == RENESAS_R8A779A0) {
> > >                 rcar_canfd_write(priv->base,
> > >                                  RCANFD_F_CFID(ch, RCANFD_CFFIFO_IDX), id);
> > >                 rcar_canfd_write(priv->base,
> > >                                  RCANFD_F_CFPTR(ch, RCANFD_CFFIFO_IDX), dlc);
> > >
> > > -               if (can_is_canfd_skb(skb)) {
> > > +               if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) &&
> > > +                   can_is_canfd_skb(skb)) {
> >
> > Could you explain why this additional check is needed?
> > My understanding is that can_is_canfd_skb(skb) being true implies
> > that the CAN_CTRLMODE_FD flag is set.
>
> That might indeed be redundant.
>
> >
> > >                         /* CAN FD frame format */
> > >                         sts |= RCANFD_CFFDCSTS_CFFDF;
> > >                         if (cf->flags & CANFD_BRS)
> > > @@ -1488,22 +1543,29 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
> > >  static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
> > >  {
> > >         struct net_device_stats *stats = &priv->ndev->stats;
> > > +       struct rcar_canfd_global *gpriv = priv->gpriv;
> > >         struct canfd_frame *cf;
> > >         struct sk_buff *skb;
> > >         u32 sts = 0, id, dlc;
> > >         u32 ch = priv->channel;
> > >         u32 ridx = ch + RCANFD_RFFIFO_IDX;
> > >
> > > -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> > > +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> > > +           gpriv->chip_id == RENESAS_R8A779A0) {
> >
> > I guess that this is linked to the above comment. Does the
> > R8A779A0 chip support CAN-FD? If yes, why not simply use the
> > CAN_CTRLMODE_FD instead of adding this additional check?
>
> The non-V3U Gen3 CAN controllers have two different ways to be driven, depending on whether they are in classic or CAN-FD mode. The V3U controller is driven the CAN-FD way in both modes and thus needs to have this branch taken no matter what mode it is in.

Ack.
Makes sense. So actually, this isn’t related to the previous comments :)

In my previous message, I added two comments toward the macro. I
just want to double check that you have seen these because they
are missing from your reply.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A714A3F2C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiAaJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:25:04 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:42693 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiAaJZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643621069;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=P5UkqPQaALnwYfktsZDBMcqM8GZxyDaLQvtRKoVi4FY=;
    b=pi1N1yl0rl4rYvtRMtSBgcTn9Lo4MQhOgJWUtfQIIQg8k4OgEk4565G+rDQWOvDLTi
    Hy53C634aHZXmFRvyjvfUp/Ed2jkcWYqlXl09XeB+1MXcjBfWsnF68bKAwgEc1DEkoUK
    1AlbMXb1drSGegB4HCSP/e3ArPFzXgotB7fCgXqWWmrivfRT9eXX2LF5ExSVtRlo5oQU
    w3RQ5lyjsUVYcJXeC/rFQuw2jBHW6x4luXirxkAKs4oLntc77R5MYdAw7SESdDQQREBp
    v65bZ7QeQmR61kGxxU13RtXedtMFFpaTKWt6H7JKNbWqrBuFEsokzskPgGGKeuhUEiXG
    agng==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fGl/w2B/oo="
X-RZG-CLASS-ID: mo00
Received: from oxapp02-05.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.38.0 AUTH)
    with ESMTPSA id c3766fy0V9OSGmU
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Mon, 31 Jan 2022 10:24:28 +0100 (CET)
Date:   Mon, 31 Jan 2022 10:24:28 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, socketcan@hartkopp.net,
        geert@linux-m68k.org, kieran.bingham@ideasonboard.com
Message-ID: <1747432551.1166887.1643621068539@webmail.strato.com>
In-Reply-To: <CAMZ6RqKr06KSMrKaB2h7iSDzOtgVKS+grPtf+bVrfpFaBai74w@mail.gmail.com>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
 <20220111162231.10390-3-uli+renesas@fpond.eu>
 <CAMZ6RqKr06KSMrKaB2h7iSDzOtgVKS+grPtf+bVrfpFaBai74w@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev34
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review.

> On 01/31/2022 3:08 AM Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:
> > @@ -1435,13 +1488,15 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
> >
> >         dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
> >
> > -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> > +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> > +           gpriv->chip_id == RENESAS_R8A779A0) {
> >                 rcar_canfd_write(priv->base,
> >                                  RCANFD_F_CFID(ch, RCANFD_CFFIFO_IDX), id);
> >                 rcar_canfd_write(priv->base,
> >                                  RCANFD_F_CFPTR(ch, RCANFD_CFFIFO_IDX), dlc);
> >
> > -               if (can_is_canfd_skb(skb)) {
> > +               if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) &&
> > +                   can_is_canfd_skb(skb)) {
> 
> Could you explain why this additional check is needed?
> My understanding is that can_is_canfd_skb(skb) being true implies
> that the CAN_CTRLMODE_FD flag is set.

That might indeed be redundant.

> 
> >                         /* CAN FD frame format */
> >                         sts |= RCANFD_CFFDCSTS_CFFDF;
> >                         if (cf->flags & CANFD_BRS)
> > @@ -1488,22 +1543,29 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
> >  static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
> >  {
> >         struct net_device_stats *stats = &priv->ndev->stats;
> > +       struct rcar_canfd_global *gpriv = priv->gpriv;
> >         struct canfd_frame *cf;
> >         struct sk_buff *skb;
> >         u32 sts = 0, id, dlc;
> >         u32 ch = priv->channel;
> >         u32 ridx = ch + RCANFD_RFFIFO_IDX;
> >
> > -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> > +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> > +           gpriv->chip_id == RENESAS_R8A779A0) {
> 
> I guess that this is linked to the above comment. Does the
> R8A779A0 chip support CAN-FD? If yes, why not simply use the
> CAN_CTRLMODE_FD instead of adding this additional check?

The non-V3U Gen3 CAN controllers have two different ways to be driven, depending on whether they are in classic or CAN-FD mode. The V3U controller is driven the CAN-FD way in both modes and thus needs to have this branch taken no matter what mode it is in.

CU
Uli

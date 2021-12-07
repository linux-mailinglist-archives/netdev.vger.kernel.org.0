Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF62646BAC1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhLGMPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:15:45 -0500
Received: from mail-yb1-f169.google.com ([209.85.219.169]:38463 "EHLO
        mail-yb1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhLGMPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:15:44 -0500
Received: by mail-yb1-f169.google.com with SMTP id v64so40289845ybi.5;
        Tue, 07 Dec 2021 04:12:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWz9cT1wHHkhENXTpIc1LB3aIV6a/yhKqCUIe73/xDw=;
        b=QsvbDCgBSmV1iKgaIxRJVZZByRjhlUCvWEwFxb0F9NqQrojMzIEPtGUUaoADZu60Sp
         SPDRvkClZqJwPJ9hV+lfbMvZQhIpYd0XNrMtbm9LHRFerrIa1J3GhEg8y40aL8s8GVNp
         fPcWML9U9VhXN7JdGvP2N7xM1ZkdH8io76j6ZCuV9s0y5IyFMwCjpC65r3hRVcO1x2HY
         sXvF/LSL8tyaQwaUR0xYXYCtnQvetxFgLES8wCYchMwAor5Ar3W02LYI9TLVdnzQb2kR
         eDfscIZ5hBwjetIM1Q63nFroymFKXRiDVIJ5055tpdEosPMgQO1CsXSx9FmKI4j0NoCI
         ctpw==
X-Gm-Message-State: AOAM533RuCiB5TJ+LkH2WyP5W3T3iHmkPZ7/Yeqz9KHoZ7BH3B820QWU
        MlvUqMIOxsS/OJY6fZjvYlRxLw8JKlGD2tSlIAI=
X-Google-Smtp-Source: ABdhPJwOqYQBJ+s984DwvdmPbLsW9oaqpv1vu0U079pgVY+khqLyUYYKEwfZS5eb3R/7oX0IbTI7hDJPacC3G+Dqn7o=
X-Received: by 2002:a25:3045:: with SMTP id w66mr53150761ybw.578.1638879133893;
 Tue, 07 Dec 2021 04:12:13 -0800 (PST)
MIME-Version: 1.0
References: <20211203131808.2380042-1-mailhol.vincent@wanadoo.fr>
 <20211203131808.2380042-6-mailhol.vincent@wanadoo.fr> <20211206141940.o3g4uydg6ibspqyq@pengutronix.de>
In-Reply-To: <20211206141940.o3g4uydg6ibspqyq@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Dec 2021 21:12:02 +0900
Message-ID: <CAMZ6RqKefpH73tffY-DrXasU-UCm-UvwCbjtPhMJ_9PmfnBUQw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] can: do not increase tx_bytes statistics for RTR frames
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 6 Dec 2021 at 23:19, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 03.12.2021 22:18:08, Vincent Mailhol wrote:
> > The actual payload length of the CAN Remote Transmission Request (RTR)
> > frames is always 0, i.e. nothing is transmitted on the wire. However,
> > those RTR frames still use the DLC to indicate the length of the
> > requested frame.
> >
> > As such, net_device_stats:tx_bytes should not be increased when
> > sending RTR frames.
> >
> > The function can_get_echo_skb() already returns the correct length,
> > even for RTR frames (c.f. [1]). However, for historical reasons, the
> > drivers do not use can_get_echo_skb()'s return value and instead, most
> > of them store a temporary length (or dlc) in some local structure or
> > array. Using the return value of can_get_echo_skb() solves the
> > issue. After doing this, such length/dlc fields become unused and so
> > this patch does the adequate cleaning when needed.
> >
> > This patch fixes all the CAN drivers.
> >
> > Finally, can_get_echo_skb() is decorated with the __must_check
> > attribute in order to force future drivers to correctly use its return
> > value (else the compiler would emit a warning).
> >
> > [1] commit ed3320cec279 ("can: dev: __can_get_echo_skb():
> > fix real payload length return value for RTR frames")
> >
> > CC: Nicolas Ferre <nicolas.ferre@microchip.com>
> > CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > CC: Ludovic Desroches <ludovic.desroches@microchip.com>
> > CC: Maxime Ripard <mripard@kernel.org>
> > CC: Chen-Yu Tsai <wens@csie.org>
> > CC: Jernej Skrabec <jernej.skrabec@gmail.com>
> > CC: Yasushi SHOJI <yashi@spacecubics.com>
> > CC: Oliver Hartkopp <socketcan@hartkopp.net>
> > CC: Stephane Grosjean <s.grosjean@peak-system.com>
> > Tested-by: Jimmy Assarsson <extja@kvaser.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/net/can/at91_can.c                    |  8 ++--
> >  drivers/net/can/c_can/c_can.h                 |  1 -
> >  drivers/net/can/c_can/c_can_main.c            |  7 +---
> >  drivers/net/can/cc770/cc770.c                 |  8 +---
> >  drivers/net/can/janz-ican3.c                  |  3 +-
> >  drivers/net/can/mscan/mscan.c                 |  4 +-
> >  drivers/net/can/pch_can.c                     |  9 ++--
> >  drivers/net/can/peak_canfd/peak_canfd.c       |  3 +-
> >  drivers/net/can/rcar/rcar_can.c               | 11 +++--
> >  drivers/net/can/rcar/rcar_canfd.c             |  6 +--
> >  drivers/net/can/sja1000/sja1000.c             |  4 +-
> >  drivers/net/can/slcan.c                       |  3 +-
> >  drivers/net/can/softing/softing_main.c        |  8 ++--
> >  drivers/net/can/spi/hi311x.c                  | 24 +++++------
> >  drivers/net/can/spi/mcp251x.c                 | 25 +++++------
> >  drivers/net/can/sun4i_can.c                   |  5 +--
> >  drivers/net/can/usb/ems_usb.c                 |  7 +---
> >  drivers/net/can/usb/esd_usb2.c                |  6 +--
> >  drivers/net/can/usb/gs_usb.c                  |  7 ++--
> >  drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  5 +--
> >  .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
> >  .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 42 +++++++++----------
> >  .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 13 +++---
> >  drivers/net/can/usb/mcba_usb.c                | 12 ++----
> >  drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 20 ++++-----
> >  drivers/net/can/usb/peak_usb/pcan_usb_core.h  |  1 -
> >  drivers/net/can/usb/ucan.c                    | 10 ++---
> >  drivers/net/can/usb/usb_8dev.c                |  6 +--
> >  drivers/net/can/vcan.c                        |  7 ++--
> >  drivers/net/can/vxcan.c                       |  2 +-
> >  include/linux/can/skb.h                       |  5 ++-
> >  31 files changed, 114 insertions(+), 160 deletions(-)
> >
> > diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
> > index 97f1d08b4133..b37d9b4f508e 100644
> > --- a/drivers/net/can/at91_can.c
> > +++ b/drivers/net/can/at91_can.c
> > @@ -448,7 +448,6 @@ static void at91_chip_stop(struct net_device *dev, enum can_state state)
> >  static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  {
> >       struct at91_priv *priv = netdev_priv(dev);
> > -     struct net_device_stats *stats = &dev->stats;
> >       struct can_frame *cf = (struct can_frame *)skb->data;
> >       unsigned int mb, prio;
> >       u32 reg_mid, reg_mcr;
> > @@ -480,8 +479,6 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >       /* This triggers transmission */
> >       at91_write(priv, AT91_MCR(mb), reg_mcr);
> >
> > -     stats->tx_bytes += cf->len;
> > -
> >       /* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
> >       can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv), 0);
> >
> > @@ -852,7 +849,10 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
> >               if (likely(reg_msr & AT91_MSR_MRDY &&
> >                          ~reg_msr & AT91_MSR_MABT)) {
> >                       /* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
> > -                     can_get_echo_skb(dev, mb - get_mb_tx_first(priv), NULL);
> > +                     dev->stats.tx_bytes =
>                                             += ?

Absolutely. I will check that the other assignments are also correct
and send a v5.


Yours sincerely,
Vincent Mailhol

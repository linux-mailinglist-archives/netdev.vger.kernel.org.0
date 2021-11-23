Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35A45AFF7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhKWXYr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Nov 2021 18:24:47 -0500
Received: from mail-yb1-f172.google.com ([209.85.219.172]:41695 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhKWXYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:24:46 -0500
Received: by mail-yb1-f172.google.com with SMTP id v138so1796476ybb.8;
        Tue, 23 Nov 2021 15:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VILIOb59HSFYM7ODbeI0lMnzn6zwuywcg41rF/8ON2U=;
        b=43ktKalg76DD27gNdbL73rEbpETbUgJlzCrlyD91pF14Q9LznbHZgQ6+gvurquKNe0
         I8MGF8iql8aFH/HeK5HTn1Mb/SfOmWZ3wFr9jV3kOxaUeD5zWchk/BczCXVV99fDdQOk
         bc20iEjt5EXi3XgOfKVALmbA00ok0f5aCf9wYa3apPSmHhesFjUIjhClFSW3f0vKvLk4
         mjtt0a6Zu+qujQJpIIIwtYbJfYXFN+oSjO3l3bcWXMQvXXtcZVqT0Qe4Pj/Q71H4v6DG
         UYj+ZHIStLvXQsO0XhJKFPWrnSguabEJ5I7LJTSvwpYKoDHHM8i02TIu30N4b7TMutig
         /lbA==
X-Gm-Message-State: AOAM530PbMHWs7sOJ71GMVnruf2DNs7ke8xvXGORFcTyRnnj/y6dVVMs
        g3CL2dIUUcBklZuqRBHse5fKGba/B8viqsMAP/4=
X-Google-Smtp-Source: ABdhPJwlCQpdb0EU5+IZEn4dCyGHPU1DV3IfmjsHLD/no3CXqEg5wlViPhnnSSsQSM905LISxRtDT6iUHxoOp+sZxT0=
X-Received: by 2002:a25:b286:: with SMTP id k6mr10401117ybj.131.1637709697429;
 Tue, 23 Nov 2021 15:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
 <20211123115333.624335-2-mailhol.vincent@wanadoo.fr> <aafec053-1054-4797-e1f1-e89586fe326f@hartkopp.net>
In-Reply-To: <aafec053-1054-4797-e1f1-e89586fe326f@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 24 Nov 2021 08:21:26 +0900
Message-ID: <CAMZ6RqKn4PjYsE+MJHM36KPjcJX_RzW6cLtxyc94DWFz__AuQA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] can: do not increase rx statistics when receiving
 CAN error frames
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Jimmy Assarsson <extja@kvaser.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 24 Nov. 2021 à 06:01, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 23.11.21 12:53, Vincent Mailhol wrote:
> > CAN error skb is an interface specific to socket CAN. The CAN error
> > skb does not correspond to any actual CAN frame sent on the wire. Only
> > an error flag and a delimiter are transmitted when an error occurs
> > (c.f. ISO 11898-1 section 10.4.4.2 "Error flag").
> >
> > For this reason, it makes no sense to increment the rx_packets and
> > rx_bytes fields of struct net_device_stats because no actual payload
> > were transmitted on the wire.
> >
>
> (..)
>
> > diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
> > index 37b0cc65237b..bb47e9a49240 100644
> > --- a/drivers/net/can/dev/rx-offload.c
> > +++ b/drivers/net/can/dev/rx-offload.c
> > @@ -54,8 +54,10 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
> >               struct can_frame *cf = (struct can_frame *)skb->data;
> >
> >               work_done++;
> > -             stats->rx_packets++;
> > -             stats->rx_bytes += cf->len;
> > +             if (!(cf->can_id & CAN_ERR_MASK)) {
>
> This looks wrong.

And it is.

> Did you think of CAN_ERR_FLAG ??

Yes, I will fix this in v2.

> > +                     stats->rx_packets++;
> > +                     stats->rx_bytes += cf->len;
> > +             }
> >               netif_receive_skb(skb);
>
> (..)
>
> > diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
> > index 1679cbe45ded..d582c39fc8d0 100644
> > --- a/drivers/net/can/usb/ucan.c
> > +++ b/drivers/net/can/usb/ucan.c
> > @@ -621,8 +621,10 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
> >               memcpy(cf->data, m->msg.can_msg.data, cf->len);
> >
> >       /* don't count error frames as real packets */
> > -     stats->rx_packets++;
> > -     stats->rx_bytes += cf->len;
> > +     if (!(cf->can_id & CAN_ERR_FLAG)) {
>
> Ah, here we are :-)

Thank you!

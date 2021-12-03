Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD52466EF2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377826AbhLCBIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:08:53 -0500
Received: from mail-yb1-f177.google.com ([209.85.219.177]:34685 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349759AbhLCBIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:08:53 -0500
Received: by mail-yb1-f177.google.com with SMTP id y68so4632706ybe.1;
        Thu, 02 Dec 2021 17:05:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+T5Ot4IZTSo1zRNQG2U0M2IjjatsPXtdCO4Vybikmg=;
        b=r2LNbdNN20tiJTGEtqGeHaw2ZrtGe95SZ3QfqKuILzqm3EYlLI9UnS8pjArwY9jT12
         YwUz+6ZUIKi5Q9zr756/hlp3hKQ6ZmW9pbtmvpnMRYXF3229nrlGcIJNOLSZKd+P0HaB
         Og0Bqk0mELpl1fXbXqaZaQbVbXj6jEbl0JodeRB8M3JSfFT/YSkSqDuYeN++IMSutxLW
         10IsFm2Lvg+YnqJK018r7u1UrjtYCrEGVAdR/2TlKq/wEDl7TU8r8IKAZUAjcKOiF6s0
         15kFdEZ1wdWPV+ncXyU/elrjIFjGUZn8yyF2AVWPJamiiVCNl3HG2InrYcCHNW02q+XU
         vuUA==
X-Gm-Message-State: AOAM532B0Oc/qqJQLTKpwKTW/y85ffyDpkIVca3kgtinzLGQgPmBKXHT
        f1nVG8p9tMwAQNXF2x8Fhv+YvCro4ZkBEqTBr8c=
X-Google-Smtp-Source: ABdhPJwp/AaVJya8em7cb2d3HLMglXseHtbme9i0djJQDNBS2PkXjUGDLoMzLBQFLDYrJuhfXXb/na+yulMhQpeNMVU=
X-Received: by 2002:a25:e746:: with SMTP id e67mr19395225ybh.476.1638493529204;
 Thu, 02 Dec 2021 17:05:29 -0800 (PST)
MIME-Version: 1.0
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
 <20211128123734.1049786-6-mailhol.vincent@wanadoo.fr> <5ba88e96-444e-39c0-d00d-03f2153e7e6f@kvaser.com>
In-Reply-To: <5ba88e96-444e-39c0-d00d-03f2153e7e6f@kvaser.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 3 Dec 2021 10:05:18 +0900
Message-ID: <CAMZ6RqJ4WWAZSrk1AqS=TFbyrx7Ys49=fN-GTxkwh62GCS8Rqw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] can: do not increase tx_bytes statistics for RTR frames
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
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

On Fri. 3 Dec. 2021 at 08:35, Jimmy Assarsson <extja@kvaser.com> wrote:
> On 2021-11-28 13:37, Vincent Mailhol wrote:
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
>
> Hi Vincent!
>
> Thanks for the patch!
> I've reviewed and tested the changes affecting kvaser_usb.
> Looks good to me, only a minor nitpick inline :)
>

[...]

> > diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
> > index 390b6bde883c..3a49257f9fa6 100644
> > --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
> > +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
> > @@ -77,7 +77,6 @@ struct kvaser_usb_dev_card_data {
> >   struct kvaser_usb_tx_urb_context {
> >       struct kvaser_usb_net_priv *priv;
> >       u32 echo_index;
> > -     int dlc;
> >   };
> >
> >   struct kvaser_usb {
> > @@ -162,8 +161,8 @@ struct kvaser_usb_dev_ops {
> >       void (*dev_read_bulk_callback)(struct kvaser_usb *dev, void *buf,
> >                                      int len);
> >       void *(*dev_frame_to_cmd)(const struct kvaser_usb_net_priv *priv,
> > -                               const struct sk_buff *skb, int *frame_len,
> > -                               int *cmd_len, u16 transid);
> > +                               const struct sk_buff *skb, int *cmd_len,
> > +                               u16 transid);
> >   };
> >
> >   struct kvaser_usb_dev_cfg {
> > diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > index 3e682ef43f8e..c4b4d3d0a387 100644
> > --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > @@ -565,7 +565,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
> >               goto freeurb;
> >       }
> >
> > -     buf = dev->ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
> > +     buf = dev->ops->dev_frame_to_cmd(priv, skb, &cmd_len,
> >                                        context->echo_index);
> >       if (!buf) {
> >               stats->tx_dropped++;
> > diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> > index 17fabd3d0613..9f423a5fb63f 100644
> > --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> > +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> > @@ -1113,7 +1113,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
> >       struct kvaser_usb_net_priv *priv;
> >       struct can_frame *cf;
> >       unsigned long irq_flags;
> > -     int len;
> > +     unsigned int len;
> >       bool one_shot_fail = false, is_err_frame = false;
> >       u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
> >
> > @@ -1136,7 +1136,6 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
> >       }
> >
> >       context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> > -     len = context->dlc;
> >
> >       spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
> >
> > @@ -1144,7 +1143,8 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
> >       if (cf)
> >               is_err_frame = !!(cf->can_id & CAN_RTR_FLAG);
> >
> > -     can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> > +     len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> > +
> >       context->echo_index = dev->max_tx_urbs;
> >       --priv->active_tx_contexts;
> >       netif_wake_queue(priv->netdev);
> > @@ -1375,8 +1375,8 @@ static void kvaser_usb_hydra_handle_cmd(const struct kvaser_usb *dev,
> >
> >   static void *
> >   kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
> > -                               const struct sk_buff *skb, int *frame_len,
> > -                               int *cmd_len, u16 transid)
> > +                               const struct sk_buff *skb, int *cmd_len,
> > +                               u16 transid)
> >   {
> >       struct kvaser_usb *dev = priv->dev;
> >       struct kvaser_cmd_ext *cmd;
> > @@ -1388,8 +1388,6 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
> >       u32 kcan_id;
> >       u32 kcan_header;
> >
> > -     *frame_len = nbr_of_bytes;
> > -
> >       cmd = kcalloc(1, sizeof(struct kvaser_cmd_ext), GFP_ATOMIC);
> >       if (!cmd)
> >               return NULL;
> > @@ -1455,8 +1453,8 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
> >
> >   static void *
> >   kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
> > -                               const struct sk_buff *skb, int *frame_len,
> > -                               int *cmd_len, u16 transid)
> > +                               const struct sk_buff *skb, int *cmd_len,
> > +                               u16 transid)
> >   {
> >       struct kvaser_usb *dev = priv->dev;
> >       struct kvaser_cmd *cmd;
> > @@ -1464,8 +1462,6 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
> >       u32 flags;
> >       u32 id;
> >
> > -     *frame_len = cf->len;
> > -
> >       cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
> >       if (!cmd)
> >               return NULL;
> > @@ -1493,13 +1489,13 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
> >       if (cf->can_id & CAN_RTR_FLAG)
> >               flags |= KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME;
> >
> > -     flags |= (cf->can_id & CAN_ERR_FLAG ?
> > -               KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME : 0);
> > +     if (cf->can_id & CAN_ERR_FLAG)
> > +             flags |= KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
>
> This has nothing to do with RTR. Maybe put it in a separate patch?

Arg... You are right. This should not be here. I saw it in my
final check, removed it in my tree and forgot to redo a "git
format-patch".

This is some leftover of a previous version in which I did more
heavy changes to kvaser_usb_hydra_frame_to_cmd_std(). This is
purely cosmetic though. I am not willing to go into a clean up
crusade of all CAN drivers so I will just leave the ternary
operator untouched. Free to you to reuse it if you want to do a
clean up later on.

> >
> >       cmd->tx_can.id = cpu_to_le32(id);
> >       cmd->tx_can.flags = flags;
> >
> > -     memcpy(cmd->tx_can.data, cf->data, *frame_len);
> > +     memcpy(cmd->tx_can.data, cf->data, cf->len);
> >
> >       return cmd;
> >   }
> > @@ -2007,17 +2003,17 @@ static void kvaser_usb_hydra_read_bulk_callback(struct kvaser_usb *dev,
> >
> >   static void *
> >   kvaser_usb_hydra_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
> > -                           const struct sk_buff *skb, int *frame_len,
> > -                           int *cmd_len, u16 transid)
> > +                           const struct sk_buff *skb, int *cmd_len,
> > +                           u16 transid)
> >   {
> >       void *buf;
> >
> >       if (priv->dev->card_data.capabilities & KVASER_USB_HYDRA_CAP_EXT_CMD)
> > -             buf = kvaser_usb_hydra_frame_to_cmd_ext(priv, skb, frame_len,
> > -                                                     cmd_len, transid);
> > +             buf = kvaser_usb_hydra_frame_to_cmd_ext(priv, skb, cmd_len,
> > +                                                     transid);
> >       else
> > -             buf = kvaser_usb_hydra_frame_to_cmd_std(priv, skb, frame_len,
> > -                                                     cmd_len, transid);
> > +             buf = kvaser_usb_hydra_frame_to_cmd_std(priv, skb, cmd_len,
> > +                                                     transid);
> >
> >       return buf;
> >   }
> > diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> > index 14b445643554..47fa7f5a11c6 100644
> > --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> > +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> > @@ -342,16 +342,14 @@ struct kvaser_usb_err_summary {
> >
> >   static void *
> >   kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
> > -                          const struct sk_buff *skb, int *frame_len,
> > -                          int *cmd_len, u16 transid)
> > +                          const struct sk_buff *skb, int *cmd_len,
> > +                          u16 transid)
> >   {
> >       struct kvaser_usb *dev = priv->dev;
> >       struct kvaser_cmd *cmd;
> >       u8 *cmd_tx_can_flags = NULL;            /* GCC */
> >       struct can_frame *cf = (struct can_frame *)skb->data;
> >
> > -     *frame_len = cf->len;
> > -
> >       cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> >       if (cmd) {
> >               cmd->u.tx_can.tid = transid & 0xff;
> > @@ -587,12 +585,11 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
> >               priv->can.state = CAN_STATE_ERROR_ACTIVE;
> >       }
> >
> > -     stats->tx_packets++;
> > -     stats->tx_bytes += context->dlc;
> > -
> >       spin_lock_irqsave(&priv->tx_contexts_lock, flags);
> >
> > -     can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> > +     stats->tx_packets++;
> > +     stats->tx_bytes += can_get_echo_skb(priv->netdev,
> > +                                         context->echo_index, NULL);
> >       context->echo_index = dev->max_tx_urbs;
> >       --priv->active_tx_contexts;
> >       netif_wake_queue(priv->netdev);

[...]

Yours sincerely,
Vincent Mailhol

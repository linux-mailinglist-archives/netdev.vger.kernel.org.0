Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4375467104
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 05:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378419AbhLCEGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 23:06:00 -0500
Received: from mail-yb1-f170.google.com ([209.85.219.170]:40908 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhLCEGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 23:06:00 -0500
Received: by mail-yb1-f170.google.com with SMTP id 131so5472081ybc.7;
        Thu, 02 Dec 2021 20:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19hCyDKy/B7S/cI0K7RhbaWfULo5jaQrSZvu4b6gsm8=;
        b=Q/XrBPOl8YWMM9iBOSEnYPAP/9q1vdjuXjD3TzG+ujZ/KTmGZxJIYF9Zznrco3ksQP
         2+/7HWlx0FPEiHxJhLmK92JDo3Ca/Lrm8Y8V6MGcdHQuTMYgNKHdycR7Pvl/+Xag0HJN
         HdjQDqqFfpk/7p4XUrlg4JMdauebnVVhH/+eSv4ZBJfSSLzwi866ewgUkds2yYPtYdkJ
         kyqV1qVUbmCYTIG5/0rlIzu9wlOYOWuFfUSWV1wJULRiZ4H3z5z9OM1Bewmtr/17g5s0
         oPsM64oyd0QhppJiuSeHDGdQdlsh/ah6vZ/z8u6CiyTRNV3efdmegBseLa7xBT4QKrS6
         9D/w==
X-Gm-Message-State: AOAM531c0KEnOtNdq6n3ypXBkXywvnCCvPJkeXIcTjw8mGoxGlMZCkFG
        Id1YI1tqdg/yTqDOlSoQuOab/LeQNVGaOjQWNyw=
X-Google-Smtp-Source: ABdhPJy5ljPR9oVlYJtDzNkoBV6J+otLipyX13p4J620nsixV2XoLB97ERTZ+P3Jim0EpPeW7r+DHvSN8CZbNKOUYPk=
X-Received: by 2002:a25:b3c3:: with SMTP id x3mr20262120ybf.25.1638504156482;
 Thu, 02 Dec 2021 20:02:36 -0800 (PST)
MIME-Version: 1.0
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
 <20211128123734.1049786-3-mailhol.vincent@wanadoo.fr> <82ea8723-a234-0dad-ea9f-1b5ccac0b812@kvaser.com>
In-Reply-To: <82ea8723-a234-0dad-ea9f-1b5ccac0b812@kvaser.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 3 Dec 2021 13:02:25 +0900
Message-ID: <CAMZ6RqKtn-EuSLCTAppzz0THzr7KUYBUBOTHkwhSCzrDyzSzhw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] can: kvaser_usb: do not increase tx statistics
 when sending error message frames
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 3 Dec 2021 at 08:35, Jimmy Assarsson <extja@kvaser.com> wrote:
> On 2021-11-28 13:37, Vincent Mailhol wrote:
> > The CAN error message frames (i.e. error skb) are an interface
> > specific to socket CAN. The payload of the CAN error message frames
> > does not correspond to any actual data sent on the wire. Only an error
> > flag and a delimiter are transmitted when an error occurs (c.f. ISO
> > 11898-1 section 10.4.4.2 "Error flag").
> >
> > For this reason, it makes no sense to increment the tx_packets and
> > tx_bytes fields of struct net_device_stats when sending an error
> > message frame because no actual payload will be transmitted on the
> > wire.
> >
> > N.B. Sending error message frames is a very specific feature which, at
> > the moment, is only supported by the Kvaser Hydra hardware. Please
> > refer to [1] for more details on the topic.
> >
> > [1] https://lore.kernel.org/linux-can/CAMZ6RqK0rTNg3u3mBpZOoY51jLZ-et-J01tY6-+mWsM4meVw-A@mail.gmail.com/t/#u
> >
> > CC: Jimmy Assarsson <extja@kvaser.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> Hi Vincent!
>
> Thanks for the patch.
> There are flags in the TX ACK package, which makes it possible to
> determine if it was an error frame or not. So we don't need to get
> the original CAN frame to determine this.
> I suggest the following change:

This is a great suggestion. I was not a fan of getting the
original CAN frame, this TX ACK solves the issue.

> ---
>   .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 25 ++++++++++++-------
>   1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> index 3398da323126..01b076f04e26 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> @@ -295,6 +295,7 @@ struct kvaser_cmd {
>   #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN      BIT(1)
>   #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME BIT(4)
>   #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID  BIT(5)
> +#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK        BIT(6)
>   /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
>   #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK     BIT(12)
>   #define KVASER_USB_HYDRA_CF_FLAG_ABL          BIT(13)
> @@ -1112,7 +1113,9 @@ static void kvaser_usb_hydra_tx_acknowledge(const
> struct kvaser_usb *dev,
>         struct kvaser_usb_tx_urb_context *context;
>         struct kvaser_usb_net_priv *priv;
>         unsigned long irq_flags;
> +       unsigned int len;
>         bool one_shot_fail = false;
> +       bool is_err_frame = false;
>         u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
>
>         priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
> @@ -1131,24 +1134,28 @@ static void
> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>                         kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
>                         one_shot_fail = true;
>                 }
> -       }
> -
> -       context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> -       if (!one_shot_fail) {
> -               struct net_device_stats *stats = &priv->netdev->stats;
> -
> -               stats->tx_packets++;
> -               stats->tx_bytes += can_fd_dlc2len(context->dlc);
> +               if (flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
> +                   flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME)
> +                        is_err_frame = true;

Nitpick, but I prefer to write:

+                is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
+                               flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;

>         }
>
>         spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
>
> -       can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> +       context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> +       len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);

This line is related to the tx RTR. I will rebase this into
"can: do not increase rx_bytes statistics for RTR frames" (patch 4/5).

> +
>         context->echo_index = dev->max_tx_urbs;
>         --priv->active_tx_contexts;
>         netif_wake_queue(priv->netdev);
>
>         spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
> +
> +       if (!one_shot_fail && !is_err_frame) {
> +               struct net_device_stats *stats = &priv->netdev->stats;
> +
> +               stats->tx_packets++;
> +               stats->tx_bytes += len;
> +       }

Same here, there is no need anymore to move this block *in this
patch*, will rebase it.

>   }
>
>   static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,


This patch ("can: kvaser_usb: do not increase tx statistics when
sending error message frames") will become:

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3398da323126..75009d38f8e3 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -295,6 +295,7 @@ struct kvaser_cmd {
 #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN       BIT(1)
 #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME  BIT(4)
 #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID   BIT(5)
+#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK                BIT(6)
 /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
 #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK      BIT(12)
 #define KVASER_USB_HYDRA_CF_FLAG_ABL           BIT(13)
@@ -1113,6 +1114,7 @@ static void
kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
        struct kvaser_usb_net_priv *priv;
        unsigned long irq_flags;
        bool one_shot_fail = false;
+       bool is_err_frame = false;
        u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);

        priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
@@ -1131,10 +1133,13 @@ static void
kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
                        kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
                        one_shot_fail = true;
                }
+
+               is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
+                              flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
        }

        context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-       if (!one_shot_fail) {
+       if (!one_shot_fail && !is_err_frame) {
                struct net_device_stats *stats = &priv->netdev->stats;

                stats->tx_packets++;


And patch 5/5 ("can: do not increase tx_bytes
statistics for RTR frames") becomes:

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 75009d38f8e3..2cb35bd162a4 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1113,6 +1113,7 @@ static void
kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
        struct kvaser_usb_tx_urb_context *context;
        struct kvaser_usb_net_priv *priv;
        unsigned long irq_flags;
+       unsigned int len;
        bool one_shot_fail = false;
        bool is_err_frame = false;
        u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
@@ -1139,21 +1140,23 @@ static void
kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
        }

        context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-       if (!one_shot_fail && !is_err_frame) {
-               struct net_device_stats *stats = &priv->netdev->stats;
-
-               stats->tx_packets++;
-               stats->tx_bytes += can_fd_dlc2len(context->dlc);
-       }

        spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);

-       can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+       len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
        context->echo_index = dev->max_tx_urbs;
        --priv->active_tx_contexts;
        netif_wake_queue(priv->netdev);

        spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
+
+       if (!one_shot_fail && !is_err_frame) {
+               struct net_device_stats *stats = &priv->netdev->stats;
+
+               stats->tx_packets++;
+               stats->tx_bytes += len;
+       }
 }

Does this look good to you? If so, can I add these tags to patch 2/5?
Co-developed-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>


Also, can I add your tested-by to patches 1/5, 4/5 and 5/5?
Tested-by: Jimmy Assarsson <extja@kvaser.com>


Yours sincerely,
Vincent Mailhol

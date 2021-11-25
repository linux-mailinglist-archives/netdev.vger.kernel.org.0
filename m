Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9245E35D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhKYXeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:34:20 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:34798 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350988AbhKYXcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 18:32:20 -0500
Received: by mail-yb1-f171.google.com with SMTP id y68so15554564ybe.1;
        Thu, 25 Nov 2021 15:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=blV1Fv4hcoWLPMa9NW0Mv4Ujudwc+s6b2OZ54WL07S4=;
        b=AGfC9C5yrVJfWGUcDsLHrMXCBi/ioIjc/kbvQSQLvsyUHzKKlMKadPosETigIHMJQ7
         RD/YHfIqbTgqqp5xkZM6BLw5m1ZVZNGh9Ttnv5AVVq6EHwsUG0JX5bMclr247vVU6czm
         1PzigDzN8lv7df6WaIBdxfEMDz/pUZoQDXKzxa3qzN6ADd4WbaJJLeJK6Pdvew6ttTfC
         1c6P9UwD/KeG/Tu7zH73nnKM3mTDqKK0NcEVoS2VuvcaUp5Rbxz9xfjN+v1lIx6PjbkW
         A8XqY+8UneGqvse3VBuApfCGogJVcxL2mikGO2+fbFsZ5GuO1aGjEb5tjqHBhhh7GMjr
         oFuQ==
X-Gm-Message-State: AOAM533ZD1H3EFagdDlfIIRbFI3Pk8yTCKEzZC/KvIMlCILvEzBVpBFu
        KftMhryNg9co/oHs94jVa0jy6N7v6xBsEz0K4N1+VLGraRs=
X-Google-Smtp-Source: ABdhPJxqAoOcr1wx1llTSS3Z489P1w21Bx/evl9uijsb35Apz8cCAD32funRnACdZQbh02+XLSTjm7lel8mdyMh18Jg=
X-Received: by 2002:a25:c987:: with SMTP id z129mr7183395ybf.62.1637882947711;
 Thu, 25 Nov 2021 15:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20211125172021.976384-1-mailhol.vincent@wanadoo.fr>
 <20211125172021.976384-5-mailhol.vincent@wanadoo.fr> <ed755990-4169-604e-d982-7e4370114512@hartkopp.net>
In-Reply-To: <ed755990-4169-604e-d982-7e4370114512@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 26 Nov 2021 08:28:56 +0900
Message-ID: <CAMZ6RqJWdO3tvOz020Ee_zcFnJDFWO9qxM7Rtjw2+n_o79B+cw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] can: do not increase rx_bytes statistics for RTR frames
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
        Yasushi SHOJI <yashi@spacecubics.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oliver,

On. 26 Nov. 2021 at 03:50, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> Hi Vincent,
>
> On 25.11.21 18:20, Vincent Mailhol wrote:
>
> > diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
> > index d582c39fc8d0..717d4925fdb0 100644
> > --- a/drivers/net/can/usb/ucan.c
> > +++ b/drivers/net/can/usb/ucan.c
> > @@ -619,12 +619,13 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
> >       /* copy the payload of non RTR frames */
> >       if (!(cf->can_id & CAN_RTR_FLAG) || (cf->can_id & CAN_ERR_FLAG))
> >               memcpy(cf->data, m->msg.can_msg.data, cf->len);
> > +     /* only frames which are neither RTR nor ERR have a payload */
> > +     else
> > +             stats->rx_bytes += cf->len;
>
> This 'else' path looks wrong ...

Ack. I will send a v3.
And thanks a lot for the review!

> >
> >       /* don't count error frames as real packets */
> > -     if (!(cf->can_id & CAN_ERR_FLAG)) {
> > +     if (!(cf->can_id & CAN_ERR_FLAG))
> >               stats->rx_packets++;
> > -             stats->rx_bytes += cf->len;
> > -     }
> >
> >       /* pass it to Linux */
> >       netif_rx(skb);
>
> Regards,
> Oliver

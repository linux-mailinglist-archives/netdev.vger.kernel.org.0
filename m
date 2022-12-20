Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49D651CA5
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 09:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiLTIxn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Dec 2022 03:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLTIxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 03:53:41 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004485FB8;
        Tue, 20 Dec 2022 00:53:40 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id gt4so11765393pjb.1;
        Tue, 20 Dec 2022 00:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYfOI5g0mVdE94ssvdHEuS1TjAEmKRYHyW9ESDKrcA4=;
        b=emWqv9vdcgwTplhb4c3XNNCJCPsIFPUeIGwJMzRTS4q0iY+e8myfQjXo1WFsWiTsm0
         Vk1MmCqoS+ip12P/nM2+Ji8buJr+nYKpcl4/dDCawLQbkJbdxiFl5290GZG5jMjtRjL7
         1YpbjI13Uuki2QvdfZp+adQndBXT9463BEuZwBrdM4D3gXWr9sY2zh6eVxjprd2/mJjI
         qQxMmdY/37u7s2pmkTdtV93QKDM9kUM+RicYdgNdYszDMrGcpuWaPABRyPndCvu3FHbG
         ycegMvgekACIRW6rtyJv2xYiBGFqCoNYefT/dCCiPmhRTBh2HmE2YYt0KjokthT+Ilfu
         6WGg==
X-Gm-Message-State: AFqh2kpAYXuF76z30WZgXhlJmmujSyrdXqbrY5QPcyJfHkazlPEKoa74
        1jNUNJ+zR6p2qcs9k72q15OMmS5PPaOt0jXSTcc=
X-Google-Smtp-Source: AMrXdXsZ2KHkjkBDRh6WyLUmshs+zkXMjFWlFSM4tkglDiTe7syCyGap/78L8ZfxENi/dlDCU3nsO45stSaQPa4aMiQ=
X-Received: by 2002:a17:90a:c7d3:b0:21c:bc8b:b080 with SMTP id
 gf19-20020a17090ac7d300b0021cbc8bb080mr1574916pjb.19.1671526419769; Tue, 20
 Dec 2022 00:53:39 -0800 (PST)
MIME-Version: 1.0
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
 <20221219212717.1298282-2-frank.jungclaus@esd.eu> <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 20 Dec 2022 17:53:28 +0900
Message-ID: <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
Subject: Re: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 20 Dec. 2022 at 14:27, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> Le mar. 20 déc. 2022 à 06:28, Frank Jungclaus <frank.jungclaus@esd.eu> a écrit :
> > As suggested by Marc there now is a union plus a struct ev_can_err_ext
> > for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
> > simply is a rx_msg with some dedicated data).
> >
> > Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> > index 09745751f168..f90bb2c0ba15 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -127,7 +127,15 @@ struct rx_msg {
> >         u8 dlc;
> >         __le32 ts;
> >         __le32 id; /* upper 3 bits contain flags */
> > -       u8 data[8];
> > +       union {
> > +               u8 data[8];
> > +               struct {
> > +                       u8 status; /* CAN Controller Status */
> > +                       u8 ecc;    /* Error Capture Register */
> > +                       u8 rec;    /* RX Error Counter */
> > +                       u8 tec;    /* TX Error Counter */
> > +               } ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
> > +       };
> >  };
> >
> >  struct tx_msg {
> > @@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
> >         u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> >
> >         if (id == ESD_EV_CAN_ERROR_EXT) {
> > -               u8 state = msg->msg.rx.data[0];
> > -               u8 ecc = msg->msg.rx.data[1];
> > -               u8 rxerr = msg->msg.rx.data[2];
> > -               u8 txerr = msg->msg.rx.data[3];
> > +               u8 state = msg->msg.rx.ev_can_err_ext.status;
> > +               u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
> > +               u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
> > +               u8 txerr = msg->msg.rx.ev_can_err_ext.tec;
>
> I do not like how you have to write msg->msg.rx.something. I think it
> would be better to make the union within struct esd_usb_msg anonymous:
>
>   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/esd_usb.c#L169

Or maybe just declare esd_usb_msg as an union instead of a struct:

  union esd_usb_msg {
          struct header_msg hdr;
          struct version_msg version;
          struct version_reply_msg version_reply;
          struct rx_msg rx;
          struct tx_msg tx;
          struct tx_done_msg txdone;
          struct set_baudrate_msg setbaud;
          struct id_filter_msg filter;
  };

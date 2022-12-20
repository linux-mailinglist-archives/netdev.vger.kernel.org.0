Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410C7651A39
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 06:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiLTF1c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Dec 2022 00:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTF1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 00:27:30 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8084FB9;
        Mon, 19 Dec 2022 21:27:29 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id 124so7818735pfy.0;
        Mon, 19 Dec 2022 21:27:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fgdIcNnHtv/UvgykaD5KYGncbrMyeY4TxNRMdBaCn4=;
        b=LUEOG8MgTans4f30L2NcYeXm80k6UeeTVN6/YSumqyr1lAx4ghQXLfotJwxEWB5Bl3
         Vvm2XlPQvFTk1A38TQu35mWDN8sxQiSHhHfYvP2BX1UmaJfU6DZivotRFo5jqfarDYb6
         qPe4p3SKFWw/TPcnIBVxAPhdXAQbTWkvHSZwJeNqy5cA0UMIDGaUH+oJJ0ZFzrmlkPdD
         0ftArsZ/4ErMsSkYs4XOg7+KOf2XCK1VdV30Q/mWZH5E295/ryJ2tWvPY1O4Sj2Y7wDc
         blcqOXHxbxBXzAQvDPkuvB0HOOKZaCN3AszxSnVoJLilK3TAwmKOP8IR31IyPxLb+SFM
         z35w==
X-Gm-Message-State: AFqh2koqscvnC/i2VNTOXrYsEd4e1Fta5G8qdGtHTjSyMFL8FzZloYGG
        EgXRD2EzJht8qxkuTSWMV+lq7OtddnLtcvEee0s=
X-Google-Smtp-Source: AMrXdXuMHderDr6lO+hCyLC5OapmMH7udHPoJpowuLYkKofpHWJueSqy55RTn/lwwS+K7Ow/nnFJSwHN0+UusvdXErE=
X-Received: by 2002:a63:584c:0:b0:484:2672:2c6a with SMTP id
 i12-20020a63584c000000b0048426722c6amr854698pgm.535.1671514048877; Mon, 19
 Dec 2022 21:27:28 -0800 (PST)
MIME-Version: 1.0
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu> <20221219212717.1298282-2-frank.jungclaus@esd.eu>
In-Reply-To: <20221219212717.1298282-2-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 20 Dec 2022 14:27:17 +0900
Message-ID: <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le mar. 20 déc. 2022 à 06:28, Frank Jungclaus <frank.jungclaus@esd.eu> a écrit :
>
> As suggested by Marc there now is a union plus a struct ev_can_err_ext
> for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
> simply is a rx_msg with some dedicated data).
>
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 09745751f168..f90bb2c0ba15 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -127,7 +127,15 @@ struct rx_msg {
>         u8 dlc;
>         __le32 ts;
>         __le32 id; /* upper 3 bits contain flags */
> -       u8 data[8];
> +       union {
> +               u8 data[8];
> +               struct {
> +                       u8 status; /* CAN Controller Status */
> +                       u8 ecc;    /* Error Capture Register */
> +                       u8 rec;    /* RX Error Counter */
> +                       u8 tec;    /* TX Error Counter */
> +               } ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
> +       };
>  };
>
>  struct tx_msg {
> @@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>         u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
>
>         if (id == ESD_EV_CAN_ERROR_EXT) {
> -               u8 state = msg->msg.rx.data[0];
> -               u8 ecc = msg->msg.rx.data[1];
> -               u8 rxerr = msg->msg.rx.data[2];
> -               u8 txerr = msg->msg.rx.data[3];
> +               u8 state = msg->msg.rx.ev_can_err_ext.status;
> +               u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
> +               u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
> +               u8 txerr = msg->msg.rx.ev_can_err_ext.tec;

I do not like how you have to write msg->msg.rx.something. I think it
would be better to make the union within struct esd_usb_msg anonymous:

  https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/esd_usb.c#L169

That said, this is not a criticism of this patch but more something to
be addressed in a separate clean-up patch.

>                 netdev_dbg(priv->netdev,
>                            "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
> --
> 2.25.1
>

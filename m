Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B14570F8A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 03:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiGLBdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 21:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiGLBdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 21:33:04 -0400
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BD28D5F0;
        Mon, 11 Jul 2022 18:33:02 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id r3so11595503ybr.6;
        Mon, 11 Jul 2022 18:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldd/zpJwmj78yQKupkX1vWzC+GyweGRaRS0TSs8SWDY=;
        b=GwcTWXIHrPEauze9nthM8ajJuQRhaOBJrqLd1YMoezYFnZ7wXXP6liHv4T2njgpJ4F
         5Ju1dJ3XzjDovb0HfeP7mtRHnC0SOxwo7ZPWx7OvzMpPtg6fmgYFPVOFzpREXLX5zGAv
         9eqMfAbG4JxPznvUaoSWcs4TbmGmAOyQ0w0vihTM0zyzpOaJySsHBN2pFz6CHduQEbOb
         Hsq/rPWqPRjnzjpEgbzt39G+QD6xK7y60KSJ37QfZqCP6OqAKYhjmypYXYBR2XtKx2T9
         FDorE+uMAlghfPpxq7RE99+OJwh8+dnxb+eE0q1Rh7dHeD/rMI511Uys2XgJSgmGLK4p
         CTLQ==
X-Gm-Message-State: AJIora+bauERk9C/rF+T12o9XtsUnjjSQSnBmTLWNzj0lJB/xngzVLG6
        41jyuSOXBbCvxxzKXkFNmkGtPbiQetky9UbGSxSM8NuRbks=
X-Google-Smtp-Source: AGRyM1uvMuQ5pwkMlrFt4f9cDZt+Q25E2CcdS6aIV4xvgCOYC/LdTyh64KRLiMuQrzAL3sAO40GRzkDv96ZWf6zn4SM=
X-Received: by 2002:a25:9743:0:b0:66e:f62d:4956 with SMTP id
 h3-20020a259743000000b0066ef62d4956mr12345502ybo.381.1657589581738; Mon, 11
 Jul 2022 18:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu> <20220708181235.4104943-7-frank.jungclaus@esd.eu>
In-Reply-To: <20220708181235.4104943-7-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jul 2022 10:33:15 +0900
Message-ID: <CAMZ6RqLC9a50mbyeaUSE4zqOfwPEVvOeYXcCVefC5EMD5dN6PA@mail.gmail.com>
Subject: Re: [PATCH 6/6] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 9 Jul. 2022 at 03:14, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> As suggested by Vincent I spend a union plus a struct ev_can_err_ext

The canonical way to declare that something was suggested by someone
else is to use the Suggested-by tag.

Also, this particular change was suggested by Marc, not by me ;)
https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/

> for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
> simply is a rx_msg with some dedicated data).

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>

> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 09649a45d6ff..2b149590720c 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -126,7 +126,15 @@ struct rx_msg {
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
> @@ -134,7 +142,7 @@ struct tx_msg {
>         u8 cmd;
>         u8 net;
>         u8 dlc;
> -       u32 hnd;        /* opaque handle, not used by device */
> +       u32 hnd;   /* opaque handle, not used by device */
>         __le32 id; /* upper 3 bits contain flags */
>         u8 data[8];
>  };
> @@ -228,11 +236,11 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>         u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
>
>         if (id == ESD_EV_CAN_ERROR_EXT) {
> -               u8 state = msg->msg.rx.data[0];
> -               u8 ecc   = msg->msg.rx.data[1];
> +               u8 state = msg->msg.rx.ev_can_err_ext.status;
> +               u8 ecc   = msg->msg.rx.ev_can_err_ext.ecc;
>
> -               priv->bec.rxerr = msg->msg.rx.data[2];
> -               priv->bec.txerr = msg->msg.rx.data[3];
> +               priv->bec.rxerr = msg->msg.rx.ev_can_err_ext.rec;
> +               priv->bec.txerr = msg->msg.rx.ev_can_err_ext.tec;
>
>                 netdev_dbg(priv->netdev,
>                            "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",

Yours sincerely,
Vincent Mailhol

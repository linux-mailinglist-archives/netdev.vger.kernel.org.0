Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896B6571CF2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiGLOjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiGLOjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:39:41 -0400
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564712496F;
        Tue, 12 Jul 2022 07:39:40 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-31c8bb90d09so83060147b3.8;
        Tue, 12 Jul 2022 07:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PC86xMGUfSnwU1wUnbuH+oo/JpYi0LOJ0j1avSTctkQ=;
        b=49tUINXn/QYV9ue6R5pzbBm14aQue7KHtywG32+w6coBbVe+Ou8W4fz4lgpViBpfkJ
         1aQp7jed18dC476wLzbfk250VB6P/JYGF9iKvc9XkUpGRyPLCKVu2GmRAYzGXfVaCXqr
         HtRz1TTxbxRd4yQ7uEDtcbgtLCC5UlwHX8aXoor0ESsb13mP2hanOCgwgZwOFBbO4OER
         6xgFZMCUhGMO7LTYQ5+CYV3iy+rNjjN2Gqc3eU4nI/TZJuF7vwYFvu1qfA6KyqUDOdwQ
         16v6wKjCsvpqD+ETrpyehLzg35mool5l2QQVHpp1IewtOw/IZcjlV39un+/+zurAdN3Q
         Gotg==
X-Gm-Message-State: AJIora+5KscHJzHWOca4iaawPDNKUeMUHkfB/IshYFUt31SaqRqbyn/p
        aTCM7y7YCbE13sv/rygEzgXgXBNql+Vq5JNwSCR9GzCsbxc=
X-Google-Smtp-Source: AGRyM1v/Pvr2a1+guMYqIWCRQro8zrJa0Io2m5481K1W8RgdZFu+NYSafudYKYGO8r8yUk1u+yyW7faKYF8JpPhYVnc=
X-Received: by 2002:a0d:f247:0:b0:31d:68b1:5a16 with SMTP id
 b68-20020a0df247000000b0031d68b15a16mr13513324ywf.191.1657636779504; Tue, 12
 Jul 2022 07:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu> <20220708181235.4104943-5-frank.jungclaus@esd.eu>
In-Reply-To: <20220708181235.4104943-5-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jul 2022 23:39:28 +0900
Message-ID: <CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com>
Subject: Re: [PATCH 4/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (3)
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

On Tue. 9 Jul. 2022 at 03:15, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> Started a rework initiated by Vincents remark about "You should not
> report the greatest of txerr and rxerr but the one which actually
> increased." Now setting CAN_ERR_CRTL_[RT]X_WARNING and
> CAN_ERR_CRTL_[RT]X_PASSIVE depending on REC and TEC
>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 0a402a23d7ac..588caba1453b 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -304,11 +304,17 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                         /* Store error in CAN protocol (location) in data[3] */
>                         cf->data[3] = ecc & SJA1000_ECC_SEG;
>
> -                       if (priv->can.state == CAN_STATE_ERROR_WARNING ||
> -                           priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> -                               cf->data[1] = (txerr > rxerr) ?
> -                                       CAN_ERR_CRTL_TX_PASSIVE :
> -                                       CAN_ERR_CRTL_RX_PASSIVE;
> +                       /* Store error status of CAN-controller in data[1] */
> +                       if (priv->can.state == CAN_STATE_ERROR_WARNING) {
> +                               if (txerr >= 96)
> +                                       cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;

As far as I understand, those flags should be set only when the
threshold is *reached*:
https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/error.h#L69

I don't think you should set it if the error state does not change.

Here, you probably want to compare the new value  with the previous
one (stored in struct can_berr_counter) to decide whether or not the
flags should be set.


> +                               if (rxerr >= 96)
> +                                       cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
> +                       } else if (priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> +                               if (txerr >= 128)
> +                                       cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
> +                               if (rxerr >= 128)
> +                                       cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
>                         }
>
>                         cf->data[6] = txerr;
> --
> 2.25.1
>

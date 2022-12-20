Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF113651A34
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 06:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiLTFQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 00:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTFQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 00:16:53 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6038E60DF;
        Mon, 19 Dec 2022 21:16:51 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id k79so7759040pfd.7;
        Mon, 19 Dec 2022 21:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y+Qr8XUVpxB/+TLY0Usi8j5C3U+ntsf3C3rD3sN9jR4=;
        b=s4tZtPN2g9gpUdRv1EJX0cbBYlfQotV2IW2D8jRMG5Jucu1czIFnR3hL9t96Umth3j
         Ph//UGAQegLEjx4P3dB4Tz2Ek/4VqFkkJRKIn4VUOWjT3TX7E8REvGF6bLWaVpOSygnh
         X4c+lu7+0bOTkNRUYRQLvOxdhXrUtmyxqhmo5zQoZGf55EnTPNJeKt3vfyfI614uChyd
         Ii3op6cnuHLg1IecjWC69dIJKivYm6AF5ypSHU4f7wFN47EX5agxWEg6bOOkIVcvFXjI
         142RmAHkoerDJlHzZzRoDWHaA1eyZHkuai7DT9NmZmKC4jnsgTHU22dsGTXm4N6WY7kk
         ogIA==
X-Gm-Message-State: AFqh2kpHJT2ePNaOlBhoK3KI2L9g9sobNJMHLVkhrVMiKbrPns4oWObD
        blyaECJoYpjKj+RbmL7/IAqE65Ps95cLoYNvabU=
X-Google-Smtp-Source: AMrXdXs15pGNbOpDcT2+T1FhTjoIu/dIQv+ESXHxbEPaBKEcsgo0JwldUymd3df/4+UrhYKmOdn//GLV9KFNmSUVd0k=
X-Received: by 2002:a63:2163:0:b0:483:f80c:cdf3 with SMTP id
 s35-20020a632163000000b00483f80ccdf3mr798360pgm.70.1671513410744; Mon, 19 Dec
 2022 21:16:50 -0800 (PST)
MIME-Version: 1.0
References: <20221219212013.1294820-1-frank.jungclaus@esd.eu> <20221219212013.1294820-2-frank.jungclaus@esd.eu>
In-Reply-To: <20221219212013.1294820-2-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 20 Dec 2022 14:16:39 +0900
Message-ID: <CAMZ6RqKc0mvfQGEGb7gCE69Mskhzq5YKF88Jhe+1VR=43YW3Xg@mail.gmail.com>
Subject: Re: [PATCH 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (1)
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 20 Dec. 2022 at 06:25, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
>
> Moved the supply for cf->data[3] (bit stream position of CAN error)
> outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement, because
> this position is independent of the error type.
>
> Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 42323f5e6f3a..5e182fadd875 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                                 cf->data[2] |= CAN_ERR_PROT_STUFF;
>                                 break;
>                         default:
> -                               cf->data[3] = ecc & SJA1000_ECC_SEG;
>                                 break;
>                         }
>
> @@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                         if (!(ecc & SJA1000_ECC_DIR))
>                                 cf->data[2] |= CAN_ERR_PROT_TX;
>
> +                       /* Bit stream position in CAN frame as the error was detected */
> +                       cf->data[3] = ecc & SJA1000_ECC_SEG;

Can you confirm that the value returned by the device matches the
specifications from linux/can/error.h?

  https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/error.h#L90

>                         if (priv->can.state == CAN_STATE_ERROR_WARNING ||
>                             priv->can.state == CAN_STATE_ERROR_PASSIVE) {
>                                 cf->data[1] = (txerr > rxerr) ?
> --
> 2.25.1
>

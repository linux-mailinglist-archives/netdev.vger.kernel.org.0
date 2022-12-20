Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C397651A67
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 06:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiLTFtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 00:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLTFtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 00:49:42 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEEE20D;
        Mon, 19 Dec 2022 21:49:41 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so11042181pjd.5;
        Mon, 19 Dec 2022 21:49:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NRazUl1sRq3nHsv4iSumaCdK0OTW7rNnCuqNd/Xi384=;
        b=yg88aU2ybi63pXPdtjQRhVODu9Ij/SEnSJYYXCEaFOcW2rNwe7TzsnI+VzX1jboYLF
         N6cxQcECvRxgKTe4visDmUj98dGfnL7hsC/ju2+Ch6ARKQ+XzINm9WfozS8bsHkm0jI8
         VZEG6qXFKMcI7q6DkjPv3NEg/IcH3qMIKUKXVDFn/fKawiB0SYqKrCkuR1dH6T+RKDPB
         mlHfvs0Uj2GoQ03AUj+lDZMuNxy1urJ9SNsZevSjB2N6bxYj/OXL+3zmV6tCq8g/CGmQ
         fniz+2oUcMOOaIYIA0Tq6+ATOOpJgWPUR/zZq0M1rMspNDmnkjR/77k08atOXCBiKLC3
         Sz+Q==
X-Gm-Message-State: AFqh2kr7rTm7byK/lipr+9Xc9LloyBgw3lpKRxE//hzd9xGMtfgQVM61
        klKZZuT3lFUv08oiT8V0JFOYdND5yf3fSDI2KhE=
X-Google-Smtp-Source: AMrXdXvfV1TvcAeZAo3YfDXWC5f/F5u6QP1TLuI8WS42DPMzbxPHdhhk5CIMP1LTlwDre2hjczIfEVotQS10Gt+3a4c=
X-Received: by 2002:a17:90b:23ca:b0:221:4b1c:3b29 with SMTP id
 md10-20020a17090b23ca00b002214b1c3b29mr1650503pjb.92.1671515380691; Mon, 19
 Dec 2022 21:49:40 -0800 (PST)
MIME-Version: 1.0
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
In-Reply-To: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 20 Dec 2022 14:49:29 +0900
Message-ID: <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> Started a rework initiated by Vincents remarks "You should not report
> the greatest of txerr and rxerr but the one which actually increased."
> [1]

I do not see this comment being addressed. You are still assigning the
flags depending on the highest value, not the one which actually
changed.

> and "As far as I understand, those flags should be set only when
> the threshold is *reached*" [2] .
>
> Now setting the flags for CAN_ERR_CRTL_[RT]X_WARNING and
> CAN_ERR_CRTL_[RT]X_PASSIVE regarding REC and TEC, when the
> appropriate threshold is reached.
>
> Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
> Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
> ---
>  drivers/net/can/usb/esd_usb.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 5e182fadd875..09745751f168 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -255,10 +255,18 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                                 can_bus_off(priv->netdev);
>                                 break;
>                         case ESD_BUSSTATE_WARN:
> +                               cf->can_id |= CAN_ERR_CRTL;
> +                               cf->data[1] = (txerr > rxerr) ?
> +                                               CAN_ERR_CRTL_TX_WARNING :
> +                                               CAN_ERR_CRTL_RX_WARNING;

Nitpick: when a ternary operator is too long to fit on one line,
prefer an if/else.

>                                 priv->can.state = CAN_STATE_ERROR_WARNING;
>                                 priv->can.can_stats.error_warning++;
>                                 break;
>                         case ESD_BUSSTATE_ERRPASSIVE:
> +                               cf->can_id |= CAN_ERR_CRTL;
> +                               cf->data[1] = (txerr > rxerr) ?
> +                                               CAN_ERR_CRTL_TX_PASSIVE :
> +                                               CAN_ERR_CRTL_RX_PASSIVE;

Same.

>                                 priv->can.state = CAN_STATE_ERROR_PASSIVE;
>                                 priv->can.can_stats.error_passive++;
>                                 break;
> @@ -296,12 +304,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                         /* Bit stream position in CAN frame as the error was detected */
>                         cf->data[3] = ecc & SJA1000_ECC_SEG;
>
> -                       if (priv->can.state == CAN_STATE_ERROR_WARNING ||
> -                           priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> -                               cf->data[1] = (txerr > rxerr) ?
> -                                       CAN_ERR_CRTL_TX_PASSIVE :
> -                                       CAN_ERR_CRTL_RX_PASSIVE;
> -                       }
>                         cf->data[6] = txerr;
>                         cf->data[7] = rxerr;
>                 }

Yours sincerely,
Vincent Mailhol

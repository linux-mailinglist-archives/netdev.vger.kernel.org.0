Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8749D571091
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiGLDFO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Jul 2022 23:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGLDFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:05:13 -0400
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FEA20F7C;
        Mon, 11 Jul 2022 20:05:11 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id y195so11904681yby.0;
        Mon, 11 Jul 2022 20:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xQ9YReWbslkfsJYK5nx/kGsWymMpYJHFL0KQKjFzhP4=;
        b=r3BHag/fllwrRX2P4qyEpWyNLMfkUxDrAl+OcmnHMrKoz0cW8Gk6x4vKKxR0YO68SW
         3/vjEHw0F9+lt+1rClD0Xy6kxovF4wPONhHzd+63umCCtqY0OLKORZjkL2nYX46tDSP0
         1z49wCYISwfeFDzDDKpqklmy6YQS9lSeDTYiV8BNGTaSDvC6H+of6erZvrHEydhv2KlG
         d0pn8hXPjrHngx5aO+V5h4kOwXGoR5aJ5mvWaPA08UiiRi6+1mAvJkHj2LMzK9u9yNJA
         8TBtYiC1s1U4VnT7Nm53P7Z0/nS/hbwK/N4JrAMG+i0y3GVzam/i3P44jGgwWqATFJhM
         TBow==
X-Gm-Message-State: AJIora+FJHg79TicEsNoBH9kNZIQl9Fgo3GVaeZcLi6UQA7+rJ2/eCv4
        RwJqHrlkpNTNBs9MYdz7/hWnb+HGOjKY1xt2Egx/jNQiEAbJaw==
X-Google-Smtp-Source: AGRyM1uoroTErC1XfHvqxlzdhzryvuVCS2aSQj1Kll2jrX3T/mvB00jkAV+Z9OhFecqeA7lGhLwDh4FLXNqvRJhE6jw=
X-Received: by 2002:a25:9743:0:b0:66e:f62d:4956 with SMTP id
 h3-20020a259743000000b0066ef62d4956mr12583850ybo.381.1657595110757; Mon, 11
 Jul 2022 20:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu> <20220708181235.4104943-6-frank.jungclaus@esd.eu>
In-Reply-To: <20220708181235.4104943-6-frank.jungclaus@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jul 2022 12:05:24 +0900
Message-ID: <CAMZ6Rq+BOFBRPGLmP9e4tuyV0-Jb-QH_TGbUQJm6aw4M+J1X8A@mail.gmail.com>
Subject: Re: [PATCH 5/6] can: esd_usb: Improved support for CAN_CTRLMODE_BERR_REPORTING
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sam. 9 juil. 2022 à 03:14, Frank Jungclaus <frank.jungclaus@esd.eu> a écrit :
>
> Bus error reporting has already been implemented for a long time, but
> before it was always active! Now it's user controllable by means off the
> "berr-reporting" parameter given to "ip link set ... ", which sets
> CAN_CTRLMODE_BERR_REPORTING within priv->can.ctrlmode.
>
> In case of an ESD_EV_CAN_ERROR_EXT now unconditionally supply
> priv->bec.rxerr and priv->bec.txerr with REC and TEC.
>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 47 ++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 588caba1453b..09649a45d6ff 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -230,12 +230,23 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>         if (id == ESD_EV_CAN_ERROR_EXT) {
>                 u8 state = msg->msg.rx.data[0];
>                 u8 ecc   = msg->msg.rx.data[1];
> -               u8 rxerr = msg->msg.rx.data[2];
> -               u8 txerr = msg->msg.rx.data[3];
> +
> +               priv->bec.rxerr = msg->msg.rx.data[2];
> +               priv->bec.txerr = msg->msg.rx.data[3];
>
>                 netdev_dbg(priv->netdev,
>                            "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
> -                          msg->msg.rx.dlc, state, ecc, rxerr, txerr);
> +                          msg->msg.rx.dlc, state, ecc, priv->bec.rxerr, priv->bec.txerr);
> +
> +               if (ecc) {
> +                       priv->can.can_stats.bus_error++;
> +                       stats->rx_errors++;
> +               }
> +
> +               if (state == priv->old_state &&
> +                   !(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
> +                       /* Neither a state change nor active bus error reporting */
> +                       return;
>
>                 skb = alloc_can_err_skb(priv->netdev, &cf);
>                 if (skb == NULL) {
> @@ -270,16 +281,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                                  * berr-counters might stay on values like
>                                  * 95 forever ...
>                                  */
> -                               txerr = 0;
> -                               rxerr = 0;
> +                               priv->bec.txerr = 0;
> +                               priv->bec.rxerr = 0;
>                                 break;
>                         }
>                 }
>
> -               if (ecc) {
> -                       priv->can.can_stats.bus_error++;
> -                       stats->rx_errors++;
> -
> +               if (ecc && (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)) {
> +                       /* Only if bus error reporting is active ... */
>                         cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
>
>                         /* Store error in CAN protocol (type) in data[2] */
> @@ -301,29 +310,26 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>                         if (!(ecc & SJA1000_ECC_DIR))
>                                 cf->data[2] |= CAN_ERR_PROT_TX;
>
> -                       /* Store error in CAN protocol (location) in data[3] */
> +                       /* Store error position in the bit stream of the CAN frame in data[3] */
>                         cf->data[3] = ecc & SJA1000_ECC_SEG;
>
>                         /* Store error status of CAN-controller in data[1] */
>                         if (priv->can.state == CAN_STATE_ERROR_WARNING) {
> -                               if (txerr >= 96)
> +                               if (priv->bec.txerr >= 96)

I checked and was just surprised that we do not have any macro for the
different thresholds.

Does it make sense to add below declarations to include/uapi/linux/can/error.h?

#define CAN_ERROR_WARNING_THRESHOLD 96
#define CAN_ERROR_PASSIVE_THRESHOLD 128

I will try to submit a patch for that by the end of today.

>                                         cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
> -                               if (rxerr >= 96)
> +                               if (priv->bec.rxerr >= 96)
>                                         cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
>                         } else if (priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> -                               if (txerr >= 128)
> +                               if (priv->bec.txerr >= 128)
>                                         cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
> -                               if (rxerr >= 128)
> +                               if (priv->bec.rxerr >= 128)
>                                         cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
>                         }
>
> -                       cf->data[6] = txerr;
> -                       cf->data[7] = rxerr;
> +                       cf->data[6] = priv->bec.txerr;
> +                       cf->data[7] = priv->bec.rxerr;
>                 }
>
> -               priv->bec.txerr = txerr;
> -               priv->bec.rxerr = rxerr;
> -
>                 netif_rx(skb);
>         }
>  }
> @@ -1021,7 +1027,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
>
>         priv->can.state = CAN_STATE_STOPPED;
>         priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
> -               CAN_CTRLMODE_CC_LEN8_DLC;
> +                                      CAN_CTRLMODE_CC_LEN8_DLC |
> +                                      CAN_CTRLMODE_BERR_REPORTING;
>
>         if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
>             USB_CANUSBM_PRODUCT_ID)
> --
> 2.25.1
>

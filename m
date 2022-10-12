Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9B25FCA12
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJLRuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJLRuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:50:39 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BAC9413E;
        Wed, 12 Oct 2022 10:50:38 -0700 (PDT)
Received: from [IPV6:2003:e9:d728:5820:2c00:8a27:9bcf:7d44] (p200300e9d72858202c008a279bcf7d44.dip0.t-ipconnect.de [IPv6:2003:e9:d728:5820:2c00:8a27:9bcf:7d44])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3AF8EC01B4;
        Wed, 12 Oct 2022 19:50:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665597035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPTAaOTk3ES86EKQXvoNx3hKyjt1D+wTsi+ko99dRMw=;
        b=FlIMGK5n0k63xfrXhXtOan1IQiLbUZM5qHrY9C5hU41nitM9Nf8AnWWTT+xYPi1Tz5jqZo
        iUFPSNLcDlfZtKPtb4MHSMomWCOoSEZQDoYoKHL2EnYf9mO/16SvKt+wEGCOo0tWdIqZd2
        IMR/ExjQaE9FTp8qrStYw+H3CxQ3DDE3TkXIxH1OGFmfn05t4g1pyHr7BG91xZ6/kKlzJ7
        iwFcKqheOU8mrrR/a2SpDU9lHNd6zuC1FfMJ/+NrXRHlxWxRr3/Oq9rBBEr+7zzqAglnSZ
        jWyU4aE59CgEQ66DmW6aGtyGmANhO1wrvEqT4ekj1KpwKyE62BgovVRiwsenVg==
Message-ID: <addba337-b3a5-5e1f-9524-e9f3b2ebfb80@datenfreihafen.org>
Date:   Wed, 12 Oct 2022 19:50:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan/next v3 9/9] ieee802154: atusb: add support for trac
 feature
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
 <20220905203412.1322947-10-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220905203412.1322947-10-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel, Alexander.

On 05.09.22 22:34, Miquel Raynal wrote:
> From: Alexander Aring <aahringo@redhat.com>
> 
> This patch adds support for reading the trac register if atusb firmware
> reports tx done. There is currently a feature to compare a sequence
> number, if the payload is 1 it tells the driver only the sequence number
> is available if it's two there is additional the trac status register as
> payload.
> 
> Currently the atusb_in_good() function determines if it's a tx done or
> rx done if according the payload length. This patch is doing the same
> and assumes this behaviour.
> 
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   drivers/net/ieee802154/atusb.c | 33 ++++++++++++++++++++++++++++-----
>   1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index 2c338783893d..95a4a3cdc8a4 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -191,7 +191,7 @@ static void atusb_work_urbs(struct work_struct *work)
>   
>   /* ----- Asynchronous USB -------------------------------------------------- */
>   
> -static void atusb_tx_done(struct atusb *atusb, u8 seq)
> +static void atusb_tx_done(struct atusb *atusb, u8 seq, int reason)
>   {
>   	struct usb_device *usb_dev = atusb->usb_dev;
>   	u8 expect = atusb->tx_ack_seq;
> @@ -199,7 +199,10 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
>   	dev_dbg(&usb_dev->dev, "%s (0x%02x/0x%02x)\n", __func__, seq, expect);
>   	if (seq == expect) {
>   		/* TODO check for ifs handling in firmware */
> -		ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
> +		if (reason == IEEE802154_SUCCESS)
> +			ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
> +		else
> +			ieee802154_xmit_error(atusb->hw, atusb->tx_skb, reason);
>   	} else {
>   		/* TODO I experience this case when atusb has a tx complete
>   		 * irq before probing, we should fix the firmware it's an
> @@ -215,7 +218,8 @@ static void atusb_in_good(struct urb *urb)
>   	struct usb_device *usb_dev = urb->dev;
>   	struct sk_buff *skb = urb->context;
>   	struct atusb *atusb = SKB_ATUSB(skb);
> -	u8 len, lqi;
> +	int result = IEEE802154_SUCCESS;
> +	u8 len, lqi, trac;
>   
>   	if (!urb->actual_length) {
>   		dev_dbg(&usb_dev->dev, "atusb_in: zero-sized URB ?\n");
> @@ -224,8 +228,27 @@ static void atusb_in_good(struct urb *urb)
>   
>   	len = *skb->data;
>   
> -	if (urb->actual_length == 1) {
> -		atusb_tx_done(atusb, len);
> +	switch (urb->actual_length) {
> +	case 2:
> +		trac = TRAC_MASK(*(skb->data + 1));
> +		switch (trac) {
> +		case TRAC_SUCCESS:
> +		case TRAC_SUCCESS_DATA_PENDING:
> +			/* already IEEE802154_SUCCESS */
> +			break;
> +		case TRAC_CHANNEL_ACCESS_FAILURE:
> +			result = IEEE802154_CHANNEL_ACCESS_FAILURE;
> +			break;
> +		case TRAC_NO_ACK:
> +			result = IEEE802154_NO_ACK;
> +			break;
> +		default:
> +			result = IEEE802154_SYSTEM_ERROR;
> +		}
> +
> +		fallthrough;
> +	case 1:
> +		atusb_tx_done(atusb, len, result);
>   		return;
>   	}
>   

There have been various RFC patches from either of you two on this. From 
what I can see this is the last one.

I am glad that this is done in a backwards compatible way, so it can 
keep working with the older v.03 firmware. See my comments on the 
firmware part of this in the other thread.

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BDB527965
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 21:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbiEOTRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 15:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiEOTRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 15:17:18 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AC311C31;
        Sun, 15 May 2022 12:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652642231;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=I0+5ZSWUjQAWtF8svedENW4Xdn6ychKP+GBcBBTY7oI=;
    b=Y10uMY+mZUS9DkBdjioTHnY9+6MLxLxKZkRU0uVZi1xkaugjNWDK1C1sNSmwkwstmO
    S9I4aEElqFxwxVqN6BJEqOxbXTO12inYGhpUAO306oPEVLVtgEbYiCgG6yzVhjWrt+IU
    X9YVLZGUimSbImwp8U9NGZAC/nVrrERZ3DBQX4+8/rzAdgLZk96Znj4T3Lez/bPU8+y8
    ZxQkGG4bjNPwJ7nyHiltm7XBoKM+H8eiFBLsSPoU2PNZms5Z1jCUqoP2LtSrMXYmzbQ0
    vYw4bWwuKQuYgjfNbPm7vE2GXvfrSrZAIuAyc1wop+5l+CODYnJYOGLuA0cBH9G5tjsi
    Xp4g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOug2krLFRKxw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b04::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4FJHA713
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 15 May 2022 21:17:10 +0200 (CEST)
Message-ID: <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
Date:   Sun, 15 May 2022 21:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 14.05.22 16:16, Vincent Mailhol wrote:
> The functions can_dropped_invalid_skb() and can_skb_headroom_valid()
> grew a lot over the years to a point which it does not make much sense
> to have them defined as static inline in header files. Move those two
> functions to the .c counterpart of skb.h.
> 
> can_skb_headroom_valid() only caller being can_dropped_invalid_skb(),
> the declaration is removed from the header. Only
> can_dropped_invalid_skb() gets its symbol exported.

I can see your point but the need for can-dev was always given for 
hardware specific stuff like bitrates, TDC, transceivers, whatever.

As there would be more things in slcan (e.g. dev_alloc_skb() could be 
unified with alloc_can_skb()) - would it probably make sense to 
introduce a new can-skb module that could be used by all CAN 
virtual/software interfaces?

Or some other split-up ... any idea?

Best regards,
Oliver

> 
> While doing so, do a small cleanup: add brackets around the else block
> in can_dropped_invalid_skb().
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>   drivers/net/can/dev/skb.c | 58 ++++++++++++++++++++++++++++++++++++++
>   include/linux/can/skb.h   | 59 +--------------------------------------
>   2 files changed, 59 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
> index 61660248c69e..8b1991130de5 100644
> --- a/drivers/net/can/dev/skb.c
> +++ b/drivers/net/can/dev/skb.c
> @@ -252,3 +252,61 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
>   	return skb;
>   }
>   EXPORT_SYMBOL_GPL(alloc_can_err_skb);
> +
> +/* Check for outgoing skbs that have not been created by the CAN subsystem */
> +static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
> +{
> +	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
> +	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
> +		return false;
> +
> +	/* af_packet does not apply CAN skb specific settings */
> +	if (skb->ip_summed == CHECKSUM_NONE) {
> +		/* init headroom */
> +		can_skb_prv(skb)->ifindex = dev->ifindex;
> +		can_skb_prv(skb)->skbcnt = 0;
> +
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +
> +		/* perform proper loopback on capable devices */
> +		if (dev->flags & IFF_ECHO)
> +			skb->pkt_type = PACKET_LOOPBACK;
> +		else
> +			skb->pkt_type = PACKET_HOST;
> +
> +		skb_reset_mac_header(skb);
> +		skb_reset_network_header(skb);
> +		skb_reset_transport_header(skb);
> +	}
> +
> +	return true;
> +}
> +
> +/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
> +bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
> +{
> +	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
> +
> +	if (skb->protocol == htons(ETH_P_CAN)) {
> +		if (unlikely(skb->len != CAN_MTU ||
> +			     cfd->len > CAN_MAX_DLEN))
> +			goto inval_skb;
> +	} else if (skb->protocol == htons(ETH_P_CANFD)) {
> +		if (unlikely(skb->len != CANFD_MTU ||
> +			     cfd->len > CANFD_MAX_DLEN))
> +			goto inval_skb;
> +	} else {
> +		goto inval_skb;
> +	}
> +
> +	if (!can_skb_headroom_valid(dev, skb))
> +		goto inval_skb;
> +
> +	return false;
> +
> +inval_skb:
> +	kfree_skb(skb);
> +	dev->stats.tx_dropped++;
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(can_dropped_invalid_skb);
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index fdb22b00674a..182749e858b3 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -31,6 +31,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
>   				struct canfd_frame **cfd);
>   struct sk_buff *alloc_can_err_skb(struct net_device *dev,
>   				  struct can_frame **cf);
> +bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
>   
>   /*
>    * The struct can_skb_priv is used to transport additional information along
> @@ -96,64 +97,6 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
>   	return nskb;
>   }
>   
> -/* Check for outgoing skbs that have not been created by the CAN subsystem */
> -static inline bool can_skb_headroom_valid(struct net_device *dev,
> -					  struct sk_buff *skb)
> -{
> -	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
> -	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
> -		return false;
> -
> -	/* af_packet does not apply CAN skb specific settings */
> -	if (skb->ip_summed == CHECKSUM_NONE) {
> -		/* init headroom */
> -		can_skb_prv(skb)->ifindex = dev->ifindex;
> -		can_skb_prv(skb)->skbcnt = 0;
> -
> -		skb->ip_summed = CHECKSUM_UNNECESSARY;
> -
> -		/* perform proper loopback on capable devices */
> -		if (dev->flags & IFF_ECHO)
> -			skb->pkt_type = PACKET_LOOPBACK;
> -		else
> -			skb->pkt_type = PACKET_HOST;
> -
> -		skb_reset_mac_header(skb);
> -		skb_reset_network_header(skb);
> -		skb_reset_transport_header(skb);
> -	}
> -
> -	return true;
> -}
> -
> -/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
> -static inline bool can_dropped_invalid_skb(struct net_device *dev,
> -					  struct sk_buff *skb)
> -{
> -	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
> -
> -	if (skb->protocol == htons(ETH_P_CAN)) {
> -		if (unlikely(skb->len != CAN_MTU ||
> -			     cfd->len > CAN_MAX_DLEN))
> -			goto inval_skb;
> -	} else if (skb->protocol == htons(ETH_P_CANFD)) {
> -		if (unlikely(skb->len != CANFD_MTU ||
> -			     cfd->len > CANFD_MAX_DLEN))
> -			goto inval_skb;
> -	} else
> -		goto inval_skb;
> -
> -	if (!can_skb_headroom_valid(dev, skb))
> -		goto inval_skb;
> -
> -	return false;
> -
> -inval_skb:
> -	kfree_skb(skb);
> -	dev->stats.tx_dropped++;
> -	return true;
> -}
> -
>   static inline bool can_is_canfd_skb(const struct sk_buff *skb)
>   {
>   	/* the CAN specific type of skb is identified by its data length */

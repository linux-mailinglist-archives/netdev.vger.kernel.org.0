Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87052333D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbiEKMir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiEKMiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:38:46 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5209722EA5F;
        Wed, 11 May 2022 05:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652272719;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3R1nyN7qEurI7mKVx7fVNCCwr1ntHBiV1xbhlFCvjRM=;
    b=DiUzy4XK9JglPAKp58efIOGrWW9GhTsNGo6Pxl/cUe76D7l9JZXWD81dtsA110wv3I
    Tk6dchEclVKI4PpBf1bgJDIfFozpkaOqNx0rStDUbsQLjM+0yQeVGaBSRF4ESYZ6IXA3
    RjXOgee6Nu7+1CBSz5vjMWMTwT1ISb8dhvtYWGpGcC5DPYN8yQCHRTBq9IrEweAopXFw
    pOoZHXnMjgwkLil2WGORwJ3ZORswfXizK9PsPkGZT0FRDVGdbbLnrrQIbt7tjovJQeBb
    nD+SmdHRGazh5J39MinuSMv/GalS14MTOuoJtZr1MMZv9Cue/avwGlA9X5D8qvqj1ncb
    BUDw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2koeKQvJnLjhchY2TXGXhEF98MlNg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00:9642:f755:5daa:777e]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y4BCcdy2r
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 11 May 2022 14:38:39 +0200 (CEST)
Message-ID: <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
Date:   Wed, 11 May 2022 14:38:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220511121913.2696181-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 5/11/22 14:19, Oleksij Rempel wrote:
> Add new can_skb_priv::local_origin flag to be able detect egress
> packages even if they was sent directly from kernel and not assigned to
> some socket.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
> ---
>   drivers/net/can/dev/skb.c | 3 +++
>   include/linux/can/skb.h   | 1 +
>   net/can/raw.c             | 2 +-
>   3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
> index 61660248c69e..3e2357fb387e 100644
> --- a/drivers/net/can/dev/skb.c
> +++ b/drivers/net/can/dev/skb.c
> @@ -63,6 +63,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
>   
>   		/* save frame_len to reuse it when transmission is completed */
>   		can_skb_prv(skb)->frame_len = frame_len;
> +		can_skb_prv(skb)->local_origin = true;
>   
>   		skb_tx_timestamp(skb);
>   
> @@ -200,6 +201,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
>   	can_skb_reserve(skb);
>   	can_skb_prv(skb)->ifindex = dev->ifindex;
>   	can_skb_prv(skb)->skbcnt = 0;
> +	can_skb_prv(skb)->local_origin = false;
>   
>   	*cf = skb_put_zero(skb, sizeof(struct can_frame));
>   
> @@ -231,6 +233,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
>   	can_skb_reserve(skb);
>   	can_skb_prv(skb)->ifindex = dev->ifindex;
>   	can_skb_prv(skb)->skbcnt = 0;
> +	can_skb_prv(skb)->local_origin = false;

IMO this patch does not work as intended.

You probably need to revisit every place where can_skb_reserve() is 
used, e.g. in raw_sendmsg().

E.g. to make it work for virtual CAN and vxcan interfaces.

I'm a bit unsure why we should not stick with the simple skb->sk handling?

Regards,
Oliver

>   
>   	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
>   
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index fdb22b00674a..1b8a8cf2b13b 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -52,6 +52,7 @@ struct can_skb_priv {
>   	int ifindex;
>   	int skbcnt;
>   	unsigned int frame_len;
> +	bool local_origin;
>   	struct can_frame cf[];
>   };
>   
> diff --git a/net/can/raw.c b/net/can/raw.c
> index b7dbb57557f3..df2d9334b395 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -173,7 +173,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
>   	/* add CAN specific message flags for raw_recvmsg() */
>   	pflags = raw_flags(skb);
>   	*pflags = 0;
> -	if (oskb->sk)
> +	if (can_skb_prv(skb)->local_origin)
>   		*pflags |= MSG_DONTROUTE;
>   	if (oskb->sk == sk)
>   		*pflags |= MSG_CONFIRM;

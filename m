Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D72543DA3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiFHUjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiFHUjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:39:13 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23695B0A79;
        Wed,  8 Jun 2022 13:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654720732;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=vPC4nYdjhDqJ8lKsGfPtKW79duI66lmrks2vdSL6r3Y=;
    b=UW3vqTqcFxaeo7mDo6EzjHifIGYUVVMlaRhMzwfOKmAR22mqvvTs/vkEECsc9GSe6R
    kzZTguFrFj16iTBnNCIaz5dKaU3pJj8AbIIHLdMTTJbKUtOY9MLSWWNjMwx7ps8HY+Bi
    M3vCH0obg++w/lTcwf2p8gw2JyXhLje3aDbTbTFDwfDUuWnzctG8+MkdiFrvo5hsDPp/
    6fxze/6FNVL9RAgp7IOQyEGwcMeM19HxkXaGB3XzgO7gn6h/f5yPB3exUhTG2Pmb+lTo
    zCa0Cjo++o60RmAgixyl+Wp/CTXnbQsQP3MM9rECobLugpmGxzBe85V0h4whUfRLVFyR
    ZFYw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofov4eKO8Kg=="
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy58KcoC46
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 8 Jun 2022 22:38:50 +0200 (CEST)
Subject: Re: [PATCH v2 05/13] can: slcan: simplify the device de-allocation
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
 <20220608165116.1575390-6-dario.binacchi@amarulasolutions.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <eae65531-bf9f-4e2e-97ca-a79a8aa833fc@hartkopp.net>
Date:   Wed, 8 Jun 2022 22:38:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220608165116.1575390-6-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch (at least) needs some rework.

The patch cf124db566e6b036 ("net: Fix inconsistent teardown and release 
of private netdev state.") from DaveM added some priv_destructor

     dev->priv_destructor = sl_free_netdev;

which is not taken into account in this patch.

As written before I would like to discuss this change out of your patch 
series "can: slcan: extend supported features" as it is no slcan feature 
extension AND has to be synchronized with the drivers/net/slip/slip.c 
implementation.

When it has not real benefit and introduces more code and may create 
side effects, this beautification should probably be omitted at all.

Thanks,
Oliver

On 08.06.22 18:51, Dario Binacchi wrote:
> Since slcan_devs array contains the addresses of the created devices, I
> think it is more natural to use its address to remove it from the list.
> It is not necessary to store the index of the array that points to the
> device in the driver's private data.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
> 
> (no changes since v1)
> 
>   drivers/net/can/slcan.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 929cb55e08af..cf05c30b8da5 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -432,11 +432,17 @@ static int slc_open(struct net_device *dev)
>   
>   static void slc_dealloc(struct slcan *sl)
>   {
> -	int i = sl->dev->base_addr;
> +	unsigned int i;
>   
> -	free_candev(sl->dev);
> -	if (slcan_devs)
> -		slcan_devs[i] = NULL;
> +	for (i = 0; i < maxdev; i++) {
> +		if (sl->dev == slcan_devs[i]) {
> +			free_candev(sl->dev);
> +			slcan_devs[i] = NULL;
> +			return;
> +		}
> +	}
> +
> +	pr_err("slcan: can't free %s resources\n",  sl->dev->name);
>   }
>   
>   static int slcan_change_mtu(struct net_device *dev, int new_mtu)
> @@ -533,7 +539,6 @@ static struct slcan *slc_alloc(void)
>   
>   	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
>   	dev->netdev_ops = &slc_netdev_ops;
> -	dev->base_addr  = i;
>   	sl = netdev_priv(dev);
>   
>   	/* Initialize channel control data */
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444C05BCD06
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiISNXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiISNXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:23:52 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF13E2CCAD
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:23:50 -0700 (PDT)
Received: (qmail 14798 invoked from network); 19 Sep 2022 13:24:11 -0000
Received: from p200300cf070fe30076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70f:e300:76d4:35ff:feb7:be92]:34684 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <davem@davemloft.net>; Mon, 19 Sep 2022 15:24:11 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Sean Anderson <seanga2@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Sean Anderson <seanga2@gmail.com>
Subject: Re: [PATCH net-next 11/13] sunhme: Combine continued messages
Date:   Mon, 19 Sep 2022 15:23:46 +0200
Message-ID: <14992029.3CObj9AJNb@eto.sf-tec.de>
In-Reply-To: <20220918232626.1601885-12-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com> <20220918232626.1601885-12-seanga2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1735805.g2cWb5fM6b"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1735805.g2cWb5fM6b
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH net-next 11/13] sunhme: Combine continued messages
Date: Mon, 19 Sep 2022 15:23:46 +0200
Message-ID: <14992029.3CObj9AJNb@eto.sf-tec.de>
In-Reply-To: <20220918232626.1601885-12-seanga2@gmail.com>
MIME-Version: 1.0

Am Montag, 19. September 2022, 01:26:24 CEST schrieb Sean Anderson:
> This driver seems to have been written under the assumption that messages
> can be continued arbitrarily. I'm not when this changed (if ever), but such
> ad-hoc continuations are liable to be rudely interrupted. Convert all such
> instances to single prints. This loses a bit of timing information (such as
> when a line was constructed piecemeal as the function executed), but it's
> easy to add a few prints if necessary. This also adds newlines to the ends
> of any prints without them.

I have a similar patch around, but yours catches more places.

> diff --git a/drivers/net/ethernet/sun/sunhme.c
> b/drivers/net/ethernet/sun/sunhme.c index 98c38e213bab..9965c9c872a6 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -330,7 +331,6 @@ static int happy_meal_bb_read(struct happy_meal *hp,
>  	int retval = 0;
>  	int i;
> 
> -	ASD("happy_meal_bb_read: reg=%d ", reg);
> 
>  	/* Enable the MIF BitBang outputs. */
>  	hme_write32(hp, tregs + TCVR_BBOENAB, 1);

You can remove one of the empty lines here.

> @@ -1196,15 +1182,15 @@ static void happy_meal_init_rings(struct happy_meal
> *hp) struct hmeal_init_block *hb = hp->happy_block;
>  	int i;
> 
> -	HMD("happy_meal_init_rings: counters to zero, ");
> +	HMD("counters to zero\n");
>  	hp->rx_new = hp->rx_old = hp->tx_new = hp->tx_old = 0;
> 
>  	/* Free any skippy bufs left around in the rings. */
> -	HMD("clean, ");
> +	HMD("clean\n");

I don't think this one is actually needed, there isn't much than can happen in 
between these 2 prints.

> @@ -1282,17 +1268,11 @@ happy_meal_begin_auto_negotiation(struct happy_meal
> *hp, * XXX so I completely skip checking for it in the BMSR for now. */
> 
> -#ifdef AUTO_SWITCH_DEBUG
> -		ASD("%s: Advertising [ ");
> -		if (hp->sw_advertise & ADVERTISE_10HALF)
> -			ASD("10H ");
> -		if (hp->sw_advertise & ADVERTISE_10FULL)
> -			ASD("10F ");
> -		if (hp->sw_advertise & ADVERTISE_100HALF)
> -			ASD("100H ");
> -		if (hp->sw_advertise & ADVERTISE_100FULL)
> -			ASD("100F ");
> -#endif
> +		ASD("Advertising [ %s%s%s%s]\n",
> +		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
> +		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
> +		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
> +		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : 
"");
> 
>  		/* Enable Auto-Negotiation, this is usually on 
already... */
>  		hp->sw_bmcr |= BMCR_ANENABLE;

Completely independent of this driver, but I wonder if there is no generic 
function to print these 10/100/* full/half duplex strings? There are several 
drivers doing this as a quick grep shows.

Eike
--nextPart1735805.g2cWb5fM6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYyhtYwAKCRBcpIk+abn8
TvVeAJ91F4hWkWpO9XheZpyJjHFLNBXP9gCeLBuiqlPLLsMyu7mUbZrevXOXdAQ=
=3qv+
-----END PGP SIGNATURE-----

--nextPart1735805.g2cWb5fM6b--




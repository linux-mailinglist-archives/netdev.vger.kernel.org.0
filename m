Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184FA63CEAE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiK3FXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiK3FXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:23:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9997221E37;
        Tue, 29 Nov 2022 21:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F01619D7;
        Wed, 30 Nov 2022 05:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E94C433D6;
        Wed, 30 Nov 2022 05:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785789;
        bh=0uiCT7VW9vnoouUwDIR7IEw9jHQ41V4i1Lzazd87aZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ptiddjqe2YckLqGBnIGFCW5KfSUn2KCDa3ljKvUWPPmsbWsRoZ3fU1z63Vnm3srAX
         T/34TtNlnXRKdFGCXmnV6z6fGaM2PQezlN1C2a8kEge4ii/2I4uUI6bnRPIu51ifJI
         eMQsjyobhYP1YgofXCFtlNPBFrYu9oKc362i/6rAifH1d6VpqC089HWLBAq2U+HR7L
         Mx7cpKrSlC2Oe7I7Te12UdiwJPDhSJL/YLzPtvPeQaOUajvtrS0iUJjooryCwu3rmI
         Uk/gN1wM3Uph5w8leUjJ5VGuBlCmk7BUlM5YdDlfW/YWo2+WMj3JvN99sGJSj4G/lJ
         TUvIwzVQlF+bg==
Date:   Tue, 29 Nov 2022 21:23:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksandr Burakov <a.burakov@rosalinux.ru>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] liquidio: avoid NULL pointer dereference in
 lio_vf_rep_copy_packet()
Message-ID: <20221129212307.2b2b4fc0@kernel.org>
In-Reply-To: <20221128102659.4946-1-a.burakov@rosalinux.ru>
References: <20221128102659.4946-1-a.burakov@rosalinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 13:26:59 +0300 Aleksandr Burakov wrote:
> --- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
> @@ -272,13 +272,12 @@ lio_vf_rep_copy_packet(struct octeon_device *oct,
>  				pg_info->page_offset;
>  			memcpy(skb->data, va, MIN_SKB_SIZE);
>  			skb_put(skb, MIN_SKB_SIZE);
> +			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> +					pg_info->page,
> +					pg_info->page_offset + MIN_SKB_SIZE,
> +					len - MIN_SKB_SIZE,
> +					LIO_RXBUFFER_SZ);
>  		}
> -
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> -				pg_info->page,
> -				pg_info->page_offset + MIN_SKB_SIZE,
> -				len - MIN_SKB_SIZE,
> -				LIO_RXBUFFER_SZ);
>  	} else {
>  		struct octeon_skb_page_info *pg_info =
>  			((struct octeon_skb_page_info *)(skb->cb));

The else branch also looks at pg_info and derefs page like there's 
no tomorrow. You need to put a bit more effort into the analysis.

Marvell people please chime in and tell us what the intention is here.
Whether page can be NULL here or this is defensive programming and can
be dropped.

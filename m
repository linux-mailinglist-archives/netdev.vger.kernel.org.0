Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68DA633B30
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiKVLVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiKVLUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:20:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD74756D5F;
        Tue, 22 Nov 2022 03:16:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928B4B81A19;
        Tue, 22 Nov 2022 11:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD58C433C1;
        Tue, 22 Nov 2022 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669115775;
        bh=RWVuynQJHu6UtzfhI2bzUBNkk6dsjJgeNdwxgSTyLTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWle+BsPZDh9ljE/DC0N3F6yPpoFQ3SgUM8PY2pWl76Yrwu4JlGEfe2YKW3vvdPCJ
         Oq3glimLyPLX+dl3nC6Pj0ynuZaQyKVdhTXcRGkJ1kR9AMlJq7KCZtPDRFh0NfFF8R
         1CZJHv0Sp/ROzpDYl5mMPrYV356CE7bPSkyHNQ4/C46T9Gu5uHeE5KGI0y5+zeTo16
         Vnkg4y+9SxM3Ge4cwCU64upbMvPVd5nWk5nZGy4xYRjAwYMh13jWniXUCmUu5Q3VVd
         mWJBrBHGoxRvYKg8eQXO7TCv4yTYbfdtApwjPApFS0+HSRFXt1JO+ueYySqnDk5twK
         uC6HRb6aW5a+g==
Date:   Tue, 22 Nov 2022 13:16:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: Re: [PATCH net v3] nfp: flower: Added pointer check and continue
Message-ID: <Y3yve5ld6KSj4GyU@unreal>
References: <20221118080317.119749-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118080317.119749-1-arefev@swemel.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 11:03:17AM +0300, Denis Arefev wrote:
> Return value of a function 'kmalloc_array' is dereferenced at 
> lag_conf.c:347 without checking for null, 
> but it is usually checked for this function.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> Fixes: bb9a8d031140 ("nfp: flower: monitor and offload LAG groups")
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/lag_conf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

<...>

>  		acti_netdevs = kmalloc_array(entry->slave_cnt,
>  					     sizeof(*acti_netdevs), GFP_KERNEL);
> +		if (!acti_netdevs) {
> +			schedule_delayed_work(&lag->work, NFP_FL_LAG_DELAY);
> +			continue;

It is usually not good idea to continue after memory allocation fails.
So or add __GFP_NOWARN with a comment why it is safe to continue or bail
out from this loop.

Thanks

> +		}
>  
>  		/* Include sanity check in the loop. It may be that a bond has
>  		 * changed between processing the last notification and the
> -- 
> 2.25.1
> 

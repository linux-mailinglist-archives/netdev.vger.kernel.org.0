Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0091528D01
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbiEPS2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344848AbiEPS2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:28:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8FB3DDD9
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24A04B81283
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461FAC34100;
        Mon, 16 May 2022 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652725698;
        bh=rpjwu6B29gAsk0yHuJ2pynp0nzoU2nqj+1rcF8rqQwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RMHuw9RiYXwsb5bRg1ukk6FgT8Z2wkX683xYN0jOLhjlST/iUA+cf4IJMDPWPsoJj
         EWmeVNDHB62e8Sbgn88Gm0jd+EHrt2ur/4IJskZaG0eWGnT2UWYB7qPZ5DRDAhI1rd
         GFy6uz0040llKnCfovt/8HKo7TYpiqoxojNZfZmF11QmJdZRIiChiVIOW/Hw2wRbuB
         g0TURr7Z7xVV7nhFFrZMBU5QevILKb2uLV5ehomLMpQwdT1IdxXpr5CaT3YGQYJqUG
         uVyfD62s3CDIWlbLvdF5Tl3O/3tW0umpL2/3rKJLhr7BalAgNCd+t9CjLMMC8scPz7
         AiSKPs9WGeFYA==
Date:   Mon, 16 May 2022 11:28:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <Sunil.Goutham@cavium.com>,
        <hkelam@marvell.com>, <colin.king@intel.com>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH V2] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Message-ID: <20220516112817.4f7d99cf@kernel.org>
In-Reply-To: <20220516105359.746919-1-sumang@marvell.com>
References: <20220516105359.746919-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 16:23:59 +0530 Suman Ghosh wrote:
> @@ -1230,7 +1262,7 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
>  
>  static const struct ethtool_ops otx2_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> -				     ETHTOOL_COALESCE_MAX_FRAMES,
> +				     ETHTOOL_COALESCE_MAX_FRAMES | ETHTOOL_COALESCE_USE_ADAPTIVE,

Ah there it is. Now you actually tested it with upstream :/

Please wrap the line.

Also please reject user trying to set asymmetric adaptive mode since
you don't seem to support it:

> +	/* Check and update coalesce status */
> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
> +			OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
> +		priv_coalesce_status = 1;
> +		if (!ec->use_adaptive_rx_coalesce || !ec->use_adaptive_tx_coalesce)
> +			pfvf->flags &= ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
> +	} else {
> +		priv_coalesce_status = 0;
> +		if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)
> +			pfvf->flags |= OTX2_FLAG_ADPTV_INT_COAL_ENABLED;

If I'm reading this right user doing:

ethtool -C eth0 adaptive-rx on adaptive-tx off

multiple times will keep switching between adaptive and non-adaptive
mode. This will be super confusing to automation which may assume
configuration commands are idempotent.

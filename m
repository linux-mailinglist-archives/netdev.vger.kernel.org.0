Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA722646836
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLHEVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLHEVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BF694910;
        Wed,  7 Dec 2022 20:21:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B704E61D51;
        Thu,  8 Dec 2022 04:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EF9C433C1;
        Thu,  8 Dec 2022 04:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473282;
        bh=l5UOLEKuYmhE4eDA/7viGkwppvnNQbHO0UIFUfLOG0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EGhzVM9yUjfJB33ZZvJYcq9lywEhzWjCDfvT7cM3t8/EV1Ez7IX6eCaKs+oNkjkvh
         n4A08huazr1QG7V5z/oeW9rIIAffpCtbWmexwQnGqHLwYtWqHZDRq+TMYkcEeLOwUw
         5G05Xa4oKFUOuE8nJfDyD01U+4f8pTkaHZfugcfNuO4S7/DsX9ol62fDnlbnbORn4H
         Ud0ytP79jkwys51AiZS5poJokOBSLXhdRNK74oAmCi/5IP6N9MEIbCLrLt/GpcmQob
         DX9aWJfuNMdX7j8/YeWrnWeAFMj6HkcMbzcd64I9l3LZ+9/lgnrwyvPhcffLQrWM1w
         0GbCUZjWrT69g==
Date:   Wed, 7 Dec 2022 20:21:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, andrew@lunn.ch,
        edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Message-ID: <20221207202120.12bc7c33@kernel.org>
In-Reply-To: <20221206094419.19478-5-rogerq@kernel.org>
References: <20221206094419.19478-1-rogerq@kernel.org>
        <20221206094419.19478-5-rogerq@kernel.org>
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

On Tue,  6 Dec 2022 11:44:17 +0200 Roger Quadros wrote:
>  	ret = pm_runtime_resume_and_get(common->dev);
>  	if (ret < 0)
>  		return ret;
>  
> +	/* Idle MAC port */
> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
> +	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
> +
> +	/* soft reset MAC */
> +	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
> +	mdelay(1);
> +	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
> +	if (reg) {
> +		dev_err(common->dev, "soft RESET didn't complete\n");
> +		return -ETIMEDOUT;

Doesn't this function leak power management references on almost all
error paths? Not really related to this set, tho.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDE6D2E35
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbjDAEwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAEwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DFC1A971
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4ED5B83366
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD8C433EF;
        Sat,  1 Apr 2023 04:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680324729;
        bh=CTHmETSBpQXECuaioTNrKO/5ZCejG5AjQ0MF5/YRxjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mGzTLprJyRqVjuBwPjZR5SZoHpVEnK0diqYhvKbXLCHBV77waNdUglTToAoZfgyfn
         GUhuP851Se1B1YYOMb5wc0LOhqT1wGcGSLMS8W4AMXnE50Z01EYfM1uCAtHC9PexsN
         sy8cKHV2Vkx3M19x28kEl0frcCDFLkN3CadDut5GU4c3yGQN2y7Uh5Y3fxvieONbgK
         UP3gBc9FUPm2iH10LOMqsNiXcPXjmgOg8rxzai0MF68WL1TQeDFib6lke9Bnbns91i
         wiXQQGVjGXsEXT5ALsnsOYoT/ol24l4i7/GShKsL2mX8Y0gkGG1It6H4QvIdY+GeXo
         h+fm18T4mElMQ==
Date:   Fri, 31 Mar 2023 21:52:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: publish actual MTU restriction
Message-ID: <20230331215208.66d867ff@kernel.org>
In-Reply-To: <20230331092344.268981-1-vinschen@redhat.com>
References: <20230331092344.268981-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 11:23:44 +0200 Corinna Vinschen wrote:
> Fixes: 2618abb73c895 ("stmmac: Fix kernel crashes for jumbo frames")
> Fixes: a2cd64f30140c ("net: stmmac: fix maxmtu assignment to be within valid range")
> Fixes: ebecb860ed228 ("net: stmmac: pci: Add HAPS support using GMAC5")
> Fixes: 58da0cfa6cf12 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
> Fixes: 30bba69d7db40 ("stmmac: pci: Add dwmac support for Loongson")

I'm not sure if we need fixes tags for this.
Are any users depending on the advertised values being exactly right?

> +	/* stmmac_change_mtu restricts MTU to queue size.
> +	 * Set maxmtu accordingly, if it hasn't been set from DT.
> +	 */
> +	if (priv->plat->maxmtu == 0) {
> +		priv->plat->maxmtu = priv->plat->tx_fifo_size ?:
> +				     priv->dma_cap.tx_fifo_size;
> +		priv->plat->maxmtu /= priv->plat->tx_queues_to_use;

tx_queues_to_use may change due to reconfiguration, no?
What will happen then?

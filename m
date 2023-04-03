Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453446D4DD4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbjDCQbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjDCQbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39951722
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799196216E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 16:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EE6C433D2;
        Mon,  3 Apr 2023 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680539412;
        bh=IojUXSBwNV9/xiyji0hBNA2uqcp0xJCVspu8hSwhpnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ie8qOgOB6MXntl7gLdW75Km1KgVTWGG52nKFwUAfFogArP/NME/rqWRMgA9t6zBOi
         4v1FOzKVbd5dYSWO3qeWv0Ozmdu77vXJv2b9xwqzqk1QRyD1HC8UQkXyt00Ol2lqVk
         5cGJFiDXKQKV7Ncz/XDGAaE+esVSogXho0iFBjrIOtyjVSvPfspTqXz8Dazw3wIEMt
         JOLbanI6lnraoBs3o5uRAH55N39McApmOd6aKhhSaRJXf2WEU5yhqJlZ2O3kSLRbPJ
         PvX9WN6744h0qQmJ04dWQxD6Flq1YoZhVBxDnZ8eeUGWyHjIZBZPKenhigQPvHF4k1
         jJunXlB3D23Sg==
Date:   Mon, 3 Apr 2023 09:30:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: publish actual MTU restriction
Message-ID: <20230403093011.27545760@kernel.org>
In-Reply-To: <ZCqYbMOEg9LvgcWZ@calimero.vinschen.de>
References: <20230331092344.268981-1-vinschen@redhat.com>
        <20230331215208.66d867ff@kernel.org>
        <ZCqYbMOEg9LvgcWZ@calimero.vinschen.de>
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

On Mon, 3 Apr 2023 11:12:12 +0200 Corinna Vinschen wrote:
> > Are any users depending on the advertised values being exactly right?  
> 
> The max MTU is advertised per interface:
> 
> p -d link show dev enp0s29f1
> 2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether [...] promiscuity 0 minmtu 46 maxmtu 9000 [...]
> 
> So the idea is surely that the user can check it and then set the MTU
> accordingly.  If the interface claims a max MTU of 9000, the expectation
> is that setting the MTU to this value just works, right?
> 
> So isn't it better if the interface only claims what it actually supports,
> i. .e, 
> 
>   # ip -d link show dev enp0s29f1
>   2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>       link/ether [...] promiscuity 0 minmtu 46 maxmtu 4096 [...]
> 
> ?

No doubt that it's better to be more precise.

The question is what about drivers which can't support full MTU with
certain features enabled. So far nobody has been updating the max MTU
dynamically, to my knowledge, so the max MTU value is the static max
under best conditions.

> > > +	/* stmmac_change_mtu restricts MTU to queue size.
> > > +	 * Set maxmtu accordingly, if it hasn't been set from DT.
> > > +	 */
> > > +	if (priv->plat->maxmtu == 0) {
> > > +		priv->plat->maxmtu = priv->plat->tx_fifo_size ?:
> > > +				     priv->dma_cap.tx_fifo_size;
> > > +		priv->plat->maxmtu /= priv->plat->tx_queues_to_use;  
> > 
> > tx_queues_to_use may change due to reconfiguration, no?
> > What will happen then?  
> 
> Nothing.  tx_fifo_size is tx_queues_to_use multiplied by the size of the
> queue.  All the above code does is to compute the size of the queues,
> which is a fixed value limiting the size of the MTU.  It's the same
> check the stmmac_change_mtu() function performs to allow or deny the MTU
> change, basically:
> 
>   txfifosz = priv->plat->tx_fifo_size;
>   if (txfifosz == 0)
>     txfifosz = priv->dma_cap.tx_fifo_size;
>   txfifosz /= priv->plat->tx_queues_to_use;
>   if (txfifosz < new_mtu)
>     return -EINVAL;

I haven't looked at the code in detail but if we start with
tx_queues_to_use = 4 and lower it via ethtool -L, won't that
make the core prevent setting higher MTU even tho the driver
would have supported it previously?

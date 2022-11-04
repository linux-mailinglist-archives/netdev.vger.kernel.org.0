Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E7F619BAC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiKDPcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiKDPce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:32:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534D52793F;
        Fri,  4 Nov 2022 08:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mT0boajW4GkaMWXjn2Ik44yi9m1XKFhaBoFguDvv3vg=; b=0aKDagYd+Mxgi/Pvo5mkjonGNN
        80IH8gS04w8qq49ppCPCtcvQmc2osfp0F7g8wTOnEs1Psnx0T1GX9I8Ds0sw8bAnL6lSw9f1YMt/g
        IhWxsymy8N0NipH+eiJrZn9aVbbtTeGrmkGuCrC8mvoIh1AQ2KtQrTL5AiLr5O9mjqYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqyfw-001RMg-PA; Fri, 04 Nov 2022 16:32:08 +0100
Date:   Fri, 4 Nov 2022 16:32:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriranjani P <sriranjani.p@samsung.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chandrasekar R <rcsekar@samsung.com>,
        Suresh Siddha <ssiddha@tesla.com>
Subject: Re: [PATCH 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
Message-ID: <Y2UweBsUDvrU9keT@lunn.ch>
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
 <CGME20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061@epcas5p4.samsung.com>
 <20221104120517.77980-3-sriranjani.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104120517.77980-3-sriranjani.p@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For FSD SoC, a mux switch is needed between internal and external clocks.
> By default after reset internal clock is used but for receiving packets
> properly, external clock is needed. Mux switch to external clock happens
> only when the external clock is present.


> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3831,6 +3831,9 @@ static int __stmmac_open(struct net_device *dev,
>  	netif_tx_start_all_queues(priv->dev);
>  	stmmac_enable_all_dma_irq(priv);
>  
> +	if (priv->plat->rxmux_setup)
> +		priv->plat->rxmux_setup(priv->plat->bsp_priv, true);
> +
>  	return 0;
>  
>  irq_error:
> @@ -3884,6 +3887,9 @@ static int stmmac_release(struct net_device *dev)
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	u32 chan;
>  
> +	if (priv->plat->rxmux_setup)
> +		priv->plat->rxmux_setup(priv->plat->bsp_priv, false);
> +

Is this the code which is deciding if the external clock is present? So when somebody called
'ip link set eth42 up'?

Where is the external clock coming from?

      Andrew

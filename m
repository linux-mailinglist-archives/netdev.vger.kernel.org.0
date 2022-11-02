Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638EE615697
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiKBAjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiKBAjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:39:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285F113E9A;
        Tue,  1 Nov 2022 17:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qQxXu7ttGxxUoXebcOqmefuwi+P5nyVPoWVHc73yfio=; b=MIP+Jq2Wgq7MLFwuE9cMuFvhF8
        SY1tIAlQLkHEFnKuIJ3jEKRYfd6Aus85plggtVs9YfWUJNZntTsZoIlHdE0j7AmWc9koeQx75uSKf
        rmvqY1p7nidGUkyZQXr7c2qNiUCFnECdAOY9JmAM5zEYuZja6D7FnIPJV+p5A7gdpSj4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq1nE-0019Ut-2Q; Wed, 02 Nov 2022 01:39:44 +0100
Date:   Wed, 2 Nov 2022 01:39:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
Subject: Re: [PATCH v2 net-next 2/3] net: axienet: set mdio clock according
 to bus-frequency
Message-ID: <Y2G8UMKSOadW8/5P@lunn.ch>
References: <20221101010146.900008-1-andy.chiu@sifive.com>
 <20221101010146.900008-3-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101010146.900008-3-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  #include "xilinx_axienet.h"
>  
>  #define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
> +#define MDIO_CLK_DIV_MASK	0x3f /* bits[5:0] */

XAE_MDIO_MC_CLOCK_DIVIDE_MAX ??

> +static int axienet_mdio_enable(struct axienet_local *lp, struct device_node *np)
>  {
> +	u32 clk_div;
>  	u32 host_clock;
> +	u32 mdio_freq = MAX_MDIO_FREQ;

Reverse Christmas tree.

>  
>  	lp->mii_clk_div = 0;
>  
> @@ -184,6 +188,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
>  			    host_clock);
>  	}
>  
> +	if (np)
> +		of_property_read_u32(np, "clock-frequency", &mdio_freq);
> +	if (mdio_freq != MAX_MDIO_FREQ)
> +		netdev_info(lp->ndev, "Setting non-standard mdio bus frequency to %u Hz\n",
> +			    mdio_freq);
> +
>  	/* clk_div can be calculated by deriving it from the equation:
>  	 * fMDIO = fHOST / ((1 + clk_div) * 2)
>  	 *
> @@ -209,13 +219,20 @@ static int axienet_mdio_enable(struct axienet_local *lp)
>  	 * "clock-frequency" from the CPU
>  	 */
>  
> -	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
> +	clk_div = (host_clock / (mdio_freq * 2)) - 1;
>  	/* If there is any remainder from the division of
> -	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
> +	 * fHOST / (mdio_freq * 2), then we need to add
>  	 * 1 to the clock divisor or we will surely be above 2.5 MHz
>  	 */
> -	if (host_clock % (MAX_MDIO_FREQ * 2))
> -		lp->mii_clk_div++;
> +	if (host_clock % (mdio_freq * 2))
> +		clk_div++;
> +
> +	/* Check for overflow of mii_clk_div */
> +	if (clk_div & ~MDIO_CLK_DIV_MASK) {
> +		netdev_dbg(lp->ndev, "MDIO clock divisor overflow, setting to maximum value\n");
> +		clk_div = MDIO_CLK_DIV_MASK;

It would be better to return -EINVAL. netdev_dbg() is not going to be
seen, and it could be the hardware does not work for no obvious
reason. It is better the driver fails to probe, which is much more
obvious.

	Andrew

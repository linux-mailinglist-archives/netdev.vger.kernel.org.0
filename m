Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07056673FBA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjASRSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjASRSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:18:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324762A14C;
        Thu, 19 Jan 2023 09:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=goNppuvMsvAqTs2f6LDSEjPwHmSsgV4gH7uC2Dwvo8A=; b=JlTJVlLtDX5VBm3jpr+T7LKb8s
        R8oUOd9OnwmO+diUvmHieYRV+PDwhqRgzuzFstpbcFeYi6IBjBBcT/0z7umETLxwcSrd1ZllMScRL
        NsSeERJrV65F4oxWbeUwsqe5ORDdSBFu8ohfpsHXGaIVxjEvl9TB+OAIFwvV+KUGKzmU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIYY1-002c22-I1; Thu, 19 Jan 2023 18:17:57 +0100
Date:   Thu, 19 Jan 2023 18:17:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8l7Rc9Vde9J45ij@lunn.ch>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
 <Y8dhUwIMb4tTeqWN@lunn.ch>
 <1jmt6eye1m.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1jmt6eye1m.fsf@starbuckisacylon.baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +
> >> +	/* Set the internal phy id */
> >> +	writel_relaxed(FIELD_PREP(REG2_PHYID, 0x110181),
> >> +		       priv->regs + ETH_REG2);
> >
> > So how does this play with what Heiner has been reporting recently?
> 
> What Heiner reported recently is related to the g12 family, not the gxl
> which this driver address.
> 
> That being said, the g12 does things in a similar way - the glue
> is just a bit different:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/mdio/mdio-mux-meson-g12a.c?h=v6.2-rc4#n165
> 
> > What is the reset default? Who determined this value?
> 
> It's the problem, the reset value is 0. That is why GXL does work with the
> internal PHY if the bootloader has not initialized it before the kernel
> comes up ... and there is no guarantee that it will.
> 
> The phy id value is arbitrary, same as the address. They match what AML
> is using internally.

Please document where these values have come from. In the future we
might need to point a finger when it all goes horribly wrong.

> They have been kept to avoid making a mess if a vendor bootloader is
> used with the mainline kernel, I guess.
> 
> I suppose any value could be used here, as long as it matches the value
> in the PHY driver:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/meson-gxl.c?h=v6.2-rc4#n253

Some Marvell Ethernet switches with integrated PHYs have IDs with the
vendor part set to Marvell, but the lower part is 0. The date sheet
even says this is deliberate, you need to look at some other register
in the switches address space to determine what the part is. That
works O.K in the vendor crap monolithic driver, but not for Linux
which separates the drivers up. So we have to intercept the reads and
fill in the lower part. And we have no real knowledge if the PHYs are
all the same, or there are differences. So we put in the switch ID,
and the PHY driver then has an entry per switch. That gives us some
future wiggle room if we find the PHYs are actually different.

Is there any indication in the datasheets that the PHY is the exact
same one as in the g12? Are we really safe to reuse this value between
different SoCs?

I actually find it an odd feature. Does the datasheet say anything
about Why you can set the ID in software? The ID describes the
hardware, and software configuration should not be able to change the
hardware in any meaningful way.

> >> +	/* Enable the internal phy */
> >> +	val |= REG3_PHYEN;
> >> +	writel_relaxed(val, priv->regs + ETH_REG3);
> >> +	writel_relaxed(0, priv->regs + ETH_REG4);
> >> +
> >> +	/* The phy needs a bit of time to come up */
> >> +	mdelay(10);
> >
> > What do you mean by 'come up'? Not link up i assume. But maybe it will
> > not respond to MDIO requests?
> 
> Yes this MDIO multiplexer is also the glue that provides power and
> clocks to the internal PHY. Once the internal PHY is selected, it needs
> a bit a of time before it is usuable. 

O.K, please reword it to indicate power up, not link up.

     Andrew

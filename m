Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39412652196
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiLTNdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLTNdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:33:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613BF18B3E;
        Tue, 20 Dec 2022 05:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PBKohcfzjSqRdddPpAv4Rwpq7IkcN9J0lMnnbLlGi0M=; b=Z9cx2J1jhbD8p1DOS0Grff44Qn
        5pp0l9vnMbZknZIlhVTaanZNAJrZ7hCXkOyvCGELpS/Pddu7B5x6tOAS9riIEDi2hDtZzwdRJM4pJ
        gEzkqbDNXRr6j86EJFL6H8M5eVvVWpqemh0+HsOYXB8NP0WWF3NHGTrDjlOd63wlPkMo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7ckI-0005gG-Lp; Tue, 20 Dec 2022 14:33:26 +0100
Date:   Tue, 20 Dec 2022 14:33:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] net: phy: mxl-gpy: disable interrupts on
 GPY215 by default
Message-ID: <Y6G5phSGSPk+7Dgj@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc>
 <Y4pHCQrDbXXmOT+A@lunn.ch>
 <69e0468cf192455fd2dc7fc93194a8ff@walle.cc>
 <Y4uzYVSRiE9feD01@lunn.ch>
 <34dc81b01930e594ca4773ddb8c24160@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dc81b01930e594ca4773ddb8c24160@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Yes, it is a valid point to do this check, but on its own i don't
> > think it is sufficient.
> 
> Care to elaborate a bit? E.g. what is the difference to the case
> the phy would have an interrupt described but no .config_intr()
> op.
> 
> > > > I think a better place for this test is in gpy_config_intr(), return
> > > > -EOPNOTSUPP. phy_enable_interrupts() failing should then cause
> > > > phy_request_interrupt() to use polling.
> > > 
> > > Which will then print a warning, which might be misleading.
> > > Or we disable the warning if -EOPNOTSUPP is returned?
> > 
> > Disabling the warning is the right thing to do.
> 
> There is more to this. .config_intr() is also used in
> phy_init_hw() and phy_drv_supports_irq(). The latter would
> still return true in our case. I'm not sure that is correct.
> 
> After trying your suggestion, I'm still in favor of somehow
> tell the phy core to force polling mode during probe() of the
> driver.

The problem is that the MAC can set the interrupt number after the PHY
probe has been called. e.g.

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c#L524

The interrupt needs to be set by the time the PHY is connected to the
MAC, which is often in the MAC open method, much later than the PHY
probe.

     Andrew

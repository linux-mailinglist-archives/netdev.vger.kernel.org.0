Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E9D64190E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLCUh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 15:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCUh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 15:37:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABBEFD2A;
        Sat,  3 Dec 2022 12:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rPTn3eQfU4xquGlMEzeTTkP+ED6yH76zbYeY/hijclo=; b=ULBFlNX00q7GtyrusWgSAGgx/B
        8I4+52OFIqQL4Q6VGdt/yffE0QToTqmAX7ZNUyLxXp6wbETr5yzbGrQ+vvbFqw9ceOyPP6x+VT6v1
        JHi+nO9I3ToPhDr/mWMekf9k6CBJhKfv+tHckmfswn7v4WEidz8o2Wv4WPnu1dp2pd5k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1ZFh-004Ho9-Vo; Sat, 03 Dec 2022 21:36:49 +0100
Date:   Sat, 3 Dec 2022 21:36:49 +0100
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
Message-ID: <Y4uzYVSRiE9feD01@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc>
 <Y4pHCQrDbXXmOT+A@lunn.ch>
 <69e0468cf192455fd2dc7fc93194a8ff@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e0468cf192455fd2dc7fc93194a8ff@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -290,6 +291,10 @@ static int gpy_probe(struct phy_device *phydev)
> > >  	phydev->priv = priv;
> > >  	mutex_init(&priv->mbox_lock);
> > > 
> > > +	if (gpy_has_broken_mdint(phydev) &&
> > > +	    !device_property_present(dev,
> > > "maxlinear,use-broken-interrupts"))
> > > +		phydev->irq = PHY_POLL;
> > > +
> > 
> > I'm not sure of ordering here. It could be phydev->irq is set after
> > probe. The IRQ is requested as part of phy_connect_direct(), which is
> > much later.
> 
> I've did it that way, because phy_probe() also sets phydev->irq = PHY_POLL
> in some cases and the phy driver .probe() is called right after it.

Yes, it is a valid point to do this check, but on its own i don't
think it is sufficient.

> > I think a better place for this test is in gpy_config_intr(), return
> > -EOPNOTSUPP. phy_enable_interrupts() failing should then cause
> > phy_request_interrupt() to use polling.
> 
> Which will then print a warning, which might be misleading.
> Or we disable the warning if -EOPNOTSUPP is returned?

Disabling the warning is the right thing to do.

	  Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471626A5B47
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjB1PFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjB1PFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:05:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D48715C9A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zXEVmRQBFWf4vEUp+2pUNiXDHZlQo+Fz32e/iV9bcno=; b=in5uXZyVwSEv5CA+mDBB3QmSlL
        X51Go4lzel+QpqtbH+tCuWIxaxlAJzJuPfKKpTqpkx5kTzINljG+Knbj+nakM284j0+GSn/cKjPl+
        4NlZ9KGf7d5lkboPAg9CkWjYFOnyDSHDITzJV9syOOsqFDZylRM0JSHv0C9El48EqIWA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pX1Xj-006AMG-1y; Tue, 28 Feb 2023 16:05:27 +0100
Date:   Tue, 28 Feb 2023 16:05:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Disable IRQs on suspend
Message-ID: <Y/4YN+j19SZNEizu@lunn.ch>
References: <20230228133412.7662-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228133412.7662-1-alexander.stein@ew.tq-group.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dp83867_suspend(struct phy_device *phydev)
> +{
> +	/* Disable PHY Interrupts */
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->interrupts = PHY_INTERRUPT_DISABLED;
> +		if (phydev->drv->config_intr)
> +			phydev->drv->config_intr(phydev);

It seems odd going via phydev->drv inside the driver to call functions
which are also inside the driver. Why do you not directly call dp83867_config_intr()?

> +static int dp83867_resume(struct phy_device *phydev)
> +{
> +	genphy_resume(phydev);
> +
> +	/* Enable PHY Interrupts */
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->interrupts = PHY_INTERRUPT_ENABLED;
> +		if (phydev->drv->config_intr)
> +			phydev->drv->config_intr(phydev);
> +	}

Is there a race here? Say the PHY is in a fixed mode, not
autoneg. Could it be, that as soon as you clear the power down bit in
genphy_resume() it signals a link up interrupt? dp83867_config_intr()
then acknowledged and clears that interrupt, before enabling the
interrupt, so the link up event never gets passed to phylib? Maybe the
order needs reversing here?

	   Andrew

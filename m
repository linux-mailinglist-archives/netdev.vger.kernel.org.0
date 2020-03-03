Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBF1782CB
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgCCTGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:06:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40114 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgCCTGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:06:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8p0TuvSHPw/uxoJ9pN7aOyklSPuYeZSiMfU4w3JSeac=; b=Tz79FiFISmAlyGrnaCV6eNyr3
        wqICY3JfhddXCct7mKRyjB48eBz+W8DlQu1s/eD8ahD5wI9uBtW7zm/MLYRmblkLutTLtHRUb2gac
        WuQiOjIjr6XwGB90Je7C7u2uewUuEFXAgT3PqcQErn4s9hc4wM5sSyiqTGcCHZWN2mdGn0w4CJav3
        NEAhmPi/Yr8u+18RFTLkpq86C4BVJosFg1IJsqhI7TextXxgdlGvRVJJkH6ExGqs7vzDxZBpRxemK
        DI8ca36Ag+4hYxGBNx1xSQ82a1P1BNzfNQDyBcG+Ril4rTPv7rMBP+uZQbHhQQcXsgRJfbkbvqZET
        0vn/FBVsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59948)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j9Crj-0001Ls-6J; Tue, 03 Mar 2020 19:06:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j9Crh-00068y-7c; Tue, 03 Mar 2020 19:06:01 +0000
Date:   Tue, 3 Mar 2020 19:06:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303190601.GU25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99s1-00011Q-RB@rmk-PC.armlinux.org.uk>
 <20200303170316.GJ24912@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303170316.GJ24912@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 06:03:16PM +0100, Andrew Lunn wrote:
> > +static int mv3310_reset(struct phy_device *phydev, u32 unit)
> > +{
> > +	int retries, val, err;
> > +
> > +	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
> > +			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	retries = 20;
> > +	do {
> > +		msleep(5);
> > +		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
> > +		if (val < 0)
> > +			return val;
> > +	} while (val & MDIO_CTRL1_RESET && --retries);
> > +
> > +	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
> 
> Hi Russell
> 
> I've often seen people get this sort of polling loop wrong. So i
> generally point people towards include/linux/iopoll.h.

The above comes from phy_poll_reset().

> I wonder if it would be helpful to add phy_read_mmd_poll_timeout()
> and maybe phy_read_poll_timeout() to phy-core.c?

Maybe, if it becomes more prevalent.

We do have one version in aquantia_main.c which does the wrong
test-register, sleep, timeout sequence, which looks to be the only
case that is wrong.

So, if we want to do this, it should be a separate series, fixing
all locations at the same time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

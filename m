Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA540FAEF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhIQO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbhIQO72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:59:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508CDC061764
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rwghMVgjahZVVBvOrycIfyU14EpdySi2pjQ0lErZJm4=; b=QripXe0n1mgrqQVkXeAil0QhUr
        AAmo++xwtpypFI7pmWQQe3GYhYil+RLf6mpvcCkRfoG7o1olrxEKbaox9J8BfkKcK8sSoVXAzJfCi
        IDx/dQ3zOM+bwojY18RGJdeEWyUtYGOZUrcDqY+Co2sdVP8eLtv++Wgs1ycG/oY5Sx/kUSVxkLLU3
        VszT0A9r0yEzpRMg723+80qBH4kiLk2UYngTcW1IsSiVwxptX+jLEFvuCZaRRm4WcEJIxWXq0a2F/
        zGY3nWuDhj2cZbOmqF5SdF+h67Sj9lh4NUtxe4glIRd9MtmZNJKvMvZgF5d44tWGeDbSbtNuLj1vx
        tdm8qmdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45126)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mRFJU-0007nN-8w; Fri, 17 Sep 2021 15:58:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mRFJR-00060T-Iz; Fri, 17 Sep 2021 15:58:01 +0100
Date:   Fri, 17 Sep 2021 15:58:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
 <YUSp78o/vfZNFCJw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUSp78o/vfZNFCJw@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 04:45:03PM +0200, Andrew Lunn wrote:
> > +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> > +{
> > +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > +	u16 val;
> > +	int err;
> > +
> > +	if (!priv->has_downshift)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (ds == DOWNSHIFT_DEV_DISABLE)
> > +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> > +					  MV_PCS_DSC1_ENABLE);
> > +
> > +	/* FIXME: The default is disabled, so should we disable? */
> > +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> > +		ds = 2;
> 
> Hi Russell
> 
> Rather than a FIXME, maybe just document that the hardware default is
> disabled, which does not make too much sense, so default to 2 attempts?

Sadly, the downshift parameters aren't documented at all in the kernel,
and one has to dig into the ethtool source to find out what they mean:

DOWNSHIFT_DEV_DEFAULT_COUNT -
	ethtool --set-phy-tunable ethN downshift on
DOWNSHIFT_DEV_DISABLE -
	ethtool --set-phy-tunable ethN downshift off
otherwise:
	ethtool --set-phy-tunable ethN downshift count N

This really needs to be documented somewhere in the kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

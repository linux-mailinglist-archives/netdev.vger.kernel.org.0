Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9041484D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhIVMCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhIVMCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 08:02:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1464C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 05:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oL7UFvP7E1O4Nzz+acnjpl59PDo/1fqSLHJLaqoudo4=; b=p6LdMQYelcNiY99xXD8qasXYm7
        ZonCtDjEG7prXB4U1cyVmtVhgVBCpum7HpAJatotxOejCrjfm0fYfO8AS+cwazQstt4hOecc9hGYH
        bnGyiou9t9pD9Quom7spJJmdOXFVScC+C8NEgHWA3MJ4Q0izyMwHfAMMvnnVZNLIqsRIAfM8xpTQD
        nYehfVNrxKpbBFNlVSWCui0CNtgb7PggvE8dUjfcXo9qEZIGeNVYwwhhQxM70RdgsU9K3OfzgzTqG
        GMR41/joj8PsI/YW7C6evrw3wmGTW8yMGMvvFF87VGA6z+i4r2ibJbXUFVgDrl6Dx1wQzCETlLb8A
        GXBx8xHg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54732)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mT0vR-0003p4-M5; Wed, 22 Sep 2021 13:00:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mT0vP-0004F6-Up; Wed, 22 Sep 2021 13:00:31 +0100
Date:   Wed, 22 Sep 2021 13:00:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YUsa3z8KsuqS64k8@shell.armlinux.org.uk>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
 <YUSp78o/vfZNFCJw@lunn.ch>
 <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 03:58:01PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 17, 2021 at 04:45:03PM +0200, Andrew Lunn wrote:
> > > +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> > > +{
> > > +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > > +	u16 val;
> > > +	int err;
> > > +
> > > +	if (!priv->has_downshift)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (ds == DOWNSHIFT_DEV_DISABLE)
> > > +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> > > +					  MV_PCS_DSC1_ENABLE);
> > > +
> > > +	/* FIXME: The default is disabled, so should we disable? */
> > > +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> > > +		ds = 2;
> > 
> > Hi Russell
> > 
> > Rather than a FIXME, maybe just document that the hardware default is
> > disabled, which does not make too much sense, so default to 2 attempts?
> 
> Sadly, the downshift parameters aren't documented at all in the kernel,
> and one has to dig into the ethtool source to find out what they mean:
> 
> DOWNSHIFT_DEV_DEFAULT_COUNT -
> 	ethtool --set-phy-tunable ethN downshift on
> DOWNSHIFT_DEV_DISABLE -
> 	ethtool --set-phy-tunable ethN downshift off
> otherwise:
> 	ethtool --set-phy-tunable ethN downshift count N
> 
> This really needs to be documented somewhere in the kernel.

I was hoping that this would cause further discussion on what the
exact meaning of "DOWNSHIFT_DEV_DEFAULT_COUNT" is. Clearly, it's
meant to turn downshift on, but what does "default" actually mean?

If we define "default" as "whatever the hardware defaults to" then
for this phy, that would be turning off downshift.

So, should we rename "DOWNSHIFT_DEV_DEFAULT_COUNT" to be
"DOWNSHIFT_DEV_ENABLE" rather than trying to imply that it's
some kind of default that may need to be made up?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

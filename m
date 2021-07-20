Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44CE3CFC85
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbhGTOAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbhGTNvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:51:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0951C0613DE
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 07:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OTUTsE3kw2/hXyNWz/pqNqxeAFfdkNNb0CODpx/Iecs=; b=mzHNWH875zR6UjvGtXe0aFdF6
        py5tO6rfIh3AtR/G5wOcn3xE+mFrpFCc1MB+MHRuczpWIRA7+/7SRl2Dfo5VTB0WfPjJAO7Q6y/rI
        MzZecNySlm+n4QGkOL9CA3Fo26//GrIz8HQFqi2ecICLjhGtwoULiPSxH3s4QetFigbbWJjvZCj46
        JDknAkfWNRLUE0qpbEJKVITaSVmVSk89YBaTcRIsMpyEzvZa6lGnJuN46AqmdqbX5ypzcmEvN/htb
        4qu3LlxaqMYHYEkG0OOShst8/HY2uTcmPODAz8ZYgamie9LCMh25NWOVatqb0sNpwa1UHMk6W8bId
        N5c5KVVgg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46374)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5qli-0006VO-R5; Tue, 20 Jul 2021 15:30:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5qli-0006z1-D6; Tue, 20 Jul 2021 15:30:46 +0100
Date:   Tue, 20 Jul 2021 15:30:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <20210720143046.GU22278@shell.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
 <YPbdfBqjgHzM+6+Z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPbdfBqjgHzM+6+Z@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:28:12PM +0200, Andrew Lunn wrote:
> > +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> > +{
> > +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > +	u16 val;
> > +	int err;
> > +
> > +	/* Fails to downshift with v0.3.5.0 and earlier */
> > +	if (priv->firmware_ver < MV_VERSION(0,3,5,0))
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
> Interesting question.
> 
> It is a useful feature, so i would enable it by default.
> 
> Is it possible to read the actual speed via some vendor register?  The
> phy-core might then give a warning, but it is 50/50 since the link
> peer might perform the downshift.

We already do read the actual negotiated speed anbd other parameters
from the MV_PCS_CSSR1 register.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

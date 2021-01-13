Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6075F2F49B8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhAMLJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbhAMLJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 06:09:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D21FC061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 03:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RVXHYkovhMMd2Bh0vK42OEvWbflwwk67vgd4HEtp70o=; b=rjQE+3ZQseRDjSAuW6W/lgmjv
        YW8QQl2ZU7S21nKWGLr3WumwtZBeC13H2cLG5oJDjpjGN44SMJgAi6wZxM3uIz87aLOPgMNGAZ22i
        JNWz5KFCbzCX2BwywqcUqaWt2X6Gysgo3LrxkTpSlVsQ4mUj/c9X/Utj/tIEV0bUTXxj35SeJ5anS
        g/5VgILl+D10/11HeuK0ZhvqJX4dMbMT6hYPwurPKAVER7vBOhjXvHdu1arX7fTRGT1BSqKdmmBbt
        TnnVJ/toMuajIIgbmDT7BQrNj1zh38HEgHGuUptFfO3CrGwMJtBpJnba0tX1YPKvOUK0/yLtxEU/3
        8MFHWcBeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47410)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kze1F-00016c-2y; Wed, 13 Jan 2021 11:08:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kze1E-0007FE-6a; Wed, 13 Jan 2021 11:08:52 +0000
Date:   Wed, 13 Jan 2021 11:08:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 4/4] net: sfp: add support for multigig
 RollBall transceivers
Message-ID: <20210113110852.GH1551@shell.armlinux.org.uk>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-5-kabel@kernel.org>
 <20210113104936.ka74oaa6xo2mvwbo@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113104936.ka74oaa6xo2mvwbo@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:49:36AM +0100, Pali Rohár wrote:
> On Monday 11 January 2021 06:00:44 Marek Behún wrote:
> > @@ -1453,7 +1459,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
> >  	struct phy_device *phy;
> >  	int err;
> >  
> > -	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
> > +	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
> >  	if (phy == ERR_PTR(-ENODEV))
> >  		return PTR_ERR(phy);
> >  	if (IS_ERR(phy)) {
> > @@ -1835,6 +1841,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
> >  
> >  	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
> >  
> > +	sfp->phy_addr = SFP_PHY_ADDR;
> > +	sfp->module_t_wait = T_WAIT;
> > +
> > +	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> > +	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> > +	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> > +	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
> > +		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
> > +		sfp->phy_addr = SFP_PHY_ADDR_ROLLBALL;
> > +		sfp->module_t_wait = T_WAIT_ROLLBALL;
> > +
> > +		/* RollBall SFPs may have wrong (zero) extended compliacne code

Spelling error - "compliance"

> > +		 * burned in EEPROM. For PHY probing we need the correct one.
> > +		 */
> > +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
> 
> Should not we rather in sfp_sm_probe_for_phy() function in "default"
> section try to probe also for clause 45 PHY when clause 22 fails?

Why? That's opening the possibilities for more problems - remember,
the access method is vendor defined, and we already have the situation
where I2C address 0x56 is used in two different styles that are
indistinguishable:

- Clause 22 write:
	Write register address, value high, value low.
- Clause 22 read:
	Write register address.
	Read value high, low.
- Clause 45 write:
	Write devad, register address high, register address low,
		value high, value low.
- Clause 45 read:
	Write devad, register address high, register address low.
	Read value high, low.

Look closely at the similarities of Clause 22 write and Clause 45
read, you'll see that if you issue a clause 45 read to a SFP module
that implements Clause 22, you actually end up issuing a write to it.

Sending random MDIO cycles to a SFP is a really bad idea.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

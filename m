Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C252F4A1F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbhAML1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbhAML1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 06:27:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A78233A1;
        Wed, 13 Jan 2021 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610537209;
        bh=+HGYvx5HBjNnkXy9L6B7Nid5od/5L/7TDEIF37vS0vM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JRtr6yCW2dbMTZs+STWdbEiOcXkRK17P8M2aOK0gxxMkV8VsR3QT2LJ30hPKT1c14
         RfILf05baCi9FwDe0iXoKYl/AnZJrF7XidT0Da0JTL5VocMcmdWmmAQiKushifXM/h
         jfYWS5yT8c9gh3xAlBCjB6dTGNZkX1ljGRxsJUqNBv78U8t/Sct1oQVJmc27IdD0ST
         tAirrXZ/vkUqZwZDYZf+M92JZTGTKnwJ2Xl/fQX77CGBfGlf/lK98Wsh85fKgGNFBw
         /GfCzL7L+NhahfdWtCjtfqCYErNGezHisdNo3F6EQDFNfw6OOA2rGklltIOjDep2k+
         WtEk5mYxSVagw==
Received: by pali.im (Postfix)
        id E24A976D; Wed, 13 Jan 2021 12:26:46 +0100 (CET)
Date:   Wed, 13 Jan 2021 12:26:46 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 4/4] net: sfp: add support for multigig
 RollBall transceivers
Message-ID: <20210113112646.lcowenak5sbrzwjs@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-5-kabel@kernel.org>
 <20210113104936.ka74oaa6xo2mvwbo@pali>
 <20210113110852.GH1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113110852.GH1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 13 January 2021 11:08:52 Russell King - ARM Linux admin wrote:
> On Wed, Jan 13, 2021 at 11:49:36AM +0100, Pali Rohár wrote:
> > On Monday 11 January 2021 06:00:44 Marek Behún wrote:
> > > @@ -1453,7 +1459,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
> > >  	struct phy_device *phy;
> > >  	int err;
> > >  
> > > -	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
> > > +	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
> > >  	if (phy == ERR_PTR(-ENODEV))
> > >  		return PTR_ERR(phy);
> > >  	if (IS_ERR(phy)) {
> > > @@ -1835,6 +1841,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
> > >  
> > >  	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
> > >  
> > > +	sfp->phy_addr = SFP_PHY_ADDR;
> > > +	sfp->module_t_wait = T_WAIT;
> > > +
> > > +	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> > > +	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> > > +	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> > > +	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
> > > +		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
> > > +		sfp->phy_addr = SFP_PHY_ADDR_ROLLBALL;
> > > +		sfp->module_t_wait = T_WAIT_ROLLBALL;
> > > +
> > > +		/* RollBall SFPs may have wrong (zero) extended compliacne code
> 
> Spelling error - "compliance"
> 
> > > +		 * burned in EEPROM. For PHY probing we need the correct one.
> > > +		 */
> > > +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
> > 
> > Should not we rather in sfp_sm_probe_for_phy() function in "default"
> > section try to probe also for clause 45 PHY when clause 22 fails?
> 
> Why? That's opening the possibilities for more problems - remember,
> the access method is vendor defined, and we already have the situation
> where I2C address 0x56 is used in two different styles that are
> indistinguishable:
> 
> - Clause 22 write:
> 	Write register address, value high, value low.
> - Clause 22 read:
> 	Write register address.
> 	Read value high, low.
> - Clause 45 write:
> 	Write devad, register address high, register address low,
> 		value high, value low.
> - Clause 45 read:
> 	Write devad, register address high, register address low.
> 	Read value high, low.
> 
> Look closely at the similarities of Clause 22 write and Clause 45
> read, you'll see that if you issue a clause 45 read to a SFP module
> that implements Clause 22, you actually end up issuing a write to it.
> 
> Sending random MDIO cycles to a SFP is a really bad idea.

I see, thank you for explanation. Incorrect data in SFP EEPROM may cause
lot of other issues :-(

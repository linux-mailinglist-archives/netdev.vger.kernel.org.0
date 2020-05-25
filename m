Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A273D1E0B62
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbgEYKGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389490AbgEYKGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 06:06:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B6EC061A0E;
        Mon, 25 May 2020 03:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dqn2ng20zbfw83d4cd9J1CGxHLx509RjA4dWqy5bjlM=; b=vT1rlakzxVU8RhV8AQrWC0DBg
        eMAO8ysp6ooFV3+5nxenSIjfA8WbVEYjovRcMnuViP2bp2CEYrmKlziRkMYgw04F5sNfTlpAuav5B
        LNjkjjFBZR6Y256CKHDegox2QjXvQhewytn4Xb+EOBoxqOidpJ97AYwAXIutHVlgBNqB+R5CQdqpp
        LQU9wTglm/2+3Z1LnEBjaf06RLPynqi+ZNOTiiqzMYn4BQGL0ogrL5sR3lxiWPfaFFEPP58vvUBdE
        mYdfBU27KARSSOhYw2Crpe1D5fFhZYh1iAJVKxF8Olik0TGweo83reEdwiWS1QaYGP6e5E9JiNqQs
        VEterxtzA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34300)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd9zq-0004vN-NX; Mon, 25 May 2020 11:06:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd9zo-0004Gd-Vw; Mon, 25 May 2020 11:06:13 +0100
Date:   Mon, 25 May 2020 11:06:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525100612.GM1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 10:34:13PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/23/20 1:37 PM, Russell King - ARM Linux admin wrote:
> > On Fri, May 22, 2020 at 04:30:52PM -0500, Jeremy Linton wrote:
> > > Until this point, we have been sanitizing the c22
> > > regs presence bit out of all the MMD device lists.
> > > This is incorrect as it causes the 0xFFFFFFFF checks
> > > to incorrectly fail. Further, it turns out that we
> > > want to utilize this flag to make a determination that
> > > there is actually a phy at this location and we should
> > > be accessing it using c22.
> > > 
> > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > ---
> > >   drivers/net/phy/phy_device.c | 16 +++++++++++++---
> > >   1 file changed, 13 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index f0761fa5e40b..2d677490ecab 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -689,9 +689,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
> > >   		return -EIO;
> > >   	*devices_in_package |= phy_reg;
> > > -	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > > -	*devices_in_package &= ~BIT(0);
> > > -
> > >   	return 0;
> > >   }
> > > @@ -742,6 +739,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   	int i;
> > >   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> > >   	u32 *devs = &c45_ids->devices_in_package;
> > > +	bool c22_present = false;
> > > +	bool valid_id = false;
> > >   	/* Find first non-zero Devices In package. Device zero is reserved
> > >   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
> > > @@ -770,6 +769,10 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   		return 0;
> > >   	}
> > > +	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > > +	c22_present = *devs & BIT(0);
> > > +	*devs &= ~BIT(0);
> > > +
> > >   	/* Now probe Device Identifiers for each device present. */
> > >   	for (i = 1; i < num_ids; i++) {
> > >   		if (!(c45_ids->devices_in_package & (1 << i)))
> > > @@ -778,6 +781,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   		ret = _get_phy_id(bus, addr, i, &c45_ids->device_ids[i], true);
> > >   		if (ret < 0)
> > >   			return ret;
> > > +		if (valid_phy_id(c45_ids->device_ids[i]))
> > > +			valid_id = true;
> > 
> > Here you are using your "devices in package" validator to validate the
> > PHY ID value.  One of the things it does is mask this value with
> > 0x1fffffff.  That means you lose some of the vendor OUI.  To me, this
> > looks completely wrong.
> 
> I think in this case I was just using it like the comment in
> get_phy_device() "if the phy_id is mostly F's, there is no device here".
> 
> My understanding is that the code is trying to avoid the 0xFFFFFFFF returns
> that seem to indicate "bus ok, phy didn't respond".
> 
> I just checked the OUI registration, and while there are a couple OUI's
> registered that have a number of FFF's in them, none of those cases seems to
> overlap sufficiently to cause this to throw them out. Plus a phy would also
> have to have model+revision set to 'F's. So while might be possible, if
> unlikely, at the moment I think the OUI registration keeps this from being a
> problem. Particularly, if i'm reading the mapping correctly, the OUI mapping
> guarantees that the field cannot be all '1's due to the OUI having X & M
> bits cleared. It sort of looks like the mapping is trying to lose those
> bits, by tossing bit 1 & 2, but the X & M are in the wrong octet (AFAIK, I
> just read it three times cause it didn't make any sense).

I should also note that we have at least one supported PHY where one
of the MMDs returns 0xfffe for even numbered registers and 0x0000 for
odd numbered registers in one of the vendor MMDs for addresses 0
through 0xefff - which has a bit set in the devices-in-package.

It also returns 0x0082 for almost every register in MMD 2, but MMD 2's
devices-in-package bit is clear in most of the valid MMDs, so we
shouldn't touch it.

These reveal the problem of randomly probing MMDs - they can return
unexpected values and not be as well behaved as we would like them to
be.  Using register 8 to detect presence may be beneficial, but that
may also introduce problems as we haven't used that before (and we
don't know whether any PHY that wrong.)  I know at least the 88x3310
gets it right for all except the vendor MMDs, where the low addresses
appear non-confromant to the 802.3 specs.  Both vendor MMDs are
definitely implemented, just not with anything conforming to 802.3.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

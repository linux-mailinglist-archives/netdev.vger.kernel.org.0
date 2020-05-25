Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788431E0B0D
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389667AbgEYJxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389333AbgEYJxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 05:53:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C99CC061A0E;
        Mon, 25 May 2020 02:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TfDqog4RDttAQOCpkvIYADSKVsDf0mydvOJDMp1M4Qc=; b=ui7FSLtgjIFF1LG04NxMsXkOc
        l8PXGeawfxrkE7xutfpP5BladqbWR0in9BTtePtImF+NfsRBKFnslnLgob2menAFTMI487ctkIiuE
        WNSqznIfDq9Lp147Pd0TmEy3zQaBSVotKTjzCpD6jNtoC5ZAEfBpYGMlWXSk8TRfu2thsocQOJYQR
        8K72hoGgT7JUgavXog9/7pK9Mm2VRGvIABqXqDUE5xNGvWg3Fs/gqFmYhPV7gJYRViR4O8Z0MK4l7
        AWzmajdhgcNkJJsAO3hSo3choUiN0AkHJtqWKKr+xtqNTvbnJCwv4tDzwVwVCM+w0fucwUgaQNlBk
        9P7/Hkp5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36736)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd9ni-0004tX-OV; Mon, 25 May 2020 10:53:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd9nh-0004GM-BG; Mon, 25 May 2020 10:53:41 +0100
Date:   Mon, 25 May 2020 10:53:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525095341.GL1551@shell.armlinux.org.uk>
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

Yes, that is certainly an interesting comment.  What's so magic about
this 0x1fffffff?  If it's about the time taken for the bus to rise
to logic 1 when not being actively driven by a PHY, then it actually
makes little sense, because we perform two transations to read each half
of the field, and both should have the same behaviour.  If this was the
issue, we should be masking and testing against 0x1fff1fff rather than
0x1fffffff.

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

The most-bits-set OUI that is currently allocated is 5C-FF-FF.  This
would result in a register value of 0x73fffc00 to 0x73ffffff, so as
you say, it should be safe.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

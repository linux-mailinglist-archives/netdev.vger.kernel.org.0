Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A221E185C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgEYX5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEYX5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:57:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3B7C061A0E;
        Mon, 25 May 2020 16:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O4D5x8eKrwyM06CMimg15MIA4vw10+KzgaRRwZ9feGw=; b=QsEvoFViGM5e/X8caczyZMkim
        4GYkdBi8P8WZqvC/8JLri62YzkTscSKziyw1tQ83X9OFqthHXYkA3yGwgP//JKfXu89/xz6ke7r+I
        PqHBG7RVrFs+KkZ87BChbIG6OvwRmwACZ2EwwZhDv5HdcaOEo6yHOOuTA7nhBIqeQ5/VMyGBB2Qq4
        69xEzck5fGWZgCMS0ljK8vVDx0CP3Gw5jbPaz8+dvwR3ugrN4fc3GMelmyTsma1x81izjmfNHaOeZ
        FcQbX10tZ2eGUv4h7gpxySIN/xowUUtqwKFc88DPcxuK+93majaCf+FdPsSqWjtScY/KXqtb/i6bm
        nFKLlokFw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36988)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdMyW-0006Hi-P1; Tue, 26 May 2020 00:57:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdMyQ-0004o1-Sg; Tue, 26 May 2020 00:57:38 +0100
Date:   Tue, 26 May 2020 00:57:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525235738.GU1551@shell.armlinux.org.uk>
References: <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220127.GO1551@shell.armlinux.org.uk>
 <a9490c28-ebe1-ed6d-e65e-2e1d0a06386b@arm.com>
 <20200525230946.GR1551@shell.armlinux.org.uk>
 <ab756571-b269-ba7f-8e23-053098d9f470@arm.com>
 <20200525233335.GT1551@shell.armlinux.org.uk>
 <269de1a4-57cf-b175-3184-2f4604255bf7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269de1a4-57cf-b175-3184-2f4604255bf7@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 06:42:50PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/25/20 6:33 PM, Russell King - ARM Linux admin wrote:
> > On Mon, May 25, 2020 at 06:22:19PM -0500, Jeremy Linton wrote:
> > > On 5/25/20 6:09 PM, Russell King - ARM Linux admin wrote:
> > > > On Mon, May 25, 2020 at 05:22:07PM -0500, Jeremy Linton wrote:
> > > > > On 5/25/20 5:01 PM, Russell King - ARM Linux admin wrote:
> > > > > > On Mon, May 25, 2020 at 04:51:16PM -0500, Jeremy Linton wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > On 5/25/20 5:06 AM, Russell King - ARM Linux admin wrote:
> > > > > > > > On Sun, May 24, 2020 at 10:34:13PM -0500, Jeremy Linton wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > On 5/23/20 1:37 PM, Russell King - ARM Linux admin wrote:
> > > > > > > > > > On Fri, May 22, 2020 at 04:30:52PM -0500, Jeremy Linton wrote:
> > > > > > > > > > > Until this point, we have been sanitizing the c22
> > > > > > > > > > > regs presence bit out of all the MMD device lists.
> > > > > > > > > > > This is incorrect as it causes the 0xFFFFFFFF checks
> > > > > > > > > > > to incorrectly fail. Further, it turns out that we
> > > > > > > > > > > want to utilize this flag to make a determination that
> > > > > > > > > > > there is actually a phy at this location and we should
> > > > > > > > > > > be accessing it using c22.
> > > > > > > > > > > 
> > > > > > > > > > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > > > > > > > > > ---
> > > > > > > > > > >       drivers/net/phy/phy_device.c | 16 +++++++++++++---
> > > > > > > > > > >       1 file changed, 13 insertions(+), 3 deletions(-)
> > > > > > > > > > > 
> > > > > > > > > > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > > > > > > > > > index f0761fa5e40b..2d677490ecab 100644
> > > > > > > > > > > --- a/drivers/net/phy/phy_device.c
> > > > > > > > > > > +++ b/drivers/net/phy/phy_device.c
> > > > > > > > > > > @@ -689,9 +689,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
> > > > > > > > > > >       		return -EIO;
> > > > > > > > > > >       	*devices_in_package |= phy_reg;
> > > > > > > > > > > -	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > > > > > > > > > > -	*devices_in_package &= ~BIT(0);
> > > > > > > > > > > -
> > > > > > > > > > >       	return 0;
> > > > > > > > > > >       }
> > > > > > > > > > > @@ -742,6 +739,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > > > > > > > > > >       	int i;
> > > > > > > > > > >       	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> > > > > > > > > > >       	u32 *devs = &c45_ids->devices_in_package;
> > > > > > > > > > > +	bool c22_present = false;
> > > > > > > > > > > +	bool valid_id = false;
> > > > > > > > > > >       	/* Find first non-zero Devices In package. Device zero is reserved
> > > > > > > > > > >       	 * for 802.3 c45 complied PHYs, so don't probe it at first.
> > > > > > > > > > > @@ -770,6 +769,10 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > > > > > > > > > >       		return 0;
> > > > > > > > > > >       	}
> > > > > > > > > > > +	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > > > > > > > > > > +	c22_present = *devs & BIT(0);
> > > > > > > > > > > +	*devs &= ~BIT(0);
> > > > > > > > > > > +
> > > > > > > > > > >       	/* Now probe Device Identifiers for each device present. */
> > > > > > > > > > >       	for (i = 1; i < num_ids; i++) {
> > > > > > > > > > >       		if (!(c45_ids->devices_in_package & (1 << i)))
> > > > > > > > > > > @@ -778,6 +781,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > > > > > > > > > >       		ret = _get_phy_id(bus, addr, i, &c45_ids->device_ids[i], true);
> > > > > > > > > > >       		if (ret < 0)
> > > > > > > > > > >       			return ret;
> > > > > > > > > > > +		if (valid_phy_id(c45_ids->device_ids[i]))
> > > > > > > > > > > +			valid_id = true;
> > > > > > > > > > 
> > > > > > > > > > Here you are using your "devices in package" validator to validate the
> > > > > > > > > > PHY ID value.  One of the things it does is mask this value with
> > > > > > > > > > 0x1fffffff.  That means you lose some of the vendor OUI.  To me, this
> > > > > > > > > > looks completely wrong.
> > > > > > > > > 
> > > > > > > > > I think in this case I was just using it like the comment in
> > > > > > > > > get_phy_device() "if the phy_id is mostly F's, there is no device here".
> > > > > > > > > 
> > > > > > > > > My understanding is that the code is trying to avoid the 0xFFFFFFFF returns
> > > > > > > > > that seem to indicate "bus ok, phy didn't respond".
> > > > > > > > > 
> > > > > > > > > I just checked the OUI registration, and while there are a couple OUI's
> > > > > > > > > registered that have a number of FFF's in them, none of those cases seems to
> > > > > > > > > overlap sufficiently to cause this to throw them out. Plus a phy would also
> > > > > > > > > have to have model+revision set to 'F's. So while might be possible, if
> > > > > > > > > unlikely, at the moment I think the OUI registration keeps this from being a
> > > > > > > > > problem. Particularly, if i'm reading the mapping correctly, the OUI mapping
> > > > > > > > > guarantees that the field cannot be all '1's due to the OUI having X & M
> > > > > > > > > bits cleared. It sort of looks like the mapping is trying to lose those
> > > > > > > > > bits, by tossing bit 1 & 2, but the X & M are in the wrong octet (AFAIK, I
> > > > > > > > > just read it three times cause it didn't make any sense).
> > > > > > > > 
> > > > > > > > I should also note that we have at least one supported PHY where one
> > > > > > > > of the MMDs returns 0xfffe for even numbered registers and 0x0000 for
> > > > > > > > odd numbered registers in one of the vendor MMDs for addresses 0
> > > > > > > > through 0xefff - which has a bit set in the devices-in-package.
> > > > > > > > 
> > > > > > > > It also returns 0x0082 for almost every register in MMD 2, but MMD 2's
> > > > > > > > devices-in-package bit is clear in most of the valid MMDs, so we
> > > > > > > > shouldn't touch it.
> > > > > > > > 
> > > > > > > > These reveal the problem of randomly probing MMDs - they can return
> > > > > > > > unexpected values and not be as well behaved as we would like them to
> > > > > > > > be.  Using register 8 to detect presence may be beneficial, but that
> > > > > > > > may also introduce problems as we haven't used that before (and we
> > > > > > > > don't know whether any PHY that wrong.)  I know at least the 88x3310
> > > > > > > > gets it right for all except the vendor MMDs, where the low addresses
> > > > > > > > appear non-confromant to the 802.3 specs.  Both vendor MMDs are
> > > > > > > > definitely implemented, just not with anything conforming to 802.3.
> > > > > > > 
> > > > > > > Yes, we know even for the NXP reference hardware, one of the phy's doesn't
> > > > > > > probe out correctly because it doesn't respond to the ieee defined
> > > > > > > registers. I think at this point, there really isn't anything we can do
> > > > > > > about that unless we involve the (ACPI) firmware in currently nonstandard
> > > > > > > behaviors.
> > > > > > > 
> > > > > > > So, my goals here have been to first, not break anything, and then do a
> > > > > > > slightly better job finding phy's that are (mostly?) responding correctly to
> > > > > > > the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
> > > > > > > have IEEE conformant phy's you should be ok". So, for your example phy, I
> > > > > > > guess the immediate answer is "use DT" or "find a conformant phy", or even
> > > > > > > "abstract it in the firmware and use a mailbox interface".
> > > > > > 
> > > > > > You haven't understood.  The PHY does conform for most of the MMDs,
> > > > > > but there are a number that do not conform.
> > > > > 
> > > > > Probably...
> > > > > 
> > > > > Except that i'm not sure how that is a problem at the moment, its still
> > > > > going to trigger as a found phy, and walk the same mmd list as before
> > > > > requesting drivers. Those drivers haven't changed their behavior so where is
> > > > > the problem? If there is a problem its in 7/11 where things are getting
> > > > > kicked due to seemingly invalid Ids.
> > > > > 
> > > > > The 1/11 devices=0 case actually appears to be a bug i'm fixing because you
> > > > > won't get an ID or a MMD list from that (before or after).
> > > > 
> > > > I think I've just flattened that argument in my immediately preceding
> > > > reply on the Cortina situation; I think you've grossly misread that
> > > > through not fully researching the history and then finding the
> > > > existing users.
> > > > 
> > > > There is no bug that you are fixing from what I can see.
> > > 
> > > One of us is missing something,
> > > 
> > > The "cortina" solution is broken in the current kernel. That is because
> > > lines 726-742 are dead code due to line 693.
> > > 
> > > I believe I've understood the problem there, and corrected it in this set
> > > along with a few others, but its distinctly possible that isn't true.
> > 
> > The code you refer to above is NOT used on the platforms that I have
> > identified use the Cortina PHY.  If this code is not used, it has not
> > caused any issue, and there is no breakage due to the change you are
> > referring to.
> > 
> Right, which is what I sort of expected. Because its falling back to a
> device list of 0xFFFFFFFF, which means probe every single MMD.

No.  no no no no no.

In the platforms that I have identified, the Cortina PHY will be
created by the DT code (drivers/of/of_mdio.c).  The PHY device
will be created by phy_device_create() with is_c45 *false*.
phydev->c45_ids will actually end up containing all-zeros.
So, there is no list of MMDs in this case.

The phy_device_create() path does not call get_phy_c45_ids().
This code is not run for any of the platforms I've identified
for a Cortina PHY.

The workaround for the devices-in-package was added back in
2015, two years _before_ there was a Cortina PHY driver, when
the phylib support for Clause 45 PHYs was in its infancy - there
was something really basic that didn't care what ID the PHY was,
just assumed it was a 10G PHY, no configuration of it, and just
reported link up/down.  So, back then IDs were mostly meaningless
for Clause 45 PHYs.

In 2017, a Cortina PHY driver was added, and we now have some
platforms that use this, and they _totally_ avoid this code path.

The workaround is likely obsolete and redundant, but we've no way
to know if removing it will create a regression.

In any case, for the reasons I've already clearly set out in one of
my previous emails analysing the Cortina situation (which you seem
to have ignored), pointing out that even the MMD 0 register set is
not compatible and would likely not reveal a valid ID, I think it's
highly likely that Cortina PHYs did not work for very long between
2015 and 2017, but continue to work fine today.

Please, rather than immediately writing yet another email trying to
"clarify" something in reply to this email, please go away and think
about some of the points I've raised, read the code as it stands,
not only in phylib but also in drivers/of.  Look at the device tree
descriptions for the boards I've pointed out.  Analyse what the code
would do.  It will help you immensely to have that understanding,
and I'm sure you will come to the same conclusion I have that the
workaround we see in get_phy_c45_ids() is likely obsolete.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

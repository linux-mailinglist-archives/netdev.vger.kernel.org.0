Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7181E25ED
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgEZPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgEZPrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:47:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DE4C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ev4ODVVmim3/97hqcHCWXCzd94sNLW7q5glAFxZiyjk=; b=cR6Wx5CtQu5mhGw1YuQT6Fn53
        8X4hm/8dOm98VQQY057FuHodtHxGGOfSaM8d68fBFS2IZKcm55KACCuyN6wf01gU2xq9Fm3SH9D19
        6Q4yM4u6rd6t2RlCLRXOXQVuEcJHRPy5wa/GFWv/T0GMB02NWmTWQUfciuRdactbWewHFfTdC5ou/
        N3Y2S22W9RgwRWWLAnZ8t2vYw0j5wmPWIzP6FM0tDdR8XhfQvcc3dkl+A1r7M7amqse1ZbM+Lm2Dm
        N6f3PrCg3WaKyPZR7YNR1LkDTfqaQp1isoGoMOxUDAG9VIqaa2eW9mLMcfysP+CQMoMczzuuttVBw
        5FvO72Qpg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37280)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdbn6-0008Dk-2K; Tue, 26 May 2020 16:46:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdbn5-0005VZ-Cx; Tue, 26 May 2020 16:46:55 +0100
Date:   Tue, 26 May 2020 16:46:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 3/7] net: phy: clean up PHY ID reading
Message-ID: <20200526154655.GD1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabn-0005sO-LN@rmk-PC.armlinux.org.uk>
 <d73f2250-d89e-b79b-5ea1-dca4c0d22c4c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d73f2250-d89e-b79b-5ea1-dca4c0d22c4c@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:38:31AM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/26/20 9:31 AM, Russell King wrote:
> > Rearrange the code to read the PHY IDs, so we don't call get_phy_id()
> > only to immediately call get_phy_c45_ids().  Move that logic into
> > get_phy_device(), which results in better readability.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >   drivers/net/phy/phy_device.c | 25 +++++++++----------------
> >   1 file changed, 9 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index e04284c4ebf8..0d6b6ca66216 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -756,29 +756,18 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> >   }
> >   /**
> > - * get_phy_id - reads the specified addr for its ID.
> > + * get_phy_c22_id - reads the specified addr for its clause 22 ID.
> >    * @bus: the target MII bus
> >    * @addr: PHY address on the MII bus
> >    * @phy_id: where to store the ID retrieved.
> > - * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
> > - * @c45_ids: where to store the c45 ID information.
> > - *
> > - * Description: In the case of a 802.3-c22 PHY, reads the ID registers
> > - *   of the PHY at @addr on the @bus, stores it in @phy_id and returns
> > - *   zero on success.
> > - *
> > - *   In the case of a 802.3-c45 PHY, get_phy_c45_ids() is invoked, and
> > - *   its return value is in turn returned.
> >    *
> > + * Read the 802.3 clause 22 PHY ID from the PHY at @addr on the @bus.
> > + * Return the PHY ID read from the PHY in @phy_id on successful access.
> >    */
> > -static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
> > -		      bool is_c45, struct phy_c45_device_ids *c45_ids)
> > +static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
> >   {
> >   	int phy_reg;
> > -	if (is_c45)
> > -		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
> > -
> >   	/* Grab the bits from PHYIR1, and put them in the upper half */
> >   	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
> >   	if (phy_reg < 0) {
> > @@ -817,7 +806,11 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
> >   	c45_ids.devices_in_package = 0;
> >   	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
> > -	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
> > +	if (is_c45)
> > +		r = get_phy_c45_ids(bus, addr, &phy_id, &c45_ids);
> > +	else
> > +		r = get_phy_c22_id(bus, addr, &phy_id);
> > +
> >   	if (r)
> >   		return ERR_PTR(r);
> > 
> 
> I see this, and the c22 regs detection, but I don't see how your choosing to
> use the c22 regs if the 45's aren't responding. Which was one of the primary
> purposes of that other set.

You are entirely correct, but I am not aiming for that in this series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

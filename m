Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361362104E9
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgGAHXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 03:23:17 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:57311 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgGAHXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 03:23:16 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 1CD4B44075D;
        Wed,  1 Jul 2020 10:23:13 +0300 (IDT)
References: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il> <20200629092224.GS1551@shell.armlinux.org.uk>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>
Subject: Re: [PATCH v2] net: phy: marvell10g: support XFI rate matching mode
In-reply-to: <20200629092224.GS1551@shell.armlinux.org.uk>
Date:   Wed, 01 Jul 2020 10:23:12 +0300
Message-ID: <87v9j7em1r.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Mon, Jun 29 2020, Russell King - ARM Linux admin wrote:
> On Sun, Jun 28, 2020 at 10:04:51AM +0300, Baruch Siach wrote:
>> When the hardware MACTYPE hardware configuration pins are set to "XFI
>> with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
>> MAC buffer packets in both directions to match various wire speeds.
>> 
>> Read the MAC Type field in the Port Control register, and set the MAC
>> interface speed accordingly.
>> 
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> ---
>> v2: Move rate matching state read to config_init (RMK)
>
> Not quite what I was after, but it'll do for now.

Thanks for you review.

> My only system which has a 3310 PHY and is configured for rate matching
> (using an XAUI interface, mode 1) seems to be sick - the 3310 no longer
> correctly negotiates on the media side (will only link at 100M/Half and
> only passes traffic in one direction), which makes any development with
> it rather difficult.  Either the media side drivers have failed or the
> magnetics.
>
> I was also hoping for some discussion, as I bought up a few points
> about the 3310's rate matching - unless you have the version with
> MACsec, the PHY expects the host side to rate limit the egress rate to
> the media rate and will _not_ send pause frames.  If you have MACsec,
> and the MACsec hardware is enabled (although may not be encrypting),
> then the PHY will send pause frames to the host as the internal buffer
> fills.

Flow control is disabled anyway in my use case (vpp).

> Then there's the whole question of what phydev->speed etc should be set
> to - the media speed or the host side link speed with the PHY, and then
> how the host side should configure itself.  At least the 88E6390x
> switch will force itself to the media side speed using that while in
> XAUI mode, resulting in a non-functioning speed.  So should the host
> side force itself to 10G whenever in something like XAUI mode?

How does the switch discover the media side speed? Is there some sort of
in-band information exchange?

> What do we do about the egress rate - ignore that statement and hope
> that the 3310 doesn't create bad packets on the wire if we fill up its
> internal buffer?

I will keep that in mind when stress testing the network. We might need
a way to set IPG on the MAC side if the MAC supports that (mvpp2 in this
case).

baruch

>>  drivers/net/phy/marvell10g.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>> 
>> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
>> index d4c2e62b2439..a7610eb55f30 100644
>> --- a/drivers/net/phy/marvell10g.c
>> +++ b/drivers/net/phy/marvell10g.c
>> @@ -80,6 +80,8 @@ enum {
>>  	MV_V2_PORT_CTRL		= 0xf001,
>>  	MV_V2_PORT_CTRL_SWRST	= BIT(15),
>>  	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
>> +	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
>> +	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
>>  	/* Temperature control/read registers (88X3310 only) */
>>  	MV_V2_TEMP_CTRL		= 0xf08a,
>>  	MV_V2_TEMP_CTRL_MASK	= 0xc000,
>> @@ -91,6 +93,7 @@ enum {
>>  
>>  struct mv3310_priv {
>>  	u32 firmware_ver;
>> +	bool rate_match;
>>  
>>  	struct device *hwmon_dev;
>>  	char *hwmon_name;
>> @@ -458,7 +461,9 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
>>  
>>  static int mv3310_config_init(struct phy_device *phydev)
>>  {
>> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>>  	int err;
>> +	int val;
>>  
>>  	/* Check that the PHY interface type is compatible */
>>  	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
>> @@ -475,6 +480,12 @@ static int mv3310_config_init(struct phy_device *phydev)
>>  	if (err)
>>  		return err;
>>  
>> +	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
>> +	if (val < 0)
>> +		return val;
>> +	priv->rate_match = ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
>> +			MV_V2_PORT_MAC_TYPE_RATE_MATCH);
>> +
>>  	/* Enable EDPD mode - saving 600mW */
>>  	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
>>  }
>> @@ -581,6 +592,17 @@ static int mv3310_aneg_done(struct phy_device *phydev)
>>  
>>  static void mv3310_update_interface(struct phy_device *phydev)
>>  {
>> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>> +
>> +	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
>> +	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
>> +	 * internal 16KB buffer.
>> +	 */
>> +	if (priv->rate_match) {
>> +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
>> +		return;
>> +	}
>> +
>>  	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
>>  	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
>>  	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
>> -- 
>> 2.27.0
>> 
>> 


-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6434BF5F
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 23:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhC1Vdh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 28 Mar 2021 17:33:37 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:35012 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhC1VdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 17:33:20 -0400
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id C987615360;
        Sun, 28 Mar 2021 22:33:14 +0100 (BST)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id BAAA121A6CA; Sun, 28 Mar 2021 22:33:14 +0100 (BST)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andre Edich <andre.edich@microchip.com>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, steve.glendinning@shawell.net,
        Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v5 3/3] smsc95xx: add phylib support
References: <20200826111717.405305-1-andre.edich@microchip.com>
        <20200826111717.405305-4-andre.edich@microchip.com>
        <yw1xk0prf3s0.fsf@mansr.com>
        <52da47b4-109a-dc4a-0fd4-023580fe86d4@gmail.com>
Date:   Sun, 28 Mar 2021 22:33:14 +0100
In-Reply-To: <52da47b4-109a-dc4a-0fd4-023580fe86d4@gmail.com> (Heiner
        Kallweit's message of "Sun, 28 Mar 2021 22:31:13 +0200")
Message-ID: <yw1xft0fezfp.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> On 28.03.2021 21:59, Måns Rullgård wrote:
>> Andre Edich <andre.edich@microchip.com> writes:
>> 
>>> Generally, each PHY has their own configuration and it can be done
>>> through an external PHY driver.  The smsc95xx driver uses only the
>>> hard-coded internal PHY configuration.
>>>
>>> This patch adds phylib support to probe external PHY drivers for
>>> configuring external PHYs.
>>>
>>> The MDI-X configuration for the internal PHYs moves from
>>> drivers/net/usb/smsc95xx.c to drivers/net/phy/smsc.c.
>>>
>>> Signed-off-by: Andre Edich <andre.edich@microchip.com>
>>> ---
>>>  drivers/net/phy/smsc.c     |  67 +++++++
>>>  drivers/net/usb/Kconfig    |   2 +
>>>  drivers/net/usb/smsc95xx.c | 399 +++++++++++++------------------------
>>>  3 files changed, 203 insertions(+), 265 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>>> index 74568ae16125..638e8c3d1f4a 100644
>>> --- a/drivers/net/phy/smsc.c
>>> +++ b/drivers/net/phy/smsc.c
>>> @@ -21,6 +21,17 @@
>>>  #include <linux/netdevice.h>
>>>  #include <linux/smscphy.h>
>>>
>>> +/* Vendor-specific PHY Definitions */
>>> +/* EDPD NLP / crossover time configuration */
>>> +#define PHY_EDPD_CONFIG			16
>>> +#define PHY_EDPD_CONFIG_EXT_CROSSOVER_	0x0001
>>> +
>>> +/* Control/Status Indication Register */
>>> +#define SPECIAL_CTRL_STS		27
>>> +#define SPECIAL_CTRL_STS_OVRRD_AMDIX_	0x8000
>>> +#define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
>>> +#define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
>>> +
>>>  struct smsc_hw_stat {
>>>  	const char *string;
>>>  	u8 reg;
>>> @@ -96,6 +107,54 @@ static int lan911x_config_init(struct phy_device *phydev)
>>>  	return smsc_phy_ack_interrupt(phydev);
>>>  }
>>>
>>> +static int lan87xx_config_aneg(struct phy_device *phydev)
>>> +{
>>> +	int rc;
>>> +	int val;
>>> +
>>> +	switch (phydev->mdix_ctrl) {
>>> +	case ETH_TP_MDI:
>>> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_;
>>> +		break;
>>> +	case ETH_TP_MDI_X:
>>> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
>>> +			SPECIAL_CTRL_STS_AMDIX_STATE_;
>>> +		break;
>>> +	case ETH_TP_MDI_AUTO:
>>> +		val = SPECIAL_CTRL_STS_AMDIX_ENABLE_;
>>> +		break;
>>> +	default:
>>> +		return genphy_config_aneg(phydev);
>>> +	}
>>> +
>>> +	rc = phy_read(phydev, SPECIAL_CTRL_STS);
>>> +	if (rc < 0)
>>> +		return rc;
>>> +
>>> +	rc &= ~(SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
>>> +		SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
>>> +		SPECIAL_CTRL_STS_AMDIX_STATE_);
>>> +	rc |= val;
>>> +	phy_write(phydev, SPECIAL_CTRL_STS, rc);
>>> +
>>> +	phydev->mdix = phydev->mdix_ctrl;
>>> +	return genphy_config_aneg(phydev);
>>> +}
>>> +
>>> +static int lan87xx_config_aneg_ext(struct phy_device *phydev)
>>> +{
>>> +	int rc;
>>> +
>>> +	/* Extend Manual AutoMDIX timer */
>>> +	rc = phy_read(phydev, PHY_EDPD_CONFIG);
>>> +	if (rc < 0)
>>> +		return rc;
>>> +
>>> +	rc |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
>>> +	phy_write(phydev, PHY_EDPD_CONFIG, rc);
>>> +	return lan87xx_config_aneg(phydev);
>>> +}
>>> +
>>>  /*
>>>   * The LAN87xx suffers from rare absence of the ENERGYON-bit when Ethernet cable
>>>   * plugs in while LAN87xx is in Energy Detect Power-Down mode. This leads to
>>> @@ -250,6 +309,9 @@ static struct phy_driver smsc_phy_driver[] = {
>>>  	.suspend	= genphy_suspend,
>>>  	.resume		= genphy_resume,
>>>  }, {
>>> +	/* This covers internal PHY (phy_id: 0x0007C0C3) for
>>> +	 * LAN9500 (PID: 0x9500), LAN9514 (PID: 0xec00), LAN9505 (PID: 0x9505)
>>> +	 */
>>>  	.phy_id		= 0x0007c0c0, /* OUI=0x00800f, Model#=0x0c */
>>>  	.phy_id_mask	= 0xfffffff0,
>>>  	.name		= "SMSC LAN8700",
>>> @@ -262,6 +324,7 @@ static struct phy_driver smsc_phy_driver[] = {
>>>  	.read_status	= lan87xx_read_status,
>>>  	.config_init	= smsc_phy_config_init,
>>>  	.soft_reset	= smsc_phy_reset,
>>> +	.config_aneg	= lan87xx_config_aneg,
>>>
>>>  	/* IRQ related */
>>>  	.ack_interrupt	= smsc_phy_ack_interrupt,
>>> @@ -293,6 +356,9 @@ static struct phy_driver smsc_phy_driver[] = {
>>>  	.suspend	= genphy_suspend,
>>>  	.resume		= genphy_resume,
>>>  }, {
>>> +	/* This covers internal PHY (phy_id: 0x0007C0F0) for
>>> +	 * LAN9500A (PID: 0x9E00), LAN9505A (PID: 0x9E01)
>>> +	 */
>>>  	.phy_id		= 0x0007c0f0, /* OUI=0x00800f, Model#=0x0f */
>>>  	.phy_id_mask	= 0xfffffff0,
>>>  	.name		= "SMSC LAN8710/LAN8720",
>>> @@ -306,6 +372,7 @@ static struct phy_driver smsc_phy_driver[] = {
>>>  	.read_status	= lan87xx_read_status,
>>>  	.config_init	= smsc_phy_config_init,
>>>  	.soft_reset	= smsc_phy_reset,
>>> +	.config_aneg	= lan87xx_config_aneg_ext,
>>>
>>>  	/* IRQ related */
>>>  	.ack_interrupt	= smsc_phy_ack_interrupt,
>> 
>> This change seems to be causing some trouble I'm seeing with a LAN8710A.
>> Specifically lan87xx_config_aneg_ext() writes to register 16 which is
>> not documented for LAN8710A (nor for LAN8720A).  The effect is somewhat
>> random.  Sometimes, the device drops to 10 Mbps while the kernel still
>> reports the link speed as 100 Mbps.  Other times, it doesn't work at
>> all.  Everything works if I change config_aneg to lan87xx_config_aneg,
>> like this:
>> 
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index 10722fed666d..07c0a7e4a350 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -408,7 +408,7 @@ static struct phy_driver smsc_phy_driver[] = {
>>         .read_status    = lan87xx_read_status,
>>         .config_init    = smsc_phy_config_init,
>>         .soft_reset     = smsc_phy_reset,
>> -       .config_aneg    = lan87xx_config_aneg_ext,
>> +       .config_aneg    = lan87xx_config_aneg,
>>  
>>         /* IRQ related */
>>         .ack_interrupt  = smsc_phy_ack_interrupt,
>> 
>> The internal phy of the LAN9500A does have a register 16 with
>> documentation matching the usage in this patch.  Unfortunately, there
>> doesn't seem to be any way of distinguishing this from the LAN8710A
>> based on register values.  Anyone got any clever ideas?
>> 
> After reading register PHY_EDPD_CONFIG you could check whether the
> read value is plausible. On the PHY's not supporting this register,
> what is the read value? 0x00 or 0xff? And is this value plausible
> for PHY's supporting this register?

On the LAN8710A I have here, it reads as 0x40.  That bit is "reserved"
without a specified value on the LAN9500A.  On LAN8740A (which also has
a different ID value), it controls Energy Efficient Ethernet

> Currently the PHY driver doesn't check the revision number (last four
> bits of PHY ID). Maybe they differ.

Even if they are different today (I don't seem to have a LAN9500A to
check), nothing guarantees that this will remain the case with future
versions of the chips.

-- 
Måns Rullgård

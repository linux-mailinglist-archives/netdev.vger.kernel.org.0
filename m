Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B22142E04
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 15:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgATOud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 09:50:33 -0500
Received: from foss.arm.com ([217.140.110.172]:33030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgATOud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 09:50:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2047630E;
        Mon, 20 Jan 2020 06:50:32 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC4A13F52E;
        Mon, 20 Jan 2020 06:50:30 -0800 (PST)
Date:   Mon, 20 Jan 2020 14:50:28 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <3b28dcb4-6e52-9a48-bf9c-ddad4cf5e98a@arm.com>
In-Reply-To: <20200118112258.GT25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
 <20200110152215.GF25745@shell.armlinux.org.uk>
 <20200110170457.GH25745@shell.armlinux.org.uk>
 <20200118112258.GT25745@shell.armlinux.org.uk>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2020 11:22, Russell King - ARM Linux admin wrote:
> On Fri, Jan 10, 2020 at 05:04:57PM +0000, Russell King - ARM Linux admin wrote:
>> Maybe something like the below will help?
>>
>> Basically, use phylink_mii_pcs_get_state() instead of
>> axienet_mac_pcs_get_state(), and setup lp->phylink_config.pcs_mii
>> to point at the MII bus, and lp->phylink_config.pcs_mii_addr to
>> access the internal PHY (as per C_PHYADDR parameter.)
>>
>> You may have some fuzz (with gnu patch) while trying to apply this,
>> as you won't have the context for the first and last hunks in this
>> patch.
>>
>> This will probably not be the final version of the patch anyway;
>> there's some possibility to pull some of the functionality out of
>> phylib into a more general library which would avoid some of the
>> functional duplication.
> 
> Hi Andre,
> 
> Did you have a chance to see whether this helps?

Sorry, I needed some time to wrap my head around your reply first. Am I am still not fully finished with this process ;-)
Anyway I observed that when I add 'managed = "in-band-status"' to the DT, it seems to work, because it actually calls axienet_mac_pcs_get_state() to learn the actual negotiated parameters. Then in turn it calls mac_config with the proper speed instead of -1:
[  151.682532] xilinx_axienet 7fe00000.ethernet eth0: configuring for inband/sgmii link mode
[  151.710743] axienet_mac_config(config, mode=2, speed=-1, duplex=255, pause=16)
...
[  153.818568] axienet_mac_pcs_get_state(config): speed=1000, interface=4, pause=0
[  153.842244] axienet_mac_config(config, mode=2, speed=1000, duplex=1, pause=0)

Without that DT property it never called mac_pcs_get_state(), so never learnt about the actual settings.
But the actual MAC setting was already right (1 GBps, FD). Whether this was by chance (reset value?) or because this was set by the PHY via SGMII, I don't know.
So in my case I think I *need* to have the managed = ... property in my DT.

But I was wondering if we need this patch anyway, regardless of the proper way to check for the connection setting in this case. Because at the moment calling mac_config with speed=-1 will *delete* the current MAC speed setting and leave it as 10 Mbps (because this is encoded as 0), when speed is not one of the well-known values. I am not sure that is desired behaviour, or speed=-1 just means: don't touch the speed setting. After all we call mac_config with speed=-1 first, even when later fixing this up (see above).

Thanks,
Andre.

>>
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 75a74a16dc3d..44198fdb3c01 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -2073,4 +2073,105 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
>>  }
>>  EXPORT_SYMBOL_GPL(phylink_select_serdes_interface);
>>  
>> +static void phylink_decode_advertisement(struct phylink_link_state *state)
>> +{
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(u);
>> +
>> +	linkmode_and(u, state->lp_advertising, state->advertising);
>> +
>> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, u)) {
>> +		state->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
>> +	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, u)) {
>> +		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +				      state->lp_advertising))
>> +			state->pause |= MLO_PAUSE_TX;
>> +		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +				      state->advertising))
>> +			state->pause |= MLO_PAUSE_RX;
>> +	}
>> +
>> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, u)) {
>> +		state->speed = SPEED_2500;
>> +		state->duplex = DUPLEX_FULL;
>> +	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, u)) {
>> +		state->pause = SPEED_1000;
>> +		state->duplex = DUPLEX_FULL;
>> +	} else {
>> +		state->link = false;
>> +	}
>> +}
>> +
>> +void phylink_mii_pcs_get_state(struct phylink_config *config,
>> +			       struct phylink_link_state *state)
>> +{
>> +	struct mii_bus *bus = config->pcs_mii;
>> +	int addr = config->pcs_mii_addr;
>> +	int bmsr, lpa;
>> +
>> +	bmsr = mdiobus_read(bus, addr, MII_BMSR);
>> +	lpa = mdiobus_read(bus, addr, MII_LPA);
>> +	if (bmsr < 0 || lpa < 0) {
>> +		state->link = false;
>> +		return;
>> +	}
>> +
>> +	state->link = !!(bmsr & BMSR_LSTATUS);
>> +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
>> +
>> +	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>> +		if (lpa & LPA_1000XFULL)
>> +			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
>> +					 state->lp_advertising);
>> +		goto lpa_8023z;
>> +
>> +	case PHY_INTERFACE_MODE_2500BASEX:
>> +		if (lpa & LPA_1000XFULL)
>> +			linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
>> +					 state->lp_advertising);
>> +	lpa_8023z:
>> +		if (lpa & LPA_1000XPAUSE)
>> +			linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +					 state->lp_advertising);
>> +		if (lpa & LPA_1000XPAUSE_ASYM)
>> +			linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +					 state->lp_advertising);
>> +		if (lpa & LPA_LPACK)
>> +			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>> +					 state->lp_advertising);
>> +		phylink_decode_advertisement(state);
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_SGMII:
>> +		switch (lpa & 0x8c00) {
>> +		case 0x8000:
>> +			state->speed = SPEED_10;
>> +			break;
>> +		case 0x8400:
>> +			state->speed = SPEED_100;
>> +			break;
>> +		case 0x8800:
>> +			state->speed = SPEED_1000;
>> +			break;
>> +		default:
>> +			state->link = false;
>> +			break;
>> +		}
>> +		switch (lpa & 0x9000) {
>> +		case 0x9000:
>> +			state->duplex = DUPLEX_FULL;
>> +			break;
>> +		case 0x8000:
>> +			state->duplex = DUPLEX_HALF;
>> +			break;
>> +		}
>> +		break;
>> +
>> +	default:
>> +		state->link = false;
>> +		break;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(phylink_mii_pcs_get_state);
>> +
>>  MODULE_LICENSE("GPL v2");
>> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
>> index 4ea76e083847..cf0fa39b4b21 100644
>> --- a/include/linux/phylink.h
>> +++ b/include/linux/phylink.h
>> @@ -65,6 +65,9 @@ enum phylink_op_type {
>>  struct phylink_config {
>>  	struct device *dev;
>>  	enum phylink_op_type type;
>> +
>> +	struct mii_bus *pcs_mii;
>> +	int pcs_mii_addr;
>>  };
>>  
>>  /**
>> @@ -292,4 +295,7 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
>>  						const phy_interface_t *pref,
>>  						size_t nprefs);
>>  
>> +void phylink_mii_pcs_get_state(struct phylink_config *config,
>> +			       struct phylink_link_state *state);
>> +
>>  #endif
>>
>> -- 
>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
>> According to speedtest.net: 11.9Mbps down 500kbps up
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 


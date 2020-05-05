Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F311C52B1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgEEKLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:11:51 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:57157 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEKLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 06:11:50 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1628622EE3;
        Tue,  5 May 2020 12:11:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588673505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TavrvyQMANfKvFpZQJK+YCCSxBW1TJw1QF6jiXVLWo=;
        b=HOZrxT3ULLYyQrnStMvo+VNJcUWNe7AB1bfXO4v+E4fwlvaQoxFl2EQJo1CwpMBrDznLXT
        CZBpIpvGpnbiHp6NTexGUyr5lepuT8l/LCT2A9Pi0zC5CvIO47n7gbEVam0YLJPkHUtJs+
        VFgFqACZ8shjd8/PULNCarGQzJ8pJn4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 12:11:45 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 08/10] net: phy: marvell: Add cable test
 support
In-Reply-To: <20200505001821.208534-9-andrew@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-9-andrew@lunn.ch>
Message-ID: <6c50c8892e7639e5b0772c9ea8d37d3a@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 2020-05-05 02:18, schrieb Andrew Lunn:
> The Marvell PHYs have a couple of different register sets for
> performing cable tests. Page 7 provides the simplest to use.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/marvell.c | 202 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 202 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 7fc8e10c5f33..72afc67f7f35 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -27,6 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/mii.h>
>  #include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/phy.h>
>  #include <linux/marvell_phy.h>
>  #include <linux/bitfield.h>
> @@ -35,6 +36,7 @@
>  #include <linux/io.h>
>  #include <asm/irq.h>
>  #include <linux/uaccess.h>
> +#include <uapi/linux/ethtool_netlink.h>
> 
>  #define MII_MARVELL_PHY_PAGE		22
>  #define MII_MARVELL_COPPER_PAGE		0x00
> @@ -42,6 +44,7 @@
>  #define MII_MARVELL_MSCR_PAGE		0x02
>  #define MII_MARVELL_LED_PAGE		0x03
>  #define MII_MARVELL_MISC_TEST_PAGE	0x06
> +#define MII_MARVELL_VCT7_PAGE		0x07
>  #define MII_MARVELL_WOL_PAGE		0x11
> 
>  #define MII_M1011_IEVENT		0x13
> @@ -162,6 +165,36 @@
>  #define MII_88E1510_GEN_CTRL_REG_1_MODE_SGMII	0x1	/* SGMII to copper 
> */
>  #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
> 
> +#define MII_VCT7_PAIR_0_DISTANCE	0x10
> +#define MII_VCT7_PAIR_1_DISTANCE	0x11
> +#define MII_VCT7_PAIR_2_DISTANCE	0x12
> +#define MII_VCT7_PAIR_3_DISTANCE	0x13
> +
> +#define MII_VCT7_RESULTS	0x14
> +#define MII_VCT7_RESULTS_PAIR3_MASK	0xf000
> +#define MII_VCT7_RESULTS_PAIR2_MASK	0x0f00
> +#define MII_VCT7_RESULTS_PAIR1_MASK	0x00f0
> +#define MII_VCT7_RESULTS_PAIR0_MASK	0x000f
> +#define MII_VCT7_RESULTS_PAIR3_SHIFT	12
> +#define MII_VCT7_RESULTS_PAIR2_SHIFT	8
> +#define MII_VCT7_RESULTS_PAIR1_SHIFT	4
> +#define MII_VCT7_RESULTS_PAIR0_SHIFT	0
> +#define MII_VCT7_RESULTS_INVALID	0
> +#define MII_VCT7_RESULTS_OK		1
> +#define MII_VCT7_RESULTS_OPEN		2
> +#define MII_VCT7_RESULTS_SAME_SHORT	3
> +#define MII_VCT7_RESULTS_CROSS_SHORT	4
> +#define MII_VCT7_RESULTS_BUSY		9
> +
> +#define MII_VCT7_CTRL		0x15
> +#define MII_VCT7_CTRL_RUN_NOW			BIT(15)
> +#define MII_VCT7_CTRL_RUN_ANEG			BIT(14)
> +#define MII_VCT7_CTRL_DISABLE_CROSS		BIT(13)
> +#define MII_VCT7_CTRL_RUN_AFTER_BREAK_LINK	BIT(12)
> +#define MII_VCT7_CTRL_IN_PROGRESS		BIT(11)
> +#define MII_VCT7_CTRL_METERS			BIT(10)
> +#define MII_VCT7_CTRL_CENTIMETERS		0
> +
>  #define LPA_PAUSE_FIBER		0x180
>  #define LPA_PAUSE_ASYM_FIBER	0x100
> 
> @@ -1658,6 +1691,163 @@ static void marvell_get_stats(struct phy_device 
> *phydev,
>  		data[i] = marvell_get_stat(phydev, i);
>  }
> 
> +static int marvell_vct7_cable_test_start(struct phy_device *phydev)
> +{
> +	int bmcr, bmsr, ret;
> +
> +	/* If auto-negotiation is enabled, but not complete, the cable
> +	 * test never completes. So disable auto-neg.
> +	 */
> +	bmcr = phy_read(phydev, MII_BMCR);
> +	if (bmcr < 0)
> +		return bmcr;
> +
> +	bmsr = phy_read(phydev, MII_BMSR);
> +
> +	if (bmsr < 0)
> +		return bmsr;
> +
> +	if (bmcr & BMCR_ANENABLE) {
> +		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> +		if (ret < 0)
> +			return ret;
> +		ret = genphy_soft_reset(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* If the link is up, allow it some time to go down */
> +	if (bmsr & BMSR_LSTATUS)
> +		msleep(1500);

Is it mandatory to wait 1.5s unconditionally or can we poll for link 
down?

> +
> +	return phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
> +			       MII_VCT7_CTRL,
> +			       MII_VCT7_CTRL_RUN_NOW |
> +			       MII_VCT7_CTRL_CENTIMETERS);
> +}
> +
> +static int marvell_vct7_distance_to_length(int distance, bool meter)
> +{
> +	if (meter)
> +		distance *= 100;

I've never understood the use of the meter unit. If we always use
centimeters, we have 2^16 cm = 655m, shouldn't that be enough given
that the max cable length is 100m in TP ethernet? Also you hardcode
the unit to centimeters, so this should be superfluous, making this
function a noop.

> +
> +	return distance;
> +}
> +
> +static bool marvell_vct7_distance_valid(int result)
> +{
> +	switch (result) {
> +	case MII_VCT7_RESULTS_OPEN:
> +	case MII_VCT7_RESULTS_SAME_SHORT:
> +	case MII_VCT7_RESULTS_CROSS_SHORT:

btw on the BCM54140 I've observed, that if you have a intra-pair
short, the length is wrong; looks like it is twice the value it
should be.

Does the Marvell PHY report the correct value?

> +		return true;
> +	}
> +	return false;
> +}
> +
> +static int marvell_vct7_report_length(struct phy_device *phydev,
> +				      int pair, bool meter)
> +{
> +	int length;
> +	int ret;
> +
> +	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
> +			     MII_VCT7_PAIR_0_DISTANCE + pair);
> +	if (ret < 0)
> +		return ret;
> +
> +	length = marvell_vct7_distance_to_length(ret, meter);
> +
> +	ethnl_cable_test_fault_length(phydev, pair, length);
> +
> +	return 0;
> +}
> +
> +static int mavell_vct7_cable_test_report_trans(int result)
> +{
> +	switch (result) {
> +	case MII_VCT7_RESULTS_OK:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	case MII_VCT7_RESULTS_OPEN:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> +	case MII_VCT7_RESULTS_SAME_SHORT:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
> +	case MII_VCT7_RESULTS_CROSS_SHORT:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
> +	default:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
> +	}
> +}
> +
> +static int marvell_vct7_cable_test_report(struct phy_device *phydev)
> +{
> +	int pair0, pair1, pair2, pair3;
> +	bool meter;
> +	int ret;
> +
> +	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
> +			     MII_VCT7_RESULTS);
> +	if (ret < 0)
> +		return ret;
> +
> +	pair3 = (ret & MII_VCT7_RESULTS_PAIR3_MASK) >>
> +		MII_VCT7_RESULTS_PAIR3_SHIFT;
> +	pair2 = (ret & MII_VCT7_RESULTS_PAIR2_MASK) >>
> +		MII_VCT7_RESULTS_PAIR2_SHIFT;
> +	pair1 = (ret & MII_VCT7_RESULTS_PAIR1_MASK) >>
> +		MII_VCT7_RESULTS_PAIR1_SHIFT;
> +	pair0 = (ret & MII_VCT7_RESULTS_PAIR0_MASK) >>
> +		MII_VCT7_RESULTS_PAIR0_SHIFT;

I'm sure you know FIELD_GET(), so there must be another
reason why you use mask and shift, consistency?

-michael

> +
> +	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
> +				mavell_vct7_cable_test_report_trans(pair0));
> +	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_B,
> +				mavell_vct7_cable_test_report_trans(pair1));
> +	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_C,
> +				mavell_vct7_cable_test_report_trans(pair2));
> +	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_D,
> +				mavell_vct7_cable_test_report_trans(pair3));
> +
> +	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE, MII_VCT7_CTRL);
> +	if (ret < 0)
> +		return ret;
> +
> +	meter = ret & MII_VCT7_CTRL_METERS;
> +
> +	if (marvell_vct7_distance_valid(pair0))
> +		marvell_vct7_report_length(phydev, 0, meter);
> +	if (marvell_vct7_distance_valid(pair1))
> +		marvell_vct7_report_length(phydev, 1, meter);
> +	if (marvell_vct7_distance_valid(pair2))
> +		marvell_vct7_report_length(phydev, 2, meter);
> +	if (marvell_vct7_distance_valid(pair3))
> +		marvell_vct7_report_length(phydev, 3, meter);
> +
> +	return 0;
> +}
> +
> +static int marvell_vct7_cable_test_get_status(struct phy_device 
> *phydev,
> +					      bool *finished)
> +{
> +	int ret;
> +
> +	*finished = false;
> +
> +	ret = phy_read_paged(phydev, MII_MARVELL_VCT7_PAGE,
> +			     MII_VCT7_CTRL);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!(ret & MII_VCT7_CTRL_IN_PROGRESS)) {
> +		*finished = true;
> +
> +		return marvell_vct7_cable_test_report(phydev);
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_HWMON
>  static int m88e1121_get_temp(struct phy_device *phydev, long *temp)
>  {
> @@ -2353,6 +2543,7 @@ static struct phy_driver marvell_drivers[] = {
>  		.phy_id_mask = MARVELL_PHY_ID_MASK,
>  		.name = "Marvell 88E1510",
>  		.features = PHY_GBIT_FIBRE_FEATURES,
> +		.flags = PHY_POLL_CABLE_TEST,
>  		.probe = &m88e1510_probe,
>  		.config_init = &m88e1510_config_init,
>  		.config_aneg = &m88e1510_config_aneg,
> @@ -2372,12 +2563,15 @@ static struct phy_driver marvell_drivers[] = {
>  		.set_loopback = genphy_loopback,
>  		.get_tunable = m88e1011_get_tunable,
>  		.set_tunable = m88e1011_set_tunable,
> +		.cable_test_start = marvell_vct7_cable_test_start,
> +		.cable_test_get_status = marvell_vct7_cable_test_get_status,
>  	},
>  	{
>  		.phy_id = MARVELL_PHY_ID_88E1540,
>  		.phy_id_mask = MARVELL_PHY_ID_MASK,
>  		.name = "Marvell 88E1540",
>  		/* PHY_GBIT_FEATURES */
> +		.flags = PHY_POLL_CABLE_TEST,
>  		.probe = m88e1510_probe,
>  		.config_init = &marvell_config_init,
>  		.config_aneg = &m88e1510_config_aneg,
> @@ -2394,6 +2588,8 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_stats = marvell_get_stats,
>  		.get_tunable = m88e1540_get_tunable,
>  		.set_tunable = m88e1540_set_tunable,
> +		.cable_test_start = marvell_vct7_cable_test_start,
> +		.cable_test_get_status = marvell_vct7_cable_test_get_status,
>  	},
>  	{
>  		.phy_id = MARVELL_PHY_ID_88E1545,
> @@ -2401,6 +2597,7 @@ static struct phy_driver marvell_drivers[] = {
>  		.name = "Marvell 88E1545",
>  		.probe = m88e1510_probe,
>  		/* PHY_GBIT_FEATURES */
> +		.flags = PHY_POLL_CABLE_TEST,
>  		.config_init = &marvell_config_init,
>  		.config_aneg = &m88e1510_config_aneg,
>  		.read_status = &marvell_read_status,
> @@ -2416,6 +2613,8 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_stats = marvell_get_stats,
>  		.get_tunable = m88e1540_get_tunable,
>  		.set_tunable = m88e1540_set_tunable,
> +		.cable_test_start = marvell_vct7_cable_test_start,
> +		.cable_test_get_status = marvell_vct7_cable_test_get_status,
>  	},
>  	{
>  		.phy_id = MARVELL_PHY_ID_88E3016,
> @@ -2442,6 +2641,7 @@ static struct phy_driver marvell_drivers[] = {
>  		.phy_id_mask = MARVELL_PHY_ID_MASK,
>  		.name = "Marvell 88E6390",
>  		/* PHY_GBIT_FEATURES */
> +		.flags = PHY_POLL_CABLE_TEST,
>  		.probe = m88e6390_probe,
>  		.config_init = &marvell_config_init,
>  		.config_aneg = &m88e6390_config_aneg,
> @@ -2458,6 +2658,8 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_stats = marvell_get_stats,
>  		.get_tunable = m88e1540_get_tunable,
>  		.set_tunable = m88e1540_set_tunable,
> +		.cable_test_start = marvell_vct7_cable_test_start,
> +		.cable_test_get_status = marvell_vct7_cable_test_get_status,
>  	},
>  };

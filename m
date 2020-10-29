Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737BA29E47C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgJ2HiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgJ2HYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:53 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4014CC05BD37;
        Wed, 28 Oct 2020 23:32:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 4D90C1409B1;
        Thu, 29 Oct 2020 07:31:30 +0100 (CET)
Date:   Thu, 29 Oct 2020 07:31:23 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, ashkan.boldaji@digi.com
Subject: Re: [PATCH v6 3/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201029073123.77ba965b@nic.cz>
In-Reply-To: <fc6a7ef241e854106de3f84c4b541ab938fb0cbc.1603944740.git.pavana.sharma@digi.com>
References: <cover.1603944740.git.pavana.sharma@digi.com>
        <fc6a7ef241e854106de3f84c4b541ab938fb0cbc.1603944740.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:42:29 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)
> 
> Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
> Changes in v2:
>   - Fix a warning (Reported-by: kernel test robot <lkp@intel.com>)
> Changes in v3:
>   - Fix 'unused function' warning
> Changes in v4, v5, v6:
>   - Incorporated feedback from maintainers.
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    |  91 +++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h |   2 +
>  drivers/net/dsa/mv88e6xxx/global2.h |   8 +
>  drivers/net/dsa/mv88e6xxx/port.c    | 234 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h    |  43 ++++-
>  drivers/net/dsa/mv88e6xxx/serdes.c  | 225 ++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/serdes.h  |  39 +++++
>  8 files changed, 644 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f0dbc05e30a4..de96fd08e77a 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -634,6 +634,24 @@ static void mv88e6390x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
>  	mv88e6390_phylink_validate(chip, port, mask, state);
>  }
>  
> +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
> +					unsigned long *mask,
> +					struct phylink_link_state *state)
> +{
> +	if (port == 0 || port == 9 || port == 10) {
> +		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseKR_Full);
> +		phylink_set(mask, 5000baseT_Full);
> +		phylink_set(mask, 2500baseX_Full);
> +		phylink_set(mask, 2500baseT_Full);
> +	}
> +
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseX_Full);
> +
> +	mv88e6065_phylink_validate(chip, port, mask, state);
> +}
> +
>  static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
>  			       unsigned long *supported,
>  			       struct phylink_link_state *state)
> @@ -4141,6 +4159,56 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
>  	.phylink_validate = mv88e6390_phylink_validate,
>  };
>  
> +static const struct mv88e6xxx_ops mv88e6193x_ops = {
> +	/* MV88E6XXX_FAMILY_6393 */
> +	.setup_errata = mv88e6393x_setup_errata,
> +	.irl_init_all = mv88e6390_g2_irl_init_all,
> +	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
> +	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
> +	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
> +	.phy_read = mv88e6xxx_g2_smi_phy_read,
> +	.phy_write = mv88e6xxx_g2_smi_phy_write,
> +	.port_set_link = mv88e6xxx_port_set_link,
> +	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
> +	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
> +	.port_tag_remap = mv88e6390_port_tag_remap,
> +	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
> +	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
> +	.port_set_ether_type = mv88e6393x_port_set_ether_type,
> +	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> +	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
> +	.port_pause_limit = mv88e6390_port_pause_limit,
> +	.port_set_cmode = mv88e6393x_port_set_cmode,
> +	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
> +	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> +	.port_get_cmode = mv88e6352_port_get_cmode,
> +	.stats_snapshot = mv88e6390_g1_stats_snapshot,
> +	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
> +	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
> +	.stats_get_strings = mv88e6320_stats_get_strings,
> +	.stats_get_stats = mv88e6390_stats_get_stats,
> +	.set_cpu_port = mv88e6393x_port_set_cpu_dest,
> +	.set_egress_port = mv88e6393x_set_egress_port,
> +	.watchdog_ops = &mv88e6390_watchdog_ops,
> +	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
> +	.pot_clear = mv88e6xxx_g2_pot_clear,
> +	.reset = mv88e6352_g1_reset,
> +	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.vtu_getnext = mv88e6390_g1_vtu_getnext,
> +	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
> +	.serdes_power = mv88e6393x_serdes_power,
> +	.serdes_get_lane = mv88e6393x_serdes_get_lane,
> +	/* Check status register pause & lpa register */

Is this a TODO comment? If so, it should be marked as such.

> +	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
> +	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
> +	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
> +	.serdes_irq_status = mv88e6393x_serdes_irq_status,
> +	.gpio_ops = &mv88e6352_gpio_ops,
> +	.avb_ops = &mv88e6390_avb_ops,
> +	.ptp_ops = &mv88e6352_ptp_ops,
> +	.phylink_validate = mv88e6393x_phylink_validate,
> +};
> +
>  static const struct mv88e6xxx_ops mv88e6240_ops = {
>  	/* MV88E6XXX_FAMILY_6352 */
>  	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
> @@ -5073,6 +5141,29 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.ops = &mv88e6191_ops,
>  	},
>  
> +	[MV88E6193X] = {
> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6193X,
> +		.family = MV88E6XXX_FAMILY_6393,
> +		.name = "Marvell 88E6193X",
> +		.num_databases = 4096,
> +		.num_ports = 11,	/* 10 + Z80 */
> +		.num_internal_phys = 9,
> +		.max_vid = 8191,
> +		.port_base_addr = 0x0,
> +		.phy_base_addr = 0x0,
> +		.global1_addr = 0x1b,
> +		.global2_addr = 0x1c,
> +		.age_time_coeff = 3750,
> +		.g1_irqs = 10,
> +		.g2_irqs = 14,
> +		.atu_move_port_mask = 0x1f,
> +		.pvt = true,
> +		.multi_chip = true,
> +		.tag_protocol = DSA_TAG_PROTO_DSA,
> +		.ptp_support = true,
> +		.ops = &mv88e6193x_ops,
> +	},
> +

Why not add 6393X here as well?

>  	[MV88E6220] = {
>  		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
>  		.family = MV88E6XXX_FAMILY_6250,
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 823ae89e5fca..b7864a24a840 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -63,6 +63,8 @@ enum mv88e6xxx_model {
>  	MV88E6190,
>  	MV88E6190X,
>  	MV88E6191,
> +	MV88E6191X,
> +	MV88E6193X,
>  	MV88E6220,
>  	MV88E6240,
>  	MV88E6250,
> @@ -75,6 +77,7 @@ enum mv88e6xxx_model {
>  	MV88E6352,
>  	MV88E6390,
>  	MV88E6390X,
> +	MV88E6393X,
>  };
>  
>  enum mv88e6xxx_family {
> @@ -90,6 +93,7 @@ enum mv88e6xxx_family {
>  	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
>  	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
>  	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
> +	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
>  };
>  
>  struct mv88e6xxx_ops;
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index 1e3546f8b072..bd17eed15aad 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -22,6 +22,7 @@
>  #define MV88E6185_G1_STS_PPU_STATE_DISABLED		0x8000
>  #define MV88E6185_G1_STS_PPU_STATE_POLLING		0xc000
>  #define MV88E6XXX_G1_STS_INIT_READY			0x0800
> +#define MV88E6193X_G1_STS_IRQ_DEVICE_2			9
>  #define MV88E6XXX_G1_STS_IRQ_AVB			8
>  #define MV88E6XXX_G1_STS_IRQ_DEVICE			7
>  #define MV88E6XXX_G1_STS_IRQ_STATS			6
> @@ -59,6 +60,7 @@
>  #define MV88E6185_G1_CTL1_SCHED_PRIO		0x0800
>  #define MV88E6185_G1_CTL1_MAX_FRAME_1632	0x0400
>  #define MV88E6185_G1_CTL1_RELOAD_EEPROM		0x0200
> +#define MV88E6193X_G1_CTL1_DEVICE2_EN		0x0200

Since the family is called 6393X, please use MV88E6393X prefix for these
macros.

>  #define MV88E6XXX_G1_CTL1_DEVICE_EN		0x0080
>  #define MV88E6XXX_G1_CTL1_STATS_DONE_EN		0x0040
>  #define MV88E6XXX_G1_CTL1_VTU_PROBLEM_EN	0x0020
> diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
> index 1f42ee656816..04696cb68971 100644
> --- a/drivers/net/dsa/mv88e6xxx/global2.h
> +++ b/drivers/net/dsa/mv88e6xxx/global2.h
> @@ -38,9 +38,15 @@
>  /* Offset 0x02: MGMT Enable Register 2x */
>  #define MV88E6XXX_G2_MGMT_EN_2X		0x02
>  
> +/* Offset 0x02: MAC LINK change IRQ Register for MV88E6393X */
> +#define MV88E6393X_G2_MACLINK_INT_SRC		0x02
> +

Here you are using prefix with 6393X, but above you used 6193X, ...

>  /* Offset 0x03: MGMT Enable Register 0x */
>  #define MV88E6XXX_G2_MGMT_EN_0X		0x03
>  
> +/* Offset 0x03: MAC LINK change IRQ Mask Register for MV88E6393X */
> +#define MV88E6393X_G2_MACLINK_INT_MASK		0x03
> +
>  /* Offset 0x04: Flow Control Delay Register */
>  #define MV88E6XXX_G2_FLOW_CTL	0x04
>  
> @@ -52,6 +58,8 @@
>  #define MV88E6XXX_G2_SWITCH_MGMT_FORCE_FLOW_CTL_PRI	0x0080
>  #define MV88E6XXX_G2_SWITCH_MGMT_RSVD2CPU		0x0008
>  
> +#define MV88E6393X_G2_EGRESS_MONITOR_DEST		0x05
> +
>  /* Offset 0x06: Device Mapping Table Register */
>  #define MV88E6XXX_G2_DEVICE_MAPPING		0x06
>  #define MV88E6XXX_G2_DEVICE_MAPPING_UPDATE	0x8000
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 8128dc607cf4..8e36a69d8cad 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -14,6 +14,7 @@
>  #include <linux/phylink.h>
>  
>  #include "chip.h"
> +#include "global2.h"
>  #include "port.h"
>  #include "serdes.h"
>  
> @@ -25,6 +26,14 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
>  	return mv88e6xxx_read(chip, addr, reg, val);
>  }
>  
> +int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
> +		int bit, int val)
> +{
> +	int addr = chip->info->port_base_addr + port;
> +
> +	return mv88e6xxx_wait_bit(chip, addr, reg, bit, val);
> +}
> +
>  int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
>  			 u16 val)
>  {
> @@ -390,6 +399,87 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
>  	return PHY_INTERFACE_MODE_NA;
>  }
>  
> +/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X) */
> +int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
> +		int speed, int duplex)
> +{
> +	u16 reg, ctrl;
> +	int err;
> +
> +	if (speed == SPEED_MAX)
> +		speed = (port > 0 && port < 9) ? 1000 : 10000;
> +
> +	if (speed == 200 && port != 0)
> +		return -EOPNOTSUPP;
> +
> +	if (speed >= 2500 && port > 0 && port < 9)
> +		return -EOPNOTSUPP;
> +
> +	switch (speed) {
> +	case 10:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_10;
> +		break;
> +	case 100:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_100;
> +		break;
> +	case 200:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_100 |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED;
> +		break;
> +	case 1000:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
> +		break;
> +	case 2500:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000 |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED;
> +		break;
> +	case 5000:
> +		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED;
> +		break;
> +	case 10000:
> +	case SPEED_UNFORCED:
> +		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_UNFORCED;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (duplex) {
> +	case DUPLEX_HALF:
> +		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX;
> +		break;
> +	case DUPLEX_FULL:
> +		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
> +			MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL;
> +		break;
> +	case DUPLEX_UNFORCED:
> +		/* normal duplex detection */
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED |
> +			MV88E6390_PORT_MAC_CTL_FORCE_SPEED);
> +
> +	if (speed != SPEED_UNFORCED)
> +		reg |= MV88E6390_PORT_MAC_CTL_FORCE_SPEED;
> +
> +	reg |= ctrl;
> +
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
>  static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  				    phy_interface_t mode, bool force)
>  {
> @@ -421,6 +511,16 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_RXAUI:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_RXAUI;
>  		break;
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		cmode = MV88E6XXX_PORT_STS_CMODE_5GBASER;
> +		break;
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_10GKR:
> +		cmode = MV88E6XXX_PORT_STS_CMODE_10GBASER;
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		cmode = MV88E6XXX_PORT_STS_CMODE_USXGMII;
> +		break;
>  	default:
>  		cmode = 0;
>  	}
> @@ -505,6 +605,15 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
>  }
>  
> +int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> +			      phy_interface_t mode)
> +{
> +	if (port != 0 && port != 9 && port != 10)
> +		return -EOPNOTSUPP;
> +
> +	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
> +}
> +
>  static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
>  					     int port)
>  {
> @@ -1128,6 +1237,131 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_PRI_OVERRIDE, 0);
>  }
>  
> +/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X*/
> +
> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
> +				u8 data)
> +{
> +
> +	int err = 0;
> +	int port;
> +	u16 reg;
> +
> +	/* Setup per Port policy register */
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		if (dsa_is_unused_port(chip->ds, port))
> +			continue;
> +
> +		/* Prevent the use of an invalid port. */
> +		if (mv88e6xxx_is_invalid_port(chip, port)) {
> +			dev_err(chip->dev, "port %d is invalid\n", port);
> +			err = -EINVAL;
> +		}
> +		reg = MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data;
> +		err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL, reg);
> +	}
> +	return err;
> +}
> +
> +int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
> +				enum mv88e6xxx_egress_direction direction,
> +				int port)
> +{
> +	u16 ptr;
> +	int err;
> +
> +	switch (direction) {
> +	case MV88E6XXX_EGRESS_DIR_INGRESS:
> +		ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST;
> +		err = mv88e6393x_port_policy_write(chip, ptr, port);
> +		if (err)
> +			return err;
> +		break;
> +	case MV88E6XXX_EGRESS_DIR_EGRESS:
> +		ptr = MV88E6393X_G2_EGRESS_MONITOR_DEST;
> +		err = mv88e6xxx_g2_write(chip, ptr, port);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +int mv88e6393x_port_set_cpu_dest(struct mv88e6xxx_chip *chip, int port)
> +{
> +	u16 ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST;
> +	u8 data = MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI | port;
> +
> +	return mv88e6393x_port_policy_write(chip, ptr, data);
> +}
> +
> +int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
> +{
> +	u16 ptr;
> +	int err;
> +
> +	/* Consider the frames with reserved multicast destination
> +	 * addresses matching 01:80:c2:00:00:00 and
> +	 * 01:80:c2:00:00:02 as MGMT.
> +	 */
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	ptr = MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI;
> +	err = mv88e6393x_port_policy_write(chip, ptr, 0xff);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/* Offset 0x10 & 0x11: EPC */
> +
> +static int mv88e6393x_epc_wait_ready(struct mv88e6xxx_chip *chip, int port)
> +{
> +	int bit = __bf_shf(MV88E6393X_PORT_EPC_CMD_BUSY);
> +
> +	return mv88e6xxx_port_wait_bit(chip, port, MV88E6393X_PORT_EPC_CMD, bit, 0);
> +}
> +
> +/* Port Ether type for 6393X family */
> +
> +int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
> +					u16 etype)
> +{
> +	u16 val;
> +	int err;
> +
> +	err = mv88e6393x_epc_wait_ready(chip, port);
> +	if (err)
> +		return err;
> +
> +	err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_DATA, etype);
> +	if (err)
> +		return err;
> +
> +	val = MV88E6393X_PORT_EPC_CMD_BUSY |
> +	      MV88E6393X_PORT_EPC_CMD_WRITE |
> +	      MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE;
> +	err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_CMD, val);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
>  /* Offset 0x0f: Port Ether type */
>  
>  int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 44d76ac973f6..fbe16168ac09 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -49,6 +49,9 @@
>  #define MV88E6XXX_PORT_STS_CMODE_2500BASEX	0x000b
>  #define MV88E6XXX_PORT_STS_CMODE_XAUI		0x000c
>  #define MV88E6XXX_PORT_STS_CMODE_RXAUI		0x000d
> +#define MV88E6XXX_PORT_STS_CMODE_5GBASER	0x000c
> +#define MV88E6XXX_PORT_STS_CMODE_10GBASER	0x000d
> +#define MV88E6XXX_PORT_STS_CMODE_USXGMII	0x000e
>  #define MV88E6185_PORT_STS_CDUPLEX		0x0008
>  #define MV88E6185_PORT_STS_CMODE_MASK		0x0007
>  #define MV88E6185_PORT_STS_CMODE_GMII_FD	0x0000
> @@ -117,6 +120,8 @@
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6176	0x1760
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6190	0x1900
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191	0x1910
> +#define MV88E6XXX_PORT_SWITCH_ID_PROD_6191X     0x1920
> +#define MV88E6XXX_PORT_SWITCH_ID_PROD_6193X	0x1930

Different indentation (the first uses spaces, the second uses tabs)

>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185	0x1a70
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6220	0x2200
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240	0x2400
> @@ -129,6 +134,7 @@
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
> +#define MV88E6XXX_PORT_SWITCH_ID_PROD_6393X	0x3930
>  #define MV88E6XXX_PORT_SWITCH_ID_REV_MASK	0x000f
>  
>  /* Offset 0x04: Port Control Register */
> @@ -236,6 +242,19 @@
>  #define MV88E6XXX_PORT_POLICY_CTL_TRAP		0x0002
>  #define MV88E6XXX_PORT_POLICY_CTL_DISCARD	0x0003
>  
> +/* Offset 0x0E: Policy & MGMT Control Register (FAMILY_6393X)*/

Space missing before end of comment */

> +#define MV88E6393X_PORT_POLICY_MGMT_CTL				0x0e
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE			0x8000
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_MASK		0x3f00
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO	0x2000
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI	0x2100
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO	0x2400
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI	0x2500
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST	0x3000
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST		0x3800
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_DATA_MASK		0x00ff
> +#define MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI	0x00e0
> +
>  /* Offset 0x0F: Port Special Ether Type */
>  #define MV88E6XXX_PORT_ETH_TYPE		0x0f
>  #define MV88E6XXX_PORT_ETH_TYPE_DEFAULT	0x9100
> @@ -243,6 +262,15 @@
>  /* Offset 0x10: InDiscards Low Counter */
>  #define MV88E6XXX_PORT_IN_DISCARD_LO	0x10
>  
> +/* Offset 0x10: Extended Port Control Command */
> +#define MV88E6393X_PORT_EPC_CMD		0x10
> +#define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
> +#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
> +#define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
> +
> +/* Offset 0x11: Extended Port Control Data */
> +#define MV88E6393X_PORT_EPC_DATA	0x11
> +
>  /* Offset 0x11: InDiscards High Counter */
>  #define MV88E6XXX_PORT_IN_DISCARD_HI	0x11
>  
> @@ -288,7 +316,8 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
>  			u16 *val);
>  int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
>  			 u16 val);
> -
> +int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
> +		int bit, int val);
>  int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
>  			     int pause);
>  int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
> @@ -312,7 +341,8 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
>  				    int speed, int duplex);
>  int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
>  				     int speed, int duplex);
> -
> +int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
> +					int speed, int duplex);
>  phy_interface_t mv88e6341_port_max_speed_mode(int port);
>  phy_interface_t mv88e6390_port_max_speed_mode(int port);
>  phy_interface_t mv88e6390x_port_max_speed_mode(int port);
> @@ -346,6 +376,13 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
>  			      enum mv88e6xxx_policy_action action);
>  int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
>  				  u16 etype);
> +int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
> +			       enum mv88e6xxx_egress_direction direction,
> +			       int port);
> +int mv88e6393x_port_set_cpu_dest(struct mv88e6xxx_chip *chip, int port);
> +int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
> +int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
> +				u16 etype);
>  int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
>  				    bool message_port);
>  int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
> @@ -362,6 +399,8 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  			     phy_interface_t mode);
>  int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  			      phy_interface_t mode);
> +int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> +			      phy_interface_t mode);
>  int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>  int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>  int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 9c07b4f3d345..9148dd0f4555 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -526,6 +526,26 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
>  	return lane;
>  }
>  
> +/* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane address
> + * a port is using else Returns -ENODEV.
> + */
> +u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	u8 lane = 0;
> +
> +	if (port == 0 || port == 9 || port == 10) {
> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +			cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +			cmode == MV88E6XXX_PORT_STS_CMODE_5GBASER ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_USXGMII)
> +			lane = port;
> +	}
> +	return lane;
> +}
> +
>  /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
>  static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
>  				      bool up)
> @@ -916,6 +936,51 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
>  	return err;
>  }
>  
> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +	    u8 lane, bool enable)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	int err = 0;
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
> +	}
> +
> +	return err;
> +}
> +
> +irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
> +				 u8 lane)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	irqreturn_t ret = IRQ_NONE;
> +	u16 status;
> +	int err;
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
> +		if (err)
> +			return ret;
> +		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
> +			      MV88E6390_SGMII_INT_LINK_UP)) {
> +			ret = IRQ_HANDLED;
> +			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
>  					u8 lane)
>  {
> @@ -999,3 +1064,163 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
>  		p[i] = reg;
>  	}
>  }
> +
> +int mv88e6393x_setup_errata(struct mv88e6xxx_chip *chip)
> +{
> +	u16 config0, config9, config10;
> +	u16 pcs0, pcs9, pcs10;
> +	int err = 0;
> +
> +	/* mv88e6393x family errata 3.8 :
> +	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may not
> +	 * come up after hardware reset or software reset of SERDES core.
> +	 * Workaround is to write SERDES register 4.F074.14 =1 for only those modes
> +	 * and 0 in all other modes.
> +	 */
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config0);
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT9_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config9);
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT10_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config10);
> +
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_SERDES_POC, &pcs0);
> +	pcs0 &= MV88E6393X_SERDES_POC_PCS_MODE_MASK;
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT9_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_SERDES_POC, &pcs9);
> +	pcs9 &= MV88E6393X_SERDES_POC_PCS_MODE_MASK;
> +	err = mv88e6390_serdes_read(chip, MV88E6393X_PORT10_LANE, MDIO_MMD_PHYXS,
> +				    MV88E6393X_SERDES_POC, &pcs10);
> +	pcs10 &= MV88E6393X_SERDES_POC_PCS_MODE_MASK;
> +
> +	if (pcs0 == MV88E6393X_PCS_SELECT_1000BASEX ||
> +		pcs0 == MV88E6393X_PCS_SELECT_SGMII_PHY ||
> +		pcs0 == MV88E6393X_PCS_SELECT_SGMII_MAC) {
> +		config0 |= MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT0_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config0);
> +	} else {
> +		config0 &= ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT0_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config0);
> +	}
> +
> +	if (pcs9 == MV88E6393X_PCS_SELECT_1000BASEX ||
> +		pcs9 == MV88E6393X_PCS_SELECT_SGMII_PHY ||
> +		pcs9 == MV88E6393X_PCS_SELECT_SGMII_MAC) {
> +		config9 |= MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT9_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config9);
> +	} else {
> +		config9 &= ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT9_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config9);
> +	}
> +
> +	if (pcs10 == MV88E6393X_PCS_SELECT_1000BASEX ||
> +		pcs10 == MV88E6393X_PCS_SELECT_SGMII_PHY ||
> +		pcs10 == MV88E6393X_PCS_SELECT_SGMII_MAC) {
> +		config10 |= MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT10_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config10);
> +	} else {
> +		config10 &= ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
> +		err = mv88e6390_serdes_write(chip, MV88E6393X_PORT10_LANE,
> +						MDIO_MMD_PHYXS,
> +						MV88E6393X_ERRATA_1000BASEX_SGMII,
> +						config10);
> +	}
> +	return err;
> +}
> +
> +static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, u8 lane,
> +					bool on)
> +{
> +	u8 cmode = chip->ports[lane].cmode;
> +	u16 config, pcs;
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +		pcs = MV88E6393X_PCS_SELECT_1000BASEX;
> +		break;
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +		pcs = MV88E6393X_PCS_SELECT_2500BASEX;
> +		break;
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		pcs = MV88E6393X_PCS_SELECT_10GBASER;
> +		break;
> +	default:
> +		pcs = MV88E6393X_PCS_SELECT_1000BASEX;
> +		break;
> +	}
> +
> +	if (on) {
> +		/* mv88e6393x family errata 3.6 :
> +		 * When changing c_mode on Port 0 from [x]MII mode to any
> +		 * SERDES mode SERDES will not be operational.
> +		 * Workaround: Set Port0 SERDES register 4.F002.5=0
> +		 */
> +		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, &config);
> +		config &= ~(MV88E6393X_SERDES_POC_PCS_MODE_MASK |
> +				MV88E6393X_SERDES_POC_PDOWN);
> +		config |= pcs;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, config);
> +		config |= MV88E6393X_SERDES_POC_RESET;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, config);
> +
> +		/* mv88e6393x family errata 3.7 :
> +		 * When changing cmode on SERDES port from any other mode to
> +		 * 1000BASE-X mode the link may not come up due to invalid
> +		 * 1000BASE-X advertisement.
> +		 * Workaround: Correct advertisement and reset PHY core.
> +		 */
> +		config = MV88E6390_SGMII_ANAR_1000BASEX_FD;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_ANAR, config);
> +
> +		/* soft reset the PCS/PMA */
> +		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_CONTROL, &config);
> +		config |= MV88E6390_SGMII_CONTROL_RESET;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_CONTROL, config);
> +	}
> +
> +	return 0;
> +}
> +
> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
> +		    bool on)
> +{
> +	lane = mv88e6393x_serdes_get_lane(chip, port);
> +
> +	if (port == 0 || port == 9 || port == 10) {
> +		u8 cmode = chip->ports[port].cmode;
> +
> +		mv88e6393x_serdes_port_config(chip, lane, on);
> +
> +		switch (cmode) {
> +		case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +		case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +			return mv88e6390_serdes_power_sgmii(chip, lane, on);
> +		case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +			return mv88e6390_serdes_power_10g(chip, lane, on);
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
> index 14315f26228a..c3eaaaac8619 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.h
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.h
> @@ -68,15 +68,47 @@
>  #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
>  #define MV88E6390_SGMII_PHY_STATUS_TX_PAUSE	BIT(3)
>  #define MV88E6390_SGMII_PHY_STATUS_RX_PAUSE	BIT(2)
> +#define MV88E6390_SGMII_STATUS_AN_ABLE	BIT(3)
> +#define MV88E6390_SGMII_ANAR	0x2004
> +#define MV88E6390_SGMII_ANAR_1000BASEX_FD	BIT(5)
> +#define MV88E6390_SGMII_CONTROL		0x2000
> +#define MV88E6390_SGMII_CONTROL_RESET		BIT(15)
> +#define MV88E6390_SGMII_CONTROL_LOOPBACK	BIT(14)
> +#define MV88E6390_SGMII_CONTROL_PDOWN		BIT(11)
> +#define MV88E6390_SGMII_STATUS		0x2001
>  
>  /* Packet generator pad packet checker */
>  #define MV88E6390_PG_CONTROL		0xf010
>  #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
>  
> +#define MV88E6393X_PORT0_LANE		0x00
> +#define MV88E6393X_PORT9_LANE		0x09
> +#define MV88E6393X_PORT10_LANE		0x0a
> +
> +/* Port Operational Configuration */
> +#define MV88E6393X_PCS_SELECT_1000BASEX		0x0000
> +#define MV88E6393X_PCS_SELECT_2500BASEX		0x0001
> +#define MV88E6393X_PCS_SELECT_SGMII_PHY		0x0002
> +#define MV88E6393X_PCS_SELECT_SGMII_MAC		0x0003
> +#define MV88E6393X_PCS_SELECT_5GBASER		0x0004
> +#define MV88E6393X_PCS_SELECT_10GBASER		0x0005
> +#define MV88E6393X_PCS_SELECT_USXGMII_PHY	0x0006
> +#define MV88E6393X_PCS_SELECT_USXGMII_MAC	0x0007
> +
> +#define MV88E6393X_SERDES_POC		0xf002
> +#define MV88E6393X_SERDES_POC_PCS_MODE_MASK		0x0007
> +#define MV88E6393X_SERDES_POC_RESET		BIT(15)
> +#define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
> +#define MV88E6393X_SERDES_POC_ANEG		BIT(3)
> +
> +#define MV88E6393X_ERRATA_1000BASEX_SGMII		0xF074
> +#define MV88E6393X_ERRATA_1000BASEX_SGMII_BIT	BIT(14)
> +
>  u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
>  u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
>  u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
>  u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
> +u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
>  				u8 lane, unsigned int mode,
>  				phy_interface_t interface,
> @@ -105,14 +137,21 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
>  			   bool on);
>  int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
>  			   bool on);
> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
> +		    bool on);
> +int mv88e6393x_setup_errata(struct mv88e6xxx_chip *chip);
>  int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
>  				bool enable);
>  int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
>  				bool enable);
> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +	    u8 lane, bool enable);
>  irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
>  					u8 lane);
>  irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
>  					u8 lane);
> +irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
> +					u8 lane);
>  int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
>  				 int port, uint8_t *data);


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9E2DF138
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 20:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgLSTMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 14:12:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgLSTMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 14:12:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kqhe1-00Cspq-Jm; Sat, 19 Dec 2020 20:11:57 +0100
Date:   Sat, 19 Dec 2020 20:11:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 2/8] net: sparx5: add the basic sparx5 driver
Message-ID: <20201219191157.GC3026679@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 08:51:28AM +0100, Steen Hegelund wrote:

> +static struct sparx5_io_resource sparx5_iomap[] =  {

This could be made const i think,.

> +	{ TARGET_DEV2G5,         0,         0 }, /* 0x610004000: dev2g5_0 */
> +	{ TARGET_DEV5G,          0x4000,    0 }, /* 0x610008000: dev5g_0 */
> +	{ TARGET_PCS5G_BR,       0x8000,    0 }, /* 0x61000c000: pcs5g_br_0 */
> +	{ TARGET_DEV2G5 + 1,     0xc000,    0 }, /* 0x610010000: dev2g5_1 */

> +static int sparx5_create_targets(struct sparx5 *sparx5)
> +{
> +	int idx, jdx;
> +	struct resource *iores[IO_RANGES];
> +	void __iomem *iomem[IO_RANGES];
> +	void __iomem *begin[IO_RANGES];
> +	int range_id[IO_RANGES];

Reverse Christmas tree. idx, jdx need to come last.

> +
> +	/* Check if done previously (deferred by serdes load) */
> +	if (sparx5->regs[sparx5_iomap[0].id])
> +		return 0;

Could you explain this a bit more. Do you mean -EPROBE_DEFER?

> +static int sparx5_probe_port(struct sparx5 *sparx5,
> +			     struct device_node *portnp,
> +			     struct phy *serdes,
> +			     u32 portno,
> +			     struct sparx5_port_config *conf)
> +{
> +	struct sparx5_port *spx5_port;
> +	struct net_device *ndev;
> +	int err;
> +
> +	err = sparx5_create_targets(sparx5);
> +	if (err)
> +		return err;

This sees odd here. Don't sparx5_create_targets() create all the
targets, where as this creates one specific port? Seems like
sparx5_create_targets() should be in the devices as a whole probe, not
the port probe.

> +	spx5_port = netdev_priv(ndev);
> +	spx5_port->of_node = portnp;
> +	spx5_port->serdes = serdes;
> +	spx5_port->pvid = NULL_VID;
> +	spx5_port->signd_internal = true;
> +	spx5_port->signd_active_high = true;
> +	spx5_port->signd_enable = true;
> +	spx5_port->flow_control = false;
> +	spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
> +	spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
> +	spx5_port->custom_etype = 0x8880; /* Vitesse */
> +	conf->portmode = conf->phy_mode;
> +	spx5_port->conf.speed = SPEED_UNKNOWN;
> +	spx5_port->conf.power_down = true;
> +	sparx5->ports[portno] = spx5_port;
> +	return 0;

I'm also not sure this has the correct name. This does not look like a
typical probe function.


> +}
> +
> +static int sparx5_init_switchcore(struct sparx5 *sparx5)
> +{
> +	u32 value, pending, jdx, idx;
> +	struct {
> +		bool gazwrap;
> +		void __iomem *init_reg;
> +		u32  init_val;
> +	} ram, ram_init_list[] = {
> +		{false, spx5_reg_get(sparx5, ANA_AC_STAT_RESET),
> +		 ANA_AC_STAT_RESET_RESET},
> +		{false, spx5_reg_get(sparx5, ASM_STAT_CFG),
> +		 ASM_STAT_CFG_STAT_CNT_CLR_SHOT},
> +		{true,  spx5_reg_get(sparx5, QSYS_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, REW_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, VOP_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, ANA_AC_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, ASM_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, EACL_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, VCAP_SUPER_RAM_INIT), 0},
> +		{true,  spx5_reg_get(sparx5, DSM_RAM_INIT), 0}
> +	};

Looks like this could be const as well. And this does not really fit
reverse christmas tree.

> +
> +	spx5_rmw(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(1),
> +		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
> +		 sparx5,
> +		 EACL_POL_EACL_CFG);
> +
> +	spx5_rmw(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(0),
> +		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
> +		 sparx5,
> +		 EACL_POL_EACL_CFG);
> +
> +	/* Initialize memories, if not done already */
> +	value = spx5_rd(sparx5, HSCH_RESET_CFG);
> +
> +	if (!(value & HSCH_RESET_CFG_CORE_ENA)) {
> +		for (idx = 0; idx < 10; idx++) {
> +			pending = ARRAY_SIZE(ram_init_list);
> +			for (jdx = 0; jdx < ARRAY_SIZE(ram_init_list); jdx++) {
> +				ram = ram_init_list[jdx];
> +				if (ram.gazwrap)
> +					ram.init_val = QSYS_RAM_INIT_RAM_INIT;
> +
> +				if (idx == 0) {
> +					writel(ram.init_val, ram.init_reg);
> +				} else {
> +					value = readl(ram.init_reg);
> +					if ((value & ram.init_val) !=
> +					    ram.init_val) {
> +						pending--;
> +					}
> +				}
> +			}
> +			if (!pending)
> +				break;
> +			usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
> +		}

You are getting pretty deeply nested here. Might be better to pull
this out into a helpers.

> +
> +		if (pending > 0) {
> +			/* Still initializing, should be complete in
> +			 * less than 1ms
> +			 */
> +			dev_err(sparx5->dev, "Memory initialization error\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Reset counters */
> +	spx5_wr(ANA_AC_STAT_RESET_RESET_SET(1), sparx5, ANA_AC_STAT_RESET);
> +	spx5_wr(ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(1), sparx5, ASM_STAT_CFG);
> +
> +	/* Enable switch-core and queue system */
> +	spx5_wr(HSCH_RESET_CFG_CORE_ENA_SET(1), sparx5, HSCH_RESET_CFG);
> +
> +	return 0;
> +}
> +
> +static int sparx5_init_coreclock(struct sparx5 *sparx5)
> +{
> +	u32 clk_div, clk_period, pol_upd_int, idx;
> +	enum sparx5_core_clockfreq freq = sparx5->coreclock;

More reverse christmas tree. Please review the whole driver.

> +
> +	/* Verify if core clock frequency is supported on target.
> +	 * If 'VTSS_CORE_CLOCK_DEFAULT' then the highest supported
> +	 * freq. is used
> +	 */
> +	switch (sparx5->target_ct) {
> +	case SPX5_TARGET_CT_7546:
> +		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
> +			freq = SPX5_CORE_CLOCK_250MHZ;
> +		else if (sparx5->coreclock != SPX5_CORE_CLOCK_250MHZ)
> +			freq = 0; /* Not supported */
> +		break;
> +	case SPX5_TARGET_CT_7549:
> +	case SPX5_TARGET_CT_7552:
> +	case SPX5_TARGET_CT_7556:
> +		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
> +			freq = SPX5_CORE_CLOCK_500MHZ;
> +		else if (sparx5->coreclock != SPX5_CORE_CLOCK_500MHZ)
> +			freq = 0; /* Not supported */
> +		break;
> +	case SPX5_TARGET_CT_7558:
> +	case SPX5_TARGET_CT_7558TSN:
> +		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
> +			freq = SPX5_CORE_CLOCK_625MHZ;
> +		else if (sparx5->coreclock != SPX5_CORE_CLOCK_625MHZ)
> +			freq = 0; /* Not supported */
> +		break;
> +	case SPX5_TARGET_CT_7546TSN:
> +		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
> +			freq = SPX5_CORE_CLOCK_625MHZ;
> +		break;
> +	case SPX5_TARGET_CT_7549TSN:
> +	case SPX5_TARGET_CT_7552TSN:
> +	case SPX5_TARGET_CT_7556TSN:
> +		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
> +			freq = SPX5_CORE_CLOCK_625MHZ;
> +		else if (sparx5->coreclock == SPX5_CORE_CLOCK_250MHZ)
> +			freq = 0; /* Not supported */
> +		break;
> +	default:
> +		dev_err(sparx5->dev, "Target (%#04x) not supported\n", sparx5->target_ct);

netdev is staying with 80 character lines. Please fold this, here and
every where else, where possible. The exception is, you should not
split a string.

> +		return -ENODEV;
> +	}
> +
> +	switch (freq) {
> +	case SPX5_CORE_CLOCK_250MHZ:
> +		clk_div = 10;
> +		pol_upd_int = 312;
> +		break;
> +	case SPX5_CORE_CLOCK_500MHZ:
> +		clk_div = 5;
> +		pol_upd_int = 624;
> +		break;
> +	case SPX5_CORE_CLOCK_625MHZ:
> +		clk_div = 4;
> +		pol_upd_int = 780;
> +		break;
> +	default:
> +		dev_err(sparx5->dev, "%s: Frequency (%d) not supported on target (%#04x)\n",
> +			__func__,
> +			sparx5->coreclock, sparx5->target_ct);
> +		return 0;

-EINVAL? Or is it not fatal to use an unsupported frequency?

> +static int sparx5_init(struct sparx5 *sparx5)
> +{
> +	u32 idx;
> +
> +	if (sparx5_create_targets(sparx5))
> +		return -ENODEV;

Hum, sparx5_create_targets() again?

> +
> +	/* Read chip ID to check CPU interface */
> +	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
> +
> +	sparx5->target_ct = (enum spx5_target_chiptype)
> +		GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
> +
> +	/* Initialize Switchcore and internal RAMs */
> +	if (sparx5_init_switchcore(sparx5)) {
> +		dev_err(sparx5->dev, "Switchcore initialization error\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Initialize the LC-PLL (core clock) and set affected registers */
> +	if (sparx5_init_coreclock(sparx5)) {
> +		dev_err(sparx5->dev, "LC-PLL initialization error\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Setup own UPSIDs */
> +	for (idx = 0; idx < 3; idx++) {
> +		spx5_wr(idx, sparx5, ANA_AC_OWN_UPSID(idx));
> +		spx5_wr(idx, sparx5, ANA_CL_OWN_UPSID(idx));
> +		spx5_wr(idx, sparx5, ANA_L2_OWN_UPSID(idx));
> +		spx5_wr(idx, sparx5, REW_OWN_UPSID(idx));
> +	}
> +
> +	/* Enable switch ports */
> +	for (idx = SPX5_PORTS; idx < SPX5_PORTS_ALL; idx++) {
> +		spx5_rmw(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1),
> +			 QFWD_SWITCH_PORT_MODE_PORT_ENA,
> +			 sparx5,
> +			 QFWD_SWITCH_PORT_MODE(idx));
> +	}

What happens when you enable the ports? Why is this here, and not in
the port specific open call?

> +/* Some boards needs to map the SGPIO for signal detect explicitly to the
> + * port module
> + */
> +static void sparx5_board_init(struct sparx5 *sparx5)
> +{
> +	int idx;
> +
> +	if (!sparx5->sd_sgpio_remapping)
> +		return;
> +
> +	/* Enable SGPIO Signal Detect remapping */
> +	spx5_rmw(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
> +		 GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
> +		 sparx5,
> +		 GCB_HW_SGPIO_SD_CFG);
> +
> +	/* Refer to LOS SGPIO */
> +	for (idx = 0; idx < SPX5_PORTS; idx++) {
> +		if (sparx5->ports[idx]) {
> +			if (sparx5->ports[idx]->conf.sd_sgpio != ~0) {
> +				spx5_wr(sparx5->ports[idx]->conf.sd_sgpio,
> +					sparx5,
> +					GCB_HW_SGPIO_TO_SD_MAP_CFG(idx));
> +			}
> +		}
> +	}
> +}

I've not looked at how you do SFP integration yet. Is this the LOS
from the SFP socket? Is there a Linux GPIO controller exported by this
driver, so the SFP driver can use the GPIOs?

> +
> +static int mchp_sparx5_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct sparx5 *sparx5;
> +	struct device_node *ports, *portnp;
> +	const u8 *mac_addr;
> +	int err = 0;
> +
> +	if (!np && !pdev->dev.platform_data)
> +		return -ENODEV;
> +
> +	sparx5 = devm_kzalloc(&pdev->dev, sizeof(*sparx5), GFP_KERNEL);
> +	if (!sparx5)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, sparx5);
> +	sparx5->pdev = pdev;
> +	sparx5->dev = &pdev->dev;
> +
> +	/* Default values, some from DT */
> +	sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
> +
> +	mac_addr = of_get_mac_address(np);
> +	if (IS_ERR_OR_NULL(mac_addr)) {
> +		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
> +		eth_random_addr(sparx5->base_mac);
> +		sparx5->base_mac[5] = 0;
> +	} else {
> +		ether_addr_copy(sparx5->base_mac, mac_addr);
> +	}

The binding document does not say anything about a MAC address at the
top level. What is this used for?

+
> +	if (sparx5_init(sparx5)) {
> +		dev_err(sparx5->dev, "Init failed\n");
> +		return -ENODEV;
> +	}
> +	ports = of_get_child_by_name(np, "ethernet-ports");
> +	if (!ports) {
> +		dev_err(sparx5->dev, "no ethernet-ports child node found\n");
> +		return -ENODEV;
> +	}
> +	sparx5->port_count = of_get_child_count(ports);
> +
> +	for_each_available_child_of_node(ports, portnp) {
> +		struct sparx5_port_config config = {};
> +		u32 portno;
> +		struct phy *serdes;
> +
> +		err = of_property_read_u32(portnp, "reg", &portno);
> +		if (err) {
> +			dev_err(sparx5->dev, "port reg property error\n");
> +			continue;
> +		}
> +		err = of_property_read_u32(portnp, "max-speed",
> +					   &config.max_speed);
> +		if (err) {
> +			dev_err(sparx5->dev, "port max-speed property error\n");
> +			continue;
> +		}
> +		config.speed = SPEED_UNKNOWN;
> +		err = of_property_read_u32(portnp, "sd_sgpio", &config.sd_sgpio);

Not in the binding documentation. I think i need to withdraw my Reviewed-by :-(

> +		if (err)
> +			config.sd_sgpio = ~0;
> +		else
> +			sparx5->sd_sgpio_remapping = true;
> +		serdes = devm_of_phy_get(sparx5->dev, portnp, NULL);
> +		if (IS_ERR(serdes)) {
> +			err = PTR_ERR(serdes);
> +			if (err != -EPROBE_DEFER)
> +				dev_err(sparx5->dev,
> +					"missing SerDes phys for port%d\n",
> +					portno);
> +			return err;
> +		}
> +
> +		err = of_get_phy_mode(portnp, &config.phy_mode);
> +		if (err)
> +			config.power_down = true;

You should indicate in the binding it is optional. And what happens
when it is missing.

> +		config.media_type = ETH_MEDIA_DAC;
> +		config.serdes_reset = true;
> +		config.portmode = config.phy_mode;
> +		err = sparx5_probe_port(sparx5, portnp, serdes, portno, &config);
> +		if (err) {
> +			dev_err(sparx5->dev, "port probe error\n");
> +			goto cleanup_ports;
> +		}
> +	}
> +	sparx5_board_init(sparx5);
> +
> +cleanup_ports:
> +	return err;

Seems missed named, no cleanup.

> +static int __init sparx5_switch_reset(void)
> +{
> +	const char *syscon_cpu = "microchip,sparx5-cpu-syscon",
> +		*syscon_gcb = "microchip,sparx5-gcb-syscon";
> +	struct regmap *cpu_ctrl, *gcb_ctrl;
> +	u32 val;
> +
> +	cpu_ctrl = syscon_regmap_lookup_by_compatible(syscon_cpu);
> +	if (IS_ERR(cpu_ctrl)) {
> +		pr_err("No '%s' syscon map\n", syscon_cpu);
> +		return PTR_ERR(cpu_ctrl);
> +	}
> +
> +	gcb_ctrl = syscon_regmap_lookup_by_compatible(syscon_gcb);
> +	if (IS_ERR(gcb_ctrl)) {
> +		pr_err("No '%s' syscon map\n", syscon_gcb);
> +		return PTR_ERR(gcb_ctrl);
> +	}
> +
> +	/* Make sure the core is PROTECTED from reset */
> +	regmap_update_bits(cpu_ctrl, RESET_PROT_STAT,
> +			   SYS_RST_PROT_VCORE, SYS_RST_PROT_VCORE);
> +
> +	regmap_write(gcb_ctrl, spx5_offset(GCB_SOFT_RST),
> +		     GCB_SOFT_RST_SOFT_SWC_RST_SET(1));
> +
> +	return readx_poll_timeout(sparx5_read_gcb_soft_rst, gcb_ctrl, val,
> +				  GCB_SOFT_RST_SOFT_SWC_RST_GET(val) == 0,
> +				  1, 100);
> +}
> +postcore_initcall(sparx5_switch_reset);

That is pretty unusual. Why cannot this be done at probe time?

> +/* Clock period in picoseconds */
> +static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
> +{
> +	switch (cclock) {
> +	case SPX5_CORE_CLOCK_250MHZ:
> +		return 4000;
> +	case SPX5_CORE_CLOCK_500MHZ:
> +		return 2000;
> +	case SPX5_CORE_CLOCK_625MHZ:
> +	default:
> +		return 1600;
> +	}
> +}

Is this something which is used in the hot path?

> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
> @@ -0,0 +1,3922 @@
> +/* SPDX-License-Identifier: GPL-2.0+
> + * Microchip Sparx5 Switch driver
> + *
> + * Copyright (c) 2020 Microchip Technology Inc.
> + */
> +
> +/* This file is autogenerated by cml-utils 2020-11-19 10:41:34 +0100.
> + * Commit ID: f34790e69dc252103e2cc3e85b1a5e4d9e3aa190
> + */

How reproducible this is generation process? If you have to run it
again, will it keep the same order of lines?

       Andrew 

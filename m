Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54FF3952EB
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhE3VBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 17:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhE3VA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 17:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97137601FD;
        Sun, 30 May 2021 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622408361;
        bh=tROU3KEbNt3YW6dQhPldNgPXNj4MPRrhK8hA1bwsCC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=imHcyB7DP4FVKnHJt2PToNlYKLsrt2NTrriG9+5cteOElTbUN+ib7qiU309JnSHcb
         e6HN7HYhMxLiQgnqEw7ZumMIEDEWRupqFNo+HYUI1BCX2sssXwxslfF7aIq9t2NZ6L
         F+f1p4fLY5krkDc/O2hG5M74hmn0xaXRwTHm/E+8XMutDVVcQKZRqCm3l8bGc89Ru+
         4KjVhBXs2hlUpFAI5tp20qN1ntooeZyuNylF96ojBGRIRGuwsXOPq5bvbhJ3zN1iiq
         W0dUb0C5S8fARlaK8NbAMonqV2Htx+4ZFticUqXW0W+oLpeKJS9HP1g1IkjyTV07bu
         cdDwyO8a71FGA==
Date:   Sun, 30 May 2021 13:59:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 02/10] net: sparx5: add the basic sparx5
 driver
Message-ID: <20210530135919.3f64cf33@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528123419.1142290-3-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
        <20210528123419.1142290-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 14:34:11 +0200 Steen Hegelund wrote:
> This adds the Sparx5 basic SwitchDev driver framework with IO range
> mapping, switch device detection and core clock configuration.
> 
> Support for ports, phylink, netdev, mactable etc. are in the following
> patches.

> +	for (idx = 0; idx < 3; idx++) {
> +		spx5_rmw(GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(clk_period / 100),
> +			 GCB_SIO_CLOCK_SYS_CLK_PERIOD,
> +			 sparx5,
> +			 GCB_SIO_CLOCK(idx));
> +	}

braces unnecessary, please fix everywhere.

> +
> +	spx5_rmw(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET
> +		 ((256 * 1000) / clk_period),
> +		 HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY,
> +		 sparx5,
> +		 HSCH_TAS_STATEMACHINE_CFG);
> +
> +	spx5_rmw(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(pol_upd_int),
> +		 ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT,
> +		 sparx5,
> +		 ANA_AC_POL_POL_UPD_INT_CFG);
> +
> +	return 0;
> +}

> +	/* Default values, some from DT */
> +	sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
> +
> +	ports = of_get_child_by_name(np, "ethernet-ports");

Don't you need to release the reference you got on @ports?

> +	if (!ports) {
> +		dev_err(sparx5->dev, "no ethernet-ports child node found\n");
> +		return -ENODEV;
> +	}
> +	sparx5->port_count = of_get_child_count(ports);
> +
> +	configs = kcalloc(sparx5->port_count,
> +			  sizeof(struct initial_port_config), GFP_KERNEL);
> +	if (!configs)
> +		return -ENOMEM;
> +
> +	for_each_available_child_of_node(ports, portnp) {
> +		struct sparx5_port_config *conf;
> +		struct phy *serdes;
> +		u32 portno;
> +
> +		err = of_property_read_u32(portnp, "reg", &portno);
> +		if (err) {
> +			dev_err(sparx5->dev, "port reg property error\n");
> +			continue;
> +		}
> +		config = &configs[idx];
> +		conf = &config->conf;
> +		err = of_get_phy_mode(portnp, &conf->phy_mode);
> +		if (err) {
> +			dev_err(sparx5->dev, "port %u: missing phy-mode\n",
> +				portno);
> +			continue;
> +		}
> +		err = of_property_read_u32(portnp, "microchip,bandwidth",
> +					   &conf->bandwidth);
> +		if (err) {
> +			dev_err(sparx5->dev, "port %u: missing bandwidth\n",
> +				portno);
> +			continue;
> +		}
> +		err = of_property_read_u32(portnp, "microchip,sd-sgpio", &conf->sd_sgpio);
> +		if (err)
> +			conf->sd_sgpio = ~0;
> +		else
> +			sparx5->sd_sgpio_remapping = true;
> +		serdes = devm_of_phy_get(sparx5->dev, portnp, NULL);
> +		if (IS_ERR(serdes)) {
> +			err = PTR_ERR(serdes);
> +			if (err != -EPROBE_DEFER)
> +				dev_err(sparx5->dev,
> +					"port %u: missing serdes\n",
> +					portno);

dev_err_probe()

> +			goto cleanup_config;
> +		}
> +		config->portno = portno;
> +		config->node = portnp;
> +		config->serdes = serdes;
> +
> +		conf->media = PHY_MEDIA_DAC;
> +		conf->serdes_reset = true;
> +		conf->portmode = conf->phy_mode;
> +		if (of_find_property(portnp, "sfp", NULL)) {
> +			conf->has_sfp = true;
> +			conf->power_down = true;
> +		}
> +		idx++;
> +	}
> +
> +	err = sparx5_create_targets(sparx5);
> +	if (err)
> +		goto cleanup_config;
> +
> +	if (of_get_mac_address(np, mac_addr)) {
> +		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
> +		eth_random_addr(sparx5->base_mac);
> +		sparx5->base_mac[5] = 0;
> +	} else {
> +		ether_addr_copy(sparx5->base_mac, mac_addr);
> +	}
> +
> +	/* Inj/Xtr IRQ support to be added in later patches */
> +	/* Read chip ID to check CPU interface */
> +	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
> +
> +	sparx5->target_ct = (enum spx5_target_chiptype)
> +		GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
> +
> +	/* Initialize Switchcore and internal RAMs */
> +	if (sparx5_init_switchcore(sparx5)) {
> +		dev_err(sparx5->dev, "Switchcore initialization error\n");
> +		goto cleanup_config;

Should @err be set?

> +	}
> +
> +	/* Initialize the LC-PLL (core clock) and set affected registers */
> +	if (sparx5_init_coreclock(sparx5)) {
> +		dev_err(sparx5->dev, "LC-PLL initialization error\n");
> +		goto cleanup_config;

ditto

> +	}
> +
> +	for (idx = 0; idx < sparx5->port_count; ++idx) {
> +		config = &configs[idx];
> +		if (!config->node)
> +			continue;
> +
> +		err = sparx5_create_port(sparx5, config);
> +		if (err) {
> +			dev_err(sparx5->dev, "port create error\n");
> +			goto cleanup_ports;
> +		}
> +	}
> +
> +	if (sparx5_start(sparx5)) {
> +		dev_err(sparx5->dev, "Start failed\n");
> +		goto cleanup_ports;

and here

> +	}
> +
> +	kfree(configs);
> +	return err;
> +
> +cleanup_ports:
> +	/* Port cleanup to be added in later patches */
> +cleanup_config:
> +	kfree(configs);
> +	return err;
> +}

> +struct sparx5_port_config      {

Spurious tab before {?

> +	phy_interface_t portmode;
> +	bool has_sfp;
> +	u32 bandwidth;
> +	int speed;
> +	int duplex;
> +	enum phy_media media;
> +	bool power_down;
> +	bool autoneg;
> +	u32 pause;
> +	bool serdes_reset;

Group all 4 bools together for better packing?

> +	phy_interface_t phy_mode;
> +	u32 sd_sgpio;
> +};

> +static inline void spx5_rmw(u32 val, u32 mask, struct sparx5 *sparx5,
> +			    int id, int tinst, int tcnt,
> +			    int gbase, int ginst, int gcnt, int gwidth,
> +			    int raddr, int rinst, int rcnt, int rwidth)
> +{
> +	u32 nval;
> +	void __iomem *addr =
> +		spx5_addr(sparx5->regs, id, tinst, tcnt,

Why try to initialize inline when it results in weird looking code and
no saved lines?

> +			  gbase, ginst, gcnt, gwidth,
> +			  raddr, rinst, rcnt, rwidth);

Not to mention that you end up with no new line after variable
declaration.

> +	nval = readl(addr);
> +	nval = (nval & ~mask) | (val & mask);
> +	writel(nval, addr);
> +}

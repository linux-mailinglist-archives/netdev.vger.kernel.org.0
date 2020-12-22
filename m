Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF122E0C4F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgLVPCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:02:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgLVPCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 10:02:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krjAA-00DOpW-57; Tue, 22 Dec 2020 16:01:22 +0100
Date:   Tue, 22 Dec 2020 16:01:22 +0100
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
Message-ID: <20201222150122.GM3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-3-steen.hegelund@microchip.com>
 <20201219191157.GC3026679@lunn.ch>
 <37309f64bf0bb94e55bc2db4c482c1e3e7f1be6f.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37309f64bf0bb94e55bc2db4c482c1e3e7f1be6f.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void sparx5_board_init(struct sparx5 *sparx5)
> > > +{
> > > +     int idx;
> > > +
> > > +     if (!sparx5->sd_sgpio_remapping)
> > > +             return;
> > > +
> > > +     /* Enable SGPIO Signal Detect remapping */
> > > +     spx5_rmw(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
> > > +              GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
> > > +              sparx5,
> > > +              GCB_HW_SGPIO_SD_CFG);
> > > +
> > > +     /* Refer to LOS SGPIO */
> > > +     for (idx = 0; idx < SPX5_PORTS; idx++) {
> > > +             if (sparx5->ports[idx]) {
> > > +                     if (sparx5->ports[idx]->conf.sd_sgpio != ~0)
> > > {
> > > +                             spx5_wr(sparx5->ports[idx]-
> > > >conf.sd_sgpio,
> > > +                                     sparx5,
> > > +                                    
> > > GCB_HW_SGPIO_TO_SD_MAP_CFG(idx));
> > > +                     }
> > > +             }
> > > +     }
> > > +}
> > 
> > I've not looked at how you do SFP integration yet. Is this the LOS
> > from the SFP socket? Is there a Linux GPIO controller exported by
> > this
> > driver, so the SFP driver can use the GPIOs?
> 
> Yes the SFP driver (used by the Sparx5 SerDes driver) will use the
> SGPIO LOS, Module Detect etc, and the Port Modules are aware of the
> location of the LOS, and use this by default without any driver
> configuration.
> But on the PCB134 the SGPIOs are shifted one bit by a mistake, and they
> are not located in the expected position, so we have this board
> remapping function to handle that aspect.

Is it possible to turn this off in the hardware? It might be less
confusing if LOS it determined by phylink, not phylink and the switch
itself. Especially when we get into race conditions between PHYLINK
polling the GPIO and the hardware taking the short cut?


> > > +static int mchp_sparx5_probe(struct platform_device *pdev)
> > > +{
> > > +     struct device_node *np = pdev->dev.of_node;
> > > +     struct sparx5 *sparx5;
> > > +     struct device_node *ports, *portnp;
> > > +     const u8 *mac_addr;
> > > +     int err = 0;
> > > +
> > > +     if (!np && !pdev->dev.platform_data)
> > > +             return -ENODEV;
> > > +
> > > +     sparx5 = devm_kzalloc(&pdev->dev, sizeof(*sparx5),
> > > GFP_KERNEL);
> > > +     if (!sparx5)
> > > +             return -ENOMEM;
> > > +
> > > +     platform_set_drvdata(pdev, sparx5);
> > > +     sparx5->pdev = pdev;
> > > +     sparx5->dev = &pdev->dev;
> > > +
> > > +     /* Default values, some from DT */
> > > +     sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
> > > +
> > > +     mac_addr = of_get_mac_address(np);
> > > +     if (IS_ERR_OR_NULL(mac_addr)) {
> > > +             dev_info(sparx5->dev, "MAC addr was not set, use
> > > random MAC\n");
> > > +             eth_random_addr(sparx5->base_mac);
> > > +             sparx5->base_mac[5] = 0;
> > > +     } else {
> > > +             ether_addr_copy(sparx5->base_mac, mac_addr);
> > > +     }
> > 
> > The binding document does not say anything about a MAC address at the
> > top level. What is this used for?
> 
> This the base MAC address used for generating the the switch NI's MAC
> addresses.

Yes, that is obvious from the code. But all DT properties must be in
the binding Documentation. The DT verifier is going to complain when
it finds a mac-address property which is not described in the yaml
file.

> > > +             config.media_type = ETH_MEDIA_DAC;
> > > +             config.serdes_reset = true;
> > > +             config.portmode = config.phy_mode;
> > > +             err = sparx5_probe_port(sparx5, portnp, serdes,
> > > portno, &config);
> > > +             if (err) {
> > > +                     dev_err(sparx5->dev, "port probe error\n");
> > > +                     goto cleanup_ports;
> > > +             }
> > > +     }
> > > +     sparx5_board_init(sparx5);
> > > +
> > > +cleanup_ports:
> > > +     return err;
> > 
> > Seems missed named, no cleanup.
> 
> Ah - this comes later (as the driver was split in functional groups for
> reviewing). I hope this is OK, as it is only temporary - I could add a
> comment to that effect.

Yes, this is fine. Here, and in other places, a comment like:

/* More code to be added in later patches */

would of been nice, just as a heads up. That is the problem with
linear patch review.

> > > +static int __init sparx5_switch_reset(void)
> > > +{
> > > +     const char *syscon_cpu = "microchip,sparx5-cpu-syscon",
> > > +             *syscon_gcb = "microchip,sparx5-gcb-syscon";
> > > +     struct regmap *cpu_ctrl, *gcb_ctrl;
> > > +     u32 val;
> > > +
> > > +     cpu_ctrl = syscon_regmap_lookup_by_compatible(syscon_cpu);
> > > +     if (IS_ERR(cpu_ctrl)) {
> > > +             pr_err("No '%s' syscon map\n", syscon_cpu);
> > > +             return PTR_ERR(cpu_ctrl);
> > > +     }
> > > +
> > > +     gcb_ctrl = syscon_regmap_lookup_by_compatible(syscon_gcb);
> > > +     if (IS_ERR(gcb_ctrl)) {
> > > +             pr_err("No '%s' syscon map\n", syscon_gcb);
> > > +             return PTR_ERR(gcb_ctrl);
> > > +     }
> > > +
> > > +     /* Make sure the core is PROTECTED from reset */
> > > +     regmap_update_bits(cpu_ctrl, RESET_PROT_STAT,
> > > +                        SYS_RST_PROT_VCORE, SYS_RST_PROT_VCORE);
> > > +
> > > +     regmap_write(gcb_ctrl, spx5_offset(GCB_SOFT_RST),
> > > +                  GCB_SOFT_RST_SOFT_SWC_RST_SET(1));
> > > +
> > > +     return readx_poll_timeout(sparx5_read_gcb_soft_rst, gcb_ctrl,
> > > val,
> > > +                               GCB_SOFT_RST_SOFT_SWC_RST_GET(val)
> > > == 0,
> > > +                               1, 100);
> > > +}
> > > +postcore_initcall(sparx5_switch_reset);
> > 
> > That is pretty unusual. Why cannot this be done at probe time?
> 
> The problem is that the switch core reset also affects (reset) the
> SGPIO controller.
> 
> We tried to put this in the reset driver, but it was rejected. If the
> reset is done at probe time, the SGPIO driver may already have
> initialized state.
> 
> The switch core reset will then reset all SGPIO registers. 

Ah, O.K. Dumb question. Why is the SGPIO driver a separate driver? It
sounds like it should be embedded inside this driver if it is sharing
hardware.

Another option would be to look at the reset subsystem, and have this
driver export a reset controller, which the SGPIO driver can bind to.
Given that the GPIO driver has been merged, if this will work, it is
probably a better solution.

       Andrew

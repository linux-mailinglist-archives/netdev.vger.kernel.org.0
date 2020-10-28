Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B1429DBBF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390796AbgJ2AN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJ2AN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXkS3-003yGL-RM; Wed, 28 Oct 2020 13:21:15 +0100
Date:   Wed, 28 Oct 2020 13:21:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v5 3/3] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201028122115.GC933237@lunn.ch>
References: <cover.1603837678.git.pavana.sharma@digi.com>
 <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:09:50AM +1000, Pavana Sharma wrote:
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)

Please break this patch up a bit into preparation patches, and the
last patch actually adding support for the new family.

e.g. serdes_get_lane() returning -ENODEV should be a patch of its
own. That should hopefully answer the question which

ommit 5122d4ec9e8053a5944bf77db6bd6c89143531d7
Author: Vivien Didelot <vivien.didelot@gmail.com>
Date:   Sat Aug 31 16:18:30 2019 -0400

    net: dsa: mv88e6xxx: simplify .serdes_get_lane
    
    Because the mapping between a SERDES interface and its lane is static,
    we don't need to stick with negative error codes actually and we can
    simply return 0 if there is no lane, just like the IRQ mapping.
    
    This way we can keep a simple and intuitive API using unsigned lane
    numbers while simplifying the implementations with single return
    statements

raises.

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
> +	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
> +	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
> +	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
> +	.serdes_irq_status = mv88e6393x_serdes_irq_status,
> +	.gpio_ops = &mv88e6352_gpio_ops,
> +	.avb_ops = &mv88e6390_avb_ops,
> +	.ptp_ops = &mv88e6352_ptp_ops,
> +	.phylink_validate = mv88e6393x_phylink_validate,
> +};

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 823ae89e5fca..03c0466ab4ae 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -63,6 +63,8 @@ enum mv88e6xxx_model {
>  	MV88E6190,
>  	MV88E6190X,
>  	MV88E6191,
> +	MV88E6191X,

Is the 6191X part of the 6193 family? Not the 6390, like the 6191 is?
Or do we have the 6191 in the wrong family?

> +	MV88E6193X,

You don't add any _ops structure for the 6193x. How is it different?
Can you make your best guess at the ops structure. Also, what about
the 6191X?

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

   Andrew

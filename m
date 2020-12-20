Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28332DF722
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 00:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgLTXgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 18:36:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgLTXgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 18:36:50 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kr8Ep-00D2nd-74; Mon, 21 Dec 2020 00:35:43 +0100
Date:   Mon, 21 Dec 2020 00:35:43 +0100
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
Subject: Re: [RFC PATCH v2 4/8] net: sparx5: add port module support
Message-ID: <20201220233543.GB3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-5-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Aneg complete provides more information  */
> +	if (DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(value)) {
> +		if (port->conf.portmode == PHY_INTERFACE_MODE_SGMII) {
> +			/* SGMII cisco aneg */
> +			u32 spdvalue = ((lp_abil >> 10) & 3);

			u32 spdvalue = lp_abil & LPA_SGMII_SPD_MASK;

> +
> +			status->link = !!((lp_abil >> 15) == 1) && status->link;

Maybe

			status->link = !!((lp_abil & LPA_SGMII_LINK) && status->link;

> +			status->an_complete = true;
> +			status->duplex = (lp_abil >> 12) & 0x1 ?  DUPLEX_FULL : DUPLEX_HALF;

			status->duplex = (lp_abil & LPA_SGMII_FULL_DUPLEX) ?  DUPLEX_FULL : DUPLEX_HALF;


> +			if (spdvalue == LPA_SGMII_10)
> +				status->speed = SPEED_10;
> +			else if (spdvalue == LPA_SGMII_100)
> +				status->speed = SPEED_100;
> +			else
> +				status->speed = SPEED_1000;

I wonder if there is a helper for this?


> +		} else {
> +			/* Clause 37 Aneg */
> +			status->link = !((lp_abil >> 12) & 3) && status->link;
> +			status->an_complete = true;
> +			status->duplex = ((lp_abil >> 5) & 1) ? DUPLEX_FULL : DUPLEX_UNKNOWN;
> +			if ((lp_abil >> 8) & 1) /* symmetric pause */
> +				status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
> +			if (lp_abil & (1 << 7)) /* asymmetric pause */
> +				status->pause |= MLO_PAUSE_RX;
> +		}

Please check if there are any standard #defines you can use for
this. Russell King has done some work for clause 37. Maybe there is
some code in phy_driver.c you can use? phylink_decode_sgmii_word()

> +static int sparx5_port_verify_speed(struct sparx5 *sparx5,
> +				    struct sparx5_port *port,
> +				    struct sparx5_port_config *conf)
> +{
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (conf->speed != SPEED_1000 &&
> +		    conf->speed != SPEED_100 &&
> +		    conf->speed != SPEED_10 &&
> +		    conf->speed != SPEED_2500)
> +			return sparx5_port_error(port, conf, SPX5_PERR_SPEED);

Is it really SGMII over clocked at 2500? Or 2500BaseX?

> +static int sparx5_port_fifo_sz(struct sparx5 *sparx5,
> +			       u32 portno, u32 speed)
> +{
> +	u32 sys_clk    = sparx5_clk_period(sparx5->coreclock);
> +	u32 mac_width  = 8;
> +	u32 fifo_width = 16;
> +	u32 addition   = 0;
> +	u32 mac_per    = 6400, tmp1, tmp2, tmp3;
> +	u32 taxi_dist[SPX5_PORTS_ALL] = {

const. As it is at the moment, it gets copied onto the stack, so it
can be modified. Const i guess prevents that copy?

> +		6, 8, 10, 6, 8, 10, 6, 8, 10, 6, 8, 10,
> +		4, 4, 4, 4,
> +		11, 12, 13, 14, 15, 16, 17, 18,
> +		11, 12, 13, 14, 15, 16, 17, 18,
> +		11, 12, 13, 14, 15, 16, 17, 18,
> +		11, 12, 13, 14, 15, 16, 17, 18,
> +		4, 6, 8, 4, 6, 8, 6, 8,
> +		2, 2, 2, 2, 2, 2, 2, 4, 2
> +	};

> +static int sparx5_port_fwd_urg(struct sparx5 *sparx5, u32 speed)

What is urg? 

> +static u16 sparx5_get_aneg_word(struct sparx5_port_config *conf)
> +{
> +	if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX) /* cl-37 aneg */
> +		return ((1 << 14) | /* ack */
> +		((conf->pause ? 1 : 0) << 8) | /* asymmetric pause */
> +		((conf->pause ? 1 : 0) << 7) | /* symmetric pause */
> +		(1 << 5)); /* FDX only */

ADVERTISE_LPACK, ADVERTISE_PAUSE_ASYM, ADVERTISE_PAUSE_CAP, ADVERTISE_1000XFULL?

> +int sparx5_port_config(struct sparx5 *sparx5,
> +		       struct sparx5_port *port,
> +		       struct sparx5_port_config *conf)
> +{
> +	bool high_speed_dev = sparx5_is_high_speed_device(conf);
> +	int err, urgency, stop_wm;
> +
> +	err = sparx5_port_verify_speed(sparx5, port, conf);
> +	if (err)
> +		return err;
> +
> +	/* high speed device is already configured */
> +	if (!high_speed_dev)
> +		sparx5_port_config_low_set(sparx5, port, conf);
> +
> +	/* Configure flow control */
> +	err = sparx5_port_fc_setup(sparx5, port, conf);
> +	if (err)
> +		return err;
> +
> +	/* Set the DSM stop watermark */
> +	stop_wm = sparx5_port_fifo_sz(sparx5, port->portno, conf->speed);
> +	spx5_rmw(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_SET(stop_wm),
> +		 DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM,
> +		 sparx5,
> +		 DSM_DEV_TX_STOP_WM_CFG(port->portno));
> +
> +	/* Enable port forwarding */
> +	urgency = sparx5_port_fwd_urg(sparx5, conf->speed);
> +	spx5_rmw(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1) |
> +		 QFWD_SWITCH_PORT_MODE_FWD_URGENCY_SET(urgency),
> +		 QFWD_SWITCH_PORT_MODE_PORT_ENA |
> +		 QFWD_SWITCH_PORT_MODE_FWD_URGENCY,
> +		 sparx5,
> +		 QFWD_SWITCH_PORT_MODE(port->portno));

What does it mean by port forwarding? By default, packets should only
go to the CPU, until the port is added to a bridge. I've not thought
much about L3, since DSA so far only has L2 switches, but i guess you
don't need to enable L3 forwarding until a route out the port has been
added?

> +/* Initialize port config to default */
> +int sparx5_port_init(struct sparx5 *sparx5,
> +		     struct sparx5_port *port,
> +		     struct sparx5_port_config *conf)
> +{
> +	/* Discard pause frame 01-80-C2-00-00-01 */
> +	spx5_wr(0xC, sparx5, ANA_CL_CAPTURE_BPDU_CFG(port->portno));

The comment is about pause frames, but the macro contain BPDU?

    Andrew

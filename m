Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34DE2DF73B
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 01:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgLUA0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 19:26:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgLUA0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 19:26:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kr91Q-00D37t-Qr; Mon, 21 Dec 2020 01:25:56 +0100
Date:   Mon, 21 Dec 2020 01:25:56 +0100
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
Subject: Re: [RFC PATCH v2 5/8] net: sparx5: add switching, vlan and mactable
 support
Message-ID: <20201221002556.GC3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-6-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-6-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> +
> +static inline int sparx5_mact_get_status(struct sparx5 *sparx5)
> +{
> +	return spx5_rd(sparx5, LRN_COMMON_ACCESS_CTRL);
> +}
> +
> +static inline int sparx5_mact_wait_for_completion(struct sparx5 *sparx5)
> +{
> +	u32 val;
> +
> +	return readx_poll_timeout(sparx5_mact_get_status,
> +		sparx5, val,
> +		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_GET(val) == 0,
> +		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
> +}

No inline functions in C files please.

> +void sparx5_mact_init(struct sparx5 *sparx5)
> +{
> +	mutex_init(&sparx5->lock);
> +
> +	mutex_lock(&sparx5->lock);
> +
> +	/*  Flush MAC table */
> +	spx5_wr(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_CLEAR_ALL) |
> +		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
> +		sparx5, LRN_COMMON_ACCESS_CTRL);
> +
> +	if (sparx5_mact_wait_for_completion(sparx5) != 0)
> +		dev_warn(sparx5->dev, "MAC flush error\n");
> +
> +	mutex_unlock(&sparx5->lock);

It always seems odd to me, when you initialise a mutex, and then
immediately take it. Who are you locking against? I'm not saying it is
wrong though, especially if you have code in spx5_wr() and spx5_rd()
which check the lock is actually taken. I've found a number of locking
bugs in mv88e6xxx by having such checks.

> +
> +	sparx5_set_ageing(sparx5, 10 * MSEC_PER_SEC); /* 10 sec */

BR_DEFAULT_AGEING_TIME is 300 seconds. Is this the same thing?

> +static int sparx5_port_bridge_join(struct sparx5_port *port,
> +				   struct net_device *bridge)
> +{
> +	struct sparx5 *sparx5 = port->sparx5;
> +
> +	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
> +		/* First bridged port */
> +		sparx5->hw_bridge_dev = bridge;
> +	else
> +		if (sparx5->hw_bridge_dev != bridge)
> +			/* This is adding the port to a second bridge, this is
> +			 * unsupported
> +			 */
> +			return -ENODEV;

Just checking my understanding. You have a 64 port switch, which only
supports a single bridge?

-EOPNOTSUPP seems like a better return code.

> +
> +	set_bit(port->portno, sparx5->bridge_mask);
> +
> +	/* Port enters in bridge mode therefor don't need to copy to CPU
> +	 * frames for multicast in case the bridge is not requesting them
> +	 */
> +	__dev_mc_unsync(port->ndev, sparx5_mc_unsync);

Did you copy that from the mellanox driver? I think in DSA we take the
opposite approach. Multicast/broadcast goes to the CPU until the CPU
says it does not want it.

> +static void sparx5_port_bridge_leave(struct sparx5_port *port,
> +				     struct net_device *bridge)
> +{
> +	struct sparx5 *sparx5 = port->sparx5;
> +
> +	clear_bit(port->portno, sparx5->bridge_mask);
> +	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
> +		sparx5->hw_bridge_dev = NULL;
> +
> +	/* Clear bridge vlan settings before updating the port settings */
> +	port->vlan_aware = 0;
> +	port->pvid = NULL_VID;
> +	port->vid = NULL_VID;
> +
> +	/* Port enters in host more therefore restore mc list */

s/more/mode

> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Microchip Sparx5 Switch driver
> + *
> + * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
> + */
> +
> +#include "sparx5_main.h"
> +
> +static int sparx5_vlant_set_mask(struct sparx5 *sparx5, u16 vid)

Is the t in vlant typ0?

> +int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
> +			bool untagged)
> +{
> +	struct sparx5 *sparx5 = port->sparx5;
> +	int ret;
> +
> +	/* Make the port a member of the VLAN */
> +	set_bit(port->portno, sparx5->vlan_mask[vid]);
> +	ret = sparx5_vlant_set_mask(sparx5, vid);
> +	if (ret)
> +		return ret;
> +
> +	/* Default ingress vlan classification */
> +	if (pvid)
> +		port->pvid = vid;
> +
> +	/* Untagged egress vlan clasification */

classification

> +	if (untagged && port->vid != vid) {
> +		if (port->vid) {
> +			netdev_err(port->ndev,
> +				   "Port already has a native VLAN: %d\n",
> +				   port->vid);
> +			return -EBUSY;
> +		}
> +		port->vid = vid;
> +	}
> +
> +	sparx5_vlan_port_apply(sparx5, port);
> +
> +	return 0;
> +}


> +void sparx5_update_fwd(struct sparx5 *sparx5)
> +{
> +	u32 mask[3];
> +	DECLARE_BITMAP(workmask, SPX5_PORTS);
> +	int port;
> +
> +	/* Divide up fwd mask in 32 bit words */
> +	bitmap_to_arr32(mask, sparx5->bridge_fwd_mask, SPX5_PORTS);
> +
> +	/* Update flood masks */
> +	for (port = PGID_UC_FLOOD; port <= PGID_BCAST; port++) {
> +		spx5_wr(mask[0], sparx5, ANA_AC_PGID_CFG(port));
> +		spx5_wr(mask[1], sparx5, ANA_AC_PGID_CFG1(port));
> +		spx5_wr(mask[2], sparx5, ANA_AC_PGID_CFG2(port));
> +	}
> +
> +	/* Update SRC masks */
> +	for (port = 0; port < SPX5_PORTS; port++) {
> +		if (test_bit(port, sparx5->bridge_fwd_mask)) {
> +			/* Allow to send to all bridged but self */
> +			bitmap_copy(workmask, sparx5->bridge_fwd_mask, SPX5_PORTS);
> +			clear_bit(port, workmask);
> +			bitmap_to_arr32(mask, workmask, SPX5_PORTS);
> +			spx5_wr(mask[0], sparx5, ANA_AC_SRC_CFG(port));
> +			spx5_wr(mask[1], sparx5, ANA_AC_SRC_CFG1(port));
> +			spx5_wr(mask[2], sparx5, ANA_AC_SRC_CFG2(port));
> +		} else {
> +			spx5_wr(0, sparx5, ANA_AC_SRC_CFG(port));
> +			spx5_wr(0, sparx5, ANA_AC_SRC_CFG1(port));
> +			spx5_wr(0, sparx5, ANA_AC_SRC_CFG2(port));
> +		}

Humm, interesting. This seems to control what other ports a port can
send to. That is one of the basic features you need for supporting
multiple bridges. So i assume your problems is you cannot partition
the MAC table?

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5312B2DF15D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 20:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgLSTwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 14:52:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbgLSTwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 14:52:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kqiGL-00CtDB-9X; Sat, 19 Dec 2020 20:51:33 +0100
Date:   Sat, 19 Dec 2020 20:51:33 +0100
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
Subject: Re: [RFC PATCH v2 3/8] net: sparx5: add hostmode with phylink support
Message-ID: <20201219195133.GD3026679@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Create a phylink for PHY management.  Also handles SFPs */
> +	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
> +	spx5_port->phylink_config.type = PHYLINK_NETDEV;
> +	spx5_port->phylink_config.pcs_poll = true;
> +
> +	/* phylink needs a valid interface mode to parse dt node */
> +	if (phy_mode == PHY_INTERFACE_MODE_NA)
> +		phy_mode = PHY_INTERFACE_MODE_10GBASER;

Maybe just enforce a valid value in DT?

> +/* Configuration */
> +static inline bool sparx5_use_cu_phy(struct sparx5_port *port)
> +{
> +	return port->conf.phy_mode != PHY_INTERFACE_MODE_NA;
> +}

That is a rather odd definition of copper.

> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
> new file mode 100644
> index 000000000000..6f9282e9d3f4
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Microchip Sparx5 Switch driver
> + *
> + * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
> + */
> +
> +#include "sparx5_main.h"

I don't actually know what is preferred here, but very few drivers
i've reviewed put all the required headers into another header
file. They normally list them in each .c file.

> +static int sparx5_port_open(struct net_device *ndev)
> +{
> +	struct sparx5_port *port = netdev_priv(ndev);
> +	int err = 0;
> +
> +	err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
> +	if (err) {
> +		netdev_err(ndev, "Could not attach to PHY\n");
> +		return err;
> +	}
> +
> +	phylink_start(port->phylink);
> +
> +	if (!ndev->phydev) {

Humm. When is ndev->phydev set? I don't think phylink ever sets it.

> +		/* power up serdes */
> +		port->conf.power_down = false;
> +		err = phy_power_on(port->serdes);
> +		if (err)
> +			netdev_err(ndev, "%s failed\n", __func__);
> +	}
> +
> +	return err;
> +}

> +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
> +{
> +	struct net_device *ndev;
> +	struct sparx5_port *spx5_port;
> +
> +	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
> +	if (!ndev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	SET_NETDEV_DEV(ndev, sparx5->dev);
> +	spx5_port = netdev_priv(ndev);
> +	spx5_port->ndev = ndev;
> +	spx5_port->sparx5 = sparx5;
> +	spx5_port->portno = portno;
> +	sparx5_set_port_ifh(spx5_port->ifh, portno);
> +	snprintf(ndev->name, IFNAMSIZ, "eth%d", portno);
> +
> +	ether_setup(ndev);

devm_alloc_etherdev() should of already called ether_setup().

> +	ndev->netdev_ops = &sparx5_port_netdev_ops;
> +	ndev->features |= NETIF_F_LLTX; /* software tx */
> +
> +	ether_addr_copy(ndev->dev_addr, sparx5->base_mac);
> +	ndev->dev_addr[ETH_ALEN - 1] += portno + 1;

That will cause some surprises with wrap around. Use eth_addr_inc()

> +static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
> +{
> +	int i, byte_cnt = 0;
> +	bool eof_flag = false, pruned_flag = false, abort_flag = false;
> +	u32 ifh[IFH_LEN];
> +	struct sk_buff *skb;
> +	struct frame_info fi;
> +	struct sparx5_port *port;
> +	struct net_device *netdev;
> +	u32 *rxbuf;
> +
> +	/* Get IFH */
> +	for (i = 0; i < IFH_LEN; i++)
> +		ifh[i] = spx5_rd(sparx5, QS_XTR_RD(grp));
> +
> +	/* Decode IFH (whats needed) */
> +	sparx5_ifh_parse(ifh, &fi);
> +
> +	/* Map to port netdev */
> +	port = fi.src_port < SPX5_PORTS ?
> +		sparx5->ports[fi.src_port] : NULL;
> +	if (!port || !port->ndev) {
> +		dev_err(sparx5->dev, "Data on inactive port %d\n", fi.src_port);
> +		sparx5_xtr_flush(sparx5, grp);
> +		return;
> +	}
> +
> +	/* Have netdev, get skb */
> +	netdev = port->ndev;
> +	skb = netdev_alloc_skb(netdev, netdev->mtu + ETH_HLEN);
> +	if (!skb) {
> +		sparx5_xtr_flush(sparx5, grp);
> +		dev_err(sparx5->dev, "No skb allocated\n");
> +		return;
> +	}
> +	rxbuf = (u32 *)skb->data;
> +
> +	/* Now, pull frame data */
> +	while (!eof_flag) {
> +		u32 val = spx5_rd(sparx5, QS_XTR_RD(grp));
> +		u32 cmp = val;
> +
> +		if (byte_swap)
> +			cmp = ntohl((__force __be32)val);
> +
> +		switch (cmp) {
> +		case XTR_NOT_READY:
> +			break;
> +		case XTR_ABORT:
> +			/* No accompanying data */
> +			abort_flag = true;
> +			eof_flag = true;
> +			break;
> +		case XTR_EOF_0:
> +		case XTR_EOF_1:
> +		case XTR_EOF_2:
> +		case XTR_EOF_3:
> +			/* This assumes STATUS_WORD_POS == 1, Status
> +			 * just after last data
> +			 */
> +			byte_cnt -= (4 - XTR_VALID_BYTES(val));
> +			eof_flag = true;
> +			break;
> +		case XTR_PRUNED:
> +			/* But get the last 4 bytes as well */
> +			eof_flag = true;
> +			pruned_flag = true;
> +			fallthrough;
> +		case XTR_ESCAPE:
> +			*rxbuf = spx5_rd(sparx5, QS_XTR_RD(grp));
> +			byte_cnt += 4;
> +			rxbuf++;
> +			break;
> +		default:
> +			*rxbuf = val;
> +			byte_cnt += 4;
> +			rxbuf++;
> +		}
> +	}
> +
> +	if (abort_flag || pruned_flag || !eof_flag) {
> +		netdev_err(netdev, "Discarded frame: abort:%d pruned:%d eof:%d\n",
> +			   abort_flag, pruned_flag, eof_flag);
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	if (!netif_oper_up(netdev)) {
> +		netdev_err(netdev, "Discarded frame: Interface not up\n");
> +		kfree_skb(skb);
> +		return;
> +	}

Why is it sending frames when it is not up?

> +static int sparx5_inject(struct sparx5 *sparx5,
> +			 u32 *ifh,
> +			 struct sk_buff *skb)
> +{
> +	u32 val, w, count;
> +	int grp = INJ_QUEUE;
> +	u8 *buf;
> +
> +	val = spx5_rd(sparx5, QS_INJ_STATUS);
> +	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
> +		pr_err("Injection: Queue not ready: 0x%lx\n",
> +		       QS_INJ_STATUS_FIFO_RDY_GET(val));
> +		return -1;

Always use -ESOMETHING.

> +	}
> +
> +	if (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)) {
> +		pr_err("Injection: Watermark reached: 0x%lx\n",
> +		       QS_INJ_STATUS_WMARK_REACHED_GET(val));
> +		return -1;
> +	}
> +
> +	/* Indicate SOF */
> +	spx5_wr(QS_INJ_CTRL_SOF_SET(1) |
> +		QS_INJ_CTRL_GAP_SIZE_SET(1),
> +		sparx5, QS_INJ_CTRL(grp));
> +
> +	// Write the IFH to the chip.
> +	for (w = 0; w < IFH_LEN; w++)
> +		spx5_wr(ifh[w], sparx5, QS_INJ_WR(grp));
> +
> +	/* Write words, round up */
> +	count = ((skb->len + 3) / 4);
> +	buf = skb->data;
> +	for (w = 0; w < count; w++, buf += 4) {
> +		val = get_unaligned((const u32 *)buf);
> +		spx5_wr(val, sparx5, QS_INJ_WR(grp));
> +	}

No DMA? What sort of performance do you get? Enough for the odd BPDU,
IGMP frame etc, but i guess you don't want any real bulk data to be
sent this way?

> +irqreturn_t sparx5_xtr_handler(int irq, void *_sparx5)
> +{
> +	struct sparx5 *sparx5 = _sparx5;
> +
> +	/* Check data in queue */
> +	while (spx5_rd(sparx5, QS_XTR_DATA_PRESENT) & BIT(XTR_QUEUE))
> +		sparx5_xtr_grp(sparx5, XTR_QUEUE, false);
> +
> +	return IRQ_HANDLED;
> +}

Is there any sort of limit how many times this will loop? If somebody
is blasting 10Gbps at the CPU, will it ever get out of this loop?

   Andrew

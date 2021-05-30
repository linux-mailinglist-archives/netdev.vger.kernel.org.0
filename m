Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984743952F7
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 23:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhE3VQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 17:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhE3VQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 17:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A06C610FA;
        Sun, 30 May 2021 21:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622409303;
        bh=/4nE5Mt+cfTfeZSZdxXWBw5wZ0ulN9IfEM3mqR1qOfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNvLdq2IvSglYTbg65bgPPSsWD0UGlfuyOM0Tnf9E7hmCXl5bDbVQLXEhrwVs0YZx
         HTAmiNSsY730McgbJnuwP0AIhqgVUh4+Pbq5YTEH/oZieR/LLGAEJlCmeumma/IcmF
         TznXMoGf6n+kh3msVM3N5Ttbfi6x3oDBmyI9sb22i2CikuSr4cb/uYmvLMRrbbDm0T
         QXP9XwwLXjR2/j43QdHGWvGhfp6lfHtLqBGnc1xIrF+REv/ONKNEpxoo/9YhtRBWJC
         mVMcf5cns3H6Y4YWN0ce5N5/wDK1SPvBTJBZqgPYnhGpRHzV9MLKLMMMTHHO3ctuRG
         u9SLPJKDbqKSQ==
Date:   Sun, 30 May 2021 14:15:02 -0700
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
Subject: Re: [PATCH net-next v2 03/10] net: sparx5: add hostmode with
 phylink support
Message-ID: <20210530141502.561920a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528123419.1142290-4-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
        <20210528123419.1142290-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 14:34:12 +0200 Steen Hegelund wrote:
> This patch adds netdevs and phylink support for the ports in the switch.
> It also adds register based injection and extraction for these ports.
> 
> Frame DMA support for injection and extraction will be added in a later
> series.

> +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
> +{
> +	struct sparx5_port *spx5_port;
> +	struct net_device *ndev;
> +	u64 val;
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
> +
> +	ndev->netdev_ops = &sparx5_port_netdev_ops;
> +	ndev->features |= NETIF_F_LLTX; /* software tx */

Is your transmission method really lockless? How does
simultaneous Tx from two CPUs work?

> +	val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
> +	u64_to_ether_addr(val, ndev->dev_addr);
> +
> +	return ndev;
> +}

> +static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
> +{
> +	bool eof_flag = false, pruned_flag = false, abort_flag = false;
> +	struct net_device *netdev;
> +	struct sparx5_port *port;
> +	struct frame_info fi;
> +	int i, byte_cnt = 0;
> +	struct sk_buff *skb;
> +	u32 ifh[IFH_LEN];
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

You should probably increment appropriate counter for each error
condition.

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
> +#if defined(CONFIG_DEBUG_KERNEL) /* TODO: Remove before upstreaming */
> +	if (!netif_oper_up(netdev)) {
> +		netdev_err(netdev, "Discarded frame: Interface not up\n");
> +		kfree_skb(skb);
> +		return;
> +	}
> +#endif
> +
> +	/* Finish up skb */
> +	skb_put(skb, byte_cnt - ETH_FCS_LEN);
> +	eth_skb_pad(skb);
> +	skb->protocol = eth_type_trans(skb, netdev);
> +	netif_rx(skb);
> +	netdev->stats.rx_bytes += skb->len;
> +	netdev->stats.rx_packets++;

Does the Rx really need to happen in an interrupt context?
Did you consider using NAPI or a tasklet?

> +}
> +
> +static int sparx5_inject(struct sparx5 *sparx5,
> +			 u32 *ifh,
> +			 struct sk_buff *skb)
> +{
> +	int grp = INJ_QUEUE;
> +	u32 val, w, count;
> +	u8 *buf;
> +
> +	val = spx5_rd(sparx5, QS_INJ_STATUS);
> +	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
> +		pr_err("Injection: Queue not ready: 0x%lx\n",
> +		       QS_INJ_STATUS_FIFO_RDY_GET(val));

non-rate-limited errors on the datapath are a bad idea

> +		return -EBUSY;

What do you expect to happen at this point? Kernel can retry sending
for ever, is there a way for the driver to find out that the fifo is
no longer busy to stop/start the software queuing appropriately?

> +	}
> +
> +	if (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)) {
> +		pr_err("Injection: Watermark reached: 0x%lx\n",
> +		       QS_INJ_STATUS_WMARK_REACHED_GET(val));
> +		return -EBUSY;

ditto

> +	}
> +
> +	/* Indicate SOF */
> +	spx5_wr(QS_INJ_CTRL_SOF_SET(1) |
> +		QS_INJ_CTRL_GAP_SIZE_SET(1),
> +		sparx5, QS_INJ_CTRL(grp));
> +
> +	// Write the IFH to the chip.

Why the mix of comment styles?

> +	for (w = 0; w < IFH_LEN; w++)
> +		spx5_wr(ifh[w], sparx5, QS_INJ_WR(grp));
> +
> +	/* Write words, round up */
> +	count = ((skb->len + 3) / 4);

DIV_ROUND_UP()

> +	buf = skb->data;
> +	for (w = 0; w < count; w++, buf += 4) {
> +		val = get_unaligned((const u32 *)buf);
> +		spx5_wr(val, sparx5, QS_INJ_WR(grp));
> +	}
> +
> +	/* Add padding */
> +	while (w < (60 / 4)) {
> +		spx5_wr(0, sparx5, QS_INJ_WR(grp));
> +		w++;
> +	}
> +
> +	/* Indicate EOF and valid bytes in last word */
> +	spx5_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
> +		QS_INJ_CTRL_VLD_BYTES_SET(skb->len < 60 ? 0 : skb->len % 4) |
> +		QS_INJ_CTRL_EOF_SET(1),
> +		sparx5, QS_INJ_CTRL(grp));
> +
> +	/* Add dummy CRC */
> +	spx5_wr(0, sparx5, QS_INJ_WR(grp));
> +	w++;
> +
> +	return NETDEV_TX_OK;
> +}

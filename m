Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC13E320E
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245682AbhHFXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 19:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A21FC6115C;
        Fri,  6 Aug 2021 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628291432;
        bh=p48bgKa6K3uyQYwKcsxKZnBAREoH61c0SPh2wPer6gs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ra3Q+VbQ7qXmg8TE9XpSs7K/rNc6mLqNdNIPgmS3Y9cuHf+1dPGE8CFgGf0Gm4Zj7
         cMa/2IP9VMA4BQVYJ5iKbkqBhZdlEgpo2+ygYYeXyE8sa6z/GOB7EzQzMPjc+t36q0
         EQ9YybmqGL5+i9DRGmroRL9tHnTSMYZ6m3ar5c8Xfq8gUcGgYq9xk+1etkzUU+Izgj
         1ulrLWWPR39URllYMQnpJjPKoI1ao29z3dkgYQyyq8Pw41Vn9xDjoWj8NwYNvJjIRe
         qTjPYh92oo5RDU7Ygb0YXjelDCmuDgacEzOpLHmhhrQjIz3gp6/dycmG/qC+LwRmOl
         i7HBefFT18B4g==
Date:   Fri, 6 Aug 2021 16:10:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network
 interface
Message-ID: <20210806161030.52a7ae93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806054904.534315-3-joel@jms.id.au>
References: <20210806054904.534315-1-joel@jms.id.au>
        <20210806054904.534315-3-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Aug 2021 15:19:04 +0930 Joel Stanley wrote:
> LiteX is a soft system-on-chip that targets FPGAs. LiteETH is a basic
> network device that is commonly used in LiteX designs.
> 
> The driver was first written in 2017 and has been maintained by the
> LiteX community in various trees. Thank you to all who have contributed.

> +config NET_VENDOR_LITEX
> +	bool "LiteX devices"
> +	default y
> +	help
> +	  If you have a network (Ethernet) card belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about LiteX devices. If you say Y, you will be asked
> +	  for your specific card in the following questions.

Maybe mention where the device is usually found (FPGAs) like you did in
the commit message, to help folks make a decision here?

> +config LITEX_LITEETH
> +	tristate "LiteX Ethernet support"
> +	help
> +	  If you wish to compile a kernel for hardware with a LiteX LiteEth
> +	  device then you should answer Y to this.

> +struct liteeth {
> +	void __iomem *base;
> +	void __iomem *mdio_base;
> +	struct net_device *netdev;
> +	struct device *dev;
> +	struct mii_bus *mii_bus;

unused field

> +
> +	/* Link management */
> +	int cur_duplex;
> +	int cur_speed;
> +
> +	/* Tx */
> +	int tx_slot;
> +	int num_tx_slots;
> +	void __iomem *tx_base;
> +
> +	/* Rx */
> +	int rx_slot;
> +	int num_rx_slots;
> +	void __iomem *rx_base;
> +};
> +
> +
> +static int liteeth_rx(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	u8 rx_slot;
> +	int len;
> +
> +	rx_slot = readb(priv->base + LITEETH_WRITER_SLOT);
> +	len = readl(priv->base + LITEETH_WRITER_LENGTH);
> +
> +	skb = netdev_alloc_skb(netdev, len + NET_IP_ALIGN);

netdev_alloc_skb_ip_align() ...

> +	if (!skb) {
> +		netdev_err(netdev, "couldn't get memory");

\n at the end? You can skip it but be consistent across messages

> +		netdev->stats.rx_dropped++;
> +		return NET_RX_DROP;
> +	}
> +
> +	/* Ensure alignemnt of the ip header within the skb */
> +	skb_reserve(skb, NET_IP_ALIGN);

... then skip this

> +	if (len == 0 || len > 2048)
> +		return NET_RX_DROP;

Should this be counted somehow?

> +	data = skb_put(skb, len);
> +	memcpy_fromio(data, priv->rx_base + rx_slot * LITEETH_BUFFER_SIZE, len);
> +	skb->protocol = eth_type_trans(skb, netdev);
> +
> +	netdev->stats.rx_packets++;
> +	netdev->stats.rx_bytes += len;
> +
> +	return netif_rx(skb);
> +}
> +
> +static irqreturn_t liteeth_interrupt(int irq, void *dev_id)
> +{
> +	struct net_device *netdev = dev_id;
> +	struct liteeth *priv = netdev_priv(netdev);
> +	u8 reg;
> +
> +	reg = readb(priv->base + LITEETH_READER_EV_PENDING);
> +	if (reg) {
> +		netdev->stats.tx_packets++;
> +		writeb(reg, priv->base + LITEETH_READER_EV_PENDING);
> +	}
> +
> +	reg = readb(priv->base + LITEETH_WRITER_EV_PENDING);
> +	if (reg) {
> +		liteeth_rx(netdev);
> +		writeb(reg, priv->base + LITEETH_WRITER_EV_PENDING);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int liteeth_open(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	int err;
> +
> +	/* Clear pending events */
> +	writeb(1, priv->base + LITEETH_WRITER_EV_PENDING);
> +	writeb(1, priv->base + LITEETH_READER_EV_PENDING);
> +
> +	err = request_irq(netdev->irq, liteeth_interrupt, 0, netdev->name, netdev);
> +	if (err) {
> +		netdev_err(netdev, "failed to request irq %d\n", netdev->irq);
> +		return err;
> +	}
> +
> +	/* Enable IRQs */
> +	writeb(1, priv->base + LITEETH_WRITER_EV_ENABLE);
> +	writeb(1, priv->base + LITEETH_READER_EV_ENABLE);
> +
> +	/* TODO: Remove these once we have working mdio support */
> +	priv->cur_duplex = DUPLEX_FULL;
> +	priv->cur_speed = SPEED_100;

please remove the fields until they're actually used

> +	netif_carrier_on(netdev);
> +
> +	netif_start_queue(netdev);
> +
> +	return 0;
> +}
> +
> +static int liteeth_stop(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);

carrier_off() for symmetry?

> +	netif_stop_queue(netdev);
> +
> +	writeb(0, priv->base + LITEETH_WRITER_EV_ENABLE);
> +	writeb(0, priv->base + LITEETH_READER_EV_ENABLE);
> +
> +	free_irq(netdev->irq, netdev);
> +	return 0;
> +}
> +
> +static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	void __iomem *txbuffer;
> +	int ret;
> +	u8 val;
> +
> +	/* Reject oversize packets */
> +	if (unlikely(skb->len > MAX_PKT_SIZE)) {
> +		if (net_ratelimit())
> +			netdev_dbg(netdev, "tx packet too big\n");
> +		goto drop;
> +	}
> +
> +	txbuffer = priv->tx_base + priv->tx_slot * LITEETH_BUFFER_SIZE;
> +	memcpy_toio(txbuffer, skb->data, skb->len);
> +	writeb(priv->tx_slot, priv->base + LITEETH_READER_SLOT);
> +	writew(skb->len, priv->base + LITEETH_READER_LENGTH);
> +
> +	ret = readl_poll_timeout_atomic(priv->base + LITEETH_READER_READY, val, val, 5, 1000);

Why the need for poll if there is an interrupt?
Why not stop the Tx queue once you're out of slots and restart 
it when the completion interrupt comes?

> +	if (ret == -ETIMEDOUT) {
> +		netdev_err(netdev, "LITEETH_READER_READY timed out\n");

ratelimit this as well, please

> +		goto drop;
> +	}
> +
> +	writeb(1, priv->base + LITEETH_READER_START);
> +
> +	netdev->stats.tx_bytes += skb->len;

Please count bytes and packets in the same place

> +	priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
> +	dev_kfree_skb_any(skb);
> +	return NETDEV_TX_OK;
> +drop:
> +	/* Drop the packet */
> +	dev_kfree_skb_any(skb);
> +	netdev->stats.tx_dropped++;
> +
> +	return NETDEV_TX_OK;
> +}

> +static int liteeth_probe(struct platform_device *pdev)
> +{
> +	struct net_device *netdev;
> +	void __iomem *buf_base;
> +	struct resource *res;
> +	struct liteeth *priv;
> +	int irq, err;
> +
> +	netdev = alloc_etherdev(sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	priv = netdev_priv(netdev);
> +	priv->netdev = netdev;
> +	priv->dev = &pdev->dev;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get IRQ\n");
> +		goto err;

`err` variable is not set here, you'd return 0

> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base)) {
> +		err = PTR_ERR(priv->base);
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->mdio_base)) {
> +		err = PTR_ERR(priv->mdio_base);
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	buf_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(buf_base)) {
> +		err = PTR_ERR(buf_base);
> +		goto err;
> +	}
> +
> +	err = of_property_read_u32(pdev->dev.of_node, "rx-fifo-depth",
> +			&priv->num_rx_slots);

Please run checkpatch --strict and fix what it points out

> +	if (err) {
> +		dev_err(&pdev->dev, "unable to get rx-fifo-depth\n");
> +		goto err;
> +	}

> +	return 0;
> +err:
> +	free_netdev(netdev);
> +	return err;
> +}

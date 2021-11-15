Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B6C4518E1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 00:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344884AbhKOXJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 18:09:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344250AbhKOXHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 18:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lya67lQEfrZvJT5/YChF+rGikFvTido06jcXHSaCpiQ=; b=KBjBrSLXIsnfFAsbdKyjsk+NyO
        1A8Ak4ANiDu1ltr4gnOzEeuHqrSYc3I1VOm6zOuHP8rZx4oHAdaCukruJyIjYzAERVScJ/OHWaSON
        D90u0EosnlL+mX2Zb/jNjIvrnkPc+3+tYKAVa/ov9E5oONqWhmFloYMurpu8HOWzMp98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mml1g-00DXcJ-VX; Tue, 16 Nov 2021 00:04:36 +0100
Date:   Tue, 16 Nov 2021 00:04:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
Message-ID: <YZLnhOUg7A66AL5p@lunn.ch>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115205005.6132-4-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int tsnep_ethtool_get_regs_len(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int len;
> +	int num_queues;
> +
> +	len = TSNEP_MAC_SIZE;
> +	num_queues = max(adapter->num_tx_queues, adapter->num_rx_queues);
> +	len += TSNEP_QUEUE_SIZE * (num_queues - 1);

Why the num_queues - 1 ? A comment here might be good explaining it.

> +
> +	return len;
> +}
> +
> +static void tsnep_ethtool_get_regs(struct net_device *netdev,
> +				   struct ethtool_regs *regs,
> +				   void *p)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	regs->version = 1;
> +
> +	memcpy_fromio(p, adapter->addr, regs->len);
> +}

So the registers and the queues are contiguous?

> +static int tsnep_ethtool_get_ts_info(struct net_device *dev,
> +				     struct ethtool_ts_info *info)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(dev);
> +
> +	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
> +				SOF_TIMESTAMPING_RX_SOFTWARE |
> +				SOF_TIMESTAMPING_SOFTWARE |
> +				SOF_TIMESTAMPING_TX_HARDWARE |
> +				SOF_TIMESTAMPING_RX_HARDWARE |
> +				SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	if (adapter->ptp_clock)
> +		info->phc_index = ptp_clock_index(adapter->ptp_clock);
> +	else
> +		info->phc_index = -1;
> +
> +	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
> +			 BIT(HWTSTAMP_TX_ON);
> +	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
> +			   BIT(HWTSTAMP_FILTER_ALL);
> +
> +	return 0;
> +}

You should Cc: Richard Cochran <richardcochran@gmail.com> for the PTP
parts.

> +static int tsnep_mdio_init(struct tsnep_adapter *adapter)
> +{
> +	struct device_node *np = adapter->pdev->dev.of_node;
> +	int retval;
> +
> +	if (np) {
> +		np = of_get_child_by_name(np, "mdio");
> +		if (!np)
> +			return 0;
> +
> +		adapter->suppress_preamble =
> +			of_property_read_bool(np, "suppress-preamble");
> +	}
> +
> +	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
> +	if (!adapter->mdiobus) {
> +		retval = -ENOMEM;
> +
> +		goto out;
> +	}
> +
> +	adapter->mdiobus->priv = (void *)adapter;
> +	adapter->mdiobus->parent = &adapter->pdev->dev;
> +	adapter->mdiobus->read = tsnep_mdiobus_read;
> +	adapter->mdiobus->write = tsnep_mdiobus_write;
> +	adapter->mdiobus->name = TSNEP "-mdiobus";
> +	snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE, "%s",
> +		 adapter->pdev->name);
> +
> +	if (np) {
> +		retval = of_mdiobus_register(adapter->mdiobus, np);
> +
> +		of_node_put(np);
> +	} else {
> +		/* do not scan broadcast address */
> +		adapter->mdiobus->phy_mask = 0x0000001;
> +
> +		retval = mdiobus_register(adapter->mdiobus);

You can probably simply this. of_mdiobus_register() is happy to take a
NULL pointer for np, and will fall back to mdiobus_register().


> diff --git a/drivers/net/ethernet/engleder/tsnep_test.c b/drivers/net/ethernet/engleder/tsnep_test.c

You have quite a lot of code in this file. Could it either be

1) A loadable module which extends the base driver?
2) A build time configuration option?

What percentage of the overall driver binary does this test code take
up?

Apart from the minor comments above, ethtool, mdio, phy all looks
good.

	Andrew

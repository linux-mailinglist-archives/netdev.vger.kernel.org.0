Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B9423F7A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfETRwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:52:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfETRwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:52:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90F1514EC46B1;
        Mon, 20 May 2019 10:52:00 -0700 (PDT)
Date:   Mon, 20 May 2019 10:51:59 -0700 (PDT)
Message-Id: <20190520.105159.1094490201484427551.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     paul.burton@mips.com, ralf@linux-mips.org, jhogan@kernel.org,
        robh+dt@kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        mark.rutland@arm.com, kernel@pengutronix.de,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, nbd@nbd.name,
        netdev@vger.kernel.org, andrew@lunn.ch, gch981213@gmail.com,
        info@freifunk-bad-gandersheim.net
Subject: Re: [PATCH v5 3/3] net: ethernet: add ag71xx driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520070716.23668-4-o.rempel@pengutronix.de>
References: <20190520070716.23668-1-o.rempel@pengutronix.de>
        <20190520070716.23668-4-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 10:52:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Mon, 20 May 2019 09:07:16 +0200

> +struct ag71xx_buf {
> +	union {
> +		struct sk_buff *skb;
> +		void *rx_buf;
> +	};
> +	union {
> +		dma_addr_t dma_addr;
> +		unsigned int len;
> +	};
> +};

I find this double union very confusing.

When using unions you should make it strictly clear which members are used
together, at what times, and in which situations.

Therefore, please use something like anonymous structures to group the
members that are used together at the same time, something like:

struct ag71xx_buf {
	union {
		struct {
			struct sk_buff *skb;
			dma_addr_t dma_addr;
		} tx;
		struct {
			void *rx_buf;
			unsigned int len;
		} rx;
};

Or at the very least add a very big comment that explains the use of
the union members.

> +static int ag71xx_mdio_mii_read(struct mii_bus *bus, int addr, int reg)
> +{
> +	struct ag71xx *ag = bus->priv;
> +	struct net_device *ndev = ag->ndev;
> +	int err, val;

Reverse christmas tree here please.

> +static int ag71xx_mdio_mii_write(struct mii_bus *bus, int addr, int reg,
> +				 u16 val)
> +{
> +	struct ag71xx *ag = bus->priv;
> +	struct net_device *ndev = ag->ndev;
> +

Likewise.

> +static int ag71xx_mdio_probe(struct ag71xx *ag)
> +{
> +	static struct mii_bus *mii_bus;
> +	struct device *dev = &ag->pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct net_device *ndev = ag->ndev;
> +	int err;

Likewise.

> +static int ag71xx_tx_packets(struct ag71xx *ag, bool flush)
> +{
> +	struct ag71xx_ring *ring = &ag->tx_ring;
> +	struct net_device *ndev = ag->ndev;
> +	bool dma_stuck = false;
> +	int ring_mask = BIT(ring->order) - 1;
> +	int ring_size = BIT(ring->order);
> +	int sent = 0;
> +	int bytes_compl = 0;
> +	int n = 0;

Likewise.

And so on, and so forth, for the rest of this file.

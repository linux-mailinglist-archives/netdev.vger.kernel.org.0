Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD0527C26
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 04:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbiEPCvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 22:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiEPCvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 22:51:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB55FCE39;
        Sun, 15 May 2022 19:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aeIiodYHNThScuod1GW5LkC5SMWKdFNGndzQilLs9lY=; b=DBFHslQ4kVTac7kIIocJyO0sUs
        QUZje+acCpNESTHr4kcevQ1jDHf8qkTE/h/8IOI3ay+VcQbxXDAPZsnJosNka2BKONFX4GTJ0+Zbg
        I/aB5Vd6xe+33jY/J5cuO0jTUc0CfAZyzp7e2huZaPcR9TJgaVDmU6yDn7RTvFdywE8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nqQp5-002wrJ-HM; Mon, 16 May 2022 04:51:03 +0200
Date:   Mon, 16 May 2022 04:51:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <YoG8F8V0Z+7hz/jw@lunn.ch>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514150656.122108-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ipqess_tx_ring_alloc(struct ipqess *ess)
> +{
> +	struct device *dev = &ess->pdev->dev;
> +	int i;
> +
> +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		struct ipqess_tx_ring *tx_ring = &ess->tx_ring[i];
> +		size_t size;
> +		u32 idx;
> +
> +		tx_ring->ess = ess;
> +		tx_ring->ring_id = i;
> +		tx_ring->idx = i * 4;
> +		tx_ring->count = IPQESS_TX_RING_SIZE;
> +		tx_ring->nq = netdev_get_tx_queue(ess->netdev, i);
> +
> +		size = sizeof(struct ipqess_buf) * IPQESS_TX_RING_SIZE;
> +		tx_ring->buf = devm_kzalloc(dev, size, GFP_KERNEL);
> +		if (!tx_ring->buf) {
> +			netdev_err(ess->netdev, "buffer alloc of tx ring failed");
> +			return -ENOMEM;
> +		}

kzalloc() is pretty loud when there is no memory. So you see patches
removing such warning messages.

> +static int ipqess_rx_napi(struct napi_struct *napi, int budget)
> +{
> +	struct ipqess_rx_ring *rx_ring = container_of(napi, struct ipqess_rx_ring,
> +						    napi_rx);
> +	struct ipqess *ess = rx_ring->ess;
> +	u32 rx_mask = BIT(rx_ring->idx);
> +	int remain_budget = budget;
> +	int rx_done;
> +	u32 status;
> +
> +poll_again:
> +	ipqess_w32(ess, IPQESS_REG_RX_ISR, rx_mask);
> +	rx_done = ipqess_rx_poll(rx_ring, remain_budget);
> +
> +	if (rx_done == remain_budget)
> +		return budget;
> +
> +	status = ipqess_r32(ess, IPQESS_REG_RX_ISR);
> +	if (status & rx_mask) {
> +		remain_budget -= rx_done;
> +		goto poll_again;
> +	}

Could this be turned into a do while() loop?

> +static void ipqess_irq_enable(struct ipqess *ess)
> +{
> +	int i;
> +
> +	ipqess_w32(ess, IPQESS_REG_RX_ISR, 0xff);
> +	ipqess_w32(ess, IPQESS_REG_TX_ISR, 0xffff);
> +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		ipqess_w32(ess, IPQESS_REG_RX_INT_MASK_Q(ess->rx_ring[i].idx), 1);
> +		ipqess_w32(ess, IPQESS_REG_TX_INT_MASK_Q(ess->tx_ring[i].idx), 1);
> +	}
> +}
> +
> +static void ipqess_irq_disable(struct ipqess *ess)
> +{
> +	int i;
> +
> +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		ipqess_w32(ess, IPQESS_REG_RX_INT_MASK_Q(ess->rx_ring[i].idx), 0);
> +		ipqess_w32(ess, IPQESS_REG_TX_INT_MASK_Q(ess->tx_ring[i].idx), 0);
> +	}
> +}

Enable and disable are not symmetric?


> +static inline void ipqess_kick_tx(struct ipqess_tx_ring *tx_ring)

No inline functions please in .c files. Let the compiler decide.

   Andrew

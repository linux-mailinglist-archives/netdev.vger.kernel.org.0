Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53196315D7D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbhBJCmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:42:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhBJCkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:40:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9fPP-005EQK-UG; Wed, 10 Feb 2021 03:39:15 +0100
Date:   Wed, 10 Feb 2021 03:39:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V3 net-next 2/2] net: broadcom: bcm4908_enet: add BCM4908
 controller driver
Message-ID: <YCNHU2g1m4dFahBd@lunn.ch>
References: <20210207222632.10981-2-zajec5@gmail.com>
 <20210209230130.4690-1-zajec5@gmail.com>
 <20210209230130.4690-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209230130.4690-2-zajec5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline u32 enet_read(struct bcm4908_enet *enet, u16 offset)
> +{
> +	return readl(enet->base + offset);
> +}

No inline functions in C files please. Let the compiler decide.

> +static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
> +				       struct bcm4908_enet_dma_ring *ring)
> +{
> +	int size = ring->length * sizeof(struct bcm4908_enet_dma_ring_bd);
> +	struct device *dev = enet->dev;
> +
> +	ring->cpu_addr = dma_alloc_coherent(dev, size, &ring->dma_addr, GFP_KERNEL);
> +	if (!ring->cpu_addr)
> +		return -ENOMEM;
> +
> +	if (((uintptr_t)ring->cpu_addr) & (0x40 - 1)) {
> +		dev_err(dev, "Invalid DMA ring alignment\n");
> +		goto err_free_buf_descs;
> +	}
> +
> +	ring->slots = kzalloc(ring->length * sizeof(*ring->slots), GFP_KERNEL);
> +	if (!ring->slots)
> +		goto err_free_buf_descs;
> +
> +	memset(ring->cpu_addr, 0, size);

It looks like dma_alloc_coherent() will perform a clear. See __dma_alloc_from_coherent()

> +static void bcm4908_enet_dma_reset(struct bcm4908_enet *enet)
> +{
> +	struct bcm4908_enet_dma_ring *rings[] = { &enet->rx_ring, &enet->tx_ring };
> +	int i;
> +
> +	/* Disable the DMA controller and channel */
> +	for (i = 0; i < ARRAY_SIZE(rings); i++)
> +		enet_write(enet, rings[i]->cfg_block + ENET_DMA_CH_CFG, 0);
> +	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN, 0);

Is there a need to wait for any in flight DMA transfers to complete
before you go further? Or is that what
bcm4908_enet_dma_rx_ring_disable() is doing?

> +
> +	/* Reset channels state */
> +	for (i = 0; i < ARRAY_SIZE(rings); i++) {
> +		struct bcm4908_enet_dma_ring *ring = rings[i];
> +
> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR, 0);
> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_STATE_DATA, 0);
> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_DESC_LEN_STATUS, 0);
> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_DESC_BASE_BUFPTR, 0);
> +	}
> +}
> +
> +static void bcm4908_enet_dma_tx_ring_ensable(struct bcm4908_enet *enet,
> +					     struct bcm4908_enet_dma_ring *ring)

enable not ensable?

> +static int bcm4908_enet_open(struct net_device *netdev)
> +{
> +	struct bcm4908_enet *enet = netdev_priv(netdev);
> +	struct device *dev = enet->dev;
> +	int err;
> +
> +	err = request_irq(netdev->irq, bcm4908_enet_irq_handler, 0, "enet", enet);
> +	if (err) {
> +		dev_err(dev, "Failed to request IRQ %d: %d\n", netdev->irq, err);
> +		return err;
> +	}
> +
> +	bcm4908_enet_gmac_init(enet);
> +	bcm4908_enet_dma_reset(enet);
> +	bcm4908_enet_dma_init(enet);
> +
> +	enet_umac_set(enet, UMAC_CMD, CMD_TX_EN | CMD_RX_EN);
> +
> +	enet_set(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN);
> +	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_FLOWC_CH1_EN, 0);
> +	bcm4908_enet_dma_rx_ring_enable(enet, &enet->rx_ring);
> +
> +	napi_enable(&enet->napi);
> +	netif_carrier_on(netdev);
> +	netif_start_queue(netdev);
> +
> +	bcm4908_enet_intrs_ack(enet);
> +	bcm4908_enet_intrs_on(enet);
> +
> +	return 0;
> +}

No PHY handling? It would be normal to connect the phy in open.

   Andrew

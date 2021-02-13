Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364EE31AD32
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBMQoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:44:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhBMQoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 11:44:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAy11-0064bW-U0; Sat, 13 Feb 2021 17:43:27 +0100
Date:   Sat, 13 Feb 2021 17:43:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: axienet: Support dynamic switching
 between 1000BaseX and SGMII
Message-ID: <YCgBrycpH+TNqhBy@lunn.ch>
References: <20210213002356.2557207-1-robert.hancock@calian.com>
 <20210213002356.2557207-4-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213002356.2557207-4-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 06:23:56PM -0600, Robert Hancock wrote:
> Newer versions of the Xilinx AXI Ethernet core (specifically version 7.2 or
> later) allow the core to be configured with a PHY interface mode of "Both",

Hi Robert

Is it possible to read the version of the core from a register? Is it
possible to synthesizer a version 7.2 or > without this feature? I'm
just wondering if the DT property is actually needed?

>  /**
>   * struct axidma_bd - Axi Dma buffer descriptor layout
>   * @next:         MM2S/S2MM Next Descriptor Pointer
> @@ -377,22 +381,29 @@ struct axidma_bd {
>   * @ndev:	Pointer for net_device to which it will be attached.
>   * @dev:	Pointer to device structure
>   * @phy_node:	Pointer to device node structure
> + * @phylink:	Pointer to phylink instance
> + * @phylink_config: phylink configuration settings
> + * @pcs_phy:	Reference to PCS/PMA PHY if used
> + * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
> + * @clk:	Clock for AXI bus
>   * @mii_bus:	Pointer to MII bus structure
>   * @mii_clk_div: MII bus clock divider value
>   * @regs_start: Resource start for axienet device addresses
>   * @regs:	Base address for the axienet_local device address space
>   * @dma_regs:	Base address for the axidma device address space
> - * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
> + * @dma_err_task: Work structure to process Axi DMA errors
>   * @tx_irq:	Axidma TX IRQ number
>   * @rx_irq:	Axidma RX IRQ number
> + * @eth_irq:	Ethernet core IRQ number
>   * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
>   * @options:	AxiEthernet option word
> - * @last_link:	Phy link state in which the PHY was negotiated earlier
>   * @features:	Stores the extended features supported by the axienet hw
>   * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
>   * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
> + * @tx_bd_num:	Size of TX buffer descriptor ring
>   * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
>   * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
> + * @rx_bd_num:	Size of RX buffer descriptor ring
>   * @tx_bd_ci:	Stores the index of the Tx buffer descriptor in the ring being
>   *		accessed currently. Used while alloc. BDs before a TX starts
>   * @tx_bd_tail:	Stores the index of the Tx buffer descriptor in the ring being
> @@ -414,23 +425,20 @@ struct axienet_local {
>  	struct net_device *ndev;
>  	struct device *dev;
>  
> -	/* Connection to PHY device */
>  	struct device_node *phy_node;
>  
>  	struct phylink *phylink;
>  	struct phylink_config phylink_config;
>  
> -	/* Reference to PCS/PMA PHY if used */
>  	struct mdio_device *pcs_phy;

This really should of been two patches. One moving the comments
around, and a second one adding the new fields.

> +static int axienet_mac_prepare(struct phylink_config *config, unsigned int mode,
> +			       phy_interface_t iface)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct axienet_local *lp = netdev_priv(ndev);
> +	int ret;
> +
> +	switch (iface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		if (!lp->switch_x_sgmii)
> +			return 0;

Maybe -EOPNOTSUPP would be better?

      Andrew

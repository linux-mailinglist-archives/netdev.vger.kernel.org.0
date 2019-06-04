Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B533D24
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFDCZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:25:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfFDCZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B8sJMdizSppqxnt60cZNytA1GVjBA6tYDai0Z+5LNrY=; b=Y9ksAlKa0K4aZC4IZIPXk6bl2Q
        v2nDBVrPvP9WDP86WakttXc4c4h8D3klvbKkTPVO04ngufAm6ahb4GRtaPF4b4BXvC257z+wf8HXm
        jdWMlFMCXP/2n/9OvbGlB07PV4XHnwPdwqxVDDVj6bT4PNCtdNZfwBwu5OgDObkflCiw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXz97-0001V5-Ao; Tue, 04 Jun 2019 04:25:53 +0200
Date:   Tue, 4 Jun 2019 04:25:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 03/18] net: axienet: fix MDIO bus naming
Message-ID: <20190604022553.GI17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-4-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-4-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:02PM -0600, Robert Hancock wrote:
> The MDIO bus for this driver was being named using the result of
> of_address_to_resource on a node which may not have any resource on it,
> but the return value of that call was not checked so it was using some
> random value in the bus name. Change to name the MDIO bus based on the
> resource start of the actual Ethernet register block.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 ++
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  1 +
>  drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 11 +++++------
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index d82e3b6..f9078bd 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -380,6 +380,7 @@ struct axidma_bd {
>   * @dev:	Pointer to device structure
>   * @phy_node:	Pointer to device node structure
>   * @mii_bus:	Pointer to MII bus structure
> + * @regs_start: Resource start for axienet device addresses
>   * @regs:	Base address for the axienet_local device address space
>   * @dma_regs:	Base address for the axidma device address space
>   * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
> @@ -421,6 +422,7 @@ struct axienet_local {
>  	struct mii_bus *mii_bus;	/* MII bus reference */
>  
>  	/* IO registers, dma functions and IRQs */
> +	resource_size_t regs_start;
>  	void __iomem *regs;
>  	void __iomem *dma_regs;
>  
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 55beca1..ffbd4d7 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1480,6 +1480,7 @@ static int axienet_probe(struct platform_device *pdev)
>  	lp->options = XAE_OPTION_DEFAULTS;
>  	/* Map device registers */
>  	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	lp->regs_start = ethres->start;
>  	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
>  	if (IS_ERR(lp->regs)) {
>  		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> index 704babd..665ae1d 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> @@ -127,7 +127,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
>  	int ret;
>  	u32 clk_div, host_clock;
>  	struct mii_bus *bus;
> -	struct resource res;
> +	struct device_node *mdio_node;
>  	struct device_node *np1;
>  
>  	/* clk_div can be calculated by deriving it from the equation:
> @@ -199,10 +199,9 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
>  	if (!bus)
>  		return -ENOMEM;
>  
> -	np1 = of_get_parent(lp->phy_node);
> -	of_address_to_resource(np1, 0, &res);
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
> -		 (unsigned long long) res.start);
> + mdio_node = of_get_parent(lp->phy_node);
w> +	snprintf(bus->id, MII_BUS_ID_SIZE, "axienet-%.8llx",
> +		 (unsigned long long)lp->regs_start);
>  
>  	bus->priv = lp;
>  	bus->name = "Xilinx Axi Ethernet MDIO";
> @@ -211,7 +210,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
>  	bus->parent = lp->dev;
>  	lp->mii_bus = bus;
>  
> -	ret = of_mdiobus_register(bus, np1);
> +	ret = of_mdiobus_register(bus, mdio_node);
>  	if (ret) {
>  		mdiobus_free(bus);
>  		lp->mii_bus = NULL;

Hi Robert

The change to the name looks fine.

But the way you moved around the code for the mdio device node made me
look at this and notice it is broken.

Take for example:

        axi_ethernet_eth0: ethernet@40c00000 {
                compatible = "xlnx,axi-ethernet-1.00.a";
                device_type = "network";
                interrupt-parent = <&microblaze_0_axi_intc>;
                interrupts = <2 0>;
                phy-mode = "mii";
                reg = <0x40c00000 0x40000>;
                xlnx,rxcsum = <0x2>;
                xlnx,rxmem = <0x800>;
                xlnx,txcsum = <0x2>;
                phy-handle = <&phy0>;
                axi_ethernetlite_0_mdio: mdio {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        phy0: phy@1 {
                                device_type = "ethernet-phy";
                                reg = <1>;
                        };
                        phy1: phy@2 {
                                device_type = "ethernet-phy";
                                reg = <2>;
                        };
                };
        };

        axi_ethernet_eth1: ethernet@40d00000 {
                compatible = "xlnx,axi-ethernet-1.00.a";
                device_type = "network";
                interrupt-parent = <&microblaze_0_axi_intc>;
                interrupts = <2 0>;
                phy-mode = "mii";
                reg = <0x40d00000 0x40000>;
                xlnx,rxcsum = <0x2>;
                xlnx,rxmem = <0x800>;
                xlnx,txcsum = <0x2>;
                phy-handle = <&phy1>;
                axi_ethernetlite_0_mdio: mdio {
                        #address-cells = <1>;
                        #size-cells = <0>;
                };
        };

When the second device probes, it will follow phy-handle to phy1.
mdio_node = of_get_parent(lp->phy_node); then gives us the MDIO node
in ethernet@40c00000, not ethernet@40d00000. It will re-register the
same MDIO bus, and bad things are likely to happen.

The code needs to do something like:

mdio_node = of_get_child_by_name(lp->dev.of_node, "mdio");

No idea if this actually works, if there are DT blobs out there which
will break, because they don't use the name "mdio", since it is not
actually specified in the binding document.

	  Andrew

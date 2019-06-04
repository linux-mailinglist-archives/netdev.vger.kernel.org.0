Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E783529A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFDWMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:12:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfFDWMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 18:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PlddWxHwjdv7iMKUEcF8tcQ6coDlMvog+ON4gYk5CmI=; b=yvXFqNeZxshvw5369xeM8Ybvqg
        mq/i24mDLHe3bp/4QxBIvx/FAeNV08JQt6pHYIvEv0F2fpMyZXJEesgpAhm/95pJWMiS/B32EndhU
        e3AQg50xIIyB+IyIzPLTyIrpq0141wMANUvr9JfrhK+NxA2wteOOMiNXTbTS0EIrnIp8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYHfn-0000XW-EI; Wed, 05 Jun 2019 00:12:51 +0200
Date:   Wed, 5 Jun 2019 00:12:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v3 05/19] net: axienet: Use clock framework to
 get device clock rate
Message-ID: <20190604221251.GA19627@lunn.ch>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
 <1559684626-24775-6-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559684626-24775-6-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 03:43:32PM -0600, Robert Hancock wrote:
> This driver was previously always calculating the MDIO clock divisor
> (from AXI bus clock to MDIO bus clock) based on the CPU clock frequency,
> assuming that it is the same as the AXI bus frequency, but that
> simplistic method only works on the MicroBlaze platform.
> 
> Add support for specifying the clock used for the device in the device
> tree using the clock framework. If the clock is specified then it will
> be used when calculating the clock divisor. The previous CPU clock
> detection method is left for backward compatibility if no clock is
> specified.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  .../devicetree/bindings/net/xilinx_axienet.txt     |  6 +++
>  drivers/net/ethernet/xilinx/xilinx_axienet.h       |  5 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 23 ++++++++-
>  drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 54 +++++++++++++---------
>  4 files changed, 62 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 38f9ec0..2dea903 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -31,6 +31,11 @@ Optional properties:
>  		  1 to enable partial TX checksum offload,
>  		  2 to enable full TX checksum offload
>  - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
> +- clocks	: AXI bus clock for the device. Refer to common clock bindings.
> +		  Used to calculate MDIO clock divisor. If not specified, it is
> +		  auto-detected from the CPU clock (but only on platforms where
> +		  this is possible). New device trees should specify this - the
> +		  auto detection is only for backward compatibility.
>  
>  Example:
>  	axi_ethernet_eth: ethernet@40c00000 {
> @@ -38,6 +43,7 @@ Example:
>  		device_type = "network";
>  		interrupt-parent = <&microblaze_0_axi_intc>;
>  		interrupts = <2 0>;
> +		clocks = <&axi_clk>;
>  		phy-mode = "mii";
>  		reg = <0x40c00000 0x40000>;
>  		xlnx,rxcsum = <0x2>;
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index f9078bd..f240ff1 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -418,6 +418,9 @@ struct axienet_local {
>  	/* Connection to PHY device */
>  	struct device_node *phy_node;
>  
> +	/* Clock for AXI bus */
> +	struct clk *clk;
> +
>  	/* MDIO bus data */
>  	struct mii_bus *mii_bus;	/* MII bus reference */
>  
> @@ -502,7 +505,7 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
>  }
>  
>  /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
> -int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np);
> +int axienet_mdio_setup(struct axienet_local *lp);
>  int axienet_mdio_wait_until_ready(struct axienet_local *lp);
>  void axienet_mdio_teardown(struct axienet_local *lp);
>  
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index ffbd4d7..42b343c 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -21,6 +21,7 @@
>   *  - Add support for extended VLAN support.
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/etherdevice.h>
>  #include <linux/module.h>
> @@ -1611,9 +1612,24 @@ static int axienet_probe(struct platform_device *pdev)
>  
>  	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
>  	if (lp->phy_node) {
> -		ret = axienet_mdio_setup(lp, pdev->dev.of_node);
> +		lp->clk = devm_clk_get(&pdev->dev, NULL);
> +		if (IS_ERR(lp->clk)) {
> +			dev_warn(&pdev->dev, "Failed to get clock: %ld\n",
> +				 PTR_ERR(lp->clk));
> +			lp->clk = NULL;
> +		} else {
> +			ret = clk_prepare_enable(lp->clk);
> +			if (ret) {
> +				dev_err(&pdev->dev, "Unable to enable clock: %d\n",
> +					ret);
> +				goto free_netdev;
> +			}
> +		}
> +
> +		ret = axienet_mdio_setup(lp);
>  		if (ret)
> -			dev_warn(&pdev->dev, "error registering MDIO bus\n");
> +			dev_warn(&pdev->dev,
> +				 "error registering MDIO bus: %d\n", ret);
>  	}
>  
>  	ret = register_netdev(lp->ndev);
> @@ -1638,6 +1654,9 @@ static int axienet_remove(struct platform_device *pdev)
>  	axienet_mdio_teardown(lp);
>  	unregister_netdev(ndev);
>  
> +	if (lp->clk)
> +		clk_disable_unprepare(lp->clk);
> +
>  	of_node_put(lp->phy_node);
>  	lp->phy_node = NULL;
>  
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> index 665ae1d..88469c7 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> @@ -8,6 +8,7 @@
>   * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/of_address.h>
>  #include <linux/of_mdio.h>
>  #include <linux/jiffies.h>
> @@ -114,7 +115,6 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
>  /**
>   * axienet_mdio_setup - MDIO setup function
>   * @lp:		Pointer to axienet local data structure.
> - * @np:		Pointer to device node
>   *
>   * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
>   *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
> @@ -122,13 +122,41 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
>   * Sets up the MDIO interface by initializing the MDIO clock and enabling the
>   * MDIO interface in hardware. Register the MDIO interface.
>   **/
> -int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
> +int axienet_mdio_setup(struct axienet_local *lp)
>  {
>  	int ret;
>  	u32 clk_div, host_clock;
>  	struct mii_bus *bus;
>  	struct device_node *mdio_node;
> -	struct device_node *np1;
> +
> +	if (lp->clk) {
> +		host_clock = clk_get_rate(lp->clk);
> +	} else {
> +		struct device_node *np1;
> +
> +		/* Legacy fallback: detect CPU clock frequency and use as AXI
> +		 * bus clock frequency. This only works on certain platforms.
> +		 */
> +		np1 = of_find_node_by_name(NULL, "cpu");
> +		if (!np1) {
> +			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
> +			netdev_warn(lp->ndev,
> +				    "Setting MDIO clock divisor to default %d\n",
> +				    DEFAULT_CLOCK_DIVISOR);
> +			clk_div = DEFAULT_CLOCK_DIVISOR;
> +			goto issue;
> +		}
> +		if (of_property_read_u32(np1, "clock-frequency", &host_clock)) {
> +			netdev_warn(lp->ndev, "clock-frequency property not found.\n");
> +			netdev_warn(lp->ndev,
> +				    "Setting MDIO clock divisor to default %d\n",
> +				    DEFAULT_CLOCK_DIVISOR);
> +			clk_div = DEFAULT_CLOCK_DIVISOR;
> +			of_node_put(np1);
> +			goto issue;
> +		}
> +		of_node_put(np1);
> +	}

Although this looks O.K, the goto is not nice. It looks like a good
candidate for refactoring into a number of smaller functions.

	  Andrew

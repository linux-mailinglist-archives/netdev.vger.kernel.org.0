Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA811219001
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGHSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:55:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGHSzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 14:55:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtFDm-004Dur-RT; Wed, 08 Jul 2020 20:55:06 +0200
Date:   Wed, 8 Jul 2020 20:55:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 2/5] net/fsl: store mdiobus fwnode
Message-ID: <20200708185506.GI928075@lunn.ch>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
 <20200708173435.16256-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708173435.16256-3-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 11:04:32PM +0530, Calvin Johnson wrote:
> Store fwnode for mdiobus in the bus structure so that it can
> later be retrieved and used whenever mdiobus fwnode information
> is required.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index 98be51d8b08c..8189c86d5a44 100644
> --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> @@ -269,6 +269,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  	bus->write = xgmac_mdio_write;
>  	bus->parent = &pdev->dev;
>  	bus->probe_capabilities = MDIOBUS_C22_C45;
> +	if (pdev->dev.fwnode)
> +		bus->dev.fwnode = pdev->dev.fwnode;

This is pretty fundamental to making this work. In the device tree
world, this is setup by of_mdiobus_register(). Maybe we need an
fwnode_mdiobus_register(), just to ensure the next device wanting to
do ACPI does not forget this?

   Andrew

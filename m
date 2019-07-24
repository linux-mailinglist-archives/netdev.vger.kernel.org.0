Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF4C73292
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfGXPSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:18:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387503AbfGXPSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 11:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HhOq85evkFM/y15ZM/uScRYpMDK7uIWdehOeEOZxwf4=; b=aD9gCEO/FuimjgYQZxJxnzZ4v1
        SEPBl3v97IkgN4q2SfajCnLPZCPyb9eAUvSJCSsM/ceXh7w22MSJIGZYynurXwVFVmUsi6Qkb6gy4
        numZoJbK/AWNh/CnvIzhqder6Q5qnPPyuV1qWrQqWUAjRrDjAC982P5hwYPoiIoAFa8U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqJ1n-000061-9c; Wed, 24 Jul 2019 17:18:03 +0200
Date:   Wed, 24 Jul 2019 17:18:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/4] enetc: Clean up local mdio bus allocation
Message-ID: <20190724151803.GR25635@lunn.ch>
References: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
 <1563979301-596-2-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563979301-596-2-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 05:41:38PM +0300, Claudiu Manoil wrote:
> Though it works, this is not how it should have been.
> What's needed is a pointer to the mdio registers.
> Store it properly inside bus->priv allocated space.
> Use devm_* variant to further clean up the init error /
> remove paths.
> 
> Fixes following sparse warning:
>  warning: incorrect type in assignment (different address spaces)
>     expected void *priv
>     got struct enetc_mdio_regs [noderef] <asn:2>*[assigned] regs
> 
> Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
> v1 - added this patch
> 
>  .../net/ethernet/freescale/enetc/enetc_mdio.c | 31 +++++++------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
> index 77b9cd10ba2b..1e3cd21c13ee 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
> @@ -15,7 +15,8 @@ struct enetc_mdio_regs {
>  	u32	mdio_addr;	/* MDIO address */
>  };
>  
> -#define bus_to_enetc_regs(bus)	(struct enetc_mdio_regs __iomem *)((bus)->priv)
> +#define bus_to_enetc_regs(bus)	(*(struct enetc_mdio_regs __iomem **) \
> +				((bus)->priv))
>  
>  #define ENETC_MDIO_REG_OFFSET	0x1c00
>  #define ENETC_MDC_DIV		258
> @@ -146,12 +147,12 @@ static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>  int enetc_mdio_probe(struct enetc_pf *pf)
>  {
>  	struct device *dev = &pf->si->pdev->dev;
> -	struct enetc_mdio_regs __iomem *regs;
> +	struct enetc_mdio_regs __iomem **regsp;
>  	struct device_node *np;
>  	struct mii_bus *bus;
> -	int ret;
> +	int err;
>  
> -	bus = mdiobus_alloc_size(sizeof(regs));
> +	bus = devm_mdiobus_alloc_size(dev, sizeof(*regsp));
>  	if (!bus)
>  		return -ENOMEM;
>  
> @@ -159,41 +160,33 @@ int enetc_mdio_probe(struct enetc_pf *pf)
>  	bus->read = enetc_mdio_read;
>  	bus->write = enetc_mdio_write;
>  	bus->parent = dev;
> +	regsp = bus->priv;
>  	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
>  
>  	/* store the enetc mdio base address for this bus */
> -	regs = pf->si->hw.port + ENETC_MDIO_REG_OFFSET;
> -	bus->priv = regs;
> +	*regsp = pf->si->hw.port + ENETC_MDIO_REG_OFFSET;

This is all very odd and different to every other driver.

If i get the code write, there are 4 registers, each u32 in size,
starting at pf->si->hw.port + ENETC_MDIO_REG_OFFSET?

There are macros like enetc_port_wr() and enetc_global_wr(). It think
it would be much cleaner to add a macro enet_mdio_wr() which takes
hw, off, val.

#define enet_mdio_wr(hw, off, val) enet_port_wr(hw, off + ENETC_MDIO_REG_OFFSET, val)

struct enetc_mdio_priv {
       struct enetc_hw *hw;
}

	struct enetc_mdio_priv *mdio_priv;

	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));

	mdio_priv = bus->priv;
	mdio_priv->hw = pf->si->hw;


static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
                            u16 value)
{
	struct enetc_mdio_priv *mdio_priv = bus->priv;
...
	enet_mdio_wr(priv->hw, ENETC_MDIO_CFG, mdio_cfg);
}
			    	
All the horrible casts go away, the driver is structured like every
other driver, sparse is probably happy, etc.

      Andrew

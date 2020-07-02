Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846802124D0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgGBNft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:35:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgGBNft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:35:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqzNR-003KMu-4A; Thu, 02 Jul 2020 15:35:45 +0200
Date:   Thu, 2 Jul 2020 15:35:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Subject: Re: [net-next,PATCH 3/4] net: mdio-ipq4019: add Clause 45 support
Message-ID: <20200702133545.GJ730739@lunn.ch>
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-4-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702103001.233961-4-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:30:00PM +0200, Robert Marko wrote:
> While up-streaming the IPQ4019 driver it was thought that the controller had no Clause 45 support,
> but it actually does and its activated by writing a bit to the mode register.
> 
> So lets add it as newer SoC-s use the same controller and Clause 45 compliant PHY-s.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  drivers/net/phy/mdio-ipq4019.c | 109 ++++++++++++++++++++++++++++-----
>  1 file changed, 92 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
> index 7660bf006da0..9143113d5a6b 100644
> --- a/drivers/net/phy/mdio-ipq4019.c
> +++ b/drivers/net/phy/mdio-ipq4019.c
> @@ -13,6 +13,7 @@
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  
> +#define MDIO_MODE_REG				0x40
>  #define MDIO_ADDR_REG				0x44
>  #define MDIO_DATA_WRITE_REG			0x48
>  #define MDIO_DATA_READ_REG			0x4c
> @@ -21,6 +22,12 @@
>  #define MDIO_CMD_ACCESS_START		BIT(8)
>  #define MDIO_CMD_ACCESS_CODE_READ	0
>  #define MDIO_CMD_ACCESS_CODE_WRITE	1
> +#define MDIO_CMD_ACCESS_CODE_C45_ADDR	0
> +#define MDIO_CMD_ACCESS_CODE_C45_WRITE	1
> +#define MDIO_CMD_ACCESS_CODE_C45_READ	2
> +
> +/* 0 = Clause 22, 1 = Clause 45 */
> +#define MDIO_MODE_BIT				BIT(8)
>  
>  #define IPQ4019_MDIO_TIMEOUT	10000
>  #define IPQ4019_MDIO_SLEEP		10
> @@ -39,7 +46,7 @@ static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
>  	unsigned int busy;
>  
>  	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
> -				  (busy & MDIO_CMD_ACCESS_BUSY) == 0, 
> +				  (busy & MDIO_CMD_ACCESS_BUSY) == 0,
>  				  IPQ4019_MDIO_SLEEP, IPQ4019_MDIO_TIMEOUT);
>  }

Please put white space changes into a separate patch.


>  
> @@ -47,18 +54,43 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  {
>  	struct ipq4019_mdio_data *priv = bus->priv;
>  	unsigned int cmd;
> -
> -	/* Reject clause 45 */
> -	if (regnum & MII_ADDR_C45)
> -		return -EOPNOTSUPP;
> +	unsigned int data;

Reverse Christmas tree please.

>  
>  	if (ipq4019_mdio_wait_busy(bus))
>  		return -ETIMEDOUT;
>  
> -	/* issue the phy address and reg */
> -	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +	/* Clause 45 support */
> +	if (regnum & MII_ADDR_C45) {
> +		unsigned int mmd = (regnum >> 16) & 0x1F;
> +		unsigned int reg = regnum & 0xFFFF;
> +
> +		/* Enter Clause 45 mode */
> +		data = readl(priv->membase + MDIO_MODE_REG);
> +
> +		data |= MDIO_MODE_BIT;
> +
> +		writel(data, priv->membase + MDIO_MODE_REG);
> +
> +		/* issue the phy address and mmd */
> +		writel((mii_id << 8) | mmd, priv->membase + MDIO_ADDR_REG);
> +
> +		/* issue reg */
> +		writel(reg, priv->membase + MDIO_DATA_WRITE_REG);
> +
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_ADDR;
> +	} else {
> +		/* Enter Clause 22 mode */
> +		data = readl(priv->membase + MDIO_MODE_REG);
>  
> -	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
> +		data &= ~MDIO_MODE_BIT;
> +
> +		writel(data, priv->membase + MDIO_MODE_REG);
> +
> +		/* issue the phy address and reg */
> +		writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
> +	}
>  
>  	/* issue read command */
>  	writel(cmd, priv->membase + MDIO_CMD_REG);
> @@ -67,6 +99,15 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  	if (ipq4019_mdio_wait_busy(bus))
>  		return -ETIMEDOUT;
>  
> +	if (regnum & MII_ADDR_C45) {
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_READ;
> +
> +		writel(cmd, priv->membase + MDIO_CMD_REG);
> +
> +		if (ipq4019_mdio_wait_busy(bus))
> +			return -ETIMEDOUT;
> +	}
> +
>  	/* Read and return data */
>  	return readl(priv->membase + MDIO_DATA_READ_REG);
>  }
> @@ -76,22 +117,56 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>  {
>  	struct ipq4019_mdio_data *priv = bus->priv;
>  	unsigned int cmd;
> -
> -	/* Reject clause 45 */
> -	if (regnum & MII_ADDR_C45)
> -		return -EOPNOTSUPP;
> +	unsigned int data;
>  
>  	if (ipq4019_mdio_wait_busy(bus))
>  		return -ETIMEDOUT;
>  
> -	/* issue the phy address and reg */
> -	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +	/* Clause 45 support */
> +	if (regnum & MII_ADDR_C45) {
> +		unsigned int mmd = (regnum >> 16) & 0x1F;
> +		unsigned int reg = regnum & 0xFFFF;
> +
> +		/* Enter Clause 45 mode */
> +		data = readl(priv->membase + MDIO_MODE_REG);
> +
> +		data |= MDIO_MODE_BIT;
> +
> +		writel(data, priv->membase + MDIO_MODE_REG);
> +
> +		/* issue the phy address and mmd */
> +		writel((mii_id << 8) | mmd, priv->membase + MDIO_ADDR_REG);
> +
> +		/* issue reg */
> +		writel(reg, priv->membase + MDIO_DATA_WRITE_REG);
> +
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_ADDR;
> +
> +		writel(cmd, priv->membase + MDIO_CMD_REG);
> +
> +		if (ipq4019_mdio_wait_busy(bus))
> +			return -ETIMEDOUT;
> +	} else {
> +		/* Enter Clause 22 mode */
> +		data = readl(priv->membase + MDIO_MODE_REG);
> +
> +		data &= ~MDIO_MODE_BIT;
> +
> +		writel(data, priv->membase + MDIO_MODE_REG);
> +
> +		/* issue the phy address and reg */
> +		writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +	}
>  
>  	/* issue write data */
>  	writel(value, priv->membase + MDIO_DATA_WRITE_REG);
> -
> -	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
> +
>  	/* issue write command */
> +	if (regnum & MII_ADDR_C45)
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_C45_WRITE;
> +	else
> +		cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
> +
>  	writel(cmd, priv->membase + MDIO_CMD_REG);
>  
>  	/* Wait write complete */
> @@ -105,7 +180,7 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>  {
>  	struct ipq4019_mdio_data *priv;
>  	struct mii_bus *bus;
> -	struct device_node *np = pdev->dev.of_node; 
> +	struct device_node *np = pdev->dev.of_node;
>  	int ret;

Another white space change.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571E81FE108
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733163AbgFRBvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:51:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45682 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732198AbgFRBvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:51:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljiV-0013N7-K9; Thu, 18 Jun 2020 03:51:47 +0200
Date:   Thu, 18 Jun 2020 03:51:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v7 2/6] net: phy: Add a helper to return the
 index for of the internal delay
Message-ID: <20200618015147.GH249144@lunn.ch>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617182019.6790-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:20:15PM -0500, Dan Murphy wrote:
> Add a helper function that will return the index in the array for the
> passed in internal delay value.  The helper requires the array, size and
> delay value.
> 
> The helper will then return the index for the exact match or return the
> index for the index to the closest smaller value.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/phy_device.c | 68 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          |  4 +++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 04946de74fa0..611d4e68e3c6 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -31,6 +31,7 @@
>  #include <linux/mdio.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> +#include <linux/property.h>
>  
>  MODULE_DESCRIPTION("PHY library");
>  MODULE_AUTHOR("Andy Fleming");
> @@ -2657,6 +2658,73 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
>  }
>  EXPORT_SYMBOL(phy_get_pause);
>  
> +/**
> + * phy_get_delay_index - returns the index of the internal delay
> + * @phydev: phy_device struct
> + * @dev: pointer to the devices device struct
> + * @delay_values: array of delays the PHY supports
> + * @size: the size of the delay array
> + * @is_rx: boolean to indicate to get the rx internal delay
> + *
> + * Returns the index within the array of internal delay passed in.
> + * Or if size == 0 then the delay read from the firmware is returned.
> + * The array must be in ascending order.
> + * Return errno if the delay is invalid or cannot be found.
> + */
> +s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
> +			   const int *delay_values, int size, bool is_rx)
> +{
> +	int ret;
> +	int i;
> +	s32 delay;
> +
> +	if (is_rx)
> +		ret = device_property_read_u32(dev, "rx-internal-delay-ps",
> +					       &delay);
> +	else
> +		ret = device_property_read_u32(dev, "tx-internal-delay-ps",
> +					       &delay);
> +	if (ret) {
> +		phydev_err(phydev, "internal delay not defined\n");

This is an optional property. So printing an error message seems heavy
handed.

Maybe it would be better to default to 0 if the property is not found,
and continue with the lookup in the table to find what value should be
written for a 0ps delay?

	Andrew

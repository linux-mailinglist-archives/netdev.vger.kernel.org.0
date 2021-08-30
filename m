Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC33FB700
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhH3Nds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:33:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235904AbhH3Ndr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 09:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WWoMPuly9JjasrmMAELtnD9xCnZoOqZNrh1kbiw2GMg=; b=gadLj+IYXsId0pedWIi13rMucB
        2YVu28H9RTBKahrWOu8MH5UQbEUIliM9nuiZA+Q0ZiW4bOBf1PUjIbrYWAelg1PDvPCaVLyElYq/r
        6vnzg2+HIbtzNl4E2tXtebnx116lCdje+NhcO88khrrPvwgy8yJ7Vs9WR+TLk/GtbsUo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mKhP2-004Z5J-Ik; Mon, 30 Aug 2021 15:32:44 +0200
Date:   Mon, 30 Aug 2021 15:32:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v1 1/3] net: phy: improve the wol feature of at803x
Message-ID: <YSzd/BCy7JHoWKZV@lunn.ch>
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830110733.8964-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 07:07:31PM +0800, Luo Jie wrote:
> wol is controlled by bit 5 of reg 3.8012, which should be
> configured by set_wol of phy_driver.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/at803x.c | 50 +++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 5d62b85a4024..ecae26f11aa4 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -70,10 +70,14 @@
>  #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
>  #define AT803X_LED_CONTROL			0x18
>  
> -#define AT803X_DEVICE_ADDR			0x03
> +/* WOL control */
> +#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
> +#define AT803X_WOL_EN				BIT(5)
> +
>  #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
>  #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
>  #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
> +
>  #define AT803X_REG_CHIP_CONFIG			0x1f
>  #define AT803X_BT_BX_REG_SEL			0x8000
>  
> @@ -328,12 +332,6 @@ static int at803x_set_wol(struct phy_device *phydev,
>  	struct net_device *ndev = phydev->attached_dev;
>  	const u8 *mac;
>  	int ret;
> -	u32 value;
> -	unsigned int i, offsets[] = {
> -		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
> -		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
> -		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
> -	};
>  
>  	if (!ndev)
>  		return -ENODEV;
> @@ -344,23 +342,30 @@ static int at803x_set_wol(struct phy_device *phydev,
>  		if (!is_valid_ether_addr(mac))
>  			return -EINVAL;
>  
> -		for (i = 0; i < 3; i++)
> -			phy_write_mmd(phydev, AT803X_DEVICE_ADDR, offsets[i],
> -				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_32_47_OFFSET,
> +				mac[1] | (mac[0] << 8));
> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_16_31_OFFSET,
> +				mac[3] | (mac[2] << 8));
> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_0_15_OFFSET,
> +				mac[5] | (mac[4] << 8));

Please try to keep your changes minimal. It looks like all you really
need is to replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS. Everything
else is O.K. Maybe make offset a const?

Making the change more complex than it needs to be makes it harder to
review.

>  
> -		value = phy_read(phydev, AT803X_INTR_ENABLE);
> -		value |= AT803X_INTR_ENABLE_WOL;
> -		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);

So that it be replaced with a phy_modify().


> +		/* clear the pending interrupt */
> +		phy_read(phydev, AT803X_INTR_STATUS);

But where did this come from? 

> +
> +		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
>  		if (ret)
>  			return ret;
> -		value = phy_read(phydev, AT803X_INTR_STATUS);
> +
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> +				0, AT803X_WOL_EN);
> +
>  	} else {
> -		value = phy_read(phydev, AT803X_INTR_ENABLE);
> -		value &= (~AT803X_INTR_ENABLE_WOL);
> -		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
> +		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);

This makes sense

>  		if (ret)
>  			return ret;
> -		value = phy_read(phydev, AT803X_INTR_STATUS);
> +
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> +				AT803X_WOL_EN, 0);

But where did this come from?

I could be wrong, but i get the feeling you just replaced the code
with what you have in your new driver, rather than step by step
improve this code.

Please break this patch up into a number of patches:

AT803X_DEVICE_ADDR with MDIO_MMD_PCS
read/write to modify.

Other patches for the remaining changes, if actually required, with a
good explanation of why they are needed.

    Andrew

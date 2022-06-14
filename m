Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05D354BCB1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbiFNVVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiFNVVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:21:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC824ECCB;
        Tue, 14 Jun 2022 14:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pp5a5lxR6zzh2GCJwG1wPnehpOB5z2vyG9Yk+Kny7KA=; b=Bvncu1AqVSD0fJrBqIsEAxMnNR
        d+lkU6/8PicuXQBD8lQNDnAEkDvJTwckRKfUEM4fCh+tSk4dz9xSzXzQtm2wHb+llciXLD8UbGCjX
        4bLx4AbDPrasUwxlm7P5srbQI/CTW9SBjLNjNVws2Y5txYUnrRAokKTChBVWkx2T1IPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1DyJ-006vmP-Tu; Tue, 14 Jun 2022 23:21:11 +0200
Date:   Tue, 14 Jun 2022 23:21:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        lxu@maxlinear.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 5/5] net: phy: add support to get Master-Slave
 configuration
Message-ID: <Yqj7x3b8nfG4GvIS@lunn.ch>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-6-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614103424.58971-6-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 04:04:24PM +0530, Raju Lakkaraju wrote:
> Implement reporting the Master-Slave configuration and state
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/phy/mxl-gpy.c | 55 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> index 5ce1bf03bbd7..cf625ced4ec1 100644
> --- a/drivers/net/phy/mxl-gpy.c
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -27,11 +27,19 @@
>  #define PHY_ID_GPY241BM		0x67C9DE80
>  #define PHY_ID_GPY245B		0x67C9DEC0
>  
> +#define PHY_STD_GCTRL		0x09	/* Gbit ctrl */
> +#define PHY_STD_GSTAT		0x0A	/* Gbit status */

#define MII_CTRL1000		0x09	/* 1000BASE-T control          */
#define MII_STAT1000		0x0a	/* 1000BASE-T status           */

from mii.h

>  #define PHY_MIISTAT		0x18	/* MII state */
>  #define PHY_IMASK		0x19	/* interrupt mask */
>  #define PHY_ISTAT		0x1A	/* interrupt status */
>  #define PHY_FWV			0x1E	/* firmware version */
>  
> +#define PHY_STD_GCTRL_MS	BIT(11)
> +#define PHY_STD_GCTRL_MSEN	BIT(12)
> +
> +#define PHY_STD_GSTAT_MSRES	BIT(14)
> +#define PHY_STD_GSTAT_MSFAULT	BIT(15)

If the device is just following the standard, there should not be any
need to add defines, they should already exist. And if it does follow
the standard there are probably helpers you can use.

>  #define PHY_MIISTAT_SPD_MASK	GENMASK(2, 0)
>  #define PHY_MIISTAT_DPX		BIT(3)
>  #define PHY_MIISTAT_LS		BIT(10)
> @@ -160,6 +168,48 @@ static bool gpy_2500basex_chk(struct phy_device *phydev)
>  	return true;
>  }
>  
> +static int gpy_master_slave_cfg_get(struct phy_device *phydev)
> +{
> +	int state;
> +	int cfg;
> +	int ret;
> +
> +	ret = phy_read(phydev, PHY_STD_GCTRL);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return ret;
> +	}
> +
> +	if (ret & PHY_STD_GCTRL_MSEN)
> +		if (ret & PHY_STD_GCTRL_MS)
> +			cfg = MASTER_SLAVE_CFG_MASTER_FORCE;
> +		else
> +			cfg = MASTER_SLAVE_CFG_SLAVE_FORCE;
> +	else
> +		cfg = MASTER_SLAVE_CFG_MASTER_PREFERRED;
> +
> +	ret = phy_read(phydev, PHY_STD_GSTAT);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return ret;
> +	}
> +
> +	if (ret & PHY_STD_GSTAT_MSFAULT)
> +		state = MASTER_SLAVE_STATE_ERR;
> +	else
> +		if (ret & PHY_STD_GSTAT_MSRES)
> +			state = MASTER_SLAVE_STATE_MASTER;
> +		else
> +			state = MASTER_SLAVE_STATE_SLAVE;
> +
> +	phydev->master_slave_get = cfg;
> +	phydev->master_slave_state = state;
> +
> +	return 0;

Would genphy_read_master_slave() work?

      Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E632F48E3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbhAMKm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbhAMKmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:42:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9536F23122;
        Wed, 13 Jan 2021 10:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610534504;
        bh=Bt8PKEKYxRlKr8ZxpQ4Sv72jnsBlJbiUbCoxxoe8GbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JNaUm/AcvlY8TD1Y3ZJ6I/VDIYdZdd88ClLxcBJ5OGTU8WYSnf0x17Q2zCv0US0Kd
         Grr2yOthczkQJE2FFEA6TB5ZRY8kTRmEYy0ySLwJ2GrGiVyA7NT9Szm+y7AsR0fKeL
         P6VEA6CU7iR2nVloPYJXlybPMmFZVUVip5MnLmquvsZUAIyN+GcFBHBLLfCgEYeUjW
         fvC9DKt4N4cgHzIHqHQegt+vBCEr8o7eEx5lzQDWujb2ilvd//zkJ7Q7m+TuQCPsZK
         6YVoqdtm/7JjWkvc9FPsoUVXRFqEhJbNY58T/DrcvYg6APl2acuuy1AyyHwzUBMuaI
         DKMFNQKdQoAYw==
Received: by pali.im (Postfix)
        id 4FEE376D; Wed, 13 Jan 2021 11:41:42 +0100 (CET)
Date:   Wed, 13 Jan 2021 11:41:42 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 3/4] net: sfp: create/destroy I2C mdiobus
 before PHY probe/after PHY release
Message-ID: <20210113104142.pr3dnrcwmyxb54yj@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111050044.22002-4-kabel@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 11 January 2021 06:00:43 Marek Behún wrote:
> Instead of configuring the I2C mdiobus when SFP driver is probed,
> create/destroy the mdiobus before the PHY is probed for/after it is
> released.
> 
> This way we can tell the mdio-i2c code which protocol to use for each
> SFP transceiver.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
>  drivers/net/phy/sfp.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 958fd514a3b4..0621d12cf878 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -217,6 +217,7 @@ struct sfp {
>  	struct i2c_adapter *i2c;
>  	struct mii_bus *i2c_mii;
>  	struct sfp_bus *sfp_bus;
> +	enum mdio_i2c_proto mdio_protocol;
>  	struct phy_device *mod_phy;
>  	const struct sff_data *type;
>  	size_t i2c_block_size;
> @@ -409,9 +410,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  
>  static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  {
> -	struct mii_bus *i2c_mii;
> -	int ret;
> -
>  	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
>  		return -EINVAL;
>  
> @@ -419,7 +417,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  	sfp->read = sfp_i2c_read;
>  	sfp->write = sfp_i2c_write;
>  
> -	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
> +	return 0;
> +}
> +
> +static int sfp_i2c_mdiobus_create(struct sfp *sfp)
> +{
> +	struct mii_bus *i2c_mii;
> +	int ret;
> +
> +	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c, sfp->mdio_protocol);
>  	if (IS_ERR(i2c_mii))
>  		return PTR_ERR(i2c_mii);
>  
> @@ -437,6 +443,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  	return 0;
>  }
>  
> +static void sfp_i2c_mdiobus_destroy(struct sfp *sfp)
> +{
> +	mdiobus_unregister(sfp->i2c_mii);
> +	sfp->i2c_mii = NULL;
> +}
> +
>  /* Interface */
>  static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
>  {
> @@ -1821,6 +1833,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  	else
>  		sfp->module_t_start_up = T_START_UP;
>  
> +	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
> +
>  	return 0;
>  }
>  
> @@ -1991,6 +2005,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
>  			sfp_module_stop(sfp->sfp_bus);
>  		if (sfp->mod_phy)
>  			sfp_sm_phy_detach(sfp);
> +		if (sfp->i2c_mii)
> +			sfp_i2c_mdiobus_destroy(sfp);
>  		sfp_module_tx_disable(sfp);
>  		sfp_soft_stop_poll(sfp);
>  		sfp_sm_next(sfp, SFP_S_DOWN, 0);
> @@ -2053,6 +2069,12 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
>  				     sfp->sm_fault_retries == N_FAULT_INIT);
>  		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
>  	init_done:
> +			/* Create mdiobus and start trying for PHY */
> +			ret = sfp_i2c_mdiobus_create(sfp);
> +			if (ret < 0) {
> +				sfp_sm_next(sfp, SFP_S_FAIL, 0);
> +				break;
> +			}
>  			sfp->sm_phy_retries = R_PHY_RETRY;
>  			goto phy_probe;
>  		}
> -- 
> 2.26.2
> 

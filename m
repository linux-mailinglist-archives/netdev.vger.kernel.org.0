Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9202F4901
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbhAMKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbhAMKuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF55523122;
        Wed, 13 Jan 2021 10:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610534979;
        bh=1tzpOfp+JNdcBufHwTuMHSTuybtxIBu+6Y5joGS61yU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GfZSlpnx3xE3nzhmkDxjxsHL9a6r+ru19Jp9P45QhC1Iw1feTcGUmikoZ1mm2PrPD
         7QCPcnYGnCb9hA1oK13Da+RSRz0bRQuPdYi+DXK1ursYfcw2LBv/F7r9svmZOpgezG
         BZlDb2DyD8I6MieDYoiubUxOIPd8XspqNB8kAmfVBPD5k6mU5/l7M3T8lt2SuiKymH
         opLj0g0gcw+j/ENm0P/q5PS3ksEKI8UPN27MtmurZG2n+J6E/DMZOl4GbapSuruh4H
         x0lf2Lx8HwTRagoPms0ZuVOyfnUBo8dhrYvRsOkr6lbSqem3ylq6CgwdSXm0QTD0nI
         tVirtmnBDD1Zg==
Received: by pali.im (Postfix)
        id 7FB1176D; Wed, 13 Jan 2021 11:49:36 +0100 (CET)
Date:   Wed, 13 Jan 2021 11:49:36 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 4/4] net: sfp: add support for multigig
 RollBall transceivers
Message-ID: <20210113104936.ka74oaa6xo2mvwbo@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111050044.22002-5-kabel@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello! (See comment below)

On Monday 11 January 2021 06:00:44 Marek Behún wrote:
> This adds support for multigig copper SFP modules from RollBall/Hilink.
> These modules have a specific way to access clause 45 registers of the
> internal PHY.
> 
> We also need to wait at least 22 seconds after deasserting TX disable
> before accessing the PHY. The code waits for 25 seconds just to be sure.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 0621d12cf878..21fb96899518 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -165,6 +165,7 @@ static const enum gpiod_flags gpio_flags[] = {
>   * on board (for a copper SFP) time to initialise.
>   */
>  #define T_WAIT			msecs_to_jiffies(50)
> +#define T_WAIT_ROLLBALL		msecs_to_jiffies(25000)
>  #define T_START_UP		msecs_to_jiffies(300)
>  #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
>  
> @@ -204,8 +205,11 @@ static const enum gpiod_flags gpio_flags[] = {
>  
>  /* SFP modules appear to always have their PHY configured for bus address
>   * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
> + * RollBall SFPs access phy via SFP Enhanced Digital Diagnostic Interface
> + * via address 0x51 (mdio-i2c will use RollBall protocol on this address).
>   */
> -#define SFP_PHY_ADDR	22
> +#define SFP_PHY_ADDR		22
> +#define SFP_PHY_ADDR_ROLLBALL	17
>  
>  struct sff_data {
>  	unsigned int gpios;
> @@ -218,6 +222,7 @@ struct sfp {
>  	struct mii_bus *i2c_mii;
>  	struct sfp_bus *sfp_bus;
>  	enum mdio_i2c_proto mdio_protocol;
> +	int phy_addr;
>  	struct phy_device *mod_phy;
>  	const struct sff_data *type;
>  	size_t i2c_block_size;
> @@ -250,6 +255,7 @@ struct sfp {
>  	struct sfp_eeprom_id id;
>  	unsigned int module_power_mW;
>  	unsigned int module_t_start_up;
> +	unsigned int module_t_wait;
>  
>  #if IS_ENABLED(CONFIG_HWMON)
>  	struct sfp_diag diag;
> @@ -1453,7 +1459,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
>  	struct phy_device *phy;
>  	int err;
>  
> -	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
> +	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
>  	if (phy == ERR_PTR(-ENODEV))
>  		return PTR_ERR(phy);
>  	if (IS_ERR(phy)) {
> @@ -1835,6 +1841,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  
>  	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
>  
> +	sfp->phy_addr = SFP_PHY_ADDR;
> +	sfp->module_t_wait = T_WAIT;
> +
> +	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> +	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> +	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> +	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
> +		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
> +		sfp->phy_addr = SFP_PHY_ADDR_ROLLBALL;
> +		sfp->module_t_wait = T_WAIT_ROLLBALL;
> +
> +		/* RollBall SFPs may have wrong (zero) extended compliacne code
> +		 * burned in EEPROM. For PHY probing we need the correct one.
> +		 */
> +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;

Should not we rather in sfp_sm_probe_for_phy() function in "default"
section try to probe also for clause 45 PHY when clause 22 fails?

> +	}
> +
>  	return 0;
>  }
>  
> @@ -2030,9 +2053,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
>  
>  		/* We need to check the TX_FAULT state, which is not defined
>  		 * while TX_DISABLE is asserted. The earliest we want to do
> -		 * anything (such as probe for a PHY) is 50ms.
> +		 * anything (such as probe for a PHY) is 50ms. (or more on
> +		 * specific modules).
>  		 */
> -		sfp_sm_next(sfp, SFP_S_WAIT, T_WAIT);
> +		sfp_sm_next(sfp, SFP_S_WAIT, sfp->module_t_wait);
>  		break;
>  
>  	case SFP_S_WAIT:
> @@ -2046,8 +2070,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
>  			 * deasserting.
>  			 */
>  			timeout = sfp->module_t_start_up;
> -			if (timeout > T_WAIT)
> -				timeout -= T_WAIT;
> +			if (timeout > sfp->module_t_wait)
> +				timeout -= sfp->module_t_wait;
>  			else
>  				timeout = 1;
>  
> -- 
> 2.26.2
> 

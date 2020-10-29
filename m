Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC829ECED
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJ2NbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2NbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:31:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0BDC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 06:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pAyxkPanKWkqeA6ehUV6RyEK6d4UJCelf0rcQ9aXmcg=; b=LDx40GGtGv1M01xEp1MjTDkZZ
        uAe/bAOhKKf/DB4A1+6+++3AtlJ/2S4aPu8/2I7zQSD7+zs7e8kjlWDnn+N72X9RRAh8o0iYvlE12
        ihvuvFWECkJ34QRx6oCSjA2tjwzLQyt3vhxUWY0vQN1R6sh3mRjsO/T4I4igXeqA3sQaqsZ4jrmyE
        tVFh6ltRX3Ucold5MUGSRBOrtKKrMEqygRzeH5SVR/Dml17D5WXoyVIRct0Ti2LzKev86PF9b4/hn
        6ZlwDVPxfHSFQh8zKJgah4HeIh18QoX7NAu2MJ+vNV/2OYtCSTHMEVwghdwZjCDJkmCmJOyjJ8IzO
        kSgu210Qw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52464)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY7rS-0004OW-Og; Thu, 29 Oct 2020 13:21:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY7rQ-00068l-Jy; Thu, 29 Oct 2020 13:21:00 +0000
Date:   Thu, 29 Oct 2020 13:21:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/5] net: sfp: configure/destroy I2C mdiobus on
 transceiver plug/unplug
Message-ID: <20201029132100.GS1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028221427.22968-4-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:14:25PM +0100, Marek Behún wrote:
> Instead of configuring the I2C mdiobus when SFP driver is probed,
> configure/destroy the mdiobus when SFP transceiver is plugged/unplugged.
> 
> This way we can tell the mdio-i2c code which protocol to use for each
> SFP transceiver.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/sfp.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index b1f9fc3a5584..a392d5fc6ab4 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -399,9 +399,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  
>  static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  {
> -	struct mii_bus *i2c_mii;
> -	int ret;
> -
>  	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
>  		return -EINVAL;
>  
> @@ -409,7 +406,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  	sfp->read = sfp_i2c_read;
>  	sfp->write = sfp_i2c_write;
>  
> -	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
> +	return 0;
> +}
> +
> +static int sfp_i2c_mdiobus_configure(struct sfp *sfp, enum mdio_i2c_type type)
> +{
> +	struct mii_bus *i2c_mii;
> +	int ret;
> +
> +	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c, type);
>  	if (IS_ERR(i2c_mii))
>  		return PTR_ERR(i2c_mii);
>  
> @@ -427,6 +432,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
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
> @@ -1768,6 +1779,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  	else
>  		sfp->module_t_start_up = T_START_UP;
>  
> +	/* Configure mdiobus */
> +	ret = sfp_i2c_mdiobus_configure(sfp, MDIO_I2C_DEFAULT);
> +	if (ret < 0)
> +		return ret;
> +

	return sfp_i2c_mdiobus_configure(sfp, MDIO_I2C_DEFAULT);

would be a simpler way to write this. However, I suggest handling this
elsewhere due to the point below.

> @@ -1778,6 +1794,8 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
>  
>  	sfp_hwmon_remove(sfp);
>  
> +	sfp_i2c_mdiobus_destroy(sfp);
> +

This doesn't seem like the right place to handle this. This is called
from the module state machine (sfp_sm_module()) which is run before the
main state machine (sfp_sm_main()). The PHY is unregistered in the main
state machine, which means you're destroying the MII bus before the
PHY.

I guess what saves us from crashing is the refcounting, but this
doesn't seem to me to be particularly good.

Maybe create the MII bus after the "init_done" label, and destroy it
after we've called sfp_sm_phy_detach() ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

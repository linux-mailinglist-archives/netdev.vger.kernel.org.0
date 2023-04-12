Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B426DF79C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjDLNrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjDLNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:47:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B57B5;
        Wed, 12 Apr 2023 06:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sFu6ISS6cMLbHP+M5q3dS3OCGt4FOXBrIYqQsmy7Xa4=; b=Mr0mNDLW1J+f1nYCep4q9MjiMB
        PaH6octghF0ItxlmYruKPU6u7GyH53VTDMW22Ci8eeGxyuNs9DvDyIHVzkByww1jY2CmyVhk0C8e+
        Yc5aTgo0hSy3B9xpknGA3rYpjW/Fhl7Z1HZlQsgDX69vNjI0+W1qJIgTzGQP0nmts7w9g8UN9sJKC
        PAxPVhsD0YA3HflQYFWGgVQLHb/jKgS8y25LHsSzqkaOnjy2ULE+wPuq4OLgG3L40sRBdQYS9uZQM
        ATve//nD/Af2NA9IwcTKmw208lnfzN8WKBACkPx6cNeWmy4iQ3cYD710TNV6/cVfLy2NRqxdTEnHE
        sVKzZqIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48398)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmap0-0008Bi-7l; Wed, 12 Apr 2023 14:47:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmaoy-0005B6-5G; Wed, 12 Apr 2023 14:47:36 +0100
Date:   Wed, 12 Apr 2023 14:47:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Message-ID: <ZDa2eFJhBlQRNBCL@shell.armlinux.org.uk>
References: <20230406131127.383006-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406131127.383006-1-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:11:27PM +0200, Lukasz Majewski wrote:
> The LAN8720Ai has special bit (12) in the PHY SPECIAL
> CONTROL/STATUS REGISTER (dec 31) to indicate if the
> AutoNeg is finished.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> ---
>  drivers/net/phy/smsc.c  | 8 ++++++++
>  include/linux/smscphy.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index ac7481ce2fc1..58e5f06ef453 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -83,6 +83,13 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
>  	return rc < 0 ? rc : 0;
>  }
>  
> +static int smsc_phy_aneg_done(struct phy_device *phydev)
> +{
> +	int rc = phy_read(phydev, MII_LAN83C185_PHY_CTRL_STS);
> +
> +	return rc & MII_LAN87XX_AUTODONE;
> +}
> +
>  static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
>  {
>  	struct smsc_phy_priv *priv = phydev->priv;
> @@ -416,6 +423,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.config_init	= smsc_phy_config_init,
>  	.soft_reset	= smsc_phy_reset,
>  	.config_aneg	= lan95xx_config_aneg_ext,
> +	.aneg_done      = smsc_phy_aneg_done,
>  
>  	/* IRQ related */
>  	.config_intr	= smsc_phy_config_intr,
> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
> index 1a136271ba6a..0debebe999d6 100644
> --- a/include/linux/smscphy.h
> +++ b/include/linux/smscphy.h
> @@ -4,6 +4,7 @@
>  
>  #define MII_LAN83C185_ISF 29 /* Interrupt Source Flags */
>  #define MII_LAN83C185_IM  30 /* Interrupt Mask */
> +#define MII_LAN83C185_PHY_CTRL_STS  31 /* PHY Special Control/Status Register */

Looks like this is a new register.

>  #define MII_LAN83C185_CTRL_STATUS 17 /* Mode/Status Register */
>  #define MII_LAN83C185_SPECIAL_MODES 18 /* Special Modes Register */
>  
> @@ -22,6 +23,7 @@
>  	 MII_LAN83C185_ISF_INT7)
>  
>  #define MII_LAN83C185_EDPWRDOWN (1 << 13) /* EDPWRDOWN */
> +#define MII_LAN87XX_AUTODONE    (1 << 12) /* AUTODONE */

Is this somehow related to the two definitions either side of it? How
do we know which register this definition corresponds to? In fact,
how do we know which registers any of these bits correspond with?
Bunging new definitions for new registers amongst other definitions
for other registers isn't particularly helpful when someone who
doesn't know the driver has to look at the code.

>  #define MII_LAN83C185_ENERGYON  (1 << 1)  /* ENERGYON */
>  
>  #define MII_LAN83C185_MODE_MASK      0xE0
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

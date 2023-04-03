Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DF6D42FC
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjDCLIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCLIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:08:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F24F3;
        Mon,  3 Apr 2023 04:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2I5G0aWxNwP2AuZEd7HJV9PNt405h29TCjS3lS11GQE=; b=tGCSsnfXfckTnukgZgod3OCwsa
        YnU3b/KQbrvK9i7Qq+Rkjbx4nZ9yBsb3Wbd61buN2wxXFaB9p6jOswox6Dy8BDEv5BIj/DtXeCY+U
        ljUoSTnuv16a9XP3Qk320OF4TgzfAANoGfajSHx7TpgLrj8qoPypAPU/nwism8gL+8mYDVKjGfQj6
        fqxf/5Rso9kWci8OIB2ctsYzaCNI7yMjRtHY2MgaxuP1/Py2mzJ9pLRXs/hWzd1J6WsFqYuT3O1M6
        oBfiaHkJJ3M6GfSsEdoZom3z/zWXdu2yqRw1Qu1VDr2ioCLwRTraXPivM+9uP3H8UfYPneTdr9Yz+
        hKGCWXvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39376)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjI3I-0002eu-Ld; Mon, 03 Apr 2023 12:08:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjI3H-0004AB-3C; Mon, 03 Apr 2023 12:08:43 +0100
Date:   Mon, 3 Apr 2023 12:08:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: ti: am65-cpsw: Move mode
 specific config to mac_config()
Message-ID: <ZCqzuwDLGuBDMHQG@shell.armlinux.org.uk>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
 <20230403110106.983994-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403110106.983994-2-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 04:31:04PM +0530, Siddharth Vadapalli wrote:
> Move the interface mode specific configuration to the mac_config()
> callback am65_cpsw_nuss_mac_config().
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index d17757ecbf42..74e099828978 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -1504,12 +1504,17 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>  							  phylink_config);
>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>  	struct am65_cpsw_common *common = port->common;
> +	u32 mac_control = 0;
>  
>  	if (common->pdata.extra_modes & BIT(state->interface)) {
> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +			mac_control |= CPSW_SL_CTL_EXT_EN;
>  			writel(ADVERTISE_SGMII,
>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> +		}
>  
> +		if (mac_control)
> +			cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
>  	}
> @@ -1553,8 +1558,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>  
>  	if (speed == SPEED_1000)
>  		mac_control |= CPSW_SL_CTL_GIG;
> -	if (interface == PHY_INTERFACE_MODE_SGMII)
> -		mac_control |= CPSW_SL_CTL_EXT_EN;
> +	/* TODO: Verify whether in-band is necessary for 10 Mbps RGMII */
>  	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
>  		/* Can be used with in band mode only */
>  		mac_control |= CPSW_SL_CTL_EXT_EN;

I'm afraid I can see you haven't thought this patch through properly.

am65_cpsw_nuss_mac_link_down() will call
cpsw_sl_ctl_reset(port->slave.mac_sl); which has the effect of clearing
to zero the entire MAC control register. This will clear
CPSW_SL_CTL_EXT_EN that was set in am65_cpsw_nuss_mac_config() which is
not what you want to be doing.

Given that we have the 10Mbps issue with RGMII, I think what you want
to be doing is:

1. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_config() if in SGMII
   mode, otherwise clear this bit.

2. Clear the mac_control register in am65_cpsw_nuss_mac_link_down()
   if in RMGII mode, otherwise preserve the state of
   CPSW_SL_CTL_EXT_EN but clear all other bits.

3. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_link_up() if in
   RGMII mode and 10Mbps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

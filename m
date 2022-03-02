Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801874C9BF7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiCBDTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiCBDTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:19:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52026B0A51;
        Tue,  1 Mar 2022 19:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rXMw4wUAlXFShkAofA0UbhafXS37c9IoNvi1pzseNYY=; b=2gVtDlIZSkhgIl24UAAe/1Xc+8
        nbaSQ/y4IaSRN9riitZyu74kEbH70mpKB0s+BR1oos5YcpFnjxVPNs/mdn8lZ6YNNFwe+mx9Rt6ht
        jU9GvAt8PzPrz1qnT8WfKZHkzqg7tzwljMhcwGudBwAiqMNPFSTwnMwh2ZSGEnphqCFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPFW2-008rUw-Ch; Wed, 02 Mar 2022 04:19:02 +0100
Date:   Wed, 2 Mar 2022 04:19:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 1/4] net: phy: used the genphy_soft_reset
 for phy reset in Lan87xx
Message-ID: <Yh7iJpT0H1+3RncS@lunn.ch>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
 <20220228140510.20883-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228140510.20883-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 07:35:07PM +0530, Arun Ramadoss wrote:
> Replaced current code for soft resetting phy to genphy_soft_reset
> function. And added the macro for LAN87xx Phy ID.

Hi Arun

Please don't mix multiple things in one patch.

Looking at the actual path, you have:

> +#define LAN87XX_PHY_ID			0x0007c150
> +#define MICROCHIP_PHY_ID_MASK		0xfffffff0

Part of macros for PHY ID.

> +
>  /* External Register Control Register */
>  #define LAN87XX_EXT_REG_CTL                     (0x14)
>  #define LAN87XX_EXT_REG_CTL_RD_CTL              (0x1000)
> @@ -197,20 +200,10 @@ static int lan87xx_phy_init(struct phy_device *phydev)
>  	if (rc < 0)
>  		return rc;
>  
> -	/* Soft Reset the SMI block */
> -	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
> -					0x00, 0x8000, 0x8000);
> -	if (rc < 0)
> -		return rc;
> -
> -	/* Check to see if the self-clearing bit is cleared */
> -	usleep_range(1000, 2000);
> -	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
> -			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
> +	/* phy Soft reset */
> +	rc = genphy_soft_reset(phydev);
>  	if (rc < 0)
>  		return rc;
> -	if ((rc & 0x8000) != 0)
> -		return -ETIMEDOUT;

Soft reset.

>  
>  	/* PHY Initialization */
>  	for (i = 0; i < ARRAY_SIZE(init); i++) {
> @@ -273,6 +266,9 @@ static int lan87xx_config_init(struct phy_device *phydev)
>  {
>  	int rc = lan87xx_phy_init(phydev);
>  
> +	if (rc < 0)
> +		phydev_err(phydev, "failed to initialize phy\n");
> +

A new error message.

>  	return rc < 0 ? rc : 0;
>  }
>  
> @@ -506,18 +502,14 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
>  
>  static struct phy_driver microchip_t1_phy_driver[] = {
>  	{
> -		.phy_id         = 0x0007c150,
> -		.phy_id_mask    = 0xfffffff0,
> -		.name           = "Microchip LAN87xx T1",
> +		.phy_id         = LAN87XX_PHY_ID,
> +		.phy_id_mask    = MICROCHIP_PHY_ID_MASK,

2nd part of the PHY ID macros.

> +		.name           = "LAN87xx T1",

A change in name.

>  		.flags          = PHY_POLL_CABLE_TEST,
> -
>  		.features       = PHY_BASIC_T1_FEATURES,
> -
>  		.config_init	= lan87xx_config_init,
> -
>  		.config_intr    = lan87xx_phy_config_intr,
>  		.handle_interrupt = lan87xx_handle_interrupt,
> -

White space changes.

You can also use PHY_ID_MATCH_MODEL().

    Andrew

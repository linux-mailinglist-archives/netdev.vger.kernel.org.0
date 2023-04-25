Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F46EE1BE
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjDYMSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjDYMSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:18:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AE7CC2A;
        Tue, 25 Apr 2023 05:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y2xmHxWJoOMFBDK3e9R7jezO1ZQRrGxNjaD0N0iIErE=; b=oxjuRHPbfCSqcokVTCnIAh65u1
        qP9/AJMGD2F8Qa1N8bIj/YTTVTX1CzwAzuoDCrWQiz/rd16R4yIwEXTnB0B6MrR6dovo3dYvy3fqa
        rhg3bmfBKgV3iuHUfGWQ6AYihNv6HXMA/PqmG4Z/quIMNRfxYi/fS2sEtTVs/knbE0HA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prHcW-00BBRl-Jl; Tue, 25 Apr 2023 14:18:08 +0200
Date:   Tue, 25 Apr 2023 14:18:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [RFC PATCH 2/2] net: phy: dp83869: fix mii mode when rgmii strap
 cfg is used
Message-ID: <cbbedaab-b2bf-4a37-88ed-c1a8211920e9@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425054429.3956535-3-s-vadapalli@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:14:29AM +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> The DP83869 PHY on TI's k3-am642-evm supports both MII and RGMII
> interfaces and is configured by default to use RGMII interface (strap).
> However, the board design allows switching dynamically to MII interface
> for testing purposes by applying different set of pinmuxes.

Only for testing? So nobody should actually design a board to use MII
and use software to change the interface from RGMII to MII?

This does not seem to be a fix, it is a new feature. So please submit
to net-next, in two weeks time when it opens again.

> @@ -692,8 +692,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>  	/* Below init sequence for each operational mode is defined in
>  	 * section 9.4.8 of the datasheet.
>  	 */
> +	phy_ctrl_val = dp83869->mode;
> +	if (phydev->interface == PHY_INTERFACE_MODE_MII)
> +		phy_ctrl_val |= DP83869_OP_MODE_MII;

Should there be some validation here with dp83869->mode?

DP83869_RGMII_COPPER_ETHERNET, DP83869_RGMII_SGMII_BRIDGE etc don't
make sense if MII is being used. DP83869_100M_MEDIA_CONVERT and maybe
DP83869_RGMII_100_BASE seem to be the only valid modes with MII?

	Andrew

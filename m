Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750E14DAFFD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355864AbiCPMrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbiCPMrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:47:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EAF2D1CA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eCzggM1GHy6dv2gEXt1Vg19jwLBUY6R1TqLjuM3yDT4=; b=rGbatJRPKRMTowL9oM+wjWKqYW
        WWzOrbtX0fVJBeGH9wwHh9Rm+LXIOXiwecW6UhDfr7a+qkZVlE9HBLwGBywAftNwhZiUUTae1ib3h
        V9nRD5miimAHpVlueMKpv/quLGigAWsndwfU6F2c7iUxzIjq5srp28taaPgwLtd0DzXg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUT25-00BE8h-Uv; Wed, 16 Mar 2022 13:45:41 +0100
Date:   Wed, 16 Mar 2022 13:45:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.co,
        netdev@vger.kernel.org, Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH] net: axiemac: use a phandle to reference pcs_phy
Message-ID: <YjHb9bYloSvnIiTo@lunn.ch>
References: <20220316075953.61398-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316075953.61398-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 03:59:53PM +0800, Andy Chiu wrote:
> The `of_mdio_find_device()` would get a reference to `mdio_device` by
> a given device tree node. Thus, getting a reference to the internal
> PCS/PMA PHY by `lp->phy_node` is incorrect since "phy-handle" in the DT
> sould point to the external PHY. This incorrect use of "phy-hanlde"
> would cause a problem when the driver called `phylink_of_phy_connect()`,
> where it would use "phy-handle" in the DT to connect the external PHY.
> To fix it, we could add a phandle, "pcs-phy", in the DT so that it would
> point to the internal PHY. And the driver would get the correct address
> of PCS/PHY.
> 
> Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 6fd5157f0a6d..293189aab4e6 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2073,12 +2073,15 @@ static int axienet_probe(struct platform_device *pdev)
>  	}
>  	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
>  	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
> -		if (!lp->phy_node) {
> -			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
> +		np = of_parse_phandle(pdev->dev.of_node, "pcs-phy", 0);

Other drivers call this pcs-handle. Please be consistent with them.

You also should update the binding document with this new property.

	Andrew

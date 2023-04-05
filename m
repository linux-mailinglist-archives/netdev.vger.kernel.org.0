Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1676D8682
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjDETGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDETGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:06:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA4D558E;
        Wed,  5 Apr 2023 12:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AAWJccQcWH6bVfGLn6jfJ5NweGGEWRAynxMYiwMVGXU=; b=R0W84hYPsUylEtIxFK88U1rk5h
        KTNwBNeNeULfjCOYwN5R5VbJ0+Fyti9LpHL7L+rNAFlg5Gz8l6TQn5JpKN8tennO+B50F89Nlf2zG
        pzgsEpgOkRGjYejJkYPsGoLGS5w5RrCDCSHl1rGjwpBWs5LyqOPva0aDM8ROqRlgWst0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk8SA-009YGD-Cu; Wed, 05 Apr 2023 21:05:54 +0200
Date:   Wed, 5 Apr 2023 21:05:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCHv2 1/2] net: ethernet: stmmac: dwmac-rk: rework optional
 clock handling
Message-ID: <b92600f9-0ea8-433e-b992-6a3007766fbf@lunn.ch>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
 <20230405161043.46190-2-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161043.46190-2-sebastian.reichel@collabora.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:10:42PM +0200, Sebastian Reichel wrote:
> The clock requesting code is quite repetitive. Fix this by requesting
> the clocks in a loop. Also use devm_clk_get_optional instead of
> devm_clk_get, since the old code effectively handles them as optional
> clocks. This removes error messages about missing clocks for platforms
> not using them and correct -EPROBE_DEFER handling.
> 
> The new code also tries to get "clk_mac_ref" and "clk_mac_refout" when
> the PHY is not configured as PHY_INTERFACE_MODE_RMII to keep the code
> simple. This is possible since we use devm_clk_get_optional() for the
> clock lookup anyways.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 7ad269ea1a2b7 ("GMAC: add driver for Rockchip RK3288 SoCs integrated GMAC")
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 63 ++++++-------------
>  1 file changed, 20 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index 4b8fd11563e4..6fdad0f10d6f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -1475,54 +1475,31 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
>  {
>  	struct rk_priv_data *bsp_priv = plat->bsp_priv;
>  	struct device *dev = &bsp_priv->pdev->dev;
> -	int ret;
> +	int i, ret;
> +	struct {
> +		struct clk **ptr;
> +		const char *name;
> +	} clocks[] = {
> +		{ &bsp_priv->mac_clk_rx, "mac_clk_rx" },
> +		{ &bsp_priv->mac_clk_tx, "mac_clk_tx" },
> +		{ &bsp_priv->aclk_mac, "aclk_mac" },
> +		{ &bsp_priv->pclk_mac, "pclk_mac" },
> +		{ &bsp_priv->clk_mac, "stmmaceth" },
> +		{ &bsp_priv->clk_mac_ref, "clk_mac_ref" },
> +		{ &bsp_priv->clk_mac_refout, "clk_mac_refout" },
> +		{ &bsp_priv->clk_mac_speed, "clk_mac_speed" },
> +	};

> +	for (i=0; i < ARRAY_SIZE(clocks); i++) {
> +		*clocks[i].ptr = devm_clk_get_optional(dev, clocks[i].name);
> +		if (IS_ERR(*clocks[i].ptr))
> +			return dev_err_probe(dev, PTR_ERR(*clocks[i].ptr),
> +					     "cannot get clock %s\n",
> +					     clocks[i].name);
>  	}

Could devm_clk_bulk_get_optional() be used?

      Andrew

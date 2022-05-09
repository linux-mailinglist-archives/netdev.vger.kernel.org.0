Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BB551FF38
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiEIONM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiEIONI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:13:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1E9B2A18A2;
        Mon,  9 May 2022 07:09:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BE2A1480;
        Mon,  9 May 2022 07:09:13 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 945423F73D;
        Mon,  9 May 2022 07:09:10 -0700 (PDT)
Date:   Mon, 9 May 2022 15:09:07 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     alexandre.torgue@foss.st.com, andrew@lunn.ch, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 2/6] net: stmmac: dwmac-sun8i: remove regulator
Message-ID: <20220509150907.6cf9c4d1@donnerap.cambridge.arm.com>
In-Reply-To: <20220509074857.195302-3-clabbe@baylibre.com>
References: <20220509074857.195302-1-clabbe@baylibre.com>
        <20220509074857.195302-3-clabbe@baylibre.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 May 2022 07:48:53 +0000
Corentin Labbe <clabbe@baylibre.com> wrote:

Hi,

> Now regulator is handled by phy core, there is no need to handle it in
> stmmac driver.

I don't think you can do that, since we definitely need to maintain
compatibility with *older* DTs.
Is there a real need for this patch, or is it just a cleanup?
I mean we should be able to keep both approaches in, and the respective
board and DT version selects which it is using.

Cheers,
Andre

> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 37 +------------------
>  1 file changed, 2 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> index f834472599f7..17888813c707 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -17,7 +17,6 @@
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> -#include <linux/regulator/consumer.h>
>  #include <linux/regmap.h>
>  #include <linux/stmmac.h>
>  
> @@ -59,7 +58,6 @@ struct emac_variant {
>  
>  /* struct sunxi_priv_data - hold all sunxi private data
>   * @ephy_clk:	reference to the optional EPHY clock for the internal PHY
> - * @regulator:	reference to the optional regulator
>   * @rst_ephy:	reference to the optional EPHY reset for the internal PHY
>   * @variant:	reference to the current board variant
>   * @regmap:	regmap for using the syscon
> @@ -69,7 +67,6 @@ struct emac_variant {
>   */
>  struct sunxi_priv_data {
>  	struct clk *ephy_clk;
> -	struct regulator *regulator;
>  	struct reset_control *rst_ephy;
>  	const struct emac_variant *variant;
>  	struct regmap_field *regmap_field;
> @@ -568,29 +565,11 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
>  {
>  	struct net_device *ndev = platform_get_drvdata(pdev);
>  	struct sunxi_priv_data *gmac = priv;
> -	int ret;
>  
> -	if (gmac->regulator) {
> -		ret = regulator_enable(gmac->regulator);
> -		if (ret) {
> -			dev_err(&pdev->dev, "Fail to enable regulator\n");
> -			return ret;
> -		}
> -	}
> -
> -	if (gmac->use_internal_phy) {
> -		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
> -		if (ret)
> -			goto err_disable_regulator;
> -	}
> +	if (gmac->use_internal_phy)
> +		return sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
>  
>  	return 0;
> -
> -err_disable_regulator:
> -	if (gmac->regulator)
> -		regulator_disable(gmac->regulator);
> -
> -	return ret;
>  }
>  
>  static void sun8i_dwmac_core_init(struct mac_device_info *hw,
> @@ -1034,9 +1013,6 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
>  
>  	if (gmac->variant->soc_has_internal_phy)
>  		sun8i_dwmac_unpower_internal_phy(gmac);
> -
> -	if (gmac->regulator)
> -		regulator_disable(gmac->regulator);
>  }
>  
>  static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
> @@ -1157,15 +1133,6 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	/* Optional regulator for PHY */
> -	gmac->regulator = devm_regulator_get_optional(dev, "phy");
> -	if (IS_ERR(gmac->regulator)) {
> -		if (PTR_ERR(gmac->regulator) == -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> -		dev_info(dev, "No regulator found\n");
> -		gmac->regulator = NULL;
> -	}
> -
>  	/* The "GMAC clock control" register might be located in the
>  	 * CCU address range (on the R40), or the system control address
>  	 * range (on most other sun8i and later SoCs).


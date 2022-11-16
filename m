Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4909462B0CF
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiKPBwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiKPBwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:52:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8903D25E9D;
        Tue, 15 Nov 2022 17:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kuh/N0Wx2kjpMO629JuP6BcKFcPo/nef5LQjffP+jxk=; b=sxjxv8L6ye11bItWDh5pYym26x
        4zn1UO3NmgBWEaKA6PHD4xgqMZlvSNiTA9Kf/1tm08wE52/R2mdNoHl5veW6ZldZkkAxe5JqI3zeI
        xaEuy8d9U6iVak7VssTEME0+wdtAH2U7CVFG/jtamNJSQYsMu2UoPuMKBgQEZanmAEcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ov7aF-002WAO-AZ; Wed, 16 Nov 2022 02:51:23 +0100
Date:   Wed, 16 Nov 2022 02:51:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 2/3] phy: handle optional regulator for PHY
Message-ID: <Y3RCG/Xt4y3OfisD@lunn.ch>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-3-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115073603.3425396-3-clabbe@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 07:36:02AM +0000, Corentin Labbe wrote:
> Add handling of optional regulators for PHY.
> Regulators need to be enabled before PHY scanning, so MDIO bus
> initiate this task.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/net/mdio/fwnode_mdio.c | 31 ++++++++++++++++++++++++++++++-
>  drivers/net/phy/phy_device.c   | 10 ++++++++++
>  include/linux/phy.h            |  3 +++
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index 689e728345ce..19a16072d4ca 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -10,6 +10,7 @@
>  #include <linux/fwnode_mdio.h>
>  #include <linux/of.h>
>  #include <linux/phy.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/pse-pd/pse.h>

These headers are sorted, so please add regulator after pse.

>  
>  MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
> @@ -116,7 +117,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	struct phy_device *phy;
>  	bool is_c45 = false;
>  	u32 phy_id;
> -	int rc;
> +	int rc, reg_cnt = 0;
> +	struct regulator_bulk_data *consumers = NULL;
> +	struct device_node __maybe_unused *nchild = NULL;

Reverse Christmas tree.

>  
>  	psec = fwnode_find_pse_control(child);
>  	if (IS_ERR(psec))
> @@ -133,6 +136,26 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	if (rc >= 0)
>  		is_c45 = true;
>  
> +#ifdef CONFIG_OF

Do you need this #ifdef ? Generally, all of_* functions should have
stubs if CONFIG_OF is not enabled. It would be nice to remove this, so
we get compile testing. And the __maybe_unused above is then probably
not needed.

> +	for_each_child_of_node(bus->dev.of_node, nchild) {
> +		u32 reg;
> +
> +		of_property_read_u32(nchild, "reg", &reg);
> +		if (reg != addr)
> +			continue;
> +		reg_cnt = of_regulator_bulk_get_all(&bus->dev, nchild, &consumers);
> +		if (reg_cnt > 0) {
> +			rc = regulator_bulk_enable(reg_cnt, consumers);
> +			if (rc)
> +				return rc;
> +		}
> +		if (reg_cnt < 0) {
> +			dev_err(&bus->dev, "Fail to regulator_bulk_get_all err=%d\n", reg_cnt);
> +			return reg_cnt;
> +		}
> +	}
> +#endif
> +

	Andrew

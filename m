Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669AA6A988F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCCNhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjCCNhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:37:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B03D3E09B;
        Fri,  3 Mar 2023 05:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nJdYjZ/flzda0YlArkOtYMjVRR8m/ms+LEswZPJ9qM8=; b=PDJLJDcVtLOYepZxg3fZHfx3Sg
        Rei2dNhiy5la7EjHE9pCxYDyyBCM7gVpz3AvZVYaC8d/aWWWib4Y76vakuuZDbsW9ZRwSiGUZBmek
        zKofeo7MdKiA34PL7XxdTAl0eeaHPLrOK2askiMZFGE5wm1uaSy5K0+3ZHimZGGqCKp4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pY5ai-006O7k-AR; Fri, 03 Mar 2023 14:36:56 +0100
Date:   Fri, 3 Mar 2023 14:36:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface
 settings
Message-ID: <ZAH3+BU5doYpOY6t@lunn.ch>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-9-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303085928.4535-9-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_dat)
> +{
> +	struct starfive_dwmac *dwmac = plat_dat->bsp_priv;
> +	struct of_phandle_args args;
> +	struct regmap *regmap;
> +	unsigned int reg, mask, mode;
> +	int err;
> +
> +	switch (plat_dat->interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		mode = MACPHYC_PHY_INFT_RMII;
> +		break;
> +
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		mode = MACPHYC_PHY_INFT_RGMII;
> +		break;
> +
> +	default:
> +		dev_err(dwmac->dev, "Unsupported interface %d\n",
> +			plat_dat->interface);
> +	}

Please add a return -EINVAL;

> +
> +	err = of_parse_phandle_with_fixed_args(dwmac->dev->of_node,
> +					       "starfive,syscon", 2, 0, &args);
> +	if (err) {
> +		dev_dbg(dwmac->dev, "syscon reg not found\n");
> +		return -EINVAL;
> +	}
> +
> +	reg = args.args[0];
> +	mask = args.args[1];
> +	regmap = syscon_node_to_regmap(args.np);
> +	of_node_put(args.np);
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	return regmap_update_bits(regmap, reg, mask, mode << __ffs(mask));

This is a poor device tree binding. We generally don't allow bindings
which say put value X in register Y.

Could you add a table: interface mode, reg, mask? You can then do a
simple lookup based on the interface mode? No device tree binding
needed at all?

       Andrew

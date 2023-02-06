Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC4B68BFD4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjBFOQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjBFOQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:16:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AE521A1A;
        Mon,  6 Feb 2023 06:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Uwm//uEvfmmKxmoWhqyZTBRjYJjdixdhrA7x2SH7ohw=; b=0+7QLZWW47PHov4bvCcj7Lf26c
        mTtvafXGbP+ERtJRTwpwHOnITOkkhUpcFXpT6mD+gCleRH1k02T3ZnYrZKqQGLx5sTSNhB02RNYpN
        ymjYsrtqT31c7YtIdwfJ/NwsU9SdGfWQJhgi+bD2JR+Pz/Trv2JRwRDeu9q9aQVLAghs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP2HB-004D8x-R5; Mon, 06 Feb 2023 15:15:21 +0100
Date:   Mon, 6 Feb 2023 15:15:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Y+ELeSQX+GWS5N2p@lunn.ch>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206060708.3574472-3-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +enum mii_mode {
> +	MII_MODE_MII = 0,
> +	MII_MODE_RGMII,
> +	MII_MODE_SGMII

There is no mention of SGMII anywhere else. And in a couple of places,
the code makes the assumption that if it is not RGMII it is MII.

Does the hardware really support SGMII?

> +static int prueth_config_rgmiidelay(struct prueth *prueth,
> +				    struct device_node *eth_np,
> +				    phy_interface_t phy_if)
> +{

...

> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
> +
> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);

Here you are adding the TX delay if the phy-mode indicates it should
be added.

> +static int prueth_netdev_init(struct prueth *prueth,
> +			      struct device_node *eth_node)
> +{

> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
> +	if (ret) {
> +		dev_err(prueth->dev, "could not get phy-mode property\n");
> +		goto free;
> +	}

> +	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
> +	if (ret)
> +		goto free;
> +

Reading it from DT and calling the delay function.

> +static int prueth_probe(struct platform_device *pdev)
> +{


> +	/* register the network devices */
> +	if (eth0_node) {
> +		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
> +		if (ret) {
> +			dev_err(dev, "can't register netdev for port MII0");
> +			goto netdev_exit;
> +		}
> +
> +		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
> +
> +		emac_phy_connect(prueth->emac[PRUETH_MAC0]);

And this is connecting the MAC and the PHY, where emac_phy_connect()
passes emac->phy_if to phylib.

What i don't see anywhere is you changing emac->phy_if to indicate the
MAC has inserted the TX delay, and so the PHY should not.

    Andrew


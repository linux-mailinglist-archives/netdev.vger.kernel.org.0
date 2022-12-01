Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C7363F458
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiLAPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiLAPlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:41:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0591F9;
        Thu,  1 Dec 2022 07:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yHPLxsl9MbDFA39XedT/fNFDaxz54nP8D2zOAb8sz/Y=; b=HOkEQshoMedf4HqS3Ukvmb7K+s
        gwW38/teWeetRQOOIhMYIOOiEtsrCxnUVbRM/Ut3foVLKH3itDFBBjT+VrD1hOYz5nA/3ZmKwT2Og
        2BDROwc4BllYWFOQIo2R0/sqq72S6h8/P9lUZ+xMiTjv0oXtR/pSjYvej4dvISZ6Bcjw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0lfh-0044fZ-7W; Thu, 01 Dec 2022 16:40:21 +0100
Date:   Thu, 1 Dec 2022 16:40:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
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
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 4/7] net: phy: motorcomm: Add YT8531 phy support
Message-ID: <Y4jK5VBVuAnl55Xz@lunn.ch>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-5-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201090242.2381-5-yanhong.wang@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const struct ytphy_reg_field ytphy_rxtxd_grp[] = {
> +	{ "rx_delay_sel", GENMASK(13, 10), 0x0 },
> +	{ "tx_delay_sel_fe", GENMASK(7, 4), 0xf },
> +	{ "tx_delay_sel", GENMASK(3, 0), 0x1 }
> +};
> +
> +static const struct ytphy_reg_field ytphy_txinver_grp[] = {
> +	{ "tx_inverted_1000", BIT(14), 0x0 },
> +	{ "tx_inverted_100", BIT(14), 0x0 },
> +	{ "tx_inverted_10", BIT(14), 0x0 }
> +};
> +
> +static const struct ytphy_reg_field ytphy_rxden_grp[] = {
> +	{ "rxc_dly_en", BIT(8), 0x1 }
> +};
> +
> +static int ytphy_config_init(struct phy_device *phydev)
> +{
> +	struct device_node *of_node;
> +	u32 val;
> +	u32 mask;
> +	u32 cfg;
> +	int ret;
> +	int i = 0;
> +
> +	of_node = phydev->mdio.dev.of_node;
> +	if (of_node) {
> +		ret = of_property_read_u32(of_node, ytphy_rxden_grp[0].name, &cfg);

You need to document the device tree binding.

Frank Sae always gets the locking wrong in this driver. Have you
tested your patch with lockdep enabled?

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089024EDECF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbiCaQaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiCaQaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:30:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132262BE8;
        Thu, 31 Mar 2022 09:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=f1Ud/0ViaYH+MGCkH++baXNjD1EX24kMqzHI2gaaGxs=; b=4lrScKXgukeKAmWs+GkIxg97+1
        RHfXVnt0Y21w75FyV8jYpfj33s4RDYd83N/aDGv2lJJkoHqVK2gMYngzvSOXtxVwauOxw/NECZQ3O
        PHzD60K+KvU03fhchiCe7MXrM+N276i2uG4+ZiIUeTsPaCxjKvUDn83ls0ngzpUvx5pM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZxeT-00DUoA-L2; Thu, 31 Mar 2022 18:28:01 +0200
Date:   Thu, 31 Mar 2022 18:28:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/3] net: phy: mscc-miim: add support to set
 MDIO bus frequency
Message-ID: <YkXWkaVRp4I1Gj0p@lunn.ch>
References: <20220331151440.3643482-1-michael@walle.cc>
 <20220331151440.3643482-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331151440.3643482-3-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -295,21 +323,41 @@ static int mscc_miim_probe(struct platform_device *pdev)
>  	if (!miim->info)
>  		return -EINVAL;
>  
> -	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	miim->clk = devm_clk_get_optional(&pdev->dev, NULL);
> +	if (IS_ERR(miim->clk))
> +		return PTR_ERR(miim->clk);
> +
> +	ret = clk_prepare_enable(miim->clk);
> +	if (ret)
> +		return ret;
> +
> +	of_property_read_u32(np, "clock-frequency", &miim->clk_freq);

The clock is optional if there is no "clock-frequency" property.  If
the property does exist, the clock should be mandatory. I don't think
it should silently fail setting the bus frequency because the clock is
missing.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62546AFA1A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCGXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCGXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:16:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5923714E92;
        Tue,  7 Mar 2023 15:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vI9Y1CiHS8N9PY2B3Tf73amwfAMRgvLG+KvBpMQiOWo=; b=UvJIHE6HLfr6F+Wi+Y/J9UekgT
        yo0/iJuW7lkdOwaNBcgQpQYgg8NU72D3yBrsmMApFjxbp0jsONP/qtLUXMksnOyIEp5xO17igjQQA
        8P9VEcG8Kne1xU3gekPcickyCAoi8I8A9Ds1mdr28lsBkBpdWNPnsUMiOPmbynbmqaMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZgXV-006iQ5-Qk; Wed, 08 Mar 2023 00:16:13 +0100
Date:   Wed, 8 Mar 2023 00:16:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
Message-ID: <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170046.28917-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> +{
> +	struct fwnode_handle *ports, *port;
> +	int port_num;
> +	int ret;
> +
> +	ports = device_get_named_child_node(priv->dev, "ports");
> +	if (!ports) {
> +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> +		return 0;
> +	}
> +
> +	fwnode_for_each_child_node(ports, port) {
> +		struct fwnode_handle *phy_node, *reg_port_node = port;
> +
> +		phy_node = fwnode_find_reference(port, "phy-handle", 0);
> +		if (!IS_ERR(phy_node))
> +			reg_port_node = phy_node;

I don't understand this bit. Why are you looking at the phy-handle?

> +
> +		if (fwnode_property_read_u32(reg_port_node, "reg", &port_num))
> +			continue;

I would of expect port, not reg_port_node. I'm missing something
here....

	Andrew

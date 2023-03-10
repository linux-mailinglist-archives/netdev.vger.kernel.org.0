Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994436B3292
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjCJAMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCJAMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:12:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8B0111689;
        Thu,  9 Mar 2023 16:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XwFWZ+VrNQufbXNI3wOtnkelo+LkhVdII6D+91nxRP8=; b=Muv1ZcFuf/S7O3QooyMSmBrtlr
        Y56uZ5MX9cgb1tO2x3MeDEy0AOzPuItF7jUIOw9uVgNf6ink3WMRS71JEdOWOluAw90fcoiRY4cMQ
        +32zGlxV7dP8tzOJtz9eSCe5GjmTVSq8yIcfblsZ3j47oI3VHjdY5M98mM5qFiSE63Qc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paQMd-006vYs-Dy; Fri, 10 Mar 2023 01:12:03 +0100
Date:   Fri, 10 Mar 2023 01:12:03 +0100
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
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v2 02/14] net: dsa: qca8k: add LEDs basic support
Message-ID: <a8c60aa6-2a89-4b2e-b773-224c6a5b03c0@lunn.ch>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
 <20230309223524.23364-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309223524.23364-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config NET_DSA_QCA8K_LEDS_SUPPORT
> +	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"

Is tristate correct here? That means the code can either be built in,
a module, or not built at all. Is that what you want?

It seems more normal to use a bool, not a tristate.

> +static enum led_brightness
> +qca8k_led_brightness_get(struct qca8k_led *led)
> +{
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 val;
> +	int ret;
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> +	if (ret)
> +		return 0;
> +
> +	val >>= reg_info.shift;
> +
> +	if (led->port_num == 0 || led->port_num == 4) {
> +		val &= QCA8K_LED_PATTERN_EN_MASK;
> +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> +	} else {
> +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> +	}
> +
> +	return val > 0 ? 1 : 0;
> +}

What will this return when in the future you add hardware offload, and
the LED is actually blinking because of frames being sent etc?

Is it better to not implement _get() when it is unclear what it should
return when offload is in operation?

       Andrew

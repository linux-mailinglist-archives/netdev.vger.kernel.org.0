Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A656B3361
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCJA6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCJA6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:58:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817DC27D5A;
        Thu,  9 Mar 2023 16:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vjW6QtxHv/QHaq/NXjZ9ZAchd2L2TcgKdY+7ifJRM3o=; b=3jinkUGJMgNUX/yYpsH83fW+B8
        ltXGet1yysa3E0N5nzid+/80PNSR/J8Dp59mC0596V1lKD0sW7hj2IWonzUq4B7bF+N/7LVbaBns3
        bvRP2gpMwcsa4NG6vWVCfZwN1WQ1mKvO4KVKGsG1dHMge4QL1dJ8y7xzuARPhC6b5qBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paR5F-006viw-J1; Fri, 10 Mar 2023 01:58:09 +0100
Date:   Fri, 10 Mar 2023 01:58:09 +0100
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
Message-ID: <98054351-b124-467c-9be6-d8a7c357c268@lunn.ch>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
 <20230309223524.23364-3-ansuelsmth@gmail.com>
 <a8c60aa6-2a89-4b2e-b773-224c6a5b03c0@lunn.ch>
 <640a7775.5d0a0220.110eb.3e41@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <640a7775.5d0a0220.110eb.3e41@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static enum led_brightness
> > > +qca8k_led_brightness_get(struct qca8k_led *led)
> > > +{
> > > +	struct qca8k_led_pattern_en reg_info;
> > > +	struct qca8k_priv *priv = led->priv;
> > > +	u32 val;
> > > +	int ret;
> > > +
> > > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > > +
> > > +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > > +	if (ret)
> > > +		return 0;
> > > +
> > > +	val >>= reg_info.shift;
> > > +
> > > +	if (led->port_num == 0 || led->port_num == 4) {
> > > +		val &= QCA8K_LED_PATTERN_EN_MASK;
> > > +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> > > +	} else {
> > > +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > > +	}
> > > +
> > > +	return val > 0 ? 1 : 0;
> > > +}
> > 
> > What will this return when in the future you add hardware offload, and
> > the LED is actually blinking because of frames being sent etc?
> > 
> > Is it better to not implement _get() when it is unclear what it should
> > return when offload is in operation?
> > 
> 
> My idea was that anything that is not 'always off' will have brightness
> 1. So also in accelerated blink brightness should be 1.
> 
> My idea of get was that it should reflect if the led is active or always
> off. Is it wrong?
 
brigntness_get seems to be used in two situations:

When the LED is first registered, it can be called to get the current
state of the LED. This then initialized cdev->brightness.

When the brightness sysfs file is read, there is first a call to
brightness_get to allow it to update the value in cdev->brightness
before returning the value in the read.

I think always returning 1 could be confusing. Take the example that
the LED is indicating link, there is no link, so it is off. Yet a read
of the brightness sysfs file will return 1?

I would say, it either needs to return the instantaneous brightness,
or it should not be implemented at all. When we come to implement
offloading, we might want to consider hiding the brightness sysfs
file. But we can solve that later.

      Andrew

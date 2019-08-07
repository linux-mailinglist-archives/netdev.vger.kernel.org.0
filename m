Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74503852DC
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbfHGSTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:19:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389042AbfHGSTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 14:19:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L8qDtsZIqu76z78+U7dJxEVIPxF+4lyLrjcD8AHguKI=; b=CnHHSfPZSVro3x4/5FBtFhfzq9
        ItF9KgHUo8zSD74cXXLzMacYyTspybjuZyZ+/9MsuQdm1ZsFuyyTKEDNDWCxVfD2yfAfkGwpi4Yka
        HFc1Ui7yiDyU/cAPpOx6Qn565u4WtnyNDtjTKtx11RSKtNZF03RCQdY0liVTDXeAUZlU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvQWY-0006rZ-I9; Wed, 07 Aug 2019 20:18:58 +0200
Date:   Wed, 7 Aug 2019 20:18:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v5 2/4] net: phy: Add support for generic LED
 configuration through the DT
Message-ID: <20190807181858.GB26047@lunn.ch>
References: <20190807170449.205378-1-mka@chromium.org>
 <20190807170449.205378-3-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807170449.205378-3-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void of_phy_config_leds(struct phy_device *phydev)
> +{
> +	struct device_node *np, *child;
> +	struct phy_led_config cfg;
> +	const char *trigger;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_OF_MDIO) || !phydev->drv->config_led)
> +		return;
> +
> +	np = of_find_node_by_name(phydev->mdio.dev.of_node, "leds");
> +	if (!np)
> +		return;
> +
> +	for_each_child_of_node(np, child) {
> +		u32 led;
> +
> +		if (of_property_read_u32(child, "reg", &led))
> +			goto skip_config;
> +
> +		ret = of_property_read_string(child, "linux,default-trigger",
> +					      &trigger);
> +		if (ret)
> +			trigger = "none";
> +
> +		memset(&cfg, 0, sizeof(cfg));
> +
> +		if (!strcmp(trigger, "none")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_NONE;
> +		} else if (!strcmp(trigger, "phy-link")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK;
> +		} else if (!strcmp(trigger, "phy-link-10m")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10M;
> +		} else if (!strcmp(trigger, "phy-link-100m")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_100M;
> +		} else if (!strcmp(trigger, "phy-link-1g")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_1G;
> +		} else if (!strcmp(trigger, "phy-link-10g")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10G;
> +		} else if (!strcmp(trigger, "phy-link-activity")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK;
> +			cfg.trigger.activity = true;
> +		} else if (!strcmp(trigger, "phy-link-10m-activity")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10M;
> +			cfg.trigger.activity = true;
> +		} else if (!strcmp(trigger, "phy-link-100m-activity")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_100M;
> +			cfg.trigger.activity = true;
> +		} else if (!strcmp(trigger, "phy-link-1g-activity")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_1G;
> +			cfg.trigger.activity = true;
> +		} else if (!strcmp(trigger, "phy-link-10g-activity")) {
> +			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10G;
> +			cfg.trigger.activity = true;
> +		} else {
> +			phydev_warn(phydev, "trigger '%s' for LED%d is invalid\n",
> +				    trigger, led);
> +			goto skip_config;
> +		}
> +
> +		phydev->drv->config_led(phydev, led, &cfg);

We should not ignore the return value. I expect drivers will return
-EINVAL, or EOPNOTSUPP if asked to configure an LED in a way they
don't support. We need to report this. So i would add a phydev_warn:

> +			phydev_warn(phydev, "trigger '%s' for LED%d not supported\n",
> +				    trigger, led);

  Andrew

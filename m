Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826DE852EC
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389319AbfHGSYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:24:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389181AbfHGSYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 14:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QJzG1RorDCaivT1FC6dyOT4S3y4JeEZ4xIz1y6EH+9o=; b=G6r6HDwBbRRDhcHKvqMPpMtF60
        bywA4OV1mW9GymD3IcmN1DQb3tZF0hp5C4mvdX+jvg8hdFJxeEPNzDPTXBnV6tn1ueD83es3gVAUj
        mUb3Q58SNkZeg6qYz8EUn9Ut5r8mH40bwRYUDTCgBAZ1ULpzxGGSg5ER3q9xD7M9tGSo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvQc6-0006uJ-AT; Wed, 07 Aug 2019 20:24:42 +0200
Date:   Wed, 7 Aug 2019 20:24:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v5 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20190807182442.GC26047@lunn.ch>
References: <20190807170449.205378-1-mka@chromium.org>
 <20190807170449.205378-5-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807170449.205378-5-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int rtl8211e_config_led(struct phy_device *phydev, int led,
> +			       struct phy_led_config *cfg)
> +{
> +	u16 lacr_bits = 0, lcr_bits = 0;
> +	int oldpage, ret;
> +
> +	switch (cfg->trigger.t) {
> +	case PHY_LED_TRIGGER_LINK:
> +		lcr_bits = 7 << (led * 4);
> +		break;
> +
> +	case PHY_LED_TRIGGER_LINK_10M:
> +		lcr_bits = 1 << (led * 4);
> +		break;
> +
> +	case PHY_LED_TRIGGER_LINK_100M:
> +		lcr_bits = 2 << (led * 4);
> +		break;
> +
> +	case PHY_LED_TRIGGER_LINK_1G:
> +		lcr_bits |= 4 << (led * 4);
> +		break;
> +
> +	case PHY_LED_TRIGGER_NONE:
> +		break;
> +
> +	default:
> +		phydev_warn(phydev,
> +			    "unknown trigger for LED%d: %d\n",
> +			    led, cfg->trigger.t);

Lets do this once in the core, not in every driver.

> +		return -EINVAL;
> +	}
> +
> +	if (cfg->trigger.activity)
> +		lacr_bits = BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + led);
> +
> +	rtl8211e_disable_eee_led_mode(phydev);
> +
> +	oldpage = rtl8211x_select_ext_page(phydev, 0x2c);
> +	if (oldpage < 0) {
> +		phydev_err(phydev, "failed to select extended page: %d\n", oldpage);
> +		return oldpage;
> +	}
> +
> +	ret = __phy_modify(phydev, RTL8211E_LACR,
> +			   LACR_MASK(led), lacr_bits);
> +	if (ret) {
> +		phydev_err(phydev, "failed to write LACR reg: %d\n",
> +			   ret);
> +		goto err;
> +	}
> +
> +	ret = __phy_modify(phydev, RTL8211E_LCR,
> +			   LCR_MASK(led), lcr_bits);
> +	if (ret)
> +		phydev_err(phydev, "failed to write LCR reg: %d\n",
> +			   ret);

That is a lot of phydev_err() calls. The rest of the driver does not
use any. Also, mdio operations are very unlikely to fail. So i would
just leave it to the layer above to report there is a problem.

     Andrew

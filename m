Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125C53E7BB3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhHJPGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:06:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241917AbhHJPGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 11:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=dtySB9rjcxH7bxKw5rZgefC4uBmGW785dtYYNm9V7pY=; b=nq
        Hzm31SVDVhMomio9sKwpp33QpzqLna0pZOu0cYQ1ET87R9oaWvwLfH+lcywouk0338tcnnR74LTaO
        FG7gC6c8p8szDknYV7bpH0nCxT9+lD0v691DkEZqm8k+3cHXTZdTZqK/+g4OweHINcO1tWDoShtwK
        7b4kQcFLsHizbw4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDTKF-00GvYZ-Ol; Tue, 10 Aug 2021 17:05:55 +0200
Date:   Tue, 10 Aug 2021 17:05:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: phy: nxp-tja11xx: log critical health
 state
Message-ID: <YRKV05IoqtJYr6Cj@lunn.ch>
References: <20210810125618.20255-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210810125618.20255-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

> @@ -89,6 +91,12 @@ static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
>  	{ "phy_polarity_detect", 25, 6, BIT(6) },
>  	{ "phy_open_detect", 25, 7, BIT(7) },
>  	{ "phy_short_detect", 25, 8, BIT(8) },
> +	{ "phy_temp_warn (temp > 155C°)", 25, 9, BIT(9) },
> +	{ "phy_temp_high (temp > 180C°)", 25, 10, BIT(10) },
> +	{ "phy_uv_vddio", 25, 11, BIT(11) },
> +	{ "phy_uv_vddd_1v8", 25, 13, BIT(13) },
> +	{ "phy_uv_vdda_3v3", 25, 14, BIT(14) },
> +	{ "phy_uv_vddd_3v3", 25, 15, BIT(15) },
>  	{ "phy_rem_rcvr_count", 26, 0, GENMASK(7, 0) },
>  	{ "phy_loc_rcvr_count", 26, 8, GENMASK(15, 8) },

I'm not so happy abusing the statistic counters like this. Especially
when we have a better API for temperature and voltage: hwmon.

phy_temp_warn maps to hwmon_temp_max_alarm. phy_temp_high maps to
either hwmon_temp_crit_alarm or hwmon_temp_emergency_alarm.

The under voltage maps to hwmon_in_lcrit_alarm.

> @@ -630,6 +640,11 @@ static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
>  		return IRQ_NONE;
>  	}
>  
> +	if (irq_status & MII_INTSRC_TEMP_ERR)
> +		dev_err(dev, "Overtemperature error detected (temp > 155C°).\n");
> +	if (irq_status & MII_INTSRC_UV_ERR)
> +		dev_err(dev, "Undervoltage error detected.\n");
> +

These are not actual errors, in the linux sense. So dev_warn() or
maybe dev_info().

      Andrew

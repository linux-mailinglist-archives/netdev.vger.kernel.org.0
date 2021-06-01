Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59D397BA9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhFAVVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:21:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhFAVVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 17:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K746KyZUyILnsVyNOLR6LEl2nAN7nqTgxol2ZLaeJwM=; b=hQ+xxKlPF0QerccACdRtGa9pIP
        FYf7R3hPM+8CaKHDhSr9kJ9hrCARuFPb1iRYD/B0iCsD8Ln8j2dnmfmUA+B4AUbaDqynWQxkgDKzw
        HSRXmSDlONBAzjxPg1SLs9WJ2Vj/OnVP+TbNuYGu7RVBQCPo7zK3FYWo+pNyUruBRESc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loBnO-007Lcc-HM; Tue, 01 Jun 2021 23:19:30 +0200
Date:   Tue, 1 Jun 2021 23:19:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v2 10/10] leds: turris-omnia: support offloading
 netdev trigger for WAN LED
Message-ID: <YLakYvTTO3BTG0q6@lunn.ch>
References: <20210601005155.27997-1-kabel@kernel.org>
 <20210601005155.27997-11-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601005155.27997-11-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int omnia_led_trig_offload_wan(struct omnia_leds *leds,
> +				      struct omnia_led *led,
> +				      struct led_netdev_data *trig)
> +{
> +	unsigned long period;
> +	int ret, blink_rate;
> +	bool link, rx, tx;
> +	u8 fun;
> +
> +	/* HW offload on WAN port is supported only via internal PHY */
> +	if (trig->net_dev->sfp_bus || !trig->net_dev->phydev)
> +		return -EOPNOTSUPP;
> +
> +	link = test_bit(NETDEV_LED_LINK, &trig->mode);
> +	rx = test_bit(NETDEV_LED_RX, &trig->mode);
> +	tx = test_bit(NETDEV_LED_TX, &trig->mode);
> +
> +	if (link && rx && tx)
> +		fun = 0x1;
> +	else if (!link && rx && tx)
> +		fun = 0x4;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	period = jiffies_to_msecs(atomic_read(&trig->interval)) * 2;
> +	blink_rate = wan_led_round_blink_rate(&period);
> +	if (blink_rate < 0)
> +		return blink_rate;
> +
> +	mutex_lock(&leds->lock);
> +
> +	if (!led->phydev) {
> +		led->phydev = trig->net_dev->phydev;
> +		get_device(&led->phydev->mdio.dev);
> +	}
> +
> +	/* set PHY's LED[0] pin to blink according to trigger setting */
> +	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
> +			       MII_PHY_LED_TCR,
> +			       MII_PHY_LED_TCR_PULSESTR_MASK |
> +			       MII_PHY_LED_TCR_BLINKRATE_MASK,
> +			       (0 << MII_PHY_LED_TCR_PULSESTR_SHIFT) |
> +			       (blink_rate << MII_PHY_LED_TCR_BLINKRATE_SHIFT));
> +	if (ret)
> +		goto unlock;
> +
> +	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
> +			       MII_PHY_LED_CTRL, 0xf, fun);
> +	if (ret)
> +		goto unlock;

This needs to be in the Marvell PHY driver. Please add a generic
interface any PHY driver can implement to allow its LEDs to be
controlled.

	Andrew

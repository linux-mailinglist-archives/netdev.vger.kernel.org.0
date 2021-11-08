Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C564480C8
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhKHOHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:07:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhKHOHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:07:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wJJrpppjSgRDTFrW+F5oEMLPyVDlFIclMKsDYZzd0Pc=; b=XjSYLHlaXLwsdK23MobXnt8pMN
        t0m5+/o+1rvO+cz2IGsLVcTgPk0r6tz6yYzO+nwBQf3IDj7rMP9Jt3P9evizyaO35gyysrqEDy03N
        P+aJxsoL4Gc9ib08ig32pw/ddxjlv1W/TtYfkNbqJYJ7o26jij/mZqvz+rLlA8BeUxaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk5G3-00CtvX-4e; Mon, 08 Nov 2021 15:04:23 +0100
Date:   Mon, 8 Nov 2021 15:04:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYkuZwQi66slgfTZ@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108002500.19115-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline int led_trigger_offload(struct led_classdev *led_cdev)
> +{
> +	int ret;
> +
> +	if (!led_cdev->trigger_offload)
> +		return -EOPNOTSUPP;
> +
> +	ret = led_cdev->trigger_offload(led_cdev, true);
> +	led_cdev->offloaded = !ret;
> +
> +	return ret;
> +}
> +
> +static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
> +{
> +	if (!led_cdev->trigger_offload)
> +		return;
> +
> +	if (led_cdev->offloaded) {
> +		led_cdev->trigger_offload(led_cdev, false);
> +		led_cdev->offloaded = false;
> +	}
> +}
> +#endif

I think there should be two calls into the cdev driver, not this
true/false parameter. trigger_offload_start() and
trigger_offload_stop().

There are also a number of PHYs which don't allow software blinking of
the LED. So for them, trigger_offload_stop() is going to return
-EOPNOTSUPP. And you need to handle that correctly.

It would be go to also document the expectations of
trigger_offload_stop(). Should it leave the LED in whatever state it
was, or force it off? 

     Andrew

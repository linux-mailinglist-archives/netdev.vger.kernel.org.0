Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B544A68C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 07:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhKIGFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 01:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240251AbhKIGFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 01:05:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CBFC061764;
        Mon,  8 Nov 2021 22:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=wcCiGrIoiCHb/FUDi9mir5h93KXm+BbzPHesuj2IQdg=; b=KsCJgHsM4+w+SdE5iznn+kVlLL
        Xvpvm41MUpzcrT+ayNkp1kfETAi4/4w1dy1gx0TiarkXP+nYkFwH0vz0ZqLi28v8BzeXH2E0qNk5z
        JzK43OYGJxLi7t8awMzvy3qlZz21g6uFZFIxVs2uzYrSUwY54C+kkQH9NjZubBNK2vYtlHsKmlDgL
        vX4vclswy8Pp61UFyD7UdiVbypKnzFkFpcFDmlw1GmvouOCNEeFJw8NPmpU3e/M/HEBjml1Ionct8
        4MJwFHAXPvop62DqJnp0W2Fw3ZxcBSXePV3tpga5s+NRgseqT7G0eAqTSDGfzFdexHPbzin3LYP6m
        aHRkJV3w==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkKDE-008ljd-9h; Tue, 09 Nov 2021 06:02:28 +0000
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <28048612-a7d2-19e0-a632-a5ae061819cd@infradead.org>
Date:   Mon, 8 Nov 2021 22:02:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109022608.11109-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 6:26 PM, Ansuel Smith wrote:
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index dc6816d36d06..b947b238be3f 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -154,4 +154,32 @@ config LEDS_TRIGGER_TTY
>   
>   	  When build as a module this driver will be called ledtrig-tty.
>   
> +config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
> +	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"
> +	depends on LEDS_HARDWARE_CONTROL
> +	help
> +	  This allows LEDs to be configured to run by hardware and offloaded
> +	  based on some rules. The LED will blink or be on based on the PHY

	                                          or be "on" based on the PHY

> +	  Activity for example on packet receive or based on the link speed.

	  activity

> +
> +	  The current supported offload triggers are:
> +	  - blink_tx: Blink LED on tx packet receive
> +	  - blink_rx: Blink LED on rx packet receive
> +	  - keep_link_10m: Keep LED on with 10m link speed
> +	  - keep_link_100m: Keep LED on with 100m link speed
> +	  - keep_link_1000m: Keep LED on with 1000m link speed
> +	  - keep_half_duplex: Keep LED on with half duplex link
> +	  - keep_full_duplex: Keep LED on with full duplex link
> +	  - option_linkup_over: Blink rules are ignored with absent link
> +	  - option_power_on_reset: Power ON Led on Switch/PHY reset
> +	  - option_blink_2hz: Set blink speed at 2hz for every blink event
> +	  - option_blink_4hz: Set blink speed at 4hz for every blink event
> +	  - option_blink_8hz: Set blink speed at 8hz for every blink event
> +
> +	  These blink modes are present in the LED sysfs dir under
> +	  hardware-phy-activity if supported by the LED driver.
> +
> +	  This trigger can be used only by LEDs that supports Hardware mode

	                                             support Hardware mode.


Ansuel, do you read and consider these comments?
It's difficult to tell if you do or not.

thanks.
-- 
~Randy

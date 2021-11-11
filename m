Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5580944CFF8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhKKCVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhKKCVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:21:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE79C061766;
        Wed, 10 Nov 2021 18:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=N8Ya7xuJZuZa7uVD5bXff/mdxtAgK083vH8aF2C6p+4=; b=XTU/23LeVC6QNY8nkO+/0v+d08
        xjnp2jDziI4L27Q/yz8EfHdyxY1X9Ct1QPrYH62cvv3hRcJOa2WmTDGxqekCRZlF3vXAdeYGeLsg9
        ah++R6TVN8O/IN6ORvF+KxZMFDvCwpWOQx/zS5O4SrDTnI1pHLgOFQgK8lDoW/1Lr4JwLKEAKDW34
        Wp/lsgbMSnrWDDAoODP6JmmkxIdCfC4NFEocsYqFYPwSeTEuQdVZSSlGNZMEypb84iJy7ZvHpZUNT
        mAPVYuUdXZu7ql0w2K3W9FWre5yBuL/IfUNrVxUePn8myEOdq2xXckc3bAPJ+aiqfPlXrxUXdcnZN
        zq5JZDNA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkzfq-006pG9-Tm; Thu, 11 Nov 2021 02:18:47 +0000
Subject: Re: [RFC PATCH v4 6/8] leds: trigger: add hardware-phy-activity
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
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
 <20211111013500.13882-7-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <94f6db80-04a3-6007-5dc4-62a3b45dcb49@infradead.org>
Date:   Wed, 10 Nov 2021 18:18:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111013500.13882-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/21 5:34 PM, Ansuel Smith wrote:
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index dc6816d36d06..737a8be533a3 100644
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

	                                    to be run

> +	  based on some rules. The LED will blink or be on based on the PHY

	                                          or be "on" based on

> +	  activity for example on packet receive or based on the link speed.
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
> +	  This trigger can be used only by LEDs that support Hardware mode.


-- 
~Randy

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E09A44D003
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKKC06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKKC05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:26:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35735C061766;
        Wed, 10 Nov 2021 18:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=L9KCH3U8IdDiFR9Id11yKIAzCbww2INZcBozXT16NGA=; b=ri10uBmEnVIqoytevmbY3gnVzA
        u6/24Ocp8Yl7aufFziZD2smWyCtYWNq3Clx7DXKR2nNBcrBllEdi6fWh6mFBzVyXGW8FoDK7nJ8WP
        9INOqYsjJLuqW+F/8kd0Bmp7UT3d8BykISmiX9siBYSmoPGE50VFsnjImjhCClp+DISl/HsItVLiy
        DUAn4aASB4r1MJv+8cJKloK/F+lExxVEZ5lGGle3rc0MLPpJR9cComN2sjClPU3rFcofUTUFLrvXV
        2nH1Z3Vqtq/HbhH6w6LhpPBAcV3FeNpmw9oPm0dbLR4chG0HfSKQ/MOReuEjQrGSEGqZo+JQI5Cik
        4vjyMYlg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkzl1-006r1T-L1; Thu, 11 Nov 2021 02:24:07 +0000
Subject: Re: [RFC PATCH v4 1/8] leds: add support for hardware driven LEDs
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
 <20211111013500.13882-2-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1d493cd2-ea4e-3181-c09a-73d69a155f5e@infradead.org>
Date:   Wed, 10 Nov 2021 18:24:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111013500.13882-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/21 5:34 PM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index cd155ead8703..0175954717a3 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -169,6 +169,38 @@ Setting the brightness to zero with brightness_set() callback function
>   should completely turn off the LED and cancel the previously programmed
>   hardware blinking function, if any.
>   
> +Hardware driven LEDs
> +===================================
> +
> +Some LEDs can be driven by hardware (for example a LED connected to

                                                     an LED

> +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> +the network, which in software is done by the netdev trigger).
> +
> +To do such offloading, LED driver must support this and a supported trigger must
> +be used.
> +
> +LED driver should declare the correct control mode supported and should set
> +the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the flags
> +parameter.
> +The trigger will check these bit and fail to activate if the control mode

                                 bits

> +is not supported. By default if a LED driver doesn't declare a control mode,
> +bit LED_SOFTWARE_CONTROLLED is assumed and set by default.

drop the second:                                  by default

> +
> +The LED must implement 3 main API:

                                  APIs:

> +- hw_control_status(): This asks the LED driver if hardware mode is enabled
> +    or not.
> +- hw_control_start(): This will simply enable the hardware mode for the LED
> +    and the LED driver should reset any active blink_mode.
> +- hw_control_stop(): This will simply disable the hardware mode for the LED.
> +    It's advised to the driver to put the LED in the old state but this is not
> +    enforcerd and putting the LED off is also accepted.

        enforced

> +
> +If LED_HARDWARE_CONTROLLED bit is the only contro mode set (LED_SOFTWARE_CONTROLLED

                                               control

> +not set) set hw_control_status/start/stop is optional as the LED supports only
> +hardware mode and any software only trigger will reject activation.
> +
> +On init a LED driver that support a hardware mode should reset every blink mode

            an LED

> +set by default.
>   
>   Known Issues
>   ============
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ed800f5da7d8..bd2b19cc77ec 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -49,6 +49,17 @@ config LEDS_BRIGHTNESS_HW_CHANGED
>   
>   	  See Documentation/ABI/testing/sysfs-class-led for details.
>   
> +config LEDS_HARDWARE_CONTROL
> +	bool "LED Hardware Control support"
> +	help
> +	  This option enabled Hardware control support used by leds that

	              enables                                  LEDs

> +	  can be driven in hardware by using supported triggers.
> +
> +	  Hardware blink modes will be exposed by sysfs class in
> +	  /sys/class/leds based on the trigger currently active.
> +
> +	  If unsure, say Y.


-- 
~Randy

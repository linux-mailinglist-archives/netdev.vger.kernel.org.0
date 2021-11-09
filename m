Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC98844A6B9
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 07:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243120AbhKIGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 01:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhKIGTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 01:19:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17F6C061764;
        Mon,  8 Nov 2021 22:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=/tOC4F0dmIvNku/yGuBCvTDhpdB/KMuIFHb37+08Fu4=; b=uc87aere3JNp1ldILlXUD8oOkM
        i1DNfZl2AW2QSsYzMOm+hEwD4e+DiT1jPselHidr3tAeRCptZ2o8bXLvm1/75jK6A88jsy9dxCbNu
        fInsCwILgZWGz6kiU8bD8Ij1phD+3KU4a5PLpYt9Jv9uhLjeIuFACHsRk+ARi5sT4g4gwTModqrUR
        0O5fMFOmQbS69Gf2AjrYRXXVFCXBYFTKDOIb677GD/LLz5MMQkD2K3S0KLKrIByJHz+3u5+OCWxL4
        nwXw9zcZKu7EN1YWGRzSyzcSBr1mQk9GAVNApfD8IpneC0BYisYDpFyVvhSr+q5d0hW7ty0BSFSjL
        Yp6ORDLA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkKRE-008ln8-OM; Tue, 09 Nov 2021 06:16:57 +0000
Subject: Re: [RFC PATCH v3 1/8] leds: add support for hardware driven LEDs
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
 <20211109022608.11109-2-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ece88816-ebe1-19d5-aa7d-16ad26121883@infradead.org>
Date:   Mon, 8 Nov 2021 22:16:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109022608.11109-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 6:26 PM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index cd155ead8703..645940b78d81 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -169,6 +169,34 @@ Setting the brightness to zero with brightness_set() callback function
>   should completely turn off the LED and cancel the previously programmed
>   hardware blinking function, if any.
>   
> +Hardware driven LEDs
> +===================================
> +
> +Some LEDs can be driven by hardware (for example a LED connected to
> +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> +the network, which in software is done by the netdev trigger).
> +
> +To do such offloading, LED driver must support this and a supported trigger must
> +be used.
> +
> +LED driver should declare the correct blink_mode supported and should set the
> +blink_mode parameter to one of HARDWARE_CONTROLLED or SOFTWARE_HARDWARE_CONTROLLED.
> +The trigger will check this option and fail to activate if the blink_mode is not
> +supported. By default if a LED driver doesn't declare blink_mode, SOFTWARE_CONTROLLED
> +is assumed.
> +
> +The LED must implement 3 main API:

                                  APIs:

> +- hw_control_status(): This asks the LED driver if hardware mode is enabled
> +    or not. Triggers will check if the hardware mode is active and will try
> +    to offload their triggers if supported by the driver.
> +- hw_control_start(): This will simply enable the hardware mode for the LED.
> +- hw_control_stop(): This will simply disable the hardware mode for the LED.
> +    It's advised to the driver to put the LED in the old state but this is not

                     for the driver

> +    enforcerd and putting the LED off is also accepted.

        enforced

> +
> +With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
> +and any software only trigger will reject activation as the LED supports only
> +hardware mode.
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

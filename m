Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D62D447676
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhKGWzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKGWzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:55:06 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4053C061570;
        Sun,  7 Nov 2021 14:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Fum75CvEuxsWYF7Libex0N752zHf3ES0X0D4SqueWCs=; b=1ZBf/8fImB+bWmbQP68x8w4Gtm
        +KPuylGr8yX7v/iXvpQXbKc31BBzvZlDR2s/4hfK6cBw2c3jljZ0RiELPX1am0zwUkvPvIZhjfY77
        gdKR/6hP18uAXqrOO0wPe5YQSEZpxcaMX1vLLnS7Ns27W32XW7HWUzj/mY33CZpcQDY3pX7fuzo4+
        UYgqGgcctyNEadAFyc6pwV0p6EXys4tC8ykOTD0nftxFLEoBhEpHAq7Mx1U8+4TYkWpdxJq/Hu91f
        6LRobCgNQrrH0FTJXVKIj6U0gKx/pQNXI65Uh34r3CfU9cHPIiLklbuNg18N0CgKgc/UQ3PH4mtAh
        fS4BLNpQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjr1O-008eur-Lu; Sun, 07 Nov 2021 22:52:19 +0000
Subject: Re: [RFC PATCH 1/6] leds: trigger: add API for HW offloading of
 triggers
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-2-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <754414f1-d8f7-7100-0f2f-fad5430fbc86@infradead.org>
Date:   Sun, 7 Nov 2021 14:52:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211107175718.9151-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/7/21 9:57 AM, Ansuel Smith wrote:
> From: Marek Behún <kabel@kernel.org>
> 
> Add method trigger_offload() and member variable `offloaded` to struct
> led_classdev. Add helper functions led_trigger_offload() and
> led_trigger_offload_stop().
> 
> The trigger_offload() method, when implemented by the LED driver, should
> be called (via led_trigger_offload() function) from trigger code wanting
> to be offloaded at the moment when configuration of the trigger changes.
> 
> If the trigger is successfully offloaded, this method returns 0 and the
> trigger does not have to blink the LED in software.
> 
> If the trigger with given configuration cannot be offloaded, the method
> should return -EOPNOTSUPP, in which case the trigger must blink the LED
> in SW.
> 
> The second argument to trigger_offload() being false means that the
> offloading is being disabled. In this case the function must return 0,
> errors are not permitted.
> 
> An additional config CONFIG_LEDS_OFFLOAD_TRIGGERS is added to add support
> for these special trigger offload driven.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   Documentation/leds/leds-class.rst | 22 +++++++++++++++++++++
>   drivers/leds/led-triggers.c       |  1 +
>   drivers/leds/trigger/Kconfig      | 10 ++++++++++
>   include/linux/leds.h              | 33 +++++++++++++++++++++++++++++++
>   4 files changed, 66 insertions(+)
> 
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index cd155ead8703..035a738afc4a 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -169,6 +169,28 @@ Setting the brightness to zero with brightness_set() callback function
>   should completely turn off the LED and cancel the previously programmed
>   hardware blinking function, if any.
>   
> +Hardware offloading of LED triggers
> +===================================
> +
> +Some LEDs can offload SW triggers to hardware (for example a LED connected to

Better to s/SW/software/ and s/HW/hardware/ throughout the documentation file
and Kconfig file(s).

> +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> +the network, which in software is done by the netdev trigger).
> +
> +To do such offloading, LED driver must support the this and a deficated offload

                                            drop:  the            dedicated

> +trigger must be used. The LED must implement the trigger_offload() method and

How does an LED implement the trigger_offload() method?
They don't have very much logic in them AFAIK.

> +the trigger code must try to call this method (via led_trigger_offload()
> +function) when configuration of the trigger (trigger_data) changes.
> +
> +The implementation of the trigger_offload() method by the LED driver must return
> +0 if the offload is successful and -EOPNOTSUPP if the requested trigger
> +configuration is not supported and the trigger should be executed in software.
> +If trigger_offload() returns negative value, the triggering will be done in
> +software, so any active offloading must also be disabled.
> +
> +If the second argument (enable) to the trigger_offload() method is false, any
> +active HW offloading must be deactivated. In this case errors are not permitted
> +in the trigger_offload() method.


> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index dc6816d36d06..c073e64e0a37 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -9,6 +9,16 @@ menuconfig LEDS_TRIGGERS
>   
>   if LEDS_TRIGGERS
>   
> +config LEDS_OFFLOAD_TRIGGERS
> +	bool "LED Offload Trigger support"
> +	help
> +	  This option enabled offload triggers support used by leds that

	                                                       LEDs

> +	  can be driven in HW by declaring some specific triggers.
> +	  A offload trigger will expose a sysfs dir to configure the
> +	  different blinking trigger and the available hw trigger.

Are the sysfs file values/meanings documented here?
I seem to have missed them.

> +
> +	  If unsure, say Y.
> +

thanks.
-- 
~Randy

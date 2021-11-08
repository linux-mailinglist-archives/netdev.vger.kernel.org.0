Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9744789B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 03:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhKHCb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 21:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhKHCb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 21:31:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEC3C061570;
        Sun,  7 Nov 2021 18:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=DaO7a1BViMKHX1NBRkvWDUjB1rua4ERcqws+CFgZJiE=; b=IPS9aghJaG07vU6gMyuOjYmc0N
        MsjYZ1meQwVV/2oSA1o2VqcPfvBzhYQHD9VMurv521P02d2HqyiVLNEvrhqyehQVq9M03IIm5eRg4
        j845ufpFjC/iYS/Ku6avPOeeIG8YIXFzJy47Aa53ePhdpaH8kKeRvtdu7jTaEcGHO/E7J/H5JMrdv
        id6Qw54k2wCtGRtsZ/sJNin+sKsAoIQh8eewN56y3He2AHlU39OEhwuB6Heon52rCvCfD5sVYVpKE
        Xxo+LVlcDzO7AdUqOq//vOUIwhIf5ndeyAOm70aqc+qylCgpaqMje4UT8D1na/XuqMcOuFfjyghik
        4W0hHefw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjuPI-008fRs-WC; Mon, 08 Nov 2021 02:29:13 +0000
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
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
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7e73d616-9326-ff03-639f-b3b264e64a26@infradead.org>
Date:   Sun, 7 Nov 2021 18:29:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108002500.19115-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 4:24 PM, Ansuel Smith wrote:
> From: Marek Behún <kabel@kernel.org>
> 

> ---
>   Documentation/leds/leds-class.rst | 20 +++++++++++++++++++
>   drivers/leds/led-triggers.c       |  1 +
>   drivers/leds/trigger/Kconfig      | 10 ++++++++++
>   include/linux/leds.h              | 33 +++++++++++++++++++++++++++++++
>   4 files changed, 64 insertions(+)
> 
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index cd155ead8703..5bf6e5d471ce 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -169,6 +169,26 @@ Setting the brightness to zero with brightness_set() callback function
>   should completely turn off the LED and cancel the previously programmed
>   hardware blinking function, if any.
>   
> +Hardware offloading of LED triggers
> +===================================
> +
> +Some LEDs can be driven by hardware triggers (for example a LED connected to
> +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> +the network, which in software is done by the netdev trigger).
> +
> +To do such offloading, LED driver must support this and a deficated offload

                                                              dedicated

> +trigger must be used. The LED must implement the trigger_offload() method and
> +the trigger code must try to call this method (via led_trigger_offload()
> +function) to set the LED to this particular mode. (and disable any software
> +blinking)
> +
> +The implementation of the trigger_offload() method by the LED driver must return
> +0 if the offload is successful and -EOPNOTSUPP if the requested trigger
> +configuration is not supported.
> +
> +If the second argument (enable) to the trigger_offload() method is false, any
> +active HW offloading must be deactivated. In this case errors are not permitted

Preferably s/HW/hardware/ and s/SW/software/ throughout documentation and Kconfig
files.

> +in the trigger_offload() method and the driver will be set to the new trigger.
>   
>   Known Issues
>   ============


> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index dc6816d36d06..33aba8defeab 100644
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

	              enables                                  LEDs

> +	  can be driven in hardware by declaring some specific triggers.
> +	  A offload trigger will expose a sysfs dir to configure the
> +	  different blinking trigger and the available hardware triggers.
> +
> +	  If unsure, say Y.


-- 
~Randy

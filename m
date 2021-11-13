Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE1844F05C
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 02:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhKMBHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 20:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhKMBHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 20:07:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFDCC061766;
        Fri, 12 Nov 2021 17:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=W3pYbR+KVmnwM9kipI6oWi9/VlOqRdBW9731D/Unbls=; b=SirK07t7fUZav/KZHpehdWm2dg
        smFKrI3HxOycN0XM7e5Z3I3VjABmpRwkJ9ojak4flvNLdePbVfQnhJu2CBAVGyJZIhjxgM/B1vjeQ
        a2m66ITzael0Za5s9QT1rtT1CNiPhRa1ETLIofTfB/97h2Bi8wY1LfQuey1dIlJjBv7b3Ar3F+nlO
        ZRKXc6Fb8CxrGsCMX+FEgPWoWmXwNMHah01n1yPtBDfDKb1jTvwM8ycck2w0dvtVYkixVQNdp5nAK
        FndQ6j8iOUsGxN0821G9gIRw37/hr13KRusgBWRh4wQtcRZcQFEidlFbrdgxYXMN0XJKLb+fFCksU
        DDu7SfhQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlhSv-00BxSy-9a; Sat, 13 Nov 2021 01:04:21 +0000
Subject: Re: [PATCH v5 1/8] leds: add support for hardware driven LEDs
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
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
 <20211112153557.26941-2-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <523edf1d-ec7d-5915-0212-d7ab0b1ce1d6@infradead.org>
Date:   Fri, 12 Nov 2021 17:04:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112153557.26941-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/21 7:35 AM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index cd155ead8703..e5d266919a19 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -169,6 +169,38 @@ Setting the brightness to zero with brightness_set() callback function
>   should completely turn off the LED and cancel the previously programmed
>   hardware blinking function, if any.
>   
> +Hardware driven LEDs
> +===================================
> +
> +Some LEDs can be driven by hardware (for example an LED connected to
> +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> +the network, which in software is done by the netdev trigger).
> +
> +To do such offloading, LED driver must support this and a supported trigger must
> +be used.
> +
> +LED driver should declare the correct control mode supported and should set
> +the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the flags
> +parameter.
> +The trigger will check these bits and fail to activate if the control mode
> +is not supported. By default if a LED driver doesn't declare a control mode,

                                 if an LED driver

> +bit LED_SOFTWARE_CONTROLLED is assumed and set.
> +
> +The LED must implement 3 main APIs:
> +- hw_control_status(): This asks the LED driver if hardware mode is enabled
> +    or not.
> +- hw_control_start(): This will simply enable the hardware mode for the LED
> +    and the LED driver should reset any active blink_mode.
> +- hw_control_stop(): This will simply disable the hardware mode for the LED.
> +    It's advised to the driver to put the LED in the old state but this is not
> +    enforced and putting the LED off is also accepted.
> +
> +If LED_HARDWARE_CONTROLLED bit is the only control mode set (LED_SOFTWARE_CONTROLLED
> +not set) set hw_control_status/start/stop is optional as the LED supports only

             ^^^ is that an extra "set"?  I can't quite read this sentence.

And it would be better with a comma added, like so:

   not set),


> +hardware mode and any software only trigger will reject activation.

                          software-only

> +
> +On init an LED driver that support a hardware mode should reset every blink mode

                               supports

> +set by default.


-- 
~Randy

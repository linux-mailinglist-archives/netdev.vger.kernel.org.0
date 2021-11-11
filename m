Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3544D00B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhKKCbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKKCa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:30:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51881C061766;
        Wed, 10 Nov 2021 18:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=th/0FiDnIpwmVdJ5jv3QB6l++8rUlwQG8LU84WSyudo=; b=3ADQi4ZXxj/UHn9w4dj76fjpRg
        LQX4t2jMiq8rP8LnneByzyNONe7Uc4VhCFMc1QQMBB2Ej2chowazFojjhb4hE4ATd83/U/kIGkBZD
        c9MQnfcmp5XCtVbakZe9/NBa+yFYsVJZeK/h8LfKK+8+VqehZTEeZnM0cBUvo7Bt2UUaKE6JZd3ej
        hwzE0fKeiXFE7Oo9MDzPEG8mdyw/IjbGFJlSxLPJSbIPTm6XmZ6hCBxu2pzq03qesiB/jdEGQIulM
        HBhJtBiBeZv7P94QNky8pz5e35BM4EnEO59Bxfb9K+Af7PXMBOacHbFUd5WzLt8Cz4CyXzVOWfEgy
        9zSIexfA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkzow-006sMM-7f; Thu, 11 Nov 2021 02:28:10 +0000
Subject: Re: [RFC PATCH v4 2/8] leds: document additional use of blink_set for
 hardware control
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
 <20211111013500.13882-3-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3c37f8c8-5c0a-302c-e68c-e6ac37cde695@infradead.org>
Date:   Wed, 10 Nov 2021 18:28:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111013500.13882-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ansuel,

Sorry -- I screwed this one up a little bit on the previous iteration.

On 11/10/21 5:34 PM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index 0175954717a3..c06a18b811de 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -202,6 +202,23 @@ hardware mode and any software only trigger will reject activation.
>   On init a LED driver that support a hardware mode should reset every blink mode
>   set by default.
>   
> +Once a trigger has declared support for hardware-controller blinks, it will use

                                            hardware-controlled

> +blink_set() to try to offload his trigger on activation/configuration.
> +blink_set() will return 0 if the requested modes set in trigger_data can be
> +controlled by hardware or an error if both the mode bitmap is not supported by

maybe:                                if both of the bitmap modes are not supported by

> +the hardware or there was a problem in the configuration.
> +
> +Following blink_set logic, setting brightness to LED_OFF with hardware control active
> +will reset any active blink mode and disable hardware control setting the LED to off.
> +
> +It's in the LED driver's interest to know how to elaborate the trigger data and report support
> +for a particular set of blink modes. For this exact reason explicit support for the specific
> +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter hardware mode
> +with a not supported trigger.
> +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> +fail as the driver doesn't support that specific hardware blink modes or doesn't know

                                                                    mode

> +how to handle the provided trigger data.


thanks.
-- 
~Randy

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3883447884
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 03:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbhKHCZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 21:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhKHCZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 21:25:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C188AC061570;
        Sun,  7 Nov 2021 18:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Kmu1o3d56x2PHpP0lDg/mYidF1A/EmIUpA6P+e8dkwE=; b=wAknlF+ydZevj70eq0j8ZFkyVz
        0lClZbALmoyuNN2Xuk4+RZNhe06866teuO8O90/BcUMJ0rH1dDJhKd3C5UxiIokL9HsYwH4Jv6AVI
        HESTbJrNgKjgOZCRr/zenRz590Mm+BFpWf2aZI1k7itxTJM8E8Bv+xxDYX5Rw5RO72uclGmsUm8WX
        GL1GwaBoaZbM3p70SCqosj2OhgDMNp39jwPbcHWqA7z3kpcy3Y+ZbCiv+k4g9lRYdcnLmbPJH0Te7
        RJ0tJvJKQ4gM7yhJau+SRBXElgZxU7HXiO53d0AH/KHkht3JbF+fmG6MWQzc4/ZP0lIogmZ40+Y4Y
        LYjU5GkQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjuIj-008fPf-EB; Mon, 08 Nov 2021 02:22:26 +0000
Subject: Re: [RFC PATCH v2 2/5] leds: add function to configure offload leds
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
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-3-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f28d4f1b-66e7-808c-ae69-c1734d60fdc1@infradead.org>
Date:   Sun, 7 Nov 2021 18:22:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108002500.19115-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 4:24 PM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index 5bf6e5d471ce..0a3bbe71dac7 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -190,6 +190,30 @@ If the second argument (enable) to the trigger_offload() method is false, any
>   active HW offloading must be deactivated. In this case errors are not permitted
>   in the trigger_offload() method and the driver will be set to the new trigger.
>   
> +The offload trigger will use the function configure_offload() provided by the driver
> +that will configure the offloaded mode for the LED.
> +This function passes as the first argument (offload_flags) a u32 flag.
> +The second argument (cmd) of the configure_offload() method can be used to do various
> +operations for the specific trigger. We currently support ENABLE, DISABLE, READ and
> +SUPPORTED to enable, disable, read the state of the offload trigger and ask the LED
> +driver supports the specific offload trigger.
> +
> +In ENABLE/DISABLE configure_offload() should configure the LED to enable/disable the
> +requested trigger (flags).
> +In READ configure_offload() should return 0 or 1 based on the status of the requested
> +trigger (flags).
> +In SUPPORTED configure_offload() should return 0 or 1 if the LED driver supports the
> +requested trigger (flags) or not.
> +
> +The u32 flag is specific to the trigger and change across them. It's in the LED

                                                changes

> +driver interest know how to elaborate this flag and to declare support for a

    driver's

> +particular offload trigger. For this exact reason explicit support for the specific
> +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> +with a not supported trigger.
> +If the driver returns -EOPNOTSUPP on configure_offload(), the trigger activation will
> +fail as the driver doesn't support that specific offload trigger or doesn't know
> +how to handle the provided flags.


-- 
~Randy

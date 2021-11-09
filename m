Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0044A6AF
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 07:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243080AbhKIGO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 01:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbhKIGO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 01:14:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB6C061764;
        Mon,  8 Nov 2021 22:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=AqxeG9GMAXTBgfM0qk7iHTvqCqKRCutUS/VQ+ILwkaQ=; b=JD/PdfTT2f0wIkwwjCNnTVAPUt
        7AWcf1S4AGHXEnBbIaUX1X2GHGuH/Ntui4nunaPnLqWOMPY026F6279zfd8ULG6mWzb6507ltebfD
        ko0pVebCoC7XfOeHhmbW3ThVj7+dIkoBHvepAJme8QPnDWuToX7K4/gwboDIyjHQgoK3OQ9LWM6Dh
        dP33YPtN8vl1nZFZL3YsFD5qvoe7XVxP7bFWdIDZnt20LtNIx+BSflKfNNa3/kjIZAmJz79tbSBL4
        yv+Hf8Od9klstS4CONxTxEuXLRbL8tMnzVcz1GiyanDMPRYd1euAYIndWX47naqsTvO1Pk3Mp4man
        /4+6enXw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkKMd-008lm1-LJ; Tue, 09 Nov 2021 06:12:12 +0000
Subject: Re: [RFC PATCH v3 2/8] leds: add function to configure hardware
 controlled LED
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
 <20211109022608.11109-3-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3e854c1c-25e2-789b-de67-d99344fcb498@infradead.org>
Date:   Mon, 8 Nov 2021 22:12:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109022608.11109-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 6:26 PM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index 645940b78d81..efd2f68c46a7 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
>   and any software only trigger will reject activation as the LED supports only
>   hardware mode.
>   
> +A trigger once he declared support for hardware controlled blinks, will use the function

Maybe this:
    Once a trigger has declared support for hardware-controller blinks, it will us the function

> +hw_control_configure() provided by the driver to check support for a particular blink mode.
> +This function passes as the first argument (flag) a u32 flag.
> +The second argument (cmd) of hw_control_configure() method can be used to do various
> +operations for the specific blink mode. We currently support ENABLE, DISABLE, READ, ZERO
> +and SUPPORTED to enable, disable, read the state of the blink mode, ask the LED
> +driver if it does supports the specific blink mode and to reset any blink mode active.
> +
> +In ENABLE/DISABLE hw_control_configure() should configure the LED to enable/disable the
> +requested blink mode (flag).
> +In READ hw_control_configure() should return 0 or 1 based on the status of the requested
> +blink mode (flag).
> +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
> +requested blink mode (flags) or not.
> +In ZERO hw_control_configure() should return 0 with success operation or error.
> +
> +The unsigned long flag is specific to the trigger and change across them. It's in the LED

                                                          changes

> +driver interest know how to elaborate this flag and to declare support for a

    driver's interest to know how to

> +particular trigger. For this exact reason explicit support for the specific
> +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> +with a not supported trigger.
> +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> +fail as the driver doesn't support that specific offload trigger or doesn't know
> +how to handle the provided flags.


-- 
~Randy

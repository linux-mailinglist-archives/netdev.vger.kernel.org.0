Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599844F054
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 01:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhKMA6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 19:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhKMA6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 19:58:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7718AC061766;
        Fri, 12 Nov 2021 16:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=yfWFwVygX4LELuhhE6JdpYKcH8c3JWQlsq941prq5Ok=; b=OL1i8crCCeuXAAYZJvt8gS6caB
        o96+WNDhTQzTk67rlv/KjBMBKfTEOV7EisLAROIM6bKw5vAh6J5uEL2/llqpjONqQI9ssP/LTh30I
        nIcGUtCcutjWVSqIlrT/XmE+J9BAjektGfw80/8ypuRQEk5f6abgjjfKqdlR792OXeUY5nRz0dCP3
        cw6Ztic4dRqwhfennUWA+zZ2OUdPWhew4YCHhr4kbVdvTPBmGDvbml8u3kVKeTkBy4/vISqiQD531
        7smFbbzGrB35b8lI8NHS5skxiVFkIgSHJwVYMGEU+evtQ5+pwQ4WEefPUATW39Ba6H+A0lnMeCR2L
        9ohCNFZQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlhKq-00BxJ4-1p; Sat, 13 Nov 2021 00:56:00 +0000
Subject: Re: [PATCH v5 2/8] leds: document additional use of blink_set for
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
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
 <20211112153557.26941-3-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5ef01f7d-b250-73e5-3f06-d03aba1304c7@infradead.org>
Date:   Fri, 12 Nov 2021 16:55:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112153557.26941-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/21 7:35 AM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index e5d266919a19..fa6e1cfc4628 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -202,6 +202,23 @@ hardware mode and any software only trigger will reject activation.
>   On init an LED driver that support a hardware mode should reset every blink mode
>   set by default.
>   
> +Once a trigger has declared support for hardware-controlled blinks, it will use
> +blink_set() to try to offload his trigger on activation/configuration.

                                  this trigger

> +blink_set() will return 0 if the requested modes set in trigger_data can be
> +controlled by hardware or an error if both of the bitmap modes are not supported by
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
> +fail as the driver doesn't support that specific hardware blink mode or doesn't know
> +how to handle the provided trigger data.


-- 
~Randy

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696E444A51F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 04:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbhKIDDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 22:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236778AbhKIDDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 22:03:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB9C61107;
        Tue,  9 Nov 2021 03:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636426868;
        bh=JGCXv2AMQ5ioYEbGNFcgOPV9CYI4zdThX7rRlB0J1a4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZJA7qTe5f89tXT4wljKt/mrRXdEEwivM9rqgy1CP8gEe0lF9u9N9gVVZWL75/1Vj
         fLmMnZCLX4mB9MXvZNzpTWH47MiA2XH4oLI36dyQqMhKXZAJHl9cs4su2hFiayH5Rw
         kc+JpA+7NgKhZLNC4Mnh5443KjIYu6iNn4d2nsEKJAmd43KRZwBNGit3olGdJY8kFW
         Vr0WVofNBuKOPIf8rv4UqFzAoxjx1RU5igSqhgd/CNcYmhXNsuR32hAb2+ARSZiYaI
         Q9qwdsViF/YSN8G+3eGZhhi5rPFx2B79rtsN8hLquWkgDATO1FjQ+I/JSNSWF2hKV+
         uwt6SsEgTw7KA==
Date:   Tue, 9 Nov 2021 04:01:03 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [RFC PATCH v3 2/8] leds: add function to configure hardware
 controlled LED
Message-ID: <20211109040103.7b56bf82@thinkpad>
In-Reply-To: <20211109022608.11109-3-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
        <20211109022608.11109-3-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ansuel,

On Tue,  9 Nov 2021 03:26:02 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Add hw_control_configure helper to configure how the LED should work in
> hardware mode. The function require to support the particular trigger and
> will use the passed flag to elaborate the data and apply the
> correct configuration. This function will then be used by the trigger to
> request and update hardware configuration.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/leds/leds-class.rst | 25 ++++++++++++++++++++
>  include/linux/leds.h              | 39 +++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index 645940b78d81..efd2f68c46a7 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
>  and any software only trigger will reject activation as the LED supports only
>  hardware mode.
>  
> +A trigger once he declared support for hardware controlled blinks, will use the function
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
> +driver interest know how to elaborate this flag and to declare support for a
> +particular trigger. For this exact reason explicit support for the specific
> +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> +with a not supported trigger.
> +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> +fail as the driver doesn't support that specific offload trigger or doesn't know
> +how to handle the provided flags.
> +
>  Known Issues
>  ============
>  
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index cf0c6005c297..00bc4d6ed7ca 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -73,6 +73,16 @@ enum led_blink_modes {
>  	SOFTWARE_HARDWARE_CONTROLLED,
>  };
>  
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +enum blink_mode_cmd {
> +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
> +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> +};
> +#endif

this is a strange proposal for the API.

Anyway, led_classdev already has the blink_set() method, which is documented as
	/*
	  * Activate hardware accelerated blink, delays are in milliseconds
	  * and if both are zero then a sensible default should be chosen.
	  * The call should adjust the timings in that case and if it can't
	  * match the values specified exactly.
	  * Deactivate blinking again when the brightness is set to LED_OFF
	  * via the brightness_set() callback.
	  */
	int		(*blink_set)(struct led_classdev *led_cdev,
				     unsigned long *delay_on,
				     unsigned long *delay_off);

So we already have a method to set hardware blkinking, we don't need
another one.

Marek

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B351B1BD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378963AbiEDWW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiEDWW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:22:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFAC4ECC3;
        Wed,  4 May 2022 15:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8hBZj6uy3ZLbWSq7oEb3tyeHIasKxirvMqK/Ski5GtE=; b=mgkJ8fpVyKh/WKJM/8EgFaOH83
        6kOfAI7y4qGPyuABhwBAonYS0wF19H9bAyvgTjqZ6d4Cv0tSTLhQtEleJi5EdlPhFweJNTWk6xIsx
        VlduNw4kbDjequ5fsuz+wNf+9D/65cqfloc37hlOnuMzFS817F2H/CaxAFZw/ILf2aIQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmNKx-001GtT-DP; Thu, 05 May 2022 00:19:11 +0200
Date:   Thu, 5 May 2022 00:19:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v6 01/11] leds: add support for hardware driven LEDs
Message-ID: <YnL73yOfh+wHQObm@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 6a8ea94834fa..3516ae3c4c3c 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -164,6 +164,27 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
>  }
>  #endif
>  
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +static int led_classdev_check_blink_mode_functions(struct led_classdev *led_cdev)
> +{
> +	int mode = led_cdev->blink_mode;
> +

We try to avoid #ifdef in code. I suggest you use

   if (IS_ENABLED(CONFIG_LEDS_HARDWARE_CONTROL)) {
   }

You then get compiler coverage independent of if the option is on or
off.

> +	if (mode == SOFTWARE_HARDWARE_CONTROLLED &&
> +	    (!led_cdev->hw_control_status ||
> +	    !led_cdev->hw_control_start ||
> +	    !led_cdev->hw_control_stop))
> +		return -EINVAL;
> +
> +	if (mode == SOFTWARE_CONTROLLED &&
> +	    (led_cdev->hw_control_status ||
> +	    led_cdev->hw_control_start ||
> +	    led_cdev->hw_control_stop))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +#endif
> +
>  /**
>   * led_classdev_suspend - suspend an led_classdev.
>   * @led_cdev: the led_classdev to suspend.
> @@ -367,6 +388,12 @@ int led_classdev_register_ext(struct device *parent,
>  	if (ret < 0)
>  		return ret;
>  
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +	ret = led_classdev_check_blink_mode_functions(led_cdev);
> +	if (ret < 0)
> +		return ret;
> +#endif

You can then drop this #ifdef, since it will return 0 by default when
disabled, and the compiler should optimize it all out.

> @@ -154,6 +160,32 @@ struct led_classdev {
>  
>  	/* LEDs that have private triggers have this set */
>  	struct led_hw_trigger_type	*trigger_type;
> +
> +	/* This report the supported blink_mode. The driver should report the
> +	 * correct LED capabilities.
> +	 * With this set to HARDWARE_CONTROLLED, LED is always in offload mode
> +	 * and triggers can't be simulated by software.
> +	 * If the led is HARDWARE_CONTROLLED, status/start/stop function
> +	 * are optional.
> +	 * By default SOFTWARE_CONTROLLED is set as blink_mode.
> +	 */
> +	enum led_blink_modes	blink_mode;
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +	/* Ask the LED driver if hardware mode is enabled or not.
> +	 * If the option is not declared by the LED driver, SOFTWARE_CONTROLLED
> +	 * is assumed.
> +	 * Triggers will check if the hardware mode is supported and will be
> +	 * activated accordingly. If the trigger can't run in hardware mode,
> +	 * return -EOPNOTSUPP as the blinking can't be simulated by software.
> +	 */
> +	bool			(*hw_control_status)(struct led_classdev *led_cdev);
> +	/* Set LED in hardware mode */
> +	int			(*hw_control_start)(struct led_classdev *led_cdev);
> +	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
> +	 * the old status but that is not mandatory and also putting it off is accepted.
> +	 */
> +	int			(*hw_control_stop)(struct led_classdev *led_cdev);
> +#endif

I'm surprised this builds. It looked like you accessed these two
members even when the option was disabled. I would keep them even when
the option is disabled. Two pointers don't add much overhead, and it
makes the drivers simpler.

>  #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
> @@ -215,7 +247,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
>  extern void led_put(struct led_classdev *led_cdev);
>  struct led_classdev *__must_check devm_of_led_get(struct device *dev,
>  						  int index);
> -

Unrelated white space change.

	  Andrew

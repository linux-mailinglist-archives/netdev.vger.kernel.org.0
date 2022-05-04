Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E058B51B3DD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346566AbiEEADm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380101AbiEDX13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:27:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E5B50B13;
        Wed,  4 May 2022 16:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z9csiruEF5xbbCJV5LeYL29FmqJAFdz3ZoLv9sjrHrQ=; b=5CK4fQnwZ5a6lvAHhinEALRp/t
        S43cRzuf6hgQWYVQ1BaliQev7dwRrINVXjS9k+S65XNd2DhoSZjUjVh6M0lYbL2rWbXbKyl4E4ZNw
        Y/iJ8VeRoPwZISh+iABX3W3HfrLNqZu1Ezh6T+/J3kmh7ySGtSurUk+ZN+Ff/NWcyW/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmOLI-001HGB-8v; Thu, 05 May 2022 01:23:36 +0200
Date:   Thu, 5 May 2022 01:23:36 +0200
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 02/11] leds: add function to configure hardware
 controlled LED
Message-ID: <YnMK+EZDQXSGDXM1@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
> +requested blink mode (flags) or not.

-EOPNOTSUPP might be clearer.


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
> index 09ff1dc6f48d..b5aad67fecfb 100644
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

Skip the #ifdef. The enum itself takes no space if never used, and it
makes the driver simpler if they always exist.

> +
>  struct led_classdev {
>  	const char		*name;
>  	unsigned int brightness;
> @@ -185,6 +195,17 @@ struct led_classdev {
>  	 * the old status but that is not mandatory and also putting it off is accepted.
>  	 */
>  	int			(*hw_control_stop)(struct led_classdev *led_cdev);
> +	/* This will be used to configure the various blink modes LED support in hardware
> +	 * mode.
> +	 * The LED driver require to support the active trigger and will elaborate the
> +	 * unsigned long flag and do the operation based on the provided cmd.
> +	 * Current operation are enable,disable,supported and status.
> +	 * A trigger will use this to enable or disable the asked blink mode, check the
> +	 * status of the blink mode or ask if the blink mode can run in hardware mode.
> +	 */
> +	int			(*hw_control_configure)(struct led_classdev *led_cdev,
> +							unsigned long flag,
> +							enum blink_mode_cmd cmd);
>  #endif
>  #endif
>  
> @@ -454,6 +475,24 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
>  	return led_cdev->trigger_data;
>  }
>  
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
> +						       unsigned long flag)
> +{
> +	int ret;
> +
> +	/* Sanity check: make sure led support hw mode */
> +	if (led_cdev->blink_mode == SOFTWARE_CONTROLLED)
> +		return false;
> +
> +	ret = led_cdev->hw_control_configure(led_cdev, flag, BLINK_MODE_SUPPORTED);
> +	if (ret > 0)
> +		return true;
> +
> +	return false;
> +}
> +#endif

Please add a version which returns false when
CONFIG_LEDS_HARDWARE_CONTROL is disabled.

Does this actually need to be an inline function?

     Andrew

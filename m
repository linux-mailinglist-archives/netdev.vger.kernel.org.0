Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B660D6F2A14
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjD3Rz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjD3RzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:55:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8101992;
        Sun, 30 Apr 2023 10:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yIlvZOfuTjNn6HkPZw086p3Bn1dl9M6rzGcnCz91xaY=; b=Jr+GGNS2rmQ+rHMRGFgXmAsRDY
        TWhd/rhdXcCUQ8v/KfzazpEYnjj4vXsP/yixKkrUhngYMUDqscI6Ne2uEgOI53qoicB1F3WQqSJAG
        d9LGC9xDyIjPWH9MLQhAEeye89AhFvO64Usns9my8YD/g1EFk5+qRzvRrg3pByOCPUzY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptBGT-00BYzN-Ft; Sun, 30 Apr 2023 19:55:13 +0200
Date:   Sun, 30 Apr 2023 19:55:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 08/11] leds: trigger: netdev: add support for LED hw
 control
Message-ID: <d2c86cf0-d57f-4358-9765-3983a145e1ab@lunn.ch>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <20230427001541.18704-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427001541.18704-9-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 02:15:38AM +0200, Christian Marangi wrote:
> Add support for LED hw control for the netdev trigger.
> 
> The trigger on calling set_baseline_state to configure a new mode, will
> do various check to verify if hw control can be used for the requested
> mode in the validate_requested_mode() function.
> 
> It will first check if the LED driver supports hw control for the netdev
> trigger, then will check if the requested mode are in the trigger mode
> mask and finally will call hw_control_set() to apply the requested mode.
> 
> To use such mode, interval MUST be set to the default value and net_dev
> MUST be empty. If one of these 2 value are not valid, hw control will
> never be used and normal software fallback is used.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 52 +++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> index 8cd876647a27..61bc19fd0c7a 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -68,6 +68,13 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
>  	int current_brightness;
>  	struct led_classdev *led_cdev = trigger_data->led_cdev;
>  
> +	/* Already validated, hw control is possible with the requested mode */
> +	if (trigger_data->hw_control) {
> +		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
> +
> +		return;
> +	}
> +
>  	current_brightness = led_cdev->brightness;
>  	if (current_brightness)
>  		led_cdev->blink_brightness = current_brightness;
> @@ -95,6 +102,51 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
>  static int validate_requested_mode(struct led_netdev_data *trigger_data,
>  				   unsigned long mode, bool *can_use_hw_control)
>  {
> +	unsigned int interval = atomic_read(&trigger_data->interval);
> +	unsigned long hw_supported_mode, hw_mode = 0, sw_mode = 0;
> +	struct led_classdev *led_cdev = trigger_data->led_cdev;
> +	unsigned long default_interval = msecs_to_jiffies(50);
> +	bool force_sw = false;
> +	int i, ret;
> +
> +	hw_supported_mode = led_cdev->trigger_supported_flags_mask;
> +

> +		if (interval == default_interval && !trigger_data->net_dev &&
> +		    !force_sw && test_bit(i, &hw_supported_mode))
> +			set_bit(i, &hw_mode);
> +		else
> +			set_bit(i, &sw_mode);
> +	}
> +

> +	/* Check if the requested mode is supported */
> +	ret = led_cdev->hw_control_is_supported(led_cdev, hw_mode);
> +	if (ret)
> +		return ret;

Hi Christian

What is the purpose of led_cdev->trigger_supported_flags_mask? I don't
see why it is needed when you are also going to ask the PHY if it can
support the specific blink pattern the user is requesting.

The problem i have with the Marvell PHY, and other PHYs i've looked at
datasheets for, is that hardware does not work like this. It has a
collection of blinking modes, which are a mixture of link speeds, rx
activity, and tx activity. It supports just a subset of all
possibilities.

I think this function can be simplified. Simply ask the LED via
hw_control_is_supported() does it support this mode. If yes, offload
it, if not use software blinking.

    Andrew

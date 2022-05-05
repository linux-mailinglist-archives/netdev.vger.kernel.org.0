Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1316A51B4ED
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiEEBEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiEEBDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:03:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F6E22298;
        Wed,  4 May 2022 18:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kIQQrRnRI0vk/O19gDTge/P4HrJOYt2OZJvWm9t1XRo=; b=RTGnzZefu3QBxVW32cySexw2+J
        oCJG44ZZH9m44UHiOTw3UeB5Zedpi2CPepgcaEak2r1Qa+xwv7QhkNQsr2CHEAhWYXMEXYOuBi2TY
        2ug9kxDvPLDyJCHxT/XGmh9sV8zeBApSHJv+ewWsp0M800JKy0V3zSGdH+i3x7QWkySs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmPqd-001Hk9-MA; Thu, 05 May 2022 03:00:03 +0200
Date:   Thu, 5 May 2022 03:00:03 +0200
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
Subject: Re: [RFC PATCH v6 06/11] leds: trigger: netdev: add hardware control
 support
Message-ID: <YnMhk1F0LrIMK5hp@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-7-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct netdev_led_attr_detail {
> +	char *name;
> +	bool hardware_only;
> +	enum led_trigger_netdev_modes bit;
> +};
> +
> +static struct netdev_led_attr_detail attr_details[] = {
> +	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
> +	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
> +	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},

hardware_only is never set. Maybe it is used in a later patch? If so,
please introduce it there.

>  static void set_baseline_state(struct led_netdev_data *trigger_data)
>  {
> +	int i;
>  	int current_brightness;
> +	struct netdev_led_attr_detail *detail;
>  	struct led_classdev *led_cdev = trigger_data->led_cdev;

This file mostly keeps with reverse christmas tree, probably because
it was written by a netdev developer. It is probably not required for
the LED subsystem, but it would be nice to keep the file consistent.

> @@ -100,10 +195,15 @@ static ssize_t device_name_store(struct device *dev,
>  				 size_t size)
>  {
>  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
> +	struct net_device *old_net = trigger_data->net_dev;
> +	char old_device_name[IFNAMSIZ];
>  
>  	if (size >= IFNAMSIZ)
>  		return -EINVAL;
>  
> +	/* Backup old device name */
> +	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
> +
>  	cancel_delayed_work_sync(&trigger_data->work);
>  
>  	spin_lock_bh(&trigger_data->lock);
> @@ -122,6 +222,19 @@ static ssize_t device_name_store(struct device *dev,
>  		trigger_data->net_dev =
>  		    dev_get_by_name(&init_net, trigger_data->device_name);
>  
> +	if (!validate_baseline_state(trigger_data)) {

You probably want to validate trigger_data->net_dev is not NULL first. The current code
is a little odd with that, 

> +		/* Restore old net_dev and device_name */
> +		if (trigger_data->net_dev)
> +			dev_put(trigger_data->net_dev);
> +
> +		dev_hold(old_net);

This dev_hold() looks wrong. It is trying to undo a dev_put()
somewhere? You should not actually do a put until you know you really
do not old_net, otherwise there is a danger it disappears and you
cannot undo.

> @@ -228,13 +349,22 @@ static ssize_t interval_store(struct device *dev,
>  		return ret;
>  
>  	/* impose some basic bounds on the timer interval */
> -	if (value >= 5 && value <= 10000) {
> -		cancel_delayed_work_sync(&trigger_data->work);
> +	if (value < 5 || value > 10000)
> +		return -EINVAL;
> +
> +	cancel_delayed_work_sync(&trigger_data->work);
> +
> +	atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
>  
> -		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
> -		set_baseline_state(trigger_data);	/* resets timer */
> +	if (!validate_baseline_state(trigger_data)) {
> +		/* Restore old interval on validation error */
> +		atomic_set(&trigger_data->interval, old_interval);
> +		trigger_data->mode = old_mode;

I think you need to schedule the work again, since you cancelled
it. It is at the end of the work that the next work is scheduled, and
so it will not self recover.

   Andrew

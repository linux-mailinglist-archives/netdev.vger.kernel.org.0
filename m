Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74944B48D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbhKIVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:20:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244996AbhKIVUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 16:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PVGQ+BZt3Xap89luTjpJPz1xs/+AqNdvxEq59MVPyl0=; b=aXM43gt+wWhALE2thCtM9R4Mk4
        IKhP2qxS56tmDVwVF74wiAkyktUVHElObPkCzC3lWpXMa6TZ/b9fJFQ+jwhvt/KoQp1vrVK8ICh6a
        oDVb2H7tpCHwlcqjo2W3TAcDpzpzDarHKmgkmJKhSJF1WRD6fRocYbl/6NgLf6hWG2Mo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkYV7-00D1YE-VJ; Tue, 09 Nov 2021 22:17:53 +0100
Date:   Tue, 9 Nov 2021 22:17:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYrlgVT7Okw1c6pB@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109022608.11109-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define DEFINE_OFFLOAD_TRIGGER(trigger_name, trigger) \
> +	static ssize_t trigger_name##_show(struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +	{ \
> +		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
> +		int val; \
> +		val = led_cdev->hw_control_configure(led_cdev, trigger, BLINK_MODE_READ); \
> +		return sprintf(buf, "%d\n", val ? 1 : 0); \
> +	} \
> +	static ssize_t trigger_name##_store(struct device *dev, \
> +					struct device_attribute *attr, \
> +					const char *buf, size_t size) \
> +	{ \
> +		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
> +		unsigned long state; \
> +		int cmd, ret; \
> +		ret = kstrtoul(buf, 0, &state); \
> +		if (ret) \
> +			return ret; \
> +		cmd = !!state ? BLINK_MODE_ENABLE : BLINK_MODE_DISABLE; \
> +		/* Update the configuration with every change */ \
> +		led_cdev->hw_control_configure(led_cdev, trigger, cmd); \
> +		return size; \
> +	} \
> +	DEVICE_ATTR_RW(trigger_name)

These are pretty big macro magic functions. And there is little actual
macro in them. So make them simple functions which call helpers

	static ssize_t trigger_name##_show(struct device *dev, \
				struct device_attribute *attr, char *buf) \
	{ \
		return trigger_generic_store(dev, attr, buf, size, trigger); \
	} \
	static ssize_t trigger_name##_store(struct device *dev, \
					struct device_attribute *attr, \
					const char *buf, size_t size) \
	{ \
		return trigger_generic_store(dev, attr, buf, size, trigger); \
	} \

> +/* The attrs will be placed dynamically based on the supported triggers */
> +static struct attribute *phy_activity_attrs[PHY_ACTIVITY_MAX_TRIGGERS + 1];
> +
> +static int offload_phy_activity_activate(struct led_classdev *led_cdev)
> +{
> +	u32 checked_list = 0;
> +	int i, trigger, ret;
> +
> +	/* Scan the supported offload triggers and expose them in sysfs if supported */
> +	for (trigger = 0, i = 0; trigger < PHY_ACTIVITY_MAX_TRIGGERS; trigger++) {
> +		if (!(checked_list & BLINK_TX) &&
> +		    led_trigger_blink_mode_is_supported(led_cdev, BLINK_TX)) {
> +			phy_activity_attrs[i++] = &dev_attr_blink_tx.attr;
> +			checked_list |= BLINK_TX;
> +		}

Please re-write this using tables, rather than all this repeated code.

       Andrew

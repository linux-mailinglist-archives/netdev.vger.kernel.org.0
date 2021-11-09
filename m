Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630E544B44D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbhKIUwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:52:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234739AbhKIUwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 15:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uskoC32TMSdvuhJDKn7CRN77CNfPsPQG6NnfnK3Twxc=; b=oMlqYD7MuCJ1P+HJlrJsKVUG9T
        t8nss0SRNMLjgrcYFGJHySV0bvIBXoDs2GmSGUthD8iMvNSbbdoDQyEgIQR30JZPfDNMJqPCHxuGK
        DZJKkAyyyHtwBlMoK+lAQ8V/eojcKmWRJW/MJLTz1dJNzy/HWi8c07ilkf948Vcc9TpA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkY3j-00D1Qb-Mr; Tue, 09 Nov 2021 21:49:35 +0100
Date:   Tue, 9 Nov 2021 21:49:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
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
Message-ID: <YYre31rVDcs8OWre@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-3-ansuelsmth@gmail.com>
 <20211109040103.7b56bf82@thinkpad>
 <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > > +enum blink_mode_cmd {
> > > +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> > > +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> > > +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> > > +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
> > > +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> > > +};
> > > +#endif
> > 
> > this is a strange proposal for the API.
> > 
> > Anyway, led_classdev already has the blink_set() method, which is documented as
> > 	/*
> > 	  * Activate hardware accelerated blink, delays are in milliseconds
> > 	  * and if both are zero then a sensible default should be chosen.
> > 	  * The call should adjust the timings in that case and if it can't
> > 	  * match the values specified exactly.
> > 	  * Deactivate blinking again when the brightness is set to LED_OFF
> > 	  * via the brightness_set() callback.
> > 	  */
> > 	int		(*blink_set)(struct led_classdev *led_cdev,
> > 				     unsigned long *delay_on,
> > 				     unsigned long *delay_off);
> > 
> > So we already have a method to set hardware blkinking, we don't need
> > another one.
> > 
> > Marek
> 
> But that is about hardware blink, not a LED controlled by hardware based
> on some rules/modes.
> Doesn't really match the use for the hardware control.
> Blink_set makes the LED blink contantly at the declared delay.
> The blink_mode_cmd are used to request stuff to a LED in hardware mode.
> 
> Doesn't seem correct to change/enhance the blink_set function with
> something that would do something completely different.

Humm. I can see merits for both.

What i like about reusing blink_set() is that it is well understood.
There is a defined sysfs API for it. ledtrig-oneshot.c also uses it,
for a non-repeating blink. So i think that also fits the PHY LED use
case.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890DC263865
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIIVUV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 17:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIIVUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:20:21 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C58C061573;
        Wed,  9 Sep 2020 14:20:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id D29DF140647;
        Wed,  9 Sep 2020 23:20:16 +0200 (CEST)
Date:   Wed, 9 Sep 2020 23:20:16 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
Message-ID: <20200909232016.138bd1db@nic.cz>
In-Reply-To: <20200909204815.GB20388@amd>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-3-marek.behun@nic.cz>
        <20200909204815.GB20388@amd>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 22:48:15 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Many an ethernet PHY (and other chips) supports various HW control modes
> > for LEDs connected directly to them.  
> 
> I guess this should be
> 
> "Many ethernet PHYs (and other chips) support various HW control modes
> for LEDs connected directly to them."
> 

I guess it is older English, used mainly in poetry, but I read it in
works of contemporary fiction as well. As far as I could find, it is still
actually gramatically correct.
https://idioms.thefreedictionary.com/many+an
https://en.wiktionary.org/wiki/many_a
But I will change it if you insist on it.

> > This API registers a new private LED trigger called dev-hw-mode. When
> > this trigger is enabled for a LED, the various HW control modes which
> > are supported by the device for given LED can be get/set via hw_mode
> > sysfs file.
> > 
> > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > ---
> >  .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
> >  drivers/leds/Kconfig                          |  10 +  
> 
> I guess this should live in drivers/leds/trigger/ledtrig-hw.c . I'd
> call the trigger just "hw"...
> 

Will move in next version. Lets see what others think about the trigger
name.

> > +Contact:	Marek Behún <marek.behun@nic.cz>
> > +		linux-leds@vger.kernel.org
> > +Description:	(W) Set the HW control mode of this LED. The various available HW control modes
> > +		    are specific per device to which the LED is connected to and per LED itself.
> > +		(R) Show the available HW control modes and the currently selected one.  
> 
> 80 columns :-) (and please fix that globally, at least at places where
> it is easy, like comments).
> 

Linux is at 100 columns now since commit bdc48fa11e46, commited by
Linus. See
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/scripts/checkpatch.pl?h=v5.9-rc4&id=bdc48fa11e46f867ea4d75fa59ee87a7f48be144
There was actually an article about this on Phoronix, I think.

> > +	return 0;
> > +err_free:
> > +	devm_kfree(dev, led);
> > +	return ret;
> > +}  
> 
> No need for explicit free with devm_ infrastructure?


No, but if the registration failed, I don't see any reason why the
memory should be freed only when the PHY device is destroyed, if the
memory is not used... On failures other code in Linux frees even devm_
allocated resources.

> > +	cur_mode = led->ops->led_get_hw_mode(dev->parent, led);
> > +
> > +	for (mode = led->ops->led_iter_hw_mode(dev->parent, led, &iter);
> > +	     mode;
> > +	     mode = led->ops->led_iter_hw_mode(dev->parent, led, &iter)) {
> > +		bool sel;
> > +
> > +		sel = cur_mode && !strcmp(mode, cur_mode);
> > +
> > +		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s%s ", sel ? "[" : "", mode,
> > +				 sel ? "]" : "");
> > +	}
> > +
> > +	if (buf[len - 1] == ' ')
> > +		buf[len - 1] = '\n';  
> 
> Can this ever be false? Are you accessing buf[-1] in such case?
> 

It can be false if whole PAGE_SIZE is written. The code above
using scnprintf only writes the first PAGE_SIZE bytes.
You are right about the buf[-1] case though. len has to be nonzero.
Thanks.

> > +int of_register_hw_controlled_leds(struct device *dev, const char *devicename,
> > +				   const struct hw_controlled_led_ops *ops);
> > +int hw_controlled_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness);
> > +  
> 
> Could we do something like hw_controlled_led -> hw_led to keep
> verbosity down and line lengths reasonable? Or hwc_led?
>

I am not opposed, lets see what Andrew / others think.

> > +extern struct led_hw_trigger_type hw_control_led_trig_type;
> > +extern struct led_trigger hw_control_led_trig;
> > +
> > +#else /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */  
> 
> CONFIG_LEDS_HWC? Or maybe CONFIG_LEDTRIG_HW?

The second option looks more reasonable to me, if we move to
drivers/leds/trigger.

Marek

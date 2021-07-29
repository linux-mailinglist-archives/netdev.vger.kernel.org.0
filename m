Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2AA3D9FF5
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhG2I7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235197AbhG2I7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 04:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC6660F23;
        Thu, 29 Jul 2021 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627549147;
        bh=ky+s93ZT6hz6wf52JivasHePWhFIThV59TCtSkd33O8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePmHKdWZ7uxG8WR0j6mcaB5Gpz840+BF0igTDq/FzK4Sur8F2KVkRiRLJN3FUAtmS
         Vt2JrvqmjJKM9LNQnIjH4M+/XtNnpBIcwR+ZINpLdasgNkD2jZB2f8Do9IfxWzT9Yl
         GXxCUcx4sKhOtah4Y/Qbw4Qklpe31T25fKHv8abCHhsYdEh3mZXTUtNT9iWVCBpk7f
         U8jk6DQTmPFvRdT+Lv3cgseJFdrS72mYG8ai82FVmFjOBoyaxXEI1CM99cwv2BR+p/
         AmnGvpJ2MFhYnXrvjtKdZnRysboUz8HujqXHhF1qN4Z+R6O+2N/Jhj20nuoaeSHd2Q
         O9HLYI9oqMyQw==
Date:   Thu, 29 Jul 2021 10:59:01 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, pavel@ucw.cz, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210729105901.35a73431@thinkpad>
In-Reply-To: <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
        <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
        <20210727172828.1529c764@thinkpad>
        <8edcc387025a6212d58fe01865725734@walle.cc>
        <20210727183213.73f34141@thinkpad>
        <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Heiner,

On Wed, 28 Jul 2021 22:43:30 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Did we come to any conclusion?
> 
> My preliminary r8169 implementation now creates the following LED names:
> 
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led0-0300
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led1-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led1-0300
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led2-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led2-0300
> 
> I understood that LEDs should at least be renamed to r8169-0300::link-0
> to link-2 Is this correct? Or do we have to wait with any network LED support
> for a name discussion outcome?

I would expect some of the LEDs to, by default, indicate activity.
So maybe look at the settings BIOS left, and if the setting is to
indicate link, use the "link" function, and if activity, use the
"activity" function? 

> For the different LED modes I defined private hw triggers (using trigger_type
> to make the triggers usable with r8169 LEDs only). The trigger attribute now
> looks like this:
> 
> [none] link_10_100 link_1000 link_10_100_1000 link_ACT link_10_100_ACT link_1000_ACT link_10_100_1000_ACT
>
> Nice, or? Issue is just that these trigger names really should be made a
> standard for all network LEDs. I don't care about the exact naming, important
> is just that trigger names are the same, no matter whether it's about a r8169-
> or igc- or whatever network chip controlled LEDs.

This is how I at first proposed doing this, last year. But this is
WRONG!

First, we do not want a different trigger for each possible
configuration. We want one trigger, and then choose configuration via
other sysfs file. I.e. a "hw" trigger, which, when activated, would
create sysfs files "link" and "act", via which you can configure those
options.

Second, we already have a standard LED trigger for network devices,
netdev! So what we should do is use the netdev trigger, and offload
blinking to the LED controller if it supports it. The problems with
this are:
1. not yet implemented in upstream, see my latest version
   https://lore.kernel.org/linux-leds/20210601005155.27997-1-kabel@kernel.org/
2. netdev trigger currently does not support all these different link
   functions. We have these settings:
     device_name: network interface name, i.e. eth0
     link: 0 - do not indicate link
           1 - indicate link (ON when linked)
     tx: 0 - do not blink on transmit
         1 - blink on transmit
     rx: 0 - do not blink on receive
         1 - blink on receive
     interval: duration of LED blink in ms

I would like to extend netdev trigger to support different
configurations. Currently my ideas are as follows:
- a new sysfs file, "advanced", will show up when netdev trigger is
  enabled (and if support is compiled in)
- when advanced is set to 1, for each possible link mode (10base-t,
  100base-t, 1000base-t, ...) a new sysfs directory will show up, and
  in each of these directories the following files:
    rx, tx, link, interval, brightness
    multi_intensity (if the LED is a multi-color LED)
  and possibly even
    pattern
With this, the user can configure more complicated configurations:
- different LED color for different link speeds
- different blink speed for different link speeds
And if some of the configurations are offloadable to the HW, the drivers
can be written to support such offloading. (Maybe even add a read-only
file "offloaded" to indicate if the trigger was offloaded.)

I will work on these ideas in the following weeks and will sent
proposals to linux-leds.

> And I don't have a good solution for initialization yet. LED mode is whatever
> BIOS sets, but initial trigger value is "none". I would have to read the
> initial LED control register values, iterate over the triggers to find the
> matching one, and call led_trigger_set() to properly set this trigger as
> current trigger.

You can set led_cdev->default_trigger prior registering the LED. But
this is moot: we do not want a different trigger for each PHY interface
mode.

Marek

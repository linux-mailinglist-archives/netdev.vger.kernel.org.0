Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F164449BCD
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhKHSof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhKHSoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 13:44:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A98361506;
        Mon,  8 Nov 2021 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636396909;
        bh=sdeq1n+k7eyb7Na64KF01UO9TaLNhF7oJ20x3QUlUUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gj5VlyPLVNTBk4vPd8looxyYc/xZI594yBBBghDH1i8LpxYzfOsN8lediJBiIw5D6
         udp3kIcqXE8qtLB38s6BWCUozCJz9/IIBxCPIwgJbPpjqF5w0fr3pe5IXw/1ZNfp72
         U0+WjBE3AwrlEjQAZm5lzD4Q+ltCj5MzFHjOxhpkULp0TpsP6lZIVVqVhl6z1oNW32
         tD3m0sm2Q7QIwGZho/UkIsSfF+32+sDt5codZW8MATMakZm5shs44k8OkeitGKHouQ
         ZLPceEq3MtHx4MmsQcPe+Aq7cZbVAcAONjKcPgGP8Ii9STUJNIFmjjvbPziQgkuzVL
         gTO0mzz8dqEWA==
Date:   Mon, 8 Nov 2021 19:41:42 +0100
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
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <20211108194142.58630e60@thinkpad>
In-Reply-To: <YYllTn9W5tZLmVN8@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
        <20211108002500.19115-2-ansuelsmth@gmail.com>
        <YYkuZwQi66slgfTZ@lunn.ch>
        <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
        <20211108171312.0318b960@thinkpad>
        <YYlUSr586WiZxMn6@Ansuel-xps.localdomain>
        <20211108183537.134ee04c@thinkpad>
        <YYllTn9W5tZLmVN8@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 18:58:38 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Are you aware of any device that can have some trigger offloaded and
> still have the led triggered manually?

I don't understand why we would need such a thing.

Look, just to make it clear via an example: I have a device with a
Marvell PHY chip inside. There is a LED connected to one of the PHY LED
pins.

Marvell PHY has LED[0] control register, which supports the following
modes:
  LED is OFF
  LED is ON
  LED is ON when Link is up
  LED blinks on RX activity
  LED blinks on TX activity
  LED blinks on RX/TX activity
  LED is ON and blinks on RX/TX activity
  ...

I have code that exports this LED as a LED classdev

When I activate netdev trigger on this LED, the netdev trigger currently
just blinks the LED in software, by calling the .brightness_set()
method, which configures LED[0] control register to one of the first
two modes above (LED is OFF, LED is ON).

But I have also another patch that adds support to offloading netdev
trigger upon offloadable settings. The netdev trigger code calls the
.trigger_offload() method, which is implemented in PHY driver. This
method checks whether it is a netdev trigger that is to be offloaded,
and whether device_name is the name of the device attached to the PHY,
and then chooses one of the modes above, according to netdev trigger
settings.

So when I request netdev trigger for eth0, to indicate link and blink
on activity, the netdev trigger doesn't do anything in software. It
just calls the offload method ONCE (at the moment I am changing netdev
trigger settings). The blinking is then done by the PHY chip. Netdev
trigger doesn't do anything, at least not until I change the settings
again.

> Talking about mixed mode, so HW and SW.

What exactly do you mean by mixed mode? There is no mixed mode.

> Asking to understand as currently the only way to impement all
> of this in netdev trigger is that:
> IF any hw offload trigger is supported (and enabled) then the entire
> netdev trigger can't work as it won't be able to simulate missing
> trigger in SW. And that would leave some flexibility.

What do you mean by missing trigger here? I think we need to clarify
what we mean by the word "trigger". Are you talking about the various
blinking modes that the PHY supports? If so, please let's call them HW
control modes, and not triggers. By "triggers" I understand triggers
that can be enabled on a LED via /sys/class/leds/<LED>/trigger.

> We need to understand how to operate in this condition. Should netdev
> detect that and ""hide"" the sysfs triggers? Should we report error?

So if I understand you correctly, you are asking about what should we
do if user asked for netdev trigger settings (currently only link, rx,
tx, interval) that can't be offloaded to the PHY chip.

Well, if the PHY allows to manipulate the LEDs ON/OFF state (in other
words "full control by SW", or ability to implement brightness_set()
method), then netdev trigger should blink the LED in SW via this
mechanism (which is something it would do now). A new sysfs file,
"offloaded", can indicate whether the trigger is offloaded to HW or not.

If, on the other hand, the LED cannot be controlled by SW, and it only
support some HW control modes, then there are multiple ways how to
implement what should be done, and we need to discuss this.

For example suppose that the PHY LED pin supports indicating LINK,
blinking on activity, or both, but it doesn't support blinking on rx
only, or tx only.

Since the LED is always indicating something about one network device,
the netdev trigger should be always activated for this LED and it
should be impossible to deactivate it. Also, it should be impossible to
change device_name.

  $ cd /sys/class/leds/<LED>
  $ cat device_name
  eth0
  $ echo eth1 >device_name
  Operation not supported.
  $ echo none >trigger
  Operation not supported.

Now suppose that the driver by default enabled link indication, so we
have:
  $ cat link
  1
  $ cat rx
  0
  $ cat tx
  0

We want to enable blink on activity, but the LED supports only blinking
on both rx/tx activity, rx only or tx only is not supported.

Currently the only way to enable this is to do
  $ echo 1 >rx
  $ echo 1 >tx
but the first call asks for (link=1, rx=1, tx=0), which is impossible.

There are multiple things which can be done:
- "echo 1 >rx" indicates error, but remembers the setting
- "echo 1 >rx" quietly fails, without error indication. Something can
  be written to dmesg about nonsupported mode
- "echo 1 >rx" succeeds, but also sets tx=1
- rx and tx are non-writable, writing always fails. Another sysfs file
  is created, which lists modes that are actually supported, and allows
  to select between them. When a mode is selected, link,rx,tx are
  filled automatically, so that user may read them to know what the LED
  is actually doing
- something different?

Marek

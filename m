Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2304944ECA2
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhKLSdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235122AbhKLSdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 13:33:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBF1E6103A;
        Fri, 12 Nov 2021 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636741853;
        bh=TnsJsZ5u6wSAfEYYk+ohxEusQvP6rbCeRilD0+Tc4ZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GW+Tel5aZWbeuKMUdv+ysaVVKstiw7b1WmjiL1L1R3eazdxj9ejLMnQ/EN3sbaUDm
         SUcTdr2z56OYioReK4I18dm9DIJQndUgYeImwcvE7bgNU57Dmv3HSr+k3LOqvnca/G
         u0EO57/32P7kWgJcHjkDh0ryIjlzK5AOV8osz01XaSJL90FUQdeprwCuKPWUsE9uXD
         XYAFE5VoNp6Km1+a0TGys3fw6nJtycqP1059cOC9HrUrjuwGC3fuLkyV2XDXok5D2d
         5Sp3+WptnLY8cCjRKBL9SD8I2O3XAa0nDCbyCDDkRG0phjZNqNunPWr/EAhDw34mkD
         gsiiUQxVPqjuQ==
Date:   Fri, 12 Nov 2021 19:30:47 +0100
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
Subject: Re: [RFC PATCH v4 0/8] Adds support for PHY LEDs with offload
 triggers
Message-ID: <20211112193047.0e867ed5@thinkpad>
In-Reply-To: <YY6JufxwvXpZp6yT@Ansuel-xps.localdomain>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
        <20211111031608.11267828@thinkpad>
        <YY6JufxwvXpZp6yT@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 16:35:21 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> On Thu, Nov 11, 2021 at 03:16:08AM +0100, Marek Beh=C3=BAn wrote:
> > On Thu, 11 Nov 2021 02:34:52 +0100
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> >  =20
> > > This is another attempt in adding support for PHY LEDs. Most of the
> > > times Switch/PHY have connected multiple LEDs that are controlled by =
HW
> > > based on some rules/event. Currently we lack any support for a generic
> > > way to control the HW part and normally we either never implement the
> > > feature or only add control for brightness or hw blink.
> > >=20
> > > This is based on Marek idea of providing some API to cled but use a
> > > different implementation that in theory should be more generilized.
> > >=20
> > > The current idea is:
> > > - LED driver implement 3 API (hw_control_status/start/stop).
> > >   They are used to put the LED in hardware mode and to configure the
> > >   various trigger.
> > > - We have hardware triggers that are used to expose to userspace the
> > >   supported hardware mode and set the hardware mode on trigger
> > >   activation.
> > > - We can also have triggers that both support hardware and software m=
ode.
> > > - The LED driver will declare each supported hardware blink mode and
> > >   communicate with the trigger all the supported blink modes that will
> > >   be available by sysfs.
> > > - A trigger will use blink_set to configure the blink mode to active
> > >   in hardware mode.
> > > - On hardware trigger activation, only the hardware mode is enabled b=
ut
> > >   the blink modes are not configured. The LED driver should reset any
> > >   link mode active by default.
> > >=20
> > > Each LED driver will have to declare explicit support for the offload
> > > trigger (or return not supported error code) as we the trigger_data t=
hat
> > > the LED driver will elaborate and understand what is referring to (ba=
sed
> > > on the current active trigger).
> > >=20
> > > I posted a user for this new implementation that will benefit from th=
is
> > > and will add a big feature to it. Currently qca8k can have up to 3 LE=
Ds
> > > connected to each PHY port and we have some device that have only one=
 of
> > > them connected and the default configuration won't work for that.
> > >=20
> > > I also posted the netdev trigger expanded with the hardware support.
> > >=20
> > > More polish is required but this is just to understand if I'm taking
> > > the correct path with this implementation hoping we find a correct
> > > implementation and we start working on the ""small details"" =20
> >=20
> > Hello Ansuel,
> >=20
> > besides other things, I am still against the idea of the
> > `hardware-phy-activity` trigger: I think that if the user wants the LED
> > to indicate network device's link status or activity, it should always
> > be done via the existing netdev trigger, and with that trigger only.
> >=20
> > Yes, I know that netdev trigger does not currently support indicating
> > different link modes, only whether the link is up (in any mode). That
> > should be solved by extending the netdev trigger.
> >=20
> > I am going to try to revive my last attempt and send my proposal again.
> > Hope you don't mind.
> >=20
> > Marek =20
>=20
> Honestly... It's a bit sad.
> The netdev trigger have its limitation and I see introducing an
> additional trigger a practical way to correctly support some
> strange/specific PHY.
> I implemented both idea: expand netdev and introduce a dedicated
> trigger and still this is problematic.
> Is having an additional trigger for the specific task that bad?
>=20
> I don't care as long as the feature is implemented but again
> pretty sad how this LEDs proposal went.

Dear Ansuel,

  Is having an additional trigger for the specific task that bad?

No, for a very specific thing it is not bad. By specific I mean
something that an existing trigger does not support and can't support
in a reasonable way. But netdev trigger already supports blinking on rx
and tx, and even setting blinking frequency, and indicating link. And
it can be reasonably extended to support indicating different link
modes and even more complex things. For example what I would like to
see is having support for indicating different links by different
colors with RGB LEDs. I have ideas about how it can be implemented.

But a very specific thing can be implemented by a separate trigger.
For an ethernet PHY chip this can be something like ethernet collision
indication, or Energy Efficient Ethernet indication. But link and
activity should be done via netdev.

Note that we even have an API for such specific triggers that can only
work with some LEDs: the LED private triggers. Look at the member
  struct led_hw_trigger_type *trigger_type;
of struct led_classdev and struct led_trigger.
With this member you can make a trigger to be only visible for some
LEDs, so that when the user does
  cd /sys/class/leds/<LED_WITH_PRIVATE_TRIGGER>
  cat trigger
it will output
  [none] netdev something something ... my-private-trigger
but for other LEDs (all those with different trigger_type) it will omit
the my-private-trigger.

Your hardware-phy trigger should in fact use this private trigger API
so that the user only sees the trigger for the LEDs that actually
support it.

Anyway, Ansuel, if you are willing, we can have a call about this where
I can explain my ideas to you and you to me and we can discuss it more
and maybe come to an understanding? I am not opposed to working on this
together.

Marek

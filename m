Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CF3447D31
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbhKHKDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238529AbhKHKDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 05:03:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817BA61177;
        Mon,  8 Nov 2021 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636365664;
        bh=XUGBCXsXy2u2IR53nZTiHERHgai0JhCJ0AWCFOaHIPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDGhMR0XcunUZTM1phfgnPAOBZJI0tnixSeUbIOH7dLH6laOQ2l+EdQVmEw5YU9V4
         6i3Yb3rZRU4ibvZ2ra4O2HpPD8prk+ouoUDiicGUkeKf/k8Ahh5tbVGDiKE/b1PFsC
         LeuV7ENMYxbE4zddquNv/Ez92rFQvC+T0bbmTqwW9wxa5Qfqm+XrEykL1Bqey9FJ0s
         0IssKk1v4PK+/ffhTNK2qozH8rCrlTFFUAHkRTyLwo+z5QycUOdcs+a/7dTKLEZk0V
         HQX6g2fN8JvzttoXHd3cuX0iVqr9bv4T4nf5unSHtn/ZY+k+C+SbzDhJpkcb5WiQwr
         2ogrfpauvoWRA==
Date:   Mon, 8 Nov 2021 11:00:58 +0100
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
Subject: Re: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
Message-ID: <20211108110058.2f4c1304@thinkpad>
In-Reply-To: <YYhWmUd5FdTYwPvn@Ansuel-xps.localdomain>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
        <20211107175718.9151-5-ansuelsmth@gmail.com>
        <20211107231009.7674734b@thinkpad>
        <YYhWmUd5FdTYwPvn@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Nov 2021 23:43:37 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> On Sun, Nov 07, 2021 at 11:10:09PM +0100, Marek Beh=C3=BAn wrote:
> > On Sun,  7 Nov 2021 18:57:16 +0100
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> >  =20
> > > Add Offload Trigger for PHY Activity. This special trigger is used to
> > > configure and expose the different HW trigger that are provided by the
> > > PHY. Each offload trigger can be configured by sysfs and on trigger
> > > activation the offload mode is enabled.
> > >=20
> > > This currently implement these hw triggers:
> > >   - blink_tx: Blink LED on tx packet receive
> > >   - blink_rx: Blink LED on rx packet receive
> > >   - blink_collision: Blink LED on collision detection
> > >   - link_10m: Keep LED on with 10m link speed
> > >   - link_100m: Keep LED on with 100m link speed
> > >   - link_1000m: Keep LED on with 1000m link speed
> > >   - half_duplex: Keep LED on with half duplex link
> > >   - full_duplex: Keep LED on with full duplex link
> > >   - linkup_over: Keep LED on with link speed and blink on rx/tx traff=
ic
> > >   - power_on_reset: Keep LED on with switch reset
> > >   - blink_2hz: Set blink speed at 2hz for every blink event
> > >   - blink_4hz: Set blink speed at 4hz for every blink event
> > >   - blink_8hz: Set blink speed at 8hz for every blink event
> > >   - blink_auto: Set blink speed at 2hz for 10m link speed,
> > >       4hz for 100m and 8hz for 1000m
> > >=20
> > > The trigger will read the supported offload trigger in the led cdev a=
nd
> > > will expose the offload triggers in sysfs and then activate the offlo=
ad
> > > mode for the led in offload mode has it configured by default. A flag=
 is
> > > passed to configure_offload with the related rule from this trigger to
> > > active or disable.
> > > It's in the led driver interest the detection and knowing how to
> > > elaborate the passed flags.
> > >=20
> > > The different hw triggers are exposed in the led sysfs dir under the
> > > offload-phy-activity subdir. =20
> >=20
> > NAK. The current plan is to use netdev trigger, and if it can
> > transparently offload the settings to HW, it will.
> >=20
> > Yes, netdev trigger currently does not support all these settings.
> > But it supports indicating link and blinking on activity.
> >=20
> > So the plan is to start with offloading the blinking on activity, i.e.
> > I the user does
> >   $ cd /sys/class/leds/<LED>
> >   $ echo netdev >trigger
> >   $ echo 1 >rx
> >   $ echo eth0 >device_name
> >=20
> > this would, instead of doing blinking in software, do it in HW instead.
> >=20
> > After this is implemented, we can start working on extending netdev
> > trigger to support more complicated features.
> >=20
> > Marek =20
>=20
> Using the netdev trigger would cause some problem. Most of the switch
> can run in SW mode (with blink controlled by software of always on) or
> be put in HW mode and they will autonomously control blinking and how
> the LED will operate. So we just need to provide a way to trigger this
> mode and configure it. Why having something that gets triggered and then
> does nothing as it's offloaded?

Nothing gets triggered. In my last proposal, when the netdev trigger
gets activated, it will first try to offload() itself to the LED
controller. If the controller supports offloading, then netdev trigger
won't be blinking the LEDs.

See my last proposal at
https://lore.kernel.org/linux-leds/20210601005155.27997-1-kabel@kernel.org/

> The current way to configure this is very similar... Set the offload
> trigger and use the deidcated subdir to set how the led will
> blink/behave based on the supported trigger reported by the driver.
>=20
> There is no reason to set a device_name as that would be hardcoded to
> the phy (and it should not change... again in HW we can't control that
> part, we can just tell the switch to blink on packet tx on that port)
>=20
> So really the command is:
>   $ cd /sys/class/leds/<LED>
>   $ echo netdev > offload-phy-activity
>   $ cd offload-phy-activity
>   $ echo 1 > tx-blink
>=20
> And the PHY will blink on tx packet.

So there are now 2 different ways to set a LED to blink on tx activity:
the first one is via standard netdev trigger, the second one is this.
That is wrong.

> I understand this should be an extension of netdev as they would do
> similar task but honestly polluting the netdev trigger of if and else to
> disable part of it if an offload mode can be supported seems bad and
> confusionary. At this point introduce a dedicated trigger so an user can
> switch between them. That way we can keep the flexibility of netdev
> trigger that will always work but also permit to support the HW mode
> with no load on the system.

The rationale behind offloading netdev trigger is that it can use
standard, existing sysfs ABI. If the driver finds out that it can
offload the blinking to HW, it will.

This is similar to how other kernel APIs do this.

For example for an ethernet switch, we have DSA. So that we don't need
a specific way to say to the switch which ports it should bridge. All
ports are exported by the switch driver as standard network devices,
and if we bridge them via standard API, the kernel, upon finding out
that the bridging can be offloading to the switch chip, does that.

Marek

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B344B647
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbhKIW0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343968AbhKIWYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 17:24:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA4F619F5;
        Tue,  9 Nov 2021 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496341;
        bh=aBNIXprNNC+WIC99moGG66hzjyuToEOTgU0fEydaa5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SSaVuhyYwXR9tWj8K36jDMkHDl0XMcstS2EZ5ceIXScLDdckZhCbUpH9vwu++tDuz
         VJQoMPsid3P1IAhLBtXMr0csdU+84lsgyDiQn7MBjJQwMRvBTIv74tkMcJs4DAJF32
         FnsA0WBrHIJEz2/zDX2xtHfoVI0OMOy7USpqse3Y+xblDqClzv3BKcHdCgZko30A3B
         48TzSnmlcZ3sNNW2xP97dzSoKZFkeiAD/KnK+7VGIiRx3ugThU0qVpuOj51GKdaQpM
         2xHeNHoF1sh74kdlMfkhBeXhaZIe7RqdU71OGqjq0AInVcLiLv05R8F7T2Qpu5K0Tw
         LFR+Ebpi3qQRQ==
Date:   Tue, 9 Nov 2021 23:18:55 +0100
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
Subject: Re: [RFC PATCH v3 2/8] leds: add function to configure hardware
 controlled LED
Message-ID: <20211109231855.5d43c05e@thinkpad>
In-Reply-To: <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
        <20211109022608.11109-3-ansuelsmth@gmail.com>
        <20211109040103.7b56bf82@thinkpad>
        <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 15:22:53 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> On Tue, Nov 09, 2021 at 04:01:03AM +0100, Marek Beh=C3=BAn wrote:
> > Hello Ansuel,
> >=20
> > On Tue,  9 Nov 2021 03:26:02 +0100
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> >  =20
> > > Add hw_control_configure helper to configure how the LED should work =
in
> > > hardware mode. The function require to support the particular trigger=
 and
> > > will use the passed flag to elaborate the data and apply the
> > > correct configuration. This function will then be used by the trigger=
 to
> > > request and update hardware configuration.
> > >=20
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > >  Documentation/leds/leds-class.rst | 25 ++++++++++++++++++++
> > >  include/linux/leds.h              | 39 +++++++++++++++++++++++++++++=
++
> > >  2 files changed, 64 insertions(+)
> > >=20
> > > diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/l=
eds-class.rst
> > > index 645940b78d81..efd2f68c46a7 100644
> > > --- a/Documentation/leds/leds-class.rst
> > > +++ b/Documentation/leds/leds-class.rst
> > > @@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_s=
tatus/start/stop is optional
> > >  and any software only trigger will reject activation as the LED supp=
orts only
> > >  hardware mode.
> > > =20
> > > +A trigger once he declared support for hardware controlled blinks, w=
ill use the function
> > > +hw_control_configure() provided by the driver to check support for a=
 particular blink mode.
> > > +This function passes as the first argument (flag) a u32 flag.
> > > +The second argument (cmd) of hw_control_configure() method can be us=
ed to do various
> > > +operations for the specific blink mode. We currently support ENABLE,=
 DISABLE, READ, ZERO
> > > +and SUPPORTED to enable, disable, read the state of the blink mode, =
ask the LED
> > > +driver if it does supports the specific blink mode and to reset any =
blink mode active.
> > > +
> > > +In ENABLE/DISABLE hw_control_configure() should configure the LED to=
 enable/disable the
> > > +requested blink mode (flag).
> > > +In READ hw_control_configure() should return 0 or 1 based on the sta=
tus of the requested
> > > +blink mode (flag).
> > > +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED =
driver supports the
> > > +requested blink mode (flags) or not.
> > > +In ZERO hw_control_configure() should return 0 with success operatio=
n or error.
> > > +
> > > +The unsigned long flag is specific to the trigger and change across =
them. It's in the LED
> > > +driver interest know how to elaborate this flag and to declare suppo=
rt for a
> > > +particular trigger. For this exact reason explicit support for the s=
pecific
> > > +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to e=
nter offload mode
> > > +with a not supported trigger.
> > > +If the driver returns -EOPNOTSUPP on hw_control_configure(), the tri=
gger activation will
> > > +fail as the driver doesn't support that specific offload trigger or =
doesn't know
> > > +how to handle the provided flags.
> > > +
> > >  Known Issues
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > =20
> > > diff --git a/include/linux/leds.h b/include/linux/leds.h
> > > index cf0c6005c297..00bc4d6ed7ca 100644
> > > --- a/include/linux/leds.h
> > > +++ b/include/linux/leds.h
> > > @@ -73,6 +73,16 @@ enum led_blink_modes {
> > >  	SOFTWARE_HARDWARE_CONTROLLED,
> > >  };
> > > =20
> > > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > > +enum blink_mode_cmd {
> > > +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> > > +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> > > +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> > > +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode =
is supported */
> > > +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> > > +};
> > > +#endif =20
> >=20
> > this is a strange proposal for the API.
> >=20
> > Anyway, led_classdev already has the blink_set() method, which is docum=
ented as
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
> >=20
> > So we already have a method to set hardware blkinking, we don't need
> > another one.
> >=20
> > Marek =20
>=20
> But that is about hardware blink, not a LED controlled by hardware based
> on some rules/modes.
> Doesn't really match the use for the hardware control.

I think there is a miscommunication, because I don't quite understand
what you are trying to say here.

How is "hardware blink" different from "a LED controlled by hardware
based on some rules/modes", when it is used for blinking ?

If the hardware, any hardware, supports blinking with different
frequencies, it should implement the blink_set() method.

> Blink_set makes the LED blink contantly at the declared delay.
> The blink_mode_cmd are used to request stuff to a LED in hardware mode.
>=20
> Doesn't seem correct to change/enhance the blink_set function with
> something that would do something completely different.
>=20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6697E3E7E24
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhHJRWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:22:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53520 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHJRWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:22:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DFB031C0B76; Tue, 10 Aug 2021 19:22:27 +0200 (CEST)
Date:   Tue, 10 Aug 2021 19:22:27 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Documentation for naming LEDs was Re: [PATCH net-next 5/5] igc:
 Export LEDs
Message-ID: <20210810172226.GA3302@amd>
References: <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad>
 <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
 <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
 <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
 <20210727020619.2ba78163@thinkpad>
 <YP9n+VKcRDIvypes@lunn.ch>
 <20210727155510.256e5fcc@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20210727155510.256e5fcc@thinkpad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The last time we discussed this (Andrew, Pavel and I), we've decided
> > > that for ethernet PHY controlled LEDs we want the devicename part
> > > should be something like
> > >    phyN  or  ethphyN  or  ethernet-phyN
> > > with N a number unique for every PHY (a simple atomically increased
> > > integer for every ethernet PHY). =20
> >=20
> > We might want to rethink this. PHYs typically have 2 or 3 LEDs. So we
> > want a way to indicate which LED of a PHY it is. So i suspect we will
> > want something like
> >=20
> > ethphyN-led0, ethphyN-led1, ethphyN-led2.
>=20
> But... there is still color and function and possibly function-numerator
> to differentiate them. I was talking only about the devicename part. So
> for three LEDs you can have, for example:
>   ethphyN:green:link
>   ethphyN:yellow:activity

For the record, this is the solution I'd like to see. Plus, we do want
it consistent between drivers, and I believe we need more than
list of functions provided by dt-bindings/leds/common.h -- we want
people to set something reasonable for "device" part, too.

Thus, I'm proposing this:

Rules will be simple -- when new type of LED is added to the
system, it will need to come with documentation explaining what the
LED does, and people will be expected to use existing names when
possible.

We'll also want to list "known bad" names in the file, so that there's
central place to search for aliases.

Thoughts?

Best regards,
								Pavel

--- /dev/null	2021-08-08 09:30:15.272028621 +0200
+++ Documentation/leds/well-known-leds.txt	2021-07-03 14:33:45.573718655 +0=
200
@@ -0,0 +1,57 @@
+-*- org -*-
+
+It is somehow important to provide consistent interface to the
+userland. LED devices have one problem there, and that is naming of
+directories in /sys/class/leds. It would be nice if userland would
+just know right "name" for given LED function, but situation got more
+complex.
+
+Anyway, if backwards compatibility is not an issue, new code should
+use one of the "good" names from this list, and you should extend the
+list where applicable.
+
+Bad names are listed, too; in case you are writing application that
+wants to use particular feature, you should probe for good name, first,
+but then try the bad ones, too.
+
+* Keyboards
+ =20
+Good: "input*:*:capslock"
+Good: "input*:*:scrolllock"
+Good: "input*:*:numlock"
+Bad: "shift-key-light" (Motorola Droid 4, capslock)
+
+Set of common keyboard LEDs, going back to PC AT or so.
+
+Good: "platform::kbd_backlight"
+Bad: "tpacpi::thinklight" (IBM/Lenovo Thinkpads)
+Bad: "lp5523:kb{1,2,3,4,5,6}" (Nokia N900)
+
+Frontlight/backlight of main keyboard.
+
+Bad: "button-backlight" (Motorola Droid 4)
+
+Some phones have touch buttons below screen; it is different from main
+keyboard. And this is their backlight.
+
+* Sound subsystem
+
+Good: "platform:*:mute"
+Good: "platform:*:micmute"
+
+LEDs on notebook body, indicating that sound input / output is muted.
+
+* System notification
+
+Good: "status-led:{red,green,blue}" (Motorola Droid 4)
+Bad: "lp5523:{r,g,b}" (Nokia N900)
+
+Phones usually have multi-color status LED.
+
+* Power management
+
+Good: "platform:*:charging" (allwinner sun50i)
+
+* Screen
+
+Good: ":backlight" (Motorola Droid 4)


--=20
http://www.livejournal.com/~pavelmachek

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEStdIACgkQMOfwapXb+vIxvACgituSqfgPGhtjS25oNe/OaExj
nVUAmwVmZrwnmknkrm6YNF/zBtOMYVTi
=dL8A
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--

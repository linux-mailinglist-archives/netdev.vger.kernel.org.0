Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9442622AF9F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgGWMlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 08:41:03 -0400
Received: from lists.nic.cz ([217.31.204.67]:38004 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgGWMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 08:41:02 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id C20B1140527;
        Thu, 23 Jul 2020 14:41:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595508060; bh=/+hTSYLOnYliKcpz5jfbvtVHUzu6SymPaYyGoAc0gf4=;
        h=Date:From:To;
        b=b7xpT4uGeBJYUcxDiWPuTtFTzAChjrHi5ywymGSAxu0mKOWH4bAkzNy7w16+nq7Zh
         ALZ19TJhgaN380bFX4/udJfHbINQSAJBPWhjwhEBq2KBwbMnBrlymuswbjLFsMng6C
         wdFHxKKdTLMxvWZBJI8flGootV5lWEjB6DSQyJOU=
Date:   Thu, 23 Jul 2020 14:41:00 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond?= =?UTF-8?Q?=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next 0/3] Add support for LEDs on Marvell
 PHYs
Message-ID: <20200723144100.647afbb4@dellmb.labs.office.nic.cz>
In-Reply-To: <20200716185647.GA1308244@lunn.ch>
References: <20200716171730.13227-1-marek.behun@nic.cz>
        <20200716185647.GA1308244@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 20:56:47 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Jul 16, 2020 at 07:17:27PM +0200, Marek Beh=FAn wrote:
> > Hello,
> >=20
> > this RFC series should apply on both net-next/master and Pavel's
> > linux-leds/for-master tree.
> >=20
> > This adds support for LED's connected to some Marvell PHYs.
> >=20
> > LEDs are specified via device-tree. Example: =20
>=20
> Hi Marek
>=20
> I've been playing with something similar, off and on, mostly off.
>=20
> Take a look at
>=20
> https://github.com/lunn/linux v5.4-rc6-hw-led-triggers
>=20
> The binding i have is pretty much the same, since we are both
> following the common LED binding. I see no problems with this.
>=20
> > This is achieved by extending the LED trigger API with LED-private
> > triggers. The proposal for this is based on work by Ondrej and
> > Pavel. =20
>=20
> So what i did here was allow triggers to be registered against a
> specific LED. The /sys/class/leds/<LED>/trigger lists both the generic
> triggers and the triggers for this specific LED. Phylib can then
> register a trigger for each blink reason that specific LED can
> perform. Which does result in a lot of triggers. Especially when you
> start talking about a 10 port switch each with 2 LEDs.
>=20
> I still have some open issues...
>

Hi Andrew,

Pavel Machek has applied support for LED private triggers yesterday,
see
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/commit=
/?h=3Dfor-next&id=3D93690cdf3060c61dfce813121d0bfc055e7fa30d

The way this is handled has this issue - it results in a lot of
triggers, if we want each possible control to have its own trigger in
the sysfs trigger file. But as Ondrej pointed out, we can just register
one "hw-control" device trigger, and have its activation create another
file/files via which the user can select which type of HW control he
wants to activate. Something similar is done in netdev trigger.

I don't like it much, but this is what can be done if we want to
avoid having lots of triggers registered.

> 1) Polarity. It would be nice to be able to configure the polarity of
> the LED in the bindings.

Yes, and also the DUAL mode and everything else.

> 2) PHY LEDs which are not actually part of the PHY. Most of the
> Marvell Ethernet switches have inbuilt PHYs, which are driven by the
> Marvell PHY driver. The Marvell PHY driver has no idea the PHY is
> inside a switch, it is just a PHY.  However, the LEDs are not
> controlled via PHY registers, but Switch registers. So the switch
> driver is going to end up controlling these LEDs. It would be good to
> be able to share as much code as possible, keep the naming consistent,
> and keep the user API the same.

I know about this - in fact I want this solved for Turris MOX, which
has one 1518 PHY and can have up to three switches connected - I want
every LED to be configurable by userspace.

The internal PHY of the switch can be identified in the marvell phy
driver not to register any LEDs. Then the switch LEDs can be controlled
by the switch driver. I don't think we are able to share much of the
code, since the access to these registers is different from the LED
registers in the PHY, and register values are also different. The only
think which could be shared are names of the trigger, I think. But I
will look into this and prepare a patch series that will share as much
code as is reasonable.

> 3) Some PHYs cannot control the LEDs independently. Or they have modes
> which configure two or more LEDs. The Marvell PHYs are like
> this. There are something like ~10 blink modes which are
> independent. And then there are 4 modes which control multiple LEDs.
> There is no simple way to support this with Linux LEDs which assume
> the LEDs are fully independent. I suspect we simply cannot support
> these combined modes.

I know about these modes, I have func specs for several differnet
Marvell PHYs and switches opened and have read about the LED systems.
I intend to do this so that all corner cases are considere.

> As a PHY maintainer, i would like to see a solution which makes use of
> Linux LEDs. I don't really care who's code it is, and feel free to
> borrow my code, or ideas, or ignore it.
>=20
>       Andrew

Wait a few days and I shall send another proposal.

Marek

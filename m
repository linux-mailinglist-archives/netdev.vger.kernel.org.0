Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A54022C62E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXNSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:18:15 -0400
Received: from lists.nic.cz ([217.31.204.67]:53008 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgGXNSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:18:15 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 652B11409C6;
        Fri, 24 Jul 2020 15:18:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595596693; bh=FXLBwI943Zogfi1PcdT70A/ip4Rj0lpCR1CpsVo5qq0=;
        h=Date:From:To;
        b=FVPTQE9Dxx4THp/tl+1Yt14Tpfj33iMP6a4zAWmEfqgZqQ5/0rZYa0w+lAnXU4UxL
         tZ61dxJZoxBxhGX7e6pQxT7U5hIYFTtAobg2ahQBmuIZEqZW7J0uv9KEQPc5AW9bjb
         oC3ukslRt89OfSQvxv9KuK95m4WsYCPVr9Qz2xvE=
Date:   Fri, 24 Jul 2020 15:18:13 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 0/1] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200724151813.709f2a4e@dellmb.labs.office.nic.cz>
In-Reply-To: <20200724151233.35d799e8@dellmb.labs.office.nic.cz>
References: <20200723181319.15988-1-marek.behun@nic.cz>
        <20200724102901.qp65rtkxucauglsp@duo.ucw.cz>
        <20200724151233.35d799e8@dellmb.labs.office.nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Fri, 24 Jul 2020 15:12:33 +0200
Marek Beh=C3=BAn <marek.behun@nic.cz> wrote:

> On Fri, 24 Jul 2020 12:29:01 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > In future, would you expect having software "1000/100/10/nolink"
> > triggers I could activate on my scrollock LED (or on GPIO controlled
> > LEDs) to indicate network activity? =20
>=20
> Look at drivers/net/phy/phy_led_triggers.c, something like that could
> be actually implemented there.
>=20
> Some of the modes are useful, like the "1000/100/10/nolink". But some
> of them are pretty weird, and I don't think anyone actually uses it
> ("1000-10/else", which is on if the device is linked at 1000mbps ar
> 10mbps, and else off? who would sacrifies a LED for this?).
>=20
> I actually wanted to talk about the phy_led_triggers.c code. It
> registers several trigger for each PHY, with the name in form:
>   phy-device-name:mode
> where
>   phy-device-name is derived from OF
>     - sometimes it is in the form
>       d0032004.mdio-mii:01
>     - but sometimes in the form of whole OF path followed by ":" and
>       the PHY address:
>       /soc/internal-regs@d0000000/mdio@32004/switch0@10/mdio:08
>   mode is "link", "1Gbps", "100Mbps", "10Mbps" and so on"
>=20
> So I have a GPIO LED, and I can set it to sw trigger so that it is on
> when a specific PHY is linked on 1Gbps.
>=20
> The problem is that on Turris Mox I can connect up to three 8-port
> switches, which yields in 25 network PHYs overall. So reading the
> trigger file results in 4290 bytes (look at attachment
> cat_trigger.txt). I think the phy_led_triggers should have gone this
> way of having just one trigger (like netdev has), and specifying phy
> device via and mode via another file.
>=20
> Marek
>=20

In fact I think the way the phy_led_triggers does this should be
deprecated. I new kernel config options should be create, something
like "new user API for PHY LED trigger", which would create just one
trigger, with name phydev, like we have netdev, and like in the netdev
trigger, the mode and device should be configured via other files.

This phydev trigger could then be made similar to phy-hw-mode trigger...

Marek

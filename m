Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DB126487E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgIJOzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731045AbgIJOwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:52:36 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC98C061798;
        Thu, 10 Sep 2020 07:15:31 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 32BF6140A8A;
        Thu, 10 Sep 2020 16:15:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599747323; bh=C7UrCrhRiGcdCqsTPmns+j9GLYW13piz0xUvPMA6PBs=;
        h=Date:From:To;
        b=gDP7XiOVXWsrQyikAPAArPyD3uFTj8c+NJO+sWGPMh+hYBCapEYM4sqXHgJ+noWfp
         jBk1eBCn50nK1Fu5IX0MFAjZrJtuLnM+Ksx39PLzYVAUL+1QsoHbAqlzb+gknn8lXB
         y+hS0d7xRGxncS1zJ71nDGKr5NwIVMjtPog0orkc=
Date:   Thu, 10 Sep 2020 16:15:22 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond?= =?UTF-8?Q?=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
In-Reply-To: <20200910131541.GD3316362@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-7-marek.behun@nic.cz>
        <20200910122341.GC7907@duo.ucw.cz>
        <20200910131541.GD3316362@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 15:15:41 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Sep 10, 2020 at 02:23:41PM +0200, Pavel Machek wrote:
> > On Wed 2020-09-09 18:25:51, Marek Beh=FAn wrote: =20
> > > This patch adds support for controlling the LEDs connected to
> > > several families of Marvell PHYs via the PHY HW LED trigger API.
> > > These families are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510
> > > and 88E1545. More can be added.
> > >=20
> > > This patch does not yet add support for compound LED modes. This
> > > could be achieved via the LED multicolor framework.
> > >=20
> > > Settings such as HW blink rate or pulse stretch duration are not
> > > yet supported.
> > >=20
> > > Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz> =20
> >=20
> > I suggest limiting to "useful" hardware modes, and documenting what
> > those modes do somewhere. =20
>=20
> I think to keep the YAML DT verification happy, they will need to be
> listed in the marvell PHY binding documentation.
>=20
>        Andrew

Okay, so the netdev trigger offers modes `link`, `rx`, `tx`.
You can enable/disable either of these (via separate sysfs files). `rx`
and `tx` blink the LED, `link` turns the LED on if the interface is
linked.

The phy_led_trigger subsystem works differently. Instead of registering
one trigger (like netdev) it registers one trigger per PHY device and
per speed. So for a PHY with name XYZ and supported speeds 1Gbps,
100Mbps, 10Mbps it registers 3 triggers:
  XYZ:1Gbps XYZ:100Mbps XYZ:10Mbps

This is especially bad on a system where there are many PHYs and they
have long names derived from device tree path.

I propose that at least these HW modes should be available (and
documented) for ethernet PHY controlled LEDs:
  mode to determine link on:
    - `link`
  mode for activity (these should blink):
    - `activity` (both rx and tx), `rx`, `tx`
  mode for link (on) and activity (blink)
    - `link/activity`, maybe `link/rx` and `link/tx`
  mode for every supported speed:
    - `1Gbps`, `100Mbps`, `10Mbps`, ...
  mode for every supported cable type:
    - `copper`, `fiber`, ... (are there others?)
  mode that allows the user to determine link speed
    - `speed` (or maybe `linkspeed` ?)
    - on some Marvell PHYs the speed can be determined by how fast
      the LED is blinking (ie. 1Gbps blinks with default blinking
      frequency, 100Mbps with half blinking frequeny of 1Gbps, 10Mbps
      of half blinking frequency of 100Mbps)
    - on other Marvell PHYs this is instead:
      1Gpbs blinks 3 times, pause, 3 times, pause, ...
      100Mpbs blinks 2 times, pause, 2 times, pause, ...
      10Mpbs blinks 1 time, pause, 1 time, pause, ...
    - we don't need to differentiate these modes with different names,
      because the important thing is just that this mode allows the
      user to determine the speed from how the LED blinks
  mode to just force blinking
    - `blink`
The nice thing is that all this can be documented and done in software
as well.

Moreover I propose (and am willing to do) this:
  Rewrite phy_led_trigger so that it registers one trigger, `phydev`.
  The identifier of the PHY which should be source of the trigger can be
  set via a separate sysfs file, `device_name`, like in netdev trigger.
  The linked speed on which the trigger should light the LED will be
  selected via sysfs file `mode` (or do you propose another name?
  `trigger_on` or something?)

  Example:
    # cd /sys/class/leds/<LED>
    # echo phydev >trigger
    # echo XYZ >device_name
    # cat mode
    1Gbps 100Mbps 10Mbps
    # echo 1Gbps >mode
    # cat mode
    [1Gbps] 100Mbps 10Mbps

  Also the code should be moved from driver/net/phy to
  drivers/leds/trigger.

  The old API can be declared deprecated or removed, but outright
  removal may cause some people to complain.

What do you think?

Marek

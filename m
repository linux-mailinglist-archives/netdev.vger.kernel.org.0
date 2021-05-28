Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285E63943A7
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhE1N7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhE1N7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 09:59:22 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A86FC061574;
        Fri, 28 May 2021 06:57:47 -0700 (PDT)
Received: from dellmb (unknown [IPv6:2001:1488:fffe:6:be02:5020:4be2:aff5])
        by mail.nic.cz (Postfix) with ESMTPSA id 95FDD13FEDF;
        Fri, 28 May 2021 15:57:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1622210264; bh=L2FRXixBLrTSjAd1ej19FFbRqmd2SpyVByQqODr4n1M=;
        h=Date:From:To;
        b=ExhtO9m0hYb9kEBgPhNQfGJ1WqAXR4CM6218iQxsgjgMlD/Fl/r5f5/J8VwxRXS6n
         GFmC2ItsMh44dKRNgtV6o1w9puc2yvqb+8Vp1x58m5A79JC/KHiwdMs9zg5RcB4pY/
         FvJB/cWDwNE8AiXevYDLMKCWpT7/95QADpMViIY0=
Date:   Fri, 28 May 2021 15:57:44 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 4/5] leds: trigger: netdev: support HW
 offloading
Message-ID: <20210528155744.6a555f6e@dellmb>
In-Reply-To: <YLD1ELr5csaat6Uk@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
        <20210526180020.13557-5-kabel@kernel.org>
        <YK/PbY/a0plxvzh+@lunn.ch>
        <20210528084556.69bbba1a@dellmb>
        <YLD1ELr5csaat6Uk@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 15:50:08 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, May 28, 2021 at 08:45:56AM +0200, Marek Beh=C3=BAn wrote:
> > On Thu, 27 May 2021 18:57:17 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Wed, May 26, 2021 at 08:00:19PM +0200, Marek Beh=C3=BAn wrote: =20
> > > > Add support for HW offloading of the netdev trigger.
> > > >=20
> > > > We need to export the netdev_led_trigger variable so that
> > > > drivers may check whether the LED is set to this trigger.   =20
> > >=20
> > > Without seeing the driver side, it is not obvious to me why this
> > > is needed. Please add the driver changes to this patchset, so we
> > > can fully see how the API works. =20
> >=20
> > OK, I will send an implementation for leds-turris-omnia with v2.
> >=20
> > The idea is that the trigger_offload() method should check which
> > trigger it should offload. A potential LED controller may be
> > configured to link the LED on net activity, or on SATA activity. So
> > the method should do something like this:
> >=20
> >   static int my_trigger_offload(struct led_classdev *cdev, bool
> > enable) {
> >     if (!enable)
> >       return my_disable_hw_triggering(cdev);
> > =09
> >     if (cdev->trigger =3D=3D &netdev_led_trigger)
> >       return my_offload_netdev_triggering(cdev);
> >     else if (cdev->trigger =3D=3D &blkdev_led_trigger)
> >       return my_offload_blkdev_triggering(cdev);
> >     else
> >       return -EOPNOTSUPP;
> >   } =20
>=20
> So the hardware driver does not need the contents of the trigger? It
> never manipulates the trigger. Maybe to keep the abstraction cleaner,
> an enum can be added to the trigger to identify it. The code then
> becomes:
>=20
> static int my_trigger_offload(struct led_classdev *cdev, bool enable)
> {
> 	if (!enable)
>         	return my_disable_hw_triggering(cdev);
>  =09
> 	switch(cdev->trigger->trigger) {
> 	case TRIGGER_NETDEV:
> 	       return my_offload_netdev_triggering(cdev);
> 	case TRIGGER_BLKDEV:
> 	       return my_offload_blkdev_triggering(cdev);
> 	default:
> 	       return -EOPNOTSUPP;
> }=09

If we want to avoid exporting the symbol I would rather compare
  !strcmp(cdev->trigger->name, "netdev")
What do you think?

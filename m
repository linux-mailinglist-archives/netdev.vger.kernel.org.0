Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84D4203BD
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhJCT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231280AbhJCT2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 15:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 779A26113E;
        Sun,  3 Oct 2021 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633289219;
        bh=xT1kBNgVseYDpuIPi5OSd2BvxN7N+C4ybBmVSDmqbkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZFKPpkB9z5vxwWZwjePFLih316yP1HgZIuOANjShMByhj5Z1HbWQr7PMFHpgihbY7
         BwQjqopfa1f3UEH0y2An/6BwWaJR2RCIFTEkS0GJpfNKBfZ7vu1Y37hxAa8/cAn0MR
         FVsSQmGGvdeb0BXIzOqKtlSJUYTcV8Bl8D09e3bx50qzye/T8bHYSf2aazg9TP2LfD
         0TPKslFYPAsZTdRLHKN5AGVbrxKSoWAqJtZ3TIyRXaZXw08xeELDAxlWV4We37lkiQ
         n+Seiekuu51pgRpZH+tNjshcx8r/oRPo3+km73qvzXjVVMZZc/Uqh6BvRGoCiggth/
         1aXl4I2xeXJog==
Date:   Sun, 3 Oct 2021 21:26:54 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211003212654.30fa43f5@thinkpad>
In-Reply-To: <YVn815h7JBtVSfwZ@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 Oct 2021 20:56:23 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Oct 01, 2021 at 02:36:01PM +0200, Marek Beh=C3=BAn wrote:
> > Hello Pavel, Jacek, Rob and others,
> >=20
> > I'd like to settle DT binding for the LED function property regarding
> > the netdev LED trigger.
> >=20
> > Currently we have, in include/dt-bindings/leds/common.h, the following
> > functions defined that could be interpreted as request to enable netdev
> > trigger on given LEDs:
> >   activity
> >   lan
> >   rx tx
> >   wan
> >   wlan
> >=20
> > The "activity" function was originally meant to imply the CPU
> > activity trigger, while "rx" and "tx" are AFAIK meant as UART indicators
> > (tty LED trigger), see
> > https://lore.kernel.org/linux-leds/20190609190803.14815-27-jacek.anasze=
wski@gmail.com/
> >=20
> > The netdev trigger supports different settings:
> > - indicate link
> > - blink on rx, blink on tx, blink on both
> >=20
> > The current scheme does not allow for implying these.
> >=20
> > I therefore propose that when a LED has a network device handle in the
> > trigger-sources property, the "rx", "tx" and "activity" functions
> > should also imply netdev trigger (with the corresponding setting).
> > A "link" function should be added, also implying netdev trigger.
> >=20
> > What about if a LED is meant by the device vendor to indicate both link
> > (on) and activity (blink)?
> > The function property is currently a string. This could be changed to
> > array of strings, and then we can have
> >   function =3D "link", "activity";
> > Since the function property is also used for composing LED classdev
> > names, I think only the first member should be used for that.
> >=20
> > This would allow for ethernet LEDs with names
> >   ethphy-0:green:link
> >   ethphy-0:yellow:activity
> > to be controlled by netdev trigger in a specific setting without the
> > need to set the trigger in /sys/class/leds. =20
>=20
> Hi Marek
>=20
> There is no real standardization here. Which means PHYs differ a lot
> in what they can do. We need to strike a balance between over
> simplifying and only supporting a very small set of PHY LED features,
> and allowing great flexibility and having each PHY implement its own
> specific features and having little in common.
>=20
> I think your current proposal is currently on the too simple side.
>=20
> One common feature is that there are multiple modes for indicating
> link, which take into account the link speed. Look at for example
> include/dt-bindings/net/microchip-lan78xx.h
>=20
> #define LAN78XX_LINK_ACTIVITY           0
> #define LAN78XX_LINK_1000_ACTIVITY      1
> #define LAN78XX_LINK_100_ACTIVITY       2
> #define LAN78XX_LINK_10_ACTIVITY        3
> #define LAN78XX_LINK_100_1000_ACTIVITY  4
> #define LAN78XX_LINK_10_1000_ACTIVITY   5
> #define LAN78XX_LINK_10_100_ACTIVITY    6
>=20
> And:
>=20
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10	0x0010
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK100	0x0020
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10X	0x0030
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK1000	0x0040
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10_0	0x0050
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK100X	0x0060
> intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10XX	0x0070
>=20
> Marvell PHYs have similar LINK modes which can either be one specific
> speed, or a combination of speeds.
>=20
> This is a common enough feature, and a frequently used feature, we
> need to support it. We also need to forward looking. We should not
> limit ourselves to 10/100/1G. We have 3 PHY drivers which support
> 2.5G, 5G and 10G. 25G and 40G are standardized so are likely to come
> along at some point.
>=20
> One way we could support this is:
>=20
> function =3D "link100", "link1G", "activity";
>=20
> for LAN78XX_LINK_100_1000_ACTIVITY, etc.
>=20
>     Andrew

Hello Andrew,

I am aware of this, and in fact am working on a proposal for an
extension of netdev LED extension, to support the different link
modes. (And also to support for multi-color LEDs.)

But I am not entirely sure whether these different link modes should be
also definable via device-tree. Are there devices with ethernet LEDs
dedicated for a specific speed? (i.e. the manufacturer says in the
documentation of the device, or perhaps on the device's case, that this
LED shows 100M/1000M link, and that other LED is shows 10M link?)
If so, that this should be specified in the devicetree, IMO. But are
such devices common?

And what about multi-color LEDs? There are ethernet ports where one LED
is red-green, and so can generate red, green, and yellow color. Should
device tree also define which color indicates which mode?

Marek

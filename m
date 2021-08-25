Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A433F783B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbhHYP1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240741AbhHYP1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 11:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E2E61052;
        Wed, 25 Aug 2021 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629905180;
        bh=sTxwrPsGsJErgKqE0ljBSfzQNjKMYgAnyDG+b7Oc4c4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AAfTbxTRyg1uJXamrEu8JFGe6inO1d1UFzuD6Vp1WvHS4yr5c8vGTvcy4/6Ozha9B
         mZWPH5BsZi5KjsFTMYNWW3sjUP4EZvhmZSn64F+uMOtmg1C2EiEgHIkRbg2vIRpqZV
         ntXMx1LWKCeaxEL52veZyTXngkmammNkYmw367iz3SZ9OLY0Y+w8pKY52P0Kcf9pTf
         GqzV1acbE8ebrrgT4UNRnJYvLZNrgE6Qx3M2a/tgfCC9N54Fmy5FwqTO8NHtNokOV7
         AeVnE/Jwsao724aoHVJtndWY3V9JAe1e7bIQptyYOXVS71XW5mkD6L+M5Sd+weB91W
         FBo4hlqoJITQw==
Date:   Wed, 25 Aug 2021 17:26:13 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>, andrew@lunn.ch
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>, anthony.l.nguyen@intel.com,
        bigeasy@linutronix.de, davem@davemloft.net,
        dvorax.fuxbrumer@linux.intel.com, f.fainelli@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210825172613.71b62113@dellmb>
In-Reply-To: <20210817190241.GA15389@amd>
References: <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
        <20210727172828.1529c764@thinkpad>
        <8edcc387025a6212d58fe01865725734@walle.cc>
        <20210727183213.73f34141@thinkpad>
        <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
        <20210810172927.GB3302@amd>
        <20210810195550.261189b3@thinkpad>
        <20210810195335.GA7659@duo.ucw.cz>
        <20210810225353.6a19f772@thinkpad>
        <20210817190241.GA15389@amd>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 21:02:42 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Tue 2021-08-10 22:53:53, Marek Beh=C3=BAn wrote:
> > On Tue, 10 Aug 2021 21:53:35 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> >  =20
> > > > Pavel, one point of the discussion is that in this case the LED
> > > > is controlled by MAC, not PHY. So the question is whether we
> > > > want to do "ethmacN" (in addition to "ethphyN").   =20
> > >=20
> > > Sorry, I missed that. I guess that yes, ethmacX is okay, too.
> > >=20
> > > Even better would be to find common term that could be used for
> > > both ethmacN and ethphyN and just use that. (Except that we want
> > > to avoid ethX). Maybe "ethportX" would be suitable? =20
> >=20
> > See
> >   https://lore.kernel.org/linux-leds/YQAlPrF2uu3Gr+0d@lunn.ch/
> > and
> >   https://lore.kernel.org/linux-leds/20210727172828.1529c764@thinkpad/
> > =20
>=20
> Ok, I guess I'd preffer all LEDs corresponding to one port to be
> grouped, but that may be hard to do.

Hi Pavel (and Andrew),

The thing is that normally we are creating LED classdevs when the
parent device is probed. In this case when the PHY is probed. But we
will know the corresponding MAC only once the PHY is attached to it's
network interface.

Also, a PHY may be theoretically attached to multiple different
interfaces during it's lifetime. I guess there isn't many boards
currently that have such a configuration wired (maybe none), but
kernel's API is prepared for this.

So we really can't group them under one parent device, unless:

- we create LED classdevs only after PHY is attached (which will make
  us unable to blink the LEDs when the PHY is not attached yet) and
  destroy them when PHY is detached. I find this solution wrong - the
  LEDs will be unavailable for example if the MAC driver fails to probe
  for some reason

- or we add a mechanism to reprobe LEDs upon request (which also seems
  a rather unsatisfactory solution to me...)

- maybe some other solution?

Marek

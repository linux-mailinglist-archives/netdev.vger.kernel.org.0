Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019493CF67A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhGTIRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:17:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39340 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbhGTIOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:14:49 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626771266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3U1eLxN82r4wxpbS8BeoAr7P8TGvhUuY+6aJL7cWBY4=;
        b=kNymBcmJIYRArPZlo+G6CeCC4BBji48XYaVmNer8cjer5jnrjsT7/K0KZwVTFhQP0pYBrA
        G8GCcaPmDf4vF4ZjP0mW19bwJ3Uv85xezJZjpLqheaLs/fE1tNWE13tOmfav5qK8PkOdYm
        7W1xWEUGz5M9lYiwj5rgBAZZ5wRA8Rtc0NgzkXSA5hWLonfl9a64lMXyhikT9ReUyvYsHT
        hvPIZHUSNWLXkADZSw2o3Ztl6mXRt1xfQ5A/t/l5UmyXqn1dd6LP9g0//QZ8dxBk1XQym6
        ZzmHGKVJYbQGB+rqPsgyDSuh2Q8dXGdTwTKplH/XpwaYOM2l2n6e7tgUoEkMIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626771266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3U1eLxN82r4wxpbS8BeoAr7P8TGvhUuY+6aJL7cWBY4=;
        b=9hmDKwnRrDz5FR11Fpi4fex2R404ETTzmC65Mey3yLAbJuJ0On/HCKffdAFYHTrulwdztG
        hdsqdCzSHamAHmBg==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <YPV6+PQq1fvH8aSy@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch> <87y2a2hm6m.fsf@kurt>
 <YPV6+PQq1fvH8aSy@lunn.ch>
Date:   Tue, 20 Jul 2021 10:54:24 +0200
Message-ID: <87y2a19xhb.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon Jul 19 2021, Andrew Lunn wrote:
> On Mon, Jul 19, 2021 at 08:06:41AM +0200, Kurt Kanzenbach wrote:
>> There are different modes such as ON, OFF, LINK established, LINK
>> activity, PAUSED ... Blinking is controlled by a different register.
>>=20
>> Are there better ways to export this?
>
> As i said in another email, using LED triggers. For simple link speed
> indication, take a look at CONFIG_LED_TRIGGER_PHY. This is purely
> software, and probably not what you want.

Here's my use case/reasoning behind this patch: Upon reception of a
certain Ethernet frame, the LEDs should blink for a certain period of
time. Afterwards the default behavior should be restored. The blinking
can be done in hardware, but only for a fixed period. I needed a
different period.

Therefore, I've exported these as regular LEDs to toggle the brightness
from user space directly.

> The more complex offload of to LED control to hardware in the PHY
> subsystem it still going around and around. The basic idea is agreed,
> just not the implementation.  However, most of the implementation is
> of no help to you, since Intel drivers ignore the kernel PHY drivers
> and do their own. But the basic idea and style of user space API
> should be kept the same. So take a look at the work Marek Beh=C3=BAn has
> been doing, e.g.
>
> https://lwn.net/Articles/830947/
>
> and a more recent version
>
> https://lore.kernel.org/netdev/20210602144439.4d20b295@dellmb/T/#m4e97c90=
16597fb40849c104c7c0e3bc10d5c1ff5

Thanks for the pointer.

>
> Looking at the basic idea of using LED triggers and offloading
> them. Please also try to make us of generic names for these triggers,
> so the PHY subsystem might also use the same or similar names when it
> eventually gets something merged.
>
> Please also Cc: The LED maintainers and LED list. Doing that from the
> start would of avoided this revert, since you would of get earlier
> feedback about this.

Yeah, noted.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD2j0ATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpvDgEACeghal5Gp5UGxP+5zpUsbV8/zkCQfJ
Ctf73R+Lc4XgbmbmSR4Xu/A/gYSsNhpX0rkkFcedaQw2nxubDle0VaD/9WOI4vyS
z+YCP/cZfe66lKcTnXJWri2xhTTpp+wid7DKqkjjwt0jnpm3qC+mZAJDLch5JW1X
Z1Z/dmLTX7FJdFdwv2s68h5Aaj78Qa8mmY6sKzMVFXVRjOFyI1bD9oa0Gkk+hMRG
k5Lk9FsMkI27/BTjqXbh/GQDwLfKS2NTJGn8OanIDtfD5E505QMvozozu/9G+lQZ
6lctKHn9nMmgb3q2fkhqfH4i/eWamFoKbW4UnPLpBRlC/zKXjsA9+PpPZb1qF2O0
AQk1CCyHmP+938Dj7vHsWdP1BuA/a54gVIsgiUMJFHcCeDaPpNxi/3mxX1G2r8w/
0b813NF54CKiA6P/zxb5JTKIK44fhd8wOqsQGvVazpG0NECcB/w/TqpG3yzeZVXR
ZwX1VioJxxtd10hiHmIh0NNIY62l7HddtuXBT9VG07OU+xCmYtXpDLFFOTcG0bU1
vBQIrRiwWVwQf3FQ/PpRDCcELP+Y6ZsQgqJOQUxQ3Jjxmqobiw4n9IcjVo3Yxbv9
PUjWdxoC0Z1YGddbVI6F0DPmEwYcaa3eeTJEDdlmVP0bfI3F4uDrxi8yUTJmi3pl
dCBrtSapNQmrrA==
=SMq/
-----END PGP SIGNATURE-----
--=-=-=--

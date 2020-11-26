Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ECA2C508D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 09:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388987AbgKZIcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:32:01 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:33688 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388975AbgKZIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 03:32:00 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2020 03:31:59 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1606378925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2/Ccyeyjwu9fU4cIT93gVE0sNF6DivFcl1DKMQ5D4Kk=;
        b=nAr2JftJh8YWBCToJ8DbRGf0wBj6eggGkhpfIb11SvnlVEscATRhARLd4JJ2Dp4RKPHt6o
        QuTGoMYXx7Cw5BYLg0elOz/qw11ca3HKCEEMD6qQc+ahYulI3a98UoYk1OXWo5/I4Lt1Qv
        ufzt8jx0gZc7G1HMfBBlRqMQV1wzJXE=
From:   Sven Eckelmann <sven@narfation.org>
To:     "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        Annika Wickert <annika.wickert@exaring.de>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        dev@openvswitch.org
Subject: Re: [RFC PATCH] batman-adv: Reserve needed_headroom for fragments
Date:   Thu, 26 Nov 2020 09:21:58 +0100
Message-ID: <5658440.UjTJXf6HLC@sven-edge>
In-Reply-To: <16FAA2FE-92FA-421E-9134-27AECE426F55@exaring.de>
References: <20201125122438.955972-1-sven@narfation.org> <16FAA2FE-92FA-421E-9134-27AECE426F55@exaring.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9679158.0AQdONaE2F"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart9679158.0AQdONaE2F
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>, Annika Wickert <annika.wickert@exaring.de>, netdev@vger.kernel.org, bridge@lists.linux-foundation.org, dev@openvswitch.org
Subject: Re: [RFC PATCH] batman-adv: Reserve needed_headroom for fragments
Date: Thu, 26 Nov 2020 09:21:58 +0100
Message-ID: <5658440.UjTJXf6HLC@sven-edge>
In-Reply-To: <16FAA2FE-92FA-421E-9134-27AECE426F55@exaring.de>
References: <20201125122438.955972-1-sven@narfation.org> <16FAA2FE-92FA-421E-9134-27AECE426F55@exaring.de>

Hi,

I find your output slightly confusing. Maybe you can change your printk stuff 
to something more like:

  printk("%s %s:%u max_headroom %u\n", __FILE__, __func__, __LINE__, max_headroom);

On Thursday, 26 November 2020 00:14:35 CET Annika Wickert wrote:
> This is what I get from the bridge when bat0 is enslaved with the vxlan interface as member of batman ( https://elixir.bootlin.com/linux/latest/source/net/bridge/br_if.c#L311 )
> [   36.959547] Bridge firewalling registered
> [  522.221767] SKB Bridge br_if.c: max_headroom 0
> [  522.221781] SKB Bridge br_if.c: new_hr 0
> [  627.186129] SKB Bridge br_if.c: max_headroom 0
> [  627.186139] SKB Bridge br_if.c: new_hr 0
> [  627.616650] SKB Bridge br_if.c: new_hr 102

When is this shown? Does the batadv interface already have its hardif (slave) 
interfaces attached at that point? And did the vxlan report the correct 
needed_headroom to batadv before you've tried to attach the batadv interface 
to the bridge?

Because the bridge can also only change its needed_headroom on interface add 
or delete.

> Also BATMAN reports itself when initialized and seems not to propagate stuff up the stack on change?: (https://github.com/open-mesh-mirror/batman-adv/blob/master/net/batman-adv/hard-interface.c#L555  )
> [ 3350.212094] SKB hard-interface.h: soft_iface->needed_tailroom) 0
> [3350.212105] SKB hard-interface.h: soft_iface->needed_headroom) 358
> [ 3350.212116] SKB hard-interface.h: lower_headroom 70
> [ 3350.212126] SKB hard-interface.h: needed_headroom 102

Afaik, it is "propagating" its stuff by adjusting its own needed_headroom/
tailroom at this point. But there is no way to notify that the headroom/
tailroom was changed and the upper layers should recalculate it.

If you need something like this then we might to have a new 
NETDEV_RESERVED_SPACE_CHANGE (or a better name OR maybe use a netdev_cmd with 
a similar meaning). And then call this whenever the needed_headroom/
tailroom/... of an interface changes during its lifetime. And bridge/batman-
adv/ovs/... have to check the headroom in their notifier_call again when they 
receive this event.

> Also added some debugging to Fragmentation.c in BATMAN after the patch: 
> Nov 25 17:48:26 raspi-1gb.awlnx.space kernel: SKB Fragmentation.c: ll_reserved 96
> Nov 25 17:48:26 raspi-1gb.awlnx.space kernel: SKB Fragmentation.c: skb->len 762
> Nov 25 17:48:26 raspi-1gb.awlnx.space kernel: SKB Fragmentation.c: header_size 20
> Nov 25 17:48:26 raspi-1gb.awlnx.space kernel: SKB Fragmentation.c: fragment_size 762
> Nov 25 17:48:26 raspi-1gb.awlnx.space kernel: SKB Fragmentation.c: ll_reserved 96
> 
> At the same time the VXLAN interface which is transported over Wireguard reports this (https://elixir.bootlin.com/linux/latest/source/drivers/net/vxlan.c#L2352 )
> [  567.515778] SKB VXLAN vxlan.c: min_headroom 200
> [  567.515792] SKB VXLAN vxlan.c: dst->header_len 0
> [  567.515805] SKB VXLAN vxlan.c: VXLAN_HLEN 16
> [  567.515819] SKB VXLAN vxlan.c: LL_RESERVED_SPACE(dst->dev) 144
> [  567.515831] SKB VXLAN vxlan.c: iphdr_len 40
> 
> So in my opinion the needed headroom reported by batman is wrong by maybe 200 ? As the min_headroom of vxlan seems to be 200 but BATMAN reports 102 up the stack to the bridge.

Could it be that the vxlan didn't had the correct needed_headroom when you've 
added it to you batadv interface? Or that the vxlan interface didn't set the 
correct needed_headroom for its lower_dev (see vxlan_config_apply)?



If you have the "slow" setup, can you please do following steps:

* keep vxlan as is (I hope you specify a fixed lowerdev)

  - but try to print the needed headroom in vxlan_config_apply and compare it 
    to the ones from vxlan_build_skb

* remove the vxlan from your batadv interface
* add your vxlan again from the batadv interface

  - check if the headroom numbers are now looking better in 
    batadv_hardif_recalc_extra_skbroom

* remove batadv interface from the bridge
* add your batadv interface again to the bridge

  - is update_headroom() now using the correct headroom information?

> If you need any more input we are happy to help. Because the actual performance with running batman over vxlan is really bad. 
> We have some figures here: https://gist.github.com/fadenb/9705059cf17eddf60e744e95bf926f05

Kind regards,
	Sven
--nextPart9679158.0AQdONaE2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl+/ZaYACgkQXYcKB8Em
e0ZCnA//XWJA3QCdgwqhSzUZdyV5m8ZeVBLCGbjhPkJNV7DaPPvmDl7umBDE59jy
aLFw3Di++IckRXDm+u5BQ7JIcaka1P4F7DuE5kt2TAXlP257uknaIkIAvjcCXQ0t
9so5u2MHfMuGFB3bsT7mwFe+ZICNTvfKT59XbsHuGKK+tQULZtHa1w7xiAn7rF+l
7BkO4ONm9ebtQeWlj7tBnMdGFyKVHqH6sSOQJ4ZAMQx1Si8XZWL2C37ZeCLvMaGW
tb/ll78bELi2x1FJuhiju6taWrJbp51VBYoMZlaCrADm0ut4+tFz1oy8Oiy8WZGj
NfJMp1U6HmyfJeb9Tg0ccdiNch/v0pS9LIW4h3YOhek6ncAuJq81EzSUjZYj2Hnr
vx7RMl6vkqHZjiYH8XKs872Y7hl70kSSDP5zVDdv0Onb55OxQElRu5SnKtSESRQG
cp5zehHgyReGbOLTvZMJKR0opu9HGbioT9VazLMTHYX6ppfdgel/eJ7+vDRwTHEU
uqC3tWIaHRMsJC9giZFNW81WlQVzObf1+oe18xWyTSjhAQJr2u2zuwgtQfSbbozz
h4hzPigHnCEPptNaiHlbTqlk5bpDFoZKQnalnWPzcERyPEUWJ0nXADpY42Gkb4eE
Qa+CUPlae2lh9Qw7s68g4HcrNLDGucg7dI9gTnFLTZ4zyepCoSQ=
=mBS8
-----END PGP SIGNATURE-----

--nextPart9679158.0AQdONaE2F--




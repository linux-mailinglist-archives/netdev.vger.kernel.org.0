Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A962F738E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbhAOHM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbhAOHM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:12:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B175DC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:11:46 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610694704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8wTgHHijFKWCsOUpAr7gjfDWm4lgzt3jm8g63ukE/CM=;
        b=k8c1jRv21K7TplCjPu4QOwe7Mvxl2CgvLJb+IizgBZdVD8nVZvn1PAJ80k43lPkVdOPQBB
        hKxAvJG5KXSxbo79H+cyTnWKZuNETtD8XqbfowfHTVfJlSreF0B87R5ULvvB/SrcG3zUhA
        Uw5zs0yTGJGL3gYBh7act6/6tkvgEVLET9G6sXzwSrXMjJMeeAbFzLoUbBnBCn/DzhN5Op
        ua6jyhw0U2s5+xujCjoUto1sS9u4q+TxN37Xw7tyviJWsVIV6lvo62Rmf+XzQuu5XNpGPt
        GpZkq/G+J3hYSbm9pSYAQQ1ax4UmSN6r9VRUd91etFOGJkAyjx1HhsYRdeXKkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610694704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8wTgHHijFKWCsOUpAr7gjfDWm4lgzt3jm8g63ukE/CM=;
        b=85lwaZgF0Lzvi1XNzFdUG3X5XrHfejjUU7s8lpIKi6Tm/wS8kqlgVGVHqkGVuFDNxTcO8J
        vx73JPRGGu/U0YAA==
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next] net: dsa: set configure_vlan_while_not_filtering to true by default
In-Reply-To: <20210114173426.2731780-1-olteanv@gmail.com>
References: <20210114173426.2731780-1-olteanv@gmail.com>
Date:   Fri, 15 Jan 2021 08:11:33 +0100
Message-ID: <87o8hq4qu2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Jan 14 2021, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.
>
> New drivers always seem to omit setting this flag, for some reason. So
> let's reverse the logic: the DSA core sets it by default to true before
> the .setup() callback, and legacy drivers can turn it off. This way, new
> drivers get the new behavior by default, unless they explicitly set the
> flag to false, which is more obvious during review.
>
> Remove the assignment from drivers which were setting it to true, and
> add the assignment to false for the drivers that didn't previously have
> it. This way, it should be easier to see how many we have left.
>
> The following drivers: lan9303, mv88e6060 were skipped from setting this
> flag to false, because they didn't have any VLAN offload ops in the
> first place.
>
> The Broadcom Starfighter 2 driver calls the common b53_switch_alloc and
> therefore also inherits the configure_vlan_while_not_filtering=true
> behavior.
>
> Also, print a message through netlink extack every time a VLAN has been
> skipped. This is mildly annoying on purpose, so that (a) it is at least
> clear that VLANs are being skipped - the legacy behavior in itself is
> confusing, and the extack should be much more difficult to miss, unlike
> kernel logs - and (b) people have one more incentive to convert to the
> new behavior.
>
> No behavior change except for the added prints is intended at this time.
>
> $ ip link add br0 type bridge vlan_filtering 0
> $ ip link set sw0p2 master br0
> [   60.315148] br0: port 1(sw0p2) entered blocking state
> [   60.320350] br0: port 1(sw0p2) entered disabled state
> [   60.327839] device sw0p2 entered promiscuous mode
> [   60.334905] br0: port 1(sw0p2) entered blocking state
> [   60.340142] br0: port 1(sw0p2) entered forwarding state
> Warning: dsa_core: skipping configuration of VLAN. # This was the pvid
> $ bridge vlan add dev sw0p2 vid 100
> Warning: dsa_core: skipping configuration of VLAN.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmABQCUACgkQeSpbgcuY
8KaeqxAAjxTvFtD49sx4Ap/fogODZm88TDoSJhjVVkN3aUKaFXjP4q1nraM3Gl6h
7SnXJhifO+aRqlHr7xc//weInOIh7FsokAyM6oR7VtakLzzV4spoy3IZpXXvvKFK
ut42amQEliw0ZkRBTownKCbjeWRVxw5jg7ER+xY0QTnemQfkutYmw0y5JMf4jc1a
DeMuxYKkQN++B+tPMC7+CN6662ofahaTkl4Jxon7Knp8Yojiyj4FFF8UeHF1SzJ8
Y+ActF2QP+C7MfMStRR2LDJMjYANW7fEY/tGWZq0CG5GMfdJp6TQjBiZBj62ZftE
QW0wxycNC1VQpvqFdgO7Q40koP4+SX61x6JAOwMXRNVpDGLY0OD3e8yJHjDvvkfV
DL9ShlT0Tb0me+KEIwOcMFg/NmoeANQojsvs1FBzX33s0ERlrKQqZZstx4ttD5VP
me/82F7ghHtpgJ0u3++c9uroaEeXy7NralttqMwxLYLbZ/NXn7K3ySosHpgWcaf3
DadE9kq7Rl8KLexIgdkPPggUSECGn54F651Snvy7TyGPIOxYViHPqHT2GlOm/TZK
6r4YmSk9ovxFjI3XkxrbudIogpeGe9XhOVVki5lIJx9IAvm+3ZwvRZdhOww8OUtj
sanPU+G060zpFz71lE8ZqSNayOopnGXCS8vBF8ZN7W81XRQQBkA=
=SF/j
-----END PGP SIGNATURE-----
--=-=-=--

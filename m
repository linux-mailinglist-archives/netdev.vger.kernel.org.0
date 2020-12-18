Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB62DE00F
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 09:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgLRIrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 03:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgLRIrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 03:47:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70940C0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 00:46:54 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608281212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VhPdAlbKyvPKqWWQ0+/u1duYod6cv1oPulb7fghE7Bc=;
        b=b9Fj4eHPx5Ho5opMCDNtK483Faku9dD7sDaePJAfFT97z0QYWoG6azFZlMHVb5d2EK8rOa
        4vXymyzZ+SO2tpP+qyXouuHwBo/voPEN698w3WraQ6bruSqkcD8ADDRNMWaL+y7sdbi6HZ
        CPhdffJI5mjITo66kXgFNtqXNsTAf+8SLuDZ6g4Imygaxl5a41GbshO5IZ6fsNXBdoFtrK
        D/lmcyuE03XUJKgFIXAnz8eK+oT5BGQVeFq+P/QkC8Xf36wNL9/nvAKqBwykRG+rLnAZAm
        shBsVLSW1zeqKK3gYI4RbW4aB62xYsmi1IhoBFCLnEeo/rpMUQnchQ2HpEQqHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608281212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VhPdAlbKyvPKqWWQ0+/u1duYod6cv1oPulb7fghE7Bc=;
        b=Xrz9bxAJK8YsIQZEbU4tawJx/yRgHCC6fJ53LrLG52XLjLlaDywddxMb6rqZIZXjf7jbUe
        /UIygZIJRZunJGDg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [RFC PATCH net-next 3/9] net: switchdev: remove the transaction structure from port attributes
In-Reply-To: <20201217015822.826304-4-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com> <20201217015822.826304-4-vladimir.oltean@nxp.com>
Date:   Fri, 18 Dec 2020 09:46:49 +0100
Message-ID: <87360333ie.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Thu Dec 17 2020, Vladimir Oltean wrote:
> Since the introduction of the switchdev API, port attributes were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
>
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
>
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
>
> This patch removes the struct switchdev_trans member from switchdev port
> attribute notifier structures, and converts drivers to not look at this
> member.
>
> In part, this patch contains a revert of my previous commit 2e554a7a5d8a
> ("net: dsa: propagate switchdev vlan_filtering prepare phase to
> drivers").
>
> For the most part, the conversion was trivial except for:
> - Rocker's world implementation based on Broadcom OF-DPA had an odd
>   implementation of ofdpa_port_attr_bridge_flags_set. The conversion was
>   done mechanically, by pasting the implementation twice, then only
>   keeping the code that would get executed during prepare phase on top,
>   then only keeping the code that gets executed during the commit phase
>   on bottom, then simplifying the resulting code until this was obtained.
> - DSA's offloading of STP state, bridge flags, VLAN filtering and
>   multicast router could be converted right away. But the ageing time
>   could not, so a shim was introduced and this was left for a further
>   commit.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/b53/b53_common.c              |  6 +-
>  drivers/net/dsa/b53/b53_priv.h                |  3 +-
>  drivers/net/dsa/dsa_loop.c                    |  3 +-
>  drivers/net/dsa/hirschmann/hellcreek.c        |  6 +-
>  drivers/net/dsa/lantiq_gswip.c                | 26 +----
>  drivers/net/dsa/microchip/ksz8795.c           |  6 +-
>  drivers/net/dsa/microchip/ksz9477.c           |  6 +-
>  drivers/net/dsa/mt7530.c                      |  6 +-
>  drivers/net/dsa/mv88e6xxx/chip.c              |  7 +-
>  drivers/net/dsa/ocelot/felix.c                |  5 +-
>  drivers/net/dsa/qca8k.c                       |  6 +-
>  drivers/net/dsa/realtek-smi-core.h            |  3 +-
>  drivers/net/dsa/rtl8366.c                     | 11 +--
>  drivers/net/dsa/sja1105/sja1105.h             |  3 +-
>  drivers/net/dsa/sja1105/sja1105_devlink.c     |  9 +-
>  drivers/net/dsa/sja1105/sja1105_main.c        | 17 ++--
>  .../marvell/prestera/prestera_switchdev.c     | 37 ++-----
>  .../mellanox/mlxsw/spectrum_switchdev.c       | 63 +++---------
>  drivers/net/ethernet/mscc/ocelot.c            | 32 ++----
>  drivers/net/ethernet/mscc/ocelot_net.c        | 13 +--
>  drivers/net/ethernet/rocker/rocker.h          |  6 +-
>  drivers/net/ethernet/rocker/rocker_main.c     | 46 +++------
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    | 23 ++---
>  drivers/net/ethernet/ti/cpsw_switchdev.c      | 20 +---
>  drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 21 +---
>  include/net/dsa.h                             |  3 +-
>  include/net/switchdev.h                       |  7 +-
>  include/soc/mscc/ocelot.h                     |  3 +-
>  net/dsa/dsa_priv.h                            | 18 ++--
>  net/dsa/port.c                                | 97 ++++++++-----------
>  net/dsa/slave.c                               | 17 ++--
>  net/dsa/switch.c                              | 11 +--
>  net/switchdev/switchdev.c                     | 46 +--------
>  33 files changed, 162 insertions(+), 424 deletions(-)
>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

for the hellcreek part.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl/cbHkACgkQeSpbgcuY
8KbrdQ//So692VKs3gzbXgd1OzZCOb9P/IcsDijH6ugOG6th1PA1btebeNZeK7Mj
q5AWkUJSiwz5VKIC5yKHah921pJK8G/zVARC8MW8ABjCn5EaDRj1c9FZHnhfeWuf
qZIcKtcHSrzBLAramTJ9LzpgroN53/wc3CxCycqqT2Oy45raF5PlT5ATnZvyHEh4
DwH4nFbcK8A2jgFXr6UerQWGy82TKeGgddu28KRhtRrkxIKFJ5A9IysHKLBuq+ez
mHC5j17/vMrqHdGu/NK3XXcr3jc1/o5xlqtKcQZGTvcXi9EVIyuobP5uQ799Gz+N
JmPXj67vDutiCz7YEIoWIVlWSZKIDrvUX5awf6QTxl8z4F/xOZjVCMfjyQaLvCVs
5vBEtIuWn2RT3OpJrnT+PMdK6WO1jhIe9obSidxzP5xR4XUw9YhA3KBiY6HJ5ciN
tj04JeURw6jdqPlAJQsFQFxsvjAA5ga2625Kz1qRds3psOTyECASBqLPfSAwsCr9
9R1bGF1YSAhTeVeQZk2rx7vW5p3ip+Tyye52ou3bDYJgnIYgnxkuO0TvmZBAq1F4
XXsYKu4CEPiM5857GwnGkWHseJMKes37s4L6g1JSgzXUbszZFBZQyCvPtRLzSgrw
SEYqrLjNYI0yEDAYfZCVRENkY4KZyiCFp07/GQEZozhwhTnzH78=
=tKvh
-----END PGP SIGNATURE-----
--=-=-=--

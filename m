Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807362ECADD
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 08:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbhAGHSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 02:18:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41848 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbhAGHSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 02:18:14 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610003850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NO/owETE9ke64ibKw0sBtpG04KlHqajs6a53Nr5F2J0=;
        b=wBinJM+MdFLMZJazOfiswbYZVsm2jRHq2QyEssoILqsOuVpbJjFU7ZXzlLPgUH0qknVokB
        MpfdX2LDE28tzyIg6BZr+466pKlj5bqHRyGEz8fqE4TClX+0y188KVxa19mKQN8sNwuVY9
        BcOd2+cNTxT5PPZoO4yRQOWZmXVuHvF/wZPKpCgLpqcjtf+398OQ+m0dnfNOPbukot0Kip
        E6XB3QJKkufPjMQbVADW1Z30AympqYFcNolcMqP00Oj1eLs4SSX27WM5LkfaPVHEmHobyG
        ETMAM8K6J6tiR3hJ/LVBjag0waN3SxAMdz2vl0erdMl2CU1hKLIsFvJs1a8DNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610003850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NO/owETE9ke64ibKw0sBtpG04KlHqajs6a53Nr5F2J0=;
        b=3J7S94+0N6csm8XZERgnO3BPIcb3EkFEjYSTrcL4jgMLMQ2TkAX5MtCWtiX5M6IzqYKlpJ
        vdmSAP1BGOkKn4CA==
To:     Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH v3 net-next 01/11] net: switchdev: remove vid_begin -> vid_end range from VLAN objects
In-Reply-To: <20210106231728.1363126-2-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com> <20210106231728.1363126-2-olteanv@gmail.com>
Date:   Thu, 07 Jan 2021 08:17:14 +0100
Message-ID: <87h7ntw70l.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu Jan 07 2021, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The call path of a switchdev VLAN addition to the bridge looks something
> like this today:
>
>         nbp_vlan_init
>         |  __br_vlan_set_default_pvid
>         |  |                       |
>         |  |    br_afspec          |
>         |  |        |              |
>         |  |        v              |
>         |  | br_process_vlan_info  |
>         |  |        |              |
>         |  |        v              |
>         |  |   br_vlan_info        |
>         |  |       / \            /
>         |  |      /   \          /
>         |  |     /     \        /
>         |  |    /       \      /
>         v  v   v         v    v
>       nbp_vlan_add   br_vlan_add ------+
>        |              ^      ^ |       |
>        |             /       | |       |
>        |            /       /  /       |
>        \ br_vlan_get_master/  /        v
>         \        ^        /  /  br_vlan_add_existing
>          \       |       /  /          |
>           \      |      /  /          /
>            \     |     /  /          /
>             \    |    /  /          /
>              \   |   /  /          /
>               v  |   | v          /
>               __vlan_add         /
>                  / |            /
>                 /  |           /
>                v   |          /
>    __vlan_vid_add  |         /
>                \   |        /
>                 v  v        v
>       br_switchdev_port_vlan_add
>
> The ranges UAPI was introduced to the bridge in commit bdced7ef7838
> ("bridge: support for multiple vlans and vlan ranges in setlink and
> dellink requests") (Jan 10 2015). But the VLAN ranges (parsed in br_afspe=
c)
> have always been passed one by one, through struct bridge_vlan_info
> tmp_vinfo, to br_vlan_info. So the range never went too far in depth.
>
> Then Scott Feldman introduced the switchdev_port_bridge_setlink function
> in commit 47f8328bb1a4 ("switchdev: add new switchdev bridge setlink").
> That marked the introduction of the SWITCHDEV_OBJ_PORT_VLAN, which made
> full use of the range. But switchdev_port_bridge_setlink was called like
> this:
>
> br_setlink
> -> br_afspec
> -> switchdev_port_bridge_setlink
>
> Basically, the switchdev and the bridge code were not tightly integrated.
> Then commit 41c498b9359e ("bridge: restore br_setlink back to original")
> came, and switchdev drivers were required to implement
> .ndo_bridge_setlink =3D switchdev_port_bridge_setlink for a while.
>
> In the meantime, commits such as 0944d6b5a2fa ("bridge: try switchdev op
> first in __vlan_vid_add/del") finally made switchdev penetrate the
> br_vlan_info() barrier and start to develop the call path we have today.
> But remember, br_vlan_info() still receives VLANs one by one.
>
> Then Arkadi Sharshevsky refactored the switchdev API in 2017 in commit
> 29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
> switchdev") so that drivers would not implement .ndo_bridge_setlink any
> longer. The switchdev_port_bridge_setlink also got deleted.
> This refactoring removed the parallel bridge_setlink implementation from
> switchdev, and left the only switchdev VLAN objects to be the ones
> offloaded from __vlan_vid_add (basically RX filtering) and  __vlan_add
> (the latter coming from commit 9c86ce2c1ae3 ("net: bridge: Notify about
> bridge VLANs")).
>
> That is to say, today the switchdev VLAN object ranges are not used in
> the kernel. Refactoring the above call path is a bit complicated, when
> the bridge VLAN call path is already a bit complicated.
>
> Let's go off and finish the job of commit 29ab586c3d83 by deleting the
> bogus iteration through the VLAN ranges from the drivers. Some aspects
> of this feature never made too much sense in the first place. For
> example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
> flag supposed to mean, when a port can obviously have a single pvid?
> This particular configuration _is_ denied as of commit 6623c60dc28e
> ("bridge: vlan: enforce no pvid flag in vlan ranges"), but from an API
> perspective, the driver still has to play pretend, and only offload the
> vlan->vid_end as pvid. And the addition of a switchdev VLAN object can
> modify the flags of another, completely unrelated, switchdev VLAN
> object! (a VLAN that is PVID will invalidate the PVID flag from whatever
> other VLAN had previously been offloaded with switchdev and had that
> flag. Yet switchdev never notifies about that change, drivers are
> supposed to guess).
>
> Nonetheless, having a VLAN range in the API makes error handling look
> scarier than it really is - unwinding on errors and all of that.
> When in reality, no one really calls this API with more than one VLAN.
> It is all unnecessary complexity.
>
> And despite appearing pretentious (two-phase transactional model and
> all), the switchdev API is really sloppy because the VLAN addition and
> removal operations are not paired with one another (you can add a VLAN
> 100 times and delete it just once). The bridge notifies through
> switchdev of a VLAN addition not only when the flags of an existing VLAN
> change, but also when nothing changes. There are switchdev drivers out
> there who don't like adding a VLAN that has already been added, and
> those checks don't really belong at driver level. But the fact that the
> API contains ranges is yet another factor that prevents this from being
> addressed in the future.
>
> Of the existing switchdev pieces of hardware, it appears that only
> Mellanox Spectrum supports offloading more than one VLAN at a time,
> through mlxsw_sp_port_vlan_set. I have kept that code internal to the
> driver, because there is some more bookkeeping that makes use of it, but
> I deleted it from the switchdev API. But since the switchdev support for
> ranges has already been de facto deleted by a Mellanox employee and
> nobody noticed for 4 years, I'm going to assume it's not a biggie.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com> # switchdev and mlxsw

[snip]

> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -353,9 +353,8 @@ static int hellcreek_vlan_prepare(struct dsa_switch *=
ds, int port,
>  		if (!dsa_is_user_port(ds, i))
>  			continue;
>=20=20
> -		for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; ++vid)
> -			if (vid =3D=3D restricted_vid)
> -				return -EBUSY;
> +		if (vlan->vid =3D=3D restricted_vid)
> +			return -EBUSY;

`u16 vid' is not used anymore:

drivers/net/dsa/hirschmann/hellcreek.c: In function =E2=80=98hellcreek_vlan=
_prepare=E2=80=99:
drivers/net/dsa/hirschmann/hellcreek.c:359:7: warning: unused variable =E2=
=80=98vid=E2=80=99 [-Wunused-variable]
   u16 vid;
       ^~~
Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl/2tXoACgkQeSpbgcuY
8KZUSxAAubPex0Tsu6ZJS0bawc3qUjIrKIUGnh91CpBBC6bWfe9BjPNPvjYc8RTP
A7sdi109T2qPWZie+jlvCUc7qU4Wkwxg+HjUvKhJj/09wzVjdJb/gMHQ48Yf7nJA
oS3Zz/O/BfOaQ+CFgidV4YG476ns3d7mmkmCe4YrQd5PekZLdn8gM37ZCNlPYQJW
BQoh9vTe0OJJKXfDffnojGs2urUim5ECeiG9HeF37LE0CpFOnOofgxkK8Q7fqCsC
QVw/y2SsnlZBoxZXZfJUUK9TnrjRVVp8SLA58ngbSkZyviU0/sHnut94UUogw63s
4JXVhdSkOyiWwVAFylRfjJ5FuICmVQRsyydaNY2KeZTHE2/oRE3Tq8polMSR11Tv
kTrCFPvIdKLhhMzwM7buQmbYTfTmISMoWbKq6jPe1g2yVSl7EXjHF+2ixD6U3qTb
cUu8eqy9v70pMH0ft0+KhXjjsofqzWuV5XpJ+cdbpuCc6MapU0TM3KkfGJpe04t4
oiTwEOrpIrE3GmBiMKB7iQp6W0kEv9OD2JV6NgaEi1rJxruA38EXqc43fGSMnAHv
yn0eeLgYRU3i/fDTHRxcwovc6JK9vEIGMGa0ZElOFz13yb+43AhiT+UaMV4gwxK8
th98eK45/wir6YnXMsVNodlfswCtLxS5floUaOFLse5KmREOjuw=
=mWKJ
-----END PGP SIGNATURE-----
--=-=-=--

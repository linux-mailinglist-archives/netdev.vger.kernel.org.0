Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD34F331F47
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 07:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhCIGbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 01:31:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50512 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCIGbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 01:31:35 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615271494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVQldDm8W7VuFwJzN49rtqU3DLzSSiW/zXNe17hi5dQ=;
        b=LWWAU7a5en4bdGMz1cFlUqfnAnrFKgrU3uEr797h6tgo9GAejjQERlXCTvt1VGgLnxc+dp
        rhhQvTQxAD/HHtBRaNFMeN47qHkJBj0pW4AQUouU9g12TSDC4WNNsrYuyJXDeqJ8iwpMP/
        8Ijay88QbjfmobEDofe/aaTeSMKjcwz3+3eEuuKsdQPF4xWlolR+7GXFqoxZbhHXVemJq3
        aNWXHZQmQ9pZBkCRKEEVFXh/zyXip39O2nhV5yzlMdT3vVWxNzBI35B+ctkgPoEF1d57FE
        8Dbe/g/tfrSUsFr+EbdDREPBGLAT4PXJ4bY+FjhB2yxm4ejLwt6L64N8UXARjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615271494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVQldDm8W7VuFwJzN49rtqU3DLzSSiW/zXNe17hi5dQ=;
        b=NZy3Ejktqo+hKamf7y/sdEhd5O1GCxLVcFyShOn+IpkPnOYRNI7bDn0aBxgaBLOOiUjt0c
        wYsKtwO3KwmTp3Dw==
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
In-Reply-To: <20210308135509.3040286-1-olteanv@gmail.com>
References: <20210308135509.3040286-1-olteanv@gmail.com>
Date:   Tue, 09 Mar 2021 07:31:25 +0100
Message-ID: <87r1kon8hu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

On Mon Mar 08 2021, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> DSA is aware of switches with global VLAN filtering since the blamed
> commit, but it makes a bad decision when multiple bridges are spanning
> the same switch:
>
> ip link add br0 type bridge vlan_filtering 1
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> ip link set swp4 master br1
> ip link set swp5 master br1
> ip link set swp5 nomaster
> ip link set swp4 nomaster
> [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a glo=
bal setting
> [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
>
> When all ports leave br1, DSA blindly attempts to disable VLAN filtering
> on the switch, ignoring the fact that br0 still exists and is VLAN-aware
> too. It fails while doing that.
>
> This patch checks whether any port exists at all and is under a
> VLAN-aware bridge.
>
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the=
 bridge")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Code looks correct. One comment below.

> ---
>  net/dsa/switch.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 4b5da89dc27a..56ed31b0e636 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -107,7 +107,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch =
*ds,
>  	bool unset_vlan_filtering =3D br_vlan_enabled(info->br);
>  	struct dsa_switch_tree *dst =3D ds->dst;
>  	struct netlink_ext_ack extack =3D {0};
> -	int err, i;
> +	int err, port;
>=20=20
>  	if (dst->index =3D=3D info->tree_index && ds->index =3D=3D info->sw_ind=
ex &&
>  	    ds->ops->port_bridge_join)
> @@ -124,13 +124,16 @@ static int dsa_switch_bridge_leave(struct dsa_switc=
h *ds,
>  	 * it. That is a good thing, because that lets us handle it and also
>  	 * handle the case where the switch's vlan_filtering setting is global
>  	 * (not per port). When that happens, the correct moment to trigger the
> -	 * vlan_filtering callback is only when the last port left this bridge.
> +	 * vlan_filtering callback is only when the last port the last

Somehow "left" got missing. Shouldn't that line be:

"vlan_filtering callback is only when the last port left the last" ?

> +	 * VLAN-aware bridge.
>  	 */

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBHFj0ACgkQeSpbgcuY
8Ka3fw/+KiXsTdNcv/EEB/h/FmqrVyAwV4RsIgGPw95rNzuMpP+F5n7+OeVb/eh0
hCYlbYmCKUavA1ktYBhIAEnotOVNCOah46C7Dag6UezLiCzWUNG5qajltLaaZwrt
V6e1quPL1HKuSGen2yEKjXqvvc3NQQ37qcWG+I+eBNfk6a9I94BeTHKh/BV0zIKL
eRU5eVJwAPFmNFIjWYurtxDxpXsga5pnQuKbH5MpGd4jlOJfxHgkOu7BeeO2xvNx
WepTFgxpIa7AuvKpXYGKMfsQZnnt/48Zye8NWgVPml/zH+EZUsen953d6tUn8xEv
KrgotVMNkNtKnhGUUXSy0NxOn8i9Q1DofMYiHQSXh4wDd81SsqFG/AGNzNt2uXc4
J7qfYHl42aTzzzZa+kYEFEEQ7vtUC0YE91Rm5xLeRWQx34F0hxwAm7Awv2ais5Yq
Jl6MrDWWyVvtanSJt0U2sLoA4BjO7XkhyVeEXHEdouimagl6rW1ueVUqOn4PrA1I
zeOHygVitmhcuvd2+UVaIGwSNWvWiZ1MnkG5JzhVyhjEFAzcJ/8nIaDJc0kM7GCb
YJ6/IES8U5nV6wbvaLRUVda/GUrSCWVp3tYN1C4ZLSKwaqkO612UDy4/vN98HoMk
GUlYRuCZmkElDchyU6OvFYPiWat/pt16YlxPcGT5yYEUSjYnj6Y=
=M0CJ
-----END PGP SIGNATURE-----
--=-=-=--

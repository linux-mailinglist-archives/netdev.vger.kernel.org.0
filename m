Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577E72B4A99
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbgKPQRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:17:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:36040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbgKPQRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 11:17:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 052ECABF4;
        Mon, 16 Nov 2020 16:17:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A17EE604F6; Mon, 16 Nov 2020 17:17:02 +0100 (CET)
Date:   Mon, 16 Nov 2020 17:17:02 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 3/4] selftests: extract common functions in
 ethtool-common.sh
Message-ID: <20201116161702.wznoj6z4ceujkydj@lion.mk-sys.cz>
References: <20201113231655.139948-1-acardace@redhat.com>
 <20201113231655.139948-3-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cbp2c2tj4chidhfm"
Content-Disposition: inline
In-Reply-To: <20201113231655.139948-3-acardace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cbp2c2tj4chidhfm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2020 at 12:16:54AM +0100, Antonio Cardace wrote:
> Factor out some useful functions so that they can be reused
> by other ethtool-netdevsim scripts.
>=20
> Signed-off-by: Antonio Cardace <acardace@redhat.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Just one comment:

[...]
> +function get_netdev_name {
> +    local -n old=3D$1
> +
> +    new=3D$(ls /sys/class/net)
> +
> +    for netdev in $new; do
> +	for check in $old; do
> +            [ $netdev =3D=3D $check ] && break
> +	done
> +
> +	if [ $netdev !=3D $check ]; then
> +	    echo $netdev
> +	    break
> +	fi
> +    done
> +}
[...]
> +function make_netdev {
> +    # Make a netdevsim
> +    old_netdevs=3D$(ls /sys/class/net)
> +
> +    if ! $(lsmod | grep -q netdevsim); then
> +	modprobe netdevsim
> +    fi
> +
> +    echo $NSIM_ID > /sys/bus/netdevsim/new_device
> +    echo `get_netdev_name old_netdevs`
> +}

This would be rather unpredictable if someone ran another selftest (or
anything else that would create a network device) in parallel. IMHO it
would be safer (and easier) to get the name of the new device from

  /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/

But as this is not new code and you are just moving existing code, it
can be done in a separate patch.

Michal

--cbp2c2tj4chidhfm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+ypfgACgkQ538sG/LR
dpXwwAgAsWgBhySDg61lP3U40G9i5QnJMLGy9ZgoK8CbPkmzeHe2fqYbr9bCZGkK
NR1N5BWlr4UY7B6LDkIi8BqaTfJFXJZFzLBxMh7ExZcmXsYxiSxSe1/XTetiCvUY
h0GOrvBUFZBDrYXP1e9gq7gmNUxF0etyUg6n5Se+vpHQfZ6A91+j0zNDQgFOqZw9
iNZlqZi2l/6rmFtAO3rvSmpXeIo94Ai+a/uPS5ybleoL9qYFBp8nhxMugH1ik1vp
4CKVG4baztEsOGaMAazla11970LRjCbpoKm227ryzm7W8uZIJCoCenc0WtiOrcde
EHWHNivg8v1hOC7VJF+Mu3ii1/ESmg==
=l9Wf
-----END PGP SIGNATURE-----

--cbp2c2tj4chidhfm--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16FA24B0FF
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHTIYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgHTIYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 04:24:14 -0400
Received: from localhost (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDF022BED;
        Thu, 20 Aug 2020 08:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911853;
        bh=9qWmb2ne5yGdqdaFQ5lWZ8JwFeZcz4s6tqM9ozd7LSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fg2EmKvGKwNBYj14t7gVN8o+kjM2t0ZORI0a6uHDXwMktsLGJIZrs9nZB9CG2sftD
         zoPbebdEvmiu7R1uyZMnntMWm/c4Ba6k6BVM90x0kBK3dOVC7q9cX4MAfMYCogTok/
         4tkHKbfqhGBDqHwNu265foqrycFG9fWtvo1OFDwA=
Date:   Thu, 20 Aug 2020 10:24:08 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] bpf: xdp: fix XDP mode when no mode flags specified
Message-ID: <20200820082408.GE2282@lore-desk>
References: <20200820052841.1559757-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Content-Disposition: inline
In-Reply-To: <20200820052841.1559757-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in ne=
t_device")
> inadvertently changed which XDP mode is assumed when no mode flags are
> specified explicitly. Previously, driver mode was preferred, if driver
> supported it. If not, generic SKB mode was chosen. That commit changed de=
fault
> to SKB mode always. This patch fixes the issue and restores the original
> logic.
>=20
> Reported-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF program=
s in net_device")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Hi Andrii,

Regarding this patch:

Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>

I found another similar issue (not sure if it is related yet), the program =
removal is failing:

$ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP m=
ode DEFAULT group default qlen 1024
    link/ether f0:ad:4e:09:6b:57 brd ff:ff:ff:ff:ff:ff
    prog/xdp id 1 tag 3b185187f1855c4c jited=20

$ip link set dev eth0 xdp off                                              =
                                                                           =
                                                                  =20
Error: XDP program already attached.

Regards,
Lorenzo

> ---
>  net/core/dev.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b5d1129d8310..d42c9ea0c3c0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8742,13 +8742,15 @@ struct bpf_xdp_link {
>  	int flags;
>  };
> =20
> -static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
> +static enum bpf_xdp_mode dev_xdp_mode(struct net_device *dev, u32 flags)
>  {
>  	if (flags & XDP_FLAGS_HW_MODE)
>  		return XDP_MODE_HW;
>  	if (flags & XDP_FLAGS_DRV_MODE)
>  		return XDP_MODE_DRV;
> -	return XDP_MODE_SKB;
> +	if (flags & XDP_FLAGS_SKB_MODE)
> +		return XDP_MODE_SKB;
> +	return dev->netdev_ops->ndo_bpf ? XDP_MODE_DRV : XDP_MODE_SKB;
>  }
> =20
>  static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode=
 mode)
> @@ -8896,7 +8898,7 @@ static int dev_xdp_attach(struct net_device *dev, s=
truct netlink_ext_ack *extack
>  		return -EINVAL;
>  	}
> =20
> -	mode =3D dev_xdp_mode(flags);
> +	mode =3D dev_xdp_mode(dev, flags);
>  	/* can't replace attached link */
>  	if (dev_xdp_link(dev, mode)) {
>  		NL_SET_ERR_MSG(extack, "Can't replace active BPF XDP link");
> @@ -8984,7 +8986,7 @@ static int dev_xdp_detach_link(struct net_device *d=
ev,
> =20
>  	ASSERT_RTNL();
> =20
> -	mode =3D dev_xdp_mode(link->flags);
> +	mode =3D dev_xdp_mode(dev, link->flags);
>  	if (dev_xdp_link(dev, mode) !=3D link)
>  		return -EINVAL;
> =20
> @@ -9080,7 +9082,7 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
k, struct bpf_prog *new_prog,
>  		goto out_unlock;
>  	}
> =20
> -	mode =3D dev_xdp_mode(xdp_link->flags);
> +	mode =3D dev_xdp_mode(xdp_link->dev, xdp_link->flags);
>  	bpf_op =3D dev_xdp_bpf_op(xdp_link->dev, mode);
>  	err =3D dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
>  			      xdp_link->flags, new_prog);
> @@ -9164,7 +9166,7 @@ int bpf_xdp_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
>  		      int fd, int expected_fd, u32 flags)
>  {
> -	enum bpf_xdp_mode mode =3D dev_xdp_mode(flags);
> +	enum bpf_xdp_mode mode =3D dev_xdp_mode(dev, flags);
>  	struct bpf_prog *new_prog =3D NULL, *old_prog =3D NULL;
>  	int err;
> =20
> --=20
> 2.24.1
>=20

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz4zJgAKCRA6cBh0uS2t
rMrDAQD2Bejq+yEChqMkqgiNlDx8ObFr5m76n3yNL8Q5TDpvtwEA3NBUJcYKYgUn
p0jBGjZU6iEyi2dvbFxUAe5rRMzpqQw=
=e8Rd
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--

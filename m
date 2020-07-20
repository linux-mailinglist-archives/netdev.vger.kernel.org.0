Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0938C2254D9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 02:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGTAMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 20:12:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:38264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgGTAMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 20:12:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3432BAF5B;
        Mon, 20 Jul 2020 00:12:57 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1AD7B60743; Mon, 20 Jul 2020 02:12:51 +0200 (CEST)
Date:   Mon, 20 Jul 2020 02:12:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool] Fix segfault with cable test and ./configure
 --disable-netlink
Message-ID: <20200720001251.5nwf7nhcivl6b4yk@lion.mk-sys.cz>
References: <20200716220509.1314265-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="prr2elq2nx67n5cm"
Content-Disposition: inline
In-Reply-To: <20200716220509.1314265-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--prr2elq2nx67n5cm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2020 at 12:05:09AM +0200, Andrew Lunn wrote:
> When the netlink interface code is disabled, a stub version of
> netlink_run_handler() is used. This stub version needs to handle the
> case when there is no possibility for a command to fall back to the
> IOCTL call. The two cable tests commands have no such fallback, and if
> we don't handle this, ethtool tries to jump through a NULL pointer
> resulting in a segfault.
>=20
> Reported-by: Chris Healy <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thank you. I'll need to be more thorough with teseting the
--disable-netlink builds.

Michal

> ---
>  netlink/extapi.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/netlink/extapi.h b/netlink/extapi.h
> index c5bfde9..a35d5f2 100644
> --- a/netlink/extapi.h
> +++ b/netlink/extapi.h
> @@ -46,6 +46,12 @@ void nl_monitor_usage(void);
>  static inline void netlink_run_handler(struct cmd_context *ctx,
>  				       nl_func_t nlfunc, bool no_fallback)
>  {
> +	if (no_fallback) {
> +		fprintf(stderr,
> +			"Command requires kernel netlink support which is not "
> +			"enabled in this ethtool binary\n");
> +		exit(1);
> +	}
>  }
> =20
>  static inline int nl_monitor(struct cmd_context *ctx)
> --=20
> 2.27.0
>=20

--prr2elq2nx67n5cm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8U4X0ACgkQ538sG/LR
dpUw8wf+KXbdFefYJEQ+biIxC/DsjwfBEldWywiF+l4XmIiLAkA5kRpvF0IlOfUj
rr37tK/7/HF3R0Tc4nJn7qYgYB/PEXPp1gAmFinbuTrfWyD6DsCOvfTWLC7exy/7
I6OkTCV+RujuH2qoMQsfIvUqxm7Cnd+GE6JRX1/DhuhbXDshDJvU8o4DrdCksTuW
tY5VZ5zPN1OyjNmhpE7vbUIivjdKmkFhK0tZ3dtn4Q3R72DQ8fL6omZFMDuRRcrT
+mSJ3d8Stn16h6ArJpdssWKMr0laaRB5VrTOY0fJb9JBXa7w18pV3CAUEhsg62z3
P0Mnt/fgzaoqkxVarY8+TNdalSbYQA==
=xsmd
-----END PGP SIGNATURE-----

--prr2elq2nx67n5cm--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CFB363DF8
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhDSIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 04:50:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37244 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbhDSIuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 04:50:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 50B761C0B77; Mon, 19 Apr 2021 10:49:54 +0200 (CEST)
Date:   Mon, 19 Apr 2021 10:49:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH AUTOSEL 5.10 41/46] net/rds: Avoid potential use after
 free in rds_send_remove_from_sock
Message-ID: <20210419084953.GA28564@amd>
References: <20210412162401.314035-1-sashal@kernel.org>
 <20210412162401.314035-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20210412162401.314035-41-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Aditya Pakki <pakki001@umn.edu>
>=20
> [ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]
>=20
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.

This patch is crazy. It adds dead code.

> +++ b/net/rds/message.c
> @@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
>  		rds_message_purge(rm);
> =20
>  		kfree(rm);
> +		rm =3D NULL;
>  	}
>  }

We are already exiting function, changing local variable has no
effect.

> +++ b/net/rds/send.c
> @@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_hea=
d *messages, int status)
>  unlock_and_drop:
>  		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
>  		rds_message_put(rm);
> -		if (was_on_sock)
> +		if (was_on_sock && rm)
>  			rds_message_put(rm);
>  	}

If rm was non-NULL calling first rds_message_put (and it was,
otherwise we oopsed), it is still non-NULL in second test.

Best regards,
								Pavel
--=20
'DENX Software Engineering GmbH,      Managing Director:    Wolfgang Denk'
'HRB 165235 Munich, Office: Kirchenstr.5, D-82194	Groebenzell, Germany'
=09

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmB9RDEACgkQMOfwapXb+vKCKACfbFn3RnqNFYdhDT2ym9rSlQMQ
StcAoIdChJp23cIYf3KpweMUNitHrXv+
=4aJ2
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

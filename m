Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528784F44D
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfFVIUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 04:20:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38002 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfFVIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 04:20:14 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 570E080642; Sat, 22 Jun 2019 10:20:01 +0200 (CEST)
Date:   Sat, 22 Jun 2019 10:20:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     pavel@ucw.cz
Cc:     linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.19 10/61] sctp: Free cookie before we memdup a new one
Message-ID: <20190622082011.GB10751@amd>
References: <20190620174336.357373754@linuxfoundation.org>
 <20190620174339.137345137@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20190620174339.137345137@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Thu 2019-06-20 19:57:05, Greg Kroah-Hartman wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
>=20
> [ Upstream commit ce950f1050cece5e406a5cde723c69bba60e1b26 ]
>=20
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
>=20

> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2600,6 +2600,8 @@ do_addr_param:
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len =3D
>  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> +		if (asoc->peer.cookie)
> +			kfree(asoc->peer.cookie);
>  		asoc->peer.cookie =3D kmemdup(param.cookie->body, asoc->peer.cookie_le=
n, gfp);
>  		if (!asoc->peer.cookie)
>  			retval =3D 0;

kfree() handles NULL just fine. Can we simply work without the tests
and save a bit of code?

										Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0N5LsACgkQMOfwapXb+vKzkQCdEGUbym7/n2RmW+fQBeeRoSLv
TGcAoIyIhzIRz7hHml13X+PxkMaLBu7y
=iJff
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--

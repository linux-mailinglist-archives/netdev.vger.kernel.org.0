Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7424DE873D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfJ2Lfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:35:54 -0400
Received: from cache12.mydevil.net ([128.204.216.223]:28450 "EHLO
        cache12.mydevil.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbfJ2Lfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:35:54 -0400
From:   michal.lyszczek@bofc.pl
Date:   Tue, 29 Oct 2019 12:35:50 +0100
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] libnetlink.c, ss.c: properly handle fread()
 error
Message-ID: <20191029113550.fax6b4hmbhutciwx@c-ml-p3510.redembedded.pl>
References: <20191024212001.7020-1-michal.lyszczek@bofc.pl>
 <20191028212128.1b8c5054@hermes.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qt2pijgyhjquszvj"
Content-Disposition: inline
In-Reply-To: <20191028212128.1b8c5054@hermes.lan>
User-Agent: NeoMutt/20180716
X-AV-Check: Passed
X-System-Sender: michal.lyszczek@bofc.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qt2pijgyhjquszvj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Stephen,
On 2019-10-28 21:21:28, Stephen Hemminger wrote:
> On Thu, 24 Oct 2019 23:20:01 +0200
> Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl> wrote:
>
> > fread(3) returns size_t data type which is unsigned, thus check
> > `if (fread(...) < 0)' is always false. To check if fread(3) has
> > failed, user should check if return is 0 and then check error
> > indicator with ferror(3).
>
> You did find something that probably has been broken for a long time.
>
> First off, not sure why libnetlink is using fread here anyway.
> It adds another copy to all I/O which can matter with 1M routes.

I don't this is a problem. Of course, this could be optimized with read(2)
but these functions are (or at least I think they are) called very rarely.
Optimal solution with read(2) will surely be much more complex than using
fread(3). I'm not sure if minor performance gain is worth bigger complexity.

> Also the man page for fread() implies that truncated reads (not
> just zero) can happen on error. Better to check that full read was
> completed or at least a valid netlink header?

Yes, you are right, I must have missed that. I've changed patch to
take this into account. I think, since this code parses precise binary
data, each call to fread(3) should return exact ammount of bytes as
what was requested as reading less then expected could lead to corrupt
read later anyway.

For example if `l =3D 3' and `NLMSG_ALIGN(l) =3D=3D 4' doing

    status =3D fread(NLMSG_DATA(h), 1, NLMSG_ALIGN(l), rtnl);
    if (status < l)
        error;

Will result in error when fread(3) returns 3 bytes (and error), as
this will move stream pointer by 3 bytes instead of 4, and next
call to fread(3) will first read last DATA byte and then header
bytes, which will result in corrupted header and possible misleading
error later in execution - I belive errors should be reported as
soon as possible.


Please review newly attached patch (in another mail).

--=20
=2E-----------------.-------------------.---------------------.------------=
------.
| Michal Lyszczek | Embedded C, Linux |   Company Address   |  .-. open sou=
rce |
| +48 727 564 419 | Software Engineer | Leszczynskiego 4/29 |  oo|  support=
er  |
| https://bofc.pl `----.--------------: 50-078 Wroclaw, Pol | /`'\      &  =
    |
| GPG FF1EBFE7E3A974B1 | Bits of Code | NIP:  813 349 58 78 |(\_;/) program=
er  |
`----------------------^--------------^---------------------^--------------=
----'

--qt2pijgyhjquszvj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE75TheM5OqeB/xDzA/x6/5+OpdLEFAl24JAwACgkQ/x6/5+Op
dLEHNQf+PYOQtZCLi4b2vRxZuZebl7gGhsKZO5HSfO+4wq4JzoyKsnTlZmLrE+7p
p9hSNmGVgJTYWj1OwIOZQRUG/NVrtWjazIaFp0HN2fjwWkTuAc3h8DEmSqNwWVK3
OHmF+Bn15fM6tsz9Ow8ZmQy5RV3iSjP6vLU6sNcaDAeqHRTYHPhDAwKs7HO6KE+A
YX+CDYYkf795oDa86bGkR40SX0yvlWI3DfM9OHQT/Rc/2tgwQshLK1NTA4+UEIQB
2+Wpz/FHvVMVA/XO8fP6cr6Sz0d0IXznkMcHjCb+qwHFEyHN+JIqCi9JlUfG9Eb2
m6DrV9ROi0vABGPLWNyewdOB8Yn4Og==
=sRAF
-----END PGP SIGNATURE-----

--qt2pijgyhjquszvj--

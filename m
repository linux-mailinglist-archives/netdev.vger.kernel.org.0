Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF894235987
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgHBRti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 13:49:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49458 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgHBRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 13:49:38 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2I72-0000ZA-2O; Sun, 02 Aug 2020 18:49:32 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2I71-000hRv-IY; Sun, 02 Aug 2020 18:49:31 +0100
Message-ID: <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>
Subject: Re: Bug#966459: linux: traffic class socket options (both
 IPv4/IPv6) inconsistent with docs/standards
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Thorsten Glaser <tg@mirbsd.de>, 966459@bugs.debian.org
Cc:     netdev <netdev@vger.kernel.org>
Date:   Sun, 02 Aug 2020 18:49:26 +0100
In-Reply-To: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-j2nqJ8CckHMlJHKjRxx/"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-j2nqJ8CckHMlJHKjRxx/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[The previous message is archived at <https://bugs.debian.org/966459>.]

On Tue, 2020-07-28 at 20:31 +0200, Thorsten Glaser wrote:
> Package: src:linux
> Version: 5.7.6-1
> Severity: normal
> Tags: upstream
> X-Debbugs-Cc: tg@mirbsd.de
>=20
> I=E2=80=99m using setsockopt to set the traffic class on sending and rece=
ive
> it in control messages on receiving, for both IPv4 and IPv6.
>=20
> The relevant documentation is the ip(7) manpage and, because the ipv6(7)
> manpage doesn=E2=80=99t contain it, RFC3542.

ip(7) also doesn't document IP_PKTOPIONS.

[...]
> Same in net/ipv4/ip_sockglue.c=E2=80=A6
>=20
>                         int tos =3D inet->rcv_tos;
>                         put_cmsg(&msg, SOL_IP, IP_TOS, sizeof(tos), &tos)=
;
> =E2=80=A6 in one place, but=E2=80=A6
>=20
>         put_cmsg(msg, SOL_IP, IP_TOS, 1, &ip_hdr(skb)->tos);
>=20
> =E2=80=A6 in ip_cmsg_recv_tos(), yielding inconsistent results for IPv4(!=
).

Those are two different APIs though: recvmsg() for datagram sockets, vs
getsockopt(... IP_PKTOPTIONS ...) for stream sockets.  They obviously
ought to be consistent, but mistakes happen.

[...]
> tl;dr: Receiving traffic class values from IP traffic is broken on
> big endian platforms.

Some user-space that uses getsockopt(... IP_PKTOPTIONS ...) for stream
sockets might be broken.

I searched for 'cmsg_type.*IP_TOS' on codesearch.debian.net, and found
only two instances where it was used in conjunction with IP_PKTOPTIONS.

libzorpll reads only the first byte (so is broken on big-endian):
https://sources.debian.org/src/libzorpll/7.0.1.0%7Ealpha1-1.1/src/io.cc/#L2=
39

squid reads an int and then truncates it to a byte (so is fine):
https://sources.debian.org/src/squid/4.12-1/src/ip/QosConfig.cc/#L41

> I place the following suggestion for discussion, to achieve maximum
> portability: put 4 bytes into the CMSG for both IPv4 and IPv6, where
> the first and fourth byte are, identically, traffic class, second and
> third 0.
[...]

I see no point in changing the IPv6 behaviour: it seems to be
consistent with itself and with the standard, so only risks breaking
user-space that works today.

As for IPv4, changing the format of the IP_TOS field in the
IP_PKTOPIONS value looks like it would work for the two users found in
Debian.

But you should know that the highest priority for Linux API
compatibility is to avoid breaking currently working user-space.  That
means that ugly and inconsistent APIs won't get fixed if it causes a
regression for the programs people actually use.  If the API never
worked like it was supposed to on some architectures, that's not a
regression, and is lower priority.

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program
than to understand a correct one.


--=-j2nqJ8CckHMlJHKjRxx/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl8m/KYACgkQ57/I7JWG
EQma7g//UH4c5onG2CPmXpCx6+SI4/jR3lZV0+V20moyfM29MJkgSkmsjYO45YI5
R0F4yshvtQuDzOEGNAvnC6RldeE4kXkun68qg0WC9r9bs5qYNjPMgbaziy0UVzd8
Dmz2fuIDFjJoUn3XqhzWBMwzwoH+Lpvlo88wwHoY6b8nbTyxXMd1XLv7eCVTNu5M
hFsJxBqUhUiHhoedN360exsHU2pVWYkvjpBrDmOPFF0afUZKx9V+O3a51W1AsCaB
U2hZI1BK7V4osffB1wQDiAkfHWABSgymZUE+XdYZfCoCQ0P2WZlvBrBvZveLzmOr
0YaVrBIts9HOHzfHhY7EyrRBZppiqHbtd6OhqeAlkLyorpr60YHz5Ozo0fB4XZfX
pNoKkWdYMVHN5EPxQ8hzsSWHu7se8oGs5vwyGgs56Zgxw7XAkoj68KPkDirFE8mP
pYwND3rE8oYovnNwUy1bCKKbNBBJMhIJP/f59gFzOrElHXfKXVlzoNdEI6lymC6o
DjaDtsbLQ0fwt3IfN8NM7rEZlWPm8zfOT8piuiZPM8H+l6d/wgHnekCN0Qfed4wy
18zA/VE2rmrqPvAlNRm/cEy7iVISEAxVuKbFOy929dN6VFaCeVUIwi03TSpB9j5J
1gH3T834zUFW+GEtXNX24k5MxZJLH2adZJfklPzMzDgRITKF5nU=
=eZmr
-----END PGP SIGNATURE-----

--=-j2nqJ8CckHMlJHKjRxx/--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1F1411A7
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 20:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAQT3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 14:29:15 -0500
Received: from mail.katalix.com ([3.9.82.81]:39654 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgAQT3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 14:29:14 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id EADFF86ACB;
        Fri, 17 Jan 2020 19:29:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579289353; bh=PiPRprrYy5Fh3VJtFZnizSBCkW/pmHwYqHM8xJ13E4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGbsGTYaSDj3jhZ4PhZSmq5rsg6OtNp0fFDuGd/YtjAZ9xWraUVu5+5K3KJlUIB1d
         A64YQdwfuRaIU7sXyMYzeu1rYyrPx6d7qfToqx7Jfks6ea4rrBk8se3mJ8MjFbhO+V
         NzpU/E5u3UF6UxxNmry1n3LU0FnWn6AxaqVYYasQ03XfirE4bbjF46kWCW6BSjJ+9N
         7rxfdNfwnrduGwV3OUew06QLXD1coctCBWRKlbrDoXH4Oc91JxikpND/ILkRb85feQ
         ImNh52Oi4ZR6J0z6W7fMV/mScdDTBuVJLd+CFQ5XhHHXiwHK8x2yk89P2xoV3eamI+
         md/x9KnD/WkjQ==
Date:   Fri, 17 Jan 2020 19:29:12 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117192912.GB19201@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <20200117163627.GC2743@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20200117163627.GC2743@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 17, 2020 at 17:36:27 +0100, Guillaume Nault wrote:
> On Thu, Jan 16, 2020 at 09:23:32PM +0000, Tom Parkin wrote:
> > On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> > > What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 modu=
le
> > > is loaded, a peer can reach whatever L2TPv3 session exists on the host
> > > just by sending an L2TP_IP packet to it.
> > > I don't know how practical it is to exploit this fact, but it looks
> > > like it's asking for trouble.
> >=20
> > Yes, I agree, although practically it's only a slightly easier
> > "exploit" than L2TP/UDP offers.
> >=20
> > The UDP case requires a rogue packet to be delivered to the correct
> > socket AND have a session ID matching that of one in the associated
> > tunnel.
> >=20
> > It's a slightly more arduous scenario to engineer than the existing
> > L2TPv3/IP case, but only a little.
> >=20
> In the UDP case, we have a socket connected to the peer (or at least
> bound to a local address). That is, some local setup is needed. With
> l2tp_ip, we don't even need to have an open socket. Everything is
> triggered remotely. And here, "remotely" means "any host on any IP
> network the LCCE is connected", because the destination address can
> be any address assigned to the LCCE, even if it's not configured to
> handle any kind of L2TP. But well, after thinking more about our L2TPv3
> discussiong, I guess that's how the designer's of the protocol wanted.

I note that RFC 3931 provides for a cookie in the data packet header
to mitigate against data packet spoofing (section 8.2).

More generally I've not tried to see what could be done to spoof
session data packets, so I can't really comment further.  It would be
interesting to try spoofing packets and see if the kernel code could
do more to limit any potential problems.

> > > > For normal operation, you just need to get the wrong packet on the
> > > > wrong socket to run into trouble of course.  In such a situation
> > > > having a unique session ID for v3 helps you to determine that
> > > > something has gone wrong, which is what the UDP encap recv path does
> > > > if the session data packet's session ID isn't found in the context =
of
> > > > the socket that receives it.
> > > Unique global session IDs might help troubleshooting, but they also
> > > break some use cases, as reported by Ridge. At some point, we'll have
> > > to make a choice, or even add a knob if necessary.
> >=20
> > I suspect we need to reach agreement on what RFC 3931 implies before
> > making headway on what the kernel should ideally do.
> >=20
> > There is perhaps room for pragmatism given that the kernel
> > used to be more permissive prior to dbdbc73b4478, and we weren't
> > inundated with reports of session ID clashes.
> >=20
> To summarise, my understanding is that global session IDs would follow
> the spirit of RFC 3931 and would allow establishing multiple L2TPv3
> connections (tunnels) over the same 5-tuple (or 3-tuple for IP encap).
> Per socket session IDs don't, but would allow fixing Ridge's case.

I'm not 100% certain what "per socket session IDs" means here.  Could
you clarify?

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4iCwgACgkQlIwGZQq6
i9CrQQgApwH89lI+FW64vXejCOC+fHjobX/jvhBMMrcfFa9LPdzhJKpscQDaRd4I
DK7tfcS/u91QhymXKdKX+XhxZirBjCyN6KzHpYvwdnZBBEjEjTKdV6lKYsqE1VE8
yU7yNf/F0NPcb/8m7EzOxGvrPAAS7BdbBvZbKQHgcSmzLa35xdrKM57rz7tVQAtM
osHRsHyOtAjcP7IRhvVwW7xN8LL6ZGXvuYHDbHEaxoBvg8vaCzgzT+YbkP7aWTu5
TITqgc6pbOPDyS8VrK3mdQD9kg3k9NWi0VPq4Exx1o/e6ahpibRvkxMxhNditu2a
6IESDRieSvkyfc0iJhqutEydN68R2g==
=+hqq
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--

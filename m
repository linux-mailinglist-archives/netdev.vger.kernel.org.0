Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A084E14118E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 20:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgAQTTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 14:19:41 -0500
Received: from mail.katalix.com ([3.9.82.81]:39568 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbgAQTTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 14:19:41 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7401886AB4;
        Fri, 17 Jan 2020 19:19:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579288779; bh=74vpcKE0MXpHMmWegpI222oNfdU/BelAhJvUgkL9FI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0pkaZ+tj2K1RJhY5A6ypVj2eVRjCpd/Wfe1igiogFoEisHFaq6sF7qZHl8V0iLdqF
         id2AZnGP+LqHhD5pJj0gxjtugsbuqXPti4kxHS/BX77M3vWh4oQuLE7iiPHsdNqIY4
         yKAA1sdoBK5PJ4Ccm8rwlEAG8ZC3kkLNIasCSET7ZTuFn5HiBTB5fvvJTBf8Gxfzef
         L3ekmn0KGZU3jHlDlYQ3b9najAnB+54Xdh+CbUF3gcN4PMuHR5ibHhjGeV6frnoyKY
         s3gTefv8pf8RsYvEuj1MbB+/uZOX8wC4aDi6gzJON44HZ6pWw6UCKLcgK74ZLAlOYP
         mPPB1PApSpzDg==
Date:   Fri, 17 Jan 2020 19:19:39 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117191939.GB3405@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20200117142558.GB2743@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 17, 2020 at 15:25:58 +0100, Guillaume Nault wrote:
> On Fri, Jan 17, 2020 at 01:18:49PM +0000, Tom Parkin wrote:
> > More generally, for v3 having the session ID be unique to the LCCE is
> > required to make IP-encap work at all.  We can't reliably obtain the
> > tunnel context from the socket because we've only got a 3-tuple
> > address to direct an incoming frame to a given socket; and the L2TPv3
> > IP-encap data packet header only contains the session ID, so that's
> > literally all there is to work with.
> >=20
> I don't see how that differs from the UDP case. We should still be able
> to get the corresponding socket and lookup the session ID in that
> context. Or did I miss something? Sure, that means that the socket is
> the tunnel, but is there anything wrong with that?

It doesn't fundamentally differ from the UDP case.

The issue is that if you're stashing tunnel context with the socket
(as UDP currently does), then you're relying on the kernel's ability
to deliver packets for a given tunnel on that tunnel's socket.

In the UDP case this is normally easily done, assuming each UDP tunnel
socket has a unique 5-tuple address.  So if peers allow the use of
ports other than port 1701, it's normally not an issue.

However, if you do get a 5-tuple clash, then packets may start
arriving on the "wrong" socket.  In general this is a corner case
assuming peers allow ports other than 1701 to be used, and so we don't
see it terribly often.

Contrast this with IP-encap.  Because we don't have ports, the 5-tuple
address now becomes a 3-tuple address.  Suddenly it's quite easy to
get a clash: two IP-encap tunnels between the same two peers would do
it.

Since we don't want to arbitrarily limit IP-encap tunnels to on per
pair of peers, it's not practical to stash tunnel context with the
socket in the IP-encap data path.

> > If we relax the restriction for UDP-encap then it fixes your (Ridge's)
> > use case; but it does impose some restrictions:
> >=20
> >  1. The l2tp subsystem has an existing bug for UDP encap where
> >  SO_REUSEADDR is used, as I've mentioned.  Where the 5-tuple address of
> >  two sockets clashes, frames may be directed to either socket.  So
> >  determining the tunnel context from the socket isn't valid in this
> >  situation.
> >=20
> >  For L2TPv2 we could fix this by looking the tunnel context up using
> >  the tunnel ID in the header.
> >=20
> >  For L2TPv3 there is no tunnel ID in the header.  If we allow
> >  duplicated session IDs for L2TPv3/UDP, there's no way to fix the
> >  problem.
> >=20
> >  This sounds like a bit of a corner case, although its surprising how
> >  many implementations expect all traffic over port 1701, making
> >  5-tuple clashes more likely.
> >=20
> Hum, I think I understand your scenario better. I just wonder why one
> would establish several tunnels over the same UDP or IP connection (and
> I've also been surprised by all those implementations forcing 1701 as
> source port).
>

Indeed, it's not ideal :-(

> >  2. Part of the rationale for L2TPv3's approach to IDs is that it
> >  allows the data plane to potentially be more efficient since a
> >  session can be identified by session ID alone.
> > =20
> >  The kernel hasn't really exploited that fact fully (UDP encap
> >  still uses the socket to get the tunnel context), but if we make
> >  this change we'll be restricting the optimisations we might make
> >  in the future.
> >=20
> > Ultimately it comes down to a judgement call.  Being unable to fix
> > the SO_REUSEADDR bug would be the biggest practical headache I
> > think.
> And it would be good to have a consistent behaviour between IP and UDP
> encapsulation. If one does a global session lookup, the other should
> too.

That would also be my preference.

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4iCMYACgkQlIwGZQq6
i9B3Gwf/YTLDKkbhsENqDYa3tTBrno9kF4cjhlvObw5y4gYwHZrsJo96PmpVwy9M
qzGWuqRwETHGhLmvfBc3mfQL9XRmjFn7jTAF9ZwxThOYRwQ9I+KoPI8apCHxkqzR
IoroJHIr5M5J4Jw+jhUqVzlFeo4eW2NFbrw3JqwDauKj58iTBZ4k/WpOIoZWRi5D
HWQRuCPWyBtGD0MvvYJ7b6oEq2+fsvfjl/AvPGSXmW3ps1MFfL6CojVGrea4eMDt
EubCSs0S5CWzokkA1q0p8a5Lr3lul4DDW0UYVrMGLkIvPLCliKDg8b0cua+KvO0q
0FVhuNh6qGvaPMVBMVnxgwyQ7GRYUA==
=3SWH
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--

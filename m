Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C836142E6B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgATPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 10:09:48 -0500
Received: from mail.katalix.com ([3.9.82.81]:44428 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgATPJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 10:09:48 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 99DB08CBAC;
        Mon, 20 Jan 2020 15:09:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579532986; bh=W2QJqJHggYIMIw2brtYq8dDRq3MGpgOyKozTNoobxlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DRrlSr2eLtn2GqGzhCv7Wxk9Iu2U3vdqiEkDEwllnUUhTd4zHzZAfV3yzUkXFyR2r
         dQEZv3AkNP+Lrr9yz7Mhe2TZTwhHVEkMU+8TLtSDW+fhoZCuMPov85liUZvvdFNc/E
         XRL8tNQV3IjTkxfZPgm+CWwfzfR0EahsqDXIn0evB8izOnN3Ldl7SDSHaQoTb286+O
         +AgzmFJiasbLcAejuZWzNrdbDI11ViJhHetetN82TbGBBipc8kwjDExBuow53Ow/p/
         O2fFHnJFwKD2aFrVNVJGMgmgEUuMMZveNMCjOnwhvOMWwX9nZrNR97eCmBxzOOljFC
         LRGz7MmZNtuUQ==
Date:   Mon, 20 Jan 2020 15:09:46 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200120150946.GB4142@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <20200118191336.GC12036@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sat, Jan 18, 2020 at 20:13:36 +0100, Guillaume Nault wrote:
> On Fri, Jan 17, 2020 at 07:19:39PM +0000, Tom Parkin wrote:
> > On  Fri, Jan 17, 2020 at 15:25:58 +0100, Guillaume Nault wrote:
> > > On Fri, Jan 17, 2020 at 01:18:49PM +0000, Tom Parkin wrote:
> > > > More generally, for v3 having the session ID be unique to the LCCE =
is
> > > > required to make IP-encap work at all.  We can't reliably obtain the
> > > > tunnel context from the socket because we've only got a 3-tuple
> > > > address to direct an incoming frame to a given socket; and the L2TP=
v3
> > > > IP-encap data packet header only contains the session ID, so that's
> > > > literally all there is to work with.
> > > >=20
> > > I don't see how that differs from the UDP case. We should still be ab=
le
> > > to get the corresponding socket and lookup the session ID in that
> > > context. Or did I miss something? Sure, that means that the socket is
> > > the tunnel, but is there anything wrong with that?
> >=20
> > It doesn't fundamentally differ from the UDP case.
> >=20
> > The issue is that if you're stashing tunnel context with the socket
> > (as UDP currently does), then you're relying on the kernel's ability
> > to deliver packets for a given tunnel on that tunnel's socket.
> >=20
> > In the UDP case this is normally easily done, assuming each UDP tunnel
> > socket has a unique 5-tuple address.  So if peers allow the use of
> > ports other than port 1701, it's normally not an issue.
> >=20
> > However, if you do get a 5-tuple clash, then packets may start
> > arriving on the "wrong" socket.  In general this is a corner case
> > assuming peers allow ports other than 1701 to be used, and so we don't
> > see it terribly often.
> >=20
> > Contrast this with IP-encap.  Because we don't have ports, the 5-tuple
> > address now becomes a 3-tuple address.  Suddenly it's quite easy to
> > get a clash: two IP-encap tunnels between the same two peers would do
> > it.
> >=20
> Well, the situation is the same with UDP, when the peer always uses
> source port 1701, which is a pretty common case as you noted
> previously.

Yes, it's the same situation as the UDP case; it's just much easier to
hit with IP encapsulation.

> I've never seen that as a problem in practice since establishing more
> than one tunnel between two LCCE or LAC/LNS doesn't bring any
> advantage.

I think the practical use depends a bit on context -- it might be
useful to e.g. segregate sessions with different QoS or security
requirements into different tunnels in order to make userspace
configuration management easier.

> > Since we don't want to arbitrarily limit IP-encap tunnels to on per
> > pair of peers, it's not practical to stash tunnel context with the
> > socket in the IP-encap data path.
> >=20
> Even though l2tp_ip doesn't lookup the session in the context of the
> socket, it is limitted to one tunnel for a pair of peers, because it
> doesn't support SO_REUSEADDR and SO_REUSEPORT.

This isn't the case.  It is indeed possible to create multiple IP-encap
tunnels between the same IP addresses.

l2tp_ip takes tunnel ID into account in struct sockaddr_l2tpip when
binding and connecting sockets.

I think if l2tp_ip were to support SO_REUSEADDR, it would be in the
context of struct sockaddr_l2tpip.  In which case reusing the address
wouldn't really make any sense.

> > > > If we relax the restriction for UDP-encap then it fixes your (Ridge=
's)
> > > > use case; but it does impose some restrictions:
> > > >=20
> > > >  1. The l2tp subsystem has an existing bug for UDP encap where
> > > >  SO_REUSEADDR is used, as I've mentioned.  Where the 5-tuple addres=
s of
> > > >  two sockets clashes, frames may be directed to either socket.  So
> > > >  determining the tunnel context from the socket isn't valid in this
> > > >  situation.
> > > >=20
> > > >  For L2TPv2 we could fix this by looking the tunnel context up using
> > > >  the tunnel ID in the header.
> > > >=20
> > > >  For L2TPv3 there is no tunnel ID in the header.  If we allow
> > > >  duplicated session IDs for L2TPv3/UDP, there's no way to fix the
> > > >  problem.
> > > >=20
> > > >  This sounds like a bit of a corner case, although its surprising h=
ow
> > > >  many implementations expect all traffic over port 1701, making
> > > >  5-tuple clashes more likely.
> > > >=20
> > > Hum, I think I understand your scenario better. I just wonder why one
> > > would establish several tunnels over the same UDP or IP connection (a=
nd
> > > I've also been surprised by all those implementations forcing 1701 as
> > > source port).
> > >
> >=20
> > Indeed, it's not ideal :-(
> >=20
> > > >  2. Part of the rationale for L2TPv3's approach to IDs is that it
> > > >  allows the data plane to potentially be more efficient since a
> > > >  session can be identified by session ID alone.
> > > > =20
> > > >  The kernel hasn't really exploited that fact fully (UDP encap
> > > >  still uses the socket to get the tunnel context), but if we make
> > > >  this change we'll be restricting the optimisations we might make
> > > >  in the future.
> > > >=20
> > > > Ultimately it comes down to a judgement call.  Being unable to fix
> > > > the SO_REUSEADDR bug would be the biggest practical headache I
> > > > think.
> > > And it would be good to have a consistent behaviour between IP and UDP
> > > encapsulation. If one does a global session lookup, the other should
> > > too.
> >=20
> > That would also be my preference.
> >=20
> Thinking more about the original issue, I think we could restrict the
> scope of session IDs to the 3-tuple (for IP encap) or 5-tuple (for UDP
> encap) of its parent tunnel. We could do that by adding the IP addresses,
> protocol and ports to the hash key in the netns session hash-table.
> This way:
>  * Sessions would be only accessible from the peer with whom we
>    established the tunnel.
>  * We could use multiple sockets bound and connected to the same
>    address pair, and lookup the right session no matter on which
>    socket L2TP messages are received.
>  * We would solve Ridge's problem because we could reuse session IDs
>    as long as the 3 or 5-tuple of the parent tunnel is different.
>=20
> That would be something for net-next though. For -net, we could get
> something like Ridge's patch, which is simpler, since we've never
> supported multiple tunnels per session anyway.

Yes, I think this would be possible.  I've been thinking of similar
schemes.

I'm struggling with it a bit though.  Wouldn't extending the hash key
like this get expensive, especially for IPv6 addresses?

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4lwrYACgkQlIwGZQq6
i9DC6AgAwfFpTB++6XwcWL1M4HTV9f289oHqpanipCr5Ih0oCpWhiL30CUjdD9dk
OCzqr5laPI8El5axvi5dKsv+1Y3AxSHO3ZcqxZQkV5KEykICpgeEzOWBU3cGBCgG
H5k374Y5OmfCMmtQ4LkP0LI4Okadm6DrurnwWk46XVdDGuFECM0sRxVeZ0jRAcL8
mCWv+rV4C8dbU0+y99V4yg+B+kL+hK7HfNOeO/kA4ckhi1gboGMF/g7Jgs8Dsbzh
KuGTIrvF3yklpndv/XEKL9S74oLMDqRE28FbpAsm5/a5RVoEwLnpPX1rZP38dVAX
kXy94PveL/rEyPRCconhwvh/8QcZog==
=GdM2
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--

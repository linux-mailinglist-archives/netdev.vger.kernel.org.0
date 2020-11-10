Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912862AD5A8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgKJLyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgKJLyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:54:12 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 193D3C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 03:54:11 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8C6E296F03;
        Tue, 10 Nov 2020 11:54:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605009247; bh=ILXLth3gfywTDkFVjmYEDmocoD96L4uZHn6DVSWP41c=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2010=20Nov=202020=2011:54:07=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[RFC=20PATCH=200/2]=20add=20ppp_generic=20ioctl=20to
         =20bridge=20channels|Message-ID:=20<20201110115407.GA5635@katalix.
         com>|References:=20<20201106181647.16358-1-tparkin@katalix.com>=0D
         =0A=20<20201109225153.GL2366@linux.home>|MIME-Version:=201.0|Conte
         nt-Disposition:=20inline|In-Reply-To:=20<20201109225153.GL2366@lin
         ux.home>;
        b=055yjn9CpwN4sOOmbDjlobwrKy6uA87p0dtr0h3czYGU+66TMo3P/cgpPV3F6XZl+
         V6wxRB/zJdmGeKCk9Ua+xOZfgzRw7LrnvF/EfcPmFBgiY7gA+4oQimjkyNRCkd+g7n
         h99kmvs+vGjet5BaO5raoBbyGKLmk26rjKwUIkzt+lLlsjasCV3uCSCaZeLBL4Nqj3
         J5E+t+CClI2ZtPx6W3xnGVBNJrCobOJl3lyIKPa3diWZn6nyXWEopvliVD3ce0DLXv
         q2AQXTTTNr0vK8Lpv3PmhR5X93law8FlUpyWNfMkD253TKgzgpcexk9H5gkOeUmpgz
         wcV7mOPVM7RUw==
Date:   Tue, 10 Nov 2020 11:54:07 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201110115407.GA5635@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109225153.GL2366@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20201109225153.GL2366@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Nov 09, 2020 at 23:51:53 +0100, Guillaume Nault wrote:
> >  * I believe that the fact we're not explicitly locking anything in the
> >    ppp_input path for access to the channel bridge field is OK since:
> >   =20
> >     - ppp_input is called from the socket backlog recv
> >=20
> >     - pppox_unbind (which calls ppp_channel_unregister, which unsets the
> >       channel bridge field) is called from the socket release
> >=20
> >    As such I think the bridge pointer cannot change in the recv
> >    path since as the pppoe.c code says: "Semantics of backlog rcv
> >    preclude any code from executing in lock_sock()/release_sock()
> >    bounds".
>=20
> But ppp_input() is used beyond pppoe. For example, I'm pretty sure these
> pre-conditions aren't met for L2TP (pppol2tp_recv() processes packets
> directly, packets aren't queued by sk_receive_skb()).

Yes, that's true.  I was basing my assumption on the fact that the
l2tp/pppox recv path made similar checks to those in in pppoe.c, e.g.
sk_state.

I take your point more widely though: ppp_input is used by multiple
pppox drivers, so it probably makes more sense to protect the bridge
with a lock than rely on the driver implementation(s) all behaving in
the same way.

> To avoid locking the channel bridge in the data path, you can protect
> the pointer with RCU.

Ack, I'll look at doing so.

> >  * When userspace makes a PPPIOCBRIDGECHAN ioctl call, the channel the
> >    ioctl is called on is updated to point to the channel identified
> >    using the index passed in the ioctl call.
> >=20
> >    As such, allow PPP frames to pass in both directions from channel A
> >    to channel B, userspace must call ioctl twice: once to bridge A to B,
> >    and once to bridge B to A.
> >=20
> >    This approach makes the kernel coding easier, because the ioctl
> >    handler doesn't need to do anything to lock the channel which is
> >    identified by index: it's sufficient to find it in the per-net list
> >    (under protection of the list lock) and take a reference on it.
> >=20
> >    The downside is that userspace must make two ioctl calls to fully set
> >    up the bridge.
>=20
> That's probably okay, but that'd allow for very strange setups, like
> channel A pointing to channel B and channel B being used by a PPP unit.
> I'd prefer to avoid having to think about such scenarios when reasoning
> about the code.

Good point about the cognitive load.  I agree with you there.

> I think that the channel needs to be locked anyway to safely modify the
> bridge pointer. So the "no lock needed" benefit of the 2 ioctl calls
> approach doesn't seem to stand.

Agreed.

> BTW, shouldn't we have an "UNBRIDGE" command to remove the bridge
> between two channels?

I'm not sure of the usecase for it to be honest.  Do you have
something specific in mind?


Thanks very much for your review and comments, it's much appreciated
:-)

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+qf1oACgkQlIwGZQq6
i9C4iAgAgOzoZRqRnnjlygr6f9XzBXXr5Mvaw9GafY7xw4dX2VmlTw8DLYSlcImJ
avYmmAvDFCuS5zBeoQWV/nbb0gdzgIJLJ2ri4wYEcLKcxo6Qgyn/mfplLB7Lnxc6
1UUV1Dfjngeia4P+xlgTCnD+DOh0Ssa8M9du1gE0cljWy/mtncxrem+91POLsF8H
7SvgrX8OAEjzkWrJKDwTwzWonHCNy9yd2gvajF9QHeEa/2/FQ4Ey0xG/zkS6kzzh
2rIZr6Zx1JXLp65tVpKWphuHt32ww9QqnCDJpJPv8QPYLO+Xa0fQZAkqpAOSJ68l
2VW5jjGL0hJjtQaHbyvrxXbWatEAvw==
=YHuN
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--

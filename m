Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5356F13FAFC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgAPVFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:05:04 -0500
Received: from mail.katalix.com ([3.9.82.81]:56580 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgAPVFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 16:05:03 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7105688CD2;
        Thu, 16 Jan 2020 21:05:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579208702; bh=aij7XRu9ifgN26D8wTAVZfer/bKRfc4WSDzPY+pqWdQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reS2IA7ot+bGBacsRKzHp0cly36gdH3dkBTfJ7Semk6c4fu5fVuT6ZNNAci0TLMvh
         djMqxbisJhZxp4XQsmz2KrQUIhfkFcUa1P3vAzTzO/t5qwoYODUqFXSD5kbd8vg7GA
         ABnrnOAj0wHKK8IAXypg4HSjJejwwpJRV/Hi0DHWrGxXYWDWDWNT1vZ6ZB7xpDfCD1
         NBnYO9Zoxd087y0U+rGa8qQcXsdpA0EK+foGR5nzCacM6GrOxwrjsbrNNR+Ju3QMD+
         IkXO7AYK4ja6eKsByMTAhSP99b2Viw+5Ftr3x2glDWGNz4OLVhaUsnvUnSqhcs4ZQv
         U2RPj5wG2QheA==
Date:   Thu, 16 Jan 2020 21:05:01 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116210501.GC4028@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123143.GA4028@jackdaw>
 <20200116192827.GB25654@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <20200116192827.GB25654@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Jan 16, 2020 at 20:28:27 +0100, Guillaume Nault wrote:
> On Thu, Jan 16, 2020 at 12:31:43PM +0000, Tom Parkin wrote:
> > However, there's nothing to prevent user space from using the same UDP
> > port for multiple tunnels, at which point this relaxation of the RFC
> > rules would break down again.
> >=20
> Multiplexing L2TP tunnels on top of non-connected UDP sockets might be
> a nice optimisation for someone using many tunnels (like hundred of
> thouthands), but I'm afraid the rest of the L2TP code is not ready to
> handle such load anyway. And the current implementation only allows
> one tunnel for each UDP socket anyway.

TBH I was thinking more of the case where multiple sockets are bound and
connected to the same address/port (SO_REUSEADDR).  There's still a
1:1 mapping of tunnel:socket, but it's possible to have packets for tunnel
A arrive on tunnel B's socket and vice versa.

It's a bit of a corner case, I grant you.

> > Since UDP-encap can also be broken in the face of duplicated L2TPv3
> > session IDs, I think its better that the kernel continue to enforce
> > the RFC.
> How is UDP-encap broken with duplicate session IDs (as long as a UDP
> socket can only one have one tunnel associated with it and that no
> duplicate session IDs are allowed inside the same tunnel)?
>=20
> It all boils down to what's the scope of a session ID. For me it has
> always been the parent tunnel. But if that's in contradiction with
> RFC 3931, I'd be happy to know.

For RFC 2661 the session ID is scoped to the tunnel.  Section 3.1
says:

  "Session ID indicates the identifier for a session within a tunnel."

Control and data packets share the same header which includes both the
tunnel and session ID with 16 bits allocated to each.  So it's always
possible to tell from the data packet header which tunnel the session is
associated with.

RFC 3931 changed the scheme.  Control packets now include a 32-bit
"Control Connection ID" (analogous to the Tunnel ID).  Data packets
have a session header specific to the packet-switching network in use:
the RFC describes schemes for both IP and UDP, both of which employ a
32-bit session ID.  Section 4.1 says:

  "The Session ID alone provides the necessary context for all further
  packet processing"

Since neither UDP nor IP encapsulated data packets include the control
connection ID, the session ID must be unique to the LCCE to allow
identification of the session.

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4gz/kACgkQlIwGZQq6
i9C7vAf/cZA7Gf9W5/0IleRuW3hQCBpmSbm/AGAy+WVzvONYRxzDOaGm1a4cJzdX
PVTrfa82Rlj0EfYstqMvAwf7HuUyi02Bpg8lFpddnvUDHDbqq6qmC/MFRVXP1tup
WNQ0wo10WSjqPOtrJPwo8Lle06FwBRFIOHyHPnb6buB/ZvpKXq3ILSP5v2xi9R/8
TCqS1qPwa5A4UtrzJWjR02BMv2DjQTwnyEDo9Kn/PEDLx5FOUUF0WikKkKK9UgKm
nHSibuBDYPQ+vbiADvQ6U5VQ7ebqVncu7sYhRlX6ZplZGFEKKcN7B7Eft26XBJTP
S0lUjViqr0WbeE0dwArqjwyuKLK2og==
=CeFi
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--

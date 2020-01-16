Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DBD13FB5C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgAPVXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:23:34 -0500
Received: from mail.katalix.com ([3.9.82.81]:56756 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbgAPVXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 16:23:34 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8C8447D148;
        Thu, 16 Jan 2020 21:23:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579209812; bh=ZBgjP9R0Bz2jMXNirC2gTAWqkAL4RSLOsYcWTiHVmm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OipzhoAeGy7jKROtLzDVvb7+XHu1Kjay+UvcmUwQmZFCkQbPR5J1dK7hdhnR95bjN
         qwvIQV6KTa83JrlohgA4Ha3qAB7LS6CE79PDTFt61wvWWfrhdb+Xr57tcpaMBuIO7m
         rmYeCksl95hPgEhxX5xxHQeI1gd8O+o2DxM27q0i9YN2JBzV6sC/nC5WWCHih9GZlt
         S2MgwJd85bNeJ6uHRxl7LfLZcQmvlDW8budY2ilJUjePCKTqnHXnSQ81Ds8jGPWpCr
         7gnXCHO041sz3mzZ9ttVM4vIsm6PjEaZFpdScJDANjwpagFF23ikaa8PZS8hWAVb6V
         5Xvmi4cpaxfag==
Date:   Thu, 16 Jan 2020 21:23:32 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116212332.GD4028@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <20200116190556.GA25654@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
> > I agree with you about the possibility for cross-talk, and I would
> > welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
> > ditch the global list.
> >=20
> > As per the RFC, for L2TPv3 the session ID should be a unique
> > identifier for the LCCE.  So it's reasonable that the kernel should
> > enforce that when registering sessions.
> >=20
> I had never thought that the session ID could have global significance
> in L2TPv3, but maybe that's because my experience is mostly about
> L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
> restricting the scope of sessions to their parent tunnel would conflict
> with the RFC.

Sorry Guillaume, I responded to your other mail without reading this
one.

I gave more detail in my other response: it boils down to how RFC 3931
changes the use of IDs in the L2TP header.  Data packets for IP or UDP
only contain the 32-bit session ID, and hence this must be unique to
the LCCE to allow the destination session to be successfully
identified.

> > When you're referring to cross-talk, I wonder whether you have in mind
> > normal operation or malicious intent?  I suppose it would be possible
> > for someone to craft session data packets in order to disrupt a
> > session.
> >=20
> What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
> is loaded, a peer can reach whatever L2TPv3 session exists on the host
> just by sending an L2TP_IP packet to it.
> I don't know how practical it is to exploit this fact, but it looks
> like it's asking for trouble.

Yes, I agree, although practically it's only a slightly easier
"exploit" than L2TP/UDP offers.

The UDP case requires a rogue packet to be delivered to the correct
socket AND have a session ID matching that of one in the associated
tunnel.

It's a slightly more arduous scenario to engineer than the existing
L2TPv3/IP case, but only a little.

I also don't know how practical this would be to leverage to cause
problems.

> > For normal operation, you just need to get the wrong packet on the
> > wrong socket to run into trouble of course.  In such a situation
> > having a unique session ID for v3 helps you to determine that
> > something has gone wrong, which is what the UDP encap recv path does
> > if the session data packet's session ID isn't found in the context of
> > the socket that receives it.
> Unique global session IDs might help troubleshooting, but they also
> break some use cases, as reported by Ridge. At some point, we'll have
> to make a choice, or even add a knob if necessary.

I suspect we need to reach agreement on what RFC 3931 implies before
making headway on what the kernel should ideally do.

There is perhaps room for pragmatism given that the kernel
used to be more permissive prior to dbdbc73b4478, and we weren't
inundated with reports of session ID clashes.

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4g1E0ACgkQlIwGZQq6
i9ChWgf/QGTXOBDrlaf4TvKFHe0h1C/BT+kNE8tYC9ht2IcTxgjIgGJizDL4tDLu
3nSRsQvgIWdpwr62mAzTvoK5710dRHWBQ1vrQMFHxsd99OiaV0nDxWBWaMoTANE/
NnsMsIyftyXeB0CU0YxViwdxkBTYwTAaCmxyRwx4dh7oikMsCRYIu3zhXPfF3ZcE
o4sINoCW/1OCpxVqZ3pRP4OIG0IeYT9D8eSF7VonnxTdsaDNzm426qOAD12wy2WC
a4nYt9ede69PDNvBUiPLCSRqG0a7pAY9TEtKTBGSuO6wY0P6oCB3akz6mjK1FXN5
2moxblQzo2MGSADgIppJZiWIiVypmQ==
=Xuqk
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5A327A7CE
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 08:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgI1GsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 02:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgI1GsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 02:48:07 -0400
Received: from mails.bitsofnetworks.org (mails.bitsofnetworks.org [IPv6:2001:912:1800:ff::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FFCC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 23:48:07 -0700 (PDT)
Received: from [2001:912:1800::5c8] (helo=tuxmachine.localdomain)
        by mails.bitsofnetworks.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <baptiste@bitsofnetworks.org>)
        id 1kMmx8-0007Uz-Dj; Mon, 28 Sep 2020 08:48:02 +0200
Date:   Mon, 28 Sep 2020 08:48:00 +0200
From:   Baptiste Jonglez <baptiste@bitsofnetworks.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>,
        Oliver <bird-o@sernet.de>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200928064800.GA1132636@tuxmachine.localdomain>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200927153552.GA471334@fedic>
 <20200927161031.GB471334@fedic>
 <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27-09-20, David Ahern wrote:
> On 9/27/20 9:10 AM, Baptiste Jonglez wrote:
> > On 27-09-20, Baptiste Jonglez wrote:
> >> 1) failing IPv6 neighbours, what Alarig reported.  We are seeing this
> >>    on a full-view BGP router with rather low amount of IPv6 traffic
> >>    (around 10-20 Mbps)
> >=20
> > Ok, I found a quick way to reproduce this issue:
> >=20
> >     # for net in {1..9999}; do ip -6 route add 2001:db8:ffff:${net}::/6=
4 via fe80::4242 dev lo; done
> >=20
> > and then:
> >=20
> >     # for net in {1..9999}; do ping -c1 2001:db8:ffff:${net}::1; done
> >=20
> > This quickly gets to a situation where ping fails early with:
> >=20
> >     ping: connect: Network is unreachable
> >=20
> > At this point, IPv6 connectivity is broken.  The kernel is no longer
> > replying to IPv6 neighbor solicitation from other hosts on local
> > networks.
> >=20
> > When this happens, the "fib_rt_alloc" field from /proc/net/rt6_stats
> > is roughly equal to net.ipv6.route.max_size (a bit more in my tests).
> >=20
> > Interestingly, the system appears to stay in this broken state
> > indefinitely, even without trying to send new IPv6 traffic.  The
> > fib_rt_alloc statistics does not decrease.
> >=20
>=20
> fib_rt_alloc is incremented by calls to ip6_dst_alloc. Each of your
> 9,999 pings is to a unique address and hence causes a dst to be
> allocated and the counter to be incremented. It is never decremented.
> That is standard operating procedure.

Ok, then this is a change in behaviour.  Here is a graph of fib_rt_alloc
on a busy router (IPv6 full view, moderate IPv6 traffic) with 4.9 kernel:

  https://files.polyno.me/tmp/rt6_stats_fib_rt_alloc_4.9.png

It varies quite a lot and stays around 50, so clearly it can be
decremented in regular operation.

On 4.19 and later, it does seem to be decremented only when a route is
removed (ip -6 route delete).  Here is the same graph on a router with a
4.19 kernel and a large net.ipv6.route.max_size:

   https://files.polyno.me/tmp/rt6_stats_fib_rt_alloc_4.19.png

Overall, do you mean that fib_rt_alloc is a red herring and is not a good
marker of the issue?

Thanks,
Baptiste

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEjVflzZuxNlVFbt5QvgHsIqBOLkYFAl9xhyAACgkQvgHsIqBO
Lka3yg//ekmNtMisYasp+p7CuRDehoaXfkOoQNNYt91joqfadTiPvxicvPS67RSC
qG7S+jcnZEXxLrHZr9sBrCzoKS+prQdbwKr66TrCW5o1rL4A3VhGv+07w44UmOP/
X6+mavoSogHlCsus2wjonjH4b4dzFJLGJwmwQmcmL/dU8ubp69qY1ZTnWz9WMuSO
tYtXn+0PxjzO0WkKB3mDQM2rHk1SOQnixyKywAg96lR5eEYzhz4GK+u7Z67cdEHi
9dZ9LzJ+/w4Kxl5MQiobctSF/TGJVZylOtM6TJzL7lqHBHFu4k56+v2yhQsE0XWM
W5Gp4fJoDX3ceV1vm+Xz67llhuapRi2ZIQPeCMCcgLUkDX77B/R30tTWDEasyAdm
Gm8kxVzl3UQ32E3DLZjx2uU2RZqu7J8GFNUq7QXFGXZ0f4eySJ5N4jA1IY2vmxrR
S/xiXXViNp4SeTF+nLgD/HI78v3FGzJoXzR3dKYjjB7dFKZa00JrYTzo+wOhRX/Q
7bwP+GTJLBnOQwD8OevHJsa+hhUhExmd5TMrAPPjxYn2TfnvmFIBN569AWXSVgOm
qOYWGPFOyK6ly0T6WAjLZytmkBhGywYwBfoHXRXkvpaOFVRlUvVFGREeTdGYCS/k
0oliqxDOscCucLivk9CISLwVH/7FVeuELwJmDX6UhrNwK9S9JUw=
=lGlI
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--

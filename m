Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70FB27A1C4
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 18:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgI0QKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 12:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgI0QKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 12:10:53 -0400
Received: from mails.bitsofnetworks.org (mails.bitsofnetworks.org [IPv6:2001:912:1800:ff::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EFC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 09:10:53 -0700 (PDT)
Received: from [2001:912:1800::ac1] (helo=fedic)
        by mails.bitsofnetworks.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <baptiste@bitsofnetworks.org>)
        id 1kMZGE-0000aj-Fn; Sun, 27 Sep 2020 18:10:50 +0200
Date:   Sun, 27 Sep 2020 18:10:31 +0200
From:   Baptiste Jonglez <baptiste@bitsofnetworks.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>,
        Oliver <bird-o@sernet.de>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200927161031.GB471334@fedic>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200927153552.GA471334@fedic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20200927153552.GA471334@fedic>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 27-09-20, Baptiste Jonglez wrote:
> 1) failing IPv6 neighbours, what Alarig reported.  We are seeing this
>    on a full-view BGP router with rather low amount of IPv6 traffic
>    (around 10-20 Mbps)

Ok, I found a quick way to reproduce this issue:

    # for net in {1..9999}; do ip -6 route add 2001:db8:ffff:${net}::/64 via fe80::4242 dev lo; done

and then:

    # for net in {1..9999}; do ping -c1 2001:db8:ffff:${net}::1; done

This quickly gets to a situation where ping fails early with:

    ping: connect: Network is unreachable

At this point, IPv6 connectivity is broken.  The kernel is no longer
replying to IPv6 neighbor solicitation from other hosts on local
networks.

When this happens, the "fib_rt_alloc" field from /proc/net/rt6_stats
is roughly equal to net.ipv6.route.max_size (a bit more in my tests).

Interestingly, the system appears to stay in this broken state
indefinitely, even without trying to send new IPv6 traffic.  The
fib_rt_alloc statistics does not decrease.

Hopes this helps,
Baptiste

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjVflzZuxNlVFbt5QvgHsIqBOLkYFAl9wuXcACgkQvgHsIqBO
LkaV1BAAuBHunjV8fLjg88sr2zh83EpLP2OX0VwbGiUOFtoVxAY2ucZY5tzH4y55
O6v2S9YMMpcUXo+dkClzbxCs7VVRaFeZLyltAAbqCgXLV+z//vkBuSd4TLe/vy/T
El4YwGa4A0oKGNcXDFXtfsKuxX9AUYiGZt7ffy+2vPtmkDiTgW/qRGHApRLFlaXy
3497E4z5E8bOQeU6QLZD4P0IRmwATvluSGULQ8mtDx933Nz7WfqdM46vuRZjeB/x
vBX4O5hqQWY09f3zO4o7gzrWp8MAMyUNpRPxfHblM9F92exBHdoIKcFJ0AEmRrJ+
8/fLf3Ydob5JVwFiaWFnZqn1lBA+Bdae1zKLTRgjtrslzgzr67ie9P4vf03aFsNj
QAAKB4Yvtha+qvDeRMUNjWNXecJDrbxgWl4pQAjJ0z0JPWh+V1n/ZuRZ/PIqDDMU
utgwkVU2y+eBj5mrt8UeNGSO31qWyO3S3pQKyXzynelEOFnwGy3BjaJXYkFWr6M8
XpWrUtuZLYF4c3pHvLL0GaKyjp3BOvE7u+io6TdZuAqN5idnlv1vUVx5R5+bC0Cf
nygAcco08zKBILSW7YlE/ss7UCsGez6QUXv8grNcs1h8FbDVFzBJ1LtLOwQP0CrW
omnHnL5MQLuP5HyNHY8mo4wzN3kc2SAT40PYegyg5d4f6Xuycl8=
=63Cg
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--

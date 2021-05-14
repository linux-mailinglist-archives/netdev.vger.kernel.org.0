Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF56C38028E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhENDmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhENDmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:42:07 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E7CC061574;
        Thu, 13 May 2021 20:40:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FhDnw3Tnjz9sWW;
        Fri, 14 May 2021 13:40:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620963653;
        bh=gp51mvqAA5f2n4jR3+M5N004LGH+fvS9evIFXb/BgSg=;
        h=Date:From:To:Cc:Subject:From;
        b=bColG3m0vC2CR2s/d22TjR8AmWF5RFlLN61hs0YcgiQMEUtL2mqTm0Zs8qHNZjzSr
         9CONVKo+99x/M170cNjcolK9T5BZQFJwO4Mdzu0u6pLA7kNAX+dXQnljxP9CDV9jk5
         pvuHM2KsImsEfh4UHbRp+//TAlnRaNsA/yNTFZvvTRoSwRPZir72xMdJ+1Pxc3ZJ+l
         to9ceH6apXUILwF3qz8cmyMswqWwgursbsjjktFhqWsG7/E0f8ETYA+uTSPBygemR7
         k7KmQNy7CT5PlE2L7r767DBvFBvgLHZ7zBFEVSMEdU8eddKn1cUPy0cVDKn1hvZi5u
         pzwcwZQXj4mAg==
Date:   Fri, 14 May 2021 13:40:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210514134050.0df7aef9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/B9mPQdekWggz17+.E33jm96";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/B9mPQdekWggz17+.E33jm96
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
pseries_le_defconfig) failed like this:

net/bridge/br_multicast.c: In function '__br_multicast_enable_port':
net/bridge/br_multicast.c:1743:3: error: implicit declaration of function '=
br_ip6_multicast_add_router'; did you mean 'br_ip4_multicast_add_router'? [=
-Werror=3Dimplicit-function-declaration]
 1743 |   br_ip6_multicast_add_router(br, port);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |   br_ip4_multicast_add_router
net/bridge/br_multicast.c: At top level:
net/bridge/br_multicast.c:2804:13: warning: conflicting types for 'br_ip6_m=
ulticast_add_router'
 2804 | static void br_ip6_multicast_add_router(struct net_bridge *br,
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_multicast.c:2804:13: error: static declaration of 'br_ip6_mul=
ticast_add_router' follows non-static declaration
net/bridge/br_multicast.c:1743:3: note: previous implicit declaration of 'b=
r_ip6_multicast_add_router' was here
 1743 |   br_ip6_multicast_add_router(br, port);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  a3c02e769efe ("net: bridge: mcast: split multicast router state for IPv4 =
and IPv6")

# CONFIG_IPV6 is not set

I have reverted that commit for today (along with commit

  3b85f9ba3480 ("net: bridge: mcast: export multicast router presence adjac=
ent to a port")

in case it depends on a3c02e769efe).

--=20
Cheers,
Stephen Rothwell

--Sig_/B9mPQdekWggz17+.E33jm96
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCd8UIACgkQAVBC80lX
0GzcVgf/V4auLEA8X9JxJ01pGbqjadWGeoOgtVXmSgESM7a96XIjYN5FzgV/gu3f
6l/XpIDgwCMF4B4wfPU4ewm1Sh0+rfYYFdZ3W2rA8n4vBQ5LC9vE+WFOL9vXHb2G
qIG6CRXN7srH8hxdzhDjT4hFdqzX1efFph/UMmU2THSzuUx2H+hImsQkL7Lgmb6H
ZOnXgXP1p2lfab9NRF4kXklMcZRtCbVhboCeNbmLjhNY42d9v+duAXuYwGwQDbo/
DUEA2t1cjvR5pmrDGW2cD9f+pxf79t/iCyuzBCm+WJvPu+LBRhK1ebdc8VoqnqjK
u4kBx+kWE4SyqQCVUKieZ/SSeS+gxA==
=6U2F
-----END PGP SIGNATURE-----

--Sig_/B9mPQdekWggz17+.E33jm96--

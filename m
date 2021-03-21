Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02B343378
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 17:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhCUQco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 12:32:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34576 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCUQcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 12:32:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EAFE51C0B78; Sun, 21 Mar 2021 17:32:10 +0100 (CET)
Date:   Sun, 21 Mar 2021 17:32:10 +0100
From:   Pavel Machek <pavel@denx.de>
To:     kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org
Subject: net/dev: fix information leak to userspace
Message-ID: <20210321163210.GC26497@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

dev_get_mac_address() does not always initialize whole
structure. Unfortunately, other code copies such structure to
userspace, leaking information. Fix it.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: stable@kernel.org

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..28283a9eb63a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8949,11 +8949,9 @@ int dev_get_mac_address(struct sockaddr *sa, struct =
net *net, char *dev_name)
 		ret =3D -ENODEV;
 		goto unlock;
 	}
-	if (!dev->addr_len)
-		memset(sa->sa_data, 0, size);
-	else
-		memcpy(sa->sa_data, dev->dev_addr,
-		       min_t(size_t, size, dev->addr_len));
+	memset(sa->sa_data, 0, size);
+	memcpy(sa->sa_data, dev->dev_addr,
+	       min_t(size_t, size, dev->addr_len));
 	sa->sa_family =3D dev->type;
=20
 unlock:


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBXdQoACgkQMOfwapXb+vJdiACfU1FPb4O7ikDk8o+OPGYR1NmK
4IIAoKK4mpRlql+ZnR9Uxo1kJUWTUrBn
=VJfs
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--

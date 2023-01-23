Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A01678BA7
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjAWXDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjAWXDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:03:36 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216233A593;
        Mon, 23 Jan 2023 15:03:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P15Gz3bSfz4xyF;
        Tue, 24 Jan 2023 10:02:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674514972;
        bh=mSntX7M1BWnx+3X6vSUMHIbBpo2Tej3Z/vVUQjj9+rc=;
        h=Date:From:To:Cc:Subject:From;
        b=B+SqX6tvMvGq3WSbJLrGhnYqWq2851XFXiISLtiDYdMUHJKXM4uMrXN17YnHIxU5m
         QX1Djq6T8C2C7ZlThUBgWPV8KiJWLzDxWaGNK6hos7PlLR/WdBcpnr3/PC6tvj7yOk
         ovHTz01zcrSKvxWJ+ftRlLGn30WgY86Kcux8mW2GiPAjyChazXFqyeyf4OABVdo7Gl
         y3K2gGSYWoWWBHVeTN9BXNu3nhFY+9rkImasYTQeSnvZn4FuKDhFb+EJaZYsITMbZ6
         GJE/VUuS03eE/qikH6HzP3HueJFhwVNkMrxrfNdUQoaWeUeysykr1AeGzgCr01cljW
         tVbuAfDSgmtMg==
Date:   Tue, 24 Jan 2023 10:02:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20230124100249.5ec4512c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/78vkhwALhY6su2u.n.Z+QAx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/78vkhwALhY6su2u.n.Z+QAx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from net/ethtool/netlink.c:6:
net/ethtool/netlink.h:177:20: error: redefinition of 'ethnl_update_bool'
  177 | static inline void ethnl_update_bool(bool *dst, const struct nlattr=
 *attr,
      |                    ^~~~~~~~~~~~~~~~~
net/ethtool/netlink.h:125:20: note: previous definition of 'ethnl_update_bo=
ol' with type 'void(bool *, const struct nlattr *, bool *)' {aka 'void(_Boo=
l *, const struct nlattr *, _Bool *)'}
  125 | static inline void ethnl_update_bool(bool *dst, const struct nlattr=
 *attr,
      |                    ^~~~~~~~~~~~~~~~~

Caused by commit

  dc0b98a1758f ("ethtool: Add and use ethnl_update_bool.")

merging badly with commit

  7c494a7749a7 ("net: ethtool: netlink: introduce ethnl_update_bool()")

from the net tree.

I applied the following merge fix up.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 Jan 2023 09:58:16 +1100
Subject: [PATCH] fix up for "ethtool: Add and use ethnl_update_bool."

interacting with "net: ethtool: netlink: introduce ethnl_update_bool()"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/ethtool/netlink.h | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 4992fab0d06b..b01f7cd542c4 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -111,32 +111,6 @@ static inline void ethnl_update_u8(u8 *dst, const stru=
ct nlattr *attr,
 	*mod =3D true;
 }
=20
-/**
- * ethnl_update_bool() - update bool from NLA_U8 attribute
- * @dst:  value to update
- * @attr: netlink attribute with new value or null
- * @mod:  pointer to bool for modification tracking
- *
- * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variab=
le
- * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @att=
r is
- * null. Bool pointed to by @mod is set to true if this function changed t=
he
- * logical value of *dst, otherwise it is left as is.
- */
-static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
-				     bool *mod)
-{
-	u8 val;
-
-	if (!attr)
-		return;
-	val =3D !!nla_get_u8(attr);
-	if (*dst =3D=3D val)
-		return;
-
-	*dst =3D val;
-	*mod =3D true;
-}
-
 /**
  * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
  * @dst:  value to update
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/78vkhwALhY6su2u.n.Z+QAx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPPEhoACgkQAVBC80lX
0Gx82gf+Nz9Fzf9CwhYXSZJ81aYhNp6oFFI/eXBgw+ZIKdL1SEH4ea0xxhwLrlHM
R2735JENLUxgww0Xp6yjsM468Qs32ggInMbMzr01Ml2HV54fyFmFAp76OI7XpKzQ
5YWFDalhJ1hofmvF/fKWQDQAzG6xwdcacga2C1w8F176+iKKg8UTBqmcZ3EuDyaI
0XLbDtov8P9MDcwGS4vCtFNsbCZJHo3hrdxnrUr/ugvjIaWvqyOjS975Q5ngAk9J
G6FMfL/zb2YvRtUC4fZuoouRw3V0pmuX2Ok4tonclyNbcGcDrsCUIn0jT4hTMvA6
KsYqtPScT8q3m8w7k5nqWhsMvlJxMg==
=BHCy
-----END PGP SIGNATURE-----

--Sig_/78vkhwALhY6su2u.n.Z+QAx--

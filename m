Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E461B27BB3F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 05:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgI2DFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 23:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgI2DFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 23:05:01 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64985C061755;
        Mon, 28 Sep 2020 20:05:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C0klF3yGSz9s1t;
        Tue, 29 Sep 2020 13:04:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601348697;
        bh=/QSIT6Tfgaxw+JmY9/F6hMsZ8bc6dWqVnIszkkrLOVE=;
        h=Date:From:To:Cc:Subject:From;
        b=IDAq7OZAH1PVcYkJ45gA2TXczwKRWwk3YQEl90qdwT7duObPUXBwYp5ggGZivY4RV
         oSBm8wiwDC44i0p6cW3hiWBTiFEUmh4o3U1/F60kdKzgAHC1iVVkmCm7gmQdfHn/FK
         MmD2gxkX2kgCRMXEbcMDhgM3AVKRVTPD/lUDPfoJWeUwoUJqDnMYbJQbMwpn17iAa+
         D9xGbMqQYqm+uwv+cfbY6xcm/l6kL7/DYY4IRxPdV+58ndOO4QDyMCuA7njlx5TLLV
         8EPKeHdrhDJx4cJv3sCwcP5NmB1kFeSrmNKERFr1eaSYB9tLts/17UM+ydpCU5dbOQ
         bsUFlvs/JY53g==
Date:   Tue, 29 Sep 2020 13:04:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200929130446.0c2630d2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mIiG9H84CW6wa3if/A52zoG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mIiG9H84CW6wa3if/A52zoG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/marvell/prestera/prestera_main.c: In function 'prester=
a_port_dev_lower_find':
drivers/net/ethernet/marvell/prestera/prestera_main.c:504:33: error: passin=
g argument 2 of 'netdev_walk_all_lower_dev' from incompatible pointer type =
[-Werror=3Dincompatible-pointer-types]
  504 |  netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~
      |                                 |
      |                                 int (*)(struct net_device *, void *)
In file included from include/linux/etherdevice.h:21,
                 from drivers/net/ethernet/marvell/prestera/prestera_main.c=
:4:
include/linux/netdevice.h:4571:16: note: expected 'int (*)(struct net_devic=
e *, struct netdev_nested_priv *)' but argument is of type 'int (*)(struct =
net_device *, void *)'
 4571 |          int (*fn)(struct net_device *lower_dev,
      |          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 4572 |      struct netdev_nested_priv *priv),
      |      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/prestera/prestera_main.c:504:58: error: passin=
g argument 3 of 'netdev_walk_all_lower_dev' from incompatible pointer type =
[-Werror=3Dincompatible-pointer-types]
  504 |  netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
      |                                                          ^~~~~
      |                                                          |
      |                                                          struct pre=
stera_port **
In file included from include/linux/etherdevice.h:21,
                 from drivers/net/ethernet/marvell/prestera/prestera_main.c=
:4:
include/linux/netdevice.h:4573:37: note: expected 'struct netdev_nested_pri=
v *' but argument is of type 'struct prestera_port **'
 4573 |          struct netdev_nested_priv *priv);
      |          ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
cc1: some warnings being treated as errors

Caused by commit

  eff7423365a6 ("net: core: introduce struct netdev_nested_priv for nested =
interface infrastructure")

interacting with commit

  e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementatio=
n")

also in the net-next tree.

I applied the following fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Sep 2020 12:57:59 +1000
Subject: [PATCH] fix up for "net: core: introduce struct netdev_nested_priv=
 for nested interface infrastructure"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/driver=
s/net/ethernet/marvell/prestera/prestera_main.c
index 9bd57b89d1d0..633d8770be35 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -482,9 +482,10 @@ bool prestera_netdev_check(const struct net_device *de=
v)
 	return dev->netdev_ops =3D=3D &prestera_netdev_ops;
 }
=20
-static int prestera_lower_dev_walk(struct net_device *dev, void *data)
+static int prestera_lower_dev_walk(struct net_device *dev,
+				   struct netdev_nested_priv *priv)
 {
-	struct prestera_port **pport =3D data;
+	struct prestera_port **pport =3D (struct prestera_port **)priv->data;
=20
 	if (prestera_netdev_check(dev)) {
 		*pport =3D netdev_priv(dev);
@@ -497,11 +498,13 @@ static int prestera_lower_dev_walk(struct net_device =
*dev, void *data)
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
 {
 	struct prestera_port *port =3D NULL;
+	struct netdev_nested_priv priv;
=20
 	if (prestera_netdev_check(dev))
 		return netdev_priv(dev);
=20
-	netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
+	priv.data =3D (void *)&port;
+	netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &priv);
=20
 	return port;
 }
--=20
2.28.0

--=20
Cheers,
Stephen Rothwell

--Sig_/mIiG9H84CW6wa3if/A52zoG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9ypE4ACgkQAVBC80lX
0GyIhAgAg692cTGuoDdmBUZPumsXi8dzTcf+iDUqKKo8/cmfzDiOx/EQqZ09G8CO
Y16VXoqXmbzqIG+X0DZq7MpR7Ul2kByk/2WSknS5xcNTBYFwWSTGGv4ooxX5zVYJ
oGIcvBYdYt/H+TKIru34Vo0Ft7RbrSqkli1vrYjapxrK4VloHCaKtXOR73LLjKhv
RgcHUYeNK33mTl9Ci+z+rpybPA5QV2RLdvu8TZ9oe77DN2WR9wrwyICZDKlnOe+9
WgcrDRM9JuIPlov2e4/5ABgXBdaqDqSYGmsyvs5mpJLLqf2KN9WO5OIvVGJMayig
CANz6GlDUsvHDgw21leSP76U0PvR0w==
=LyoE
-----END PGP SIGNATURE-----

--Sig_/mIiG9H84CW6wa3if/A52zoG--

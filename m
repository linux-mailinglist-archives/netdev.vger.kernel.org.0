Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BA41D6B62
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgEQRU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:20:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43432 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgEQRU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 13:20:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jaMy6-0006Mt-AM; Sun, 17 May 2020 18:20:54 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jaMy5-0035KG-TB; Sun, 17 May 2020 18:20:53 +0100
Date:   Sun, 17 May 2020 18:20:53 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     960702@bugs.debian.org, netdev@vger.kernel.org
Subject: [PATCH net] mlx4: Fix information leak on failure to read module
 EEPROM
Message-ID: <20200517172053.GA734488@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

mlx4_en_get_module_eeprom() returns 0 even if it fails.  This results
in copying an uninitialised (or partly initialised) buffer back to
user-space.

Change it so that:

* In the special case that the DOM turns out not to be readable, the
  remaining part of the buffer is cleared.  This should avoid a
  regression when reading modules with this problem.

* In other error cases, the error code is propagated.

Reported-by: Yannis Aribaud <bugs@d6bell.net>
References: https://bugs.debian.org/960702
Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/...=
")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is compile-tested only.  It should go to stable, if it is a
correct fix.

Ben.

 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/=
ethernet/mellanox/mlx4/en_ethtool.c
index 8a5ea2543670..6edc3177af1c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2078,14 +2078,17 @@ static int mlx4_en_get_module_eeprom(struct net_dev=
ice *dev,
 		ret =3D mlx4_get_module_info(mdev->dev, priv->port,
 					   offset, ee->len - i, data + i);
=20
-		if (!ret) /* Done reading */
+		if (!ret) {
+			/* DOM was not readable after all */
+			memset(data + i, 0, ee->len - i);
 			return 0;
+		}
=20
 		if (ret < 0) {
 			en_err(priv,
 			       "mlx4_get_module_info i(%d) offset(%d) bytes_to_read(%d) - FAILE=
D (0x%x)\n",
 			       i, offset, ee->len - i, ret);
-			return 0;
+			return ret;
 		}
=20
 		i +=3D ret;

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7BcmsACgkQ57/I7JWG
EQkqnA/+MbQABTsYvIeldzjd9gcFCSg+/JOxD9vYsAw8ECQ1g9PmS1YeEGvA2Jea
KKilTi+qRtvyL3yqN77qJmwqoXGdmhVlpDuVqAaI3F5f5NtLcsmj4qT6fMOTFXd2
qDFwBqU5xcXZ6aZJ+HcRWofU/vKdMEtGcWAorWN49wxE7pAV4P0jCqXXL7PcR2OM
OLwH4sHmhSQNt7fByq8pdwORE8TBrCdhzJpB8uBIJSg6QWNF1vekAwxJ8tONzo3w
MiSXOHgkKYzwP5NReToix49M2AzLqS67vb8oFwGKrZCqW/vPh34+wW0ojCtOnSYh
LnG9DYwjDlZv5a0U7rX+7FDqotPmw6cLa9Dxg4hPvgT/ZFi0zMJx3ojdwVMzRkS6
S8T7EtBcRJQLlOCK2GhlGAgt5JkypP3UxcEx/ex3D8Wi9aHSGDm1PjRHzmOV8Xk8
ud5arTiT3QzqStf3CqZX4ZLRZIvkyQdMXBjZV+sHoGFPuCi/2sMgc2sSQD0DOlJX
DbOBhlIRDqQ51TBwOnUdmT/Rj1DWXBeLZvWUSCwqE2jCErG1p64ZYw28hvwrrYDY
j/edBrjbJgt9gJ00Wt7Rhw0bt5LLOy8J7y+G7zwELngeC6mAPYtKFd55Qy/j+m2l
SaeV7+b8fHE3kCZOF3qEUSW1CKqOvk5vuP+252CcN9miX4B++jY=
=zaeW
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--

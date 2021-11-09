Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD90C44ACC2
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239894AbhKILmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbhKILmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:42:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BD3C061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 03:39:46 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkPTY-0007l1-63; Tue, 09 Nov 2021 12:39:40 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkPTV-0008HY-Ax; Tue, 09 Nov 2021 12:39:37 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mkPTV-00086Y-9q; Tue, 09 Nov 2021 12:39:37 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next] net: dsa: Some cleanups in remove code
Date:   Tue,  9 Nov 2021 12:39:21 +0100
Message-Id: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=614dw3GzkjL3qzgy566iVGuSzip3P+2Jp+xYcl1K/i8=; m=GzspymK2Iba3NYKAGlVIkegX0UaUp2OYPaOkQrk6hss=; p=iqHh/hQ4fFKyKcB4AkfPK7P2ETrZ3HukYRpWohTwdBU=; g=8ca4680a943a69acde554e11917ce6726617d4e9
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGKXeYACgkQwfwUeK3K7AmdIgf9EOj xbqbSSdFaevWY31UkwKk9/U4GRbk3LXULkwRbJmDR36QsawsSxi0ez7ycIIwTEdA6t3NwqwU/uTDK B7nu2mzhuySCFXq9wf91awzi9/Zt1OtCRdrQWkO/eVE5Pp48IyFE5250KUTEjlabiANfn9X4UHRcC UxC7fcYTu9iM+05FpQHbb1lluWINK3Zuu+IewUjFi1HOr1Bp6eUtzIlEXqHpye2PZtYc2Hz/t++ZU rb878r8W3blQEGTmLgm4nwdaY6+YyPWdAZTQtDSVNYtrzwG4YHnoNIhcsmd3GxKN0Xv5hCeJKF7bv 8U+URzGW6vxtWP6RvyhEorucD/stwyg==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsc73xx_remove() returns zero unconditionally and no caller checks the
returned value. So convert the function to return no value.

For both the platform and the spi variant ..._get_drvdata() will never
return NULL in .remove() because the remove callback is only called after
the probe callback returned successfully and in this case driver data was
set to a non-NULL value.

Also setting driver data to NULL is not necessary, this is already done
in the driver core in __device_release_driver(), so drop this from the
remove callback, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c     | 4 +---
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 5 -----
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 5 -----
 drivers/net/dsa/vitesse-vsc73xx.h          | 2 +-
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index a4b1447ff055..4c18f619ec02 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1216,12 +1216,10 @@ int vsc73xx_probe(struct vsc73xx *vsc)
 }
 EXPORT_SYMBOL(vsc73xx_probe);
 
-int vsc73xx_remove(struct vsc73xx *vsc)
+void vsc73xx_remove(struct vsc73xx *vsc)
 {
 	dsa_unregister_switch(vsc->ds);
 	gpiod_set_value(vsc->reset, 1);
-
-	return 0;
 }
 EXPORT_SYMBOL(vsc73xx_remove);
 
diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
index fe4b154a0a57..f2715bee2173 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -116,13 +116,8 @@ static int vsc73xx_platform_remove(struct platform_device *pdev)
 {
 	struct vsc73xx_platform *vsc_platform = platform_get_drvdata(pdev);
 
-	if (!vsc_platform)
-		return 0;
-
 	vsc73xx_remove(&vsc_platform->vsc);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 645398901e05..6b33f754982b 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -163,13 +163,8 @@ static int vsc73xx_spi_remove(struct spi_device *spi)
 {
 	struct vsc73xx_spi *vsc_spi = spi_get_drvdata(spi);
 
-	if (!vsc_spi)
-		return 0;
-
 	vsc73xx_remove(&vsc_spi->vsc);
 
-	spi_set_drvdata(spi, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse-vsc73xx.h
index 30b951504e65..30b1f0a36566 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.h
+++ b/drivers/net/dsa/vitesse-vsc73xx.h
@@ -26,5 +26,5 @@ struct vsc73xx_ops {
 
 int vsc73xx_is_addr_valid(u8 block, u8 subblock);
 int vsc73xx_probe(struct vsc73xx *vsc);
-int vsc73xx_remove(struct vsc73xx *vsc);
+void vsc73xx_remove(struct vsc73xx *vsc);
 void vsc73xx_shutdown(struct vsc73xx *vsc);
-- 
2.30.2


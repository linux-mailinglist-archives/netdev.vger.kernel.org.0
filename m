Return-Path: <netdev+bounces-6712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2627A717941
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49B06281354
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50792BA25;
	Wed, 31 May 2023 07:58:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45674A942
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:58:16 +0000 (UTC)
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 00:58:02 PDT
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C42186
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
	s=selector; t=1685519881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f8zcB3FWzdIFMOaqwlI0SLKX/m2ghSlGQdvzpIMntgE=;
	b=bGKjGcO08aLl+6a8ArDMeNaCMGBODLkkkE4YQM9DZBiGBviWtuw43u3ysx9JsvURj+8FcN
	U0EOvZUnRabF0HcYY1t8VmhHoOPzmd72XXmNJ7bAdAyBMkIsFbn33dPnaeIzFFP0872tBq
	t/XTpN20gXRSHYK/bdCMieDrzUPkLLtb1LsLuF2bDjOav7x7GQh2/+ZyHoMJIfjD/tvY4o
	ntnz1gpPyWEVUDvA30CiWrdC8dIlJcyF8pQZmKvz2BIWwtTp20Er0l9Twm9QpOB17t+skG
	KkxrIeiAgi5Ies9LHasDCT4RymFWl6gLYnG/YTepCyQrl5Adrg/Ls9WCdLDRBw==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-613-lqpd6lBjOL-cJyLEWZh_4Q-1; Wed, 31 May 2023 03:48:42 -0400
X-MC-Unique: lqpd6lBjOL-cJyLEWZh_4Q-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Wed, 31 May 2023 00:48:29 -0700
From: Xu Liang <lxu@maxlinear.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <kuba@kernel.org>
CC: <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
	<tmohren@maxlinear.com>, <rtanwar@maxlinear.com>,
	<mohammad.athari.ismail@intel.com>, <edumazet@google.com>,
	<michael@walle.cc>, <pabeni@redhat.com>, Xu Liang <lxu@maxlinear.com>
Subject: [PATCH net] net: phy: mxl-gpy: extend interrupt fix to all impacted variants
Date: Wed, 31 May 2023 15:48:22 +0800
Message-ID: <20230531074822.39136-1-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The interrupt fix in commit 97a89ed101bb should be applied on all variants
of GPY2xx PHY and GPY115C.

Fixes: 97a89ed101bb ("net: phy: mxl-gpy: disable interrupts on GPY215 by de=
fault")
Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
 drivers/net/phy/mxl-gpy.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 6301a9abfb95..ea1073adc5a1 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -274,13 +274,6 @@ static int gpy_config_init(struct phy_device *phydev)
 =09return ret < 0 ? ret : 0;
 }
=20
-static bool gpy_has_broken_mdint(struct phy_device *phydev)
-{
-=09/* At least these PHYs are known to have broken interrupt handling */
-=09return phydev->drv->phy_id =3D=3D PHY_ID_GPY215B ||
-=09       phydev->drv->phy_id =3D=3D PHY_ID_GPY215C;
-}
-
 static int gpy_probe(struct phy_device *phydev)
 {
 =09struct device *dev =3D &phydev->mdio.dev;
@@ -300,8 +293,7 @@ static int gpy_probe(struct phy_device *phydev)
 =09phydev->priv =3D priv;
 =09mutex_init(&priv->mbox_lock);
=20
-=09if (gpy_has_broken_mdint(phydev) &&
-=09    !device_property_present(dev, "maxlinear,use-broken-interrupts"))
+=09if (!device_property_present(dev, "maxlinear,use-broken-interrupts"))
 =09=09phydev->dev_flags |=3D PHY_F_NO_IRQ;
=20
 =09fw_version =3D phy_read(phydev, PHY_FWV);
@@ -659,11 +651,9 @@ static irqreturn_t gpy_handle_interrupt(struct phy_dev=
ice *phydev)
 =09 * frame. Therefore, polling is the best we can do and won't do any mor=
e
 =09 * harm.
 =09 * It was observed that this bug happens on link state and link speed
-=09 * changes on a GPY215B and GYP215C independent of the firmware version
-=09 * (which doesn't mean that this list is exhaustive).
+=09 * changes independent of the firmware version.
 =09 */
-=09if (gpy_has_broken_mdint(phydev) &&
-=09    (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC))) {
+=09if (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC)) {
 =09=09reg =3D gpy_mbox_read(phydev, REG_GPIO0_OUT);
 =09=09if (reg < 0) {
 =09=09=09phy_error(phydev);
--=20
2.17.1



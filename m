Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C107416ECB
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244555AbhIXJWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:22:46 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.129.115]:51617 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244963AbhIXJWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:22:44 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2021 05:22:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1632475270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uL5UOrW0xYwbJjFtc6QUKnjBL9JvrhVulPM0Kqr41gM=;
        b=O1DNx66KtqK8TtP/egTmtYjzjBGV7tzqBm4V7Aas1fQTeFQFSyJHGb10OuirIHtnciB9K4
        T2Wdltb+MLMyWSqMoDej71dlkYn6S5FkxnaSxaF/CzCmP0j1vib7g3/hjFXsx28hFftBXL
        nOCNthktx048nxjBM1afDkeiLu5Q7aA=
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-ZjorimJoNZOdrDNLDVP-sw-1; Fri, 24 Sep 2021 05:05:48 -0400
X-MC-Unique: ZjorimJoNZOdrDNLDVP-sw-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2242.4;
 Fri, 24 Sep 2021 02:05:43 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH] net: phy: enhance GPY115 loopback disable function
Date:   Fri, 24 Sep 2021 17:05:37 +0800
Message-ID: <20210924090537.48972-1-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPY115 need reset PHY when it comes out from loopback mode if the firmware
version number (lower 8 bits) is equal to or below 0x76.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
 drivers/net/phy/mxl-gpy.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 2d5d5081c3b6..3ef62d5c4776 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -493,6 +493,32 @@ static int gpy_loopback(struct phy_device *phydev, boo=
l enable)
 =09return ret;
 }
=20
+static int gpy115_loopback(struct phy_device *phydev, bool enable)
+{
+=09int ret;
+=09int fw_minor;
+
+=09if (enable)
+=09=09return gpy_loopback(phydev, enable);
+
+=09/* Show GPY PHY FW version in dmesg */
+=09ret =3D phy_read(phydev, PHY_FWV);
+=09if (ret < 0)
+=09=09return ret;
+
+=09fw_minor =3D FIELD_GET(PHY_FWV_MINOR_MASK, ret);
+=09if (fw_minor > 0x0076)
+=09=09return gpy_loopback(phydev, 0);
+
+=09ret =3D phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, BMCR_RESET);
+=09if (!ret) {
+=09=09/* Some delay for the reset complete. */
+=09=09msleep(100);
+=09}
+
+=09return ret;
+}
+
 static struct phy_driver gpy_drivers[] =3D {
 =09{
 =09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx),
@@ -527,7 +553,7 @@ static struct phy_driver gpy_drivers[] =3D {
 =09=09.handle_interrupt =3D gpy_handle_interrupt,
 =09=09.set_wol=09=3D gpy_set_wol,
 =09=09.get_wol=09=3D gpy_get_wol,
-=09=09.set_loopback=09=3D gpy_loopback,
+=09=09.set_loopback=09=3D gpy115_loopback,
 =09},
 =09{
 =09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY115C),
@@ -544,7 +570,7 @@ static struct phy_driver gpy_drivers[] =3D {
 =09=09.handle_interrupt =3D gpy_handle_interrupt,
 =09=09.set_wol=09=3D gpy_set_wol,
 =09=09.get_wol=09=3D gpy_get_wol,
-=09=09.set_loopback=09=3D gpy_loopback,
+=09=09.set_loopback=09=3D gpy115_loopback,
 =09},
 =09{
 =09=09.phy_id=09=09=3D PHY_ID_GPY211B,
--=20
2.17.1


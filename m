Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDA418FA6
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 09:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhI0HEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 03:04:54 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:34487 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233118AbhI0HEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 03:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1632726193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XLZNOfYfpC5ztNPOoufpucttZwj3ZH+y3LDmJu/eCr4=;
        b=C5ThP+yZ+RmCf6qtBNGUDNyg+KHXtFsVdr7CJT1rQpebCKDPZdNCotAMOzvjA2VXDBJXxz
        dBtvvoCvox5AGi+d8WdsKybnmgBaxjMkffUMDV3chVY/iuJDRW3BvlkmV+EQ35gtnRFqow
        kHXpEADMDLVTlSzVgjZZ0BKGkOa/hjE=
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-OVPxP044PVmdKhfKB4-gzQ-1; Mon, 27 Sep 2021 03:03:11 -0400
X-MC-Unique: OVPxP044PVmdKhfKB4-gzQ-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2242.4;
 Mon, 27 Sep 2021 00:03:06 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v2] net: phy: enhance GPY115 loopback disable function
Date:   Mon, 27 Sep 2021 15:03:02 +0800
Message-ID: <20210927070302.27956-1-lxu@maxlinear.com>
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

Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v2 changes:
  Remove wrong comment.
  Use genphy_soft_reset instead of modifying MII_BMCR register to trigger P=
HY reset.

 drivers/net/phy/mxl-gpy.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 2d5d5081c3b6..5ce1bf03bbd7 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -493,6 +493,25 @@ static int gpy_loopback(struct phy_device *phydev, boo=
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
+=09ret =3D phy_read(phydev, PHY_FWV);
+=09if (ret < 0)
+=09=09return ret;
+
+=09fw_minor =3D FIELD_GET(PHY_FWV_MINOR_MASK, ret);
+=09if (fw_minor > 0x0076)
+=09=09return gpy_loopback(phydev, 0);
+
+=09return genphy_soft_reset(phydev);
+}
+
 static struct phy_driver gpy_drivers[] =3D {
 =09{
 =09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx),
@@ -527,7 +546,7 @@ static struct phy_driver gpy_drivers[] =3D {
 =09=09.handle_interrupt =3D gpy_handle_interrupt,
 =09=09.set_wol=09=3D gpy_set_wol,
 =09=09.get_wol=09=3D gpy_get_wol,
-=09=09.set_loopback=09=3D gpy_loopback,
+=09=09.set_loopback=09=3D gpy115_loopback,
 =09},
 =09{
 =09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY115C),
@@ -544,7 +563,7 @@ static struct phy_driver gpy_drivers[] =3D {
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


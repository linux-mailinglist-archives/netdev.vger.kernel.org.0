Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092A23CCD6C
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 07:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhGSFfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 01:35:25 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:33768 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhGSFfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 01:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1626672744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dz5OBIGGSXOudV6AsLJmj+3otCE9P9ZcDxWOoGphMH0=;
        b=bpumKjSONrScptk1nCOlU8mHQ4kxUHn02sXEG7LEDc7NO7hwbs5EeHNZmYqiWIRiXHNd4B
        7MaQEG4XsfRT+m/mQfKf+xjglcBFu+tkPgm2P2RugtsA04bTyGIY9xdo/S3DD78+duqOdB
        +moIdJsCIAmU8I+8d30HEFvgb/+ppbU=
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-HtrLWVnROJi-QpoCI0Mc8w-1; Mon, 19 Jul 2021 01:32:23 -0400
X-MC-Unique: HtrLWVnROJi-QpoCI0Mc8w-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2242.4;
 Sun, 18 Jul 2021 22:32:18 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v6 1/2] net: phy: add API to read 802.3-c45 IDs
Date:   Mon, 19 Jul 2021 13:32:11 +0800
Message-ID: <20210719053212.11244-1-lxu@maxlinear.com>
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

Add API to read 802.3-c45 IDs so that C22/C45 mixed device can use
C45 APIs without failing ID checks.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v5 changes:
 Fix incorrect prototype name in comment.

 drivers/net/phy/phy_device.c | 14 ++++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d5f9a9ee768..107aa6d7bc6b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -968,6 +968,20 @@ void phy_device_remove(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_device_remove);
=20
+/**
+ * phy_get_c45_ids - Read 802.3-c45 IDs for phy device.
+ * @phydev: phy_device structure to read 802.3-c45 IDs
+ *
+ * Returns zero on success, %-EIO on bus access error, or %-ENODEV if
+ * the "devices in package" is invalid.
+ */
+int phy_get_c45_ids(struct phy_device *phydev)
+{
+=09return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
+=09=09=09       &phydev->c45_ids);
+}
+EXPORT_SYMBOL(phy_get_c45_ids);
+
 /**
  * phy_find_first - finds the first PHY device on the bus
  * @bus: the target MII bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3b80dc3ed68b..736e1d1a47c4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1431,6 +1431,7 @@ static inline int phy_device_register(struct phy_devi=
ce *phy)
 static inline void phy_device_free(struct phy_device *phydev) { }
 #endif /* CONFIG_PHYLIB */
 void phy_device_remove(struct phy_device *phydev);
+int phy_get_c45_ids(struct phy_device *phydev);
 int phy_init_hw(struct phy_device *phydev);
 int phy_suspend(struct phy_device *phydev);
 int phy_resume(struct phy_device *phydev);
--=20
2.17.1


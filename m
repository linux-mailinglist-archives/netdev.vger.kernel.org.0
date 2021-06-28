Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17143B6158
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhF1Ofi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:35:38 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:20844 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234163AbhF1Oci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1624890610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gyZfI7pvrpe2GYjzBa5V3TIpV5IC5MOrD1i16xRB/Jg=;
        b=f8507faACyQZyk6v27hHWll5xGGKoLMtiTHUrp0pm8dVEKbmmgOw5am/wX1zNotP8ApN5m
        h9jT7HDSHFBIuE45vz15UHLlqBhPaTayY9bZOLcmGafb2dy9xKXqt6FKOtUvYDs7BNvlTj
        Gxiy27BQKe4n40+3sfHgiJJivwfSvDw=
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-RFFeUWYEPQ6eOk5yql5clQ-1; Mon, 28 Jun 2021 10:30:08 -0400
X-MC-Unique: RFFeUWYEPQ6eOk5yql5clQ-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2242.4;
 Mon, 28 Jun 2021 07:30:03 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v4 1/2] net: phy: add API to read 802.3-c45 IDs
Date:   Mon, 28 Jun 2021 22:29:45 +0800
Message-ID: <20210628142946.16319-1-lxu@maxlinear.com>
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
 drivers/net/phy/phy_device.c | 14 ++++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0a2d8bedf73d..c8969642076f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -935,6 +935,20 @@ void phy_device_remove(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_device_remove);
=20
+/**
+ * get_phy_c45_ids - Read 802.3-c45 IDs for phy device.
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
index 852743f07e3e..e46b23a2113b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1391,6 +1391,7 @@ static inline int phy_device_register(struct phy_devi=
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


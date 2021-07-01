Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2203B8ECA
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 10:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhGAI3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 04:29:45 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:32437 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234709AbhGAI3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 04:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1625128033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rFqUCvft/naHa/Axuf+8oehy5U/b8dKHlcxM4TQtdS8=;
        b=C555/pPnzrhEdnhmD4/r5zB4H0nyZ/wXHJ74X87csyu6jHsi1vFB61t3F5Dd5t+AwTvTUr
        OIGldJcNpxY2UNlJJt6LrOGX2zj+vuCMwLalBouXpcyjELIbIq3YTnG74J/ThNc4b5yq8c
        iayAUQ/DuNuBG3wVcwpQza+Kh2yazDg=
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-AJXqtySgN0S467wP1ndQcQ-3; Thu, 01 Jul 2021 04:27:12 -0400
X-MC-Unique: AJXqtySgN0S467wP1ndQcQ-3
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2242.4;
 Thu, 1 Jul 2021 01:27:01 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v5 1/2] net: phy: add API to read 802.3-c45 IDs
Date:   Thu, 1 Jul 2021 16:26:57 +0800
Message-ID: <20210701082658.21875-1-lxu@maxlinear.com>
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
index 0a2d8bedf73d..f0ad1c4add48 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -935,6 +935,20 @@ void phy_device_remove(struct phy_device *phydev)
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


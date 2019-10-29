Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9FE8EC9
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfJ2R5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:57:06 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:40997 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJ2R5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:57:06 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 42D7822EE4;
        Tue, 29 Oct 2019 18:48:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572371333;
        bh=PbfA7H2lwRKfSuMsRBe42p6Zb1q6FIEe3795UNqR4bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFoia7pxEXBX7aG7MOFMI+VAK0xmtS6JrxS3qPeIwCIefNCalHFpgCJH9/Tajj4kT
         GgH1SKAvQo7VvEwg0bCVRWp+DI+AI+35kzGvVFlBpVIU4/KpT29Uqmw+JX1ih7tfzh
         eGz7XqYya37WWQv1Er3sU7yd7rzJ3O0PZYVwWnkU=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 2/3] net: phy: export __phy_{read|write}_page
Date:   Tue, 29 Oct 2019 18:48:18 +0100
Message-Id: <20191029174819.3502-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191029174819.3502-1-michael@walle.cc>
References: <20191029174819.3502-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also check if the op is actually available. Otherwise return -ENOTSUPP.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy-core.c | 24 ++++++++++++++++++++++--
 include/linux/phy.h        |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9412669b579c..70f93e405e91 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -687,15 +687,35 @@ int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(phy_modify_mmd);
 
-static int __phy_read_page(struct phy_device *phydev)
+/**
+ * __phy_read_page - get currently selected page
+ * @phydev: the phy_device struct
+ *
+ * Get the current PHY page. On error, returns a negative errno, otherwise
+ * returns the selected page number.
+ */
+int __phy_read_page(struct phy_device *phydev)
 {
+	if (!phydev->drv->read_page)
+		return -ENOTSUPP;
 	return phydev->drv->read_page(phydev);
 }
+EXPORT_SYMBOL_GPL(__phy_read_page);
 
-static int __phy_write_page(struct phy_device *phydev, int page)
+/**
+ * __phy_write_page - set the current page
+ * @phydev: the phy_device struct
+ * @page: desired page
+ *
+ * Set the current PHY page. On error, returns a negative errno.
+ */
+int __phy_write_page(struct phy_device *phydev, int page)
 {
+	if (!phydev->drv->write_page)
+		return -ENOTSUPP;
 	return phydev->drv->write_page(phydev, page);
 }
+EXPORT_SYMBOL_GPL(__phy_write_page);
 
 /**
  * phy_save_page() - take the bus lock and save the current page
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9a0e981df502..70eca3cb25ff 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -797,6 +797,8 @@ int __phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 		     u16 mask, u16 set);
 int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 		   u16 mask, u16 set);
+int __phy_read_page(struct phy_device *phydev);
+int __phy_write_page(struct phy_device *phydev, int page);
 
 /**
  * __phy_set_bits - Convenience function for setting bits in a PHY register
-- 
2.20.1


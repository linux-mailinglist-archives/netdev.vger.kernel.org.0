Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E9150CE71
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiDXC1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiDXC1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:27:00 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4AC24085
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:24:01 -0700 (PDT)
Received: (qmail 36860 invoked by uid 89); 24 Apr 2022 02:24:00 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 24 Apr 2022 02:24:00 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v1 2/4] net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
Date:   Sat, 23 Apr 2022 19:23:54 -0700
Message-Id: <20220424022356.587949-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220424022356.587949-1-jonathan.lemon@gmail.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the public bcm_ptp_probe() and bcm_ptp_config_init() functions
to the bcm-phy library.  The PTP functions are contained in a separate
file for clarity, and also to simplify the PTP clock dependencies.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.c | 13 +++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 287cccf8f7f4..b9d2d1d48402 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -816,6 +816,19 @@ int bcm_phy_cable_test_get_status_rdb(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status_rdb);
 
+#if !IS_ENABLED(CONFIG_BCM_NET_PHYPTP)
+struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
+{
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(bcm_ptp_probe);
+
+void bcm_ptp_config_init(struct phy_device *phydev)
+{
+}
+EXPORT_SYMBOL_GPL(bcm_ptp_config_init);
+#endif
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index c3842f87c33b..66fa731554a3 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -87,4 +87,7 @@ int bcm_phy_cable_test_start_rdb(struct phy_device *phydev);
 int bcm_phy_cable_test_start(struct phy_device *phydev);
 int bcm_phy_cable_test_get_status(struct phy_device *phydev, bool *finished);
 
+struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev);
+void bcm_ptp_config_init(struct phy_device *phydev);
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
-- 
2.31.1


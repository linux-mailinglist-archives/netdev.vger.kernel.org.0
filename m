Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7EA5159F1
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiD3DAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 23:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiD3DAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 23:00:50 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393917E37
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:57:30 -0700 (PDT)
Received: (qmail 58004 invoked by uid 89); 30 Apr 2022 02:57:26 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 30 Apr 2022 02:57:26 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, richardcochran@gmail.com,
        lasse@timebeat.app
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v2 2/3] net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
Date:   Fri, 29 Apr 2022 19:57:22 -0700
Message-Id: <20220430025723.1037573-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220430025723.1037573-1-jonathan.lemon@gmail.com>
References: <20220430025723.1037573-1-jonathan.lemon@gmail.com>
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
 drivers/net/phy/bcm-phy-lib.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index c3842f87c33b..c2cc3c2766a1 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -87,4 +87,18 @@ int bcm_phy_cable_test_start_rdb(struct phy_device *phydev);
 int bcm_phy_cable_test_start(struct phy_device *phydev);
 int bcm_phy_cable_test_get_status(struct phy_device *phydev, bool *finished);
 
+#if IS_ENABLED(CONFIG_BCM_NET_PHYPTP)
+struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev);
+void bcm_ptp_config_init(struct phy_device *phydev);
+#else
+static inline struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
+{
+	return NULL;
+}
+
+static inline void bcm_ptp_config_init(struct phy_device *phydev)
+{
+}
+#endif
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1944E51B232
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiEDWri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiEDWrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:47:37 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9196B48892
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:44:00 -0700 (PDT)
Received: (qmail 26583 invoked by uid 89); 4 May 2022 22:43:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 4 May 2022 22:43:59 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, richardcochran@gmail.com,
        lasse@timebeat.app
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v3 1/3] net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
Date:   Wed,  4 May 2022 15:43:54 -0700
Message-Id: <20220504224356.1128644-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220504224356.1128644-1-jonathan.lemon@gmail.com>
References: <20220504224356.1128644-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192E65A0AF6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbiHYIGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239213AbiHYIGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:06:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CAD44552;
        Thu, 25 Aug 2022 01:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661414771; x=1692950771;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9uK5TnxQ+lrTrmdrZfvdGZkX8FHoJoY0NQJe55dWt8Y=;
  b=mImjrDuuKrz0oHRMl/NuksvT5oaNkKNx7Z+Qf1IYTnbuhORvW6phbOFG
   5mZENUGPoiaIBdhsz4joV9IfBMzR+qcEkAGTgvfT2wuamqf4Qx4rBPxlI
   6T56G/zmzIfGbmoCk3tpL7OwspMdyuyq3jkRJeY2Is2WDn2LeakIavSCi
   gqkFcvytk3ZqgEDVD5IGIY3BFC/NetutGa3WKtJ9lBI4INu67C5pICnP5
   HdngbsLF2fVThLdLdvDQfodeA2w02Q/BTkl5Ah1GBfbBpMeHvhKnFl8aJ
   8PcRiZE/IwC7Lc3UNVk/U6btYY7HgHls1phpVLGue8oGkKh4lk/SBJoj3
   A==;
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="174075197"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2022 01:06:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 25 Aug 2022 01:06:11 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 25 Aug 2022 01:06:07 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814 phy
Date:   Thu, 25 Aug 2022 13:35:49 +0530
Message-ID: <20220825080549.9444-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supports SQI(Signal Quality Index) for lan8814 phy, where
it has SQI index of 0-7 values and this indicator can be used
for cable integrity diagnostic and investigating other noise
sources.

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..3775da7afc64 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1975,6 +1975,13 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 #define LAN8814_CLOCK_MANAGEMENT			0xd
 #define LAN8814_LINK_QUALITY				0x8e
 
+#define LAN8814_DCQ_CTRL				0xe6
+#define LAN8814_DCQ_CTRL_READ_CAPTURE_			BIT(15)
+#define LAN8814_DCQ_CTRL_CHANNEL_MASK			GENMASK(1, 0)
+#define LAN8814_DCQ_SQI					0xe4
+#define LAN8814_DCQ_SQI_MAX				7
+#define LAN8814_DCQ_SQI_VAL_MASK			GENMASK(3, 1)
+
 static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
 	int data;
@@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_get_sqi(struct phy_device *phydev)
+{
+	int rc, val;
+
+	val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
+	if (val < 0)
+		return val;
+
+	val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
+	val |= LAN8814_DCQ_CTRL_READ_CAPTURE_;
+	rc = lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL, val);
+	if (rc < 0)
+		return rc;
+
+	rc = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
+	if (rc < 0)
+		return rc;
+
+	return FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, rc);
+}
+
+static int lan8814_get_sqi_max(struct phy_device *phydev)
+{
+	return LAN8814_DCQ_SQI_MAX;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -3117,6 +3150,8 @@ static struct phy_driver ksphy_driver[] = {
 	.resume		= kszphy_resume,
 	.config_intr	= lan8814_config_intr,
 	.handle_interrupt = lan8814_handle_interrupt,
+	.get_sqi	= lan8814_get_sqi,
+	.get_sqi_max	= lan8814_get_sqi_max,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.17.1


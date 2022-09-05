Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23115ACFE1
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiIEKS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237972AbiIEKSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:18:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974D757E2B;
        Mon,  5 Sep 2022 03:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662373066; x=1693909066;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=1LxAEb0YeNv/EF5OX+3v58gClT2GrInwD87KBgwe+HA=;
  b=y75nAuRw/g8UC2IG1tPDxk162LsfrJneZyz2SPtlaRSdd6WE0BLaf2eM
   YWVAdKdxsjwCle6/ZDT+I3tEzObKOVs5kYmtvsOEe7TabCWEfCLnuYFvD
   7/xMiR9KjHvqCJSo1ROX2Gq9Pn+eBk3LiGoYjEY0MekX98Rc41v/F1hj1
   TXHE6Lmn4toPoWy1ESVjbYhlgYuX2oUHfrJ0BZJOOUz9r6OSKczp1jZNg
   1HQFIUvdQImKNRy8/ZAu8J7AuRTCm6sGxqrx+7VjHffffAnRfpQbUfTlP
   gPBx1jxUdQcZTUUPZLymwp+JYmKMNBiFRD/oVdivi59G4bJYLeOSHhVIj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="175641566"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Sep 2022 03:17:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Sep 2022 03:17:44 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Sep 2022 03:17:40 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for lan8814 phy
Date:   Mon, 5 Sep 2022 15:47:30 +0530
Message-ID: <20220905101730.29951-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supports SQI(Signal Quality Index) for lan8814 phy, where
it has SQI index of 0-7 values and this indicator can be used
for cable integrity diagnostic and investigating other noise
sources. It is not supported for 10Mbps speed

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2
- Given SQI support for all pairs of wires in 1000/100 base-T phy's
  uAPI may run through all instances in future. At present returning
  only first instance as uAPI supports for only 1 pair.
- SQI is not supported for 10Mbps speed, handled accordingly.
---
 drivers/net/phy/micrel.c | 44 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..37845efe2cb6 100644
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
@@ -2933,6 +2940,41 @@ static int lan8814_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_get_sqi(struct phy_device *phydev)
+{
+	int ret, val, pair;
+	int sqi_val[4];
+
+	if (phydev->speed == SPEED_10)
+		return -EOPNOTSUPP;
+
+	for (pair = 0; pair < 4; pair++) {
+		val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
+		if (val < 0)
+			return val;
+
+		val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
+		val |= pair;
+		val |= LAN8814_DCQ_CTRL_READ_CAPTURE_;
+		ret = lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL, val);
+		if (ret < 0)
+			return ret;
+
+		ret = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
+		if (ret < 0)
+			return ret;
+
+		sqi_val[pair] = FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, ret);
+	}
+
+	return *sqi_val;
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
@@ -3123,6 +3165,8 @@ static struct phy_driver ksphy_driver[] = {
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


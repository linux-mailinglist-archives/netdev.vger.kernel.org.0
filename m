Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD425B55E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgIBUfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:35:21 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:55676 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgIBUfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:35:19 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 082KZ5cU094799;
        Wed, 2 Sep 2020 15:35:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599078905;
        bh=lB6gMLFYWNjTQrjVUHT02s8NbLlsZvqbvkao9a2Eltk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=zENysSlakgXzwOSoH1TY0AT87xIqxUJnXFk67EZamuvrAZe2ieqk8L5m2moNmYGZE
         HSDcjjVizMyvOcbVkHfms/C/zHUZ7FcR4CSQiU/j9YWXM5OKWZkk3lkHffPTpvQ6JL
         vss/Xv5l1zHCfGd18FOCQCCXhZLXNyIQ4IKgIwjg=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 082KZ5No027502
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 2 Sep 2020 15:35:05 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 2 Sep
 2020 15:35:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 2 Sep 2020 15:35:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 082KZ5WV061840;
        Wed, 2 Sep 2020 15:35:05 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 3/3] net: dp83869: Add speed optimization feature
Date:   Wed, 2 Sep 2020 15:34:44 -0500
Message-ID: <20200902203444.29167-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200902203444.29167-1-dmurphy@ti.com>
References: <20200902203444.29167-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the speed optimization bit on the DP83869 PHY.

Speed optimization, also known as link downshift, enables fallback to 100M
operation after multiple consecutive failed attempts at Gigabit link
establishment. Such a case could occur if cabling with only four wires
(two twisted pairs) were connected instead of the standard cabling with
eight wires (four twisted pairs).

The number of failed link attempts before falling back to 100M operation is
configurable. By default, four failed link attempts are required before
falling back to 100M.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 116 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 5045df9515a5..06a228dac92b 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/delay.h>
+#include <linux/bitfield.h>
 
 #include <dt-bindings/net/ti-dp83869.h>
 
@@ -20,6 +21,7 @@
 #define MII_DP83869_PHYCTRL	0x10
 #define MII_DP83869_MICR	0x12
 #define MII_DP83869_ISR		0x13
+#define DP83869_CFG2		0x14
 #define DP83869_CTRL		0x1f
 #define DP83869_CFG4		0x1e
 
@@ -121,6 +123,18 @@
 #define DP83869_WOL_SEC_EN		BIT(5)
 #define DP83869_WOL_ENH_MAC		BIT(7)
 
+/* CFG2 bits */
+#define DP83869_DOWNSHIFT_EN		(BIT(8) | BIT(9))
+#define DP83869_DOWNSHIFT_ATTEMPT_MASK	(BIT(10) | BIT(11))
+#define DP83869_DOWNSHIFT_1_COUNT_VAL	0
+#define DP83869_DOWNSHIFT_2_COUNT_VAL	1
+#define DP83869_DOWNSHIFT_4_COUNT_VAL	2
+#define DP83869_DOWNSHIFT_8_COUNT_VAL	3
+#define DP83869_DOWNSHIFT_1_COUNT	1
+#define DP83869_DOWNSHIFT_2_COUNT	2
+#define DP83869_DOWNSHIFT_4_COUNT	4
+#define DP83869_DOWNSHIFT_8_COUNT	8
+
 enum {
 	DP83869_PORT_MIRRORING_KEEP,
 	DP83869_PORT_MIRRORING_EN,
@@ -281,6 +295,99 @@ static void dp83869_get_wol(struct phy_device *phydev,
 		wol->wolopts = 0;
 }
 
+static int dp83869_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable, count;
+
+	val = phy_read(phydev, DP83869_CFG2);
+	if (val < 0)
+		return val;
+
+	enable = FIELD_GET(DP83869_DOWNSHIFT_EN, val);
+	cnt = FIELD_GET(DP83869_DOWNSHIFT_ATTEMPT_MASK, val);
+
+	switch (cnt) {
+	case DP83869_DOWNSHIFT_1_COUNT_VAL:
+		count = DP83869_DOWNSHIFT_1_COUNT;
+		break;
+	case DP83869_DOWNSHIFT_2_COUNT_VAL:
+		count = DP83869_DOWNSHIFT_2_COUNT;
+		break;
+	case DP83869_DOWNSHIFT_4_COUNT_VAL:
+		count = DP83869_DOWNSHIFT_4_COUNT;
+		break;
+	case DP83869_DOWNSHIFT_8_COUNT_VAL:
+		count = DP83869_DOWNSHIFT_8_COUNT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*data = enable ? count : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int dp83869_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	int val, count;
+
+	if (cnt > DP83869_DOWNSHIFT_8_COUNT)
+		return -E2BIG;
+
+	if (!cnt)
+		return phy_clear_bits(phydev, DP83869_CFG2,
+				      DP83869_DOWNSHIFT_EN);
+
+	switch (cnt) {
+		case DP83869_DOWNSHIFT_1_COUNT:
+			count = DP83869_DOWNSHIFT_1_COUNT_VAL;
+			break;
+		case DP83869_DOWNSHIFT_2_COUNT:
+			count = DP83869_DOWNSHIFT_2_COUNT_VAL;
+			break;
+		case DP83869_DOWNSHIFT_4_COUNT:
+			count = DP83869_DOWNSHIFT_4_COUNT_VAL;
+			break;
+		case DP83869_DOWNSHIFT_8_COUNT:
+			count = DP83869_DOWNSHIFT_8_COUNT_VAL;
+			break;
+		default:
+			phydev_err(phydev,
+				   "Downshift count must be 1, 2, 4 or 8\n");
+			return -EINVAL;
+	}
+
+	val = DP83869_DOWNSHIFT_EN;
+	val |= FIELD_PREP(DP83869_DOWNSHIFT_ATTEMPT_MASK, count);
+
+	return phy_modify(phydev, DP83869_CFG2,
+			  DP83869_DOWNSHIFT_EN | DP83869_DOWNSHIFT_ATTEMPT_MASK,
+			  val);
+}
+
+static int dp83869_get_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return dp83869_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dp83869_set_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return dp83869_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int dp83869_config_port_mirroring(struct phy_device *phydev)
 {
 	struct dp83869_private *dp83869 = phydev->priv;
@@ -558,6 +665,12 @@ static int dp83869_config_init(struct phy_device *phydev)
 	struct dp83869_private *dp83869 = phydev->priv;
 	int ret, val;
 
+       /* Force speed optimization for the PHY even if it strapped */
+       ret = phy_modify(phydev, DP83869_CFG2, DP83869_DOWNSHIFT_EN,
+                        DP83869_DOWNSHIFT_EN);
+       if (ret)
+               return ret;
+
 	ret = dp83869_configure_mode(phydev, dp83869);
 	if (ret)
 		return ret;
@@ -656,6 +769,9 @@ static struct phy_driver dp83869_driver[] = {
 		.ack_interrupt	= dp83869_ack_interrupt,
 		.config_intr	= dp83869_config_intr,
 
+		.get_tunable	= dp83869_get_tunable,
+		.set_tunable	= dp83869_set_tunable,
+
 		.get_wol	= dp83869_get_wol,
 		.set_wol	= dp83869_set_wol,
 
-- 
2.28.0


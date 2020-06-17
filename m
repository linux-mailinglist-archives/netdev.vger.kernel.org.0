Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2E11FD457
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgFQSVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:21:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58074 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgFQSUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:20:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKaE4039691;
        Wed, 17 Jun 2020 13:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592418036;
        bh=ZNakNO/yn9w134SOd5ynDhx+3+mu8fsJN9YSibNbl20=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ir7fAGqYjfCLlRirA0pQf3ozgPGgdkVp1TWvl33vI40UcEexF++LixsgC7KDKypiB
         no2IfGSEFofaoYvrbwfeEAftIz2kAk5H1eqfUx+fK85o+jOv5pp1Ghfs7dpjinRkPM
         xI4PxZB9zyS9tHLUu3DAejyPLsS793SHmK2dsTr8=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05HIKaNA001355
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jun 2020 13:20:36 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 17
 Jun 2020 13:20:36 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 17 Jun 2020 13:20:36 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKash068354;
        Wed, 17 Jun 2020 13:20:36 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v7 2/6] net: phy: Add a helper to return the index for of the internal delay
Date:   Wed, 17 Jun 2020 13:20:15 -0500
Message-ID: <20200617182019.6790-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617182019.6790-1-dmurphy@ti.com>
References: <20200617182019.6790-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper function that will return the index in the array for the
passed in internal delay value.  The helper requires the array, size and
delay value.

The helper will then return the index for the exact match or return the
index for the index to the closest smaller value.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/phy_device.c | 68 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  4 +++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..611d4e68e3c6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -31,6 +31,7 @@
 #include <linux/mdio.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/property.h>
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
@@ -2657,6 +2658,73 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 }
 EXPORT_SYMBOL(phy_get_pause);
 
+/**
+ * phy_get_delay_index - returns the index of the internal delay
+ * @phydev: phy_device struct
+ * @dev: pointer to the devices device struct
+ * @delay_values: array of delays the PHY supports
+ * @size: the size of the delay array
+ * @is_rx: boolean to indicate to get the rx internal delay
+ *
+ * Returns the index within the array of internal delay passed in.
+ * Or if size == 0 then the delay read from the firmware is returned.
+ * The array must be in ascending order.
+ * Return errno if the delay is invalid or cannot be found.
+ */
+s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
+			   const int *delay_values, int size, bool is_rx)
+{
+	int ret;
+	int i;
+	s32 delay;
+
+	if (is_rx)
+		ret = device_property_read_u32(dev, "rx-internal-delay-ps",
+					       &delay);
+	else
+		ret = device_property_read_u32(dev, "tx-internal-delay-ps",
+					       &delay);
+	if (ret) {
+		phydev_err(phydev, "internal delay not defined\n");
+		return -EINVAL;
+	}
+
+	if (delay < 0)
+		return -EINVAL;
+
+	if (size <= 0)
+		return delay;
+
+	if (delay < delay_values[0] || delay > delay_values[size - 1]) {
+		phydev_err(phydev, "Delay %d is out of range\n", delay);
+		return -EINVAL;
+	}
+
+	if (delay == delay_values[0])
+		return 0;
+
+	for (i = 1; i < size; i++) {
+		if (delay == delay_values[i])
+			return i;
+
+		/* Find an approximate index by looking up the table */
+		if (delay > delay_values[i - 1] &&
+		    delay < delay_values[i]) {
+			if (delay - delay_values[i - 1] <
+			    delay_values[i] - delay)
+				return i - 1;
+			else
+				return i;
+		}
+	}
+
+	phydev_err(phydev, "error finding internal delay index for %d\n",
+		   delay);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(phy_get_internal_delay);
+
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
 	return phydrv->config_intr && phydrv->ack_interrupt;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8c05d0fb5c00..917bfd422e06 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1430,6 +1430,10 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp);
 void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
+
+s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
+			   const int *delay_values, int size, bool is_rx);
+
 void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
 		       bool *tx_pause, bool *rx_pause);
 
-- 
2.26.2


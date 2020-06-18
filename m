Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED81FFD39
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbgFRVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:10:37 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57010 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbgFRVKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:10:33 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05ILASio036148;
        Thu, 18 Jun 2020 16:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592514628;
        bh=LHygI244ExKKKjPR1xtZS3qmfgtP0Pf9c6oBOGOVf/M=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=EijeIYISNAUwqbdUrNNBsrJNACx04/wwSwXdsS97ppHS1pLOWU/2gqZd6sMauyfZ9
         /DWxD5pICpxl5wCKne+vy5BdN2TQF4NBlHEkr2N/cUZUESkX/F5ZcAW6ip2TEO3kk/
         tZFr+nlHeny+SUS79VA1sY4bQ0lW0GZewbzOEseE=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05ILASf3021715
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:10:28 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 16:10:27 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 16:10:27 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05ILARxF014987;
        Thu, 18 Jun 2020 16:10:27 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v8 2/5] net: phy: Add a helper to return the index for of the internal delay
Date:   Thu, 18 Jun 2020 16:10:08 -0500
Message-ID: <20200618211011.28837-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618211011.28837-1-dmurphy@ti.com>
References: <20200618211011.28837-1-dmurphy@ti.com>
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

v8 - I did a considerable amount of rework on this patch.  First the device_property
calls needed to be wrapped in IS_ENABLED (CONFIG_OF_MDIO).  Next if the PHY has
a fixed delay like the DP83822 with a bit to turn the delay on and off then
having a device tree property was a bit to much.  The device property should be
used for configurable delays.  If the PHY had a fixed delay then the PHY
interface type was good enough to tell the PHY to turn on the delay for the path.
This helper was tested on both the DP83869 and DP83822 devices.

 drivers/net/phy/phy_device.c | 100 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |   4 ++
 2 files changed, 104 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..55f9953bcd1d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -31,6 +31,7 @@
 #include <linux/mdio.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/property.h>
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
@@ -2657,6 +2658,105 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 }
 EXPORT_SYMBOL(phy_get_pause);
 
+#if IS_ENABLED(CONFIG_OF_MDIO)
+static int phy_get_int_delay_property(struct device *dev, const char *name)
+{
+	s32 int_delay;
+	int ret;
+
+	ret = device_property_read_u32(dev, name, &int_delay);
+	if (ret)
+		return ret;
+
+	return int_delay;
+}
+#else
+static inline int phy_get_int_delay_property(struct device *dev,
+					     const char *name)
+{
+	return -EINVAL
+}
+#endif
+
+/**
+ * phy_get_delay_index - returns the index of the internal delay
+ * @phydev: phy_device struct
+ * @dev: pointer to the devices device struct
+ * @delay_values: array of delays the PHY supports
+ * @size: the size of the delay array
+ * @is_rx: boolean to indicate to get the rx internal delay
+ *
+ * Returns the index within the array of internal delay passed in.
+ * If the device property is not present then the interface type is checked
+ * if the interface defines use of internal delay then a 1 is returned otherwise
+ * a 0 is returned.
+ * The array must be in ascending order. If PHY does not have an ascending order
+ * array then size = 0 and the value of the delay property is returned.
+ * Return -EINVAL if the delay is invalid or cannot be found.
+ */
+s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
+			   const int *delay_values, int size, bool is_rx)
+{
+	int i;
+	s32 delay;
+
+	if (is_rx) {
+		delay = phy_get_int_delay_property(dev, "rx-internal-delay-ps");
+		if (delay < 0 && size == 0) {
+			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+				return 1;
+			else
+				return 0;
+		}
+
+	} else {
+		delay = phy_get_int_delay_property(dev, "tx-internal-delay-ps");
+		if (delay < 0 && size == 0) {
+			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+				return 1;
+			else
+				return 0;
+		}
+	}
+
+	if (delay < 0)
+		return delay;
+
+	if (delay && size == 0)
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


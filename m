Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7131DD4F9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgEURsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:46 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57764 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730255AbgEURsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:42 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmZA5052544;
        Thu, 21 May 2020 12:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083315;
        bh=qos1fvvu633d2pJTPbu/Q+SMdAvpHI/AStqQHTvDHV4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lQGQKAtK8lOBuDLUfD5EgxeYzMYT4cRuYyHrSqYkqta51mfcxR+K+cxoMSfqr692E
         vd0pOQ+nBtdXADm6N4HhYbYYMiLa8SrSFiumd9KzjNme0JwIoKl9MbmUvtQB0+YypR
         B8a5AV6fN+bw+TWDkYnL8uz9MBWsfAh1kZ7ugEIg=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LHmZXC128922
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 12:48:35 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:48:35 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:48:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmZhf026281;
        Thu, 21 May 2020 12:48:35 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [RFC PATCH net-next 2/4] net: phy: Add a helper to return the index for of the internal delay
Date:   Thu, 21 May 2020 12:48:32 -0500
Message-ID: <20200521174834.3234-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174834.3234-1-dmurphy@ti.com>
References: <20200521174834.3234-1-dmurphy@ti.com>
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
 drivers/net/phy/phy_device.c | 45 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7481135d27ab..40f53b379d2b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2661,6 +2661,51 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 }
 EXPORT_SYMBOL(phy_get_pause);
 
+/**
+ * phy_get_delay_index - returns the index of the internal delay
+ * @phydev: phy_device struct
+ * @delay_values: array of delays the PHY supports
+ * @size: the size of the delay array
+ * @delay: the delay to be looked up
+ *
+ * Returns the index within the array of internal delay passed in.
+ */
+int phy_get_delay_index(struct phy_device *phydev, int *delay_values, int size,
+			int delay)
+{
+	int i;
+
+	if (size <= 0)
+		return -EINVAL;
+
+	if (delay <= delay_values[0])
+		return 0;
+
+	if (delay > delay_values[size - 1])
+		return size - 1;
+
+	for (i = 0; i < size; i++) {
+		if (delay == delay_values[i])
+			return i;
+
+		/* Find an approximate index by looking up the table */
+		if (delay > delay_values[i - 1] &&
+		    delay < delay_values[i]) {
+			if (delay - delay_values[i - 1] < delay_values[i] - delay)
+				return i - 1;
+			else
+				return i;
+		}
+
+	}
+
+	phydev_err(phydev, "error finding internal delay index for %d\n",
+		   delay);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(phy_get_delay_index);
+
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
 	return phydrv->config_intr && phydrv->ack_interrupt;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 467aa8bf9f64..78b7b77f9a67 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1406,6 +1406,8 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp);
 void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
+int phy_get_delay_index(struct phy_device *phydev, int *delay_values,
+			int size, int delay);
 void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
 		       bool *tx_pause, bool *rx_pause);
 
-- 
2.26.2


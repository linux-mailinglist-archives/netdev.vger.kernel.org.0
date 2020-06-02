Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9747A1EC050
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFBQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:45:46 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59396 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgFBQpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:45:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 052GjdG2068920;
        Tue, 2 Jun 2020 11:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591116339;
        bh=1cN/9gYfJ/0Mdbfn2fF8wGKvI9RoSVF5wA22u2jiwI4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qMSgxH5KqNMW8gY+uKRlVDgKSGkHt4Qbf8JKLtgacg5v3onl2ul7982BXh1eZD0w/
         GZL09R7PyZkKH2f9+VwZFiVRLbGr2vzqYFwhKvIlwidQG9RnozUFOqtyjMbnd8xlT/
         7013kof6unQF4IPuPLBpVUE1EmxWUmneOlDDL+DM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 052GjdH1115468
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Jun 2020 11:45:39 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 2 Jun
 2020 11:45:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 2 Jun 2020 11:45:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 052Gjdi8105433;
        Tue, 2 Jun 2020 11:45:39 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v5 2/4] net: phy: Add a helper to return the index for of the internal delay
Date:   Tue, 2 Jun 2020 11:45:20 -0500
Message-ID: <20200602164522.3276-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602164522.3276-1-dmurphy@ti.com>
References: <20200602164522.3276-1-dmurphy@ti.com>
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
 drivers/net/phy/phy_device.c | 51 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..5d4e7520b15e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2657,6 +2657,57 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 }
 EXPORT_SYMBOL(phy_get_pause);
 
+/**
+ * phy_get_delay_index - returns the index of the internal delay
+ * @phydev: phy_device struct
+ * @delay_values: array of delays the PHY supports
+ * @size: the size of the delay array
+ * @int_delay: the internal delay to be looked up
+ *
+ * Returns the index within the array of internal delay passed in.
+ * The array must be in ascending order.
+ * Return errno if the delay is invalid or cannot be found.
+ */
+s32 phy_get_delay_index(struct phy_device *phydev, const int *delay_values,
+			int size, int int_delay)
+{
+	int i;
+
+	if (int_delay < 0)
+		return -EINVAL;
+
+	if (size <= 0)
+		return -EINVAL;
+
+	if (int_delay < delay_values[0] || int_delay > delay_values[size - 1]) {
+		phydev_err(phydev, "Delay %d is out of range\n", int_delay);
+		return -EINVAL;
+	}
+
+	if (int_delay == delay_values[0])
+		return 0;
+
+	for (i = 1; i < size; i++) {
+		if (int_delay == delay_values[i])
+			return i;
+
+		/* Find an approximate index by looking up the table */
+		if (int_delay > delay_values[i - 1] &&
+		    int_delay < delay_values[i]) {
+			if (int_delay - delay_values[i - 1] <
+			    delay_values[i] - int_delay)
+				return i - 1;
+			else
+				return i;
+		}
+	}
+
+	phydev_err(phydev, "error finding internal delay index for %d\n",
+		   int_delay);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(phy_get_delay_index);
+
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
 	return phydrv->config_intr && phydrv->ack_interrupt;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8c05d0fb5c00..a4327e6fd356 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1430,6 +1430,8 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp);
 void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
+int phy_get_delay_index(struct phy_device *phydev, const int *delay_values,
+			int size, int delay);
 void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
 		       bool *tx_pause, bool *rx_pause);
 
-- 
2.26.2


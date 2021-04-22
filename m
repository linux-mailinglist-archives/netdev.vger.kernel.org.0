Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC02367E0C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhDVJov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:44:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47602 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbhDVJon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084649; x=1650620649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P+qM5L/3Pmnzn2w9eKq6fcyXjaYNQ3hamPIMbpyEycM=;
  b=N/dIELpC+iGeMbAsjcesHz99WXqBV7yQZkMDkDAIeHuKyIC3MpODFsOA
   ZrKg1o0mO9LclmIGdJmG2hBN4Gl/+rQWv2U5fd8A+lfOSfF/YXI9AWhj5
   EHvOzHhO+k1+A/O5OGViBJKYsbVsHbKKgZ41r61Rp+K2ntgCfWWlwRHyJ
   134E9v0VXGYjbwM6eGYQwmgke2Yf+r/ZuwLYdKJzLT9mZ5/X8lvFqTjUI
   EbL7+pfe4exnTQY+F48lDHkh+dcT1uB6nBLBrYpj5EaHBTd1WIDauplxK
   x2D0gGCw2632DIRGYCagTH1wWY9+k2fDRvzLkVaKQXaJDEyz/Yr6uSuUl
   g==;
IronPort-SDR: zItV1dLqdhrJBctnqfO8KwC7xooPwAEf3pL1ku88H2FR6X4s46K4vgmxjKV8ZdfiBsTb8KPD0B
 Hh3lksaWKvyr4lSFaWI54FlbE3vQrD0V3wDHlVPrUWao2oyz9Q+gCgfG+F7WDa4wSeYvz31RNL
 VmiVmxo8j1vQA4VSICdpGxSd4CcJCA4/zGCOxYVh+23hRDxgtTFldzdK0QXs7WM+MR1NVjrhn5
 Lg/u2in2CuNc27In6Zw9jywTSUSjF+q1zEBgYc1CStBDF2ucOcV6RVnM56XCPhkXPlUpRYO/Xc
 8KY=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="124117508"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:44:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:44:08 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:44:02 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 9/9] net: dsa: microchip: add support for vlan operations
Date:   Thu, 22 Apr 2021 15:12:57 +0530
Message-ID: <20210422094257.1641396-10-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for VLAN add, del, prepare and filtering operations.

It aligns with latest update of removing switchdev
transactional logic from VLAN objects

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 214 +++++++++++++++++++++++
 1 file changed, 214 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7f6183dc0e31..35f3456c3506 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -14,6 +14,103 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+static int lan937x_wait_vlan_ctrl_ready(struct ksz_device *dev)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL,
+					val, !(val & VLAN_START), 10, 1000);
+}
+
+static int lan937x_get_vlan_table(struct ksz_device *dev, u16 vid,
+				  u32 *vlan_table)
+{
+	int rc;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	rc = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+	if (rc < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	rc = lan937x_wait_vlan_ctrl_ready(dev);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &vlan_table[0]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, &vlan_table[1]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4, &vlan_table[2]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	if (rc < 0)
+		goto exit;
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return rc;
+}
+
+static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
+				  u32 *vlan_table)
+{
+	int rc;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, vlan_table[0]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, vlan_table[1]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_table[2]);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+	if (rc < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	rc = lan937x_wait_vlan_ctrl_ready(dev);
+	if (rc < 0)
+		goto exit;
+
+	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	if (rc < 0)
+		goto exit;
+
+	/* update vlan cache table */
+	dev->vlan_cache[vid].table[0] = vlan_table[0];
+	dev->vlan_cache[vid].table[1] = vlan_table[1];
+	dev->vlan_cache[vid].table[2] = vlan_table[2];
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return rc;
+}
+
 static int lan937x_read_table(struct ksz_device *dev, u32 *table)
 {
 	int rc;
@@ -190,6 +287,120 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag,
+				       struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int rc;
+
+	if (flag) {
+		rc = lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
+				      PORT_VLAN_LOOKUP_VID_0, true);
+		if (rc < 0)
+			return rc;
+
+		rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, true);
+	} else {
+		rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, false);
+		if (rc < 0)
+			return rc;
+
+		rc = lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
+				      PORT_VLAN_LOOKUP_VID_0, false);
+	}
+
+	return rc;
+}
+
+static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	u32 vlan_table[3];
+	int rc;
+
+	rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
+	if (rc < 0) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return rc;
+	}
+
+	vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
+
+	/* set/clear switch port when updating vlan table registers */
+	if (untagged)
+		vlan_table[1] |= BIT(port);
+	else
+		vlan_table[1] &= ~BIT(port);
+	vlan_table[1] &= ~(BIT(dev->cpu_port));
+
+	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
+
+	rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
+	if (rc < 0) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return rc;
+	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
+
+		if (rc < 0) {
+			dev_err(dev->dev, "Failed to set pvid\n");
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	u32 vlan_table[3];
+	u16 pvid;
+	int rc;
+
+	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
+	pvid &= 0xFFF;
+
+	rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
+
+	if (rc < 0) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return rc;
+	}
+	/* clear switch port number */
+	vlan_table[2] &= ~BIT(port);
+
+	if (pvid == vlan->vid)
+		pvid = 1;
+
+	if (untagged)
+		vlan_table[1] &= ~BIT(port);
+
+	rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
+	if (rc < 0) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return rc;
+	}
+
+	rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
+
+	if (rc < 0) {
+		dev_err(dev->dev, "Failed to set pvid\n");
+		return rc;
+	}
+
+	return 0;
+}
+
 static u8 lan937x_get_fid(u16 vid)
 {
 	if (vid > ALU_FID_SIZE)
@@ -955,6 +1166,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_flags	= lan937x_port_bridge_flags,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
+	.port_vlan_filtering	= lan937x_port_vlan_filtering,
+	.port_vlan_add		= lan937x_port_vlan_add,
+	.port_vlan_del		= lan937x_port_vlan_del,
 	.port_fdb_dump		= lan937x_port_fdb_dump,
 	.port_fdb_add		= lan937x_port_fdb_add,
 	.port_fdb_del		= lan937x_port_fdb_del,
-- 
2.27.0


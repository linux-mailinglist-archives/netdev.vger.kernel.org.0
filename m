Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB37306DD8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhA1Gq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:46:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:10607 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhA1GqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:46:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816368; x=1643352368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k/LpW9ZLWg6XuYfZ2wxuCNVHoLBJD/igf9dgOMJ1fHM=;
  b=AQfJl7poN8HWJK13AgkzzZmAD34zTQRkUwkoi1AVWDXO5V1AZBPodlCR
   TMWcZQ3JSwx7+iWASK2SzPwXbch9UhI0JC6ayd2Uq6mC5JF115bNl8ubn
   TKj+wuiZiUj99trlv29d/KKzeHd3hcC8LCJI0Aj1kmDt/OyF/ERY26OfK
   8dcjvXWuGd5jzOoAcKC5xxCbmmIOuGZ8dzkBKEDYmjX7AhIlInS6HDBUV
   RPuNPRllAEzLD8GTKOt9BYGSRnuCny8tsD9ubeBdIDAFrEjrYX91NLIiG
   4j+lBM0cdxk8N74YNKtuEY+NEl38sKhGgb9FPeq2IZGlcX8d8V2x7mD12
   A==;
IronPort-SDR: fdaOdcRNa4P0dD+3hQEaBqJLSlvtMZG2atrmqu3nFduFI/X4/lZHvdFDccslbAACoqk8LTdbfr
 w9teYlCaqDvhdjfCBxdHn6FnDvDSVsDTT4qooKvgdSYhEQ6Xzg0DVIE14ciaee0C61IhYpf1tA
 Bvpxk0HWeRq8zwhHoN/vM0sx1ESc3i0MAsJjQsV1wjZBOG2DTLb6abmyYClHum5qRVY4pbVCyE
 bBLws9EMg4aYgJTppGPEy4rIbgJQhLOY6sB7VAAnKmFdhItVWjcm4XNQRzRBKguZAqLzIQ+ypU
 PmQ=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="42047643"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:51 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:47 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 8/8] net: dsa: microchip: add support for vlan operations
Date:   Thu, 28 Jan 2021 12:11:12 +0530
Message-ID: <20210128064112.372883-9-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
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
 drivers/net/dsa/microchip/lan937x_main.c | 161 +++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index cd902addce3f..b4c68baf9281 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -14,6 +14,73 @@
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
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret)
+		goto exit;
+
+	ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &vlan_table[0]);
+	ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, &vlan_table[1]);
+	ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4, &vlan_table[2]);
+
+	ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
+static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
+				  u32 *vlan_table)
+{
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ksz_write32(dev, REG_SW_VLAN_ENTRY__4, vlan_table[0]);
+	ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, vlan_table[1]);
+	ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_table[2]);
+
+	ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret)
+		goto exit;
+
+	ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+
+	/* update vlan cache table */
+	dev->vlan_cache[vid].table[0] = vlan_table[0];
+	dev->vlan_cache[vid].table[1] = vlan_table[1];
+	dev->vlan_cache[vid].table[2] = vlan_table[2];
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
 static void lan937x_read_table(struct ksz_device *dev, u32 *table)
 {
 	/* read alu table */
@@ -198,6 +265,97 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (flag) {
+		lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
+				 PORT_VLAN_LOOKUP_VID_0, true);
+		lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, true);
+	} else {
+		lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, false);
+		lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
+				 PORT_VLAN_LOOKUP_VID_0, false);
+	}
+
+	return 0;
+}
+
+static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	u32 vlan_table[3];
+	int err;
+
+	err = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
+	if (err) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return err;
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
+	vlan_table[2] |= BIT(port) |
+					BIT(dev->cpu_port);
+
+	err = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
+	if (err) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return err;
+	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+		lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
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
+
+	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
+	pvid = pvid & 0xFFF;
+
+	if (lan937x_get_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return -ETIMEDOUT;
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
+	if (lan937x_set_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return -ETIMEDOUT;
+	}
+
+	lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
+
+	return 0;
+}
+
 static u8 lan937x_get_fid(u16 vid)
 {
 	if (vid > ALU_FID_SIZE)
@@ -852,6 +1010,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
+	.port_vlan_filtering	= lan937x_port_vlan_filtering,
+	.port_vlan_add		= lan937x_port_vlan_add,
+	.port_vlan_del		= lan937x_port_vlan_del,
 	.port_fdb_dump		= lan937x_port_fdb_dump,
 	.port_fdb_add		= lan937x_port_fdb_add,
 	.port_fdb_del		= lan937x_port_fdb_del,
-- 
2.25.1


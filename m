Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96EB306DD6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhA1GqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:46:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:3043 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhA1GqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:46:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816367; x=1643352367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L2YbG6neRTTwbRjDueKVetunN5vOYg7Q+iDPWDIOUc8=;
  b=VW9oPj48lP6u8LEzUyTuwGsV6feJ0MoVwYNRCSDmt8Hm5hnuD4w6evqN
   Lt5GGsv5gK1XGDh7k/Y2ug9AxGZyMhJF8R1Xe3QhcMaCmd+4aNbkTmauT
   SzO7/nYs4fFXq2ilgEKqqpCMxcEZYipX+1J24a9Pic8cLnAHGv+apof8e
   mdz9JSr1qDPDMMURLCLQ5VoC3oo97nVk1FHaId1bVofD+nXMNnMCnDICi
   oD9jEv/Hv2XN0D6zhpWmnSOfjg+C2KUTAQ1TjCj3jA6t1zHncY3faS1QI
   wa0OQ0ApvExUlZNRevKjbPUweCXH8dbyrzg5HQLKqz329xXUuWrQOfb51
   A==;
IronPort-SDR: a/y7t6CDc3xOdRGjAwp9Nutfk+OrFLGJLR2AMB8My8Q7VKUXDf60uZpaKM1NCiCuLXpOG5nMEw
 GjuXMeMCPG+6beAZHsetp1uk2+U9x1NW8r+MSXxpZCB6CGaRdyb6G4d4M37L3hj66FVySTpM8m
 jIMKi2BU9qGSipsgosxmrnWTJAKI1z1+w5Caq/ICqJe0yF0HqhiTMEMaJDMYetHLhgY4Fsc1n+
 v0JGe8QAplSTgpvPK9N0AI7amC2VqHe+8NSeq43yKFkIi3O9eT3dTw0MEepmR8WYr9tusme7l0
 B00=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="101713994"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:46 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:41 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 7/8] net: dsa: microchip: add support for fdb and mdb management
Date:   Thu, 28 Jan 2021 12:11:11 +0530
Message-ID: <20210128064112.372883-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for fdb_add, mdb_add, fdb_del, mdb_del and
fdb_dump operations

It aligns with latest update of removing switchdev
transactional logic from mdb entries

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 424 +++++++++++++++++++++++
 1 file changed, 424 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index aa2efa4e5823..cd902addce3f 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -14,6 +14,42 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+static void lan937x_read_table(struct ksz_device *dev, u32 *table)
+{
+	/* read alu table */
+	ksz_read32(dev, REG_SW_ALU_VAL_A, &table[0]);
+	ksz_read32(dev, REG_SW_ALU_VAL_B, &table[1]);
+	ksz_read32(dev, REG_SW_ALU_VAL_C, &table[2]);
+	ksz_read32(dev, REG_SW_ALU_VAL_D, &table[3]);
+}
+
+static void lan937x_write_table(struct ksz_device *dev, u32 *table)
+{
+	/* write alu table */
+	ksz_write32(dev, REG_SW_ALU_VAL_A, table[0]);
+	ksz_write32(dev, REG_SW_ALU_VAL_B, table[1]);
+	ksz_write32(dev, REG_SW_ALU_VAL_C, table[2]);
+	ksz_write32(dev, REG_SW_ALU_VAL_D, table[3]);
+}
+
+static int lan937x_wait_alu_ready(int alu, struct ksz_device *dev)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(dev->regmap[2], REG_SW_ALU_CTRL(alu),
+					val, !(val & ALU_START), 10, 1000);
+}
+
+static int lan937x_wait_alu_sta_ready(struct ksz_device *dev)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(dev->regmap[2],
+					REG_SW_ALU_STAT_CTRL__4,
+					val, !(val & ALU_STAT_START),
+					10, 1000);
+}
+
 static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
 						      int port,
 						      enum dsa_tag_protocol mp)
@@ -162,6 +198,389 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static u8 lan937x_get_fid(u16 vid)
+{
+	if (vid > ALU_FID_SIZE)
+		return LAN937X_GET_FID(vid);
+	else
+		return vid;
+}
+
+static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
+				const unsigned char *addr, u16 vid)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 fid = lan937x_get_fid(vid);
+	u32 alu_table[4];
+	int ret, i;
+	u32 data;
+	u8 val;
+
+	mutex_lock(&dev->alu_mutex);
+
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* find any entry with mac & fid */
+		data = fid << ALU_FID_INDEX_S;
+		data |= ((addr[0] << 8) | addr[1]);
+		ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+
+		data = ((addr[2] << 24) | (addr[3] << 16));
+		data |= ((addr[4] << 8) | addr[5]);
+		ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+
+		/* start read operation */
+		ksz_write32(dev, REG_SW_ALU_CTRL(i), ALU_READ | ALU_START);
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret) {
+			dev_err(dev->dev, "Failed to read ALU\n");
+			goto exit;
+		}
+
+		/* read ALU entry */
+		lan937x_read_table(dev, alu_table);
+
+		/* update ALU entry */
+		alu_table[0] = ALU_V_STATIC_VALID;
+
+		/* update port number */
+		alu_table[1] |= BIT(port);
+
+		if (fid)
+			alu_table[1] |= ALU_V_USE_FID;
+		alu_table[2] = (fid << ALU_V_FID_S);
+		alu_table[2] |= ((addr[0] << 8) | addr[1]);
+		alu_table[3] = ((addr[2] << 24) | (addr[3] << 16));
+		alu_table[3] |= ((addr[4] << 8) | addr[5]);
+
+		lan937x_write_table(dev, alu_table);
+
+		ksz_write32(dev, REG_SW_ALU_CTRL(i), ALU_WRITE | ALU_START);
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+
+		if (ret)
+			dev_err(dev->dev, "Failed to write ALU\n");
+
+		ksz_read8(dev, REG_SW_LUE_INT_STATUS__1, &val);
+
+		/* ALU write failed */
+		if (val & WRITE_FAIL_INT && i == 1)
+			dev_err(dev->dev, "Failed to write ALU\n");
+
+		/* ALU1 write failed and attempt to write ALU2, otherwise exit*/
+		if (val & WRITE_FAIL_INT)
+			val = WRITE_FAIL_INT;
+		else
+			goto exit;
+	}
+
+exit:
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
+static int lan937x_port_fdb_del(struct dsa_switch *ds, int port,
+				const unsigned char *addr, u16 vid)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 fid = lan937x_get_fid(vid);
+	u32 alu_table[4];
+	int ret, i;
+	u32 data;
+
+	mutex_lock(&dev->alu_mutex);
+
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* read any entry with mac & fid */
+		data = fid << ALU_FID_INDEX_S;
+		data |= ((addr[0] << 8) | addr[1]);
+		ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+
+		data = ((addr[2] << 24) | (addr[3] << 16));
+		data |= ((addr[4] << 8) | addr[5]);
+		ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+
+		/* start read operation */
+		ksz_write32(dev, REG_SW_ALU_CTRL(i), ALU_READ | ALU_START);
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret) {
+			dev_err(dev->dev, "Failed to read ALU\n");
+			goto exit;
+		}
+
+		ksz_read32(dev, REG_SW_ALU_VAL_A, &alu_table[0]);
+		if (alu_table[0] & ALU_V_STATIC_VALID) {
+			ksz_read32(dev, REG_SW_ALU_VAL_B, &alu_table[1]);
+			ksz_read32(dev, REG_SW_ALU_VAL_C, &alu_table[2]);
+			ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
+
+			/* clear forwarding port */
+			alu_table[1] &= ~BIT(port);
+
+			/* if there is no port to forward, clear table */
+			if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
+				alu_table[0] = 0;
+				alu_table[1] = 0;
+				alu_table[2] = 0;
+				alu_table[3] = 0;
+			}
+		} else {
+			alu_table[0] = 0;
+			alu_table[1] = 0;
+			alu_table[2] = 0;
+			alu_table[3] = 0;
+		}
+
+		lan937x_write_table(dev, alu_table);
+
+		ksz_write32(dev, REG_SW_ALU_CTRL(i), ALU_WRITE | ALU_START);
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret)
+			dev_err(dev->dev, "Failed to write ALU\n");
+	}
+
+exit:
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
+static void lan937x_convert_alu(struct lan_alu_struct *alu, u32 *alu_table)
+{
+	alu->is_static = !!(alu_table[0] & ALU_V_STATIC_VALID);
+	alu->is_src_filter = !!(alu_table[0] & ALU_V_SRC_FILTER);
+	alu->is_dst_filter = !!(alu_table[0] & ALU_V_DST_FILTER);
+	alu->prio_age = (alu_table[0] >> ALU_V_PRIO_AGE_CNT_S) &
+			ALU_V_PRIO_AGE_CNT_M;
+	alu->mstp = alu_table[0] & ALU_V_MSTP_M;
+
+	alu->is_override = !!(alu_table[1] & ALU_V_OVERRIDE);
+	alu->is_use_fid = !!(alu_table[1] & ALU_V_USE_FID);
+	alu->port_forward = alu_table[1] & ALU_V_PORT_MAP;
+
+	alu->fid = (alu_table[2] >> ALU_V_FID_S) & ALU_V_FID_M;
+
+	alu->mac[0] = (alu_table[2] >> 8) & 0xFF;
+	alu->mac[1] = alu_table[2] & 0xFF;
+	alu->mac[2] = (alu_table[3] >> 24) & 0xFF;
+	alu->mac[3] = (alu_table[3] >> 16) & 0xFF;
+	alu->mac[4] = (alu_table[3] >> 8) & 0xFF;
+	alu->mac[5] = alu_table[3] & 0xFF;
+}
+
+static int lan937x_port_fdb_dump(struct dsa_switch *ds, int port,
+				 dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct ksz_device *dev = ds->priv;
+	struct lan_alu_struct alu;
+	u32 lan937x_data;
+	u32 alu_table[4];
+	int ret, i;
+	int timeout;
+
+	mutex_lock(&dev->alu_mutex);
+
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* start ALU search */
+		ksz_write32(dev, REG_SW_ALU_CTRL(i), ALU_START | ALU_SEARCH);
+
+		do {
+			timeout = 1000;
+			do {
+				ksz_read32(dev, REG_SW_ALU_CTRL(i), &lan937x_data);
+				if ((lan937x_data & ALU_VALID) || !(lan937x_data & ALU_START))
+					break;
+				usleep_range(1, 10);
+			} while (timeout-- > 0);
+
+			if (!timeout) {
+				dev_err(dev->dev, "Failed to search ALU\n");
+				ret = -ETIMEDOUT;
+				goto exit;
+			}
+
+			/* read ALU table */
+			lan937x_read_table(dev, alu_table);
+
+			lan937x_convert_alu(&alu, alu_table);
+
+			if (alu.port_forward & BIT(port)) {
+				ret = cb(alu.mac, alu.fid, alu.is_static, data);
+				if (ret)
+					goto exit;
+			}
+		} while (lan937x_data & ALU_START);
+
+exit:
+			/* stop ALU search & continue to next ALU if available */
+			ksz_write32(dev, REG_SW_ALU_CTRL(i), 0);
+	}
+
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
+static int lan937x_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 fid = lan937x_get_fid(mdb->vid);
+	u32 static_table[4];
+	u32 mac_hi, mac_lo;
+	int err = 0;
+	int index;
+	u32 data;
+
+	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
+	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
+	mac_lo |= ((mdb->addr[4] << 8) | mdb->addr[5]);
+
+	mutex_lock(&dev->alu_mutex);
+
+	for (index = 0; index < dev->num_statics; index++) {
+		/* find empty slot first */
+		data = (index << ALU_STAT_INDEX_S) |
+			ALU_STAT_READ | ALU_STAT_START;
+		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+
+		/* wait to be finished */
+		err = lan937x_wait_alu_sta_ready(dev);
+		if (err) {
+			dev_err(dev->dev, "Failed to read ALU STATIC\n");
+			goto exit;
+		}
+
+		/* read ALU static table */
+		lan937x_read_table(dev, static_table);
+
+		if (static_table[0] & ALU_V_STATIC_VALID) {
+			/* check this has same fid & mac address */
+			if (((static_table[2] >> ALU_V_FID_S) == fid) &&
+			    ((static_table[2] & ALU_V_MAC_ADDR_HI) == mac_hi) &&
+			    static_table[3] == mac_lo) {
+				/* found matching one */
+				break;
+			}
+		} else {
+			/* found empty one */
+			break;
+		}
+	}
+
+	/* no available entry */
+	if (index == dev->num_statics) {
+		err = -ENOSPC;
+		goto exit;
+	}
+
+	/* add entry */
+	static_table[0] = ALU_V_STATIC_VALID;
+
+	static_table[1] |= BIT(port);
+	if (fid)
+		static_table[1] |= ALU_V_USE_FID;
+	static_table[2] = (fid << ALU_V_FID_S);
+	static_table[2] |= mac_hi;
+	static_table[3] = mac_lo;
+
+	lan937x_write_table(dev, static_table);
+
+	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+
+	/* wait to be finished */
+	if (lan937x_wait_alu_sta_ready(dev))
+		dev_err(dev->dev, "Failed to read ALU STATIC\n");
+
+exit:
+	mutex_unlock(&dev->alu_mutex);
+	return err;
+}
+
+static int lan937x_port_mdb_del(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 fid = lan937x_get_fid(mdb->vid);
+	u32 static_table[4];
+	u32 mac_hi, mac_lo;
+	int index, ret;
+	u32 data;
+
+	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
+	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
+	mac_lo |= ((mdb->addr[4] << 8) | mdb->addr[5]);
+
+	mutex_lock(&dev->alu_mutex);
+
+	for (index = 0; index < dev->num_statics; index++) {
+		/* find empty slot first */
+		data = (index << ALU_STAT_INDEX_S) |
+			ALU_STAT_READ | ALU_STAT_START;
+		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_sta_ready(dev);
+		if (ret) {
+			dev_err(dev->dev, "Failed to read ALU STATIC\n");
+			goto exit;
+		}
+
+		/* read ALU static table */
+		lan937x_read_table(dev, static_table);
+
+		if (static_table[0] & ALU_V_STATIC_VALID) {
+			/* check this has same fid & mac address */
+
+			if (((static_table[2] >> ALU_V_FID_S) == fid) &&
+			    ((static_table[2] & ALU_V_MAC_ADDR_HI) == mac_hi) &&
+			    static_table[3] == mac_lo) {
+				/* found matching one */
+				break;
+			}
+		}
+	}
+
+	/* no available entry */
+	if (index == dev->num_statics)
+		goto exit;
+
+	/* clear port based on port arg */
+	static_table[1] &= ~BIT(port);
+
+	if ((static_table[1] & ALU_V_PORT_MAP) == 0) {
+		/* delete entry */
+		static_table[0] = 0;
+		static_table[1] = 0;
+		static_table[2] = 0;
+		static_table[3] = 0;
+	}
+
+	lan937x_write_table(dev, static_table);
+
+	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+
+	/* wait to be finished */
+	ret = lan937x_wait_alu_sta_ready(dev);
+	if (ret)
+		dev_err(dev->dev, "Failed to read ALU STATIC\n");
+
+exit:
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
 static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
 				   bool ingress)
@@ -433,6 +852,11 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
+	.port_fdb_dump		= lan937x_port_fdb_dump,
+	.port_fdb_add		= lan937x_port_fdb_add,
+	.port_fdb_del		= lan937x_port_fdb_del,
+	.port_mdb_add           = lan937x_port_mdb_add,
+	.port_mdb_del           = lan937x_port_mdb_del,
 	.port_mirror_add	= lan937x_port_mirror_add,
 	.port_mirror_del	= lan937x_port_mirror_del,
 	.port_max_mtu		= lan937x_get_max_mtu,
-- 
2.25.1


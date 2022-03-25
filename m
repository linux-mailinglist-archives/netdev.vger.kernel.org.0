Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67034E797E
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377212AbiCYQ5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377236AbiCYQ4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:56:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB893DA40;
        Fri, 25 Mar 2022 09:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648227291; x=1679763291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPEhiiDlQYioz350ez/WeiaXyv/nNniYmUdEydRriGU=;
  b=gimp8AXKQ+GkMJhoXNyko2mbLka4JjHgwbookZhGwEv/BmB+CpTylg1k
   FuLpFth2yG+K9JtC4FGCe+ScrdMtbx12sZbymdc7geVS3qpiafYAMFWGy
   eetVUOXGC0Uu33S3qnvKGSxOhErclHXbKLcfdlN6pVv5E21FGZaRLKbeE
   qol2QlDGRK6F0594KQvKwewF4orRTh2FmDHbayqzlhAS41zvVYbPz20CO
   XCookxjwJvzhr3PqzzoVTYQ7fMUajpuFojnVD+StFSYAaL8KKjz2L8f3b
   JGgfZM3CDolc2p5i7+up9Y/3nXbazoMmpBq1evge/TRe4iIXaumPGeQaR
   g==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="150450971"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 09:54:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 09:54:48 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 09:54:43 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC PATCH v11 net-next 09/10] net: dsa: microchip: add support for fdb and mdb management
Date:   Fri, 25 Mar 2022 22:23:40 +0530
Message-ID: <20220325165341.791013-10-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for fdb_add, mdb_add, fdb_del, mdb_del and
fdb_dump operations. ALU1 and ALU2 are used for fdb operations.

fdb_add: find any existing entries and update the port map.
if ALU1 write is failed and attempt to write ALU2.
If ALU2 is also failed then exit. Clear WRITE_FAIL for both ALU1
& ALU2.

fdb_del: find the matching entry and clear the respective port
in the port map by writing the ALU tables

fdb_dump: read and dump 2 ALUs upto last entry. ALU_START bit is
used to find the last entry. If the read is timed out, then pass
the error message.

mdb_add: Find the empty slot in ALU and update the port map &
mac address by writing the ALU

mdb_del: find the matching entry and delete the respective port
in port map by writing the ALU

For MAC address, could not use upper_32_bits() & lower_32_bits()
as per Vladimir proposal since it gets accessed in terms of 16bits.
I tried to have common API to get 16bits based on index but shifting
seems to be straight-forward.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 515 +++++++++++++++++++++++
 1 file changed, 515 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 504b9a4edea2..5067da9488c1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -17,6 +17,70 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+static u8 lan937x_get_fid(u16 vid)
+{
+	if (vid > ALU_FID_SIZE)
+		return LAN937X_GET_FID(vid);
+	else
+		return vid;
+}
+
+static int lan937x_read_table(struct ksz_device *dev, u32 *table)
+{
+	int ret;
+
+	/* read alu table */
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_A, &table[0]);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_B, &table[1]);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_C, &table[2]);
+	if (ret < 0)
+		return ret;
+
+	return ksz_read32(dev, REG_SW_ALU_VAL_D, &table[3]);
+}
+
+static int lan937x_write_table(struct ksz_device *dev, u32 *table)
+{
+	int ret;
+
+	/* write alu table */
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_A, table[0]);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_B, table[1]);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_C, table[2]);
+	if (ret < 0)
+		return ret;
+
+	return ksz_write32(dev, REG_SW_ALU_VAL_D, table[3]);
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
+	return regmap_read_poll_timeout(dev->regmap[2], REG_SW_ALU_STAT_CTRL__4,
+					val, !(val & ALU_STAT_START), 10, 1000);
+}
+
 static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
 						      int port,
 						      enum dsa_tag_protocol mp)
@@ -98,6 +162,452 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_update_port_member(dev, port);
 }
 
+static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
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
+	/* Accessing two ALU tables through loop */
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* find any entry with mac & fid */
+		data = fid << ALU_FID_INDEX_S;
+		data |= ((addr[0] << 8) | addr[1]);
+
+		ret = ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+		if (ret < 0)
+			break;
+
+		data = ((addr[2] << 24) | (addr[3] << 16));
+		data |= ((addr[4] << 8) | addr[5]);
+
+		ret = ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+		if (ret < 0)
+			break;
+
+		/* start read operation */
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i),
+				  ALU_READ | ALU_START);
+		if (ret < 0)
+			break;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to read ALU\n");
+			break;
+		}
+
+		/* read ALU entry */
+		ret = lan937x_read_table(dev, alu_table);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to read ALU\n");
+			break;
+		}
+
+		/* update ALU entry */
+		alu_table[0] = ALU_V_STATIC_VALID;
+
+		/* update port number */
+		alu_table[1] |= BIT(port);
+
+		if (fid)
+			alu_table[1] |= ALU_V_USE_FID;
+
+		alu_table[2] = (fid << ALU_V_FID_S);
+		alu_table[2] |= ((addr[0] << 8) | addr[1]);
+		alu_table[3] = ((addr[2] << 24) | (addr[3] << 16));
+		alu_table[3] |= ((addr[4] << 8) | addr[5]);
+
+		ret = lan937x_write_table(dev, alu_table);
+		if (ret < 0)
+			break;
+
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i),
+				  (ALU_WRITE | ALU_START));
+		if (ret < 0)
+			break;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to write ALU\n");
+			break;
+		}
+
+		ret = ksz_read8(dev, REG_SW_LUE_INT_STATUS__1, &val);
+		if (ret < 0)
+			break;
+
+		/* ALU2 write failed */
+		if (val & WRITE_FAIL_INT && i == 1)
+			dev_err(dev->dev, "Failed to write ALU\n");
+
+		/* if ALU1 write is failed and attempt to write ALU2,
+		 * otherwise exit. Clear Write fail for both ALU1 & ALU2
+		 */
+		if (val & WRITE_FAIL_INT) {
+			/* Write to clear the Write Fail */
+			ret = ksz_write8(dev, REG_SW_LUE_INT_STATUS__1,
+					 WRITE_FAIL_INT);
+			if (ret < 0)
+				break;
+		} else {
+			break;
+		}
+	}
+
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
+static int lan937x_port_fdb_del(struct dsa_switch *ds, int port,
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 fid = lan937x_get_fid(vid);
+	u32 alu_table[4];
+	int ret, i;
+	u32 data;
+
+	mutex_lock(&dev->alu_mutex);
+
+	/* Accessing two ALU tables through loop */
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* read any entry with mac & fid */
+		data = fid << ALU_FID_INDEX_S;
+		data |= ((addr[0] << 8) | addr[1]);
+		ret = ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+		if (ret < 0)
+			break;
+
+		data = ((addr[2] << 24) | (addr[3] << 16));
+		data |= ((addr[4] << 8) | addr[5]);
+		ret = ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+		if (ret < 0)
+			break;
+
+		/* start read operation */
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i),
+				  (ALU_READ | ALU_START));
+		if (ret < 0)
+			break;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to read ALU\n");
+			break;
+		}
+
+		ret = ksz_read32(dev, REG_SW_ALU_VAL_A, &alu_table[0]);
+		if (ret < 0)
+			break;
+
+		if (alu_table[0] & ALU_V_STATIC_VALID) {
+			/* read ALU entry */
+			ret = lan937x_read_table(dev, alu_table);
+			if (ret < 0) {
+				dev_err(dev->dev, "Failed to read ALU table\n");
+				break;
+			}
+
+			/* clear forwarding port */
+			alu_table[1] &= ~BIT(port);
+
+			/* if there is no port to forward, clear table */
+			if ((alu_table[1] & ALU_V_PORT_MAP) == 0)
+				memset(&alu_table, 0, sizeof(alu_table));
+		} else {
+			memset(&alu_table, 0, sizeof(alu_table));
+		}
+
+		ret = lan937x_write_table(dev, alu_table);
+		if (ret < 0)
+			break;
+
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i),
+				  (ALU_WRITE | ALU_START));
+		if (ret < 0)
+			break;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_ready(i, dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to delete ALU Entries\n");
+			break;
+		}
+	}
+
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
+			 ALU_V_PRIO_AGE_CNT_M;
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
+	int timeout;
+	int ret, i;
+
+	mutex_lock(&dev->alu_mutex);
+
+	/* Accessing two ALU tables through loop */
+	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
+		/* start ALU search */
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i),
+				  (ALU_START | ALU_SEARCH));
+		if (ret < 0)
+			goto exit;
+
+		do {
+			timeout = 1000;
+			do {
+				ret = ksz_read32(dev, REG_SW_ALU_CTRL(i),
+						 &lan937x_data);
+				if (ret < 0)
+					goto exit;
+
+				if ((lan937x_data & ALU_VALID) ||
+				    !(lan937x_data & ALU_START))
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
+			ret = lan937x_read_table(dev, alu_table);
+			if (ret < 0)
+				goto exit;
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
+		/* stop ALU search & continue to next ALU if available */
+		ret = ksz_write32(dev, REG_SW_ALU_CTRL(i), 0);
+	}
+
+	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
+}
+
+static int lan937x_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
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
+	/* Access the entries in the table */
+	for (index = 0; index < dev->num_statics; index++) {
+		/* find empty slot first */
+		data = (index << ALU_STAT_INDEX_S) |
+			ALU_STAT_READ | ALU_STAT_START;
+
+		ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		if (ret < 0)
+			goto exit;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_sta_ready(dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to read ALU STATIC\n");
+			goto exit;
+		}
+
+		/* read ALU static table */
+		ret = lan937x_read_table(dev, static_table);
+		if (ret < 0)
+			goto exit;
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
+		ret = -ENOSPC;
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
+	ret = lan937x_write_table(dev, static_table);
+	if (ret < 0)
+		goto exit;
+
+	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be finished */
+	ret = lan937x_wait_alu_sta_ready(dev);
+	if (ret < 0)
+		dev_err(dev->dev, "Failed to read ALU STATIC\n");
+
+exit:
+	mutex_unlock(&dev->alu_mutex);
+	return ret;
+}
+
+static int lan937x_port_mdb_del(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
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
+	/* Access the entries in the table */
+	for (index = 0; index < dev->num_statics; index++) {
+		data = (index << ALU_STAT_INDEX_S) |
+			ALU_STAT_READ | ALU_STAT_START;
+		ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		if (ret < 0)
+			goto exit;
+
+		/* wait to be finished */
+		ret = lan937x_wait_alu_sta_ready(dev);
+		if (ret < 0) {
+			dev_err(dev->dev, "Failed to read ALU STATIC\n");
+			goto exit;
+		}
+
+		/* read ALU static table */
+		ret = lan937x_read_table(dev, static_table);
+		if (ret < 0)
+			goto exit;
+
+		if (static_table[0] & ALU_V_STATIC_VALID) {
+			/* check this has same fid & mac address */
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
+		memset(&static_table, 0, sizeof(static_table));
+	}
+
+	ret = lan937x_write_table(dev, static_table);
+	if (ret < 0)
+		goto exit;
+
+	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be finished */
+	ret = lan937x_wait_alu_sta_ready(dev);
+	if (ret < 0)
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
 				   bool ingress, struct netlink_ext_ack *extack)
@@ -566,6 +1076,11 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_fdb_dump = lan937x_port_fdb_dump,
+	.port_fdb_add = lan937x_port_fdb_add,
+	.port_fdb_del = lan937x_port_fdb_del,
+	.port_mdb_add = lan937x_port_mdb_add,
+	.port_mdb_del = lan937x_port_mdb_del,
 	.port_mirror_add = lan937x_port_mirror_add,
 	.port_mirror_del = lan937x_port_mirror_del,
 	.port_max_mtu = lan937x_get_max_mtu,
-- 
2.30.2


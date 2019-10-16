Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267ACD96A3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393621AbfJPQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:11:51 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55981 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391929AbfJPQLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:11:50 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46tck61qVlz1rYHJ;
        Wed, 16 Oct 2019 18:11:34 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46tcjy0TCVz1qqkD;
        Wed, 16 Oct 2019 18:11:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id PIBRslKPKjwz; Wed, 16 Oct 2019 18:11:31 +0200 (CEST)
X-Auth-Info: DF3Kcr5qC6KUhaNAFjWIsFU78PHRP2OMLNRwRBBsIgA=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 16 Oct 2019 18:11:31 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC][PATCH net-next] net: dsa: microchip: Add control bus error handling
Date:   Wed, 16 Oct 2019 18:11:10 +0200
Message-Id: <20191016161110.9532-1-marex@denx.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds error handling for ksz_{read,write}{8,16,32} functions,
which was completely missing from the original driver. While a failure
of the control SPI/I2C bus during operation is unlikely, it does happen
and thus is good to handle it instead of doing something undefined.

This patch only fixes part of the problem for the aforementioned
functions, it does not fix ksz_cfg() calls and it does not fix
ksz_p{read,write} either, these are fixes in subsequent patches.
This is because the amount of changes in the driver in this patch
is already huge, hence the split.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 142 ++++++++++----
 drivers/net/dsa/microchip/ksz9477.c    | 260 ++++++++++++++++++-------
 drivers/net/dsa/microchip/ksz_common.h |  12 +-
 3 files changed, 304 insertions(+), 110 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 24a5e99f7fd5..62fa6a68f4f3 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -76,12 +76,15 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8795_reset_switch(struct ksz_device *dev)
 {
+	int ret;
+
 	/* reset switch */
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1,
-		   SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
-	ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
+	ret = ksz_write8(dev, REG_POWER_MANAGEMENT_1,
+			 SW_SOFTWARE_POWER_DOWN << SW_POWER_MANAGEMENT_MODE_S);
+	if (ret)
+		return ret;
 
-	return 0;
+	return ksz_write8(dev, REG_POWER_MANAGEMENT_1, 0);
 }
 
 static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
@@ -117,44 +120,55 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 			true);
 }
 
-static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+static int ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
+			     u64 *cnt)
 {
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
-	int loop;
+	int ret, loop;
 
 	ctrl_addr = addr + SWITCH_COUNTER_NUM * port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ret = ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	if (ret)
+		goto exit;
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ret = ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		if (ret)
+			goto exit;
 
 		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
+			ret = ksz_read32(dev, REG_IND_DATA_LO, &data);
+			if (ret)
+				goto exit;
+
 			if (check & MIB_COUNTER_OVERFLOW)
 				*cnt += MIB_COUNTER_VALUE + 1;
 			*cnt += data & MIB_COUNTER_VALUE;
 			break;
 		}
 	}
+
+exit:
 	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
 }
 
-static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *dropped, u64 *cnt)
+static int ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			     u64 *dropped, u64 *cnt)
 {
+	int ret, loop;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
-	int loop;
 
 	addr -= SWITCH_COUNTER_NUM;
 	ctrl_addr = (KS_MIB_TOTAL_RX_1 - KS_MIB_TOTAL_RX_0) * port;
@@ -162,16 +176,23 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ret = ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	if (ret)
+		goto exit;
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
 	 */
 	for (loop = 2; loop > 0; loop--) {
-		ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		ret = ksz_read8(dev, REG_IND_MIB_CHECK, &check);
+		if (ret)
+			goto exit;
 
 		if (check & MIB_COUNTER_VALID) {
-			ksz_read32(dev, REG_IND_DATA_LO, &data);
+			ret = ksz_read32(dev, REG_IND_DATA_LO, &data);
+			if (ret)
+				goto exit;
+
 			if (addr < 2) {
 				u64 total;
 
@@ -192,7 +213,10 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			break;
 		}
 	}
+
+exit:
 	mutex_unlock(&dev->alu_mutex);
+	return ret;
 }
 
 static void ksz8795_freeze_mib(struct ksz_device *dev, int port, bool freeze)
@@ -207,7 +231,7 @@ static void ksz8795_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 		ksz_cfg(dev, REG_SW_CTRL_6, BIT(port), false);
 }
 
-static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
+static int ksz8795_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
 
@@ -233,40 +257,56 @@ static void ksz8795_port_init_cnt(struct ksz_device *dev, int port)
 	}
 	mib->cnt_ptr = 0;
 	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+
+	return 0;
 }
 
-static void ksz8795_r_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 *data)
+static int ksz8795_r_table(struct ksz_device *dev, int table, u16 addr,
+			   u64 *data)
 {
 	u16 ctrl_addr;
+	int ret;
 
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
-	ksz_read64(dev, REG_IND_DATA_HI, data);
+	ret = ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	if (!ret)
+		ret = ksz_read64(dev, REG_IND_DATA_HI, data);
+
 	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
 }
 
-static void ksz8795_w_table(struct ksz_device *dev, int table, u16 addr,
-			    u64 data)
+static int ksz8795_w_table(struct ksz_device *dev, int table, u16 addr,
+			   u64 data)
 {
 	u16 ctrl_addr;
+	int ret;
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write64(dev, REG_IND_DATA_HI, data);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ret = ksz_write64(dev, REG_IND_DATA_HI, data);
+	if (!ret)
+		ret = ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+
 	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
 }
 
 static int ksz8795_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
 	int timeout = 100;
+	int ret;
 
 	do {
-		ksz_read8(dev, REG_IND_DATA_CHECK, data);
+		ret = ksz_read8(dev, REG_IND_DATA_CHECK, data);
+		if (ret)
+			return ret;
+
 		timeout--;
 	} while ((*data & DYNAMIC_MAC_TABLE_NOT_READY) && timeout);
 
@@ -275,7 +315,9 @@ static int ksz8795_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 		return -EAGAIN;
 	/* Entry is ready for accessing. */
 	} else {
-		ksz_read8(dev, REG_IND_DATA_8, data);
+		ret = ksz_read8(dev, REG_IND_DATA_8, data);
+		if (ret)
+			return ret;
 
 		/* There is no valid entry in the table. */
 		if (*data & DYNAMIC_MAC_TABLE_MAC_EMPTY)
@@ -296,7 +338,9 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	rc = ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	if (rc)
+		goto exit;
 
 	rc = ksz8795_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
@@ -309,7 +353,10 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 		u64 buf = 0;
 		int cnt;
 
-		ksz_read64(dev, REG_IND_DATA_HI, &buf);
+		rc = ksz_read64(dev, REG_IND_DATA_HI, &buf);
+		if (rc)
+			goto exit;
+
 		data_hi = (u32)(buf >> 32);
 		data_lo = (u32)buf;
 
@@ -336,6 +383,8 @@ static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
 		mac_addr[0] = (u8)(data_hi >> 8);
 		rc = 0;
 	}
+
+exit:
 	mutex_unlock(&dev->alu_mutex);
 
 	return rc;
@@ -920,10 +969,11 @@ static void ksz8795_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+static int ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	u8 data8, member;
+	int ret;
 
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
@@ -941,7 +991,10 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 
 	if (cpu_port) {
 		/* Configure MII interface for proper network communication. */
-		ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
+		ret = ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
+		if (ret)
+			return ret;
+
 		data8 &= ~PORT_INTERFACE_TYPE;
 		data8 &= ~PORT_GMII_1GPS_MODE;
 		switch (dev->interface) {
@@ -971,7 +1024,10 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			p->phydev.speed = SPEED_1000;
 			break;
 		}
-		ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
+		ret = ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
+		if (ret)
+			return ret;
+
 		p->phydev.duplex = 1;
 
 		member = dev->port_mask;
@@ -986,14 +1042,16 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			dev->live_ports |= BIT(port);
 	}
 	ksz8795_cfg_port_member(dev, port, member);
+
+	return 0;
 }
 
-static void ksz8795_config_cpu_port(struct dsa_switch *ds)
+static int ksz8795_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
+	int i, ret;
 	u8 remote;
-	int i;
 
 	ds->num_ports = dev->port_cnt + 1;
 
@@ -1005,7 +1063,10 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	p->vid_member = dev->port_mask;
 	p->on = 1;
 
-	ksz8795_port_setup(dev, dev->cpu_port, true);
+	ret = ksz8795_port_setup(dev, dev->cpu_port, true);
+	if (ret)
+		return ret;
+
 	dev->member = dev->host_mask;
 
 	for (i = 0; i < SWITCH_PORT_NUM; i++) {
@@ -1038,6 +1099,8 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
 				     false);
 	}
+
+	return 0;
 }
 
 static int ksz8795_setup(struct dsa_switch *ds)
@@ -1074,7 +1137,9 @@ static int ksz8795_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	ksz8795_config_cpu_port(ds);
+	ret = ksz8795_config_cpu_port(ds);
+	if (ret)
+		return ret;
 
 	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
 
@@ -1162,7 +1227,10 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 		u8 val;
 
 		id2 = 0x95;
-		ksz_read8(dev, REG_PORT_1_STATUS_0, &val);
+		ret = ksz_read8(dev, REG_PORT_1_STATUS_0, &val);
+		if (ret)
+			return ret;
+
 		if (val & PORT_FIBER_MODE)
 			id2 = 0x65;
 	} else if (id2 == CHIP_ID_94) {
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 50ffc63d6231..e0df0e0e640b 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -103,8 +103,13 @@ static int ksz9477_get_vlan_table(struct ksz_device *dev, u16 vid,
 
 	mutex_lock(&dev->vlan_mutex);
 
-	ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
-	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+	if (ret)
+		goto exit;
 
 	/* wait to be cleared */
 	ret = ksz9477_wait_vlan_ctrl_ready(dev);
@@ -113,11 +118,19 @@ static int ksz9477_get_vlan_table(struct ksz_device *dev, u16 vid,
 		goto exit;
 	}
 
-	ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &vlan_table[0]);
-	ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, &vlan_table[1]);
-	ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4, &vlan_table[2]);
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &vlan_table[0]);
+	if (ret)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, &vlan_table[1]);
+	if (ret)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4, &vlan_table[2]);
+	if (ret)
+		goto exit;
 
-	ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
 
 exit:
 	mutex_unlock(&dev->vlan_mutex);
@@ -132,12 +145,25 @@ static int ksz9477_set_vlan_table(struct ksz_device *dev, u16 vid,
 
 	mutex_lock(&dev->vlan_mutex);
 
-	ksz_write32(dev, REG_SW_VLAN_ENTRY__4, vlan_table[0]);
-	ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, vlan_table[1]);
-	ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_table[2]);
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, vlan_table[0]);
+	if (ret)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, vlan_table[1]);
+	if (ret)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_table[2]);
+	if (ret)
+		goto exit;
+
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret)
+		goto exit;
 
-	ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
-	ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+	if (ret)
+		goto exit;
 
 	/* wait to be cleared */
 	ret = ksz9477_wait_vlan_ctrl_ready(dev);
@@ -146,7 +172,9 @@ static int ksz9477_set_vlan_table(struct ksz_device *dev, u16 vid,
 		goto exit;
 	}
 
-	ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	if (ret)
+		goto exit;
 
 	/* update vlan cache table */
 	dev->vlan_cache[vid].table[0] = vlan_table[0];
@@ -159,20 +187,42 @@ static int ksz9477_set_vlan_table(struct ksz_device *dev, u16 vid,
 	return ret;
 }
 
-static void ksz9477_read_table(struct ksz_device *dev, u32 *table)
+static int ksz9477_read_table(struct ksz_device *dev, u32 *table)
 {
-	ksz_read32(dev, REG_SW_ALU_VAL_A, &table[0]);
-	ksz_read32(dev, REG_SW_ALU_VAL_B, &table[1]);
-	ksz_read32(dev, REG_SW_ALU_VAL_C, &table[2]);
-	ksz_read32(dev, REG_SW_ALU_VAL_D, &table[3]);
+	int ret;
+
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_A, &table[0]);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_B, &table[1]);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_C, &table[2]);
+	if (ret)
+		return ret;
+
+	return ksz_read32(dev, REG_SW_ALU_VAL_D, &table[3]);
 }
 
-static void ksz9477_write_table(struct ksz_device *dev, u32 *table)
+static int ksz9477_write_table(struct ksz_device *dev, u32 *table)
 {
-	ksz_write32(dev, REG_SW_ALU_VAL_A, table[0]);
-	ksz_write32(dev, REG_SW_ALU_VAL_B, table[1]);
-	ksz_write32(dev, REG_SW_ALU_VAL_C, table[2]);
-	ksz_write32(dev, REG_SW_ALU_VAL_D, table[3]);
+	int ret;
+
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_A, table[0]);
+	if (ret)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_B, table[1]);
+	if (ret)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_C, table[2]);
+	if (ret)
+		return ret;
+
+	return ksz_write32(dev, REG_SW_ALU_VAL_D, table[3]);
 }
 
 static int ksz9477_wait_alu_ready(struct ksz_device *dev)
@@ -195,8 +245,9 @@ static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev)
 
 static int ksz9477_reset_switch(struct ksz_device *dev)
 {
-	u8 data8;
 	u32 data32;
+	u8 data8;
+	int ret;
 
 	/* reset switch */
 	ksz_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
@@ -206,15 +257,28 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 			   SPI_AUTO_EDGE_DETECTION, 0);
 
 	/* default configuration */
-	ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
+	ret = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
+	if (ret)
+		return ret;
+
 	data8 = SW_AGING_ENABLE | SW_LINK_AUTO_AGING |
 	      SW_SRC_ADDR_FILTER | SW_FLUSH_STP_TABLE | SW_FLUSH_MSTP_TABLE;
-	ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
+	ret = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
+	if (ret)
+		return ret;
 
 	/* disable interrupts */
-	ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
-	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
-	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
+	ret = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
+	if (ret)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
+	if (ret)
+		return ret;
 
 	/* set broadcast storm protection 10% rate */
 	regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
@@ -229,8 +293,8 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
-static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *cnt)
+static int ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
+			     u64 *cnt)
 {
 	struct ksz_port *p = &dev->ports[port];
 	unsigned int val;
@@ -249,19 +313,20 @@ static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 	/* failed to read MIB. get out of loop */
 	if (ret) {
 		dev_dbg(dev->dev, "Failed to get MIB\n");
-		return;
+		return ret;
 	}
 
 	/* count resets upon read */
 	ksz_pread32(dev, port, REG_PORT_MIB_DATA, &data);
 	*cnt += data;
+	return 0;
 }
 
-static void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
-			      u64 *dropped, u64 *cnt)
+static int ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			     u64 *dropped, u64 *cnt)
 {
 	addr = ksz9477_mib_names[addr].index;
-	ksz9477_r_mib_cnt(dev, port, addr, cnt);
+	return ksz9477_r_mib_cnt(dev, port, addr, cnt);
 }
 
 static void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
@@ -278,20 +343,28 @@ static void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze)
 	mutex_unlock(&p->mib.cnt_mutex);
 }
 
-static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
+static int ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	int ret;
 
 	/* flush all enabled port MIB counters */
 	mutex_lock(&mib->cnt_mutex);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4,
 		     MIB_COUNTER_FLUSH_FREEZE);
-	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
+	ret = ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
+	if (ret)
+		goto exit;
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
 
 	mib->cnt_ptr = 0;
 	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+	return 0;
+
+exit:
+	mutex_unlock(&mib->cnt_mutex);
+	return ret;
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
@@ -602,14 +675,20 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	/* find any entry with mac & vid */
 	data = vid << ALU_FID_INDEX_S;
 	data |= ((addr[0] << 8) | addr[1]);
-	ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+	ret = ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+	if (ret)
+		goto exit;
 
 	data = ((addr[2] << 24) | (addr[3] << 16));
 	data |= ((addr[4] << 8) | addr[5]);
-	ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+	ret = ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+	if (ret)
+		goto exit;
 
 	/* start read operation */
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	ret = ksz9477_wait_alu_ready(dev);
@@ -619,7 +698,9 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	}
 
 	/* read ALU entry */
-	ksz9477_read_table(dev, alu_table);
+	ret = ksz9477_read_table(dev, alu_table);
+	if (ret)
+		goto exit;
 
 	/* update ALU entry */
 	alu_table[0] = ALU_V_STATIC_VALID;
@@ -631,9 +712,13 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	alu_table[3] = ((addr[2] << 24) | (addr[3] << 16));
 	alu_table[3] |= ((addr[4] << 8) | addr[5]);
 
-	ksz9477_write_table(dev, alu_table);
+	ret = ksz9477_write_table(dev, alu_table);
+	if (ret)
+		goto exit;
 
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	ret = ksz9477_wait_alu_ready(dev);
@@ -659,14 +744,20 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 	/* read any entry with mac & vid */
 	data = vid << ALU_FID_INDEX_S;
 	data |= ((addr[0] << 8) | addr[1]);
-	ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+	ret = ksz_write32(dev, REG_SW_ALU_INDEX_0, data);
+	if (ret)
+		goto exit;
 
 	data = ((addr[2] << 24) | (addr[3] << 16));
 	data |= ((addr[4] << 8) | addr[5]);
-	ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+	ret = ksz_write32(dev, REG_SW_ALU_INDEX_1, data);
+	if (ret)
+		goto exit;
 
 	/* start read operation */
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_READ | ALU_START);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	ret = ksz9477_wait_alu_ready(dev);
@@ -675,11 +766,19 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 		goto exit;
 	}
 
-	ksz_read32(dev, REG_SW_ALU_VAL_A, &alu_table[0]);
+	ret = ksz_read32(dev, REG_SW_ALU_VAL_A, &alu_table[0]);
+	if (ret)
+		goto exit;
 	if (alu_table[0] & ALU_V_STATIC_VALID) {
-		ksz_read32(dev, REG_SW_ALU_VAL_B, &alu_table[1]);
-		ksz_read32(dev, REG_SW_ALU_VAL_C, &alu_table[2]);
-		ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
+		ret = ksz_read32(dev, REG_SW_ALU_VAL_B, &alu_table[1]);
+		if (ret)
+			goto exit;
+		ret = ksz_read32(dev, REG_SW_ALU_VAL_C, &alu_table[2]);
+		if (ret)
+			goto exit;
+		ret = ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
+		if (ret)
+			goto exit;
 
 		/* clear forwarding port */
 		alu_table[2] &= ~BIT(port);
@@ -698,9 +797,13 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 		alu_table[3] = 0;
 	}
 
-	ksz9477_write_table(dev, alu_table);
+	ret = ksz9477_write_table(dev, alu_table);
+	if (ret)
+		goto exit;
 
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_WRITE | ALU_START);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	ret = ksz9477_wait_alu_ready(dev);
@@ -749,12 +852,16 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 	mutex_lock(&dev->alu_mutex);
 
 	/* start ALU search */
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_START | ALU_SEARCH);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, ALU_START | ALU_SEARCH);
+	if (ret)
+		goto exit;
 
 	do {
 		timeout = 1000;
 		do {
-			ksz_read32(dev, REG_SW_ALU_CTRL__4, &ksz_data);
+			ret = ksz_read32(dev, REG_SW_ALU_CTRL__4, &ksz_data);
+			if (ret)
+				goto exit;
 			if ((ksz_data & ALU_VALID) || !(ksz_data & ALU_START))
 				break;
 			usleep_range(1, 10);
@@ -767,7 +874,9 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 		}
 
 		/* read ALU table */
-		ksz9477_read_table(dev, alu_table);
+		ret = ksz9477_read_table(dev, alu_table);
+		if (ret)
+			goto exit;
 
 		ksz9477_convert_alu(&alu, alu_table);
 
@@ -779,9 +888,8 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 	} while (ksz_data & ALU_START);
 
 exit:
-
 	/* stop ALU search */
-	ksz_write32(dev, REG_SW_ALU_CTRL__4, 0);
+	ret = ksz_write32(dev, REG_SW_ALU_CTRL__4, 0);
 
 	mutex_unlock(&dev->alu_mutex);
 
@@ -793,9 +901,9 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
-	u32 data;
-	int index;
 	u32 mac_hi, mac_lo;
+	int index, ret;
+	u32 data;
 
 	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
 	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
@@ -807,7 +915,9 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 		/* find empty slot first */
 		data = (index << ALU_STAT_INDEX_S) |
 			ALU_STAT_READ | ALU_STAT_START;
-		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		if (ret)
+			goto exit;
 
 		/* wait to be finished */
 		if (ksz9477_wait_alu_sta_ready(dev)) {
@@ -816,7 +926,9 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 		}
 
 		/* read ALU static table */
-		ksz9477_read_table(dev, static_table);
+		ret = ksz9477_read_table(dev, static_table);
+		if (ret)
+			goto exit;
 
 		if (static_table[0] & ALU_V_STATIC_VALID) {
 			/* check this has same vid & mac address */
@@ -845,10 +957,14 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	static_table[2] |= mac_hi;
 	static_table[3] = mac_lo;
 
-	ksz9477_write_table(dev, static_table);
+	ret = ksz9477_write_table(dev, static_table);
+	if (ret)
+		goto exit;
 
 	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
-	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	if (ksz9477_wait_alu_sta_ready(dev))
@@ -878,7 +994,9 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 		/* find empty slot first */
 		data = (index << ALU_STAT_INDEX_S) |
 			ALU_STAT_READ | ALU_STAT_START;
-		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		if (ret)
+			goto exit;
 
 		/* wait to be finished */
 		ret = ksz9477_wait_alu_sta_ready(dev);
@@ -888,7 +1006,9 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 		}
 
 		/* read ALU static table */
-		ksz9477_read_table(dev, static_table);
+		ret = ksz9477_read_table(dev, static_table);
+		if (ret)
+			goto exit;
 
 		if (static_table[0] & ALU_V_STATIC_VALID) {
 			/* check this has same vid & mac address */
@@ -917,10 +1037,14 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 		static_table[3] = 0;
 	}
 
-	ksz9477_write_table(dev, static_table);
+	ret = ksz9477_write_table(dev, static_table);
+	if (ret)
+		goto exit;
 
 	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
-	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	if (ret)
+		goto exit;
 
 	/* wait to be finished */
 	ret = ksz9477_wait_alu_sta_ready(dev);
@@ -1185,7 +1309,7 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
-static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+static int ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	u8 data8;
 	u8 member;
@@ -1285,6 +1409,8 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* clear pending interrupts */
 	if (port < dev->phy_port_cnt)
 		ksz_pread16(dev, port, REG_PORT_PHY_INT_ENABLE, &data16);
+
+	return 0;
 }
 
 static void ksz9477_config_cpu_port(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d78e61114765..8af33299166e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -123,7 +123,7 @@ struct ksz_dev_ops {
 	void (*phy_setup)(struct ksz_device *dev, int port,
 			  struct phy_device *phy);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
-	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
+	int (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
 	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 	void (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 	int (*r_dyn_mac_table)(struct ksz_device *dev, u16 addr, u8 *mac_addr,
@@ -133,12 +133,12 @@ struct ksz_dev_ops {
 			       struct alu_struct *alu);
 	void (*w_sta_mac_table)(struct ksz_device *dev, u16 addr,
 				struct alu_struct *alu);
-	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
-			  u64 *cnt);
-	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
-			  u64 *dropped, u64 *cnt);
+	int (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
+			 u64 *cnt);
+	int (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
+			 u64 *dropped, u64 *cnt);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
-	void (*port_init_cnt)(struct ksz_device *dev, int port);
+	int (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
 	int (*detect)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
-- 
2.23.0


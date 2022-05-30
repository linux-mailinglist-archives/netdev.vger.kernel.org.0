Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6945853795E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiE3Kq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiE3Koc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:44:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9E7E1CE;
        Mon, 30 May 2022 03:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907463; x=1685443463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/qfF6l2+Qd+DdGpCGovzCwJFmvLnsE3RDiGUt0tx/4=;
  b=kRWGitNXWrKxJq4tmFO8SXK3/Lrn+/jnNt2EqhRHShbvfsbgCv8/04sF
   o0XhR2QUMSUZxX4liP/5qr1uj3j6fG//8s4BASbPJhhicvJrr7pCo2sD7
   +lsy0LFk+ZTBn5mjYPpa1MzVACYf50Tis86JUDx4tEDBx+CMqKFlYYGkm
   QuR+t8BOsD2GLRL5/RU1c+MKXvpY0Q/USmoKb6z4EVH7KR207ayzHw4N3
   hx1Q4i0lQ3Qovt4yp43wkpkqBXSkAv0E5UiOjRizmLg7HwDXsDxECQV6b
   63Z92fBCYPx1TLfcz+yzGlhx+nuFWhZe0LXD/AercjLBf5WS4n3BGPF9G
   A==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="165913242"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:44:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:44:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:44:16 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [RFC Patch net-next v2 09/15] net: dsa: microchip: update fdb add/del/dump in ksz_common
Date:   Mon, 30 May 2022 16:12:51 +0530
Message-ID: <20220530104257.21485-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the dsa_switch_hook for fdbs to use ksz_common.c file.
And from ksz_common, individual switches fdb functions are called using
the dev->dev_ops.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 30 +++++++++++++++
 drivers/net/dsa/microchip/ksz9477.c    | 28 +++++++-------
 drivers/net/dsa/microchip/ksz_common.c | 52 +++++++++++++++-----------
 drivers/net/dsa/microchip/ksz_common.h | 10 +++++
 4 files changed, 84 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index abd28dc44eb5..528de481b319 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -958,6 +958,35 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+static int ksz8_fdb_dump(struct ksz_device *dev, int port,
+			 dsa_fdb_dump_cb_t *cb, void *data)
+{
+	int ret = 0;
+	u16 i = 0;
+	u16 entries = 0;
+	u8 timestamp = 0;
+	u8 fid;
+	u8 member;
+	struct alu_struct alu;
+
+	do {
+		alu.is_static = false;
+		ret = dev->dev_ops->r_dyn_mac_table(dev, i, alu.mac, &fid,
+						    &member, &timestamp,
+						    &entries);
+		if (!ret && (member & BIT(port))) {
+			ret = cb(alu.mac, alu.fid, alu.is_static, data);
+			if (ret)
+				break;
+		}
+		i++;
+	} while (i < entries);
+	if (i >= entries)
+		ret = 0;
+
+	return ret;
+}
+
 static int ksz8_mdb_add(struct ksz_device *dev, int port,
 			const struct switchdev_obj_port_mdb *mdb,
 			struct dsa_db db)
@@ -1528,6 +1557,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 045856656466..d70e0c32b309 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -457,11 +457,10 @@ static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+static int ksz9477_fdb_add(struct ksz_device *dev, int port,
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
 	u32 data;
 	int ret = 0;
@@ -515,11 +514,10 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+static int ksz9477_fdb_del(struct ksz_device *dev, int port,
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
 	u32 data;
 	int ret = 0;
@@ -606,10 +604,9 @@ static void ksz9477_convert_alu(struct alu_struct *alu, u32 *alu_table)
 	alu->mac[5] = alu_table[3] & 0xFF;
 }
 
-static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
-				 dsa_fdb_dump_cb_t *cb, void *data)
+static int ksz9477_fdb_dump(struct ksz_device *dev, int port,
+			    dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct ksz_device *dev = ds->priv;
 	int ret = 0;
 	u32 ksz_data;
 	u32 alu_table[4];
@@ -1315,9 +1312,9 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
 	.port_vlan_del		= ksz_port_vlan_del,
-	.port_fdb_dump		= ksz9477_port_fdb_dump,
-	.port_fdb_add		= ksz9477_port_fdb_add,
-	.port_fdb_del		= ksz9477_port_fdb_del,
+	.port_fdb_dump		= ksz_port_fdb_dump,
+	.port_fdb_add		= ksz_port_fdb_add,
+	.port_fdb_del		= ksz_port_fdb_del,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
 	.port_mirror_add	= ksz_port_mirror_add,
@@ -1403,6 +1400,9 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_stp_reg = ksz9477_get_stp_reg,
 	.get_caps = ksz9477_get_caps,
+	.fdb_dump = ksz9477_fdb_dump,
+	.fdb_add = ksz9477_fdb_add,
+	.fdb_del = ksz9477_fdb_del,
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.shutdown = ksz9477_reset_switch,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index b9082952db0f..8f79ff1ac648 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -765,32 +765,40 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_port_fast_age);
 
+int ksz_port_fdb_add(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->fdb_add)
+		ret = dev->dev_ops->fdb_add(dev, port, addr, vid, db);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ksz_port_fdb_add);
+
+int ksz_port_fdb_del(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->fdb_del)
+		ret = dev->dev_ops->fdb_del(dev, port, addr, vid, db);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ksz_port_fdb_del);
+
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data)
 {
 	struct ksz_device *dev = ds->priv;
-	int ret = 0;
-	u16 i = 0;
-	u16 entries = 0;
-	u8 timestamp = 0;
-	u8 fid;
-	u8 member;
-	struct alu_struct alu;
-
-	do {
-		alu.is_static = false;
-		ret = dev->dev_ops->r_dyn_mac_table(dev, i, alu.mac, &fid,
-						    &member, &timestamp,
-						    &entries);
-		if (!ret && (member & BIT(port))) {
-			ret = cb(alu.mac, alu.fid, alu.is_static, data);
-			if (ret)
-				break;
-		}
-		i++;
-	} while (i < entries);
-	if (i >= entries)
-		ret = 0;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->fdb_dump)
+		ret = dev->dev_ops->fdb_dump(dev, port, cb, data);
 
 	return ret;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 816581dd7f8e..133b1a257868 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -192,6 +192,12 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	int (*fdb_add)(struct ksz_device *dev, int port,
+		       const unsigned char *addr, u16 vid, struct dsa_db db);
+	int (*fdb_del)(struct ksz_device *dev, int port,
+		       const unsigned char *addr, u16 vid, struct dsa_db db);
+	int (*fdb_dump)(struct ksz_device *dev, int port,
+			dsa_fdb_dump_cb_t *cb, void *data);
 	int (*mdb_add)(struct ksz_device *dev, int port,
 		       const struct switchdev_obj_port_mdb *mdb,
 		       struct dsa_db db);
@@ -239,6 +245,10 @@ void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
+int ksz_port_fdb_add(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db);
+int ksz_port_fdb_del(struct dsa_switch *ds, int port,
+		     const unsigned char *addr, u16 vid, struct dsa_db db);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-- 
2.36.1


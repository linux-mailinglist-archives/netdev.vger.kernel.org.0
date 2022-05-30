Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2772E537949
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiE3KoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiE3Knz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:43:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7793D7CB29;
        Mon, 30 May 2022 03:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907427; x=1685443427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J9QShkTnOJrDGyfjbmKjZwhOxg4CtQ5nHxBThRK/WOQ=;
  b=UJnvnfAl4jnJ3sJfqUj526B+4frrgxWFuyFS3TYFfEADqMfWTbQDYO/K
   mSAaOxZ4Ymewau+2FFYjKoLBX2PdACTiwLDlWcszPFSJKfoZTg+nRK6I/
   nWxxgHpCwwiQ1toDK5nGAjebIVcfNSNIOVd+ZJYcPa6BwnuH1C87vMQ5a
   A1XfB/olYk8UepkZYgJTuy94doVDrXsY9HqPiwdxP4t6LDDKqColmpXSI
   /bDWNAlNq5oaMIrLEE2l6bpTbA5ZQBbW26wkPwM4SvWsCRWkg2aKd1p9c
   3DQvP7VuT8eJPmKYSHIe2BaRweSiH05T7qSf1h/Az1kC/kBZpXbntRZGF
   w==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="165913115"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:43:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:43:45 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:43:40 -0700
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
Subject: [RFC Patch net-next v2 04/15] net: dsa: microchip: move vlan functionality to ksz_common
Date:   Mon, 30 May 2022 16:12:46 +0530
Message-ID: <20220530104257.21485-5-arun.ramadoss@microchip.com>
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

This patch moves the vlan dsa_switch_ops such as vlan_add, vlan_del and
vlan_filtering from the individual files ksz8795.c, ksz9477.c to
ksz_common.c file.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 19 ++++++------
 drivers/net/dsa/microchip/ksz9477.c    | 19 ++++++------
 drivers/net/dsa/microchip/ksz_common.c | 40 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 14 +++++++++
 4 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 6e5f665fa1f6..157d69e46793 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -958,11 +958,9 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
+static int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 				    struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
@@ -987,12 +985,11 @@ static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
 	}
 }
 
-static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
+static int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 			      const struct switchdev_obj_port_vlan *vlan,
 			      struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
@@ -1060,10 +1057,9 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
+static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
-	struct ksz_device *dev = ds->priv;
 	u16 data, pvid;
 	u8 fid, member, valid;
 
@@ -1398,9 +1394,9 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz8_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz8_port_vlan_filtering,
-	.port_vlan_add		= ksz8_port_vlan_add,
-	.port_vlan_del		= ksz8_port_vlan_del,
+	.port_vlan_filtering	= ksz_port_vlan_filtering,
+	.port_vlan_add		= ksz_port_vlan_add,
+	.port_vlan_del		= ksz_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
@@ -1465,6 +1461,9 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.vlan_filtering = ksz8_port_vlan_filtering,
+	.vlan_add = ksz8_port_vlan_add,
+	.vlan_del = ksz8_port_vlan_del,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4fb96e53487e..e230fe1d1917 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -372,12 +372,10 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
-static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 				       bool flag,
 				       struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (flag) {
 		ksz_port_cfg(dev, port, REG_PORT_LUE_CTRL,
 			     PORT_VLAN_LOOKUP_VID_0, true);
@@ -391,11 +389,10 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 				 const struct switchdev_obj_port_vlan *vlan,
 				 struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	int err;
@@ -428,10 +425,9 @@ static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 				 const struct switchdev_obj_port_vlan *vlan)
 {
-	struct ksz_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
 	u16 pvid;
@@ -1323,9 +1319,9 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz9477_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
-	.port_vlan_add		= ksz9477_port_vlan_add,
-	.port_vlan_del		= ksz9477_port_vlan_del,
+	.port_vlan_filtering	= ksz_port_vlan_filtering,
+	.port_vlan_add		= ksz_port_vlan_add,
+	.port_vlan_del		= ksz_port_vlan_del,
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
 	.port_fdb_add		= ksz9477_port_fdb_add,
 	.port_fdb_del		= ksz9477_port_fdb_del,
@@ -1407,6 +1403,9 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.vlan_filtering = ksz9477_port_vlan_filtering,
+	.vlan_add = ksz9477_port_vlan_add,
+	.vlan_del = ksz9477_port_vlan_del,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a43b01c2e67f..a1fef9e4e36c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -954,6 +954,46 @@ enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
 
+int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
+			    bool flag, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->vlan_filtering)
+		ret = dev->dev_ops->vlan_filtering(dev, port, flag, extack);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_filtering);
+
+int ksz_port_vlan_add(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->vlan_add)
+		ret = dev->dev_ops->vlan_add(dev, port, vlan, extack);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_add);
+
+int ksz_port_vlan_del(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->vlan_del)
+		ret = dev->dev_ops->vlan_del(dev, port, vlan);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f253f3f22386..03e738c0cbb8 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -180,6 +180,13 @@ struct ksz_dev_ops {
 	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
 			  u64 *dropped, u64 *cnt);
 	void (*r_mib_stat64)(struct ksz_device *dev, int port);
+	int  (*vlan_filtering)(struct ksz_device *dev, int port,
+			       bool flag, struct netlink_ext_ack *extack);
+	int  (*vlan_add)(struct ksz_device *dev, int port,
+			 const struct switchdev_obj_port_vlan *vlan,
+			 struct netlink_ext_ack *extack);
+	int  (*vlan_del)(struct ksz_device *dev, int port,
+			 const struct switchdev_obj_port_vlan *vlan);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -233,6 +240,13 @@ void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf);
 enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 					   int port, enum dsa_tag_protocol mp);
+int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
+			    bool flag, struct netlink_ext_ack *extack);
+int ksz_port_vlan_add(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack);
+int ksz_port_vlan_del(struct dsa_switch *ds, int port,
+		      const struct switchdev_obj_port_vlan *vlan);
 
 /* Common register access functions */
 
-- 
2.36.1


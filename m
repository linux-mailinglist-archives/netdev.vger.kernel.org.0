Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2B654F361
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381257AbiFQIow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381221AbiFQIom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:44:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F5D69B5B;
        Fri, 17 Jun 2022 01:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455480; x=1686991480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mZAcUmb/d9xeVUDNNBF1SQk1BOA5VxuXDxhk9omzZRE=;
  b=PcKnEpb3y6gji1Y5Ul+1mkj0mACrJF+Vkviphrefn9Tv/sTeQFh4+XIe
   5x6RGI8VznO3eJUspl7JjCUK9cjfPk56XQMLLcxQyEal3QZopbA6u7RjH
   QIKqSjVQEk9DAEGNuc9Q33u0TmNVFjAaGIi4/HWlFUG/SuumuqfvvFGJi
   9tU3TVr1gH+geWf7d9ezbRa/JOwyPE+M4VnHAdnsJ/aVvV8bzUAF0dhS/
   /Cnkaqtw135WYZvMeBe+xSuKsHo/Bsk8+C8SPcH8wNDHPkskpIv90bL0+
   EeKdhRYgZsfVqE6PZlPFp0Du+A8gSUbeqP4t16sd7aSHbRXn9maZJrS0v
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="100484937"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:44:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:44:31 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:27 -0700
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
Subject: [Patch net-next 06/11] net: dsa: microchip: move the port mirror to ksz_common
Date:   Fri, 17 Jun 2022 14:12:50 +0530
Message-ID: <20220617084255.19376-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617084255.19376-1-arun.ramadoss@microchip.com>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
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

This patch updates the common port mirror add/del dsa_switch_ops in
ksz_common.c. The individual switches implementation is executed based
on the ksz_dev_ops function pointers.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 ++++++-------
 drivers/net/dsa/microchip/ksz9477.c    | 12 ++++++------
 drivers/net/dsa/microchip/ksz_common.c | 23 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 10 ++++++++++
 4 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 16e946dbd9d4..2e3d24a3260e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1089,12 +1089,10 @@ static int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
+static int ksz8_port_mirror_add(struct ksz_device *dev, int port,
 				struct dsa_mall_mirror_tc_entry *mirror,
 				bool ingress, struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
-
 	if (ingress) {
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
 		dev->mirror_rx |= BIT(port);
@@ -1113,10 +1111,9 @@ static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8_port_mirror_del(struct dsa_switch *ds, int port,
+static void ksz8_port_mirror_del(struct ksz_device *dev, int port,
 				 struct dsa_mall_mirror_tc_entry *mirror)
 {
-	struct ksz_device *dev = ds->priv;
 	u8 data;
 
 	if (mirror->ingress) {
@@ -1400,8 +1397,8 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.port_fdb_dump		= ksz_port_fdb_dump,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
-	.port_mirror_add	= ksz8_port_mirror_add,
-	.port_mirror_del	= ksz8_port_mirror_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
 };
 
 static u32 ksz8_get_port_addr(int port, int offset)
@@ -1464,6 +1461,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_filtering = ksz8_port_vlan_filtering,
 	.vlan_add = ksz8_port_vlan_add,
 	.vlan_del = ksz8_port_vlan_del,
+	.mirror_add = ksz8_port_mirror_add,
+	.mirror_del = ksz8_port_mirror_del,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e230fe1d1917..6796c9d89ab9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -811,11 +811,10 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
+static int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
 				   bool ingress, struct netlink_ext_ack *extack)
 {
-	struct ksz_device *dev = ds->priv;
 	u8 data;
 	int p;
 
@@ -851,10 +850,9 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
+static void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
 				    struct dsa_mall_mirror_tc_entry *mirror)
 {
-	struct ksz_device *dev = ds->priv;
 	bool in_use = false;
 	u8 data;
 	int p;
@@ -1327,8 +1325,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_del		= ksz9477_port_fdb_del,
 	.port_mdb_add           = ksz9477_port_mdb_add,
 	.port_mdb_del           = ksz9477_port_mdb_del,
-	.port_mirror_add	= ksz9477_port_mirror_add,
-	.port_mirror_del	= ksz9477_port_mirror_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
 	.port_change_mtu	= ksz9477_change_mtu,
 	.port_max_mtu		= ksz9477_max_mtu,
@@ -1406,6 +1404,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
+	.mirror_add = ksz9477_port_mirror_add,
+	.mirror_del = ksz9477_port_mirror_del,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d63af57c76e4..340cad43deea 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -991,6 +991,29 @@ int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
 
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->mirror_add)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->mirror_add(dev, port, mirror, ingress, extack);
+}
+EXPORT_SYMBOL_GPL(ksz_port_mirror_add);
+
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->mirror_del)
+		dev->dev_ops->mirror_del(dev, port, mirror);
+}
+EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1baa270859aa..c724cbb437e2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -187,6 +187,11 @@ struct ksz_dev_ops {
 			 struct netlink_ext_ack *extack);
 	int  (*vlan_del)(struct ksz_device *dev, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
+	int (*mirror_add)(struct ksz_device *dev, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack);
+	void (*mirror_del)(struct ksz_device *dev, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -247,6 +252,11 @@ int ksz_port_vlan_add(struct dsa_switch *ds, int port,
 		      struct netlink_ext_ack *extack);
 int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 		      const struct switchdev_obj_port_vlan *vlan);
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack);
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror);
 
 /* Common register access functions */
 
-- 
2.36.1


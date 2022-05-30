Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888B753794B
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiE3Kof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiE3KoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:44:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8567CB6A;
        Mon, 30 May 2022 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907436; x=1685443436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOUxOz0CuZ6ZV6n9fE6Ut+b/Kon8oZeIxhvj1TjAWCo=;
  b=iNCBxLFtoAC7kAjtA8PW5MxFk8Tdc7pT8EXXO1iuByTcslnZ5m2dge1n
   J5A7is28Ff5A8Ff5pSX46gHAGUVu2m8Q+F8CrqRxGoA4csBVDvGu7FzKd
   M5+QqOy5QlivmWoDYKcS8Y8S9vHeV2WAwrj3vYHzOYN62bEkJWkmYr8RU
   WWl0v84OIIBZNbbEKLYcuJsbrSfqaxzESH5K1ZXeVfRiLAFa2UcbIfAai
   cwI5Fdm4K4cz6oijRwDPtinpIX5K3zgq6/0nnbT+9ZeQVre5VxOUvRSp3
   8mGsvvLGUdYzjADB0vG6f0cv6nMZqDZnEq0l8bN16Miq4BVt1fxjZ+pXM
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="175663041"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:43:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:43:53 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:43:48 -0700
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
Subject: [RFC Patch net-next v2 05/15] net: dsa: microchip: move the port mirror to ksz_common
Date:   Mon, 30 May 2022 16:12:47 +0530
Message-ID: <20220530104257.21485-6-arun.ramadoss@microchip.com>
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

This patch updates the common port mirror add/del dsa_switch_ops in
ksz_common.c. The individual switches implementation is executed based
on the ksz_dev_ops function pointers.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 ++++++-------
 drivers/net/dsa/microchip/ksz9477.c    | 12 ++++++------
 drivers/net/dsa/microchip/ksz_common.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 10 ++++++++++
 4 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 157d69e46793..8657b520b336 100644
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
index a1fef9e4e36c..1ed4cc94795e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -994,6 +994,31 @@ int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
 
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = -EOPNOTSUPP;
+
+	if (dev->dev_ops->mirror_add)
+		ret = dev->dev_ops->mirror_add(dev, port, mirror, ingress,
+					       extack);
+
+	return ret;
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
index 03e738c0cbb8..01080ec22bf1 100644
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


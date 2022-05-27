Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB35359E0
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344168AbiE0HH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345244AbiE0HGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:06:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B2DF136B;
        Fri, 27 May 2022 00:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653635212; x=1685171212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AXEma/wXIo46/RpjwWuiE+84rIu0sswJH6jcqexjMHM=;
  b=zCzYuE+GHqwqb786rPr30j21edrIOQammjeF/arqXzDD4Ux6SagbbvYv
   aGCAwxyCxI63vjxQlpQ5kU4dZ8TlfVQuX8+VkDIhRJwqaGeBNC6kulWqM
   B87X7H4qT0gq/78yIdl2xEjMbrZUgIzMcO39+K1vQboaEY4ng2poLU46a
   Xbjv2zT5Ls00UoL4jmHsOpK4MC+eSGY5xV3LGtpuVtIW7m+1zVvKYPfBz
   nwF/A4D+2xYuUJM+YhzEGfHKYSDEAg5qfnDa4L5HS3kLFsYROWPgO9n8l
   /IQ2UQeJvOsHna12zlrLCBLWzIo/csQwR5sdzQtpWmOV8PJ2F4XVc0cp6
   A==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="175350445"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2022 00:06:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 27 May 2022 00:06:47 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 27 May 2022 00:06:42 -0700
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
Subject: [RFC Patch net-next 07/17] net: dsa: microchip: get P_STP_CTRL in ksz_port_stp_state by ksz_dev_ops
Date:   Fri, 27 May 2022 12:33:48 +0530
Message-ID: <20220527070358.25490-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527070358.25490-1-arun.ramadoss@microchip.com>
References: <20220527070358.25490-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, P_STP_CTRL register value is passed as parameter to
ksz_port_stp_state from the individual dsa_switch_ops hooks. This patch
update the function to retrieve the register value through the
ksz_dev_ops function pointer.
And add the static to ksz_update_port_member since it is not called
outside the ksz_common.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  9 +++++----
 drivers/net/dsa/microchip/ksz9477.c    | 10 +++++-----
 drivers/net/dsa/microchip/ksz_common.c |  9 +++++----
 drivers/net/dsa/microchip/ksz_common.h |  5 ++---
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8657b520b336..e6982fa9d382 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -920,9 +920,9 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
 }
 
-static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+static int ksz8_get_stp_reg(void)
 {
-	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
+	return P_STP_CTRL;
 }
 
 static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1240,7 +1240,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
 
-		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
 		if (i == dev->phy_port_cnt)
@@ -1389,7 +1389,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz8_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
@@ -1463,6 +1463,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_del = ksz8_port_vlan_del,
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
+	.get_stp_reg = ksz8_get_stp_reg,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 6796c9d89ab9..f08694aba6bb 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -344,10 +344,9 @@ static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
 	ksz_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
-static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
-				       u8 state)
+static int ksz9477_get_stp_reg(void)
 {
-	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
+	return P_STP_CTRL;
 }
 
 static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
@@ -1237,7 +1236,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			continue;
 		p = &dev->ports[i];
 
-		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
 		if (i < dev->phy_port_cnt)
 			p->phy = 1;
@@ -1315,7 +1314,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz9477_port_stp_state_set,
+	.port_stp_state_set	= ksz_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
@@ -1406,6 +1405,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_del = ksz9477_port_vlan_del,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
+	.get_stp_reg = ksz9477_get_stp_reg,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1ed4cc94795e..5cf183f753d9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -532,7 +532,7 @@ void ksz_get_strings(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_get_strings);
 
-void ksz_update_port_member(struct ksz_device *dev, int port)
+static void ksz_update_port_member(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
@@ -589,7 +589,6 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
-EXPORT_SYMBOL_GPL(ksz_update_port_member);
 
 static void port_r_cnt(struct ksz_device *dev, int port)
 {
@@ -890,12 +889,14 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
-void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
-			    u8 state, int reg)
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
 	u8 data;
+	int reg;
+
+	reg = dev->dev_ops->get_stp_reg();
 
 	ksz_pread8(dev, port, reg, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 01080ec22bf1..2727934b7171 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -192,6 +192,7 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	int (*get_stp_reg)(void);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
@@ -207,7 +208,6 @@ void ksz_switch_remove(struct ksz_device *dev);
 int ksz8_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
 
-void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_get_stats64(struct dsa_switch *ds, int port,
@@ -229,8 +229,7 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
-void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
-			    u8 state, int reg);
+void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
-- 
2.36.1


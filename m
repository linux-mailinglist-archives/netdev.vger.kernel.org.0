Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACF75548F4
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356308AbiFVJJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357322AbiFVJId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:08:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CD53AA73;
        Wed, 22 Jun 2022 02:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888827; x=1687424827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LMRJkXQESxFAGWk9Jr0RGQeR5yqRLWxs4I0JojDeyg=;
  b=cVulY40d4Vdh2BW2XXXi/3o5KJwX6BQjwUK7PwIYbxvpJWmmGGaQyBIl
   NuJ//9z9nedSJp5JLwbyOV6T+jKrEs2iaLzfCEgoHgHkLyrh6bbc0XdB0
   mncY7I8P/GuSYBZXOWmoPtCU+PiybNviSQcd7xhfO9n+vJNxuPr64UfH9
   VqTVyWmoYbK8EvwQZdzypButAJ+99d6CM0n18YTV2sQnTx5gh1OYpK6tA
   fkgAtJSwEq+8srVPjngHeVwuG2HHD4Z0/wKPjgcRwDYJXa8/pkts7JVT4
   GpN/50cxvyn0X9G9wTuuly3reZ0UZmMb+0czVqo8f/labjY2+/R0k3ma4
   g==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="179017143"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:07:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:07:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:07:00 -0700
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
Subject: [Patch net-next 03/13] net: dsa: microchip: add the enable_stp_addr pointer in ksz_dev_ops
Date:   Wed, 22 Jun 2022 14:34:15 +0530
Message-ID: <20220622090425.17709-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
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

In order to transmit the STP BPDU packet to the CPU port, the STP
address 01-80-c2-00-00-00 has to be added to static alu table for
ksz8795 series switch. For the ksz9477 switch, there is reserved
multicast table which handles forwarding the particular set of
multicast address to cpu port. So enabling the multicast reserved table
and updated the cpu port index. The stp addr is enabled during the setup
phase using the enable_stp_addr pointer in struct ksz_dev_ops.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 27 ++++++++++++++-------
 drivers/net/dsa/microchip/ksz9477.c    | 33 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 3 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 0df2140b7ccc..30052dc5b9a1 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1368,10 +1368,25 @@ static int ksz8_handle_global_errata(struct dsa_switch *ds)
 	return ret;
 }
 
+static int ksz8_enable_stp_addr(struct ksz_device *dev)
+{
+	struct alu_struct alu;
+
+	/* Setup STP address for STP operation. */
+	memset(&alu, 0, sizeof(alu));
+	ether_addr_copy(alu.mac, eth_stp_addr);
+	alu.is_static = true;
+	alu.is_override = true;
+	alu.port_forward = dev->info->cpu_ports;
+
+	ksz8_w_sta_mac_table(dev, 0, &alu);
+
+	return 0;
+}
+
 static int ksz8_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	struct alu_struct alu;
 	int i, ret = 0;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
@@ -1422,14 +1437,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 	for (i = 0; i < (dev->info->num_vlans / 4); i++)
 		ksz8_r_vlan_entries(dev, i);
 
-	/* Setup STP address for STP operation. */
-	memset(&alu, 0, sizeof(alu));
-	ether_addr_copy(alu.mac, eth_stp_addr);
-	alu.is_static = true;
-	alu.is_override = true;
-	alu.port_forward = dev->info->cpu_ports;
-
-	ksz8_w_sta_mac_table(dev, 0, &alu);
+	dev->dev_ops->enable_stp_addr(dev);
 
 	ksz_init_mib_timer(dev);
 
@@ -1546,6 +1554,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
 	.config_cpu_port = ksz8_config_cpu_port,
+	.enable_stp_addr = ksz8_enable_stp_addr,
 	.reset = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index fef8142440cf..6ca0d5753df0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1236,6 +1236,36 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
+static int ksz9477_enable_stp_addr(struct ksz_device *dev)
+{
+	u32 data;
+	int ret;
+
+	/* Enable Reserved multicast table */
+	ksz_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
+
+	/* Set the Override bit for forwarding BPDU packet to CPU */
+	ret = ksz_write32(dev, REG_SW_ALU_VAL_B,
+			  ALU_V_OVERRIDE | BIT(dev->cpu_port));
+	if (ret < 0)
+		return ret;
+
+	data = ALU_STAT_START | ALU_RESV_MCAST_ADDR;
+
+	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+	if (ret < 0)
+		return ret;
+
+	/* wait to be finished */
+	ret = ksz9477_wait_alu_sta_ready(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to update Reserved Multicast table\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -1281,6 +1311,8 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	/* start switch */
 	ksz_cfg(dev, REG_SW_OPERATION, SW_START, true);
 
+	dev->dev_ops->enable_stp_addr(dev);
+
 	ksz_init_mib_timer(dev);
 
 	ds->configure_vlan_while_not_filtering = false;
@@ -1401,6 +1433,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.change_mtu = ksz9477_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
 	.config_cpu_port = ksz9477_config_cpu_port,
+	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d5b53b5b7b51..e38bdf1f5b41 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -205,6 +205,7 @@ struct ksz_dev_ops {
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	void (*config_cpu_port)(struct dsa_switch *ds);
+	int (*enable_stp_addr)(struct ksz_device *dev);
 	int (*reset)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
-- 
2.36.1


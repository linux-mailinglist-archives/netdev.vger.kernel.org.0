Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7345617AA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiF3KXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiF3KXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:23:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFD145534;
        Thu, 30 Jun 2022 03:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656584581; x=1688120581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKy55q+XdP7GS6YdLTU0y4L8L6D7YkjTxTiaOU22vYk=;
  b=sTf4cNpYKeoYASM5ca8lv9hN87ZfBp6PQqBfzU/EI1tscwP8STVtBTnW
   hz7WVh8aEffHPiJGQv2gwo2jvtv1M52gZ81BLBTv0TASHOtHuc3m6m7dm
   NuktIgbsnxRVz7IWcn5RmRRGpXbg52nG0I23n+rd0Gxv8v7nSRjnIFiJz
   b7gcBtxdHVzyThBTN7DcMKs8Ds4nUA83mmYL8KXBjcBg/2fJt4TBRx65F
   NhwffBfH+XkjYNwmkV0On1rBAFRYZLL2zqrT+2p494V98akkuLbRVWk00
   +ovR4mlRjSHKPhsf6f02TRgeIZu4TBMqj8l80V+scUkYHgyk0if554nTw
   A==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="162744565"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 03:23:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 03:22:58 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 03:22:50 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v14 09/13] net: dsa: microchip: lan937x: add MTU and fast_age support
Date:   Thu, 30 Jun 2022 15:50:37 +0530
Message-ID: <20220630102041.25555-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630102041.25555-1-arun.ramadoss@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the support for port_max_mtu, port_change_mtu and
port_fast_age dsa functionality.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |  2 ++
 drivers/net/dsa/microchip/lan937x.h      |  1 +
 drivers/net/dsa/microchip/lan937x_main.c | 28 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  5 +++++
 4 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 67bb4bff4d9b..fb0de48a3f5e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -206,6 +206,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.setup = lan937x_setup,
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
+	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = lan937x_port_setup,
 	.r_phy = lan937x_r_phy,
 	.w_phy = lan937x_w_phy,
@@ -224,6 +225,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.fdb_del = ksz9477_fdb_del,
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
+	.change_mtu = lan937x_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
 	.config_cpu_port = lan937x_config_cpu_port,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 370203406a05..50563874600d 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -14,4 +14,5 @@ int lan937x_switch_init(struct ksz_device *dev);
 void lan937x_switch_exit(struct ksz_device *dev);
 void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
 void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
+int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7090947cf52c..5917cc11ba59 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -9,6 +9,7 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/math.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -284,6 +285,33 @@ void lan937x_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
+int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
+{
+	struct dsa_switch *ds = dev->ds;
+	int ret;
+
+	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	if (dsa_is_cpu_port(ds, port))
+		new_mtu += LAN937X_TAG_LEN;
+
+	if (new_mtu >= FR_MIN_SIZE)
+		ret = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
+				       PORT_JUMBO_PACKET, true);
+	else
+		ret = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
+				       PORT_JUMBO_PACKET, false);
+	if (ret < 0) {
+		dev_err(ds->dev, "failed to enable jumbo\n");
+		return ret;
+	}
+
+	/* Write the frame size in PORT_MAX_FR_SIZE register */
+	ksz_pwrite16(dev, port, PORT_MAX_FR_SIZE, new_mtu);
+
+	return 0;
+}
+
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 7a0fa2595950..19f3aa344228 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -149,6 +149,9 @@
 #define PORT_BACK_PRESSURE		BIT(3)
 #define PORT_PASS_ALL			BIT(0)
 
+#define PORT_MAX_FR_SIZE		0x404
+#define FR_MIN_SIZE		1522
+
 /* 8 - Classification and Policing */
 #define REG_PORT_MRI_PRIO_CTRL		0x0801
 #define PORT_HIGHEST_PRIO		BIT(7)
@@ -161,4 +164,6 @@
 
 #define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
 
+#define LAN937X_TAG_LEN			2
+
 #endif
-- 
2.36.1


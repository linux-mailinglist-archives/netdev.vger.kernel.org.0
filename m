Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD751739A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386129AbiEBQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386306AbiEBQGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:06:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4CF13E33;
        Mon,  2 May 2022 09:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507335; x=1683043335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+rCtV1iavC/O998Lu4+YGLSEk0OPAQ/6AUuzNmdoY4Y=;
  b=PSqrS9ci99QfH2ycjNklXv+A5FD2P9h7zwq9RZuPtM8O+fYah89SAP3j
   UnnZw2nIC3SGKosmlfkfuksEZUmji8ijhsq1ck1nUNItDhOijynuVOy51
   kus2k3ZEK4tSc8c8cDb36dtqBu6gxHqoP2p6HhaiRevC2kWb+5jIZWjyb
   eLhpHpNQ07P34dzbiw3wAtATrhbZvunhY4aehb/PxbSV85MQpRoBl+Rif
   6C6tVufNst87b0KAx/hcfXI2bHErdD9bt6yeoYM6AckPGcNmS5pFQjqJp
   JCexz378CqrDCLHEt5FdqOtFUP06TBviJkamFaNZ3hkcKgRQamMFEbG1g
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="162031990"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:02:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:02:13 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:01:56 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 08/13] net: dsa: microchip: add support for MTU configuration and fast_age
Date:   Mon, 2 May 2022 21:28:43 +0530
Message-ID: <20220502155848.30493-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
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

This patch add the support for port_max_mtu, port_change_mtu and
port_fast_age dsa functionality.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 31 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_main.c | 44 ++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index f430a8711775..353800edfa54 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -63,6 +63,36 @@ void lan937x_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 	lan937x_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
 }
 
+static void lan937x_flush_dyn_mac_table(struct ksz_device *dev, int port)
+{
+	unsigned int value;
+	u8 data;
+
+	regmap_update_bits(dev->regmap[0], REG_SW_LUE_CTRL_2,
+			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
+			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
+
+	if (port < dev->port_cnt) {
+		/* flush individual port */
+		lan937x_pread8(dev, port, P_STP_CTRL, &data);
+		if (!(data & PORT_LEARN_DISABLE))
+			lan937x_pwrite8(dev, port, P_STP_CTRL,
+					(data | PORT_LEARN_DISABLE));
+		lan937x_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_DYN_MAC_TABLE,
+			    true);
+
+		regmap_read_poll_timeout(dev->regmap[0], S_FLUSH_TABLE_CTRL,
+					 value,
+					 !(value & SW_FLUSH_DYN_MAC_TABLE), 10,
+					 1000);
+
+		lan937x_pwrite8(dev, port, P_STP_CTRL, data);
+	} else {
+		/* flush all */
+		lan937x_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_STP_TABLE, true);
+	}
+}
+
 int lan937x_reset_switch(struct ksz_device *dev)
 {
 	u32 data32;
@@ -437,6 +467,7 @@ static int lan937x_init(struct ksz_device *dev)
 const struct ksz_dev_ops lan937x_dev_ops = {
 	.get_port_addr = lan937x_get_port_addr,
 	.cfg_port_member = lan937x_cfg_port_member,
+	.flush_dyn_mac_table = lan937x_flush_dyn_mac_table,
 	.port_setup = lan937x_port_setup,
 	.shutdown = lan937x_reset_switch,
 	.detect = lan937x_switch_detect,
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 88ca91f59a6f..f48b54d9d2c0 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -8,6 +8,7 @@
 #include <linux/phy.h>
 #include <linux/of_net.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/math.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -217,6 +218,46 @@ static int lan937x_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static int lan937x_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	if (dsa_is_cpu_port(ds, port))
+		new_mtu += LAN937X_TAG_LEN;
+
+	if (new_mtu >= FR_MIN_SIZE)
+		ret = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
+				       PORT_JUMBO_EN, true);
+	else
+		ret = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
+				       PORT_JUMBO_EN, false);
+	if (ret < 0) {
+		dev_err(ds->dev, "failed to enable jumbo\n");
+		return ret;
+	}
+
+	/* Write the frame size in PORT_MAX_FR_SIZE register */
+	ret = lan937x_pwrite16(dev, port, PORT_MAX_FR_SIZE, new_mtu);
+	if (ret < 0) {
+		dev_err(ds->dev, "failed to change the mtu\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	/* Frame max size is 9000 (= 0x2328) if
+	 * jumbo frame support is enabled, PORT_JUMBO_EN bit will be enabled
+	 * based on mtu in lan937x_change_mtu() API
+	 */
+	return (FR_MAX_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
@@ -226,6 +267,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
+	.port_fast_age = ksz_port_fast_age,
+	.port_max_mtu = lan937x_get_max_mtu,
+	.port_change_mtu = lan937x_change_mtu,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.33.0


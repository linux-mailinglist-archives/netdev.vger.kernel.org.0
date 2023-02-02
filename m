Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278B4687E13
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjBBM6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBM6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:58:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB254EF82;
        Thu,  2 Feb 2023 04:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342726; x=1706878726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bxVhL1m9KqOfZ9Y/N1jqZpYPk1To2xrlI3Xdh5PfAks=;
  b=EiVff7QfUvQrneIJCVgjDlXUuhtQ4/cOcZXp9T5WL/QQIJuTZKWTfG5g
   MroN2ACLf9AAfo/nN/u7nNDNhaY25W2pZ8gn9Ofnm5j0oJLkTkpWfAzUl
   ApsH+60Qu0ulWZTBeZcpb6QE9kFlGuIZgXmF0FYg7h4Ey5PtWZ+aVfpqz
   jak+nhkj8MVKmSVKk+YE4Vvh9pn5//OHXmfpsAkP0zeI8zvPDCrYl4CLY
   faR+UH3CTpExA5IChn0Wrjn6e/XKHgw5XbA2bo/D89nPGwJ6SAvJFnbIE
   7DwjxKlPge88oSpUU2mqWFaWi2lrBdqQiBRBsKDO2rVGJhvj58WuyeVNh
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="198620506"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:58:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:58:44 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:39 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 03/11] net: dsa: microchip: lan937x: enable cascade port
Date:   Thu, 2 Feb 2023 18:29:22 +0530
Message-ID: <20230202125930.271740-4-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get index of cascaded port (if any) from device tree and enable
the feature. These ports referenced as dev->dsa_port and will be
used for processing further based on cascaded connection.

For the second switch in cascaded connection, no dev->cpu_port will
be assigned, and same happens for dev->dsa_port variable for switches
without cascading. For the single switch design, there is no way
dev->cpu_port will be unassigned. But coming to cascaded connection,
it can be unassigned, and they will be having value zero. Keeping the
initial value as zero will create error in other features like port
forwarding since DSA will misunderstood these as port index zero. So
keep the default values as 0xFF which is of invalid value so that if
nothing assigned, taking bitmap of the cpu_port or dsa_port will not
cause any harm.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |  4 +++
 drivers/net/dsa/microchip/ksz_common.h   |  2 ++
 drivers/net/dsa/microchip/lan937x.h      |  1 +
 drivers/net/dsa/microchip/lan937x_main.c | 31 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  3 +++
 5 files changed, 41 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d2ec5acd7b17..ada673b6efc6 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -292,6 +292,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.change_mtu = lan937x_change_mtu,
 	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = lan937x_config_cpu_port,
+	.config_dsa_port = lan937x_config_dsa_port,
 	.tc_cbs_set_cinc = lan937x_tc_cbs_set_cinc,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = lan937x_reset_switch,
@@ -2095,6 +2096,9 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	dev->dev_ops->config_cpu_port(ds);
 
+	if (dev->dev_ops->config_dsa_port)
+		dev->dev_ops->config_dsa_port(ds);
+
 	dev->dev_ops->enable_stp_addr(dev);
 
 	ds->num_tx_queues = dev->info->num_tx_queues;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index aab60f2587bf..c3c3eee178f4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -147,6 +147,7 @@ struct ksz_device {
 	u32 chip_id;
 	u8 chip_rev;
 	int cpu_port;			/* port connected to CPU */
+	int dsa_port;                   /* Port used as cascaded port */
 	u32 smi_index;
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
@@ -358,6 +359,7 @@ struct ksz_dev_ops {
 	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
 	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
 	void (*config_cpu_port)(struct dsa_switch *ds);
+	void (*config_dsa_port)(struct dsa_switch *ds);
 	int (*enable_stp_addr)(struct ksz_device *dev);
 	int (*reset)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 3388d91dbc44..ef84abc31556 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -11,6 +11,7 @@ int lan937x_setup(struct dsa_switch *ds);
 void lan937x_teardown(struct dsa_switch *ds);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 void lan937x_config_cpu_port(struct dsa_switch *ds);
+void lan937x_config_dsa_port(struct dsa_switch *ds);
 int lan937x_switch_init(struct ksz_device *dev);
 void lan937x_switch_exit(struct ksz_device *dev);
 int lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 399a3905e6ca..5108a3f4bf76 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -205,11 +205,42 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	dev->dev_ops->cfg_port_member(dev, port, member);
 }
 
+void lan937x_config_dsa_port(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
+
+	dev->dsa_port = 0xFF;
+
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_is_dsa_port(ds, dp->index)) {
+			ksz_rmw32(dev, REG_SW_CASCADE_MODE_CTL,
+				  CASCADE_PORT_SEL, dp->index);
+			dev->dsa_port = dp->index;
+
+			/* Tail tag should be enabled for switch 0
+			 * in cascaded connection.
+			 */
+			if (dev->smi_index == 0) {
+				lan937x_port_cfg(dev, dp->index, REG_PORT_CTRL_0,
+						 PORT_TAIL_TAG_ENABLE, true);
+			}
+
+			/* Frame check length should be disabled for cascaded ports */
+			lan937x_port_cfg(dev, dp->index, REG_PORT_MAC_CTRL_0,
+					 PORT_CHECK_LENGTH, false);
+		}
+	}
+}
+
 void lan937x_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct dsa_port *dp;
 
+	/* Initializing cpu_port parameter into invalid value */
+	dev->cpu_port = 0xFF;
+
 	dsa_switch_for_each_cpu_port(dp, ds) {
 		if (dev->info->cpu_ports & (1 << dp->index)) {
 			dev->cpu_port = dp->index;
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 45b606b6429f..4f30bc12f7a9 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -32,6 +32,9 @@
 #define REG_SW_PORT_INT_STATUS__4	0x0018
 #define REG_SW_PORT_INT_MASK__4		0x001C
 
+#define REG_SW_CASCADE_MODE_CTL         0x0030
+#define CASCADE_PORT_SEL                7
+
 /* 1 - Global */
 #define REG_SW_GLOBAL_OUTPUT_CTRL__1	0x0103
 #define SW_CLK125_ENB			BIT(1)
-- 
2.34.1


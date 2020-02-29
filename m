Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3F174783
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgB2Ou6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:50:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33549 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgB2Ou6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:50:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id x7so6897508wrr.0
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uLNHyRAjC4wov5hS8QIrpAiZebqdM/djVwvCaNIiAvw=;
        b=FQwOG5Lho9hxft+hEXWJfXH8BSHkHgLdACYHyiy3n1/QaSKrQf8hIFYJq0syzMng0B
         5DA6qSKpXDGV8dhmQi+LOQbeZkSJBfwb9NbUW+n5fSzyY/4gLX9LXp4w8C8SuKlzW0zk
         nB2StB2xUzmHJD5UG10qULSYFujdtD8Et9MN+shVTex1IhYATlfwuIYMJRaI4AdTWaEx
         mQpq0WWUeUIOPAupc4NXQEC6GuRzKGUB5xuXOigiRN5Rd8HEzA8vaR24voOyM6Wxdeug
         VVUbCz44eyo+MlYVkE+p49eCiy/vg8+D9YsF7mQehy+hQYscP+PPGAbE7fRPtUC40RtS
         2q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uLNHyRAjC4wov5hS8QIrpAiZebqdM/djVwvCaNIiAvw=;
        b=UGE2D0FLewruiD41uhubHLk8qV4FJsw9D4RbTy1RyHv4q/0pHeiGsZSStUAGO1zua+
         hlxuh/JcqyIlCTX8Cq89JNjSKua+BQ+boIsnzYAT1Iza4adX9rpx7mmJ4iSBErLg0Z2Y
         OUe3MzNY+TNBliVgaMlk4h0hD8Yys6S7whd0WTTpkcfzrzgUvQtS5t/OKpliYcvghDwo
         JejW6wyBILxPOzzc8G2O2ADA8RHcBYGnTAM3reLfbXSzlTQNGl3ZQNl4IPUYMdRNDYs8
         fQ2zc4Wj7oyZ//kbLAl4J0VrhGjr6tpaMIgicnhKzM1G3+qyLQnoOMhbSDBxl/Hf572Q
         1cQw==
X-Gm-Message-State: APjAAAXU16tKHZELuLegL1FrEhUtAl1mW/h97zIdloRviYqJjKCg/29h
        tM+8yfmlYL7oJmQrOJLhvbM=
X-Google-Smtp-Source: APXvYqynnVLjE4uD01953yGNiRGoJbceLyZL+KKGc59LPfBizSjY6ug+mts61GF+H65295PJ+f8XwA==
X-Received: by 2002:adf:a48f:: with SMTP id g15mr11079553wrb.42.1582987855115;
        Sat, 29 Feb 2020 06:50:55 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j14sm18164015wrn.32.2020.02.29.06.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:50:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 1/2] net: mscc: ocelot: eliminate confusion between CPU and NPI port
Date:   Sat, 29 Feb 2020 16:50:02 +0200
Message-Id: <20200229145003.23751-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229145003.23751-1-olteanv@gmail.com>
References: <20200229145003.23751-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Ocelot has the concept of a CPU port. The CPU port is represented in the
forwarding and the queueing system, but it is not a physical device. The
CPU port can either be accessed via register-based injection/extraction
(which is the case of Ocelot), via Frame-DMA (similar to the first one),
or "connected" to a physical Ethernet port (called NPI in the datasheet)
which is the case of the Felix DSA switch.

In Ocelot the CPU port is at index 11.
In Felix the CPU port is at index 6.

The CPU bit is treated special in the forwarding, as it is never cleared
from the forwarding port mask (once added to it). Other than that, it is
treated the same as a normal front port.

Both Felix and Ocelot should use the CPU port in the same way. This
means that Felix should not use the NPI port directly when forwarding to
the CPU, but instead use the CPU port.

This patch is fixing this such that Felix will use port 6 as its CPU
port, and just use the NPI port to carry the traffic.

Therefore, eliminate the "ocelot->cpu" variable which was holding the
index of the NPI port for Felix, and the index of the CPU port module
for Ocelot, so the variable was actually configuring different things
for different drivers and causing at least part of the confusion.

Also remove the "ocelot->num_cpu_ports" variable, which is the result of
another confusion. The 2 CPU ports mentioned in the datasheet are
because there are two frame extraction channels (register based or DMA
based). This is of no relevance to the driver at the moment, and
invisible to the analyzer module.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: Allan W. Nielsen <allan.nielsen@microchip.com>
---
Changes in v3:
Replaced commit message verbiage with text from Allan Nielsen.

 drivers/net/dsa/ocelot/felix.c           |  7 +--
 drivers/net/ethernet/mscc/ocelot.c       | 62 ++++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_board.c |  7 ++-
 include/soc/mscc/ocelot.h                | 12 +++--
 net/dsa/tag_ocelot.c                     |  3 +-
 5 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7e66821b05b4..65b753b78221 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -512,10 +512,11 @@ static int felix_setup(struct dsa_switch *ds)
 	for (port = 0; port < ds->num_ports; port++) {
 		ocelot_init_port(ocelot, port);
 
+		/* Bring up the CPU port module and configure the NPI port */
 		if (dsa_is_cpu_port(ds, port))
-			ocelot_set_cpu_port(ocelot, port,
-					    OCELOT_TAG_PREFIX_NONE,
-					    OCELOT_TAG_PREFIX_LONG);
+			ocelot_configure_cpu(ocelot, port,
+					     OCELOT_TAG_PREFIX_NONE,
+					     OCELOT_TAG_PREFIX_LONG);
 	}
 
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 86d543ab1ab9..341092f9097c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1398,7 +1398,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	 * a source for the other ports.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
+		if (ocelot->bridge_fwd_mask & BIT(p)) {
 			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
 
 			for (i = 0; i < ocelot->num_phys_ports; i++) {
@@ -1413,18 +1413,10 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 				}
 			}
 
-			/* Avoid the NPI port from looping back to itself */
-			if (p != ocelot->cpu)
-				mask |= BIT(ocelot->cpu);
-
 			ocelot_write_rix(ocelot, mask,
 					 ANA_PGID_PGID, PGID_SRC + p);
 		} else {
-			/* Only the CPU port, this is compatible with link
-			 * aggregation.
-			 */
-			ocelot_write_rix(ocelot,
-					 BIT(ocelot->cpu),
+			ocelot_write_rix(ocelot, 0,
 					 ANA_PGID_PGID, PGID_SRC + p);
 		}
 	}
@@ -2293,27 +2285,34 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 }
 EXPORT_SYMBOL(ocelot_probe_port);
 
-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
-			 enum ocelot_tag_prefix injection,
-			 enum ocelot_tag_prefix extraction)
+/* Configure and enable the CPU port module, which is a set of queues.
+ * If @npi contains a valid port index, the CPU port module is connected
+ * to the Node Processor Interface (NPI). This is the mode through which
+ * frames can be injected from and extracted to an external CPU,
+ * over Ethernet.
+ */
+void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
+			  enum ocelot_tag_prefix injection,
+			  enum ocelot_tag_prefix extraction)
 {
-	/* Configure and enable the CPU port. */
+	int cpu = ocelot->num_phys_ports;
+
+	/* The unicast destination PGID for the CPU port module is unused */
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
+	/* Instead set up a multicast destination PGID for traffic copied to
+	 * the CPU. Whitelisted MAC addresses like the port netdevice MAC
+	 * addresses will be copied to the CPU via this PGID.
+	 */
 	ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
 	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
 			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
 			 ANA_PORT_PORT_CFG, cpu);
 
-	/* If the CPU port is a physical port, set up the port in Node
-	 * Processor Interface (NPI) mode. This is the mode through which
-	 * frames can be injected from and extracted to an external CPU.
-	 * Only one port can be an NPI at the same time.
-	 */
-	if (cpu < ocelot->num_phys_ports) {
+	if (npi >= 0 && npi < ocelot->num_phys_ports) {
 		int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
 
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
-			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
+			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
 			     QSYS_EXT_CPU_CFG);
 
 		if (injection == OCELOT_TAG_PREFIX_SHORT)
@@ -2321,14 +2320,27 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
 			mtu += OCELOT_LONG_PREFIX_LEN;
 
-		ocelot_port_set_mtu(ocelot, cpu, mtu);
+		ocelot_port_set_mtu(ocelot, npi, mtu);
+
+		/* Enable NPI port */
+		ocelot_write_rix(ocelot,
+				 QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
+				 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
+				 QSYS_SWITCH_PORT_MODE_PORT_ENA,
+				 QSYS_SWITCH_PORT_MODE, npi);
+		/* NPI port Injection/Extraction configuration */
+		ocelot_write_rix(ocelot,
+				 SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
+				 SYS_PORT_MODE_INCL_INJ_HDR(injection),
+				 SYS_PORT_MODE, npi);
 	}
 
-	/* CPU port Injection/Extraction configuration */
+	/* Enable CPU port module */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
 			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
 			 QSYS_SWITCH_PORT_MODE, cpu);
+	/* CPU port Injection/Extraction configuration */
 	ocelot_write_rix(ocelot, SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
 			 SYS_PORT_MODE_INCL_INJ_HDR(injection),
 			 SYS_PORT_MODE, cpu);
@@ -2338,10 +2350,8 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 				 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
 				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
 			 ANA_PORT_VLAN_CFG, cpu);
-
-	ocelot->cpu = cpu;
 }
-EXPORT_SYMBOL(ocelot_set_cpu_port);
+EXPORT_SYMBOL(ocelot_configure_cpu);
 
 int ocelot_init(struct ocelot *ocelot)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 1135a18019c7..87ff775897da 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -349,8 +349,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->ptp = 1;
 	}
 
-	ocelot->num_cpu_ports = 1; /* 1 port on the switch, two groups */
-
 	ports = of_get_child_by_name(np, "ethernet-ports");
 	if (!ports) {
 		dev_err(&pdev->dev, "no ethernet-ports child node found\n");
@@ -363,8 +361,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 
 	ocelot_init(ocelot);
-	ocelot_set_cpu_port(ocelot, ocelot->num_phys_ports,
-			    OCELOT_TAG_PREFIX_NONE, OCELOT_TAG_PREFIX_NONE);
+	/* No NPI port */
+	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
+			     OCELOT_TAG_PREFIX_NONE);
 
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 068f96b1a83e..247b537fc7ef 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -447,9 +447,11 @@ struct ocelot {
 	/* Keep track of the vlan port masks */
 	u32				vlan_mask[VLAN_N_VID];
 
+	/* In tables like ANA:PORT and the ANA:PGID:PGID mask,
+	 * the CPU is located after the physical ports (at the
+	 * num_phys_ports index).
+	 */
 	u8				num_phys_ports;
-	u8				num_cpu_ports;
-	u8				cpu;
 
 	u32				*lags;
 
@@ -500,9 +502,9 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
 struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
-			 enum ocelot_tag_prefix injection,
-			 enum ocelot_tag_prefix extraction);
+void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
+			  enum ocelot_tag_prefix injection,
+			  enum ocelot_tag_prefix extraction);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8e3e7283d430..59de1315100f 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -153,7 +153,8 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 
 	memset(injection, 0, OCELOT_TAG_LEN);
 
-	src = dsa_upstream_port(ds, port);
+	/* Set the source port as the CPU port module and not the NPI port */
+	src = ocelot->num_phys_ports;
 	dest = BIT(port);
 	bypass = true;
 	qos_class = skb->priority;
-- 
2.17.1


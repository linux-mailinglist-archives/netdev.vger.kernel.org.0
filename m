Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC5F5F50
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKINDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55069 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfKINDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:45 -0500
Received: by mail-wm1-f67.google.com with SMTP id z26so8805137wmi.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8WwZSaF1dM5pu4ZNxAbxUOHkEXADzUxk8R/qZeipfCc=;
        b=P48LOqt43BsyFRTuzukho8u+MtdPpqS6fNU/ZrgQObsPt1ui4P0tF5iiqCVX3o4SFd
         ZidGtEiCN1VUxUMqRgw6rxUIf5tpitXyuQ5KyEi71DXgwGc+aUJ1mkrc/C5sMO02YC0p
         y2jSOnw5bdhEx4axUSC1rNH3siVRXQ7JjuBRo0SPjZi5UNGZdk3CbvXa/MCT/ByB5WU0
         DafiYI5RtoCq78GhmkYsluDQByuCMHViRIuG8y3A2XyWmigdscCv6ZMkcSPCOC9sLqXB
         oxD4zpzpWg6fvwAdgQX9eJbyghxEQ4Wadq5ItQlPuE0yCS3LKVrV4jHsKImA6CiaD3WS
         fl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8WwZSaF1dM5pu4ZNxAbxUOHkEXADzUxk8R/qZeipfCc=;
        b=fd8QCxXF0RDixV0jToScoevYxBDSuxQ+G7w8f281SmGLZ9OvZDaagE2gXZZKwG2kPE
         XcxDPXgKeBQv3RgnF+pD6W99vvYs+IgyScDmfRB919VIkvMTmbXdG6daPI/yFOwoIdaI
         6bK+ZkT+UdBhZJCDS7d5ecv64GhaoSFm8SBf4jMl5XhGG4xXfKqe2os8OQoJQ0BRcZ8p
         oTFZBm9jksIIQ2gJTfv0dHpKEIJpu/kwxMgFKHCPQZjLdCOS0pCJBmjdZDb+CNWynEHQ
         oM2694cjWHmQACBNi/0iMyK+tFz+HtPVu/DuGUrF3tU1CmAq0a8Nm5jTuExWODxoS9IK
         lkrQ==
X-Gm-Message-State: APjAAAXEUOlDzaJaewJ+Dsl++OiDM5esJno9hxJs+Ewi5z0Saxjt7oUB
        TNS/g9f3+pcCkrn84oPfZeU=
X-Google-Smtp-Source: APXvYqxWgblGyd6Z7BBw57MaQP2RWiY5JuvE9K8AfsBjcF8wyI4WFvXiFgvI+UPazet06RwYBCR0Lg==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr2001587wmc.148.1573304621842;
        Sat, 09 Nov 2019 05:03:41 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 14/15] net: mscc: ocelot: split assignment of the cpu port into a separate function
Date:   Sat,  9 Nov 2019 15:03:00 +0200
Message-Id: <20191109130301.13716-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that the places that configure routing destinations for the CPU port
have been marked as such, allow callers to specify their own CPU port
that is different than ocelot->num_phys_ports. A user will be the Felix
DSA driver, where the CPU port is one of the physical ports (NPI mode).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 65 ++++++++++++++++--------
 drivers/net/ethernet/mscc/ocelot.h       | 12 +++++
 drivers/net/ethernet/mscc/ocelot_board.c |  2 +
 3 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7f0bd89fc363..bba6d60dc5a8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -380,12 +380,6 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	ocelot->vlan_mask[0] = GENMASK(ocelot->num_phys_ports - 1, 0);
 	ocelot_vlant_set_mask(ocelot, 0, ocelot->vlan_mask[0]);
 
-	/* Configure the CPU port to be VLAN aware */
-	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
-				 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
-			 ANA_PORT_VLAN_CFG, ocelot->num_phys_ports);
-
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
 	 */
@@ -2224,11 +2218,52 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 }
 EXPORT_SYMBOL(ocelot_probe_port);
 
+void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
+			 enum ocelot_tag_prefix injection,
+			 enum ocelot_tag_prefix extraction)
+{
+	/* Configure and enable the CPU port. */
+	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
+	ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
+	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
+			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
+			 ANA_PORT_PORT_CFG, cpu);
+
+	/* If the CPU port is a physical port, set up the port in Node
+	 * Processor Interface (NPI) mode. This is the mode through which
+	 * frames can be injected from and extracted to an external CPU.
+	 * Only one port can be an NPI at the same time.
+	 */
+	if (cpu < ocelot->num_phys_ports) {
+		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
+			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
+			     QSYS_EXT_CPU_CFG);
+	}
+
+	/* CPU port Injection/Extraction configuration */
+	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
+			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
+			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
+			 QSYS_SWITCH_PORT_MODE, cpu);
+	ocelot_write_rix(ocelot, SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
+			 SYS_PORT_MODE_INCL_INJ_HDR(injection),
+			 SYS_PORT_MODE, cpu);
+
+	/* Configure the CPU port to be VLAN aware */
+	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
+				 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
+			 ANA_PORT_VLAN_CFG, cpu);
+
+	ocelot->cpu = cpu;
+}
+EXPORT_SYMBOL(ocelot_set_cpu_port);
+
 int ocelot_init(struct ocelot *ocelot)
 {
-	u32 port;
-	int i, ret, cpu = ocelot->num_phys_ports;
 	char queue_name[32];
+	int i, ret;
+	u32 port;
 
 	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				    sizeof(u32), GFP_KERNEL);
@@ -2308,13 +2343,6 @@ int ocelot_init(struct ocelot *ocelot)
 		ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_SRC + port);
 	}
 
-	/* Configure and enable the CPU port. */
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
-	ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
-	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
-			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
-			 ANA_PORT_PORT_CFG, cpu);
-
 	/* Allow broadcast MAC frames. */
 	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++) {
 		u32 val = ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports - 1, 0));
@@ -2327,13 +2355,6 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
 
-	/* CPU port Injection/Extraction configuration */
-	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
-			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, cpu);
-	ocelot_write_rix(ocelot, SYS_PORT_MODE_INCL_XTR_HDR(1) |
-			 SYS_PORT_MODE_INCL_INJ_HDR(1), SYS_PORT_MODE, cpu);
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.
 	 */
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 7f3526151fa9..4d8e769ccad9 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -427,6 +427,13 @@ struct ocelot_multicast {
 	u16 ports;
 };
 
+enum ocelot_tag_prefix {
+	OCELOT_TAG_PREFIX_DISABLED	= 0,
+	OCELOT_TAG_PREFIX_NONE,
+	OCELOT_TAG_PREFIX_SHORT,
+	OCELOT_TAG_PREFIX_LONG,
+};
+
 struct ocelot_port;
 
 struct ocelot_stat_layout {
@@ -455,6 +462,7 @@ struct ocelot {
 
 	u8 num_phys_ports;
 	u8 num_cpu_ports;
+	u8 cpu;
 	struct ocelot_port **ports;
 
 	u32 *lags;
@@ -552,6 +560,10 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy);
 
+void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
+			 enum ocelot_tag_prefix injection,
+			 enum ocelot_tag_prefix extraction);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 9985fb334aac..811599f32910 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -365,6 +365,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 
 	ocelot_init(ocelot);
+	ocelot_set_cpu_port(ocelot, ocelot->num_phys_ports,
+			    OCELOT_TAG_PREFIX_NONE, OCELOT_TAG_PREFIX_NONE);
 
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
-- 
2.17.1


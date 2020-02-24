Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE4316B2A6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgBXVfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:35:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40371 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbgBXVfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:35:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so12176261wru.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v6+nrjXuMjeOuAEeWLzWYB9sEJU1UoSBM8ukDZnbeak=;
        b=OvFtc2u56AIEKIe4q+8Q2AbhhRsmGW+NhjJLDcHxIV9Nu6LfelwF1/QQyYrdnberVa
         bXkxe6uh1EcmUze4bpO9OOueTnKMwx99lYhimPYkdn8SeOiDtFq26zbgWCtC1aMzdCQL
         uscTMR9XChA6bh6gA+8k7Je4L4vydVqgYmRpr4ifFiIuIl0HvlX8xbtMFEG/0CzZq2pH
         sG9BAGyqxFkn+Uxw3/Mf20VdW6i5XVZe4+cXK+U0iHv7efVY2IxU/j0q2UD8yKY/Saef
         SgGFCQ0jwY4YAnMp6CqQ9LH2cTmQ79W6Lzk7QujJ6zHDOr7O7/2u/cTTnaN6YXMF3tnB
         w72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v6+nrjXuMjeOuAEeWLzWYB9sEJU1UoSBM8ukDZnbeak=;
        b=ZESmyyrf/BcgCopO8nXzM8wMYg//gywyov6IlBqXQEp6ocIxcl8MsDn1d8c2TwWAoc
         +rmSd9ZikqMbjm0oZUDDb4wgd//9R6xQRrPYHqrU++5AUbn5tKopD+5iMvBKlwxmTmhc
         ekIxCTD+MWoigO0R8dBesFlIkoEL54T4IACiOfyHerSdq5dsPHxTmH9/7tmgdXkRQCPz
         1IlzoAG2WFPefpzgnTuA/VDVXgeMkziAUuS4Y+WLp06ILpa623gfArsYWMLHXEllF7Le
         IBopIbIbx9ITgNwUtS6wvcmxxBUFGD/1NFLrGpI8LJ+wW/e4lDrh1jCDQRB1BDlz5+m/
         yoBQ==
X-Gm-Message-State: APjAAAUnFIwLfMHcyHXLQGXncw4TSBj8WBQyqaFs7G0ZijHRDQUexY85
        yB7stoqZElgRVVdw9GWwoZ4=
X-Google-Smtp-Source: APXvYqyn2krxLAmdmAIDZKIvIvpo5KHWKjrZwkt+mWooX1BqMEUIxMrrp+JYsXWssFfw5jVh2lL6AQ==
X-Received: by 2002:a5d:4ac8:: with SMTP id y8mr68051635wrs.272.1582580107157;
        Mon, 24 Feb 2020 13:35:07 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n3sm1001069wmc.27.2020.02.24.13.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:35:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/2] net: mscc: ocelot: eliminate confusion between CPU and NPI port
Date:   Mon, 24 Feb 2020 23:34:57 +0200
Message-Id: <20200224213458.32451-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224213458.32451-1-olteanv@gmail.com>
References: <20200224213458.32451-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In Ocelot, the CPU port module is a set of queues which, depending upon
hardware integration, may be connected to a DMA engine or similar
(register access), or to an Ethernet port (the so-called NPI mode).

The CPU port module has a [fixed] number, just like the physical switch
ports.  In VSC7514 (a 10-port switch), there are 2 CPU port modules -
ports 10 and 11, aka the eleventh and twelfth port. Similarly, in
VSC9959 (a 6-port switch), the CPU port module is port 6, the seventh
port.

The VSC7514 instantiation (ocelot_board.c) uses register access for
frame injection/extraction, while the VSC9959 instantiation
(felix_vsc9959.c) uses an NPI port. The NPI functionality is actually
equivalent to the "CPU port" concept from DSA, hence the tendency of
using the ocelot->cpu variable to hold:
 - The CPU port module, for the switchdev ocelot_board.c
 - The NPI port, for the DSA felix_vsc9959.c

But Ocelot and Felix have been operating in different hardware modes,
with 2 very different things being configured by the same "ocelot->cpu"
umbrella. The difference has to do with how a frame reaches the CPU with
the Ocelot switch.

The CPU port module has a "god mode" view of the switch. Even though it
is assigned a number in hardware just like the physical ports, the CPU
port doesn't need to be in the forwarding matrix of the other source
ports (PGID_SRC + p, where p is a physical port) in order to be able to
receive frames from them.

The actual process by which the CPU sees frames in Ocelot is by
"copying" them to the CPU. This is a term used in the hardware docs
which means that the frames are "mirrored" to the CPU port. The
distinction here is that the frames are not supposed to reach the CPU
through the regular L2 forwarding process. Instead, there is a
meticulous hardware process in place, by which the destination PGIDs
(aka PGIDs in the range 0-63) which have BIT(ocelot->num_phys_ports) set
will cause the frames to be copied [unconditionally] to the CPU.
In the way the Ocelot driver sets the destination PGIDs up, these
destination PGIDs are _only_ PGID_CPU and PGID_MC. So a frame is not
supposed to reach the CPU via any other mechanism.

On the other hand, the NPI port, as currently configured for Felix, the
DSA consumer of Ocelot, is set up to receive frames via L2 forwarding.
So in that case, the forwarding matrix does indeed need to contain the
NPI port as a valid destination port for all other ports, via the
PGID_SRC + p source port masks.

But the NPI port doesn't benefit from the "god mode" view that the CPU
port module has upon the other switch ports, or at least not in the L2
forwarding way of frames reaching it. It is literally only the CPU port
(the first non-physical port) who has the power of getting frames
copied.

In Ocelot, CPU copying works because PGID_CPU contains ocelot->cpu which
is 11 (the CPU port module).
In Felix, CPU copying doesn't work, because PGID_CPU contains
ocelot->cpu which is the NPI port (a number in the range 0-5, definitely
not 6 which would be the CPU port module).

But in the way that the NPI port is supposed to be used, it should
actually be configured such that the CPU port module just sends all
traffic to it (it is connected to the queues). So we can get all
benefits of the CPU port module in NPI mode as well.

Doing this configuration change for Felix is mostly a mindset thing: we
need to make the distinction between the CPU port module and the NPI
port. This is a bit unfortunate for readers accustomed with the DSA
terminology. The DSA CPU port is the NPI port, while the CPU port module
is fixed at 6 and has no equivalent.

We need to stop calling the NPI port ocelot->cpu, and we need to stop
trying to make frames reach the NPI port directly via forwarding. The
result is a code simplification.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           |  7 +--
 drivers/net/ethernet/mscc/ocelot.c       | 62 ++++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
 include/soc/mscc/ocelot.h                |  7 ++-
 net/dsa/tag_ocelot.c                     |  3 +-
 5 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 35124ef7e75b..17f84c636c8f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -510,10 +510,11 @@ static int felix_setup(struct dsa_switch *ds)
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
index 1135a18019c7..7c3dae87d505 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -363,8 +363,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
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
index 068f96b1a83e..abe912715b54 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -449,7 +449,6 @@ struct ocelot {
 
 	u8				num_phys_ports;
 	u8				num_cpu_ports;
-	u8				cpu;
 
 	u32				*lags;
 
@@ -500,9 +499,9 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937802FDFC5
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393254AbhAUCwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbhAUCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:39:22 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94BDC061794
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:39 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so724276ede.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AEZmpbMS9sm6+SLmOVP2Mfz5Eyy0NnxxA2WVVixTSU=;
        b=A7MbFgt0uHewTLND1lRMNyq/l1YJKCFQ6A6ft30sZxLuk68Z+FY8Ooac1o5BPx+NRQ
         nx6cbJBY/sWobb6gZcyrT5mGIPLj5DKKgXsKo8I3feDGSF2RM8fbZyrmERpy80Ppqqc1
         flVZIZTMBVRgzVIrWDt35axHiCfJwrJMsfDgfjkWm1RPEL8Y1VNe2VPJc6atC7QbbK0x
         yYoKyh1G5mfK/MVSC2O6SgQ/HCGOKIhJyZ1sf3GOBLSbLKDOHBzm5TQ8+SOPCs45eoC/
         xok8czd4NU016ALFB8xN42LJKcZ2Ownm6Hv70lbbfaEKh3jVv1qR1rrfF3XOAku3zbRO
         hOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AEZmpbMS9sm6+SLmOVP2Mfz5Eyy0NnxxA2WVVixTSU=;
        b=VcpUGoQCpG1l8uMlw3NUJw38q34iHqbW23igbw+liPd33gqAqqpH5wpxHLZ+WtYZ/p
         qUj+EMUgv8BUFHFezssB/YAr+ChRFsph1RfkD3vh/Ed49ULnONP1LevjYAuLTptkupR1
         8GrUsEDLQOknQdRt8cPZb7DJknnIDcfMz9CTCU0fUnMbJthxa5WJT1kh2J9S+C49KaB2
         +48kS6c6jYDtwnZoGMSf507tVyh3Oi8vvm2EqOm9k+tFJtEDMawVTT6o7eHO70rSM4I3
         WRmOpgdwrP7XGug1wFDJs0hDQsEA95Sxz+0W0aSu07U8YeQnCGiot1ou1dbN2G1A4JdF
         Wl9g==
X-Gm-Message-State: AOAM531vgZYZky8pRjk9sREKpXXxhyjnnUkYLxzryrduEYD5mL4oN1uk
        jcRzDlFh+YqXlV0C+Cxnz0M=
X-Google-Smtp-Source: ABdhPJzvOCnrEk/REJ2BuoiX3+vu+xRr5y5DkMAUglGLALhFH32i8d3Op9tEwavEdZ+GpghcMAxsyQ==
X-Received: by 2002:a05:6402:1f4:: with SMTP id i20mr9110946edy.180.1611196598610;
        Wed, 20 Jan 2021 18:36:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 08/10] net: dsa: felix: convert to the new .{set,del}_tag_protocol DSA API
Date:   Thu, 21 Jan 2021 04:36:14 +0200
Message-Id: <20210121023616.1696021-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In expectation of the new tag_ocelot_8021q tagger implementation, we
need to be able to do runtime switchover between one tagger and another.
So we must implement the .set_tag_protocol() and .del_tag_protocol() for
the current NPI-based tagger.

We move the felix_npi_port_init function in expectation of the future
driver configuration necessary for tag_ocelot_8021q: we would like to
not have the NPI-related bits interspersed with the tag_8021q bits.

Note that the NPI port is no longer configured when the .setup() method
concludes - aka when ocelot_init() and ocelot_init_port() are called.
So we need to set the replicator groups - the PGIDs - again, when the
NPI port is configured - in .set_tag_protocol(). So we export and call
ocelot_apply_bridge_fwd_mask().

The conversion from this:

	ocelot_write_rix(ocelot,
			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
			 ANA_PGID_PGID, PGID_UC);

to this:

	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);

is perhaps non-trivial, but is nonetheless non-functional. The PGID_UC
(replicator for unknown unicast) is already configured out of hardware
reset to flood to all ports except ocelot->num_phys_ports (the CPU port
module). All we change is that we use a read-modify-write to only add
the CPU port module to the unknown unicast replicator, as opposed to
doing a full write to the register.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Path is split from previous monolithic patch "net: dsa: felix: add new
VLAN-based tagger".

 drivers/net/dsa/ocelot/felix.c           | 150 +++++++++++++++++------
 drivers/net/dsa/ocelot/felix.h           |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |   1 +
 drivers/net/ethernet/mscc/ocelot.c       |   3 +-
 include/soc/mscc/ocelot.h                |   1 +
 6 files changed, 120 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 054e57dd4383..f45dfb800bcb 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2019 NXP Semiconductors
+/* Copyright 2019-2021 NXP Semiconductors
  *
  * This is an umbrella module for all network switches that are
  * register-compatible with Ocelot and that perform I/O to their host CPU
@@ -24,11 +24,118 @@
 #include <net/dsa.h>
 #include "felix.h"
 
+/* The CPU port module is connected to the Node Processor Interface (NPI). This
+ * is the mode through which frames can be injected from and extracted to an
+ * external CPU, over Ethernet. In NXP SoCs, the "external CPU" is the ARM CPU
+ * running Linux, and this forms a DSA setup together with the enetc or fman
+ * DSA master.
+ */
+static void felix_npi_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->npi = port;
+
+	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
+		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
+		     QSYS_EXT_CPU_CFG);
+
+	/* NPI port Injection/Extraction configuration */
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
+			    ocelot->npi_xtr_prefix);
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
+			    ocelot->npi_inj_prefix);
+
+	/* Disable transmission of pause frames */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+}
+
+static void felix_npi_port_deinit(struct ocelot *ocelot, int port)
+{
+	/* Restore hardware defaults */
+	int unused_port = ocelot->num_phys_ports + 2;
+
+	ocelot->npi = -1;
+
+	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPU_PORT(unused_port),
+		     QSYS_EXT_CPU_CFG);
+
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
+			    OCELOT_TAG_PREFIX_DISABLED);
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
+			    OCELOT_TAG_PREFIX_DISABLED);
+
+	/* Enable transmission of pause frames */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
+}
+
+static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+	unsigned long cpu_flood;
+
+	felix_npi_port_init(ocelot, cpu);
+
+	/* Include the CPU port module (and indirectly, the NPI port)
+	 * in the forwarding mask for unknown unicast - the hardware
+	 * default value for ANA_FLOODING_FLD_UNICAST excludes
+	 * BIT(ocelot->num_phys_ports), and so does ocelot_init,
+	 * since Ocelot relies on whitelisting MAC addresses towards
+	 * PGID_CPU.
+	 * We do this because DSA does not yet perform RX filtering,
+	 * and the NPI port does not perform source address learning,
+	 * so traffic sent to Linux is effectively unknown from the
+	 * switch's perspective.
+	 */
+	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
+	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);
+
+	ocelot_apply_bridge_fwd_mask(ocelot);
+
+	return 0;
+}
+
+static void felix_teardown_tag_npi(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	felix_npi_port_deinit(ocelot, cpu);
+}
+
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 						    int port,
 						    enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_OCELOT;
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix->tag_proto;
+}
+
+static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
+				  enum dsa_tag_protocol proto)
+{
+	int err;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_OCELOT:
+		err = felix_setup_tag_npi(ds, cpu);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
+				   enum dsa_tag_protocol proto)
+{
+	switch (proto) {
+	case DSA_TAG_PROTO_OCELOT:
+		felix_teardown_tag_npi(ds, cpu);
+		break;
+	default:
+		break;
+	}
 }
 
 static int felix_set_ageing_time(struct dsa_switch *ds,
@@ -527,28 +634,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
-/* The CPU port module is connected to the Node Processor Interface (NPI). This
- * is the mode through which frames can be injected from and extracted to an
- * external CPU, over Ethernet.
- */
-static void felix_npi_port_init(struct ocelot *ocelot, int port)
-{
-	ocelot->npi = port;
-
-	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
-		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
-		     QSYS_EXT_CPU_CFG);
-
-	/* NPI port Injection/Extraction configuration */
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->npi_xtr_prefix);
-	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->npi_inj_prefix);
-
-	/* Disable transmission of pause frames */
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
-}
-
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -578,10 +663,10 @@ static int felix_setup(struct dsa_switch *ds)
 	}
 
 	for (port = 0; port < ds->num_ports; port++) {
-		ocelot_init_port(ocelot, port);
+		if (dsa_is_unused_port(ds, port))
+			continue;
 
-		if (dsa_is_cpu_port(ds, port))
-			felix_npi_port_init(ocelot, port);
+		ocelot_init_port(ocelot, port);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
@@ -593,15 +678,6 @@ static int felix_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
-	/* Include the CPU port module in the forwarding mask for unknown
-	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
-	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
-	 * Ocelot relies on whitelisting MAC addresses towards PGID_CPU.
-	 */
-	ocelot_write_rix(ocelot,
-			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
-			 ANA_PGID_PGID, PGID_UC);
-
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
 
@@ -860,6 +936,8 @@ static int felix_sb_occ_tc_port_bind_get(struct dsa_switch *ds, int port,
 
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
+	.set_tag_protocol		= felix_set_tag_protocol,
+	.del_tag_protocol		= felix_del_tag_protocol,
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 994835cb9307..264b3bbdc4d1 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -48,6 +48,7 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
+	enum dsa_tag_protocol		tag_proto;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f9711e69b8d5..e944868cc120 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1467,6 +1467,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	ds->ops = &felix_switch_ops;
 	ds->priv = ocelot;
 	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
 
 	err = dsa_register_switch(ds);
 	if (err) {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 5e9bfdea50be..512f677a6c1c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1246,6 +1246,7 @@ static int seville_probe(struct platform_device *pdev)
 	ds->ops = &felix_switch_ops;
 	ds->priv = ocelot;
 	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
 
 	err = dsa_register_switch(ds);
 	if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index acf7ef00e56b..a14ff1e5f940 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,7 +876,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 {
 	int port;
 
@@ -908,6 +908,7 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 		}
 	}
 }
+EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 93c22627dedd..fba24a0327d4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -760,6 +760,7 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
-- 
2.25.1


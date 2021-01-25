Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0FB302EAF
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbhAYWJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733169AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9722C06178B
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:37 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z22so2719920edb.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJmc0jCWZrW9fQ7F7zCRgOrJ/yeq1MSAQVnDxtE7aVA=;
        b=nI92JOBNIfB+O9DaJZxt1NwNgG44/9JN0NxWKFWqIvS4dD8eysvK38mm+k6Cvs19ld
         F/6SNOl6Gud8XeFW9uKXKFp8/jugWa7evfXMhDAikzzEHrQUjeMyRDXPCvWS9ueAgS1q
         HAmicPlQJRCbYtoCmjJIGYNQ6XjzRYyAKRqsJz2NrmFBUltP6PQURd9sxm1Hv8mLZWQQ
         Cyi0aDKfTTz2Ah1VRr8DTsZKuMuDjilpkf7qKupqGxpKwL8LlVkpb420I581h8qHYXrj
         t65xF4Q9TiG0y+EeKp+uidptz8eYuJhDlI0ZGuGpcXyuAfrJJRTAaoaI5d7uFkqoYbLa
         sIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJmc0jCWZrW9fQ7F7zCRgOrJ/yeq1MSAQVnDxtE7aVA=;
        b=KmcGl+dpRsGUhxtGEC4QHZYRZ0CNwaOjYD1FqAoab5i4bvYvvGmulMFEh90WfuSNLR
         J4oxxVDhmLPJEYYvugRnc5WY1DLJXDW+fA7RYeovbFn9VWF2E44eJNa0ZvQJ45t+U2li
         oXGC0fFd1bIO4cE7q3U3ov6+2VapLmeC72WJO1WmcLh3pOAP5zG7G6xiqv6AI9G+kQb0
         xYb7D0G+1WHN3v8Av70Lvhtza8lq/76K21CoU42WxjJS3a/HsYNuQjAQFc/EQhRBsbH+
         ZXe32AKCMTYM5Pj1GqYpi/OOjUXu3xlzY5twLzLxQPmswJ5NdsIqL1+nT7NSpDvWgwNI
         yo6w==
X-Gm-Message-State: AOAM531A/3MX0pvW7lcV9nMj8E8zDIl8JAI7zIrEWnSE26J2cTGkAGsS
        YyzwQPgWE1MujUEUB1DUN94=
X-Google-Smtp-Source: ABdhPJxto36UApgwR15eJIUa8bRctJ4q6zXjSk/+WxTULKbgkpKkrnkNH+PvIMcVl2OTtl2M+qY/ig==
X-Received: by 2002:aa7:d8c6:: with SMTP id k6mr2211161eds.265.1611612276399;
        Mon, 25 Jan 2021 14:04:36 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 09/11] net: dsa: felix: convert to the new .{set,del}_tag_protocol DSA API
Date:   Tue, 26 Jan 2021 00:03:31 +0200
Message-Id: <20210125220333.1004365-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
None.

Changes in v6:
None.

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
index 714165c2f85a..ebc797a08506 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,7 +889,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 {
 	int port;
 
@@ -921,6 +921,7 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A34E3082D6
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhA2BDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhA2BB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:59 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BDEC06178C
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id n6so8724775edt.10
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qv4ZppELWmkfx5vHzxidK+zk/vYbYCntYvAPDd4RqQ=;
        b=BiRWEblgaTsib0/oYgzRnHk4juCyxVJiHur4rmLGogq5Hbn7MONdCzHF1Xkjdou+r6
         YdQx5ALx++EvoBdq4ogdXRD9eiIlf4puWx2wopUXYLxPD63DsODONmg764HLEl220N/K
         V1+0kk1Al3CqUJ02a/45hmMFfmAlq5O4TTLr+TBbm8rS20BMSRyQ2WkZ8OQnRBwL0sE8
         f5jVuwmZSIiAsAjm9EIarJ6rs8jv7cgYCd5bnL9cwO+B9li2lgrQRVUQEbOnhRVDQKo5
         c1DwIzAYuUn1LVo6s3ae5uFiqvqQ8zVlOSWzbHNuQyMm6hAwTEw27LwTSCNFR9CHdzrH
         2PlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qv4ZppELWmkfx5vHzxidK+zk/vYbYCntYvAPDd4RqQ=;
        b=W7aAhWLkV44wDJRxWnF43MFH3Gy9cAkTeRDc8IgjFmOdUfOak2FEMfiBuyWwSTVpuX
         GTdIMALbY9VXd2ADO1hw1yLBSnSxWEhA1LKWNgG8530FUwqDc+aPYE6UOowWFfLIsk0+
         gWQGowZS3pXQIccf1qeRnUmfJtYqTODiuav+rZTi4yCOr8lxCXoQAW+dHT/qKhcG6wE+
         kIzX63/iDg4BEb0FvGuF4Nu+2y5ihR3j/BbJBfRyYYkAsHiOC6SlQYipm9Pq19yB673/
         OzzhcwCq4jfz7YvUc16c6sdE7FwgOZLEKJmW+ANjctUOjhH4aPBff7boHETqYitvmucO
         8sZA==
X-Gm-Message-State: AOAM533633VWtXfxkGj4ZWlxB4dKlJzwah+PoO5KaiEa1wfC+8R8tC3B
        EU4vJ1R2OgDc0tE+qkbJsgg=
X-Google-Smtp-Source: ABdhPJxapOqwX6b3cYPU7Lg+oQOvsLlatXdRkrVjVbaQ+pF0p2yPLUgevhMpME3Ozdjc5pY1fgg9EQ==
X-Received: by 2002:a05:6402:3116:: with SMTP id dc22mr2450704edb.325.1611882040988;
        Thu, 28 Jan 2021 17:00:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:40 -0800 (PST)
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
Subject: [PATCH v8 net-next 09/11] net: dsa: felix: convert to the new .change_tag_protocol DSA API
Date:   Fri, 29 Jan 2021 03:00:07 +0200
Message-Id: <20210129010009.3959398-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In expectation of the new tag_ocelot_8021q tagger implementation, we
need to be able to do runtime switchover between one tagger and another.
So we must structure the existing code for the current NPI-based tagger
in a certain way.

We move the felix_npi_port_init function in expectation of the future
driver configuration necessary for tag_ocelot_8021q: we would like to
not have the NPI-related bits interspersed with the tag_8021q bits.

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
Changes in v8:
- Used -EPROTONOSUPPORT instead of -EOPNOTSUPP as return code.
- Adapted to .change_tag_protocol. Kept felix_set_tag_protocol and
  felix_del_tag_protocol, but now calling them privately from
  felix_setup and felix_teardown.
- Removed ocelot_apply_bridge_fwd_mask from this patch and moved it to
  11/11.
- Dropped review tags due to amount of changes.

Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
Path is split from previous monolithic patch "net: dsa: felix: add new
VLAN-based tagger".

 drivers/net/dsa/ocelot/felix.c           | 186 ++++++++++++++++++-----
 drivers/net/dsa/ocelot/felix.h           |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |   1 +
 4 files changed, 154 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 054e57dd4383..af3cee8762ce 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2019 NXP Semiconductors
+/* Copyright 2019-2021 NXP Semiconductors
  *
  * This is an umbrella module for all network switches that are
  * register-compatible with Ocelot and that perform I/O to their host CPU
@@ -24,11 +24,140 @@
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
+		err = -EPROTONOSUPPORT;
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
+}
+
+static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
+				     enum dsa_tag_protocol proto)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	enum dsa_tag_protocol old_proto = felix->tag_proto;
+	int err;
+
+	if (proto != DSA_TAG_PROTO_OCELOT)
+		return -EPROTONOSUPPORT;
+
+	felix_del_tag_protocol(ds, cpu, old_proto);
+
+	err = felix_set_tag_protocol(ds, cpu, proto);
+	if (err) {
+		felix_set_tag_protocol(ds, cpu, old_proto);
+		return err;
+	}
+
+	felix->tag_proto = proto;
+
+	return 0;
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
 }
 
 static int felix_set_ageing_time(struct dsa_switch *ds,
@@ -527,28 +656,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
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
@@ -578,10 +685,10 @@ static int felix_setup(struct dsa_switch *ds)
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
@@ -593,14 +700,15 @@ static int felix_setup(struct dsa_switch *ds)
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
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_cpu_port(ds, port))
+			continue;
+
+		/* The initial tag protocol is NPI which always returns 0, so
+		 * there's no real point in checking for errors.
+		 */
+		felix_set_tag_protocol(ds, port, felix->tag_proto);
+	}
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
@@ -614,6 +722,13 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_cpu_port(ds, port))
+			continue;
+
+		felix_del_tag_protocol(ds, port, felix->tag_proto);
+	}
+
 	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -860,6 +975,7 @@ static int felix_sb_occ_tc_port_bind_get(struct dsa_switch *ds, int port,
 
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
+	.change_tag_protocol		= felix_change_tag_protocol,
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
-- 
2.25.1


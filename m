Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96222FC4B5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbhASXWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbhASXJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:03 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8B5C061786
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 6so30914205ejz.5
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eoaAf3VB2ZkBJEscAlighF3epDpYPmPmxeLjzaEE4XI=;
        b=c9+pKH44rKKTeEkS6CrH+pXLOMOJ5V3vFNg6YWESbluNB5gUqLZnyx+kzabu+8KvvL
         2ACMLnumxPgccsgnjro3BdkXlKeiNaxjAQUXAUD+maMj8D6A5BtWX6sDq+0GZH8A6KLq
         i3ucla29Z1bKCkXkmQiDomM9cUx7O7+FmIy1A2digRInhMfcFRd76P3wk0+kF8kgk8Lg
         NH4gY9oEzDZfpE40A0XmBN2Tn9rcHKj/fJwE9J8cvXQYsxyjagI/bxl4Jbv3dxidaYvy
         M04Vk4xhMCH0gqydhyv9rMy6D5n59vlUAgAmehuqba92A8C8R7RAEhFLbJoJo22Cza8W
         vanQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eoaAf3VB2ZkBJEscAlighF3epDpYPmPmxeLjzaEE4XI=;
        b=PfWqqwX/Qy11dDXpQnOvALCwYo0wABYn6BIURx8AxBRiPMttPwRO3Kp5y3lvVB4wYM
         GRWAgbQsMtu0IviZtKsLDUMCOZn1P5TPMc+L+JmIs36RBRKXezX5A+xJJRzBDizZID+N
         0qibXTClTHdkmaGWbuqLtJ9PveYX7Sc+CUzCuKY9SjKplc1mzwMKbuyb/5RZBzsTBNd5
         8OdD2qfIZnjp5vxJNtnUd/kic9yRUacoHiXADPrPDwfSqn2BivzPr925CCmcMarN228k
         sI3rBacpv2WzP2XA/QvHWBcGAgFhEJGO/FasJxZ6WT9bhwxejfgkcytAiDZ5vo3S1GBZ
         KHqg==
X-Gm-Message-State: AOAM531LTXaAAh3sckCVCsLwAVL1dPQ7EKwMbFQ3tm6k/XF7//mNLtBN
        BvhnGZES9zF78b9jODoanWw=
X-Google-Smtp-Source: ABdhPJxo/yXQ1yMjXabi3MBt5qEP+27FXQeIH2hm10gXUosfCM641cHbziEQVDdcjlV/qCwzjxsCbw==
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr4467150ejr.39.1611097690097;
        Tue, 19 Jan 2021 15:08:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:09 -0800 (PST)
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
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 07/16] net: dsa: felix: add new VLAN-based tagger
Date:   Wed, 20 Jan 2021 01:07:40 +0200
Message-Id: <20210119230749.1178874-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are use cases for which the existing tagger, based on the NPI
(Node Processor Interface) functionality, is insufficient.

Namely:
- Frames injected through the NPI port bypass the frame analyzer, so no
  source address learning is performed, no TSN stream classification,
  etc.
- Flow control is not functional over an NPI port (PAUSE frames are
  encapsulated in the same Extraction Frame Header as all other frames)
- There can be at most one NPI port configured for an Ocelot switch. But
  in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
  port is currently either disabled, or operated as a plain user port
  (albeit an internally-facing one). Having the ability to configure the
  two CPU ports symmetrically could pave the way for e.g. creating a LAG
  between them, to increase bandwidth seamlessly for the system.

So, there is a desire to have an alternative to the NPI mode.

This patch brings an implementation of the software-defined tag_8021q.c
tagger format, which also preserves full functionality under a
vlan_filtering bridge (unlike sja1105, the only other user of
tag_8021q).

It does this by using the TCAM engines for:
- pushing the RX VLAN as a second, outer tag, on egress towards the CPU
  port
- redirecting towards the correct front port based on TX VLAN and
  popping that on egress

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
- Support simultaneous compilation of tag_ocelot.c and
  tag_ocelot_8021q.c.
- Support runtime switchover between these two taggers.
- We are now actually performing cleanup instead of just probe-time
  setup, which is required for supporting tagger switchover.

Changes in v3:
- Use a per-port bool is_dsa_8021q_cpu instead of a single dsa_8021q_cpu
  variable, to be compatible with future work where there may be
  potentially multiple tag_8021q CPU ports in a LAG.
- Initialize ocelot->npi = -1 in felix_8021q_cpu_port_init to ensure we
  don't mistakenly trigger NPI-specific code in ocelot.

Changes in v2:
Clean up the hardcoding of random VCAP filter IDs and the inclusion of a
private ocelot header.

 MAINTAINERS                              |   1 +
 drivers/net/dsa/ocelot/Kconfig           |   2 +
 drivers/net/dsa/ocelot/felix.c           | 473 +++++++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h           |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |   1 +
 drivers/net/ethernet/mscc/ocelot.c       |  36 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c  |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.h  |   3 -
 include/net/dsa.h                        |   2 +
 include/soc/mscc/ocelot.h                |   2 +
 include/soc/mscc/ocelot_vcap.h           |   3 +
 net/dsa/Kconfig                          |  21 +-
 net/dsa/Makefile                         |   1 +
 net/dsa/tag_ocelot_8021q.c               |  68 ++++
 15 files changed, 566 insertions(+), 51 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 096b584e7fed..ae793658e6a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12842,6 +12842,7 @@ F:	drivers/net/dsa/ocelot/*
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 F:	net/dsa/tag_ocelot.c
+F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index c110e82a7973..932b6b6fe817 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -6,6 +6,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
@@ -19,6 +20,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
 	help
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 054e57dd4383..df43f4a40f83 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright 2019 NXP Semiconductors
+/* Copyright 2019-2021 NXP Semiconductors
  *
  * This is an umbrella module for all network switches that are
  * register-compatible with Ocelot and that perform I/O to their host CPU
@@ -13,6 +13,7 @@
 #include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/dsa/8021q.h>
 #include <linux/platform_device.h>
 #include <linux/packing.h>
 #include <linux/module.h>
@@ -24,11 +25,440 @@
 #include <net/dsa.h>
 #include "felix.h"
 
+static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int key_length, upstream;
+
+	/* We don't need to install the rxvlan into the other ports' filtering
+	 * tables, because we're just pushing the rxvlan when sending towards
+	 * the CPU
+	 */
+	if (!pvid)
+		return 0;
+
+	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
+	upstream = dsa_upstream_port(ds, port);
+
+	outer_tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter),
+				     GFP_KERNEL);
+	if (!outer_tagging_rule)
+		return -ENOMEM;
+
+	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	outer_tagging_rule->prio = 1;
+	outer_tagging_rule->id.cookie = port;
+	outer_tagging_rule->id.tc_offload = false;
+	outer_tagging_rule->block_id = VCAP_ES0;
+	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	outer_tagging_rule->lookup = 0;
+	outer_tagging_rule->ingress_port.value = port;
+	outer_tagging_rule->ingress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->egress_port.value = upstream;
+	outer_tagging_rule->egress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->action.push_outer_tag = OCELOT_ES0_TAG;
+	outer_tagging_rule->action.tag_a_tpid_sel = OCELOT_TAG_TPID_SEL_8021AD;
+	outer_tagging_rule->action.tag_a_vid_sel = 1;
+	outer_tagging_rule->action.vid_a_val = vid;
+
+	return ocelot_vcap_filter_add(ocelot, outer_tagging_rule, NULL);
+}
+
+static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int upstream, err;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (ocelot->ports[port]->is_dsa_8021q_cpu)
+		return 0;
+
+	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!untagging_rule)
+		return -ENOMEM;
+
+	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!redirect_rule) {
+		kfree(untagging_rule);
+		return -ENOMEM;
+	}
+
+	upstream = dsa_upstream_port(ds, port);
+
+	untagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	untagging_rule->ingress_port_mask = BIT(upstream);
+	untagging_rule->vlan.vid.value = vid;
+	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
+	untagging_rule->prio = 1;
+	untagging_rule->id.cookie = port;
+	untagging_rule->id.tc_offload = false;
+	untagging_rule->block_id = VCAP_IS1;
+	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	untagging_rule->lookup = 0;
+	untagging_rule->action.vlan_pop_cnt_ena = true;
+	untagging_rule->action.vlan_pop_cnt = 1;
+	untagging_rule->action.pag_override_mask = 0xff;
+	untagging_rule->action.pag_val = port;
+
+	err = ocelot_vcap_filter_add(ocelot, untagging_rule, NULL);
+	if (err) {
+		kfree(untagging_rule);
+		kfree(redirect_rule);
+		return err;
+	}
+
+	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	redirect_rule->ingress_port_mask = BIT(upstream);
+	redirect_rule->pag = port;
+	redirect_rule->prio = 1;
+	redirect_rule->id.cookie = port;
+	redirect_rule->id.tc_offload = false;
+	redirect_rule->block_id = VCAP_IS2;
+	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	redirect_rule->lookup = 0;
+	redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+	redirect_rule->action.port_mask = BIT(port);
+
+	err = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
+	if (err) {
+		ocelot_vcap_filter_del(ocelot, untagging_rule);
+		kfree(redirect_rule);
+		return err;
+	}
+
+	return 0;
+}
+
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	return 0;
+}
+
+static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot_vcap_block *block_vcap_es0;
+	struct ocelot *ocelot = &felix->ocelot;
+
+	block_vcap_es0 = &ocelot->block[VCAP_ES0];
+
+	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
+								 port, false);
+	/* In rxvlan_add, we had the "if (!pvid) return 0" logic to avoid
+	 * installing outer tagging ES0 rules where they weren't needed.
+	 * But in rxvlan_del, the API doesn't give us the "flags" anymore,
+	 * so that forces us to be slightly sloppy here, and just assume that
+	 * if we didn't find an outer_tagging_rule it means that there was
+	 * none in the first place, i.e. rxvlan_del is called on a non-pvid
+	 * port. This is most probably true though.
+	 */
+	if (!outer_tagging_rule)
+		return 0;
+
+	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
+}
+
+static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
+	struct ocelot_vcap_block *block_vcap_is1;
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot *ocelot = &felix->ocelot;
+	int err;
+
+	if (ocelot->ports[port]->is_dsa_8021q_cpu)
+		return 0;
+
+	block_vcap_is1 = &ocelot->block[VCAP_IS1];
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	untagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
+							     port, false);
+	if (!untagging_rule)
+		return 0;
+
+	err = ocelot_vcap_filter_del(ocelot, untagging_rule);
+	if (err)
+		return err;
+
+	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
+							    port, false);
+	if (!redirect_rule)
+		return 0;
+
+	return ocelot_vcap_filter_del(ocelot, redirect_rule);
+}
+
+static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_del(ocelot_to_felix(ocelot),
+						  port, vid);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_del(ocelot_to_felix(ocelot),
+						  port, vid);
+
+	return 0;
+}
+
+static const struct dsa_8021q_ops felix_tag_8021q_ops = {
+	.vlan_add	= felix_tag_8021q_vlan_add,
+	.vlan_del	= felix_tag_8021q_vlan_del,
+};
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
+/* Alternatively to using the NPI functionality, that same hardware MAC
+ * connected internally to the enetc or fman DSA master can be configured to
+ * use the software-defined tag_8021q frame format. As far as the hardware is
+ * concerned, it thinks it is a "dumb switch" - the queues of the CPU port
+ * module are now disconnected from it, but can still be accessed through
+ * register-based MMIO.
+ */
+static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot->npi = -1;
+
+	/* Overwrite PGID_CPU with the non-tagging port */
+	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
+}
+
+static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+
+	/* Restore PGID_CPU */
+	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
+			 PGID_CPU);
+}
+
+static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long cpu_flood;
+	int port, err;
+
+	felix_8021q_cpu_port_init(ocelot, cpu);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		/* This overwrites ocelot_init():
+		 * Do not forward BPDU frames to the CPU port module,
+		 * for 2 reasons:
+		 * - When these packets are injected from the tag_8021q
+		 *   CPU port, we want them to go out, not loop back
+		 *   into the system.
+		 * - STP traffic ingressing on a user port should go to
+		 *   the tag_8021q CPU port, not to the hardware CPU
+		 *   port module.
+		 */
+		ocelot_write_gix(ocelot,
+				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
+				 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+	}
+
+	/* In tag_8021q mode, the CPU port module is unused. So we
+	 * want to disable flooding of any kind to the CPU port module,
+	 * since packets going there will end in a black hole.
+	 */
+	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
+
+	ocelot_apply_bridge_fwd_mask(ocelot);
+
+	felix->dsa_8021q_ctx = kzalloc(sizeof(*felix->dsa_8021q_ctx),
+				       GFP_KERNEL);
+	if (!felix->dsa_8021q_ctx)
+		return -ENOMEM;
+
+	felix->dsa_8021q_ctx->ops = &felix_tag_8021q_ops;
+	felix->dsa_8021q_ctx->proto = htons(ETH_P_8021AD);
+	felix->dsa_8021q_ctx->ds = ds;
+
+	rtnl_lock();
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	rtnl_unlock();
+
+	return err;
+}
+
+static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, port;
+
+	rtnl_lock();
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
+	rtnl_unlock();
+	if (err)
+		dev_err(ds->dev, "dsa_8021q_setup returned %d",
+			err);
+
+	kfree(felix->dsa_8021q_ctx);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		/* Restore the logic from ocelot_init:
+		 * do not forward BPDU frames to the front ports.
+		 */
+		ocelot_write_gix(ocelot,
+				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0xffff),
+				 ANA_PORT_CPU_FWD_BPDU_CFG,
+				 port);
+	}
+
+	felix_8021q_cpu_port_deinit(ocelot, cpu);
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
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		err = felix_setup_tag_8021q(ds, cpu);
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
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		felix_teardown_tag_8021q(ds, cpu);
+		break;
+	default:
+		break;
+	}
 }
 
 static int felix_set_ageing_time(struct dsa_switch *ds,
@@ -527,28 +957,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
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
@@ -578,10 +986,10 @@ static int felix_setup(struct dsa_switch *ds)
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
@@ -593,15 +1001,6 @@ static int felix_setup(struct dsa_switch *ds)
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
 
@@ -860,6 +1259,8 @@ static int felix_sb_occ_tc_port_bind_get(struct dsa_switch *ds, int port,
 
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
+	.set_tag_protocol		= felix_set_tag_protocol,
+	.del_tag_protocol		= felix_del_tag_protocol,
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 994835cb9307..9d4459f2fffb 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -48,6 +48,8 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
+	struct dsa_8021q_context	*dsa_8021q_ctx;
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
index acf7ef00e56b..0cbd1bbbf365 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,18 +876,39 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 {
+	unsigned long cpu_fwd_mask = 0;
 	int port;
 
+	/* If a DSA tag_8021q CPU exists, it needs to be unconditionally
+	 * (i.e. regardless of whether the port is bridged or standalone)
+	 * included in the regular forwarding path, as opposed to the
+	 * hardware-based CPU port module which can be a destination for
+	 * packets even if it isn't part of PGID_SRC.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		if (ocelot->ports[port]->is_dsa_8021q_cpu)
+			cpu_fwd_mask |= BIT(port);
+
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (ocelot->bridge_fwd_mask & BIT(port)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+		/* Standalone ports forward only to DSA tag_8021q CPU ports */
+		unsigned long mask = cpu_fwd_mask;
+
+		/* The DSA tag_8021q CPU ports need to be able to forward
+		 * packets to all other ports except for themselves
+		 */
+		if (ocelot->ports[port]->is_dsa_8021q_cpu) {
+			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
+			mask &= ~cpu_fwd_mask;
+		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
 			int lag;
 
+			mask |= ocelot->bridge_fwd_mask & ~BIT(port);
+
 			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 				unsigned long bond_mask = ocelot->lags[lag];
 
@@ -899,15 +920,12 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 					break;
 				}
 			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + port);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + port);
 		}
+
+		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
 }
+EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index b82fd4103a68..37a232911395 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1009,6 +1009,7 @@ ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
 
 	return NULL;
 }
+EXPORT_SYMBOL(ocelot_vcap_block_find_filter_by_id);
 
 /* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
  * on destination and source MAC addresses, but only on higher-level protocol
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 3b0c7916056e..523611ccc48f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -14,9 +14,6 @@
 
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
-struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
-				    bool tc_offload);
 
 void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index aa0ba41e42d6..b942e8574a4b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -47,6 +47,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
+#define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -69,6 +70,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
+	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 };
 
 struct packet_type;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 93c22627dedd..6a61c499a30d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -610,6 +610,7 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+	bool				is_dsa_8021q_cpu;
 };
 
 struct ocelot {
@@ -760,6 +761,7 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 76e01c927e17..25fd525aaf92 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -693,5 +693,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack);
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
+				    bool tc_offload);
 
 #endif /* _OCELOT_VCAP_H_ */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2d226a5c085f..a45572cfb71a 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -105,11 +105,26 @@ config NET_DSA_TAG_RTL4_A
 	  the Realtek RTL8366RB.
 
 config NET_DSA_TAG_OCELOT
-	tristate "Tag driver for Ocelot family of switches"
+	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	select PACKING
 	help
-	  Say Y or M if you want to enable support for tagging frames for the
-	  Ocelot switches (VSC7511, VSC7512, VSC7513, VSC7514, VSC9959).
+	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
+	  (VSC7511, VSC7512, VSC7513, VSC7514, VSC9953, VSC9959). In this mode,
+	  the frames over the Ethernet CPU port are prepended with a
+	  hardware-defined injection/extraction frame header.  Flow control
+	  (PAUSE frames) over the CPU port is not supported when operating in
+	  this mode.
+
+config NET_DSA_TAG_OCELOT_8021Q
+	tristate "Tag driver for Ocelot family of switches, using VLAN"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y or M if you want to enable support for tagging frames with a
+	  custom VLAN-based header. Frames that require timestamping, such as
+	  PTP, are not delivered over Ethernet but over register-based MMIO.
+	  Flow control over the CPU port is functional in this mode. When using
+	  this mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for
+	  use with tc-flower.
 
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 92cea2132241..44bc79952b8b 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
new file mode 100644
index 000000000000..09e10ade11f7
--- /dev/null
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2021 NXP Semiconductors
+ *
+ * An implementation of the software-defined tag_8021q.c tagger format, which
+ * also preserves full functionality under a vlan_filtering bridge. It does
+ * this by using the TCAM engines for:
+ * - pushing the RX VLAN as a second, outer tag, on egress towards the CPU port
+ * - redirecting towards the correct front port based on TX VLAN and popping
+ *   that on egress
+ */
+#include <linux/dsa/8021q.h>
+#include "dsa_priv.h"
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+
+	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
+			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+}
+
+static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
+				  struct net_device *netdev,
+				  struct packet_type *pt)
+{
+	int src_port, switch_id, qos_class;
+	u16 vid, tci;
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	if (skb_vlan_tag_present(skb)) {
+		tci = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		__skb_vlan_pop(skb, &tci);
+	}
+	skb_pull_rcsum(skb, ETH_HLEN);
+
+	vid = tci & VLAN_VID_MASK;
+	src_port = dsa_8021q_rx_source_port(vid);
+	switch_id = dsa_8021q_rx_switch_id(vid);
+	qos_class = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
+	if (!skb->dev)
+		return NULL;
+
+	skb->offload_fwd_mark = 1;
+	skb->priority = qos_class;
+
+	return skb;
+}
+
+static struct dsa_device_ops ocelot_netdev_ops = {
+	.name			= "ocelot-8021q",
+	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT_8021Q);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.25.1


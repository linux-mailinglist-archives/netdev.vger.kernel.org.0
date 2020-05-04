Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D71C49F4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgEDXAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728281AbgEDXAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32364C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so90811wmb.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wUHDA4nVNKlFsBHz3w4wdWcQ0jS3mUIYZBMwi75PeoE=;
        b=EiMJYKQwkPmyT9Cb6d/IYMBDVttsptPgUCAUt58riD77nvi+TyhtzgFcYKBr1tkbXt
         6g+FQj6yML4x9YHhuNulH//U6TLcAywvwAdh2rxDHMW7lF/7e4YGLBnW6JywT8j0Dvap
         C1TmgVo5huFvYWNQecVxvHwX/OVcZ98GIr1eSuqFfW0QHWkd9H/9WxnXrfwq4ISQkf9D
         tgikQHZiKJ1FgVoba6jUaOtVAdJo7gjBlCSdcQhUbrdcl8bEtX0DWe3p8zGioHstUqLS
         E6FfiPtxaPCZjBmjTMe2RdgLBDu3GNsn4WSXckLN2A3FEVdx+iZ7vp2nNocxyduzYfJV
         T8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wUHDA4nVNKlFsBHz3w4wdWcQ0jS3mUIYZBMwi75PeoE=;
        b=W0Dk5h0sxxtx9EuDBwCy+vuQoA3ssrcR0G8XeVx4R84AQDmDJLiuPtMqUxZjVgQLk3
         pYsv+3DA8zm4sDp5nYrhqMeMbvzp1dK1keowkS9AAlIAqTVrBNri9xEGn2NAdrkJ6knQ
         l1+YgZboKK3B+I2oYIaY6ZhKmxbQMA+uoacD/0GwdLb5Cr7L7v7LOv2q7rG+EoYvvLeF
         zxWAqPH2Z5ixRkrNfz7eoBjC4jZals4CmwRxb2/8PhAPcKmt4mhM2sz8KMXOJMBi79tR
         /UfJu7inbrJQSWvUB10nuRT/4Pb/1REDY+yhC+f4CNmXh05EAQEIcvgKPdlwqPOec7Yg
         ZPTw==
X-Gm-Message-State: AGi0PuZoabBzrGmx1Gycpxfgwx0lDQ0QoM3WlgVExQ4LtdYHh1UGCtJk
        VJOBcKBE6I7aMrWC1AWv87kkLSvdL6o=
X-Google-Smtp-Source: APiQypKctJ0H4xIYBZnC/p30PER0TtxMbmDp6sDqV34rY6yXwxvm9sbZEXh1S2X59/2VCJ3XPlJrJw==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr48948wme.126.1588633249307;
        Mon, 04 May 2020 16:00:49 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 4/6] net: dsa: sja1105: support flow-based redirection via virtual links
Date:   Tue,  5 May 2020 02:00:32 +0300
Message-Id: <20200504230034.23958-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504230034.23958-1-olteanv@gmail.com>
References: <20200504230034.23958-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Implement tc-flower offloads for redirect, trap and drop using
non-critical virtual links.

Commands which were tested to work are:

  # Send frames received on swp2 with a DA of 42:be:24:9b:76:20 to the
  # CPU and to swp3. This type of key (DA only) when the port's VLAN
  # awareness state is off.
  tc qdisc add dev swp2 clsact
  tc filter add dev swp2 ingress flower skip_sw dst_mac 42:be:24:9b:76:20 \
          action mirred egress redirect dev swp3 \
          action trap

  # Drop frames received on swp2 with a DA of 42:be:24:9b:76:20, a VID
  # of 100 and a PCP of 0.
  tc filter add dev swp2 ingress protocol 802.1Q flower skip_sw \
          dst_mac 42:be:24:9b:76:20 vlan_id 100 vlan_prio 0 action drop

Under the hood, all rules match on DMAC, VID and PCP, but when VLAN
filtering is disabled, those are set internally by the driver to the
port-based defaults. Because we would be put in an awkward situation if
the user were to change the VLAN filtering state while there are active
rules (packets would no longer match on the specified keys), we simply
deny changing vlan_filtering unless the list of flows offloaded via
virtual links is empty. Then the user can re-add new rules.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes from v1:
Using the new dsa_port_from_netdev helper.

Changes from RFC:
None.

 drivers/net/dsa/sja1105/Kconfig          |   9 +
 drivers/net/dsa/sja1105/Makefile         |   4 +
 drivers/net/dsa/sja1105/sja1105.h        |  18 ++
 drivers/net/dsa/sja1105/sja1105_flower.c |  57 ++++-
 drivers/net/dsa/sja1105/sja1105_main.c   |  12 +-
 drivers/net/dsa/sja1105/sja1105_vl.c     | 302 +++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_vl.h     |  41 +++
 7 files changed, 437 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.h

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 0fe1ae173aa1..bc59c3fbab50 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -33,3 +33,12 @@ config NET_DSA_SJA1105_TAS
 	  This enables support for the TTEthernet-based egress scheduling
 	  engine in the SJA1105 DSA driver, which is controlled using a
 	  hardware offload of the tc-tqprio qdisc.
+
+config NET_DSA_SJA1105_VL
+	bool "Support for Virtual Links on NXP SJA1105"
+	depends on NET_DSA_SJA1105_TAS
+	help
+	  This enables support for flow classification using capable devices
+	  (SJA1105T, SJA1105Q, SJA1105S). The following actions are supported:
+	  - redirect, trap, drop
+	  - time-based ingress policing, via the tc-gate action
diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 8943d8d66f2b..c88e56a29db8 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -17,3 +17,7 @@ endif
 ifdef CONFIG_NET_DSA_SJA1105_TAS
 sja1105-objs += sja1105_tas.o
 endif
+
+ifdef CONFIG_NET_DSA_SJA1105_VL
+sja1105-objs += sja1105_vl.o
+endif
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 95633ad9bfb7..1756000f6936 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -126,6 +126,13 @@ struct sja1105_key {
 enum sja1105_rule_type {
 	SJA1105_RULE_BCAST_POLICER,
 	SJA1105_RULE_TC_POLICER,
+	SJA1105_RULE_VL,
+};
+
+enum sja1105_vl_type {
+	SJA1105_VL_NONCRITICAL,
+	SJA1105_VL_RATE_CONSTRAINED,
+	SJA1105_VL_TIME_TRIGGERED,
 };
 
 struct sja1105_rule {
@@ -135,6 +142,7 @@ struct sja1105_rule {
 	struct sja1105_key key;
 	enum sja1105_rule_type type;
 
+	/* Action */
 	union {
 		/* SJA1105_RULE_BCAST_POLICER */
 		struct {
@@ -145,12 +153,19 @@ struct sja1105_rule {
 		struct {
 			int sharindx;
 		} tc_pol;
+
+		/* SJA1105_RULE_VL */
+		struct {
+			unsigned long destports;
+			enum sja1105_vl_type type;
+		} vl;
 	};
 };
 
 struct sja1105_flow_block {
 	struct list_head rules;
 	bool l2_policer_used[SJA1105_NUM_L2_POLICERS];
+	int num_virtual_links;
 };
 
 struct sja1105_private {
@@ -187,6 +202,7 @@ enum sja1105_reset_reason {
 	SJA1105_AGEING_TIME,
 	SJA1105_SCHEDULING,
 	SJA1105_BEST_EFFORT_POLICING,
+	SJA1105_VIRTUAL_LINKS,
 };
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
@@ -290,5 +306,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress);
 void sja1105_flower_setup(struct dsa_switch *ds);
 void sja1105_flower_teardown(struct dsa_switch *ds);
+struct sja1105_rule *sja1105_rule_find(struct sja1105_private *priv,
+				       unsigned long cookie);
 
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 3246d5a49436..5f08eed0b1fc 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -2,9 +2,10 @@
 /* Copyright 2020, NXP Semiconductors
  */
 #include "sja1105.h"
+#include "sja1105_vl.h"
 
-static struct sja1105_rule *sja1105_rule_find(struct sja1105_private *priv,
-					      unsigned long cookie)
+struct sja1105_rule *sja1105_rule_find(struct sja1105_private *priv,
+				       unsigned long cookie)
 {
 	struct sja1105_rule *rule;
 
@@ -173,7 +174,8 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 
 static int sja1105_flower_policer(struct sja1105_private *priv, int port,
 				  struct netlink_ext_ack *extack,
-				  unsigned long cookie, struct sja1105_key *key,
+				  unsigned long cookie,
+				  struct sja1105_key *key,
 				  u64 rate_bytes_per_sec,
 				  s64 burst)
 {
@@ -308,6 +310,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	const struct flow_action_entry *act;
 	unsigned long cookie = cls->cookie;
 	struct sja1105_key key;
+	bool vl_rule = false;
 	int rc, i;
 
 	rc = sja1105_flower_parse_key(priv, extack, cls, &key);
@@ -319,13 +322,50 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			rc = sja1105_flower_policer(priv, port,
-						    extack, cookie, &key,
+			rc = sja1105_flower_policer(priv, port, extack, cookie,
+						    &key,
 						    act->police.rate_bytes_ps,
 						    act->police.burst);
 			if (rc)
 				goto out;
 			break;
+		case FLOW_ACTION_TRAP: {
+			int cpu = dsa_upstream_port(ds, port);
+
+			vl_rule = true;
+
+			rc = sja1105_vl_redirect(priv, port, extack, cookie,
+						 &key, BIT(cpu), true);
+			if (rc)
+				goto out;
+			break;
+		}
+		case FLOW_ACTION_REDIRECT: {
+			struct dsa_port *to_dp;
+
+			to_dp = dsa_port_from_netdev(act->dev);
+			if (IS_ERR(to_dp)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Destination not a switch port");
+				return -EOPNOTSUPP;
+			}
+
+			vl_rule = true;
+
+			rc = sja1105_vl_redirect(priv, port, extack, cookie,
+						 &key, BIT(to_dp->index), true);
+			if (rc)
+				goto out;
+			break;
+		}
+		case FLOW_ACTION_DROP:
+			vl_rule = true;
+
+			rc = sja1105_vl_redirect(priv, port, extack, cookie,
+						 &key, 0, false);
+			if (rc)
+				goto out;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Action not supported");
@@ -333,6 +373,10 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			goto out;
 		}
 	}
+
+	if (vl_rule && !rc)
+		rc = sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
+
 out:
 	return rc;
 }
@@ -348,6 +392,9 @@ int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 	if (!rule)
 		return 0;
 
+	if (rule->type == SJA1105_RULE_VL)
+		return sja1105_vl_delete(priv, port, rule, cls->common.extack);
+
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
 
 	if (rule->type == SJA1105_RULE_BCAST_POLICER) {
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 472f4eb20c49..8bb104ee73d5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -445,7 +445,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 */
 		.casc_port = SJA1105_NUM_PORTS,
 		/* No TTEthernet */
-		.vllupformat = 0,
+		.vllupformat = SJA1105_VL_FORMAT_PSFP,
 		.vlmarker = 0,
 		.vlmask = 0,
 		/* Only update correctionField for 1-step PTP (L2 transport) */
@@ -1589,6 +1589,7 @@ static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_AGEING_TIME] = "Ageing time",
 	[SJA1105_SCHEDULING] = "Time-aware scheduling",
 	[SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
+	[SJA1105_VIRTUAL_LINKS] = "Virtual links",
 };
 
 /* For situations where we need to change a setting at runtime that is only
@@ -1831,9 +1832,18 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
+	struct sja1105_rule *rule;
 	u16 tpid, tpid2;
 	int rc;
 
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		if (rule->type == SJA1105_RULE_VL) {
+			dev_err(ds->dev,
+				"Cannot change VLAN filtering state while VL rules are active\n");
+			return -EBUSY;
+		}
+	}
+
 	if (enabled) {
 		/* Enable VLAN filtering. */
 		tpid  = ETH_P_8021Q;
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
new file mode 100644
index 000000000000..c226779b8275
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020, NXP Semiconductors
+ */
+#include <linux/dsa/8021q.h>
+#include "sja1105.h"
+
+/* The switch flow classification core implements TTEthernet, which 'thinks' in
+ * terms of Virtual Links (VL), a concept borrowed from ARINC 664 part 7.
+ * However it also has one other operating mode (VLLUPFORMAT=0) where it acts
+ * somewhat closer to a pre-standard implementation of IEEE 802.1Qci
+ * (Per-Stream Filtering and Policing), which is what the driver is going to be
+ * implementing.
+ *
+ *                                 VL Lookup
+ *        Key = {DMAC && VLANID   +---------+  Key = { (DMAC[47:16] & VLMASK ==
+ *               && VLAN PCP      |         |                         VLMARKER)
+ *               && INGRESS PORT} +---------+                      (both fixed)
+ *            (exact match,            |             && DMAC[15:0] == VLID
+ *         all specified in rule)      |                    (specified in rule)
+ *                                     v             && INGRESS PORT }
+ *                               ------------
+ *                    0 (PSFP)  /            \  1 (ARINC664)
+ *                 +-----------/  VLLUPFORMAT \----------+
+ *                 |           \    (fixed)   /          |
+ *                 |            \            /           |
+ *  0 (forwarding) v             ------------            |
+ *           ------------                                |
+ *          /            \  1 (QoS classification)       |
+ *     +---/  ISCRITICAL  \-----------+                  |
+ *     |   \  (per rule)  /           |                  |
+ *     |    \            /   VLID taken from      VLID taken from
+ *     v     ------------     index of rule       contents of rule
+ *  select                     that matched         that matched
+ * DESTPORTS                          |                  |
+ *  |                                 +---------+--------+
+ *  |                                           |
+ *  |                                           v
+ *  |                                     VL Forwarding
+ *  |                                   (indexed by VLID)
+ *  |                                      +---------+
+ *  |                       +--------------|         |
+ *  |                       |  select TYPE +---------+
+ *  |                       v
+ *  |   0 (rate      ------------    1 (time
+ *  |  constrained) /            \   triggered)
+ *  |       +------/     TYPE     \------------+
+ *  |       |      \  (per VLID)  /            |
+ *  |       v       \            /             v
+ *  |  VL Policing   ------------         VL Policing
+ *  | (indexed by VLID)                (indexed by VLID)
+ *  |  +---------+                        +---------+
+ *  |  | TYPE=0  |                        | TYPE=1  |
+ *  |  +---------+                        +---------+
+ *  |  select SHARINDX                 select SHARINDX to
+ *  |  to rate-limit                 re-enter VL Forwarding
+ *  |  groups of VL's               with new VLID for egress
+ *  |  to same quota                           |
+ *  |       |                                  |
+ *  |  select MAXLEN -> exceed => drop    select MAXLEN -> exceed => drop
+ *  |       |                                  |
+ *  |       v                                  v
+ *  |  VL Forwarding                      VL Forwarding
+ *  | (indexed by SHARINDX)             (indexed by SHARINDX)
+ *  |  +---------+                        +---------+
+ *  |  | TYPE=0  |                        | TYPE=1  |
+ *  |  +---------+                        +---------+
+ *  |  select PRIORITY,                 select PRIORITY,
+ *  | PARTITION, DESTPORTS            PARTITION, DESTPORTS
+ *  |       |                                  |
+ *  |       v                                  v
+ *  |  VL Policing                        VL Policing
+ *  | (indexed by SHARINDX)           (indexed by SHARINDX)
+ *  |  +---------+                        +---------+
+ *  |  | TYPE=0  |                        | TYPE=1  |
+ *  |  +---------+                        +---------+
+ *  |       |                                  |
+ *  |       v                                  |
+ *  |  select BAG, -> exceed => drop           |
+ *  |    JITTER                                v
+ *  |       |             ----------------------------------------------
+ *  |       |            /    Reception Window is open for this VL      \
+ *  |       |           /    (the Schedule Table executes an entry i     \
+ *  |       |          /   M <= i < N, for which these conditions hold):  \ no
+ *  |       |    +----/                                                    \-+
+ *  |       |    |yes \       WINST[M] == 1 && WINSTINDEX[M] == VLID       / |
+ *  |       |    |     \     WINEND[N] == 1 && WINSTINDEX[N] == VLID      /  |
+ *  |       |    |      \                                                /   |
+ *  |       |    |       \ (the VL window has opened and not yet closed)/    |
+ *  |       |    |        ----------------------------------------------     |
+ *  |       |    v                                                           v
+ *  |       |  dispatch to DESTPORTS when the Schedule Table               drop
+ *  |       |  executes an entry i with TXEN == 1 && VLINDEX == i
+ *  v       v
+ * dispatch immediately to DESTPORTS
+ *
+ * The per-port classification key is always composed of {DMAC, VID, PCP} and
+ * is non-maskable. This 'looks like' the NULL stream identification function
+ * from IEEE 802.1CB clause 6, except for the extra VLAN PCP. When the switch
+ * ports operate as VLAN-unaware, we do allow the user to not specify the VLAN
+ * ID and PCP, and then the port-based defaults will be used.
+ *
+ * In TTEthernet, routing is something that needs to be done manually for each
+ * Virtual Link. So the flow action must always include one of:
+ * a. 'redirect', 'trap' or 'drop': select the egress port list
+ * Additionally, the following actions may be applied on a Virtual Link,
+ * turning it into 'critical' traffic:
+ * b. 'police': turn it into a rate-constrained VL, with bandwidth limitation
+ *    given by the maximum frame length, bandwidth allocation gap (BAG) and
+ *    maximum jitter.
+ * c. 'gate': turn it into a time-triggered VL, which can be only be received
+ *    and forwarded according to a given schedule.
+ */
+
+static bool sja1105_vl_key_lower(struct sja1105_vl_lookup_entry *a,
+				 struct sja1105_vl_lookup_entry *b)
+{
+	if (a->macaddr < b->macaddr)
+		return true;
+	if (a->macaddr > b->macaddr)
+		return false;
+	if (a->vlanid < b->vlanid)
+		return true;
+	if (a->vlanid > b->vlanid)
+		return false;
+	if (a->port < b->port)
+		return true;
+	if (a->port > b->port)
+		return false;
+	if (a->vlanprior < b->vlanprior)
+		return true;
+	if (a->vlanprior > b->vlanprior)
+		return false;
+	/* Keys are equal */
+	return false;
+}
+
+static int sja1105_init_virtual_links(struct sja1105_private *priv,
+				      struct netlink_ext_ack *extack)
+{
+	struct sja1105_vl_lookup_entry *vl_lookup;
+	struct sja1105_table *table;
+	struct sja1105_rule *rule;
+	int num_virtual_links = 0;
+	int i, j, k;
+
+	/* Figure out the dimensioning of the problem */
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+		/* Each VL lookup entry matches on a single ingress port */
+		num_virtual_links += hweight_long(rule->port_mask);
+	}
+
+	if (num_virtual_links > SJA1105_MAX_VL_LOOKUP_COUNT) {
+		NL_SET_ERR_MSG_MOD(extack, "Not enough VL entries available");
+		return -ENOSPC;
+	}
+
+	/* Discard previous VL Lookup Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_LOOKUP];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Nothing to do */
+	if (!num_virtual_links)
+		return 0;
+
+	/* Pre-allocate space in the static config tables */
+
+	/* VL Lookup Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_LOOKUP];
+	table->entries = kcalloc(num_virtual_links,
+				 table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = num_virtual_links;
+	vl_lookup = table->entries;
+
+	k = 0;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		unsigned long port;
+
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+
+		for_each_set_bit(port, &rule->port_mask, SJA1105_NUM_PORTS) {
+			vl_lookup[k].format = SJA1105_VL_FORMAT_PSFP;
+			vl_lookup[k].port = port;
+			vl_lookup[k].macaddr = rule->key.vl.dmac;
+			if (rule->key.type == SJA1105_KEY_VLAN_AWARE_VL) {
+				vl_lookup[k].vlanid = rule->key.vl.vid;
+				vl_lookup[k].vlanprior = rule->key.vl.pcp;
+			} else {
+				u16 vid = dsa_8021q_rx_vid(priv->ds, port);
+
+				vl_lookup[k].vlanid = vid;
+				vl_lookup[k].vlanprior = 0;
+			}
+			/* For critical VLs, the DESTPORTS mask is taken from
+			 * the VL Forwarding Table, so no point in putting it
+			 * in the VL Lookup Table
+			 */
+			if (rule->vl.type == SJA1105_VL_NONCRITICAL)
+				vl_lookup[k].destports = rule->vl.destports;
+			else
+				vl_lookup[k].iscritical = true;
+			k++;
+		}
+	}
+
+	/* UM10944.pdf chapter 4.2.3 VL Lookup table:
+	 * "the entries in the VL Lookup table must be sorted in ascending
+	 * order (i.e. the smallest value must be loaded first) according to
+	 * the following sort order: MACADDR, VLANID, PORT, VLANPRIOR."
+	 */
+	for (i = 0; i < num_virtual_links; i++) {
+		struct sja1105_vl_lookup_entry *a = &vl_lookup[i];
+
+		for (j = i + 1; j < num_virtual_links; j++) {
+			struct sja1105_vl_lookup_entry *b = &vl_lookup[j];
+
+			if (sja1105_vl_key_lower(b, a)) {
+				struct sja1105_vl_lookup_entry tmp = *a;
+
+				*a = *b;
+				*b = tmp;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int sja1105_vl_redirect(struct sja1105_private *priv, int port,
+			struct netlink_ext_ack *extack, unsigned long cookie,
+			struct sja1105_key *key, unsigned long destports,
+			bool append)
+{
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	int rc;
+
+	if (dsa_port_is_vlan_filtering(dsa_to_port(priv->ds, port)) &&
+	    key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only redirect based on {DMAC, VID, PCP}");
+		return -EOPNOTSUPP;
+	} else if (key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only redirect based on DMAC");
+		return -EOPNOTSUPP;
+	}
+
+	if (!rule) {
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule)
+			return -ENOMEM;
+
+		rule->cookie = cookie;
+		rule->type = SJA1105_RULE_VL;
+		rule->key = *key;
+		list_add(&rule->list, &priv->flow_block.rules);
+	}
+
+	rule->port_mask |= BIT(port);
+	if (append)
+		rule->vl.destports |= destports;
+	else
+		rule->vl.destports = destports;
+
+	rc = sja1105_init_virtual_links(priv, extack);
+	if (rc) {
+		rule->port_mask &= ~BIT(port);
+		if (!rule->port_mask) {
+			list_del(&rule->list);
+			kfree(rule);
+		}
+	}
+
+	return rc;
+}
+
+int sja1105_vl_delete(struct sja1105_private *priv, int port,
+		      struct sja1105_rule *rule, struct netlink_ext_ack *extack)
+{
+	int rc;
+
+	rule->port_mask &= ~BIT(port);
+	if (!rule->port_mask) {
+		list_del(&rule->list);
+		kfree(rule);
+	}
+
+	rc = sja1105_init_virtual_links(priv, extack);
+	if (rc)
+		return rc;
+
+	return sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.h b/drivers/net/dsa/sja1105/sja1105_vl.h
new file mode 100644
index 000000000000..08ee5557b463
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_vl.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020, NXP Semiconductors
+ */
+#ifndef _SJA1105_VL_H
+#define _SJA1105_VL_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_VL)
+
+int sja1105_vl_redirect(struct sja1105_private *priv, int port,
+			struct netlink_ext_ack *extack, unsigned long cookie,
+			struct sja1105_key *key, unsigned long destports,
+			bool append);
+
+int sja1105_vl_delete(struct sja1105_private *priv, int port,
+		      struct sja1105_rule *rule,
+		      struct netlink_ext_ack *extack);
+
+#else
+
+static inline int sja1105_vl_redirect(struct sja1105_private *priv, int port,
+				      struct netlink_ext_ack *extack,
+				      unsigned long cookie,
+				      struct sja1105_key *key,
+				      unsigned long destports,
+				      bool append)
+{
+	NL_SET_ERR_MSG_MOD(extack, "Virtual Links not compiled in");
+	return -EOPNOTSUPP;
+}
+
+static inline int sja1105_vl_delete(struct sja1105_private *priv,
+				    int port, struct sja1105_rule *rule,
+				    struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG_MOD(extack, "Virtual Links not compiled in");
+	return -EOPNOTSUPP;
+}
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_VL) */
+
+#endif /* _SJA1105_VL_H */
-- 
2.17.1


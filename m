Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258FB1C39B5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgEDMo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728125AbgEDMoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:23 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F93DC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so20721687wrv.10
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9wnPAkGNLB0wQOlYn6wdF/PnMiFe9GBaa49zGf0rRY=;
        b=rw3MrNKNK4UYS2LTZNsVF4tMZGTIT+kXwGNegImFKt0cwPYTY2AObpUJJtL9CR7E4i
         RR5q0Gcga0zdr4vAUriWkh+6pacmg1xf39SjyAEMbxmWWiwsVWoNlUSDDbjskkqTTiNe
         Dn8F2PW+dNaVyTGlCZyx28mMkjWynNgYh2SIYqedOcdYBlbw+OR4hibeNPKReDOOScEV
         DtEV3sNq/4avZ1y9v3Hwo3yny9eG2Syh+cSGZy7h/YHKnyX1Y6C6wKiEX3khTrzdIB+A
         jT+TpkqgpGJQchQSGuJ1VxsIgT15o4guvvweAWUQhWW99mRR7E32RWtmzr4Rtp+vD2z3
         Tj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k9wnPAkGNLB0wQOlYn6wdF/PnMiFe9GBaa49zGf0rRY=;
        b=r4nsDbxqXhM3cyX0t6u7nCFaPAJpwcURxfmE2fh4lB6gv6B0IWppkcLd4DSCOiAI+I
         jzBhSOWzRwf1i02e1RC0wM/ET2QNECwuFAkhk8PU4EJndOtEgkBnk/WMCfsobkJZ778/
         Gz8WwGyEYmCOGk4byQGUNb8fYNSYVUz0WlJ4VYLY77VGbvnF2mqNcH+000aPJjM0ZOcA
         6AwBJ7Yv+EeQo6xDn5TLDDwUMIeLbCkdxx2yWeUTHcqY7kE7sEuoFGQs95wfFBM9BoSv
         bNyopDGWDwt0Q4+7lP4f1+O6lyUSNAng7NNZAPHSltIqtOg7JHglELpl32ImQbHSmdra
         yp5w==
X-Gm-Message-State: AGi0PuZsIXwtRkwEITw0+pqV9EjBczxgIPgh8Sko/Mktdf23LRgfywSO
        l5xNHjeYXDkdHJy/JFDcm5k=
X-Google-Smtp-Source: APiQypIUYrmRG8C1j4X7GDXO+7ouzB5jlUG/1xc9y8U/nyQ8jGl08x8fjWepBidnLdBRaLzw0usGPg==
X-Received: by 2002:adf:e751:: with SMTP id c17mr1943491wrn.351.1588596261459;
        Mon, 04 May 2020 05:44:21 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 5/6] net: dsa: sja1105: support up to 7 VLANs per port using retagging
Date:   Mon,  4 May 2020 15:43:24 +0300
Message-Id: <20200504124325.26758-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For switches that support VLAN retagging, such as sja1105, we extend
dsa_8021q by encoding a "sub-VLAN" into the remaining 3 free bits in the
dsa_8021q tag.

A sub-VLAN is nothing more than a number in the range 0-7, which serves
as an index into a per-port driver lookup table. The sub-VLAN value of
zero means that traffic is untagged (this is also backwards-compatible
with dsa_8021q without retagging).

The switch is configured to retag VLAN-tagged traffic that gets
transmitted towards the CPU port (and towards the CPU only). Example:

bridge vlan add dev sw1p0 vid 100

The switch retags frames received on port 0, going to the CPU, and
having VID 100, to the VID of 1104 0x0450. In dsa_8021q language, 0x0450
means:

 | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
 +-----------+-----+-----------------+-----------+-----------------------+
 |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
 +-----------+-----+-----------------+-----------+-----------------------+

aka:
 - DIR = 0b01: this is an RX VLAN
 - SUBVLAN = 0b001: this is subvlan #1
 - SWITCH_ID = 0b001: this is switch 1 (see the name "sw1p0")
 - PORT = 0b0000: this is port 0 (see the name "sw1p0")

The driver also remembers the "1 -> 100" mapping. In the hotpath, if the
sub-VLAN from the tag encodes a non-untagged frame, this mapping is used
to create a VLAN hwaccel tag, with the value of 100.

There are some performance-related concerns, since all VLAN-retagged
traffic cannot exceed 1Gbps due to the way it is implemented in hardware.
This should not be an issue, because:
- We only support retagging towards the CPU port, which is limited at
  1Gbps anyway.
- VLAN-tagged traffic between ports on the same chip works without
  retagging.
- Untagged traffic, autonomously forwarded as well as terminated
  locally, works without retagging.

On xmit from Linux, transmitting VLAN-tagged traffic is possible by
adding a second VLAN tag with the tx_vid (which encode the destination
port). But this tag needs to be transmitted using a different TPID than
the plain ETH_P_8021Q, because otherwise, the switch thinks we're trying
to do VLAN hopping, it freaks out and drops our frame. By using a TPID
of ETH_P_8021AD, it looks at the S-tag only, which is what we want.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 244 ++++++++++++++++++++++++-
 include/linux/dsa/8021q.h              |  31 ++++
 include/linux/dsa/sja1105.h            |   2 +
 net/dsa/tag_8021q.c                    |  80 ++++++--
 net/dsa/tag_sja1105.c                  |  21 ++-
 5 files changed, 357 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index edbe5dd4af37..106182103b19 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -387,7 +387,8 @@ static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 		/* Disallow dynamic reconfiguration of vlan_pmap */
 		.max_dynp = 0,
 		/* Use a single memory partition for all ingress queues */
-		.part_spc = { SJA1105_MAX_FRAME_MEMORY, 0, 0, 0, 0, 0, 0, 0 },
+		.part_spc = { SJA1105_MAX_FRAME_MEMORY_RETAGGING,
+			      0, 0, 0, 0, 0, 0, 0 },
 	};
 	struct sja1105_table *table;
 
@@ -1733,6 +1734,31 @@ static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 	return -1;
 }
 
+/* The Retagging Table generates packet *clones* with the new VLAN. This is a
+ * very odd hardware quirk which we need to suppress by dropping the original
+ * packet. We do that by removing the pre-retagging VID from the port
+ * membership of the egress port. For this strategy to be effective, we need a
+ * blacklist to ensure that nobody can add that VID back on the destination
+ * port, otherwise we'll see duplicates (with the old and the new VID).
+ */
+static bool sja1105_vlan_is_blacklisted(struct sja1105_private *priv, int port,
+					u16 vid)
+{
+	struct sja1105_retagging_entry *retagging;
+	struct sja1105_table *table;
+	int i;
+
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
+	retagging = table->entries;
+
+	for (i = 0; i < table->entry_count; i++)
+		if ((retagging[i].egr_port & BIT(port)) &&
+		    (retagging[i].vlan_ing == vid))
+			return true;
+
+	return false;
+}
+
 static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 			      bool enabled, bool untagged)
 {
@@ -1741,6 +1767,9 @@ static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 	bool keep = true;
 	int match, rc;
 
+	if (enabled && sja1105_vlan_is_blacklisted(priv, port, vid))
+		return 0;
+
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
 	match = sja1105_is_vlan_configured(priv, vid);
@@ -1793,6 +1822,194 @@ static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 	return 0;
 }
 
+static int sja1105_find_retagging_entry(struct sja1105_private *priv,
+					int from_port, u16 from_vid,
+					int to_port, u16 to_vid)
+{
+	struct sja1105_retagging_entry *retagging;
+	struct sja1105_table *table;
+	int i;
+
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
+	retagging = table->entries;
+
+	for (i = 0; i < table->entry_count; i++)
+		if (retagging[i].ing_port & BIT(from_port) &&
+		    retagging[i].egr_port & BIT(to_port) &&
+		    retagging[i].vlan_ing == from_vid &&
+		    retagging[i].vlan_egr == to_vid)
+			return i;
+
+	return -1;
+}
+
+static int sja1105_setup_retagging_vid(struct sja1105_private *priv,
+				       int from_port, u16 from_vid, int to_port,
+				       u16 to_vid, bool keep, bool untagged)
+{
+	int rc;
+
+	rc = sja1105_vlan_apply(priv, from_port, to_vid, keep, true);
+	if (rc)
+		return rc;
+
+	rc = sja1105_vlan_apply(priv, to_port, to_vid, keep, untagged);
+	if (rc)
+		return rc;
+
+	return sja1105_vlan_apply(priv, to_port, from_vid, false, false);
+}
+
+static int sja1105_retagging_apply(struct sja1105_private *priv, int from_port,
+				   u16 from_vid, int to_port, u16 to_vid,
+				   bool keep, bool untagged)
+{
+	struct sja1105_retagging_entry *retagging;
+	struct sja1105_table *table;
+	int rc, match;
+
+	rc = sja1105_setup_retagging_vid(priv, from_port, from_vid, to_port,
+					 to_vid, keep, untagged);
+	if (rc)
+		return rc;
+
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
+
+	match = sja1105_find_retagging_entry(priv, from_port, from_vid,
+					     to_port, to_vid);
+	if (match < 0) {
+		/* Can't delete a missing entry. */
+		if (!keep) {
+			dev_err(priv->ds->dev, "can't delete a missing entry\n");
+			return 0;
+		}
+
+		/* No match => new entry */
+		rc = sja1105_table_resize(table, table->entry_count + 1);
+		if (rc) {
+			dev_err(priv->ds->dev, "failed to resize retagging table: %d\n", rc);
+			return rc;
+		}
+
+		match = table->entry_count - 1;
+	}
+
+	/* Assign pointer after the resize (it may be new memory) */
+	retagging = table->entries;
+
+	if (keep) {
+		retagging[match].egr_port = BIT(to_port);
+		retagging[match].ing_port = BIT(from_port);
+		retagging[match].vlan_ing = from_vid;
+		retagging[match].vlan_egr = to_vid;
+		retagging[match].do_not_learn = false;
+		retagging[match].use_dest_ports = true;
+		retagging[match].destports = BIT(to_port);
+
+		dev_err(priv->ds->dev,
+			"%s: entry %d egr_port 0x%llx ing_port 0x%llx vlan_ing %lld vlan_egr %lld do_not_learn %lld use_dest_ports %lld destports %lld\n",
+			__func__, match, retagging[match].egr_port, retagging[match].ing_port, retagging[match].vlan_ing, retagging[match].vlan_egr,
+			retagging[match].do_not_learn, retagging[match].use_dest_ports, retagging[match].destports);
+		return sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
+						    match, &retagging[match],
+						    true);
+	}
+
+	/* To remove, the strategy is to overwrite the element with
+	 * the last one, and then reduce the array size by 1
+	 */
+	retagging[match] = retagging[table->entry_count - 1];
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
+					  table->entry_count - 1,
+					  &retagging[table->entry_count - 1],
+					  false);
+	if (rc)
+		return rc;
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING, match,
+					  &retagging[match], true);
+	if (rc)
+		return rc;
+
+	return sja1105_table_resize(table, table->entry_count - 1);
+}
+
+static int sja1105_find_free_subvlan(struct sja1105_private *priv, int port)
+{
+	struct sja1105_port *sp = &priv->ports[port];
+	int subvlan;
+
+	for (subvlan = 1; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		if (sp->subvlan_map[subvlan] == VLAN_N_VID)
+			return subvlan;
+
+	return -1;
+}
+
+static int sja1105_find_subvlan(struct sja1105_private *priv, int port, u16 vid)
+{
+	struct sja1105_port *sp = &priv->ports[port];
+	int subvlan;
+
+	for (subvlan = 1; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		if (sp->subvlan_map[subvlan] == vid)
+			return subvlan;
+
+	return -1;
+}
+
+static int sja1105_subvlan_apply(struct sja1105_private *priv, int port,
+				 u16 vid, bool pvid, bool keep)
+{
+	struct sja1105_port *sp = &priv->ports[port];
+	int cpu = dsa_upstream_port(priv->ds, port);
+	int rc, subvlan;
+	u16 rx_vid;
+
+	/* There are several situations when we don't want to add a subvlan */
+	if (!priv->best_effort_vlan_filtering)
+		return 0;
+	if (vid_is_dsa_8021q(vid))
+		return 0;
+	if (!dsa_is_user_port(priv->ds, port))
+		return 0;
+
+	if (keep) {
+		subvlan = sja1105_find_free_subvlan(priv, port);
+		if (subvlan < 0) {
+			dev_err(priv->ds->dev, "No more free subvlans\n");
+			return -ENOSPC;
+		}
+	} else {
+		subvlan = sja1105_find_subvlan(priv, port, vid);
+		if (subvlan < 0)
+			/* A subvlan may not be found because either we ran out
+			 * (and that's ok, after all, we only support up to 7
+			 * per port), or because the VID was added prior to
+			 * best_effort_vlan_filtering getting toggled. So it's
+			 * perfectly fine, don't do anything.
+			 */
+			return 0;
+	}
+
+	if (pvid)
+		rx_vid = dsa_8021q_rx_vid(priv->ds, port);
+	else
+		rx_vid = dsa_8021q_rx_vid_subvlan(priv->ds, port, subvlan);
+
+	rc = sja1105_retagging_apply(priv, port, vid, cpu, rx_vid, keep, false);
+	if (rc)
+		return rc;
+
+	if (keep)
+		sp->subvlan_map[subvlan] = vid;
+	else
+		sp->subvlan_map[subvlan] = VLAN_N_VID;
+
+	return 0;
+}
+
 static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 					 int tree_index, int sw_index,
 					 int other_port, struct net_device *br)
@@ -1918,8 +2135,13 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 	 */
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		rc = dsa_8021q_vid_validate(ds, port, vid, vlan->flags);
-		if (rc < 0)
-			return rc;
+		/* Suppress the "wrong pvid" error. We can (and will) retag the
+		 * pvid requested by the bridge to the dsa_8021q pvid. Untagged
+		 * traffic is still tagged with the dsa_8021q pvid directly and
+		 * does not require retagging.
+		 */
+		if (rc < 0 && rc != DSA_8021Q_WRONG_PVID)
+			return -EPERM;
 	}
 
 	return 0;
@@ -2017,6 +2239,8 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+
 		rc = sja1105_vlan_apply(priv, port, vid, true, vlan->flags &
 					BRIDGE_VLAN_INFO_UNTAGGED);
 		if (rc < 0) {
@@ -2024,7 +2248,7 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 				vid, port, rc);
 			return;
 		}
-		if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		if (pvid) {
 			rc = sja1105_pvid_apply(ds->priv, port, vid);
 			if (rc < 0) {
 				dev_err(ds->dev, "Failed to set pvid %d on port %d: %d\n",
@@ -2032,6 +2256,9 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 				return;
 			}
 		}
+		rc = sja1105_subvlan_apply(priv, port, vid, pvid, true);
+		if (rc)
+			return;
 	}
 }
 
@@ -2043,6 +2270,8 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+
 		rc = sja1105_vlan_apply(priv, port, vid, false, vlan->flags &
 					BRIDGE_VLAN_INFO_UNTAGGED);
 		if (rc < 0) {
@@ -2050,6 +2279,9 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 				vid, port, rc);
 			return rc;
 		}
+		rc = sja1105_subvlan_apply(priv, port, vid, pvid, false);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
@@ -2728,6 +2960,7 @@ static int sja1105_probe(struct spi_device *spi)
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
+		int subvlan;
 
 		if (!dsa_is_user_port(ds, port))
 			continue;
@@ -2747,6 +2980,9 @@ static int sja1105_probe(struct spi_device *spi)
 			goto out;
 		}
 		skb_queue_head_init(&sp->xmit_queue);
+
+		for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+			sp->subvlan_map[subvlan] = VLAN_N_VID;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index dfbd5b62f67a..40d85d3cdf15 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -20,6 +20,16 @@ struct dsa_8021q_crosschip_link {
 	refcount_t refcount;
 };
 
+enum dsa_8021q_vid_error {
+	DSA_8021Q_VID_OK = 0,
+	DSA_8021Q_WRONG_PVID = -1,
+	DSA_8021Q_TX_VLAN_WRONG_FLAGS = -2,
+	DSA_8021Q_TX_VLAN_WRONG_PORT = -3,
+	DSA_8021Q_RX_VLAN_WRONG_FLAGS = -4,
+};
+
+#define DSA_8021Q_N_SUBVLAN			8
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -48,10 +58,16 @@ u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan);
+
 int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
+u16 dsa_8021q_rx_subvlan(u16 vid);
+
+bool vid_is_dsa_8021q(u16 vid);
+
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -104,6 +120,11 @@ u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 	return 0;
 }
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
+{
+	return 0;
+}
+
 int dsa_8021q_rx_switch_id(u16 vid)
 {
 	return 0;
@@ -114,6 +135,16 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
+u16 dsa_8021q_rx_subvlan(u16 vid)
+{
+	return 0;
+}
+
+bool vid_is_dsa_8021q(u16 vid)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index a609fdbe1355..ef04625087ef 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -9,6 +9,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/8021q.h>
 #include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
@@ -53,6 +54,7 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
 
 struct sja1105_port {
+	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
 	struct kthread_worker *xmit_worker;
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3958f426d60e..48d4cb42763f 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -17,7 +17,7 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | RSV |    SWITCH_ID    |    RSV    |          PORT         |
+ * |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
  * DIR - VID[11:10]:
@@ -27,17 +27,24 @@
  *	These values make the special VIDs of 0, 1 and 4095 to be left
  *	unused by this coding scheme.
  *
- * RSV - VID[9]:
- *	To be used for further expansion of SWITCH_ID or for other purposes.
- *	Must be transmitted as zero and ignored on receive.
+ * SVL/SUBVLAN - { VID[9], VID[5:4] }:
+ *	Sub-VLAN encoding. Valid only when DIR indicates an RX VLAN.
+ *	* 0 (0b000): Field does not encode a sub-VLAN, either because
+ *	received traffic is untagged, PVID-tagged or because a second
+ *	VLAN tag is present after this tag and not inside of it.
+ *	* 1 (0b001): Received traffic is tagged with a VID value private
+ *	to the host. This field encodes the index in the host's lookup
+ *	table through which the value of the ingress VLAN ID can be
+ *	recovered.
+ *	* 2 (0b010): Field encodes a sub-VLAN.
+ *	...
+ *	* 7 (0b111): Field encodes a sub-VLAN.
+ *	When DIR indicates a TX VLAN, SUBVLAN must be transmitted as zero
+ *	(by the host) and ignored on receive (by the switch).
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
  *
- * RSV - VID[5:4]:
- *	To be used for further expansion of PORT or for other purposes.
- *	Must be transmitted as zero and ignored on receive.
- *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and 15.
  */
@@ -54,6 +61,18 @@
 #define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
 						 DSA_8021Q_SWITCH_ID_MASK)
 
+#define DSA_8021Q_SUBVLAN_HI_SHIFT	9
+#define DSA_8021Q_SUBVLAN_HI_MASK	GENMASK(9, 9)
+#define DSA_8021Q_SUBVLAN_LO_SHIFT	4
+#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(4, 3)
+#define DSA_8021Q_SUBVLAN_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
+#define DSA_8021Q_SUBVLAN_LO(x)		((x) & GENMASK(1, 0))
+#define DSA_8021Q_SUBVLAN(x)		\
+		(((DSA_8021Q_SUBVLAN_LO(x) << DSA_8021Q_SUBVLAN_LO_SHIFT) & \
+		  DSA_8021Q_SUBVLAN_LO_MASK) | \
+		 ((DSA_8021Q_SUBVLAN_HI(x) << DSA_8021Q_SUBVLAN_HI_SHIFT) & \
+		  DSA_8021Q_SUBVLAN_HI_MASK))
+
 #define DSA_8021Q_PORT_SHIFT		0
 #define DSA_8021Q_PORT_MASK		GENMASK(3, 0)
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
@@ -79,6 +98,13 @@ u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
+{
+	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
+	       DSA_8021Q_PORT(port) | DSA_8021Q_SUBVLAN(subvlan);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid_subvlan);
+
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
 {
@@ -93,6 +119,27 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+/* Returns the decoded subvlan from the RX VID. */
+u16 dsa_8021q_rx_subvlan(u16 vid)
+{
+	u16 svl_hi, svl_lo;
+
+	svl_hi = (vid & DSA_8021Q_SUBVLAN_HI_MASK) >>
+		 DSA_8021Q_SUBVLAN_HI_SHIFT;
+	svl_lo = (vid & DSA_8021Q_SUBVLAN_LO_MASK) >>
+		 DSA_8021Q_SUBVLAN_LO_SHIFT;
+
+	return (svl_hi << 2) | svl_lo;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
+
+bool vid_is_dsa_8021q(u16 vid)
+{
+	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
+		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
+
 static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 {
 	struct bridge_vlan_info vinfo;
@@ -289,7 +336,8 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
-int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
+enum dsa_8021q_vid_error dsa_8021q_vid_validate(struct dsa_switch *ds, int port,
+						u16 vid, u16 flags)
 {
 	int upstream = dsa_upstream_port(ds, port);
 	int rx_vid_of = ds->num_ports;
@@ -299,7 +347,7 @@ int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
 	/* @vid wants to be a pvid of @port, but is not equal to its rx_vid */
 	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
 	    vid != dsa_8021q_rx_vid(ds, port))
-		return -EPERM;
+		return DSA_8021Q_WRONG_PVID;
 
 	for (other_port = 0; other_port < ds->num_ports; other_port++) {
 		if (!dsa_is_user_port(ds, other_port))
@@ -318,15 +366,15 @@ int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
 	if (tx_vid_of != ds->num_ports) {
 		if (tx_vid_of == port) {
 			if (flags != BRIDGE_VLAN_INFO_UNTAGGED)
-				return -EPERM;
+				return DSA_8021Q_TX_VLAN_WRONG_FLAGS;
 			/* Fall through on proper flags */
 		} else if (port == upstream) {
 			if (flags != 0)
-				return -EPERM;
+				return DSA_8021Q_TX_VLAN_WRONG_FLAGS;
 			/* Fall through on proper flags */
 		} else {
 			/* Trying to configure on other port */
-			return -EPERM;
+			return DSA_8021Q_TX_VLAN_WRONG_PORT;
 		}
 	}
 
@@ -335,17 +383,17 @@ int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
 		if (rx_vid_of == port) {
 			if (flags != (BRIDGE_VLAN_INFO_UNTAGGED |
 				      BRIDGE_VLAN_INFO_PVID))
-				return -EPERM;
+				return DSA_8021Q_RX_VLAN_WRONG_FLAGS;
 			/* Fall through on proper flags */
 		} else if (port == upstream) {
 			if (flags != 0)
-				return -EPERM;
+				return DSA_8021Q_RX_VLAN_WRONG_FLAGS;
 			/* Fall through on proper flags */
 		} else if (flags != BRIDGE_VLAN_INFO_UNTAGGED) {
 			/* Trying to configure on other port, but with
 			 * invalid flags.
 			 */
-			return -EPERM;
+			return DSA_8021Q_RX_VLAN_WRONG_FLAGS;
 		}
 	}
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 72d76743c272..b47c38cd5fcc 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -113,7 +113,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 		return sja1105_defer_xmit(dp->priv, skb);
 
 	if (dsa_port_is_vlan_filtering(dp))
-		tpid = ETH_P_8021Q;
+		tpid = ETH_P_8021AD;
 	else
 		tpid = ETH_P_SJA1105;
 
@@ -242,6 +242,20 @@ static struct sk_buff
 	return skb;
 }
 
+static void sja1105_decode_subvlan(struct sk_buff *skb, u16 subvlan)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct sja1105_port *sp = dp->priv;
+	u16 vid = sp->subvlan_map[subvlan];
+	u16 vlan_tci;
+
+	if (vid == VLAN_N_VID)
+		return;
+
+	vlan_tci = (skb->priority << VLAN_PRIO_SHIFT) | vid;
+	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
@@ -251,6 +265,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
+	u16 subvlan = 0;
 	bool is_tagged;
 	bool is_meta;
 
@@ -274,6 +289,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+		subvlan = dsa_8021q_rx_subvlan(vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -298,6 +314,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	if (subvlan)
+		sja1105_decode_subvlan(skb, subvlan);
+
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
-- 
2.17.1


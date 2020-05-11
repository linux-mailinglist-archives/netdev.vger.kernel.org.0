Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68261CDC1E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgEKNyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730383AbgEKNyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:54:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1719C061A0C;
        Mon, 11 May 2020 06:54:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f134so5964444wmf.1;
        Mon, 11 May 2020 06:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=srjfuCRQdbfgjEZc1mUEhDYF9mErnn33WtAhRwCFfkU=;
        b=rO2tJLhYLGR5ZmrNq65rgeYrIt0wTcnPlpRhJjL757Tc1L5GV9abgwmlETYcyQq+6D
         tCCpHQLsLx9h8VfpewR1i/xGghesMfpe+aKvViRWy2tCKdMwu3g+GT0kKDRYLBmXMhZi
         gdE00Z0bhQAEhCcWUAFtHPKgtRwXOa+/8tFEI3kGOtLWvTOSoTjbyq+HTzFTFspPtfHV
         rW6jFFT6MB6PNaFOK6F46x5Eu/iPWqU13piARwDLgHk0DzuYBiDYWh/FS79ixDox7nH4
         V1VdOdmxoLW9mc6HepH5an6w9opEItYLEVftzEdWQpb/WZ0heABUahGRCYmHmq3NR8gS
         i7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=srjfuCRQdbfgjEZc1mUEhDYF9mErnn33WtAhRwCFfkU=;
        b=cUTpxIWMno40VF7hVmRvMwxSg496GKTPYygk3vaLc29wJNhE/YBEAgDMYCDmv0jH7b
         nlcse/5RQSSP898Y4rlc8IS04JzSZajDIqCbVpu1fOTDFhfbkAXKFmp8obNGUtruASqW
         OW/F+S317GqQvD+L4cv2KL+LU/SPkEisVatPRJ1X9MHmelDk7b/DwzSt1WqM5FpuP0so
         YAbNpN3LEPQx/Lk/nsou7kiT84e09DxEYS9nUxTeqT9B99iPMYpsoBgMElIjWb3vCI9C
         VPPwoClGbW3b02vP3SQ1Xrfed1D6uES0dTgwKWqno66ZN8lkI+q/d8i53zwqO16nEimr
         iPiw==
X-Gm-Message-State: AGi0PuZZeai3ygOADI09tQ1HDYOadeVz+vnW0XqLW77zas0VZ3qK1PgL
        uIrp9I1ANqRtECl88Vqhalg=
X-Google-Smtp-Source: APiQypLClTR1WpqGZXvzVNeWY1ZxSi+r8FviC3wb5NLNyJblkM3KYUw8dCO4/6JJbF4LH69um9AzPg==
X-Received: by 2002:a1c:b4d4:: with SMTP id d203mr22496033wmf.188.1589205242228;
        Mon, 11 May 2020 06:54:02 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:54:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 14/15] net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs
Date:   Mon, 11 May 2020 16:53:37 +0300
Message-Id: <20200511135338.20263-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Expand the delta commit procedure for VLANs with additional logic for
treating bridge_vlans in the newly introduced operating mode,
SJA1105_VLAN_BEST_EFFORT.

For every bridge VLAN on every user port, a sub-VLAN index is calculated
and retagging rules are installed towards a dsa_8021q rx_vid that
encodes that sub-VLAN index. This way, the tagger can identify the
original VLANs.

Extra care is taken for VLANs to still work as intended in cross-chip
scenarios. Retagging may have unintended consequences for these because
a sub-VLAN encoding that works for the CPU does not make any sense for a
front-panel port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
 - Only do anything in sja1105_build_subvlans and in
   sja1105_build_crosschip_subvlans when operating in
   SJA1105_VLAN_BEST_EFFORT state. This avoids installing VLAN retagging
   rules in unaware mode, which would cost us a penalty in terms of
   usable frame memory.

 drivers/net/dsa/sja1105/sja1105_main.c | 412 ++++++++++++++++++++++++-
 1 file changed, 409 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 99b453d0d205..b398b1b4ad4e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1869,6 +1869,57 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_SJA1105;
 }
 
+static int sja1105_find_free_subvlan(u16 *subvlan_map, bool pvid)
+{
+	int subvlan;
+
+	if (pvid)
+		return 0;
+
+	for (subvlan = 1; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		if (subvlan_map[subvlan] == VLAN_N_VID)
+			return subvlan;
+
+	return -1;
+}
+
+static int sja1105_find_subvlan(u16 *subvlan_map, u16 vid)
+{
+	int subvlan;
+
+	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		if (subvlan_map[subvlan] == vid)
+			return subvlan;
+
+	return -1;
+}
+
+static int sja1105_find_committed_subvlan(struct sja1105_private *priv,
+					  int port, u16 vid)
+{
+	struct sja1105_port *sp = &priv->ports[port];
+
+	return sja1105_find_subvlan(sp->subvlan_map, vid);
+}
+
+static void sja1105_init_subvlan_map(u16 *subvlan_map)
+{
+	int subvlan;
+
+	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		subvlan_map[subvlan] = VLAN_N_VID;
+}
+
+static void sja1105_commit_subvlan_map(struct sja1105_private *priv, int port,
+				       u16 *subvlan_map)
+{
+	struct sja1105_port *sp = &priv->ports[port];
+	int subvlan;
+
+	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+		sp->subvlan_map[subvlan] = subvlan_map[subvlan];
+}
+
 static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 {
 	struct sja1105_vlan_lookup_entry *vlan;
@@ -1885,9 +1936,29 @@ static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 	return -1;
 }
 
+static int
+sja1105_find_retagging_entry(struct sja1105_retagging_entry *retagging,
+			     int count, int from_port, u16 from_vid,
+			     u16 to_vid)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		if (retagging[i].ing_port == BIT(from_port) &&
+		    retagging[i].vlan_ing == from_vid &&
+		    retagging[i].vlan_egr == to_vid)
+			return i;
+
+	/* Return an invalid entry index if not found */
+	return -1;
+}
+
 static int sja1105_commit_vlans(struct sja1105_private *priv,
-				struct sja1105_vlan_lookup_entry *new_vlan)
+				struct sja1105_vlan_lookup_entry *new_vlan,
+				struct sja1105_retagging_entry *new_retagging,
+				int num_retagging)
 {
+	struct sja1105_retagging_entry *retagging;
 	struct sja1105_vlan_lookup_entry *vlan;
 	struct sja1105_table *table;
 	int num_vlans = 0;
@@ -1947,9 +2018,50 @@ static int sja1105_commit_vlans(struct sja1105_private *priv,
 		vlan[k++] = new_vlan[i];
 	}
 
+	/* VLAN Retagging Table */
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];
+	retagging = table->entries;
+
+	for (i = 0; i < table->entry_count; i++) {
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
+						  i, &retagging[i], false);
+		if (rc)
+			return rc;
+	}
+
+	if (table->entry_count)
+		kfree(table->entries);
+
+	table->entries = kcalloc(num_retagging, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = num_retagging;
+	retagging = table->entries;
+
+	for (i = 0; i < num_retagging; i++) {
+		retagging[i] = new_retagging[i];
+
+		/* Update entry */
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_RETAGGING,
+						  i, &retagging[i], true);
+		if (rc < 0)
+			return rc;
+	}
+
 	return 0;
 }
 
+struct sja1105_crosschip_vlan {
+	struct list_head list;
+	u16 vid;
+	bool untagged;
+	int port;
+	int other_port;
+	struct dsa_switch *other_ds;
+};
+
 struct sja1105_crosschip_switch {
 	struct list_head list;
 	struct dsa_switch *other_ds;
@@ -2021,6 +2133,265 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 	return 0;
 }
 
+static int sja1105_build_subvlans(struct sja1105_private *priv,
+				  u16 subvlan_map[][DSA_8021Q_N_SUBVLAN],
+				  struct sja1105_vlan_lookup_entry *new_vlan,
+				  struct sja1105_retagging_entry *new_retagging,
+				  int *num_retagging)
+{
+	struct sja1105_bridge_vlan *v;
+	int k = *num_retagging;
+
+	if (priv->vlan_state != SJA1105_VLAN_BEST_EFFORT)
+		return 0;
+
+	list_for_each_entry(v, &priv->bridge_vlans, list) {
+		int upstream = dsa_upstream_port(priv->ds, v->port);
+		int match, subvlan;
+		u16 rx_vid;
+
+		/* Only sub-VLANs on user ports need to be applied.
+		 * Bridge VLANs also include VLANs added automatically
+		 * by DSA on the CPU port.
+		 */
+		if (!dsa_is_user_port(priv->ds, v->port))
+			continue;
+
+		subvlan = sja1105_find_subvlan(subvlan_map[v->port],
+					       v->vid);
+		if (subvlan < 0) {
+			subvlan = sja1105_find_free_subvlan(subvlan_map[v->port],
+							    v->pvid);
+			if (subvlan < 0) {
+				dev_err(priv->ds->dev, "No more free subvlans\n");
+				return -ENOSPC;
+			}
+		}
+
+		rx_vid = dsa_8021q_rx_vid_subvlan(priv->ds, v->port, subvlan);
+
+		/* @v->vid on @v->port needs to be retagged to @rx_vid
+		 * on @upstream. Assume @v->vid on @v->port and on
+		 * @upstream was already configured by the previous
+		 * iteration over bridge_vlans.
+		 */
+		match = rx_vid;
+		new_vlan[match].vlanid = rx_vid;
+		new_vlan[match].vmemb_port |= BIT(v->port);
+		new_vlan[match].vmemb_port |= BIT(upstream);
+		new_vlan[match].vlan_bc |= BIT(v->port);
+		new_vlan[match].vlan_bc |= BIT(upstream);
+		/* The "untagged" flag is set the same as for the
+		 * original VLAN
+		 */
+		if (!v->untagged)
+			new_vlan[match].tag_port |= BIT(v->port);
+		/* But it's always tagged towards the CPU */
+		new_vlan[match].tag_port |= BIT(upstream);
+
+		/* The Retagging Table generates packet *clones* with
+		 * the new VLAN. This is a very odd hardware quirk
+		 * which we need to suppress by dropping the original
+		 * packet.
+		 * Deny egress of the original VLAN towards the CPU
+		 * port. This will force the switch to drop it, and
+		 * we'll see only the retagged packets.
+		 */
+		match = v->vid;
+		new_vlan[match].vlan_bc &= ~BIT(upstream);
+
+		/* And the retagging itself */
+		new_retagging[k].vlan_ing = v->vid;
+		new_retagging[k].vlan_egr = rx_vid;
+		new_retagging[k].ing_port = BIT(v->port);
+		new_retagging[k].egr_port = BIT(upstream);
+		if (k++ == SJA1105_MAX_RETAGGING_COUNT) {
+			dev_err(priv->ds->dev, "No more retagging rules\n");
+			return -ENOSPC;
+		}
+
+		subvlan_map[v->port][subvlan] = v->vid;
+	}
+
+	*num_retagging = k;
+
+	return 0;
+}
+
+/* Sadly, in crosschip scenarios where the CPU port is also the link to another
+ * switch, we should retag backwards (the dsa_8021q vid to the original vid) on
+ * the CPU port of neighbour switches.
+ */
+static int
+sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
+				 struct sja1105_vlan_lookup_entry *new_vlan,
+				 struct sja1105_retagging_entry *new_retagging,
+				 int *num_retagging)
+{
+	struct sja1105_crosschip_vlan *tmp, *pos;
+	struct dsa_8021q_crosschip_link *c;
+	struct sja1105_bridge_vlan *v, *w;
+	struct list_head crosschip_vlans;
+	int k = *num_retagging;
+	int rc = 0;
+
+	if (priv->vlan_state != SJA1105_VLAN_BEST_EFFORT)
+		return 0;
+
+	INIT_LIST_HEAD(&crosschip_vlans);
+
+	list_for_each_entry(c, &priv->crosschip_links, list) {
+		struct sja1105_private *other_priv = c->other_ds->priv;
+
+		if (other_priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+			continue;
+
+		/* Crosschip links are also added to the CPU ports.
+		 * Ignore those.
+		 */
+		if (!dsa_is_user_port(priv->ds, c->port))
+			continue;
+		if (!dsa_is_user_port(c->other_ds, c->other_port))
+			continue;
+
+		/* Search for VLANs on the remote port */
+		list_for_each_entry(v, &other_priv->bridge_vlans, list) {
+			bool already_added = false;
+			bool we_have_it = false;
+
+			if (v->port != c->other_port)
+				continue;
+
+			/* If @v is a pvid on @other_ds, it does not need
+			 * re-retagging, because its SVL field is 0 and we
+			 * already allow that, via the dsa_8021q crosschip
+			 * links.
+			 */
+			if (v->pvid)
+				continue;
+
+			/* Search for the VLAN on our local port */
+			list_for_each_entry(w, &priv->bridge_vlans, list) {
+				if (w->port == c->port && w->vid == v->vid) {
+					we_have_it = true;
+					break;
+				}
+			}
+
+			if (!we_have_it)
+				continue;
+
+			list_for_each_entry(tmp, &crosschip_vlans, list) {
+				if (tmp->vid == v->vid &&
+				    tmp->untagged == v->untagged &&
+				    tmp->port == c->port &&
+				    tmp->other_port == v->port &&
+				    tmp->other_ds == c->other_ds) {
+					already_added = true;
+					break;
+				}
+			}
+
+			if (already_added)
+				continue;
+
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+			if (!tmp) {
+				dev_err(priv->ds->dev, "Failed to allocate memory\n");
+				rc = -ENOMEM;
+				goto out;
+			}
+			tmp->vid = v->vid;
+			tmp->port = c->port;
+			tmp->other_port = v->port;
+			tmp->other_ds = c->other_ds;
+			tmp->untagged = v->untagged;
+			list_add(&tmp->list, &crosschip_vlans);
+		}
+	}
+
+	list_for_each_entry(tmp, &crosschip_vlans, list) {
+		struct sja1105_private *other_priv = tmp->other_ds->priv;
+		int upstream = dsa_upstream_port(priv->ds, tmp->port);
+		int match, subvlan;
+		u16 rx_vid;
+
+		subvlan = sja1105_find_committed_subvlan(other_priv,
+							 tmp->other_port,
+							 tmp->vid);
+		/* If this happens, it's a bug. The neighbour switch does not
+		 * have a subvlan for tmp->vid on tmp->other_port, but it
+		 * should, since we already checked for its vlan_state.
+		 */
+		if (WARN_ON(subvlan < 0)) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		rx_vid = dsa_8021q_rx_vid_subvlan(tmp->other_ds,
+						  tmp->other_port,
+						  subvlan);
+
+		/* The @rx_vid retagged from @tmp->vid on
+		 * {@tmp->other_ds, @tmp->other_port} needs to be
+		 * re-retagged to @tmp->vid on the way back to us.
+		 *
+		 * Assume the original @tmp->vid is already configured
+		 * on this local switch, otherwise we wouldn't be
+		 * retagging its subvlan on the other switch in the
+		 * first place. We just need to add a reverse retagging
+		 * rule for @rx_vid and install @rx_vid on our ports.
+		 */
+		match = rx_vid;
+		new_vlan[match].vlanid = rx_vid;
+		new_vlan[match].vmemb_port |= BIT(tmp->port);
+		new_vlan[match].vmemb_port |= BIT(upstream);
+		/* The "untagged" flag is set the same as for the
+		 * original VLAN. And towards the CPU, it doesn't
+		 * really matter, because @rx_vid will only receive
+		 * traffic on that port. For consistency with other dsa_8021q
+		 * VLANs, we'll keep the CPU port tagged.
+		 */
+		if (!tmp->untagged)
+			new_vlan[match].tag_port |= BIT(tmp->port);
+		new_vlan[match].tag_port |= BIT(upstream);
+		/* Deny egress of @rx_vid towards our front-panel port.
+		 * This will force the switch to drop it, and we'll see
+		 * only the re-retagged packets (having the original,
+		 * pre-initial-retagging, VLAN @tmp->vid).
+		 */
+		new_vlan[match].vlan_bc &= ~BIT(tmp->port);
+
+		/* On reverse retagging, the same ingress VLAN goes to multiple
+		 * ports. So we have an opportunity to create composite rules
+		 * to not waste the limited space in the retagging table.
+		 */
+		k = sja1105_find_retagging_entry(new_retagging, *num_retagging,
+						 upstream, rx_vid, tmp->vid);
+		if (k < 0) {
+			if (*num_retagging == SJA1105_MAX_RETAGGING_COUNT) {
+				dev_err(priv->ds->dev, "No more retagging rules\n");
+				rc = -ENOSPC;
+				goto out;
+			}
+			k = (*num_retagging)++;
+		}
+		/* And the retagging itself */
+		new_retagging[k].vlan_ing = rx_vid;
+		new_retagging[k].vlan_egr = tmp->vid;
+		new_retagging[k].ing_port = BIT(upstream);
+		new_retagging[k].egr_port |= BIT(tmp->port);
+	}
+
+out:
+	list_for_each_entry_safe(tmp, pos, &crosschip_vlans, list) {
+		list_del(&tmp->list);
+		kfree(tmp);
+	}
+
+	return rc;
+}
+
 static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify);
 
 static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
@@ -2074,10 +2445,12 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 
 static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 {
+	u16 subvlan_map[SJA1105_NUM_PORTS][DSA_8021Q_N_SUBVLAN];
+	struct sja1105_retagging_entry *new_retagging;
 	struct sja1105_vlan_lookup_entry *new_vlan;
 	struct sja1105_table *table;
+	int i, num_retagging = 0;
 	int rc;
-	int i;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 	new_vlan = kcalloc(VLAN_N_VID,
@@ -2085,9 +2458,23 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (!new_vlan)
 		return -ENOMEM;
 
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+	new_retagging = kcalloc(SJA1105_MAX_RETAGGING_COUNT,
+				table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!new_retagging) {
+		kfree(new_vlan);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < VLAN_N_VID; i++)
 		new_vlan[i].vlanid = VLAN_N_VID;
 
+	for (i = 0; i < SJA1105_MAX_RETAGGING_COUNT; i++)
+		new_retagging[i].vlan_ing = VLAN_N_VID;
+
+	for (i = 0; i < priv->ds->num_ports; i++)
+		sja1105_init_subvlan_map(subvlan_map[i]);
+
 	/* Bridge VLANs */
 	rc = sja1105_build_bridge_vlans(priv, new_vlan);
 	if (rc)
@@ -2102,7 +2489,22 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (rc)
 		goto out;
 
-	rc = sja1105_commit_vlans(priv, new_vlan);
+	/* Private VLANs necessary for dsa_8021q operation, which we need to
+	 * determine on our own:
+	 * - Sub-VLANs
+	 * - Sub-VLANs of crosschip switches
+	 */
+	rc = sja1105_build_subvlans(priv, subvlan_map, new_vlan, new_retagging,
+				    &num_retagging);
+	if (rc)
+		goto out;
+
+	rc = sja1105_build_crosschip_subvlans(priv, new_vlan, new_retagging,
+					      &num_retagging);
+	if (rc)
+		goto out;
+
+	rc = sja1105_commit_vlans(priv, new_vlan, new_retagging, num_retagging);
 	if (rc)
 		goto out;
 
@@ -2110,6 +2512,9 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (rc)
 		goto out;
 
+	for (i = 0; i < priv->ds->num_ports; i++)
+		sja1105_commit_subvlan_map(priv, i, subvlan_map[i]);
+
 	if (notify) {
 		rc = sja1105_notify_crosschip_switches(priv);
 		if (rc)
@@ -2118,6 +2523,7 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 
 out:
 	kfree(new_vlan);
+	kfree(new_retagging);
 
 	return rc;
 }
-- 
2.17.1


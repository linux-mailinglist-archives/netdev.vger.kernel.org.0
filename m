Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A1B1234E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEBUZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37784 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfEBUYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id k23so5131879wrd.4;
        Thu, 02 May 2019 13:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zCq4mqZ+zvlqQwo9H/hm32hrej76/HfKl3+FYhQFGMQ=;
        b=XXpufF2LhTEgOQyk4HF5AJ932cVTpyHDURn2WctgK56B2T8F+q0WQWYWN1jZvV1gIM
         Dxk0zXa0WdfyMu/LvcP41DwPEXPxPTKmzJA9j0NVY+6fhDFZuYTOnWKPEpk1yaslhXqW
         wlUYHU2C+6jCXO2cEDE6bhWkFKnktxx6Kft5I+qk5p8CfnThAVw9bK1ZTF7LwDIffERp
         mJfzqp2fwIyQnxpbTRQZMGxMgb/3vLNTNw4JBvlItLW4mG47NQH7Qd/gT4qOgqcRSWpg
         Qjzy7ZhSN46j4k1vFoKOjOJ4etlZlhDAUKv/UKbE7Ozu+UrqVFVDaAB0Pc5AOOEktl9v
         AD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zCq4mqZ+zvlqQwo9H/hm32hrej76/HfKl3+FYhQFGMQ=;
        b=LyjSPyeazrlu/hvH43e6rlHVJzKNKEmrTtP2WPiN/M7YeOombyP63JesBZj+72QLQ9
         IfNBJRV4elRyNG7JbWLpA2lgOgtECn3S1IStElwv634c2E4Iu3XHfWirIEpsZwHlSgRT
         7d0U8I09lqDyFaP+Bfaz+PGTI0KDg9tqKoxayAzcGoSb1zfD1iAZwupKLheJgvjqeOM/
         YKgsv/elOQbgtg9a+lYgp39neVQGsCLgKA9sbClfOog/P2g18YXbi4nQYXqK0lVexZRj
         NjExEO1oRg5U9SgRaZ4NNy7680TyYozSImaFzx13Ks0mZs+bwj7tT4EuoOBLJRI3dRol
         QHnw==
X-Gm-Message-State: APjAAAWAiIP5l+Ny/bLTbKxV6PWmowHJmCB3RK1QlH2RXA3F/NRnqH8i
        fCxkew3noOW6xY9jvGksOVI=
X-Google-Smtp-Source: APXvYqzHxAIRnTAZU02Au0E5FbTR0ibTUEdVMUrlqjAR6KYvp1kO8TfJvqhjkmU3GOn87XfQpyWgjg==
X-Received: by 2002:a5d:6a47:: with SMTP id t7mr3480735wrw.307.1556828684033;
        Thu, 02 May 2019 13:24:44 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 06/12] net: dsa: sja1105: Add support for VLAN operations
Date:   Thu,  2 May 2019 23:23:34 +0300
Message-Id: <20190502202340.21054-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN filtering cannot be properly disabled in SJA1105. So in order to
emulate the "no VLAN awareness" behavior (not dropping traffic that is
tagged with a VID that isn't configured on the port), we need to hack
another switch feature: programmable TPID (which is 0x8100 for 802.1Q).
We are reprogramming the TPID to a bogus value which leaves the switch
thinking that all traffic is untagged, and therefore accepts it.

Under a vlan_filtering bridge, the proper TPID of ETH_P_8021Q is
installed again, and the switch starts identifying 802.1Q-tagged
traffic.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
Changed back to ETH_P_DSA_8021Q (hidden behind the ETH_P_SJA1105 macro
definition).
Simplified handling of .port_vlan_filtering due to the recent extra
patches on DSA core.

Changes in v3:
Changed back to ETH_P_EDSA.

Changes in v2:
Changed the TPID from ETH_P_EDSA (0xDADA) to a newly introduced one:
ETH_P_DSA_8021Q (0xDADB).

 drivers/net/dsa/sja1105/sja1105_main.c        | 248 +++++++++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   |  38 +++
 .../net/dsa/sja1105/sja1105_static_config.h   |   3 +
 include/linux/dsa/sja1105.h                   |   4 +
 4 files changed, 291 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d27b9c178cba..f7b1525b388a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -251,6 +251,13 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
 	/* The static VLAN table will only contain the initial pvid of 0.
+	 * All other VLANs are to be configured through dynamic entries,
+	 * and kept in the static configuration table as backing memory.
+	 * The pvid of 0 is sufficient to pass traffic while the ports are
+	 * standalone and when vlan_filtering is disabled. When filtering
+	 * gets enabled, the switchdev core sets up the VLAN ID 1 and sets
+	 * it as the new pvid. Actually 'pvid 1' still comes up in 'bridge
+	 * vlan' even when vlan_filtering is off, but it has no effect.
 	 */
 	if (table->entry_count) {
 		kfree(table->entries);
@@ -391,8 +398,11 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.vlmask = 0,
 		/* Only update correctionField for 1-step PTP (L2 transport) */
 		.ignore2stf = 0,
-		.tpid = ETH_P_8021Q,
-		.tpid2 = ETH_P_8021Q,
+		/* Forcefully disable VLAN filtering by telling
+		 * the switch that VLAN has a different EtherType.
+		 */
+		.tpid = ETH_P_SJA1105,
+		.tpid2 = ETH_P_SJA1105,
 	};
 	struct sja1105_table *table;
 	int i;
@@ -954,12 +964,233 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 	sja1105_bridge_member(ds, port, br, false);
 }
 
+/* For situations where we need to change a setting at runtime that is only
+ * available through the static configuration, resetting the switch in order
+ * to upload the new static config is unavoidable. Back up the settings we
+ * modify at runtime (currently only MAC) and restore them after uploading,
+ * such that this operation is relatively seamless.
+ */
+static int sja1105_static_config_reload(struct sja1105_private *priv)
+{
+	struct sja1105_mac_config_entry *mac;
+	int speed_mbps[SJA1105_NUM_PORTS];
+	int rc, i;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	/* Back up settings changed by sja1105_adjust_port_config and
+	 * and restore their defaults.
+	 */
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		speed_mbps[i] = sja1105_speed[mac[i].speed];
+		mac[i].speed = SJA1105_SPEED_AUTO;
+	}
+
+	/* Reset switch and send updated static configuration */
+	rc = sja1105_static_config_upload(priv);
+	if (rc < 0)
+		goto out;
+
+	/* Configure the CGU (PLLs) for MII and RMII PHYs.
+	 * For these interfaces there is no dynamic configuration
+	 * needed, since PLLs have same settings at all speeds.
+	 */
+	rc = sja1105_clocking_setup(priv);
+	if (rc < 0)
+		goto out;
+
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		bool enabled = (speed_mbps[i] != 0);
+
+		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i],
+						enabled);
+		if (rc < 0)
+			goto out;
+	}
+out:
+	return rc;
+}
+
+/* The TPID setting belongs to the General Parameters table,
+ * which can only be partially reconfigured at runtime (and not the TPID).
+ * So a switch reset is required.
+ */
+static int sja1105_change_tpid(struct sja1105_private *priv,
+			       u16 tpid, u16 tpid2)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	general_params->tpid = tpid;
+	general_params->tpid2 = tpid2;
+	return sja1105_static_config_reload(priv);
+}
+
+static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
+{
+	struct sja1105_mac_config_entry *mac;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	mac[port].vlanid = pvid;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					   &mac[port], true);
+}
+
+static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	int count, i;
+
+	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
+	count = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entry_count;
+
+	for (i = 0; i < count; i++)
+		if (vlan[i].vlanid == vid)
+			return i;
+
+	/* Return an invalid entry index if not found */
+	return -1;
+}
+
+static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
+			      bool enabled, bool untagged)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	struct sja1105_table *table;
+	bool keep = true;
+	int match, rc;
+
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+
+	match = sja1105_is_vlan_configured(priv, vid);
+	if (match < 0) {
+		/* Can't delete a missing entry. */
+		if (!enabled)
+			return 0;
+		rc = sja1105_table_resize(table, table->entry_count + 1);
+		if (rc)
+			return rc;
+		match = table->entry_count - 1;
+	}
+	/* Assign pointer after the resize (it's new memory) */
+	vlan = table->entries;
+	vlan[match].vlanid = vid;
+	if (enabled) {
+		vlan[match].vlan_bc |= BIT(port);
+		vlan[match].vmemb_port |= BIT(port);
+	} else {
+		vlan[match].vlan_bc &= ~BIT(port);
+		vlan[match].vmemb_port &= ~BIT(port);
+	}
+	/* Also unset tag_port if removing this VLAN was requested,
+	 * just so we don't have a confusing bitmap (no practical purpose).
+	 */
+	if (untagged || !enabled)
+		vlan[match].tag_port &= ~BIT(port);
+	else
+		vlan[match].tag_port |= BIT(port);
+	/* If there's no port left as member of this VLAN,
+	 * it's time for it to go.
+	 */
+	if (!vlan[match].vmemb_port)
+		keep = false;
+
+	dev_dbg(priv->ds->dev,
+		"%s: port %d, vid %llu, broadcast domain 0x%llx, "
+		"port members 0x%llx, tagged ports 0x%llx, keep %d\n",
+		__func__, port, vlan[match].vlanid, vlan[match].vlan_bc,
+		vlan[match].vmemb_port, vlan[match].tag_port, keep);
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_VLAN_LOOKUP, vid,
+					  &vlan[match], keep);
+	if (rc < 0)
+		return rc;
+
+	if (!keep)
+		return sja1105_table_delete_entry(table, match);
+
+	return 0;
+}
+
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port)
 {
 	return DSA_TAG_PROTO_NONE;
 }
 
+/* This callback needs to be present */
+static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_vlan *vlan)
+{
+	return 0;
+}
+
+static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	if (enabled)
+		/* Enable VLAN filtering. */
+		rc = sja1105_change_tpid(priv, ETH_P_8021Q, ETH_P_8021AD);
+	else
+		/* Disable VLAN filtering. */
+		rc = sja1105_change_tpid(priv, ETH_P_SJA1105, ETH_P_SJA1105);
+	if (rc)
+		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
+
+	return rc;
+}
+
+static void sja1105_vlan_add(struct dsa_switch *ds, int port,
+			     const struct switchdev_obj_port_vlan *vlan)
+{
+	struct sja1105_private *priv = ds->priv;
+	u16 vid;
+	int rc;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		rc = sja1105_vlan_apply(priv, port, vid, true, vlan->flags &
+					BRIDGE_VLAN_INFO_UNTAGGED);
+		if (rc < 0) {
+			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
+				vid, port, rc);
+			return;
+		}
+		if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+			rc = sja1105_pvid_apply(ds->priv, port, vid);
+			if (rc < 0) {
+				dev_err(ds->dev, "Failed to set pvid %d on port %d: %d\n",
+					vid, port, rc);
+				return;
+			}
+		}
+	}
+}
+
+static int sja1105_vlan_del(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct sja1105_private *priv = ds->priv;
+	u16 vid;
+	int rc;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		rc = sja1105_vlan_apply(priv, port, vid, false, vlan->flags &
+					BRIDGE_VLAN_INFO_UNTAGGED);
+		if (rc < 0) {
+			dev_err(ds->dev, "Failed to remove VLAN %d from port %d: %d\n",
+				vid, port, rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -1005,6 +1236,15 @@ static int sja1105_setup(struct dsa_switch *ds)
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
 		return rc;
 	}
+	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
+	 * The only thing we can do to disable it is lie about what the 802.1Q
+	 * EtherType is.
+	 * So it will still try to apply VLAN filtering, but all ingress
+	 * traffic (except frames received with EtherType of ETH_P_SJA1105)
+	 * will be internally tagged with a distorted VLAN header where the
+	 * TPID is ETH_P_SJA1105, and the VLAN ID is the port pvid.
+	 */
+	ds->vlan_filtering_is_global = true;
 
 	return 0;
 }
@@ -1018,6 +1258,10 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_fdb_del		= sja1105_fdb_del,
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
+	.port_vlan_prepare	= sja1105_vlan_prepare,
+	.port_vlan_filtering	= sja1105_vlan_filtering,
+	.port_vlan_add		= sja1105_vlan_add,
+	.port_vlan_del		= sja1105_vlan_del,
 	.port_mdb_prepare	= sja1105_mdb_prepare,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 84ee623c6336..b3c992b0abb0 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -947,3 +947,41 @@ void sja1105_static_config_free(struct sja1105_static_config *config)
 		}
 	}
 }
+
+int sja1105_table_delete_entry(struct sja1105_table *table, int i)
+{
+	size_t entry_size = table->ops->unpacked_entry_size;
+	u8 *entries = table->entries;
+
+	if (i > table->entry_count)
+		return -ERANGE;
+
+	memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
+		(table->entry_count - i) * entry_size);
+
+	table->entry_count--;
+
+	return 0;
+}
+
+/* No pointers to table->entries should be kept when this is called. */
+int sja1105_table_resize(struct sja1105_table *table, size_t new_count)
+{
+	size_t entry_size = table->ops->unpacked_entry_size;
+	void *new_entries, *old_entries = table->entries;
+
+	if (new_count > table->ops->max_entry_count)
+		return -ERANGE;
+
+	new_entries = kcalloc(new_count, entry_size, GFP_KERNEL);
+	if (!new_entries)
+		return -ENOMEM;
+
+	memcpy(new_entries, old_entries, min(new_count, table->entry_count) *
+		entry_size);
+
+	table->entries = new_entries;
+	table->entry_count = new_count;
+	kfree(old_entries);
+	return 0;
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 7b0a02fe3147..069ca8fd059c 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -240,6 +240,9 @@ int sja1105_static_config_init(struct sja1105_static_config *config,
 			       u64 device_id);
 void sja1105_static_config_free(struct sja1105_static_config *config);
 
+int sja1105_table_delete_entry(struct sja1105_table *table, int i);
+int sja1105_table_resize(struct sja1105_table *table, size_t new_count);
+
 u32 sja1105_crc32(const void *buf, size_t len);
 
 void sja1105_pack(void *buf, const u64 *val, int start, int end, size_t len);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 30559d1d0e1b..abf3977e34fd 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -7,6 +7,10 @@
 #ifndef _NET_DSA_SJA1105_H
 #define _NET_DSA_SJA1105_H
 
+#include <linux/etherdevice.h>
+
+#define ETH_P_SJA1105				ETH_P_DSA_8021Q
+
 /* The switch can only be convinced to stay in unmanaged mode and not trap any
  * link-local traffic by actually telling it to filter frames sent at the
  * 00:00:00:00:00:00 destination MAC.
-- 
2.17.1


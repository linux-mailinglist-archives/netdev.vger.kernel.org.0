Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1006D1C39B3
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEDMoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728876AbgEDMoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52098C061A41
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so8865795wmg.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1kbuXB6vTsPB0I0gwKSR9cCQxqxWxU9Yl8zRddbnmE=;
        b=kjOWA6Dbvso4hi2U+wUWzvtRlLn4MhQ8LbMJQJPoV3g8yeby9Uj8qP6jpbbClQYiqb
         7R2bnSRzsvX89K9zBgnA+u5wOT0WOjW8nr5oLBr9jwogqe7mnwCj7luZi+/j8IGO5ziD
         EqeXTzZ1iPqfuMkbiZP9n8nhsRjhhtRnUKbN7na6c5Mxmbc/HQri+0WzDqTyIjSn7qi0
         K1+AlyM8t/Ps2fh1Pg9hxUA4tvw4Z+dvpfJVr56XBz5hIv6Ej16O4h/p8aWLyd45jzSQ
         a5dIinFVf4IZFEAG5u/mx5v5B2S57KdFjfY9GuYav61QjCR6VkOuZE1LmGnkjdL3jTPj
         QbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1kbuXB6vTsPB0I0gwKSR9cCQxqxWxU9Yl8zRddbnmE=;
        b=N8tiO5Cu0CLx6Y1IZhRlGbjBzNMYyJ0J26aAM0FvwbEG0jMMtvGGbMLSZN5u1lu68T
         u6oUuJe4seKf4/yaCCw0S3jTfJJjtnQdVTN1zjAOgJkAy26Fy9vveztiyT6OEPoVd7I9
         0cS3dmed1yq46DFAynzE3gYE7J6pKq2atzKedCsO4gi1gTt2W8wKHrGnOB+zTrfI8Mbk
         dtFjzBYwfjVFHedxXjwhZCHh/8thmMoPQZ0c1FbxZs5iweywKJTBEIpTGOag348XPbvo
         YX+kOWa+McAkG4GYoUZ8zl/pZQiOWXyhHhpAQall3p04ZNcueeEcYydG88Ps8Ij0pUln
         Hkng==
X-Gm-Message-State: AGi0PuaEG8VHGLqJGTL57gsv/poZ7zbgiDjYolKPInAXU25Rme2Fpnz+
        hm/LI6wdYkfnXGkARSUandg=
X-Google-Smtp-Source: APiQypKJxcNLApDkAoxEE72cBWcKD8vGwSe6sazehyrTVg9djUkdG5E8SX15f/RjSWcd8G6rIBTeuQ==
X-Received: by 2002:a05:600c:2196:: with SMTP id e22mr14077781wme.105.1588596258909;
        Mon, 04 May 2020 05:44:18 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 3/6] net: dsa: tag_8021q: allow DSA tags and VLAN filtering simultaneously
Date:   Mon,  4 May 2020 15:43:22 +0300
Message-Id: <20200504124325.26758-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are very good reasons to want this, but there are also very good
reasons for not enabling it by default. So a devlink param named
best_effort_vlan_filtering, currently driver-specific and exported only
by sja1105, is used to configure this.

In practice, this is perhaps the way that most users are going to use
the switch in. Best-effort untagged traffic can be bridged with any net
device in the system or terminated locally, and VLAN-tagged streams are
forwarded autonomously in a time-sensitive manner according to their
PCP (they need not transit the CPU). For those cases where the CPU needs
to terminate some VLAN-tagged traffic, the next patch will also address
that, via dsa_8021q sub-VLANs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/sja1105.rst | 21 +++---
 drivers/net/dsa/sja1105/sja1105.h        |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c   | 81 ++++++++++++++++++++++--
 include/linux/dsa/8021q.h                |  7 ++
 include/linux/dsa/sja1105.h              |  2 +
 net/dsa/tag_8021q.c                      | 62 ++++++++++++++++++
 net/dsa/tag_sja1105.c                    | 16 ++---
 7 files changed, 167 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 35d0643f1377..4a8639cba1f3 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -85,15 +85,18 @@ functionality.
 
 The following traffic modes are supported over the switch netdevices:
 
-+--------------------+------------+------------------+------------------+
-|                    | Standalone | Bridged with     | Bridged with     |
-|                    | ports      | vlan_filtering 0 | vlan_filtering 1 |
-+====================+============+==================+==================+
-| Regular traffic    |     Yes    |       Yes        |  No (use master) |
-+--------------------+------------+------------------+------------------+
-| Management traffic |     Yes    |       Yes        |       Yes        |
-| (BPDU, PTP)        |            |                  |                  |
-+--------------------+------------+------------------+------------------+
++-------------+------------+----------------+----------------+----------------------------+
+|             | Standalone |  Bridged with  |  Bridged with  |        Bridged with        |
+|             |    ports   | vlan_filtering | vlan_filtering | best_effort_vlan_filtering |
+|             |            |        0       |        1       |              1             |
++=============+============+================+================+============================+
+|   Regular   |     Yes    |       Yes      |       No       |     Partial (untagged),    |
+|   traffic   |            |                |  (use master)  |    use master for tagged   |
++-------------+------------+----------------+----------------+----------------------------+
+| Management  |     Yes    |       Yes      |      Yes       |             Yes            |
+|  traffic    |            |                |                |                            |
+| (BPDU, PTP) |            |                |                |                            |
++-------------+------------+----------------+----------------+----------------------------+
 
 Switching features
 ==================
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2a21cab0888c..8fedcaa99f3b 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -132,6 +132,7 @@ struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
+	bool best_effort_vlan_filtering;
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8a444e6949fd..edbe5dd4af37 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1901,10 +1901,27 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_SJA1105;
 }
 
-/* This callback needs to be present */
 static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
+	struct sja1105_private *priv = ds->priv;
+	u16 vid;
+	int rc;
+
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)) ||
+	    !priv->best_effort_vlan_filtering)
+		return 0;
+
+	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
+	 * bridge plus tagging), be sure to at least deny alterations to the
+	 * configuration done by dsa_8021q.
+	 */
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		rc = dsa_8021q_vid_validate(ds, port, vid, vlan->flags);
+		if (rc < 0)
+			return rc;
+	}
+
 	return 0;
 }
 
@@ -1918,6 +1935,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
+	bool want_tagging;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -1943,8 +1961,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
+	want_tagging = priv->best_effort_vlan_filtering || !enabled;
+
 	/* VLAN filtering => independent VLAN learning.
-	 * No VLAN filtering => shared VLAN learning.
+	 * No VLAN filtering (or best effort) => shared VLAN learning.
 	 *
 	 * In shared VLAN learning mode, untagged traffic still gets
 	 * pvid-tagged, and the FDB table gets populated with entries
@@ -1963,7 +1983,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !enabled;
+	l2_lookup_params->shared_learn = want_tagging;
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
@@ -1971,11 +1991,24 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	/* Switch port identification based on 802.1Q is only passable
 	 * if we are not under a vlan_filtering bridge. So make sure
-	 * the two configurations are mutually exclusive.
+	 * the two configurations are mutually exclusive (of course, the
+	 * user may know better, i.e. best_effort_vlan_filtering).
 	 */
-	return sja1105_setup_8021q_tagging(ds, !enabled);
+	return sja1105_setup_8021q_tagging(ds, want_tagging);
 }
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct sja1105_private *priv = ds->priv;
+
+	if (dsa_port_is_vlan_filtering(dp) && !priv->best_effort_vlan_filtering)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(sja1105_can_use_vlan_as_tags);
+
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
@@ -2048,9 +2081,35 @@ static int sja1105_hostprio_set(struct sja1105_private *priv, u8 hostprio)
 	return sja1105_static_config_reload(priv, SJA1105_HOSTPRIO);
 }
 
+static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
+						  bool *be_vlan)
+{
+	*be_vlan = priv->best_effort_vlan_filtering;
+
+	return 0;
+}
+
+static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
+						  bool be_vlan)
+{
+	struct dsa_switch *ds = priv->ds;
+	bool vlan_filtering;
+	int rc;
+
+	vlan_filtering = dsa_port_is_vlan_filtering(dsa_to_port(ds, 0));
+	priv->best_effort_vlan_filtering = be_vlan;
+
+	rtnl_lock();
+	rc = sja1105_vlan_filtering(ds, 0, vlan_filtering);
+	rtnl_unlock();
+
+	return rc;
+}
+
 enum sja1105_devlink_param_id {
 	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
+	SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
 };
 
 static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
@@ -2063,6 +2122,10 @@ static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
 	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
 		err = sja1105_hostprio_get(priv, &ctx->val.vu8);
 		break;
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_get(priv,
+							     &ctx->val.vbool);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -2081,6 +2144,10 @@ static int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
 	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
 		err = sja1105_hostprio_set(priv, ctx->val.vu8);
 		break;
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_set(priv,
+							     ctx->val.vbool);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -2093,6 +2160,10 @@ static const struct devlink_param sja1105_devlink_params[] = {
 	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
 				 "hostprio", DEVLINK_PARAM_TYPE_U8,
 				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
+				 "best_effort_vlan_filtering",
+				 DEVLINK_PARAM_TYPE_BOOL,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
 };
 
 static int sja1105_setup_devlink_params(struct dsa_switch *ds)
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index b8daaec0896e..dfbd5b62f67a 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -25,6 +25,8 @@ struct dsa_8021q_crosschip_link {
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 				 bool enabled);
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags);
+
 int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 				   struct dsa_switch *other_ds,
 				   int other_port, bool enabled);
@@ -58,6 +60,11 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 	return 0;
 }
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
+{
+	return 0;
+}
+
 int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 				   struct dsa_switch *other_ds,
 				   int other_port, bool enabled)
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index fa5735c353cd..a609fdbe1355 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -61,4 +61,6 @@ struct sja1105_port {
 	bool hwts_tx_en;
 };
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_port *dp);
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index ff9c5bf64bda..158584153e15 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -289,6 +289,68 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
+{
+	int upstream = dsa_upstream_port(ds, port);
+	int rx_vid_of = ds->num_ports;
+	int tx_vid_of = ds->num_ports;
+	int other_port;
+
+	/* @vid wants to be a pvid of @port, but is not equal to its rx_vid */
+	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
+	    vid != dsa_8021q_rx_vid(ds, port))
+		return -EPERM;
+
+	for (other_port = 0; other_port < ds->num_ports; other_port++) {
+		if (vid == dsa_8021q_rx_vid(ds, other_port)) {
+			rx_vid_of = other_port;
+			break;
+		}
+		if (vid == dsa_8021q_tx_vid(ds, other_port)) {
+			tx_vid_of = other_port;
+			break;
+		}
+	}
+
+	/* @vid is a TX VLAN of the @tx_vid_of port */
+	if (tx_vid_of != ds->num_ports) {
+		if (tx_vid_of == port) {
+			if (flags != BRIDGE_VLAN_INFO_UNTAGGED)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (port == upstream) {
+			if (flags != 0)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else {
+			/* Trying to configure on other port */
+			return -EPERM;
+		}
+	}
+
+	/* @vid is an RX VLAN of the @rx_vid_of port */
+	if (rx_vid_of != ds->num_ports) {
+		if (rx_vid_of == port) {
+			if (flags != (BRIDGE_VLAN_INFO_UNTAGGED |
+				      BRIDGE_VLAN_INFO_PVID))
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (port == upstream) {
+			if (flags != 0)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (flags != BRIDGE_VLAN_INFO_UNTAGGED) {
+			/* Trying to configure on other port, but with
+			 * invalid flags.
+			 */
+			return -EPERM;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_vid_validate);
+
 int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 				   struct dsa_switch *other_ds,
 				   int other_port, bool enabled)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..72d76743c272 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -74,7 +74,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_can_use_vlan_as_tags(skb->dev->dsa_ptr))
 		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
@@ -103,6 +103,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tpid;
 
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
@@ -111,15 +112,12 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	if (unlikely(sja1105_is_link_local(skb)))
 		return sja1105_defer_xmit(dp->priv, skb);
 
-	/* If we are under a vlan_filtering bridge, IP termination on
-	 * switch ports based on 802.1Q tags is simply too brittle to
-	 * be passable. So just defer to the dsa_slave_notag_xmit
-	 * implementation.
-	 */
 	if (dsa_port_is_vlan_filtering(dp))
-		return skb;
+		tpid = ETH_P_8021Q;
+	else
+		tpid = ETH_P_SJA1105;
 
-	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
+	return dsa_8021q_xmit(skb, netdev, tpid,
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
@@ -258,7 +256,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	hdr = eth_hdr(skb);
 	tpid = ntohs(hdr->h_proto);
-	is_tagged = (tpid == ETH_P_SJA1105);
+	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-- 
2.17.1


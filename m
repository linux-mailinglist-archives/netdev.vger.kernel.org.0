Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4D630FFCF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBDWBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhBDWAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:00:47 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B473CC06178B
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:00:06 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id d1so4924845otl.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1ZySffUUeDJM726FBySm8qOwO5Z0SZpmWssweHDns38=;
        b=IwIZmx2aSwowtizqwJZhPX3ZqiQWzalWhYVlxq3vqI9cxtZPd9gWLXVUor3n7d98D/
         IwSTlnldcWn4WZaPyPSuuEs7gWZqIMk7gLlyjO07O3FFcFXf4RmEvC+/upC+D9pqCMvf
         No1jcKVs51tH5d5Pj7ZxvZduNnheiwrOyh/UO0mIjO5VZsNfghts8I/O2yIUGBKljwJz
         WwwrsVy6Vp0hfj7KUEVonIRO1u1w2+ztVbYH7/KZhYoEmda9tT+MWQ+Sh/LTA5golxBO
         O5grZE2dyYTgC+/bQY1mTpUliXSTlZXqHhs1GRKIFhjfwpagXRtuqKOC2Fhelf4A8iQt
         7H2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1ZySffUUeDJM726FBySm8qOwO5Z0SZpmWssweHDns38=;
        b=X6wRn78UJDAgFddgIA83XEZCO5o2arHrmoElDTuQ/k8IGMzsq9/lJYyHu7kYJSQie+
         9nPns8xYtczk4tzrNe0MLq1G6ge7+sp0SRXhW3l4hwvYla6XAhNTtgBfgaTlvem6C08W
         gZ3ZTMaJwrYNtVDhbG4prYlt04n4rxgS/3DPPwtpqXCnomRkNRr7jErFkHddRw73y6je
         DhToV1G9nNSC2FlBSdO5zw+fBMa0bRju3emaAZZ6XvQ+Yu/XAoxgAsnuPKRQ2JkGrv5O
         sIf2K1pRskzspB1R+S6tt4ShZCQO8gDh2G4gbWjwLwWMrXyh1grDou00CTYVff41IKpc
         HJ+A==
X-Gm-Message-State: AOAM533kQdPAWDfzT+KBg8bvmuuSBJUXqdOlbzeNtl+lg+N5g4YJt6Qc
        C8Aug+ify1di9XChlCnKRA==
X-Google-Smtp-Source: ABdhPJzud+cV6ZnfR6BkLcF3pVyM+QFtSPmLq2x74kEgECZgWRbXQ5HgNOTVps+YzHCc1w4tkS+tew==
X-Received: by 2002:a05:6830:1318:: with SMTP id p24mr1099497otq.302.1612476006095;
        Thu, 04 Feb 2021 14:00:06 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y10sm1361395ooy.11.2021.02.04.14.00.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 14:00:04 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
Date:   Thu,  4 Feb 2021 15:59:25 -0600
Message-Id: <20210204215926.64377-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210204215926.64377-1-george.mccollister@gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
tag removal, duplicate generation and forwarding on DSA switches.

Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.

The DSA switch driver should then set netdev feature flags for the
HSR/PRP operation that it offloads.
    NETIF_F_HW_HSR_TAG_INS
    NETIF_F_HW_HSR_TAG_RM
    NETIF_F_HW_HSR_FWD
    NETIF_F_HW_HSR_DUP

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 include/net/dsa.h  | 13 +++++++++++++
 net/dsa/dsa_priv.h | 11 +++++++++++
 net/dsa/port.c     | 34 ++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    | 14 ++++++++++++++
 net/dsa/switch.c   | 24 ++++++++++++++++++++++++
 5 files changed, 96 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 60acb9fca124..84875960b706 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -172,6 +172,10 @@ struct dsa_switch_tree {
 	list_for_each_entry((_dp), &(_dst)->ports, list)	\
 		if ((_dp)->lag_dev == (_lag))
 
+#define dsa_hsr_foreach_port(_dp, _ds, _hsr)			\
+	list_for_each_entry((_dp), &(_ds)->dst->ports, list)	\
+		if ((_dp)->ds == (_ds) && (_dp)->hsr_dev == (_hsr))
+
 static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 					     unsigned int id)
 {
@@ -264,6 +268,7 @@ struct dsa_port {
 	struct phylink_config	pl_config;
 	struct net_device	*lag_dev;
 	bool			lag_tx_enabled;
+	struct net_device	*hsr_dev;
 
 	struct list_head list;
 
@@ -769,6 +774,14 @@ struct dsa_switch_ops {
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
 				  struct net_device *lag);
+
+	/*
+	 * HSR integration
+	 */
+	int	(*port_hsr_join)(struct dsa_switch *ds, int port,
+				 struct net_device *hsr);
+	void	(*port_hsr_leave)(struct dsa_switch *ds, int port,
+				  struct net_device *hsr);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 263593ce94a8..bb41f8bf4f6e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -20,6 +20,8 @@ enum {
 	DSA_NOTIFIER_BRIDGE_LEAVE,
 	DSA_NOTIFIER_FDB_ADD,
 	DSA_NOTIFIER_FDB_DEL,
+	DSA_NOTIFIER_HSR_JOIN,
+	DSA_NOTIFIER_HSR_LEAVE,
 	DSA_NOTIFIER_LAG_CHANGE,
 	DSA_NOTIFIER_LAG_JOIN,
 	DSA_NOTIFIER_LAG_LEAVE,
@@ -100,6 +102,13 @@ struct dsa_switchdev_event_work {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_HSR_* */
+struct dsa_notifier_hsr_info {
+	struct net_device *hsr;
+	int sw_index;
+	int port;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
@@ -183,6 +192,8 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
+void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5e079a61528e..b93bda463026 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -868,3 +868,37 @@ int dsa_port_get_phy_sset_count(struct dsa_port *dp)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
+
+int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
+{
+	struct dsa_notifier_hsr_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.hsr = hsr,
+	};
+	int err;
+
+	dp->hsr_dev = hsr;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_JOIN, &info);
+	if (err)
+		dp->hsr_dev = NULL;
+
+	return err;
+}
+
+void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
+{
+	struct dsa_notifier_hsr_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.hsr = hsr,
+	};
+	int err;
+
+	dp->hsr_dev = NULL;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_LEAVE, &info);
+	if (err)
+		pr_err("DSA: failed to notify DSA_NOTIFIER_HSR_LEAVE\n");
+}
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..11d01276f11d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -17,6 +17,7 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mirred.h>
 #include <linux/if_bridge.h>
+#include <linux/if_hsr.h>
 #include <linux/netpoll.h>
 #include <linux/ptp_classify.h>
 
@@ -1935,6 +1936,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			dsa_port_lag_leave(dp, info->upper_dev);
 			err = NOTIFY_OK;
 		}
+	} else if (is_hsr_master(info->upper_dev)) {
+		if (info->linking) {
+			err = dsa_port_hsr_join(dp, info->upper_dev);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
+			err = notifier_from_errno(err);
+		} else {
+			dsa_port_hsr_leave(dp, info->upper_dev);
+			err = NOTIFY_OK;
+		}
 	}
 
 	return err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5026e4143663..1e0a65b307de 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -166,6 +166,24 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
 }
 
+static int dsa_switch_hsr_join(struct dsa_switch *ds,
+			       struct dsa_notifier_hsr_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_hsr_join)
+		return ds->ops->port_hsr_join(ds, info->port, info->hsr);
+
+	return 0;
+}
+
+static int dsa_switch_hsr_leave(struct dsa_switch *ds,
+				struct dsa_notifier_hsr_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
+		ds->ops->port_hsr_leave(ds, info->port, info->hsr);
+
+	return 0;
+}
+
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
@@ -371,6 +389,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_FDB_DEL:
 		err = dsa_switch_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HSR_JOIN:
+		err = dsa_switch_hsr_join(ds, info);
+		break;
+	case DSA_NOTIFIER_HSR_LEAVE:
+		err = dsa_switch_hsr_leave(ds, info);
+		break;
 	case DSA_NOTIFIER_LAG_CHANGE:
 		err = dsa_switch_lag_change(ds, info);
 		break;
-- 
2.11.0


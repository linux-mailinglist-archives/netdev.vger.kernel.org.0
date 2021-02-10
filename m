Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F8315BDF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhBJBG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbhBJBDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:03:35 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DDC061788
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 17:02:55 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id 100so330489otg.3
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wmCIVOq1NAIlLDqeMnMtQQlsHBH3WlyqDeom4tMXSfU=;
        b=YRERJnA82ZZtIiNjeN/tnA+m6TtGHg8RxJLJhf1j1bnfREfCUvT87nKI9rZFgxWeWW
         KHQh6j0rijHp9CZ4KCsjiEQvgO80rX4bQplbPRspf8x++dIntdEcb/qGdRmcg6n0JHDp
         Ck+ail51Td7/KbmfoZkzEox8GO/DXiSo9KpAlUhZVlQYIdVT7yJh9cHt8Qf/sj60IzXj
         mDLfoLiL534FZ+a+y1pzeli4rbmYKe9oOtSe42wvO27yCwW7rLh5vZMSNDafwgpdaX7S
         taKvFPgh+rf1NtHqa3WhZrm/jROsV3ePvMSv7SEv7+/7UV6eEJNwG8cw3CHHldRkxA4f
         ns5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wmCIVOq1NAIlLDqeMnMtQQlsHBH3WlyqDeom4tMXSfU=;
        b=a7DI5c8L7/G2O5fHzNLQisltAUbAQILjik5ArZ5KPMIdofg+Lt657JGztTBAvH6YIH
         HX2wjwnL4LlW3CKyfovMmXri5VEvjZwbFoiyKGJCqMA2mQOZNk6vszln0zgTu2dPwJcl
         WrZ/vCyCAfT1oXylJyco3RUXKyNMQuPSaMWwA4WXEmn5zXWc8o6GD4UZlFffxHQIGAxh
         oFf95bl9gCp8Tiw5WkHlIWld5wMvewKlK8hPo3e8KjlG2EtStHbfHj/1x0rn5Vh1rgLE
         wE1uzC5HUZbM/hjXocwZBUmbLQtVv7H+DJpy3tsw505uOUbW4DF63exg8RBxQv96myWf
         FHLQ==
X-Gm-Message-State: AOAM530BQiQnm8NPjDMB34UW0EKj2eydkrD3k9uUQ3PyRtAnYN8rwzcx
        wvfTUkEduiUNqqfwPnLJyA==
X-Google-Smtp-Source: ABdhPJxDZYcsGrAQ3nyxszuNkM5QgfkbMqFzzng0tSuTJ7qY5QY4zFvbxkrZ1DeiVh6IvRCuYMq88g==
X-Received: by 2002:a9d:4a8e:: with SMTP id i14mr295051otf.37.1612918974934;
        Tue, 09 Feb 2021 17:02:54 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id i9sm101811oii.34.2021.02.09.17.02.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 17:02:53 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 3/4] net: dsa: add support for offloading HSR
Date:   Tue,  9 Feb 2021 19:02:12 -0600
Message-Id: <20210210010213.27553-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210210010213.27553-1-george.mccollister@gmail.com>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
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
index 60acb9fca124..d8de23ce7221 100644
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
+	int	(*port_hsr_leave)(struct dsa_switch *ds, int port,
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
index 5026e4143663..1906179e59f7 100644
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
+	return -EOPNOTSUPP;
+}
+
+static int dsa_switch_hsr_leave(struct dsa_switch *ds,
+				struct dsa_notifier_hsr_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
+		return ds->ops->port_hsr_leave(ds, info->port, info->hsr);
+
+	return -EOPNOTSUPP;
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


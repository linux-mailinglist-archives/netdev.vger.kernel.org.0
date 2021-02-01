Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1F930A955
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBAOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhBAOGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:06:10 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFEAC061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:05:30 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id f6so16289409ots.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8HW3K8yagETnCFREbbV7sID3AtI2Eya/phv8oX3UrEI=;
        b=sbk9yj5XBDotfdUvarhmolf7m1hqOQOn3T9Ty4y7W7YBRrc8MlhjzQEkicH43EkFo8
         oU5ngbasGwHKRBilvaqx/Cefkhf8EBQ6miAyUvJMmvMX52Xm+XJh33/C2xc26x48qaIJ
         iuWVfFIpaiMI144nehZj2Ih1xgdjxUPuKm5A5pDycq53o1GaG+F7Wq6Z5+kzH0BbYS9y
         0oeXNmgUBwCZzBNJ21uWi1/8fJon5BPfOZRj/dGsIbSFHgIBjqvCCi4xjdtO00KOUSbL
         k5sRn6usUyl2sCkJBb8ZulmC0E3X3nu5P5vO0IKoGnSdCGUlO9Camhp6yroPZcOobgAO
         rRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8HW3K8yagETnCFREbbV7sID3AtI2Eya/phv8oX3UrEI=;
        b=Uiz2RQGtJ1T4vxCAYRvLQULRYZKRZXeESsyPmxG4tO0o8FS/PsvhhsJMeUZf0OnSgG
         4Zfu9zzc1e8iZauazCV6weY+kvbC/A7mVqv22EFPvBveFJFOjrsrOau9wt89J1kYKBiz
         hd/03BWE+jQPGKxLTfcvwm4DLPxSvVctoQxQkCISWwVkPAqBc1lvwstPtfPTwMu08KY4
         EGFFm8eHx6iB6F0mnhPwk1WVivaURMT/0tM2R1ZlZsJg40wOApuR7IYnxaXh37ZT4ah0
         9c8pev8DMFNUjR7b0T6FqtnB+AQY2ekg6YdLDeZZIcYStyMNB3HfHXNXCDHox7AjgTfp
         o+9g==
X-Gm-Message-State: AOAM531+M5vwSxr1jrKwrOnFbjTBCUYqTkFDxUAD8K/SbUDlJZHQA+Tl
        IGoQkBAWjn0G7gTTSRe5anRbPm3bw6QP
X-Google-Smtp-Source: ABdhPJxrNw/IKNRpqzMEljVcXbzQZWYuoFNTcCAwZcxl/8gvuRkfXF/ReE5E2caZVwJhOAysnLmwvw==
X-Received: by 2002:a9d:7d12:: with SMTP id v18mr11675056otn.205.1612188329794;
        Mon, 01 Feb 2021 06:05:29 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id q6sm3967972otm.68.2021.02.01.06.05.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 06:05:24 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RESEND PATCH net-next 3/4] net: dsa: add support for offloading HSR
Date:   Mon,  1 Feb 2021 08:05:02 -0600
Message-Id: <20210201140503.130625-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210201140503.130625-1-george.mccollister@gmail.com>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
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
 net/dsa/slave.c    | 13 +++++++++++++
 net/dsa/switch.c   | 24 ++++++++++++++++++++++++
 5 files changed, 95 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2f5435d3d1db..584e2b5c02e0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -167,6 +167,10 @@ struct dsa_switch_tree {
 	list_for_each_entry((_dp), &(_dst)->ports, list)	\
 		if ((_dp)->lag_dev == (_lag))
 
+#define dsa_hsr_foreach_port(_dp, _ds, _hsr)			\
+	list_for_each_entry((_dp), &(_ds)->dst->ports, list)	\
+		if ((_dp)->ds == (_ds) && (_dp)->hsr_dev == (_hsr))
+
 static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 					     unsigned int id)
 {
@@ -257,6 +261,7 @@ struct dsa_port {
 	struct phylink_config	pl_config;
 	struct net_device	*lag_dev;
 	bool			lag_tx_enabled;
+	struct net_device	*hsr_dev;
 
 	struct list_head list;
 
@@ -753,6 +758,14 @@ struct dsa_switch_ops {
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
index 2ce46bb87703..9006f62f69cd 100644
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
@@ -94,6 +96,13 @@ struct dsa_switchdev_event_work {
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
@@ -174,6 +183,8 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
+void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f5b0f72ee7cd..09738af4d32e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -870,3 +870,37 @@ int dsa_port_get_phy_sset_count(struct dsa_port *dp)
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
index f2fb433f3828..fc7e3ff11c5c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1924,6 +1924,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			dsa_port_lag_leave(dp, info->upper_dev);
 			err = NOTIFY_OK;
 		}
+	} else if (netif_is_hsr_master(info->upper_dev)) {
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
index cc0b25f3adea..c1e5083f2cfc 100644
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
@@ -319,6 +337,12 @@ static int dsa_switch_event(struct notifier_block *nb,
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


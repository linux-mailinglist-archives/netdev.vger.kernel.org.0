Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6613009C8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbhAVR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729223AbhAVQBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:01:04 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC11C061793
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:20 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id x137so5220455oix.11
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U5twcOoLF8KlRgBxVGC2UjWKeA0YYTzxyaqw6g4kjMQ=;
        b=WbK791f52SVqLJGBQqGWkjtHbJ9cXWhq4cFdpvDuOIhxVS+ffsOCYHSL+yLURvXVz5
         3Zohx91u7kYxQ1MDWhRT0/iFfnYjGuRSrLU6jMXysZwiQDkt1P4DzFNxrZXKEMhleAEg
         BRXEozxiHy0OwzFZVad8NdNVVeBjy/UQCZLU9wIL9cLDGrEC8wIue6ay9xawJ1tlSQz5
         wyY6zamCV7JlqBEj00M6VT2/FZTvOz7vo0P7oHy453gt37EOdPopVqtfqBYSRaipLj7I
         f6CY5qkLcYw1hXm3Tdoa/7Nyaprp0DEQUySmox8KX0nvv3flO7q9OGvYwdh7i21Qskz5
         6b0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U5twcOoLF8KlRgBxVGC2UjWKeA0YYTzxyaqw6g4kjMQ=;
        b=Mlo4dRFehSzkDfqSrAJR5jE679XnUv6w8s9JEeTk9pOd1xF0MkGH8OiQalm9B46A6u
         dIedg4bg6a6RdueqjdUCObFmWQrN1uSY+BBpDx+u3Z6a4LfwIlJ1phLxZueksdaNPKoQ
         MzO6GgIvpgcddfpp/6G7bmSMep58CN+7/1TjScO0O0s7IACZZK+dVXAhT4YwiAX4tCnq
         d37EOQ68SdORL31IuMYjpBv6LkYXRPu024tWz4Rql8NDRLzc8Debr66pcInsZxbf4fWp
         LRG0lQx7vU3tQceTrVTy0wXAsQvNpR7MDkanwi6fE2UXZpOc8teCD5USurUa8+T/3j6T
         9YwA==
X-Gm-Message-State: AOAM533Ug5tPRjpNUbURukxwZ4GlgbxMrKTDHCG6iXDwcOpXfX5L9v4F
        jSOPCnzvx8AFkyItWxk3lw==
X-Google-Smtp-Source: ABdhPJzFnPsNUcWJbuCwNqluoL2WO6N90oT90qkk+f5GtGyiI4lNjDZHukj3L+w6H5K6i/EgMLZ8/g==
X-Received: by 2002:aca:34c2:: with SMTP id b185mr3699983oia.25.1611331219871;
        Fri, 22 Jan 2021 08:00:19 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y24sm1674942oos.44.2021.01.22.08.00.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:00:19 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
Date:   Fri, 22 Jan 2021 09:59:47 -0600
Message-Id: <20210122155948.5573-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210122155948.5573-1-george.mccollister@gmail.com>
References: <20210122155948.5573-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
tag removal, duplicate generation and forwarding on DSA switches.

Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
device so DSA can tell them apart from other devices in
dsa_slave_changeupper.

Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.

The DSA switch driver should then set netdev feature flags for the
HSR/PRP operation that it offloads.
    NETIF_F_HW_HSR_TAG_INS
    NETIF_F_HW_HSR_TAG_RM
    NETIF_F_HW_HSR_FWD
    NETIF_F_HW_HSR_DUP

For HSR, insertion involves the switch adding a 6 byte HSR header after
the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.

Tag removal involves automatically stripping the HSR/PRP header/trailer
in the switch. This is possible when the switch also preforms auto
deduplication using the HSR/PRP header/trailer (making it no longer
required).

Forwarding involves automatically forwarding between redundant ports in
an HSR. This is crucial because delay is accumulated as a frame passes
through each node in the ring.

Duplication involves the switch automatically sending a single frame
from the CPU port to both redundant ports. This is required because the
inserted HSR/PRP header/trailer must contain the same sequence number
on the frames sent out both redundant ports.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/networking/netdev-features.rst | 20 ++++++++++++++++
 include/linux/if_hsr.h                       | 22 ++++++++++++++++++
 include/linux/netdev_features.h              |  9 ++++++++
 include/linux/netdevice.h                    | 13 +++++++++++
 include/net/dsa.h                            | 13 +++++++++++
 net/dsa/dsa_priv.h                           | 11 +++++++++
 net/dsa/port.c                               | 34 ++++++++++++++++++++++++++++
 net/dsa/slave.c                              | 13 +++++++++++
 net/dsa/switch.c                             | 24 ++++++++++++++++++++
 net/ethtool/common.c                         |  4 ++++
 net/hsr/hsr_device.c                         | 12 +++-------
 net/hsr/hsr_forward.c                        | 27 +++++++++++++++++++---
 net/hsr/hsr_forward.h                        |  1 +
 net/hsr/hsr_main.c                           | 14 ++++++++++++
 net/hsr/hsr_main.h                           |  8 +------
 net/hsr/hsr_slave.c                          | 13 +++++++----
 16 files changed, 215 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/if_hsr.h

diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
index a2d7d7160e39..4eab45405031 100644
--- a/Documentation/networking/netdev-features.rst
+++ b/Documentation/networking/netdev-features.rst
@@ -182,3 +182,23 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
 be re-segmentable by GSO or TSO back to the exact original packet stream.
 Hardware GRO is dependent on RXCSUM since every packet successfully merged
 by hardware must also have the checksum verified by hardware.
+
+* hsr-tag-ins-offload
+
+This should be set for devices which insert an HSR (highspeed ring) tag
+automatically when in HSR mode.
+
+* hsr-tag-rm-offload
+
+This should be set for devices which remove HSR (highspeed ring) tags
+automatically when in HSR mode.
+
+* hsr-fwd-offload
+
+This should be set for devices which forward HSR (highspeed ring) frames from
+one port to another in hardware.
+
+* hsr-dup-offload
+
+This should be set for devices which duplicate outgoing HSR (highspeed ring)
+frames in hardware.
diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
new file mode 100644
index 000000000000..eec9079efab0
--- /dev/null
+++ b/include/linux/if_hsr.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_IF_HSR_H_
+#define _LINUX_IF_HSR_H_
+
+/* used to differentiate various protocols */
+enum hsr_version {
+	HSR_V0 = 0,
+	HSR_V1,
+	PRP_V1,
+};
+
+#if IS_ENABLED(CONFIG_HSR)
+extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
+#else
+static inline int hsr_get_version(struct net_device *dev,
+				  enum hsr_version *ver)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_HSR */
+
+#endif /*_LINUX_IF_HSR_H_*/
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 934de56644e7..13b3fa7668bb 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -85,6 +85,11 @@ enum {
 
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
 
+	NETIF_F_HW_HSR_TAG_INS_BIT,	/* Offload HSR tag insertion */
+	NETIF_F_HW_HSR_TAG_RM_BIT,	/* Offload HSR tag removal */
+	NETIF_F_HW_HSR_FWD_BIT,		/* Offload HSR forwarding */
+	NETIF_F_HW_HSR_DUP_BIT,		/* Offload HSR duplication */
+
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -157,6 +162,10 @@ enum {
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
+#define NETIF_F_HW_HSR_TAG_INS	__NETIF_F(HW_HSR_TAG_INS)
+#define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
+#define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
+#define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b949076ed23..4a1533aff3cf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1523,6 +1523,7 @@ struct net_device_ops {
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
+ * @IFF_HSR: device is an hsr device
  */
 enum netdev_priv_flags {
 	IFF_802_1Q_VLAN			= 1<<0,
@@ -1556,6 +1557,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
+	IFF_HSR				= 1<<31,
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
@@ -1588,6 +1590,7 @@ enum netdev_priv_flags {
 #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
 #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
+#define IFF_HSR				IFF_HSR
 
 /**
  *	struct net_device - The DEVICE structure.
@@ -4996,6 +4999,16 @@ static inline bool netif_is_failover_slave(const struct net_device *dev)
 	return dev->priv_flags & IFF_FAILOVER_SLAVE;
 }
 
+static inline bool netif_is_hsr_master(const struct net_device *dev)
+{
+	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_HSR;
+}
+
+static inline bool netif_is_hsr_slave(const struct net_device *dev)
+{
+	return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_HSR;
+}
+
 /* This device needs to keep skb dst for qdisc enqueue or ndo_start_xmit() */
 static inline void netif_keep_dst(struct net_device *dev)
 {
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
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..934e98e495a6 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,10 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
+	[NETIF_F_HW_HSR_TAG_INS_BIT] =	 "hsr-tag-ins-offload",
+	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
+	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
+	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
 };
 
 const char
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 161b8da6a21d..d9b033e9b18c 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -418,6 +418,7 @@ static struct hsr_proto_ops hsr_ops = {
 	.send_sv_frame = send_hsr_supervision_frame,
 	.create_tagged_frame = hsr_create_tagged_frame,
 	.get_untagged_frame = hsr_get_untagged_frame,
+	.drop_frame = hsr_drop_frame,
 	.fill_frame_info = hsr_fill_frame_info,
 	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
 };
@@ -521,15 +522,8 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	hsr->prot_version = protocol_version;
 
-	/* FIXME: should I modify the value of these?
-	 *
-	 * - hsr_dev->flags - i.e.
-	 *			IFF_MASTER/SLAVE?
-	 * - hsr_dev->priv_flags - i.e.
-	 *			IFF_EBRIDGE?
-	 *			IFF_TX_SKB_SHARING?
-	 *			IFF_HSR_MASTER/SLAVE?
-	 */
+	hsr_dev->flags |= IFF_MASTER;
+	hsr_dev->priv_flags |= IFF_HSR;
 
 	/* Make sure the 1st call to netif_carrier_on() gets through */
 	netif_carrier_off(hsr_dev);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index a5566b2245a0..9c79d602c4e0 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -247,6 +247,8 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 		/* set the lane id properly */
 		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
+	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
 	/* Create the new skb with enough headroom to fit the HSR tag */
@@ -341,6 +343,14 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 		 port->type ==  HSR_PT_SLAVE_A));
 }
 
+bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
+{
+	if (port->dev->features & NETIF_F_HW_HSR_FWD)
+		return prp_drop_frame(frame, port);
+
+	return false;
+}
+
 /* Forward the frame through all devices except:
  * - Back through the receiving device
  * - If it's a HSR frame: through a device where it has passed before
@@ -357,6 +367,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 {
 	struct hsr_port *port;
 	struct sk_buff *skb;
+	bool sent = false;
 
 	hsr_for_each_port(frame->port_rcv->hsr, port) {
 		struct hsr_priv *hsr = port->hsr;
@@ -372,6 +383,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
 			continue;
 
+		/* If hardware duplicate generation is enabled, only send out
+		 * one port.
+		 */
+		if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
+			continue;
+
 		/* Don't send frame over port where it has been sent before.
 		 * Also fro SAN, this shouldn't be done.
 		 */
@@ -403,10 +420,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		}
 
 		skb->dev = port->dev;
-		if (port->type == HSR_PT_MASTER)
+		if (port->type == HSR_PT_MASTER) {
 			hsr_deliver_master(skb, port->dev, frame->node_src);
-		else
-			hsr_xmit(skb, port, frame);
+		} else {
+			if (!hsr_xmit(skb, port, frame))
+				sent = true;
+		}
 	}
 }
 
@@ -457,6 +476,7 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	struct hsr_port *port = frame->port_rcv;
 
 	if (port->type != HSR_PT_MASTER &&
+	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
 	    (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
@@ -478,6 +498,7 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 	struct hsr_port *port = frame->port_rcv;
 
 	if (port->type != HSR_PT_MASTER &&
+	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
 	    rct &&
 	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
 		frame->skb_hsr = NULL;
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index 618140d484ad..b6acaafa83fc 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -23,6 +23,7 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port);
 bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
+bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
 void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			 struct hsr_frame_info *frame);
 void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 2fd1976e5b1c..0e7b5b18b5e3 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -131,6 +131,20 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
 	return NULL;
 }
 
+int hsr_get_version(struct net_device *dev, enum hsr_version *ver)
+{
+	struct hsr_priv *hsr;
+
+	if (!(dev->priv_flags & IFF_HSR))
+		return -EINVAL;
+
+	hsr = netdev_priv(dev);
+	*ver = hsr->prot_version;
+
+	return 0;
+}
+EXPORT_SYMBOL(hsr_get_version);
+
 static struct notifier_block hsr_nb = {
 	.notifier_call = hsr_netdev_notify,	/* Slave event notifications */
 };
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 7dc92ce5a134..7369b2febe0f 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include <linux/list.h>
 #include <linux/if_vlan.h>
+#include <linux/if_hsr.h>
 
 /* Time constants as specified in the HSR specification (IEC-62439-3 2010)
  * Table 8.
@@ -171,13 +172,6 @@ struct hsr_port {
 	enum hsr_port_type	type;
 };
 
-/* used by driver internally to differentiate various protocols */
-enum hsr_version {
-	HSR_V0 = 0,
-	HSR_V1,
-	PRP_V1,
-};
-
 struct hsr_frame_info;
 struct hsr_node;
 
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 36d5fcf09c61..59f8d2b68376 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -48,12 +48,14 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		goto finish_consume;
 	}
 
-	/* For HSR, only tagged frames are expected, but for PRP
-	 * there could be non tagged frames as well from Single
-	 * attached nodes (SANs).
+	/* For HSR, only tagged frames are expected (unless the device offloads
+	 * HSR tag removal), but for PRP there could be non tagged frames as
+	 * well from Single attached nodes (SANs).
 	 */
 	protocol = eth_hdr(skb)->h_proto;
-	if (hsr->proto_ops->invalid_dan_ingress_frame &&
+
+	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	    hsr->proto_ops->invalid_dan_ingress_frame &&
 	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
 		goto finish_pass;
 
@@ -137,6 +139,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	hsr_dev = master->dev;
 
+	dev->flags |= IFF_SLAVE;
+	dev->priv_flags |= IFF_HSR;
+
 	res = netdev_upper_dev_link(dev, hsr_dev, extack);
 	if (res)
 		goto fail_upper_dev_link;
-- 
2.11.0


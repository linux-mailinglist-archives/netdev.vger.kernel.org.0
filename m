Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CDF4F6D50
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiDFVuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiDFVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AF15FAE
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 912A8B82598
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FF7C385A1;
        Wed,  6 Apr 2022 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649281080;
        bh=7mEdMBGEmAXNCXdHLpWUKBdS7a27b+jQrp9SI+oUl8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I03h8p7t4djx22NPoMV1Jxq6UQni7DskmnjLJ9DYozC5jWacwqjBJ2Gb8IgXhGpTT
         tU6L3DKYhppRtcsu9R3R/Cvf1EZc0G8cccJ1mtQJNHgKHrAIdzIZYcZ/OPGvwn9a7X
         V40wQwzzG8vwhxU+HGjA2v6lNFOV1ybvsH6cs+ABrNlIigdo75ttdXZcezic5FBx2C
         TxNQvON6YQ/pE1tEfak8C7M5C8s/r1BDpFI9Ir5iME88yB7OHuLuCloer8kGT0CQbH
         BjZhr76f1rHvIeX5JIQerB1Lq0C/gehjL44YvgaqcbNpuzBZWcKLEcPUzQXzcnJdsd
         QUVoW5yrwSHdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] net: extract a few internals from netdevice.h
Date:   Wed,  6 Apr 2022 14:37:54 -0700
Message-Id: <20220406213754.731066-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220406213754.731066-1-kuba@kernel.org>
References: <20220406213754.731066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of functions and static variables used
under net/core/ but not from the outside. We currently
dump most of them into netdevice.h. That bad for many
reasons:
 - netdevice.h is very cluttered, hard to figure out
   what the APIs are;
 - netdevice.h is very long;
 - we have to touch netdevice.h more which causes expensive
   incremental builds.

Create a header under net/core/ and move some declarations.

The new header is also a bit of a catch-all but that's
fine, if we create more specific headers people will
likely over-think where their declaration fit best.
And end up putting them in netdevice.h, again.

More work should be done on splitting netdevice.h into more
targeted headers, but that'd be more time consuming so small
steps.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h  | 72 +-----------------------------
 net/core/dev.c             |  1 +
 net/core/dev.h             | 91 ++++++++++++++++++++++++++++++++++++++
 net/core/dev_addr_lists.c  |  2 +
 net/core/dev_ioctl.c       |  2 +
 net/core/link_watch.c      |  1 +
 net/core/net-procfs.c      |  2 +
 net/core/net-sysfs.c       |  1 +
 net/core/rtnetlink.c       |  2 +
 net/core/sock.c            |  2 +
 net/core/sysctl_net_core.c |  2 +
 11 files changed, 108 insertions(+), 70 deletions(-)
 create mode 100644 net/core/dev.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7b2a0b739684..7e7b2a72e473 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -59,7 +59,8 @@ struct dsa_port;
 struct ip_tunnel_parm;
 struct macsec_context;
 struct macsec_ops;
-
+struct netdev_name_node;
+struct sd_flow_limit;
 struct sfp_bus;
 /* 802.11 specific */
 struct wireless_dev;
@@ -1020,16 +1021,6 @@ struct dev_ifalias {
 struct devlink;
 struct tlsdev_ops;
 
-struct netdev_name_node {
-	struct hlist_node hlist;
-	struct list_head list;
-	struct net_device *dev;
-	const char *name;
-};
-
-int netdev_name_node_alt_create(struct net_device *dev, const char *name);
-int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
-
 struct netdev_net_notifier {
 	struct list_head list;
 	struct notifier_block *nb;
@@ -2975,7 +2966,6 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
-int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_restart(struct net_device *dev);
 
 
@@ -3034,19 +3024,6 @@ static inline bool dev_has_header(const struct net_device *dev)
 	return dev->header_ops && dev->header_ops->create;
 }
 
-#ifdef CONFIG_NET_FLOW_LIMIT
-#define FLOW_LIMIT_HISTORY	(1 << 7)  /* must be ^2 and !overflow buckets */
-struct sd_flow_limit {
-	u64			count;
-	unsigned int		num_buckets;
-	unsigned int		history_head;
-	u16			history[FLOW_LIMIT_HISTORY];
-	u8			buckets[];
-};
-
-extern int netdev_flow_limit_table_len;
-#endif /* CONFIG_NET_FLOW_LIMIT */
-
 /*
  * Incoming packets are placed on per-CPU queues
  */
@@ -3770,7 +3747,6 @@ int dev_change_flags(struct net_device *dev, unsigned int flags,
 		     struct netlink_ext_ack *extack);
 void __dev_notify_flags(struct net_device *, unsigned int old_flags,
 			unsigned int gchanges);
-int dev_change_name(struct net_device *, const char *);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
@@ -3782,13 +3758,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net,
 	return __dev_change_net_namespace(dev, net, pat, 0);
 }
 int __dev_set_mtu(struct net_device *, int);
-int dev_validate_mtu(struct net_device *dev, int mtu,
-		     struct netlink_ext_ack *extack);
-int dev_set_mtu_ext(struct net_device *dev, int mtu,
-		    struct netlink_ext_ack *extack);
 int dev_set_mtu(struct net_device *, int);
-int dev_change_tx_queue_len(struct net_device *, unsigned long);
-void dev_set_group(struct net_device *, int);
 int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
 			      struct netlink_ext_ack *extack);
 int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
@@ -3796,24 +3766,13 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
 			     struct netlink_ext_ack *extack);
 int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
-int dev_change_carrier(struct net_device *, bool new_carrier);
-int dev_get_phys_port_id(struct net_device *dev,
-			 struct netdev_phys_item_id *ppid);
-int dev_get_phys_port_name(struct net_device *dev,
-			   char *name, size_t len);
 int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
-int dev_change_proto_down(struct net_device *dev, bool proto_down);
-void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
-				  u32 value);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
-typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags);
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
@@ -3898,13 +3857,6 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
 bool dev_nit_active(struct net_device *dev);
 void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev);
 
-extern int		netdev_budget;
-extern unsigned int	netdev_budget_usecs;
-
-/* Used by rtnetlink.c:__rtnl_unlock()/rtnl_unlock() */
-extern struct list_head net_todo_list;
-void netdev_run_todo(void);
-
 static inline void __dev_put(struct net_device *dev)
 {
 	if (dev) {
@@ -4021,10 +3973,7 @@ static inline void dev_replace_track(struct net_device *odev,
  * called netif_lowerlayer_*() because they represent the state of any
  * kind of lower layer not just hardware media.
  */
-
-void linkwatch_init_dev(struct net_device *dev);
 void linkwatch_fire_event(struct net_device *dev);
-void linkwatch_forget_dev(struct net_device *dev);
 
 /**
  *	netif_carrier_ok - test if carrier present
@@ -4470,9 +4419,6 @@ int dev_addr_add(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
 int dev_addr_del(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
-void dev_addr_flush(struct net_device *dev);
-int dev_addr_init(struct net_device *dev);
-void dev_addr_check(struct net_device *dev);
 
 /* Functions used for unicast addresses handling */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr);
@@ -4562,7 +4508,6 @@ static inline void __dev_mc_unsync(struct net_device *dev,
 
 /* Functions used for secondary unicast and multicast support */
 void dev_set_rx_mode(struct net_device *dev);
-void __dev_set_rx_mode(struct net_device *dev);
 int dev_set_promiscuity(struct net_device *dev, int inc);
 int dev_set_allmulti(struct net_device *dev, int inc);
 void netdev_state_change(struct net_device *dev);
@@ -4580,11 +4525,6 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
 
 extern int		netdev_max_backlog;
-extern int		netdev_tstamp_prequeue;
-extern int		netdev_unregister_timeout_secs;
-extern int		weight_p;
-extern int		dev_weight_rx_bias;
-extern int		dev_weight_tx_bias;
 extern int		dev_rx_weight;
 extern int		dev_tx_weight;
 extern int		gro_normal_batch;
@@ -4772,12 +4712,6 @@ static inline void netdev_rx_csum_fault(struct net_device *dev,
 void net_enable_timestamp(void);
 void net_disable_timestamp(void);
 
-#ifdef CONFIG_PROC_FS
-int __init dev_proc_init(void);
-#else
-#define dev_proc_init() 0
-#endif
-
 static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
 					      struct sk_buff *skb, struct net_device *dev,
 					      bool more)
@@ -4813,8 +4747,6 @@ extern const struct kobj_ns_type_operations net_ns_type_operations;
 
 const char *netdev_drivername(const struct net_device *dev);
 
-void linkwatch_run_queue(void);
-
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 8755ad71be6c..f00d29856b43 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -151,6 +151,7 @@
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
 
+#include "dev.h"
 #include "net-sysfs.h"
 
 
diff --git a/net/core/dev.h b/net/core/dev.h
new file mode 100644
index 000000000000..27923df00637
--- /dev/null
+++ b/net/core/dev.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _NET_CORE_DEV_H
+#define _NET_CORE_DEV_H
+
+#include <linux/types.h>
+
+struct net;
+struct net_device;
+struct netdev_bpf;
+struct netdev_phys_item_id;
+struct netlink_ext_ack;
+
+/* Random bits of netdevice that don't need to be exposed */
+#define FLOW_LIMIT_HISTORY	(1 << 7)  /* must be ^2 and !overflow buckets */
+struct sd_flow_limit {
+	u64			count;
+	unsigned int		num_buckets;
+	unsigned int		history_head;
+	u16			history[FLOW_LIMIT_HISTORY];
+	u8			buckets[];
+};
+
+extern int netdev_flow_limit_table_len;
+
+#ifdef CONFIG_PROC_FS
+int __init dev_proc_init(void);
+#else
+#define dev_proc_init() 0
+#endif
+
+void linkwatch_init_dev(struct net_device *dev);
+void linkwatch_forget_dev(struct net_device *dev);
+void linkwatch_run_queue(void);
+
+void dev_addr_flush(struct net_device *dev);
+int dev_addr_init(struct net_device *dev);
+void dev_addr_check(struct net_device *dev);
+
+/* sysctls not referred to from outside net/core/ */
+extern int		netdev_budget;
+extern unsigned int	netdev_budget_usecs;
+
+extern int		netdev_tstamp_prequeue;
+extern int		netdev_unregister_timeout_secs;
+extern int		weight_p;
+extern int		dev_weight_rx_bias;
+extern int		dev_weight_tx_bias;
+
+/* rtnl helpers */
+extern struct list_head net_todo_list;
+void netdev_run_todo(void);
+
+/* netdev management, shared between various uAPI entry points */
+struct netdev_name_node {
+	struct hlist_node hlist;
+	struct list_head list;
+	struct net_device *dev;
+	const char *name;
+};
+
+int netdev_get_name(struct net *net, char *name, int ifindex);
+int dev_change_name(struct net_device *dev, const char *newname);
+
+int netdev_name_node_alt_create(struct net_device *dev, const char *name);
+int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
+
+int dev_validate_mtu(struct net_device *dev, int mtu,
+		     struct netlink_ext_ack *extack);
+int dev_set_mtu_ext(struct net_device *dev, int mtu,
+		    struct netlink_ext_ack *extack);
+
+int dev_get_phys_port_id(struct net_device *dev,
+			 struct netdev_phys_item_id *ppid);
+int dev_get_phys_port_name(struct net_device *dev,
+			   char *name, size_t len);
+
+int dev_change_proto_down(struct net_device *dev, bool proto_down);
+void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
+				  u32 value);
+
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+		      int fd, int expected_fd, u32 flags);
+
+int dev_change_tx_queue_len(struct net_device *dev, unsigned long new_len);
+void dev_set_group(struct net_device *dev, int new_group);
+int dev_change_carrier(struct net_device *dev, bool new_carrier);
+
+void __dev_set_rx_mode(struct net_device *dev);
+
+#endif
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index bead38ca50bd..baa63dee2829 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -12,6 +12,8 @@
 #include <linux/export.h>
 #include <linux/list.h>
 
+#include "dev.h"
+
 /*
  * General list handling functions
  */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1b807d119da5..4f6be442ae7e 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -10,6 +10,8 @@
 #include <net/dsa.h>
 #include <net/wext.h>
 
+#include "dev.h"
+
 /*
  *	Map an interface index to its name (SIOCGIFNAME)
  */
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 95098d1a49bd..a244d3bade7d 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 
+#include "dev.h"
 
 enum lw_bits {
 	LW_URGENT = 0,
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 88cc0ad7d386..1ec23bf8b05c 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -4,6 +4,8 @@
 #include <linux/seq_file.h>
 #include <net/wext.h>
 
+#include "dev.h"
+
 #define BUCKET_SPACE (32 - NETDEV_HASHBITS - 1)
 
 #define get_bucket(x) ((x) >> BUCKET_SPACE)
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9cbc1c8289bc..4980c3a50475 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -24,6 +24,7 @@
 #include <linux/of_net.h>
 #include <linux/cpu.h>
 
+#include "dev.h"
 #include "net-sysfs.h"
 
 #ifdef CONFIG_SYSFS
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0e4502d641eb..4041b3e2e8ec 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -54,6 +54,8 @@
 #include <net/rtnetlink.h>
 #include <net/net_namespace.h>
 
+#include "dev.h"
+
 #define RTNL_MAX_TYPE		50
 #define RTNL_SLAVE_MAX_TYPE	40
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..7000403eaeb2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -141,6 +141,8 @@
 
 #include <linux/ethtool.h>
 
+#include "dev.h"
+
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7123fe7feeac..8295e5877eb3 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -23,6 +23,8 @@
 #include <net/busy_poll.h>
 #include <net/pkt_sched.h>
 
+#include "dev.h"
+
 static int two = 2;
 static int three = 3;
 static int int_3600 = 3600;
-- 
2.34.1


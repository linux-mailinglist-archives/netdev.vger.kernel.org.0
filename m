Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D128230A025
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 03:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhBACFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 21:05:04 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33191 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231126AbhBACFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 21:05:04 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from cmi@nvidia.com)
        with SMTP; 1 Feb 2021 04:04:15 +0200
Received: from dev-r630-03.mtbc.labs.mlnx (dev-r630-03.mtbc.labs.mlnx [10.75.205.13])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 11124DVC015533;
        Mon, 1 Feb 2021 04:04:14 +0200
From:   Chris Mi <cmi@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, jiri@nvidia.com, saeedm@nvidia.com,
        Chris Mi <cmi@nvidia.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC driver dependency
Date:   Mon,  1 Feb 2021 10:04:12 +0800
Message-Id: <20210201020412.52790-1-cmi@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to send sampled packets to userspace, NIC driver calls
psample api directly. But it creates a hard dependency on module
psample. Introduce psample_ops to remove the hard dependency.
It is initialized when psample module is loaded and set to NULL
when the module is unloaded.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
 - fix sparse errors
v2->v3:
 - remove inline
v3->v4:
 - add inline back
v4->v5:
 - address Jakub's comments
v5-v6:
 - fix psample_stub.c copyright

 include/net/psample.h    | 26 ++++++++++++++++++++++++++
 net/psample/psample.c    | 14 +++++++++++++-
 net/sched/Makefile       |  2 +-
 net/sched/psample_stub.c |  5 +++++
 4 files changed, 45 insertions(+), 2 deletions(-)
 create mode 100644 net/sched/psample_stub.c

diff --git a/include/net/psample.h b/include/net/psample.h
index 68ae16bb0a4a..d0f1cfc56f6f 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -14,6 +14,15 @@ struct psample_group {
 	struct rcu_head rcu;
 };
 
+struct psample_ops {
+	void (*sample_packet)(struct psample_group *group, struct sk_buff *skb,
+			      u32 trunc_size, int in_ifindex, int out_ifindex,
+			      u32 sample_rate);
+
+};
+
+extern const struct psample_ops __rcu *psample_ops __read_mostly;
+
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_take(struct psample_group *group);
 void psample_group_put(struct psample_group *group);
@@ -35,4 +44,21 @@ static inline void psample_sample_packet(struct psample_group *group,
 
 #endif
 
+static inline void
+psample_nic_sample_packet(struct psample_group *group,
+			  struct sk_buff *skb, u32 trunc_size,
+			  int in_ifindex, int out_ifindex,
+			  u32 sample_rate)
+{
+	const struct psample_ops *ops;
+
+	rcu_read_lock();
+	ops = rcu_dereference(psample_ops);
+	if (ops)
+		ops->sample_packet(group, skb, trunc_size,
+				   in_ifindex, out_ifindex,
+				   sample_rate);
+	rcu_read_unlock();
+}
+
 #endif /* __NET_PSAMPLE_H */
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 33e238c965bd..983ca5b698fe 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -35,6 +36,10 @@ static const struct genl_multicast_group psample_nl_mcgrps[] = {
 
 static struct genl_family psample_nl_family __ro_after_init;
 
+static const struct psample_ops psample_sample_ops = {
+	.sample_packet	= psample_sample_packet,
+};
+
 static int psample_group_nl_fill(struct sk_buff *msg,
 				 struct psample_group *group,
 				 enum psample_command cmd, u32 portid, u32 seq,
@@ -456,11 +461,18 @@ EXPORT_SYMBOL_GPL(psample_sample_packet);
 
 static int __init psample_module_init(void)
 {
-	return genl_register_family(&psample_nl_family);
+	int ret;
+
+	ret = genl_register_family(&psample_nl_family);
+	if (!ret)
+		RCU_INIT_POINTER(psample_ops, &psample_sample_ops);
+	return ret;
 }
 
 static void __exit psample_module_exit(void)
 {
+	rcu_assign_pointer(psample_ops, NULL);
+	synchronize_rcu();
 	genl_unregister_family(&psample_nl_family);
 }
 
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..0d92bb98bb26 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the Linux Traffic Control Unit.
 #
 
-obj-y	:= sch_generic.o sch_mq.o
+obj-y	:= sch_generic.o sch_mq.o psample_stub.o
 
 obj-$(CONFIG_INET)		+= sch_frag.o
 obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
new file mode 100644
index 000000000000..0541b8c5100d
--- /dev/null
+++ b/net/sched/psample_stub.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+const struct psample_ops __rcu *psample_ops __read_mostly;
+EXPORT_SYMBOL_GPL(psample_ops);
-- 
2.26.2


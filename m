Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB33C6EC0A2
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDWOwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjDWOwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DEBDE;
        Sun, 23 Apr 2023 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261538; x=1713797538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZtQmDSziqwfO1ORSRl00f69RfVB+hhRFkRYPrzDg8PI=;
  b=B8q3QGwdNC0AaAYwMyfNeeFjGH+xSf9eIzIMf//aY0AyASV8rKjVTHyc
   8u20T6KNfYP25ZpnIXKZDMfApl5tyc7dB83Bm8Rrx2eyG1jBMPiDsBBku
   VGUYApXPtprGwjmKGCmFYD9gLRWwVCF7+ZXSWZPCWQQom6tHuN493FrvV
   pNiFm+5+/1Q0zT5UqhMOQwnOPoq+uTcIBS0ZZk+iGtHYmJqybmepXnP+O
   gIL5X8Jh68rIM2DRzqRCMTL5WWCIentOAy3BmvfHhiiBbidRV8MzQX5RC
   bQTluuxTK2hzPoQ/hz3Xj9Sn6C2PdQNSYu1eoDFQZyAKnYNeA53Fq4sy/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890268"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890268"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680695"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680695"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:12 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 7/8] RDMA/rxe: Add the support of net namespace notifier
Date:   Sun, 23 Apr 2023 22:48:21 +0800
Message-Id: <20230423144822.1797465-8-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230423144822.1797465-1-yanjun.zhu@intel.com>
References: <20230423144822.1797465-1-yanjun.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The functions register_pernet_subsys/unregister_pernet_subsys register a
notifier of net namespace. When a new net namespace is created, the init
function of rxe will be called to initialize sk4 and sk6 socks. When a
net namespace is destroyed, the exit function will be called to handle
sk4 and sk6 socks.

The functions rxe_ns_pernet_sk4 and rxe_ns_pernet_sk6 are used to get
sk4 and sk6 socks.

The functions rxe_ns_pernet_set_sk4 and rxe_ns_pernet_set_sk6 are used
to set sk4 and sk6 socks.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/Makefile  |   3 +-
 drivers/infiniband/sw/rxe/rxe.c     |   9 ++
 drivers/infiniband/sw/rxe/rxe_net.c |  50 +++++------
 drivers/infiniband/sw/rxe/rxe_ns.c  | 134 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_ns.h  |  17 ++++
 5 files changed, 187 insertions(+), 26 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h

diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
index 5395a581f4bb..8380f97674cb 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -22,4 +22,5 @@ rdma_rxe-y := \
 	rxe_mcast.o \
 	rxe_task.o \
 	rxe_net.o \
-	rxe_hw_counters.o
+	rxe_hw_counters.o \
+	rxe_ns.o
diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index ef632be05e38..96841c56ff3a 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -9,6 +9,7 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_net.h"
+#include "rxe_ns.h"
 
 MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
 MODULE_DESCRIPTION("Soft RDMA transport");
@@ -236,6 +237,12 @@ static int __init rxe_module_init(void)
 		return -1;
 	}
 
+	err = rxe_namespace_init();
+	if (err) {
+		pr_err("Failed to register net namespace notifier\n");
+		return -1;
+	}
+
 	pr_info("loaded\n");
 	return 0;
 }
@@ -246,6 +253,8 @@ static void __exit rxe_module_exit(void)
 	ib_unregister_driver(RDMA_DRIVER_RXE);
 	rxe_net_exit();
 
+	rxe_namespace_exit();
+
 	pr_info("unloaded\n");
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0cf164da8299..28d8171a36e8 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -17,6 +17,7 @@
 #include "rxe.h"
 #include "rxe_net.h"
 #include "rxe_loc.h"
+#include "rxe_ns.h"
 
 static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
 					 struct net_device *ndev,
@@ -557,33 +558,30 @@ void rxe_net_del(struct ib_device *dev)
 
 	rdev = container_of(dev, struct rxe_dev, ib_dev);
 
-	rcu_read_lock();
-	sk = udp4_lib_lookup(dev_net(rdev->ndev), 0, 0, htonl(INADDR_ANY),
-			     htons(ROCE_V2_UDP_DPORT), 0);
-	rcu_read_unlock();
+	sk = rxe_ns_pernet_sk4(dev_net(rdev->ndev));
 	if (!sk)
 		return;
 
-	__sock_put(sk);
 
-	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
-	else
+	} else {
 		rxe_release_udp_tunnel(sk->sk_socket);
+		sk = NULL;
+		rxe_ns_pernet_set_sk4(dev_net(rdev->ndev), sk);
+	}
 
-	rcu_read_lock();
-	sk = udp6_lib_lookup(dev_net(rdev->ndev), NULL, 0, &in6addr_any,
-			     htons(ROCE_V2_UDP_DPORT), 0);
-	rcu_read_unlock();
+	sk = rxe_ns_pernet_sk6(dev_net(rdev->ndev));
 	if (!sk)
 		return;
 
-	__sock_put(sk);
-
-	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
-	else
+	} else {
 		rxe_release_udp_tunnel(sk->sk_socket);
+		sk = NULL;
+		rxe_ns_pernet_set_sk6(dev_net(rdev->ndev), sk);
+	}
 }
 #undef SK_REF_FOR_TUNNEL
 
@@ -684,18 +682,18 @@ static int rxe_net_ipv4_init(struct net_device *ndev)
 	struct sock *sk;
 	struct socket *sock;
 
-	rcu_read_lock();
-	sk = udp4_lib_lookup(dev_net(ndev), 0, 0, htonl(INADDR_ANY),
-			     htons(ROCE_V2_UDP_DPORT), 0);
-	rcu_read_unlock();
-	if (sk)
+	sk = rxe_ns_pernet_sk4(dev_net(ndev));
+	if (sk) {
+		sock_hold(sk);
 		return 0;
+	}
 
 	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(sock)) {
 		pr_err("Failed to create IPv4 UDP tunnel\n");
 		return -1;
 	}
+	rxe_ns_pernet_set_sk4(dev_net(ndev), sock->sk);
 
 	return 0;
 }
@@ -706,12 +704,11 @@ static int rxe_net_ipv6_init(struct net_device *ndev)
 	struct sock *sk;
 	struct socket *sock;
 
-	rcu_read_lock();
-	sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
-			     htons(ROCE_V2_UDP_DPORT), 0);
-	rcu_read_unlock();
-	if (sk)
+	sk = rxe_ns_pernet_sk6(dev_net(ndev));
+	if (sk) {
+		sock_hold(sk);
 		return 0;
+	}
 
 	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), true);
 	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
@@ -723,6 +720,9 @@ static int rxe_net_ipv6_init(struct net_device *ndev)
 		pr_err("Failed to create IPv6 UDP tunnel\n");
 		return -1;
 	}
+
+	rxe_ns_pernet_set_sk6(dev_net(ndev), sock->sk);
+
 #endif
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
new file mode 100644
index 000000000000..29d08899dcda
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_ns.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ */
+
+#include <net/sock.h>
+#include <net/netns/generic.h>
+#include <net/net_namespace.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/pid_namespace.h>
+#include <net/udp_tunnel.h>
+
+#include "rxe_ns.h"
+
+/*
+ * Per network namespace data
+ */
+struct rxe_ns_sock {
+	struct sock __rcu *rxe_sk4;
+	struct sock __rcu *rxe_sk6;
+};
+
+/*
+ * Index to store custom data for each network namespace.
+ */
+static unsigned int rxe_pernet_id;
+
+/*
+ * Called for every existing and added network namespaces
+ */
+static int __net_init rxe_ns_init(struct net *net)
+{
+	/*
+	 * create (if not present) and access data item in network namespace
+	 * (net) using the id (net_id)
+	 */
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+
+	rcu_assign_pointer(ns_sk->rxe_sk4, NULL); /* initialize sock 4 socket */
+	rcu_assign_pointer(ns_sk->rxe_sk6, NULL); /* initialize sock 6 socket */
+	synchronize_rcu();
+
+	return 0;
+}
+
+static void __net_exit rxe_ns_exit(struct net *net)
+{
+	/*
+	 * called when the network namespace is removed
+	 */
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+	struct sock *rxe_sk4 = NULL;
+	struct sock *rxe_sk6 = NULL;
+
+	rcu_read_lock();
+	rxe_sk4 = rcu_dereference(ns_sk->rxe_sk4);
+	rxe_sk6 = rcu_dereference(ns_sk->rxe_sk6);
+	rcu_read_unlock();
+
+	/* close socket */
+	if (rxe_sk4 && rxe_sk4->sk_socket) {
+		udp_tunnel_sock_release(rxe_sk4->sk_socket);
+		rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
+		synchronize_rcu();
+	}
+
+	if (rxe_sk6 && rxe_sk6->sk_socket) {
+		udp_tunnel_sock_release(rxe_sk6->sk_socket);
+		rcu_assign_pointer(ns_sk->rxe_sk6, NULL);
+		synchronize_rcu();
+	}
+}
+
+/*
+ * callback to make the module network namespace aware
+ */
+static struct pernet_operations rxe_net_ops __net_initdata = {
+	.init = rxe_ns_init,
+	.exit = rxe_ns_exit,
+	.id = &rxe_pernet_id,
+	.size = sizeof(struct rxe_ns_sock),
+};
+
+struct sock *rxe_ns_pernet_sk4(struct net *net)
+{
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+	struct sock *sk;
+
+	rcu_read_lock();
+	sk = rcu_dereference(ns_sk->rxe_sk4);
+	rcu_read_unlock();
+
+	return sk;
+}
+
+void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk)
+{
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+
+	rcu_assign_pointer(ns_sk->rxe_sk4, sk);
+	synchronize_rcu();
+}
+
+struct sock *rxe_ns_pernet_sk6(struct net *net)
+{
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+	struct sock *sk;
+
+	rcu_read_lock();
+	sk = rcu_dereference(ns_sk->rxe_sk6);
+	rcu_read_unlock();
+
+	return sk;
+}
+
+void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk)
+{
+	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
+
+	rcu_assign_pointer(ns_sk->rxe_sk6, sk);
+	synchronize_rcu();
+}
+
+int __init rxe_namespace_init(void)
+{
+	return register_pernet_subsys(&rxe_net_ops);
+}
+
+void __exit rxe_namespace_exit(void)
+{
+	unregister_pernet_subsys(&rxe_net_ops);
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.h b/drivers/infiniband/sw/rxe/rxe_ns.h
new file mode 100644
index 000000000000..da5bfcea1274
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_ns.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ */
+
+#ifndef RXE_NS_H
+#define RXE_NS_H
+
+struct sock *rxe_ns_pernet_sk4(struct net *net);
+struct sock *rxe_ns_pernet_sk6(struct net *net);
+void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk);
+void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk);
+int __init rxe_namespace_init(void);
+void __exit rxe_namespace_exit(void);
+
+#endif /* RXE_NS_H */
-- 
2.27.0


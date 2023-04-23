Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12486EC096
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjDWOwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjDWOwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC70AE77;
        Sun, 23 Apr 2023 07:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261536; x=1713797536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mSMn64fDwA9oOZ4hqlNDcBEYyaVAKEk5r1ra86/ZK2o=;
  b=PFI77bMa4DaFmMWV9W93RMiMBPOdecFquZjTFEQvQvsWM6CJ//Vf3ttS
   DZzkxtA5jbHCgP3t6HjsCuWu7Ao57ILRjCNRPI+XswUWCgjkQ+mBSrJH3
   rN32Ren4jpHXJpZwZzmI9GeAfMASfQs5uZzmn8r22REgS2ItLZQtyAQBZ
   HihMudgvSYhmGgJKH+vg8hOA7GY0sbIbwxOEUvoFwIpRXNEeNTgK3Omod
   XBurRlPePu9P1ZKElL3oNouD3qvtryQ7u6+L7eJAgmAnaI1ZNMejQJ63j
   LqRzGhJ7/zE19tb0kFLcF0At5tUlfqE5z3BzJpfqUdgXBDdqM3LvavfRg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890221"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890221"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680646"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680646"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:00 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 2/8] RDMA/rxe: Support more rdma links in init_net
Date:   Sun, 23 Apr 2023 22:48:16 +0800
Message-Id: <20230423144822.1797465-3-yanjun.zhu@intel.com>
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

In init_net, when several rdma links are created with the command "rdma
link add", newlink will check whether the udp port 4791 is listening or
not.
If not, creating a sock listening on udp port 4791. If yes, increasing the
reference count of the sock.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c     | 12 ++++++-
 drivers/infiniband/sw/rxe/rxe_net.c | 55 +++++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_net.h |  1 +
 3 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 89b24bc34299..c15d3c5d7a6f 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -8,6 +8,7 @@
 #include <net/addrconf.h>
 #include "rxe.h"
 #include "rxe_loc.h"
+#include "rxe_net.h"
 
 MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
 MODULE_DESCRIPTION("Soft RDMA transport");
@@ -207,14 +208,23 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 	return err;
 }
 
-static struct rdma_link_ops rxe_link_ops = {
+struct rdma_link_ops rxe_link_ops = {
 	.type = "rxe",
 	.newlink = rxe_newlink,
 };
 
 static int __init rxe_module_init(void)
 {
+	int err;
+
 	rdma_link_register(&rxe_link_ops);
+
+	err = rxe_register_notifier();
+	if (err) {
+		pr_err("Failed to register netdev notifier\n");
+		return -1;
+	}
+
 	pr_info("loaded\n");
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 2bc7361152ea..1b98efa2cf66 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -626,13 +626,23 @@ static struct notifier_block rxe_net_notifier = {
 
 static int rxe_net_ipv4_init(void)
 {
-	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
-				htons(ROCE_V2_UDP_DPORT), false);
-	if (IS_ERR(recv_sockets.sk4)) {
-		recv_sockets.sk4 = NULL;
+	struct sock *sk;
+	struct socket *sock;
+
+	rcu_read_lock();
+	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY),
+			     htons(ROCE_V2_UDP_DPORT), 0);
+	rcu_read_unlock();
+	if (sk)
+		return 0;
+
+	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), false);
+	if (IS_ERR(sock)) {
 		pr_err("Failed to create IPv4 UDP tunnel\n");
+		recv_sockets.sk4 = NULL;
 		return -1;
 	}
+	recv_sockets.sk4 = sock;
 
 	return 0;
 }
@@ -640,24 +650,46 @@ static int rxe_net_ipv4_init(void)
 static int rxe_net_ipv6_init(void)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	struct sock *sk;
+	struct socket *sock;
+
+	rcu_read_lock();
+	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any,
+			     htons(ROCE_V2_UDP_DPORT), 0);
+	rcu_read_unlock();
+	if (sk)
+		return 0;
 
-	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
-						htons(ROCE_V2_UDP_DPORT), true);
-	if (PTR_ERR(recv_sockets.sk6) == -EAFNOSUPPORT) {
+	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), true);
+	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
 		recv_sockets.sk6 = NULL;
 		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
 		return 0;
 	}
 
-	if (IS_ERR(recv_sockets.sk6)) {
+	if (IS_ERR(sock)) {
 		recv_sockets.sk6 = NULL;
 		pr_err("Failed to create IPv6 UDP tunnel\n");
 		return -1;
 	}
+	recv_sockets.sk6 = sock;
 #endif
 	return 0;
 }
 
+int rxe_register_notifier(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&rxe_net_notifier);
+	if (err) {
+		pr_err("Failed to register netdev notifier\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 void rxe_net_exit(void)
 {
 	rxe_release_udp_tunnel(recv_sockets.sk6);
@@ -669,19 +701,12 @@ int rxe_net_init(void)
 {
 	int err;
 
-	recv_sockets.sk6 = NULL;
-
 	err = rxe_net_ipv4_init();
 	if (err)
 		return err;
 	err = rxe_net_ipv6_init();
 	if (err)
 		goto err_out;
-	err = register_netdevice_notifier(&rxe_net_notifier);
-	if (err) {
-		pr_err("Failed to register netdev notifier\n");
-		goto err_out;
-	}
 	return 0;
 err_out:
 	rxe_net_exit();
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index 45d80d00f86b..a222c3eeae12 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -18,6 +18,7 @@ struct rxe_recv_sockets {
 
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
 
+int rxe_register_notifier(void);
 int rxe_net_init(void);
 void rxe_net_exit(void);
 
-- 
2.27.0


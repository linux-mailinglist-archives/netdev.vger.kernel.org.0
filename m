Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212956EC0A0
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjDWOw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjDWOwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB1FE77;
        Sun, 23 Apr 2023 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261538; x=1713797538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e2wZ1GSb/c+S5rrGWT0XVZ9c/OmqNX0dETAkJ8gdOW0=;
  b=ezaIQ8LiuYYvyByczHZvNeaJybiETFsxcbUzEo59KNLDVuFS77Tgp/Qy
   IXwAdEBnVmnNu13ss0sRqI5iGSfvsFP33nnW+1gbq+KXMVl42g1WRI6VR
   nBJS593t6JaLASsw/HOGzA+wEjOw1iAKENAvHBNGuZVdMldOOvLoNdM3w
   zY3cTRnShWbStuizCWIFSbr4cr5sF/r6oSnhq5as16m1/tfhoN96/dzpR
   PY4XlD3aw+KE8l56SkWw8bfH8CJfl30vaVrzUENQEByOLxxVUnY0GHWL8
   09wX9u9q4OlG2tU3+RLMisn7wUTUyRMyA8U+t/GVE2xBVzoeVMeEZIdeT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890252"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890252"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680683"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680683"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:07 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 5/8] RDMA/rxe: Replace global variable with sock lookup functions
Date:   Sun, 23 Apr 2023 22:48:19 +0800
Message-Id: <20230423144822.1797465-6-yanjun.zhu@intel.com>
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

Originally a global variable is to keep the sock of udp listening
on port 4791. In fact, sock lookup functions can be used to get
the sock.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c       |  1 +
 drivers/infiniband/sw/rxe/rxe_net.c   | 58 ++++++++++++++++++++-------
 drivers/infiniband/sw/rxe/rxe_net.h   |  5 ---
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 4 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index ac7e7b0a9dc9..c9b3125b26d0 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -74,6 +74,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
+	rxe->l_sk6				= NULL;
 }
 
 /* initialize port attributes */
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 6071533d67c8..87af6a65a291 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -18,8 +18,6 @@
 #include "rxe_net.h"
 #include "rxe_loc.h"
 
-static struct rxe_recv_sockets recv_sockets;
-
 static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
 					 struct net_device *ndev,
 					 struct in_addr *saddr,
@@ -51,6 +49,23 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 {
 	struct dst_entry *ndst;
 	struct flowi6 fl6 = { { 0 } };
+	struct rxe_dev *rdev;
+
+	rdev = rxe_get_dev_from_net(ndev);
+	if (!rdev->l_sk6) {
+		struct sock *sk;
+
+		rcu_read_lock();
+		sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+		rcu_read_unlock();
+		if (!sk) {
+			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
+			return (struct dst_entry *)sk;
+		}
+		__sock_put(sk);
+		rdev->l_sk6 = sk->sk_socket;
+	}
+
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_oif = ndev->ifindex;
@@ -58,8 +73,8 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	ndst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(recv_sockets.sk6->sk),
-					       recv_sockets.sk6->sk, &fl6,
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(ndev),
+					       rdev->l_sk6->sk, &fl6,
 					       NULL);
 	if (IS_ERR(ndst)) {
 		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
@@ -536,15 +551,33 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 #define SK_REF_FOR_TUNNEL	2
 void rxe_net_del(struct ib_device *dev)
 {
-	if (refcount_read(&recv_sockets.sk6->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
-		__sock_put(recv_sockets.sk6->sk);
+	struct sock *sk;
+
+	rcu_read_lock();
+	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY), htons(ROCE_V2_UDP_DPORT), 0);
+	rcu_read_unlock();
+	if (!sk)
+		return;
+
+	__sock_put(sk);
+
+	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+		__sock_put(sk);
 	else
-		rxe_release_udp_tunnel(recv_sockets.sk6);
+		rxe_release_udp_tunnel(sk->sk_socket);
+
+	rcu_read_lock();
+	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+	rcu_read_unlock();
+	if (!sk)
+		return;
+
+	__sock_put(sk);
 
-	if (refcount_read(&recv_sockets.sk4->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
-		__sock_put(recv_sockets.sk4->sk);
+	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+		__sock_put(sk);
 	else
-		rxe_release_udp_tunnel(recv_sockets.sk4);
+		rxe_release_udp_tunnel(sk->sk_socket);
 }
 #undef SK_REF_FOR_TUNNEL
 
@@ -654,10 +687,8 @@ static int rxe_net_ipv4_init(void)
 	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(sock)) {
 		pr_err("Failed to create IPv4 UDP tunnel\n");
-		recv_sockets.sk4 = NULL;
 		return -1;
 	}
-	recv_sockets.sk4 = sock;
 
 	return 0;
 }
@@ -677,17 +708,14 @@ static int rxe_net_ipv6_init(void)
 
 	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), true);
 	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
-		recv_sockets.sk6 = NULL;
 		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
 		return 0;
 	}
 
 	if (IS_ERR(sock)) {
-		recv_sockets.sk6 = NULL;
 		pr_err("Failed to create IPv6 UDP tunnel\n");
 		return -1;
 	}
-	recv_sockets.sk6 = sock;
 #endif
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index f48f22f3353b..027b20e1bab6 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -11,11 +11,6 @@
 #include <net/if_inet6.h>
 #include <linux/module.h>
 
-struct rxe_recv_sockets {
-	struct socket *sk4;
-	struct socket *sk6;
-};
-
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
 void rxe_net_del(struct ib_device *dev);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 26a20f088692..0aa3817770a5 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -382,6 +382,7 @@ struct rxe_dev {
 
 	struct rxe_port		port;
 	struct crypto_shash	*tfm;
+	struct socket		*l_sk6;
 };
 
 static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
-- 
2.27.0


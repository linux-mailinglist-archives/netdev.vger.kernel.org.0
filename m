Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3865F5856
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJEQdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiJEQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:33:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7CB7E010;
        Wed,  5 Oct 2022 09:33:18 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="303182130"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="303182130"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 09:33:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="619518193"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="619518193"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2022 09:33:15 -0700
From:   yanjun.zhu@linux.dev
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCHv2 6/6] RDMA/rxe: add the support of net namespace
Date:   Thu,  6 Oct 2022 04:59:21 -0400
Message-Id: <20221006085921.1323148-7-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Originally init_net is used to indicate the current net namespace.
Currently more net namespaces are supported.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c     |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c | 32 +++++++++++++++++------------
 drivers/infiniband/sw/rxe/rxe_net.h |  2 +-
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 933d8e129c47..927c513ace81 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -196,7 +196,7 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 		goto err;
 	}
 
-	err = rxe_net_init();
+	err = rxe_net_init(ndev);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 64b11faccfb4..b5955d0c284a 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -31,7 +31,7 @@ static struct dst_entry *rxe_find_route4(struct net_device *ndev,
 	memcpy(&fl.daddr, daddr, sizeof(*daddr));
 	fl.flowi4_proto = IPPROTO_UDP;
 
-	rt = ip_route_output_key(&init_net, &fl);
+	rt = ip_route_output_key(dev_net(ndev), &fl);
 	if (IS_ERR(rt)) {
 		pr_err_ratelimited("no route to %pI4\n", &daddr->s_addr);
 		return NULL;
@@ -54,7 +54,8 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,
 		struct sock *sk;
 
 		rcu_read_lock();
-		sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+		sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
+				     htons(ROCE_V2_UDP_DPORT), 0);
 		rcu_read_unlock();
 		if (!sk) {
 			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
@@ -546,9 +547,13 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 void rxe_net_del(struct ib_device *dev)
 {
 	struct sock *sk;
+	struct rxe_dev *rdev;
+
+	rdev = container_of(dev, struct rxe_dev, ib_dev);
 
 	rcu_read_lock();
-	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY), htons(ROCE_V2_UDP_DPORT), 0);
+	sk = udp4_lib_lookup(dev_net(rdev->ndev), 0, 0, htonl(INADDR_ANY),
+			     htons(ROCE_V2_UDP_DPORT), 0);
 	rcu_read_unlock();
 	if (!sk)
 		return;
@@ -561,7 +566,8 @@ void rxe_net_del(struct ib_device *dev)
 		rxe_release_udp_tunnel(sk->sk_socket);
 
 	rcu_read_lock();
-	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+	sk = udp6_lib_lookup(dev_net(rdev->ndev), NULL, 0, &in6addr_any,
+			     htons(ROCE_V2_UDP_DPORT), 0);
 	rcu_read_unlock();
 	if (!sk)
 		return;
@@ -665,19 +671,19 @@ static struct notifier_block rxe_net_notifier = {
 	.notifier_call = rxe_notify,
 };
 
-static int rxe_net_ipv4_init(void)
+static int rxe_net_ipv4_init(struct net_device *ndev)
 {
 	struct sock *sk;
 	struct socket *sock;
 
 	rcu_read_lock();
-	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY),
+	sk = udp4_lib_lookup(dev_net(ndev), 0, 0, htonl(INADDR_ANY),
 			     htons(ROCE_V2_UDP_DPORT), 0);
 	rcu_read_unlock();
 	if (sk)
 		return 0;
 
-	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), false);
+	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(sock)) {
 		pr_err("Failed to create IPv4 UDP tunnel\n");
 		return -1;
@@ -686,20 +692,20 @@ static int rxe_net_ipv4_init(void)
 	return 0;
 }
 
-static int rxe_net_ipv6_init(void)
+static int rxe_net_ipv6_init(struct net_device *ndev)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct sock *sk;
 	struct socket *sock;
 
 	rcu_read_lock();
-	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any,
+	sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
 			     htons(ROCE_V2_UDP_DPORT), 0);
 	rcu_read_unlock();
 	if (sk)
 		return 0;
 
-	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), true);
+	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), true);
 	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
 		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
 		return 0;
@@ -731,14 +737,14 @@ void rxe_net_exit(void)
 	unregister_netdevice_notifier(&rxe_net_notifier);
 }
 
-int rxe_net_init(void)
+int rxe_net_init(struct net_device *ndev)
 {
 	int err;
 
-	err = rxe_net_ipv4_init();
+	err = rxe_net_ipv4_init(ndev);
 	if (err)
 		return err;
-	err = rxe_net_ipv6_init();
+	err = rxe_net_ipv6_init(ndev);
 	if (err)
 		goto err_out;
 	return 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index 027b20e1bab6..56249677d692 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -15,7 +15,7 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
 void rxe_net_del(struct ib_device *dev);
 
 int rxe_register_notifier(void);
-int rxe_net_init(void);
+int rxe_net_init(struct net_device *ndev);
 void rxe_net_exit(void);
 
 #endif /* RXE_NET_H */
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A006EC0A1
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjDWOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDWOwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823CAE79;
        Sun, 23 Apr 2023 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261538; x=1713797538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JObRfMcVM5YOGeuzHZkyGnqQkVgEuMQSSrQAay8qvIU=;
  b=ZtX3Jgeeg8NvtMTcCcu3BDCabDagQa3G5vJoKqVI7po+x5FRViYKxE94
   NkpI6dyMvbi07nHld7Qp62MDOyXn9PqsPImzy97eBeqextkGPgTlOjC5K
   j//xDAYjQ/VdANpBBPnpKAOoSf8TA7TCBmOYOaomJUN2katQRNABZcSim
   CqOFZ5FrgU/5PwCQJ7D2y1uDa2DdRNsv0kmKvrTmZqb/uv045F0Fw6uaq
   cuVAhuNkBa2efof1GE51aRXafqygLjEYZY8TDYpMEIE6rS8cQlJX4ekuD
   sEn9zJAhMT3qed9jXThp6lU5aSZQF5Mx+XPFOIOqFxr+rXdRHAJDBcbit
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890260"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890260"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680690"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680690"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:10 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 6/8] RDMA/rxe: add the support of net namespace
Date:   Sun, 23 Apr 2023 22:48:20 +0800
Message-Id: <20230423144822.1797465-7-yanjun.zhu@intel.com>
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

Originally init_net is used to indicate the current net namespace.
Currently more net namespaces are supported.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c     |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c | 33 +++++++++++++++++------------
 drivers/infiniband/sw/rxe/rxe_net.h |  2 +-
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c9b3125b26d0..ef632be05e38 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -198,7 +198,7 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 		goto err;
 	}
 
-	err = rxe_net_init();
+	err = rxe_net_init(ndev);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 87af6a65a291..0cf164da8299 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -32,7 +32,7 @@ static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
 	memcpy(&fl.daddr, daddr, sizeof(*daddr));
 	fl.flowi4_proto = IPPROTO_UDP;
 
-	rt = ip_route_output_key(&init_net, &fl);
+	rt = ip_route_output_key(dev_net(ndev), &fl);
 	if (IS_ERR(rt)) {
 		rxe_dbg_qp(qp, "no route to %pI4\n", &daddr->s_addr);
 		return NULL;
@@ -56,7 +56,8 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 		struct sock *sk;
 
 		rcu_read_lock();
-		sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+		sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
+				     htons(ROCE_V2_UDP_DPORT), 0);
 		rcu_read_unlock();
 		if (!sk) {
 			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
@@ -552,9 +553,13 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
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
@@ -567,7 +572,8 @@ void rxe_net_del(struct ib_device *dev)
 		rxe_release_udp_tunnel(sk->sk_socket);
 
 	rcu_read_lock();
-	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
+	sk = udp6_lib_lookup(dev_net(rdev->ndev), NULL, 0, &in6addr_any,
+			     htons(ROCE_V2_UDP_DPORT), 0);
 	rcu_read_unlock();
 	if (!sk)
 		return;
@@ -639,6 +645,7 @@ static int rxe_notify(struct notifier_block *not_blk,
 	switch (event) {
 	case NETDEV_UNREGISTER:
 		ib_unregister_device_queued(&rxe->ib_dev);
+		rxe_net_del(&rxe->ib_dev);
 		break;
 	case NETDEV_UP:
 		rxe_port_up(rxe);
@@ -672,19 +679,19 @@ static struct notifier_block rxe_net_notifier = {
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
@@ -693,20 +700,20 @@ static int rxe_net_ipv4_init(void)
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
@@ -738,14 +745,14 @@ void rxe_net_exit(void)
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


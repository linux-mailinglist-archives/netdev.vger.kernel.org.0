Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE91A1EEBD8
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgFDUYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:24:36 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:18372 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFDUYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:24:36 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 054KOH5q010281;
        Thu, 4 Jun 2020 13:24:17 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, borisp@mellanox.com, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next,v2] crypto/chtls:Fix compile error when CONFIG_IPV6 is disabled
Date:   Fri,  5 Jun 2020 01:53:44 +0530
Message-Id: <20200604202344.7728-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix compile errors,warnings when CONFIG_IPV6 is disabled and
inconsistent indenting.

v1->v2:
- Corrected errors/warnings reported when used newer gcc version,
  unused array.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.h        |  4 --
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 46 +++++++++++++++++------
 drivers/crypto/chelsio/chtls/chtls_main.c |  2 +
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index f58c2b5c7fc5..d4f6e010dc79 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -389,10 +389,6 @@ static inline void copy_hash_init_values(char *key, int digestsize)
 	}
 }
 
-static const u8 sgl_lengths[20] = {
-	0, 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11, 12, 13, 13, 14, 15
-};
-
 /* Number of len fields(8) * size of one addr field */
 #define PHYSDSGL_MAX_LEN_SIZE 16
 
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 9a642c79a657..f200fae6f7cb 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -93,8 +93,10 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
 	struct net_device *ndev = cdev->ports[0];
+#if IS_ENABLED(CONFIG_IPV6)
 	struct net_device *temp;
 	int addr_type;
+#endif
 
 	switch (sk->sk_family) {
 	case PF_INET:
@@ -102,19 +104,21 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 			return ndev;
 		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case PF_INET6:
 		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
 		if (likely(addr_type == IPV6_ADDR_ANY))
 			return ndev;
 
-	for_each_netdev_rcu(&init_net, temp) {
-		if (ipv6_chk_addr(&init_net, (struct in6_addr *)
-				  &sk->sk_v6_rcv_saddr, temp, 1)) {
-			ndev = temp;
-			break;
+		for_each_netdev_rcu(&init_net, temp) {
+			if (ipv6_chk_addr(&init_net, (struct in6_addr *)
+					  &sk->sk_v6_rcv_saddr, temp, 1)) {
+				ndev = temp;
+				break;
+			}
 		}
-	}
 	break;
+#endif
 	default:
 		return NULL;
 	}
@@ -476,8 +480,10 @@ void chtls_destroy_sock(struct sock *sk)
 	csk->cdev = NULL;
 	if (sk->sk_family == AF_INET)
 		sk->sk_prot = &tcp_prot;
+#if IS_ENABLED(CONFIG_IPV6)
 	else
 		sk->sk_prot = &tcpv6_prot;
+#endif
 	sk->sk_prot->destroy(sk);
 }
 
@@ -629,14 +635,15 @@ static void chtls_reset_synq(struct listen_ctx *listen_ctx)
 int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 {
 	struct net_device *ndev;
+#if IS_ENABLED(CONFIG_IPV6)
+	bool clip_valid = false;
+#endif
 	struct listen_ctx *ctx;
 	struct adapter *adap;
 	struct port_info *pi;
-	bool clip_valid;
+	int ret = 0;
 	int stid;
-	int ret;
 
-	clip_valid = false;
 	rcu_read_lock();
 	ndev = chtls_find_netdev(cdev, sk);
 	rcu_read_unlock();
@@ -674,6 +681,7 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 					  inet_sk(sk)->inet_rcv_saddr,
 					  inet_sk(sk)->inet_sport, 0,
 					  cdev->lldi->rxq_ids[0]);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		int addr_type;
 
@@ -689,6 +697,7 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 					   &sk->sk_v6_rcv_saddr,
 					   inet_sk(sk)->inet_sport,
 					   cdev->lldi->rxq_ids[0]);
+#endif
 	}
 	if (ret > 0)
 		ret = net_xmit_errno(ret);
@@ -696,8 +705,10 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 		goto del_hash;
 	return 0;
 del_hash:
+#if IS_ENABLED(CONFIG_IPV6)
 	if (clip_valid)
 		cxgb4_clip_release(ndev, (const u32 *)&sk->sk_v6_rcv_saddr, 1);
+#endif
 	listen_hash_del(cdev, sk);
 free_stid:
 	cxgb4_free_stid(cdev->tids, stid, sk->sk_family);
@@ -711,8 +722,6 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 {
 	struct listen_ctx *listen_ctx;
-	struct chtls_sock *csk;
-	int addr_type = 0;
 	int stid;
 
 	stid = listen_hash_del(cdev, sk);
@@ -725,7 +734,11 @@ void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 	cxgb4_remove_server(cdev->lldi->ports[0], stid,
 			    cdev->lldi->rxq_ids[0], sk->sk_family == PF_INET6);
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
+		struct chtls_sock *csk;
+		int addr_type = 0;
+
 		csk = rcu_dereference_sk_user_data(sk);
 		addr_type = ipv6_addr_type((const struct in6_addr *)
 					  &sk->sk_v6_rcv_saddr);
@@ -733,6 +746,7 @@ void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 			cxgb4_clip_release(csk->egress_dev, (const u32 *)
 					   &sk->sk_v6_rcv_saddr, 1);
 	}
+#endif
 	chtls_disconnect_acceptq(sk);
 }
 
@@ -941,9 +955,11 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	tp = tcp_sk(sk);
 	tcpoptsz = 0;
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
 		iphdrsz = sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
 	else
+#endif
 		iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
 	if (req->tcpopt.tstamp)
 		tcpoptsz += round_up(TCPOLEN_TIMESTAMP, 4);
@@ -1091,13 +1107,13 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 				    const struct cpl_pass_accept_req *req,
 				    struct chtls_dev *cdev)
 {
+	struct neighbour *n = NULL;
 	struct inet_sock *newinet;
 	const struct iphdr *iph;
 	struct tls_context *ctx;
 	struct net_device *ndev;
 	struct chtls_sock *csk;
 	struct dst_entry *dst;
-	struct neighbour *n;
 	struct tcp_sock *tp;
 	struct sock *newsk;
 	u16 port_id;
@@ -1115,6 +1131,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 			goto free_sk;
 
 		n = dst_neigh_lookup(dst, &iph->saddr);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		const struct ipv6hdr *ip6h;
 		struct flowi6 fl6;
@@ -1131,6 +1148,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		if (IS_ERR(dst))
 			goto free_sk;
 		n = dst_neigh_lookup(dst, &ip6h->saddr);
+#endif
 	}
 	if (!n)
 		goto free_sk;
@@ -1158,6 +1176,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		newinet->inet_daddr = iph->saddr;
 		newinet->inet_rcv_saddr = iph->daddr;
 		newinet->inet_saddr = iph->daddr;
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		struct tcp6_sock *newtcp6sk = (struct tcp6_sock *)newsk;
 		struct inet_request_sock *treq = inet_rsk(oreq);
@@ -1175,6 +1194,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		newinet->inet_opt = NULL;
 		newinet->inet_daddr = LOOPBACK4_IPV6;
 		newinet->inet_saddr = LOOPBACK4_IPV6;
+#endif
 	}
 
 	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
@@ -1337,10 +1357,12 @@ static void chtls_pass_accept_request(struct sock *sk,
 	if (iph->version == 0x4) {
 		chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
 		ip_dsfield = ipv4_get_dsfield(iph);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		inet_rsk(oreq)->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 		inet_rsk(oreq)->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 		ip_dsfield = ipv6_get_dsfield(ipv6_hdr(skb));
+#endif
 	}
 	if (req->tcpopt.wsf <= 14 &&
 	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 7dfffdde9593..d98b89d0fa6e 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -608,9 +608,11 @@ static void __init chtls_init_ulp_ops(void)
 	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
 	chtls_cpl_prot.setsockopt	= chtls_setsockopt;
 	chtls_cpl_prot.getsockopt	= chtls_getsockopt;
+#if IS_ENABLED(CONFIG_IPV6)
 	chtls_cpl_protv6		= chtls_cpl_prot;
 	chtls_init_rsk_ops(&chtls_cpl_protv6, &chtls_rsk_opsv6,
 			   &tcpv6_prot, PF_INET6);
+#endif
 }
 
 static int __init chtls_register(void)
-- 
2.25.4


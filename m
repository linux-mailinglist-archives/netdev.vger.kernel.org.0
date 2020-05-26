Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C34A1E139E
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbgEYRpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:45:32 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:42477 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYRpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:45:32 -0400
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04PHjLfk002771;
        Mon, 25 May 2020 10:45:22 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     borisp@mellanox.com, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next] crypto/chtls: IPv6 support for inline TLS
Date:   Mon, 25 May 2020 23:14:47 +0530
Message-Id: <20200525174447.3756-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extends support to IPv6 for Inline TLS server.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 195 +++++++++++++++++-----
 drivers/crypto/chelsio/chtls/chtls_cm.h   |   1 +
 drivers/crypto/chelsio/chtls/chtls_main.c |  14 +-
 net/ipv6/tcp_ipv6.c                       |   1 +
 4 files changed, 168 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index d5720a859443..9a642c79a657 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -18,13 +18,20 @@
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/if_vlan.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/transp_v6.h>
+#include <net/ip6_route.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/dst.h>
 #include <net/tls.h>
+#include <net/addrconf.h>
+#include <net/secure_seq.h>
 
 #include "chtls.h"
 #include "chtls_cm.h"
+#include "clip_tbl.h"
 
 /*
  * State transitions and actions for close.  Note that if we are in SYN_SENT
@@ -82,15 +89,36 @@ static void chtls_sock_release(struct kref *ref)
 	kfree(csk);
 }
 
-static struct net_device *chtls_ipv4_netdev(struct chtls_dev *cdev,
+static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
 	struct net_device *ndev = cdev->ports[0];
+	struct net_device *temp;
+	int addr_type;
+
+	switch (sk->sk_family) {
+	case PF_INET:
+		if (likely(!inet_sk(sk)->inet_rcv_saddr))
+			return ndev;
+		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
+		break;
+	case PF_INET6:
+		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+		if (likely(addr_type == IPV6_ADDR_ANY))
+			return ndev;
+
+	for_each_netdev_rcu(&init_net, temp) {
+		if (ipv6_chk_addr(&init_net, (struct in6_addr *)
+				  &sk->sk_v6_rcv_saddr, temp, 1)) {
+			ndev = temp;
+			break;
+		}
+	}
+	break;
+	default:
+		return NULL;
+	}
 
-	if (likely(!inet_sk(sk)->inet_rcv_saddr))
-		return ndev;
-
-	ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
 	if (!ndev)
 		return NULL;
 
@@ -446,7 +474,10 @@ void chtls_destroy_sock(struct sock *sk)
 	free_tls_keyid(sk);
 	kref_put(&csk->kref, chtls_sock_release);
 	csk->cdev = NULL;
-	sk->sk_prot = &tcp_prot;
+	if (sk->sk_family == AF_INET)
+		sk->sk_prot = &tcp_prot;
+	else
+		sk->sk_prot = &tcpv6_prot;
 	sk->sk_prot->destroy(sk);
 }
 
@@ -473,7 +504,8 @@ static void chtls_disconnect_acceptq(struct sock *listen_sk)
 	while (*pprev) {
 		struct request_sock *req = *pprev;
 
-		if (req->rsk_ops == &chtls_rsk_ops) {
+		if (req->rsk_ops == &chtls_rsk_ops ||
+		    req->rsk_ops == &chtls_rsk_opsv6) {
 			struct sock *child = req->sk;
 
 			*pprev = req->dl_next;
@@ -600,14 +632,13 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 	struct listen_ctx *ctx;
 	struct adapter *adap;
 	struct port_info *pi;
+	bool clip_valid;
 	int stid;
 	int ret;
 
-	if (sk->sk_family != PF_INET)
-		return -EAGAIN;
-
+	clip_valid = false;
 	rcu_read_lock();
-	ndev = chtls_ipv4_netdev(cdev, sk);
+	ndev = chtls_find_netdev(cdev, sk);
 	rcu_read_unlock();
 	if (!ndev)
 		return -EBADF;
@@ -638,16 +669,35 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 	if (!listen_hash_add(cdev, sk, stid))
 		goto free_stid;
 
-	ret = cxgb4_create_server(ndev, stid,
-				  inet_sk(sk)->inet_rcv_saddr,
-				  inet_sk(sk)->inet_sport, 0,
-				  cdev->lldi->rxq_ids[0]);
+	if (sk->sk_family == PF_INET) {
+		ret = cxgb4_create_server(ndev, stid,
+					  inet_sk(sk)->inet_rcv_saddr,
+					  inet_sk(sk)->inet_sport, 0,
+					  cdev->lldi->rxq_ids[0]);
+	} else {
+		int addr_type;
+
+		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+		if (addr_type != IPV6_ADDR_ANY) {
+			ret = cxgb4_clip_get(ndev, (const u32 *)
+					     &sk->sk_v6_rcv_saddr, 1);
+			if (ret)
+				goto del_hash;
+			clip_valid = true;
+		}
+		ret = cxgb4_create_server6(ndev, stid,
+					   &sk->sk_v6_rcv_saddr,
+					   inet_sk(sk)->inet_sport,
+					   cdev->lldi->rxq_ids[0]);
+	}
 	if (ret > 0)
 		ret = net_xmit_errno(ret);
 	if (ret)
 		goto del_hash;
 	return 0;
 del_hash:
+	if (clip_valid)
+		cxgb4_clip_release(ndev, (const u32 *)&sk->sk_v6_rcv_saddr, 1);
 	listen_hash_del(cdev, sk);
 free_stid:
 	cxgb4_free_stid(cdev->tids, stid, sk->sk_family);
@@ -661,6 +711,8 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 {
 	struct listen_ctx *listen_ctx;
+	struct chtls_sock *csk;
+	int addr_type = 0;
 	int stid;
 
 	stid = listen_hash_del(cdev, sk);
@@ -671,7 +723,16 @@ void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 	chtls_reset_synq(listen_ctx);
 
 	cxgb4_remove_server(cdev->lldi->ports[0], stid,
-			    cdev->lldi->rxq_ids[0], 0);
+			    cdev->lldi->rxq_ids[0], sk->sk_family == PF_INET6);
+
+	if (sk->sk_family == PF_INET6) {
+		csk = rcu_dereference_sk_user_data(sk);
+		addr_type = ipv6_addr_type((const struct in6_addr *)
+					  &sk->sk_v6_rcv_saddr);
+		if (addr_type != IPV6_ADDR_ANY)
+			cxgb4_clip_release(csk->egress_dev, (const u32 *)
+					   &sk->sk_v6_rcv_saddr, 1);
+	}
 	chtls_disconnect_acceptq(sk);
 }
 
@@ -880,7 +941,10 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	tp = tcp_sk(sk);
 	tcpoptsz = 0;
 
-	iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
+	if (sk->sk_family == AF_INET6)
+		iphdrsz = sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
+	else
+		iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
 	if (req->tcpopt.tstamp)
 		tcpoptsz += round_up(TCPOLEN_TIMESTAMP, 4);
 
@@ -1045,11 +1109,29 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	if (!newsk)
 		goto free_oreq;
 
-	dst = inet_csk_route_child_sock(lsk, newsk, oreq);
-	if (!dst)
-		goto free_sk;
+	if (lsk->sk_family == AF_INET) {
+		dst = inet_csk_route_child_sock(lsk, newsk, oreq);
+		if (!dst)
+			goto free_sk;
 
-	n = dst_neigh_lookup(dst, &iph->saddr);
+		n = dst_neigh_lookup(dst, &iph->saddr);
+	} else {
+		const struct ipv6hdr *ip6h;
+		struct flowi6 fl6;
+
+		ip6h = (const struct ipv6hdr *)network_hdr;
+		memset(&fl6, 0, sizeof(fl6));
+		fl6.flowi6_proto = IPPROTO_TCP;
+		fl6.saddr = ip6h->daddr;
+		fl6.daddr = ip6h->saddr;
+		fl6.fl6_dport = inet_rsk(oreq)->ir_rmt_port;
+		fl6.fl6_sport = htons(inet_rsk(oreq)->ir_num);
+		security_req_classify_flow(oreq, flowi6_to_flowi(&fl6));
+		dst = ip6_dst_lookup_flow(sock_net(lsk), lsk, &fl6, NULL);
+		if (IS_ERR(dst))
+			goto free_sk;
+		n = dst_neigh_lookup(dst, &ip6h->saddr);
+	}
 	if (!n)
 		goto free_sk;
 
@@ -1072,9 +1154,28 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	tp = tcp_sk(newsk);
 	newinet = inet_sk(newsk);
 
-	newinet->inet_daddr = iph->saddr;
-	newinet->inet_rcv_saddr = iph->daddr;
-	newinet->inet_saddr = iph->daddr;
+	if (iph->version == 0x4) {
+		newinet->inet_daddr = iph->saddr;
+		newinet->inet_rcv_saddr = iph->daddr;
+		newinet->inet_saddr = iph->daddr;
+	} else {
+		struct tcp6_sock *newtcp6sk = (struct tcp6_sock *)newsk;
+		struct inet_request_sock *treq = inet_rsk(oreq);
+		struct ipv6_pinfo *newnp = inet6_sk(newsk);
+		struct ipv6_pinfo *np = inet6_sk(lsk);
+
+		inet_sk(newsk)->pinet6 = &newtcp6sk->inet6;
+		memcpy(newnp, np, sizeof(struct ipv6_pinfo));
+		newsk->sk_v6_daddr = treq->ir_v6_rmt_addr;
+		newsk->sk_v6_rcv_saddr = treq->ir_v6_loc_addr;
+		inet6_sk(newsk)->saddr = treq->ir_v6_loc_addr;
+		newnp->ipv6_fl_list = NULL;
+		newnp->pktoptions = NULL;
+		newsk->sk_bound_dev_if = treq->ir_iif;
+		newinet->inet_opt = NULL;
+		newinet->inet_daddr = LOOPBACK4_IPV6;
+		newinet->inet_saddr = LOOPBACK4_IPV6;
+	}
 
 	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
 	sk_setup_caps(newsk, dst);
@@ -1156,6 +1257,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	struct sk_buff *reply_skb;
 	struct chtls_sock *csk;
 	struct chtls_dev *cdev;
+	struct ipv6hdr *ip6h;
 	struct tcphdr *tcph;
 	struct sock *newsk;
 	struct ethhdr *eh;
@@ -1196,37 +1298,50 @@ static void chtls_pass_accept_request(struct sock *sk,
 	if (sk_acceptq_is_full(sk))
 		goto reject;
 
-	oreq = inet_reqsk_alloc(&chtls_rsk_ops, sk, true);
-	if (!oreq)
-		goto reject;
-
-	oreq->rsk_rcv_wnd = 0;
-	oreq->rsk_window_clamp = 0;
-	oreq->cookie_ts = 0;
-	oreq->mss = 0;
-	oreq->ts_recent = 0;
 
 	eth_hdr_len = T6_ETH_HDR_LEN_G(ntohl(req->hdr_len));
 	if (eth_hdr_len == ETH_HLEN) {
 		eh = (struct ethhdr *)(req + 1);
 		iph = (struct iphdr *)(eh + 1);
+		ip6h = (struct ipv6hdr *)(eh + 1);
 		network_hdr = (void *)(eh + 1);
 	} else {
 		vlan_eh = (struct vlan_ethhdr *)(req + 1);
 		iph = (struct iphdr *)(vlan_eh + 1);
+		ip6h = (struct ipv6hdr *)(vlan_eh + 1);
 		network_hdr = (void *)(vlan_eh + 1);
 	}
-	if (iph->version != 0x4)
-		goto free_oreq;
 
-	tcph = (struct tcphdr *)(iph + 1);
-	skb_set_network_header(skb, (void *)iph - (void *)req);
+	if (iph->version == 0x4) {
+		tcph = (struct tcphdr *)(iph + 1);
+		skb_set_network_header(skb, (void *)iph - (void *)req);
+		oreq = inet_reqsk_alloc(&chtls_rsk_ops, sk, true);
+	} else {
+		tcph = (struct tcphdr *)(ip6h + 1);
+		skb_set_network_header(skb, (void *)ip6h - (void *)req);
+		oreq = inet_reqsk_alloc(&chtls_rsk_opsv6, sk, false);
+	}
+
+	if (!oreq)
+		goto reject;
+
+	oreq->rsk_rcv_wnd = 0;
+	oreq->rsk_window_clamp = 0;
+	oreq->cookie_ts = 0;
+	oreq->mss = 0;
+	oreq->ts_recent = 0;
 
 	tcp_rsk(oreq)->tfo_listener = false;
 	tcp_rsk(oreq)->rcv_isn = ntohl(tcph->seq);
 	chtls_set_req_port(oreq, tcph->source, tcph->dest);
-	chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
-	ip_dsfield = ipv4_get_dsfield(iph);
+	if (iph->version == 0x4) {
+		chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
+		ip_dsfield = ipv4_get_dsfield(iph);
+	} else {
+		inet_rsk(oreq)->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
+		inet_rsk(oreq)->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+		ip_dsfield = ipv6_get_dsfield(ipv6_hdr(skb));
+	}
 	if (req->tcpopt.wsf <= 14 &&
 	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
 		inet_rsk(oreq)->wscale_ok = 1;
@@ -1243,7 +1358,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-		goto reject;
+		goto free_oreq;
 
 	if (chtls_get_module(newsk))
 		goto reject;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index 3fac0c74a41f..47ba81e42f5d 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -79,6 +79,7 @@ enum {
 
 typedef void (*defer_handler_t)(struct chtls_dev *dev, struct sk_buff *skb);
 extern struct request_sock_ops chtls_rsk_ops;
+extern struct request_sock_ops chtls_rsk_opsv6;
 
 struct deferred_skb_cb {
 	defer_handler_t handler;
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 2110d0893bc7..7dfffdde9593 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -13,6 +13,8 @@
 #include <linux/net.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <net/ipv6.h>
+#include <net/transp_v6.h>
 #include <net/tcp.h>
 #include <net/tls.h>
 
@@ -30,8 +32,8 @@ static DEFINE_MUTEX(cdev_mutex);
 
 static DEFINE_MUTEX(notify_mutex);
 static RAW_NOTIFIER_HEAD(listen_notify_list);
-static struct proto chtls_cpl_prot;
-struct request_sock_ops chtls_rsk_ops;
+static struct proto chtls_cpl_prot, chtls_cpl_protv6;
+struct request_sock_ops chtls_rsk_ops, chtls_rsk_opsv6;
 static uint send_page_order = (14 - PAGE_SHIFT < 0) ? 0 : 14 - PAGE_SHIFT;
 
 static void register_listen_notifier(struct notifier_block *nb)
@@ -586,7 +588,10 @@ static struct cxgb4_uld_info chtls_uld_info = {
 
 void chtls_install_cpl_ops(struct sock *sk)
 {
-	sk->sk_prot = &chtls_cpl_prot;
+	if (sk->sk_family == AF_INET)
+		sk->sk_prot = &chtls_cpl_prot;
+	else
+		sk->sk_prot = &chtls_cpl_protv6;
 }
 
 static void __init chtls_init_ulp_ops(void)
@@ -603,6 +608,9 @@ static void __init chtls_init_ulp_ops(void)
 	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
 	chtls_cpl_prot.setsockopt	= chtls_setsockopt;
 	chtls_cpl_prot.getsockopt	= chtls_getsockopt;
+	chtls_cpl_protv6		= chtls_cpl_prot;
+	chtls_init_rsk_ops(&chtls_cpl_protv6, &chtls_rsk_opsv6,
+			   &tcpv6_prot, PF_INET6);
 }
 
 static int __init chtls_register(void)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 413b3425ac66..456cb6648c05 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2110,6 +2110,7 @@ struct proto tcpv6_prot = {
 #endif
 	.diag_destroy		= tcp_abort,
 };
+EXPORT_SYMBOL(tcpv6_prot);
 
 /* thinking of making this const? Don't.
  * early_demux can change based on sysctl.
-- 
2.18.1


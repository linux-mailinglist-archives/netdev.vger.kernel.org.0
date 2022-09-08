Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286035B11E6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiIHBL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIHBL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:11:56 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11C7C6B62
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662599514; x=1694135514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xcE7vhV9YEBnhdHIACLvvZqif8PLkCyAm36Y8RnnBbw=;
  b=Qq0aYfw2opI5df3+LlHMvc/5cPuhps/Q32dxoZfmFQhqGDTJAld9P4LG
   +6ryNd8o5geJdX0KPUBBOCqHqMFWAdQWSfK49Rf3x5ap4gvoYLXoHUEJp
   r+ucvzlX4YrTTdS/6gdvBJeeLVmzOEvvqhpogb4TmUsDpWEySVj0bRtjF
   4=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="257267215"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:11:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 796BD451AB;
        Thu,  8 Sep 2022 01:11:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 01:11:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 01:11:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 net-next 4/6] tcp: Access &tcp_hashinfo via net.
Date:   Wed, 7 Sep 2022 18:10:20 -0700
Message-ID: <20220908011022.45342-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
References: <20220908011022.45342-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will soon introduce an optional per-netns ehash.

This means we cannot use tcp_hashinfo directly in most places.

Instead, access it via net->ipv4.tcp_death_row.hashinfo.

The access will be valid only while initialising tcp_hashinfo
itself and creating/destroying each netns.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |  5 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  5 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |  5 +-
 net/core/filter.c                             |  5 +-
 net/ipv4/esp4.c                               |  3 +-
 net/ipv4/inet_hashtables.c                    |  2 +-
 net/ipv4/netfilter/nf_socket_ipv4.c           |  4 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c           | 16 ++---
 net/ipv4/tcp_diag.c                           | 18 ++++-
 net/ipv4/tcp_ipv4.c                           | 72 +++++++++++--------
 net/ipv4/tcp_minisocks.c                      |  2 +-
 net/ipv6/esp6.c                               |  3 +-
 net/ipv6/inet6_hashtables.c                   |  4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |  4 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c           |  8 +--
 net/ipv6/tcp_ipv6.c                           | 23 +++---
 net/mptcp/mptcp_diag.c                        |  7 +-
 17 files changed, 108 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index ddfe9208529a..f90bfba4b303 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1069,8 +1069,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
 	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
 }
 
-static void inet_inherit_port(struct inet_hashinfo *hash_info,
-			      struct sock *lsk, struct sock *newsk)
+static void inet_inherit_port(struct sock *lsk, struct sock *newsk)
 {
 	local_bh_disable();
 	__inet_inherit_port(lsk, newsk);
@@ -1240,7 +1239,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 						     ipv4.sysctl_tcp_window_scaling),
 					   tp->window_clamp);
 	neigh_release(n);
-	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
+	inet_inherit_port(lsk, newsk);
 	csk_set_flag(csk, CSK_CONN_INLINE);
 	bh_unlock_sock(newsk); /* tcp_create_openreq_child ->sk_clone_lock */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 13145ecaf839..5203393adf88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -461,6 +461,7 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
 	struct net_device *netdev = rq->netdev;
+	struct net *net = dev_net(netdev);
 	struct sock *sk = NULL;
 	unsigned int datalen;
 	struct iphdr *iph;
@@ -475,7 +476,7 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 		depth += sizeof(struct iphdr);
 		th = (void *)iph + sizeof(struct iphdr);
 
-		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
+		sk = inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 					     iph->saddr, th->source, iph->daddr,
 					     th->dest, netdev->ifindex);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -485,7 +486,7 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 		depth += sizeof(struct ipv6hdr);
 		th = (void *)ipv6h + sizeof(struct ipv6hdr);
 
-		sk = __inet6_lookup_established(dev_net(netdev), &tcp_hashinfo,
+		sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 						&ipv6h->saddr, th->source,
 						&ipv6h->daddr, ntohs(th->dest),
 						netdev->ifindex, 0);
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 78368e71ce83..f80f1a6953fa 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -474,6 +474,7 @@ int nfp_net_tls_rx_resync_req(struct net_device *netdev,
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	struct nfp_net_tls_offload_ctx *ntls;
+	struct net *net = dev_net(netdev);
 	struct ipv6hdr *ipv6h;
 	struct tcphdr *th;
 	struct iphdr *iph;
@@ -494,13 +495,13 @@ int nfp_net_tls_rx_resync_req(struct net_device *netdev,
 
 	switch (ipv6h->version) {
 	case 4:
-		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
+		sk = inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 					     iph->saddr, th->source, iph->daddr,
 					     th->dest, netdev->ifindex);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case 6:
-		sk = __inet6_lookup_established(dev_net(netdev), &tcp_hashinfo,
+		sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 						&ipv6h->saddr, th->source,
 						&ipv6h->daddr, ntohs(th->dest),
 						netdev->ifindex, 0);
diff --git a/net/core/filter.c b/net/core/filter.c
index e872f45399b0..31608801078e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6373,6 +6373,7 @@ static const struct bpf_func_proto bpf_lwt_seg6_adjust_srh_proto = {
 static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 			      int dif, int sdif, u8 family, u8 proto)
 {
+	struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row.hashinfo;
 	bool refcounted = false;
 	struct sock *sk = NULL;
 
@@ -6381,7 +6382,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 		__be32 dst4 = tuple->ipv4.daddr;
 
 		if (proto == IPPROTO_TCP)
-			sk = __inet_lookup(net, &tcp_hashinfo, NULL, 0,
+			sk = __inet_lookup(net, hinfo, NULL, 0,
 					   src4, tuple->ipv4.sport,
 					   dst4, tuple->ipv4.dport,
 					   dif, sdif, &refcounted);
@@ -6395,7 +6396,7 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 		struct in6_addr *dst6 = (struct in6_addr *)&tuple->ipv6.daddr;
 
 		if (proto == IPPROTO_TCP)
-			sk = __inet6_lookup(net, &tcp_hashinfo, NULL, 0,
+			sk = __inet6_lookup(net, hinfo, NULL, 0,
 					    src6, tuple->ipv6.sport,
 					    dst6, ntohs(tuple->ipv6.dport),
 					    dif, sdif, &refcounted);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 5c03eba787e5..6be0f8903be1 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -134,6 +134,7 @@ static void esp_free_tcp_sk(struct rcu_head *head)
 static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
 {
 	struct xfrm_encap_tmpl *encap = x->encap;
+	struct net *net = xs_net(x);
 	struct esp_tcp_sk *esk;
 	__be16 sport, dport;
 	struct sock *nsk;
@@ -160,7 +161,7 @@ static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
 	}
 	spin_unlock_bh(&x->lock);
 
-	sk = inet_lookup_established(xs_net(x), &tcp_hashinfo, x->id.daddr.a4,
+	sk = inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo, x->id.daddr.a4,
 				     dport, x->props.saddr.a4, sport, 0);
 	if (!sk)
 		return ERR_PTR(-ENOENT);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index bdb5427a7a3d..c440de998910 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -386,7 +386,7 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (hashinfo != &tcp_hashinfo)
+	if (hashinfo != net->ipv4.tcp_death_row.hashinfo)
 		return NULL; /* only TCP is supported */
 
 	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP, saddr, sport,
diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index 2d42e4c35a20..a1350fc25838 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -71,8 +71,8 @@ nf_socket_get_sock_v4(struct net *net, struct sk_buff *skb, const int doff,
 {
 	switch (protocol) {
 	case IPPROTO_TCP:
-		return inet_lookup(net, &tcp_hashinfo, skb, doff,
-				   saddr, sport, daddr, dport,
+		return inet_lookup(net, net->ipv4.tcp_death_row.hashinfo,
+				   skb, doff, saddr, sport, daddr, dport,
 				   in->ifindex);
 	case IPPROTO_UDP:
 		return udp4_lib_lookup(net, saddr, sport, daddr, dport,
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index b2bae0b0e42a..b22b2c745c76 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -79,6 +79,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		      const struct net_device *in,
 		      const enum nf_tproxy_lookup_t lookup_type)
 {
+	struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row.hashinfo;
 	struct sock *sk;
 
 	switch (protocol) {
@@ -92,12 +93,10 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 
 		switch (lookup_type) {
 		case NF_TPROXY_LOOKUP_LISTENER:
-			sk = inet_lookup_listener(net, &tcp_hashinfo, skb,
-						    ip_hdrlen(skb) +
-						      __tcp_hdrlen(hp),
-						    saddr, sport,
-						    daddr, dport,
-						    in->ifindex, 0);
+			sk = inet_lookup_listener(net, hinfo, skb,
+						  ip_hdrlen(skb) + __tcp_hdrlen(hp),
+						  saddr, sport, daddr, dport,
+						  in->ifindex, 0);
 
 			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 				sk = NULL;
@@ -108,9 +107,8 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 			 */
 			break;
 		case NF_TPROXY_LOOKUP_ESTABLISHED:
-			sk = inet_lookup_established(net, &tcp_hashinfo,
-						    saddr, sport, daddr, dport,
-						    in->ifindex);
+			sk = inet_lookup_established(net, hinfo, saddr, sport,
+						     daddr, dport, in->ifindex);
 			break;
 		default:
 			BUG();
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 75a1c985f49a..01b50fa79189 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -181,13 +181,21 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 static void tcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			  const struct inet_diag_req_v2 *r)
 {
-	inet_diag_dump_icsk(&tcp_hashinfo, skb, cb, r);
+	struct inet_hashinfo *hinfo;
+
+	hinfo = sock_net(cb->skb->sk)->ipv4.tcp_death_row.hashinfo;
+
+	inet_diag_dump_icsk(hinfo, skb, cb, r);
 }
 
 static int tcp_diag_dump_one(struct netlink_callback *cb,
 			     const struct inet_diag_req_v2 *req)
 {
-	return inet_diag_dump_one_icsk(&tcp_hashinfo, cb, req);
+	struct inet_hashinfo *hinfo;
+
+	hinfo = sock_net(cb->skb->sk)->ipv4.tcp_death_row.hashinfo;
+
+	return inet_diag_dump_one_icsk(hinfo, cb, req);
 }
 
 #ifdef CONFIG_INET_DIAG_DESTROY
@@ -195,9 +203,13 @@ static int tcp_diag_destroy(struct sk_buff *in_skb,
 			    const struct inet_diag_req_v2 *req)
 {
 	struct net *net = sock_net(in_skb->sk);
-	struct sock *sk = inet_diag_find_one_icsk(net, &tcp_hashinfo, req);
+	struct inet_hashinfo *hinfo;
+	struct sock *sk;
 	int err;
 
+	hinfo = net->ipv4.tcp_death_row.hashinfo;
+	sk = inet_diag_find_one_icsk(net, hinfo, req);
+
 	if (IS_ERR(sk))
 		return PTR_ERR(sk);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3bb7da95b757..9aa186af6c44 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -248,9 +248,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (!inet_opt || !inet_opt->opt.srr)
 		daddr = fl4->daddr;
 
+	tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
+
 	if (!inet->inet_saddr) {
 		if (inet_csk(sk)->icsk_bind2_hash) {
-			prev_addr_hashbucket = inet_bhashfn_portaddr(&tcp_hashinfo,
+			prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
 								     sk, net, inet->inet_num);
 			prev_sk_rcv_saddr = sk->sk_rcv_saddr;
 		}
@@ -292,7 +294,6 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * complete initialization after this.
 	 */
 	tcp_set_state(sk, TCP_SYN_SENT);
-	tcp_death_row = &net->ipv4.tcp_death_row;
 	err = inet_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto failure;
@@ -494,9 +495,9 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	int err;
 	struct net *net = dev_net(skb->dev);
 
-	sk = __inet_lookup_established(net, &tcp_hashinfo, iph->daddr,
-				       th->dest, iph->saddr, ntohs(th->source),
-				       inet_iif(skb), 0);
+	sk = __inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
+				       iph->daddr, th->dest, iph->saddr,
+				       ntohs(th->source), inet_iif(skb), 0);
 	if (!sk) {
 		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 		return -ENOENT;
@@ -759,8 +760,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 * Incoming packet is checked with md5 hash with finding key,
 		 * no RST generated if md5 hash doesn't match.
 		 */
-		sk1 = __inet_lookup_listener(net, &tcp_hashinfo, NULL, 0,
-					     ip_hdr(skb)->saddr,
+		sk1 = __inet_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
+					     NULL, 0, ip_hdr(skb)->saddr,
 					     th->source, ip_hdr(skb)->daddr,
 					     ntohs(th->source), dif, sdif);
 		/* don't send rst if it can't find key */
@@ -1728,6 +1729,7 @@ EXPORT_SYMBOL(tcp_v4_do_rcv);
 
 int tcp_v4_early_demux(struct sk_buff *skb)
 {
+	struct net *net = dev_net(skb->dev);
 	const struct iphdr *iph;
 	const struct tcphdr *th;
 	struct sock *sk;
@@ -1744,7 +1746,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 	if (th->doff < sizeof(struct tcphdr) / 4)
 		return 0;
 
-	sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
+	sk = __inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 				       iph->saddr, th->source,
 				       iph->daddr, ntohs(th->dest),
 				       skb->skb_iif, inet_sdif(skb));
@@ -1970,7 +1972,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 lookup:
-	sk = __inet_lookup_skb(&tcp_hashinfo, skb, __tcp_hdrlen(th), th->source,
+	sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
+			       skb, __tcp_hdrlen(th), th->source,
 			       th->dest, sdif, &refcounted);
 	if (!sk)
 		goto no_tcp_socket;
@@ -2152,9 +2155,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
 	case TCP_TW_SYN: {
-		struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
-							&tcp_hashinfo, skb,
-							__tcp_hdrlen(th),
+		struct sock *sk2 = inet_lookup_listener(net,
+							net->ipv4.tcp_death_row.hashinfo,
+							skb, __tcp_hdrlen(th),
 							iph->saddr, th->source,
 							iph->daddr, th->dest,
 							inet_iif(skb),
@@ -2304,15 +2307,16 @@ static bool seq_sk_match(struct seq_file *seq, const struct sock *sk)
  */
 static void *listening_get_first(struct seq_file *seq)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct tcp_iter_state *st = seq->private;
 
 	st->offset = 0;
-	for (; st->bucket <= tcp_hashinfo.lhash2_mask; st->bucket++) {
+	for (; st->bucket <= hinfo->lhash2_mask; st->bucket++) {
 		struct inet_listen_hashbucket *ilb2;
 		struct hlist_nulls_node *node;
 		struct sock *sk;
 
-		ilb2 = &tcp_hashinfo.lhash2[st->bucket];
+		ilb2 = &hinfo->lhash2[st->bucket];
 		if (hlist_nulls_empty(&ilb2->nulls_head))
 			continue;
 
@@ -2337,6 +2341,7 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	struct tcp_iter_state *st = seq->private;
 	struct inet_listen_hashbucket *ilb2;
 	struct hlist_nulls_node *node;
+	struct inet_hashinfo *hinfo;
 	struct sock *sk = cur;
 
 	++st->num;
@@ -2348,7 +2353,8 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 			return sk;
 	}
 
-	ilb2 = &tcp_hashinfo.lhash2[st->bucket];
+	hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
+	ilb2 = &hinfo->lhash2[st->bucket];
 	spin_unlock(&ilb2->lock);
 	++st->bucket;
 	return listening_get_first(seq);
@@ -2370,9 +2376,10 @@ static void *listening_get_idx(struct seq_file *seq, loff_t *pos)
 	return rc;
 }
 
-static inline bool empty_bucket(const struct tcp_iter_state *st)
+static inline bool empty_bucket(struct inet_hashinfo *hinfo,
+				const struct tcp_iter_state *st)
 {
-	return hlist_nulls_empty(&tcp_hashinfo.ehash[st->bucket].chain);
+	return hlist_nulls_empty(&hinfo->ehash[st->bucket].chain);
 }
 
 /*
@@ -2381,20 +2388,21 @@ static inline bool empty_bucket(const struct tcp_iter_state *st)
  */
 static void *established_get_first(struct seq_file *seq)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct tcp_iter_state *st = seq->private;
 
 	st->offset = 0;
-	for (; st->bucket <= tcp_hashinfo.ehash_mask; ++st->bucket) {
+	for (; st->bucket <= hinfo->ehash_mask; ++st->bucket) {
 		struct sock *sk;
 		struct hlist_nulls_node *node;
-		spinlock_t *lock = inet_ehash_lockp(&tcp_hashinfo, st->bucket);
+		spinlock_t *lock = inet_ehash_lockp(hinfo, st->bucket);
 
 		/* Lockless fast path for the common case of empty buckets */
-		if (empty_bucket(st))
+		if (empty_bucket(hinfo, st))
 			continue;
 
 		spin_lock_bh(lock);
-		sk_nulls_for_each(sk, node, &tcp_hashinfo.ehash[st->bucket].chain) {
+		sk_nulls_for_each(sk, node, &hinfo->ehash[st->bucket].chain) {
 			if (seq_sk_match(seq, sk))
 				return sk;
 		}
@@ -2406,6 +2414,7 @@ static void *established_get_first(struct seq_file *seq)
 
 static void *established_get_next(struct seq_file *seq, void *cur)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct tcp_iter_state *st = seq->private;
 	struct hlist_nulls_node *node;
 	struct sock *sk = cur;
@@ -2420,7 +2429,7 @@ static void *established_get_next(struct seq_file *seq, void *cur)
 			return sk;
 	}
 
-	spin_unlock_bh(inet_ehash_lockp(&tcp_hashinfo, st->bucket));
+	spin_unlock_bh(inet_ehash_lockp(hinfo, st->bucket));
 	++st->bucket;
 	return established_get_first(seq);
 }
@@ -2458,6 +2467,7 @@ static void *tcp_get_idx(struct seq_file *seq, loff_t pos)
 
 static void *tcp_seek_last_pos(struct seq_file *seq)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct tcp_iter_state *st = seq->private;
 	int bucket = st->bucket;
 	int offset = st->offset;
@@ -2466,7 +2476,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 
 	switch (st->state) {
 	case TCP_SEQ_STATE_LISTENING:
-		if (st->bucket > tcp_hashinfo.lhash2_mask)
+		if (st->bucket > hinfo->lhash2_mask)
 			break;
 		st->state = TCP_SEQ_STATE_LISTENING;
 		rc = listening_get_first(seq);
@@ -2478,7 +2488,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 		st->state = TCP_SEQ_STATE_ESTABLISHED;
 		fallthrough;
 	case TCP_SEQ_STATE_ESTABLISHED:
-		if (st->bucket > tcp_hashinfo.ehash_mask)
+		if (st->bucket > hinfo->ehash_mask)
 			break;
 		rc = established_get_first(seq);
 		while (offset-- && rc && bucket == st->bucket)
@@ -2546,16 +2556,17 @@ EXPORT_SYMBOL(tcp_seq_next);
 
 void tcp_seq_stop(struct seq_file *seq, void *v)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct tcp_iter_state *st = seq->private;
 
 	switch (st->state) {
 	case TCP_SEQ_STATE_LISTENING:
 		if (v != SEQ_START_TOKEN)
-			spin_unlock(&tcp_hashinfo.lhash2[st->bucket].lock);
+			spin_unlock(&hinfo->lhash2[st->bucket].lock);
 		break;
 	case TCP_SEQ_STATE_ESTABLISHED:
 		if (v)
-			spin_unlock_bh(inet_ehash_lockp(&tcp_hashinfo, st->bucket));
+			spin_unlock_bh(inet_ehash_lockp(hinfo, st->bucket));
 		break;
 	}
 }
@@ -2750,6 +2761,7 @@ static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
 static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
 						 struct sock *start_sk)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct bpf_tcp_iter_state *iter = seq->private;
 	struct tcp_iter_state *st = &iter->state;
 	struct hlist_nulls_node *node;
@@ -2769,7 +2781,7 @@ static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
 			expected++;
 		}
 	}
-	spin_unlock(&tcp_hashinfo.lhash2[st->bucket].lock);
+	spin_unlock(&hinfo->lhash2[st->bucket].lock);
 
 	return expected;
 }
@@ -2777,6 +2789,7 @@ static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
 static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
 						   struct sock *start_sk)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct bpf_tcp_iter_state *iter = seq->private;
 	struct tcp_iter_state *st = &iter->state;
 	struct hlist_nulls_node *node;
@@ -2796,13 +2809,14 @@ static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
 			expected++;
 		}
 	}
-	spin_unlock_bh(inet_ehash_lockp(&tcp_hashinfo, st->bucket));
+	spin_unlock_bh(inet_ehash_lockp(hinfo, st->bucket));
 
 	return expected;
 }
 
 static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 {
+	struct inet_hashinfo *hinfo = seq_file_net(seq)->ipv4.tcp_death_row.hashinfo;
 	struct bpf_tcp_iter_state *iter = seq->private;
 	struct tcp_iter_state *st = &iter->state;
 	unsigned int expected;
@@ -2818,7 +2832,7 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 		st->offset = 0;
 		st->bucket++;
 		if (st->state == TCP_SEQ_STATE_LISTENING &&
-		    st->bucket > tcp_hashinfo.lhash2_mask) {
+		    st->bucket > hinfo->lhash2_mask) {
 			st->state = TCP_SEQ_STATE_ESTABLISHED;
 			st->bucket = 0;
 		}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 8bddb2a78b21..2e53981252d9 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -319,7 +319,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		/* Linkage updates.
 		 * Note that access to tw after this point is illegal.
 		 */
-		inet_twsk_hashdance(tw, sk, &tcp_hashinfo);
+		inet_twsk_hashdance(tw, sk, net->ipv4.tcp_death_row.hashinfo);
 		local_bh_enable();
 	} else {
 		/* Sorry, if we're out of memory, just CLOSE this
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 8220923a12f7..b10f9183801d 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -151,6 +151,7 @@ static void esp_free_tcp_sk(struct rcu_head *head)
 static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
 {
 	struct xfrm_encap_tmpl *encap = x->encap;
+	struct net *net = xs_net(x);
 	struct esp_tcp_sk *esk;
 	__be16 sport, dport;
 	struct sock *nsk;
@@ -177,7 +178,7 @@ static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
 	}
 	spin_unlock_bh(&x->lock);
 
-	sk = __inet6_lookup_established(xs_net(x), &tcp_hashinfo, &x->id.daddr.in6,
+	sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo, &x->id.daddr.in6,
 					dport, &x->props.saddr.in6, ntohs(sport), 0, 0);
 	if (!sk)
 		return ERR_PTR(-ENOENT);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 7d53d62783b1..b64b49012655 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -21,8 +21,6 @@
 #include <net/ip.h>
 #include <net/sock_reuseport.h>
 
-extern struct inet_hashinfo tcp_hashinfo;
-
 u32 inet6_ehashfn(const struct net *net,
 		  const struct in6_addr *laddr, const u16 lport,
 		  const struct in6_addr *faddr, const __be16 fport)
@@ -169,7 +167,7 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
 
-	if (hashinfo != &tcp_hashinfo)
+	if (hashinfo != net->ipv4.tcp_death_row.hashinfo)
 		return NULL; /* only TCP is supported */
 
 	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_TCP, saddr, sport,
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index aa5bb8789ba0..a7690ec62325 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -83,8 +83,8 @@ nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
 {
 	switch (protocol) {
 	case IPPROTO_TCP:
-		return inet6_lookup(net, &tcp_hashinfo, skb, doff,
-				    saddr, sport, daddr, dport,
+		return inet6_lookup(net, net->ipv4.tcp_death_row.hashinfo,
+				    skb, doff, saddr, sport, daddr, dport,
 				    in->ifindex);
 	case IPPROTO_UDP:
 		return udp6_lib_lookup(net, saddr, sport, daddr, dport,
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 6bac68fb27a3..929502e51203 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -80,6 +80,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		      const struct net_device *in,
 		      const enum nf_tproxy_lookup_t lookup_type)
 {
+	struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row.hashinfo;
 	struct sock *sk;
 
 	switch (protocol) {
@@ -93,7 +94,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 
 		switch (lookup_type) {
 		case NF_TPROXY_LOOKUP_LISTENER:
-			sk = inet6_lookup_listener(net, &tcp_hashinfo, skb,
+			sk = inet6_lookup_listener(net, hinfo, skb,
 						   thoff + __tcp_hdrlen(hp),
 						   saddr, sport,
 						   daddr, ntohs(dport),
@@ -108,9 +109,8 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 			 */
 			break;
 		case NF_TPROXY_LOOKUP_ESTABLISHED:
-			sk = __inet6_lookup_established(net, &tcp_hashinfo,
-							saddr, sport, daddr, ntohs(dport),
-							in->ifindex, 0);
+			sk = __inet6_lookup_established(net, hinfo, saddr, sport, daddr,
+							ntohs(dport), in->ifindex, 0);
 			break;
 		default:
 			BUG();
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e0b5f5b4d868..f9ed47eb9b93 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -287,12 +287,14 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto failure;
 	}
 
+	tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
+
 	if (!saddr) {
 		struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
 		struct in6_addr prev_v6_rcv_saddr;
 
 		if (icsk->icsk_bind2_hash) {
-			prev_addr_hashbucket = inet_bhashfn_portaddr(&tcp_hashinfo,
+			prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
 								     sk, net, inet->inet_num);
 			prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
 		}
@@ -325,7 +327,6 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	inet->inet_dport = usin->sin6_port;
 
 	tcp_set_state(sk, TCP_SYN_SENT);
-	tcp_death_row = &net->ipv4.tcp_death_row;
 	err = inet6_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto late_failure;
@@ -402,7 +403,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	bool fatal;
 	int err;
 
-	sk = __inet6_lookup_established(net, &tcp_hashinfo,
+	sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 					&hdr->daddr, th->dest,
 					&hdr->saddr, ntohs(th->source),
 					skb->dev->ifindex, inet6_sdif(skb));
@@ -1035,11 +1036,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 * Incoming packet is checked with md5 hash with finding key,
 		 * no RST generated if md5 hash doesn't match.
 		 */
-		sk1 = inet6_lookup_listener(net,
-					   &tcp_hashinfo, NULL, 0,
-					   &ipv6h->saddr,
-					   th->source, &ipv6h->daddr,
-					   ntohs(th->source), dif, sdif);
+		sk1 = inet6_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
+					    NULL, 0, &ipv6h->saddr, th->source,
+					    &ipv6h->daddr, ntohs(th->source),
+					    dif, sdif);
 		if (!sk1)
 			goto out;
 
@@ -1637,7 +1637,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	hdr = ipv6_hdr(skb);
 
 lookup:
-	sk = __inet6_lookup_skb(&tcp_hashinfo, skb, __tcp_hdrlen(th),
+	sk = __inet6_lookup_skb(net->ipv4.tcp_death_row.hashinfo, skb, __tcp_hdrlen(th),
 				th->source, th->dest, inet6_iif(skb), sdif,
 				&refcounted);
 	if (!sk)
@@ -1812,7 +1812,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	{
 		struct sock *sk2;
 
-		sk2 = inet6_lookup_listener(dev_net(skb->dev), &tcp_hashinfo,
+		sk2 = inet6_lookup_listener(net, net->ipv4.tcp_death_row.hashinfo,
 					    skb, __tcp_hdrlen(th),
 					    &ipv6_hdr(skb)->saddr, th->source,
 					    &ipv6_hdr(skb)->daddr,
@@ -1845,6 +1845,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 void tcp_v6_early_demux(struct sk_buff *skb)
 {
+	struct net *net = dev_net(skb->dev);
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
 	struct sock *sk;
@@ -1862,7 +1863,7 @@ void tcp_v6_early_demux(struct sk_buff *skb)
 		return;
 
 	/* Note : We use inet6_iif() here, not tcp_v6_iif() */
-	sk = __inet6_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
+	sk = __inet6_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
 					&hdr->saddr, th->source,
 					&hdr->daddr, ntohs(th->dest),
 					inet6_iif(skb), inet6_sdif(skb));
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 7f9a71780437..8df1bdb647e2 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -81,15 +81,18 @@ static void mptcp_diag_dump_listeners(struct sk_buff *skb, struct netlink_callba
 	struct mptcp_diag_ctx *diag_ctx = (void *)cb->ctx;
 	struct nlattr *bc = cb_data->inet_diag_nla_bc;
 	struct net *net = sock_net(skb->sk);
+	struct inet_hashinfo *hinfo;
 	int i;
 
-	for (i = diag_ctx->l_slot; i <= tcp_hashinfo.lhash2_mask; i++) {
+	hinfo = net->ipv4.tcp_death_row.hashinfo;
+
+	for (i = diag_ctx->l_slot; i <= hinfo->lhash2_mask; i++) {
 		struct inet_listen_hashbucket *ilb;
 		struct hlist_nulls_node *node;
 		struct sock *sk;
 		int num = 0;
 
-		ilb = &tcp_hashinfo.lhash2[i];
+		ilb = &hinfo->lhash2[i];
 
 		rcu_read_lock();
 		spin_lock(&ilb->lock);
-- 
2.30.2


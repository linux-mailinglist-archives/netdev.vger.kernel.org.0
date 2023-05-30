Return-Path: <netdev+bounces-6191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7637152CB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28E3C1C20AF6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DC87EC;
	Tue, 30 May 2023 01:04:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802F9636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:04:41 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C4C9D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408679; x=1716944679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z832o59VDZ2qacd7B9DfyrK/miH4OKkQfSFBlsSf5/Q=;
  b=pbzTm2IwhxLGYA9eenOpqnhrWpYvYQ1+588uHK/GaY89YRjiIlqtBSd9
   1zf2nHvZnucEiyANuHB7TX5sBuQOJj2uvsnSu6D6PCEyIZ2XlL4Bzz5zT
   cOLDaM75DW3cf3IYVshpat+uaV8U97St05H8oY73/Z4H+32YDBcXk2kB6
   M=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="334633335"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:04:37 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 045E580C59;
	Tue, 30 May 2023 01:04:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:04:34 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:04:31 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 01/14] udp: Random clenaup.
Date: Mon, 29 May 2023 18:03:35 -0700
Message-ID: <20230530010348.21425-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is preparation patch to make the following diff smaller.

No functional changes are intended:

  - Keep Reverse Xmas Tree Order
  - Define struct net instead of using sock_net() repeatedly

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 68 +++++++++++++++++++++++++++-----------------------
 net/ipv6/udp.c | 58 +++++++++++++++++++++++-------------------
 2 files changed, 69 insertions(+), 57 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fd3dae081f3a..7a874c497cbd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -901,16 +901,17 @@ EXPORT_SYMBOL(udp_set_csum);
 static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 			struct inet_cork *cork)
 {
+	int err, len, datalen, is_udplite;
 	struct sock *sk = skb->sk;
-	struct inet_sock *inet = inet_sk(sk);
+	struct inet_sock *inet;
 	struct udphdr *uh;
-	int err;
-	int is_udplite = IS_UDPLITE(sk);
-	int offset = skb_transport_offset(skb);
-	int len = skb->len - offset;
-	int datalen = len - sizeof(*uh);
 	__wsum csum = 0;
 
+	inet = inet_sk(sk);
+	is_udplite = IS_UDPLITE(sk);
+	len = skb->len - skb_transport_offset(skb);
+	datalen = len - sizeof(*uh);
+
 	/*
 	 * Create a UDP header
 	 */
@@ -1051,24 +1052,25 @@ EXPORT_SYMBOL_GPL(udp_cmsg_send);
 
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
+	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
+	DECLARE_SOCKADDR(struct sockaddr_in *, usin, msg->msg_name);
 	struct inet_sock *inet = inet_sk(sk);
 	struct udp_sock *up = udp_sk(sk);
-	DECLARE_SOCKADDR(struct sockaddr_in *, usin, msg->msg_name);
+	struct ip_options_data opt_copy;
+	int is_udplite = IS_UDPLITE(sk);
+	__be32 daddr, faddr, saddr;
+	struct rtable *rt = NULL;
 	struct flowi4 fl4_stack;
-	struct flowi4 *fl4;
-	int ulen = len;
 	struct ipcm_cookie ipc;
-	struct rtable *rt = NULL;
-	int free = 0;
+	struct sk_buff *skb;
+	struct flowi4 *fl4;
 	int connected = 0;
-	__be32 daddr, faddr, saddr;
+	int ulen = len;
 	u8 tos, scope;
 	__be16 dport;
-	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
-	struct sk_buff *skb;
-	struct ip_options_data opt_copy;
+	int free = 0;
+	int corkreq;
+	int err;
 
 	if (len > 0xFFFF)
 		return -EMSGSIZE;
@@ -1080,6 +1082,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB) /* Mirror BSD error message compatibility */
 		return -EOPNOTSUPP;
 
+	corkreq = READ_ONCE(up->corkflag) || msg->msg_flags & MSG_MORE;
 	getfrag = is_udplite ? udplite_getfrag : ip_generic_getfrag;
 
 	fl4 = &inet->cork.fl.u.ip4;
@@ -1805,13 +1808,13 @@ EXPORT_SYMBOL(udp_read_skb);
 int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		int *addr_len)
 {
-	struct inet_sock *inet = inet_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
-	struct sk_buff *skb;
-	unsigned int ulen, copied;
 	int off, err, peeking = flags & MSG_PEEK;
+	struct inet_sock *inet = inet_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
 	bool checksum_valid = false;
+	unsigned int ulen, copied;
+	struct sk_buff *skb;
 
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len, addr_len);
@@ -1965,9 +1968,9 @@ void udp_lib_unhash(struct sock *sk)
 	if (sk_hashed(sk)) {
 		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2;
+		struct net *net = sock_net(sk);
 
-		hslot  = udp_hashslot(udptable, sock_net(sk),
-				      udp_sk(sk)->udp_port_hash);
+		hslot  = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 
 		spin_lock_bh(&hslot->lock);
@@ -1976,7 +1979,7 @@ void udp_lib_unhash(struct sock *sk)
 		if (sk_del_node_init_rcu(sk)) {
 			hslot->count--;
 			inet_sk(sk)->inet_num = 0;
-			sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+			sock_prot_inuse_add(net, sk->sk_prot, -1);
 
 			spin_lock(&hslot2->lock);
 			hlist_del_init_rcu(&udp_sk(sk)->udp_portaddr_node);
@@ -1996,6 +1999,7 @@ void udp_lib_rehash(struct sock *sk, u16 newhash)
 	if (sk_hashed(sk)) {
 		struct udp_table *udptable = udp_get_table_prot(sk);
 		struct udp_hslot *hslot, *hslot2, *nhslot2;
+		struct net *net = sock_net(sk);
 
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 		nhslot2 = udp_hashslot2(udptable, newhash);
@@ -2003,8 +2007,7 @@ void udp_lib_rehash(struct sock *sk, u16 newhash)
 
 		if (hslot2 != nhslot2 ||
 		    rcu_access_pointer(sk->sk_reuseport_cb)) {
-			hslot = udp_hashslot(udptable, sock_net(sk),
-					     udp_sk(sk)->udp_port_hash);
+			hslot = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
 			/* we must lock primary chain too */
 			spin_lock_bh(&hslot->lock);
 			if (rcu_access_pointer(sk->sk_reuseport_cb))
@@ -2239,15 +2242,18 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    struct udp_table *udptable,
 				    int proto)
 {
-	struct sock *sk, *first = NULL;
+	int dif = skb->dev->ifindex, sdif = inet_sdif(skb);
+	unsigned int offset, hash2 = 0, hash2_any = 0;
 	unsigned short hnum = ntohs(uh->dest);
-	struct udp_hslot *hslot = udp_hashslot(udptable, net, hnum);
-	unsigned int hash2 = 0, hash2_any = 0, use_hash2 = (hslot->count > 10);
-	unsigned int offset = offsetof(typeof(*sk), sk_node);
-	int dif = skb->dev->ifindex;
-	int sdif = inet_sdif(skb);
+	struct sock *sk, *first = NULL;
 	struct hlist_node *node;
+	struct udp_hslot *hslot;
 	struct sk_buff *nskb;
+	bool use_hash2;
+
+	hslot = udp_hashslot(udptable, net, hnum);
+	offset = offsetof(typeof(*sk), sk_node);
+	use_hash2 = hslot->count > 10;
 
 	if (use_hash2) {
 		hash2_any = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum) &
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e5a337e6b970..2ec611c2f964 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -340,14 +340,14 @@ static int udp6_skb_len(struct sk_buff *skb)
 int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		  int flags, int *addr_len)
 {
+	int off, err, peeking = flags & MSG_PEEK;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	struct sk_buff *skb;
-	unsigned int ulen, copied;
-	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
 	struct udp_mib __percpu *mib;
 	bool checksum_valid = false;
+	unsigned int ulen, copied;
+	struct sk_buff *skb;
 	int is_udp4;
 
 	if (flags & MSG_ERRQUEUE)
@@ -848,16 +848,19 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		const struct in6_addr *saddr, const struct in6_addr *daddr,
 		struct udp_table *udptable, int proto)
 {
-	struct sock *sk, *first = NULL;
+	int dif = inet6_iif(skb), sdif = inet6_sdif(skb);
+	unsigned int offset, hash2 = 0, hash2_any = 0;
 	const struct udphdr *uh = udp_hdr(skb);
 	unsigned short hnum = ntohs(uh->dest);
-	struct udp_hslot *hslot = udp_hashslot(udptable, net, hnum);
-	unsigned int offset = offsetof(typeof(*sk), sk_node);
-	unsigned int hash2 = 0, hash2_any = 0, use_hash2 = (hslot->count > 10);
-	int dif = inet6_iif(skb);
-	int sdif = inet6_sdif(skb);
+	struct sock *sk, *first = NULL;
 	struct hlist_node *node;
+	struct udp_hslot *hslot;
 	struct sk_buff *nskb;
+	bool use_hash2;
+
+	hslot = udp_hashslot(udptable, net, hnum);
+	offset = offsetof(typeof(*sk), sk_node);
+	use_hash2 = hslot->count > 10;
 
 	if (use_hash2) {
 		hash2_any = ipv6_portaddr_hash(net, &in6addr_any, hnum) &
@@ -1225,14 +1228,14 @@ static void udp6_hwcsum_outgoing(struct sock *sk, struct sk_buff *skb,
 static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			   struct inet_cork *cork)
 {
+	int err, len, datalen, is_udplite;
 	struct sock *sk = skb->sk;
 	struct udphdr *uh;
-	int err = 0;
-	int is_udplite = IS_UDPLITE(sk);
 	__wsum csum = 0;
-	int offset = skb_transport_offset(skb);
-	int len = skb->len - offset;
-	int datalen = len - sizeof(*uh);
+
+	is_udplite = IS_UDPLITE(sk);
+	len = skb->len - skb_transport_offset(skb);
+	datalen = len - sizeof(*uh);
 
 	/*
 	 * Create a UDP header
@@ -1330,26 +1333,26 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 
 int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
-	struct ipv6_txoptions opt_space;
-	struct udp_sock *up = udp_sk(sk);
-	struct inet_sock *inet = inet_sk(sk);
-	struct ipv6_pinfo *np = inet6_sk(sk);
+	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
-	struct in6_addr *daddr, *final_p, final;
-	struct ipv6_txoptions *opt = NULL;
 	struct ipv6_txoptions *opt_to_free = NULL;
+	struct in6_addr *daddr, *final_p, final;
 	struct ip6_flowlabel *flowlabel = NULL;
+	struct inet_sock *inet = inet_sk(sk);
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct ipv6_txoptions *opt = NULL;
+	struct udp_sock *up = udp_sk(sk);
+	struct ipv6_txoptions opt_space;
+	int addr_len = msg->msg_namelen;
+	int is_udplite = IS_UDPLITE(sk);
 	struct inet_cork_full cork;
-	struct flowi6 *fl6 = &cork.fl.u.ip6;
-	struct dst_entry *dst;
 	struct ipcm6_cookie ipc6;
-	int addr_len = msg->msg_namelen;
 	bool connected = false;
+	struct dst_entry *dst;
+	struct flowi6 *fl6;
 	int ulen = len;
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
+	int corkreq;
 	int err;
-	int is_udplite = IS_UDPLITE(sk);
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
 	ipcm6_init(&ipc6);
 	ipc6.gso_size = READ_ONCE(up->gso_size);
@@ -1411,6 +1414,9 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (len > INT_MAX - sizeof(struct udphdr))
 		return -EMSGSIZE;
 
+	corkreq = READ_ONCE(up->corkflag) || msg->msg_flags & MSG_MORE;
+	fl6 = &cork.fl.u.ip6;
+
 	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
 		if (up->pending == AF_INET)
-- 
2.30.2



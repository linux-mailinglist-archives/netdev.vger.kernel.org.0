Return-Path: <netdev+bounces-6201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE577152D8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F2FC1C20AFD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812BE7FE;
	Tue, 30 May 2023 01:08:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7139B7ED
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:08:26 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8F5DF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408904; x=1716944904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YmCDDrG8r9hfECB0b0vJSKysH9uwV0J8aKdtfBeeF+w=;
  b=egVqpuYRqH5nDL17pFia4x8qTCIv4G6X58LyBT400y99+rZFMK3TmlRH
   K0zKoJOmwaPsyUpz4v3oCAIEUjtwllXLb3QKJ1cmb5chkKfYpntRyyvKM
   icJa4IvqBN5iu3LjFDUqL0o5XunG47V5TCSFtM8ci8OYJl/yJOkADwAus
   s=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="6648225"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:08:23 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id 14DF8803B1;
	Tue, 30 May 2023 01:08:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:08:20 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:08:17 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 10/14] udp: Don't pass proto to __udp[46]_lib_rcv().
Date: Mon, 29 May 2023 18:03:44 -0700
Message-ID: <20230530010348.21425-11-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We passed IPPROTO_UDPLITE as proto to __udp[46]_lib_rcv() to share the
code with UDP-Lite, which we no longer support.

We need not check proto in __udp[46]_lib_rcv().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 26 ++++++++++----------------
 net/ipv6/udp.c | 38 +++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f8a545c6e3e7..23ebea2b84e4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2180,8 +2180,7 @@ EXPORT_SYMBOL(udp_sk_rx_dst_set);
 static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 				    struct udphdr  *uh,
 				    __be32 saddr, __be32 daddr,
-				    struct udp_table *udptable,
-				    int proto)
+				    struct udp_table *udptable)
 {
 	int dif = skb->dev->ifindex, sdif = inet_sdif(skb);
 	unsigned int offset, hash2 = 0, hash2_any = 0;
@@ -2299,8 +2298,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
  *	All we need to do is get the socket, and then do a checksum.
  */
 
-static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-			  int proto)
+static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 {
 	struct sock *sk;
 	struct udphdr *uh;
@@ -2327,12 +2325,10 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (ulen > skb->len)
 		goto short_packet;
 
-	if (proto == IPPROTO_UDP) {
-		/* UDP validates ulen. */
-		if (ulen < sizeof(*uh) || pskb_trim_rcsum(skb, ulen))
-			goto short_packet;
-		uh = udp_hdr(skb);
-	}
+	if (ulen < sizeof(*uh) || pskb_trim_rcsum(skb, ulen))
+		goto short_packet;
+
+	uh = udp_hdr(skb);
 
 	if (udp4_csum_init(skb, uh))
 		goto csum_error;
@@ -2353,7 +2349,7 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(net, skb, uh,
-						saddr, daddr, udptable, proto);
+						saddr, daddr, udptable);
 
 	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 	if (sk)
@@ -2380,8 +2376,7 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 short_packet:
 	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
-	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
-			    proto == IPPROTO_UDPLITE ? "Lite" : "",
+	net_dbg_ratelimited("UDP: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    &saddr, ntohs(uh->source),
 			    ulen, skb->len,
 			    &daddr, ntohs(uh->dest));
@@ -2393,8 +2388,7 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
 	drop_reason = SKB_DROP_REASON_UDP_CSUM;
-	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
-			    proto == IPPROTO_UDPLITE ? "Lite" : "",
+	net_dbg_ratelimited("UDP: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
 			    ulen);
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS);
@@ -2539,7 +2533,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 int udp_rcv(struct sk_buff *skb)
 {
-	return __udp4_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table, IPPROTO_UDP);
+	return __udp4_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table);
 }
 
 static void udp_destroy_sock(struct sock *sk)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 170bbaa4a9d4..ee859679427a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -819,8 +819,9 @@ static void udp6_csum_zero_error(struct sk_buff *skb)
  * so we don't need to lock the hashes.
  */
 static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
-		const struct in6_addr *saddr, const struct in6_addr *daddr,
-		struct udp_table *udptable, int proto)
+				    const struct in6_addr *saddr,
+				    const struct in6_addr *daddr,
+				    struct udp_table *udptable)
 {
 	int dif = inet6_iif(skb), sdif = inet6_sdif(skb);
 	unsigned int offset, hash2 = 0, hash2_any = 0;
@@ -947,8 +948,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
-			  int proto)
+static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 {
 	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct in6_addr *saddr, *daddr;
@@ -969,23 +969,20 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (ulen > skb->len)
 		goto short_packet;
 
-	if (proto == IPPROTO_UDP) {
-		/* UDP validates ulen. */
+	/* Check for jumbo payload */
+	if (ulen == 0)
+		ulen = skb->len;
 
-		/* Check for jumbo payload */
-		if (ulen == 0)
-			ulen = skb->len;
+	if (ulen < sizeof(*uh))
+		goto short_packet;
 
-		if (ulen < sizeof(*uh))
+	if (ulen < skb->len) {
+		if (pskb_trim_rcsum(skb, ulen))
 			goto short_packet;
 
-		if (ulen < skb->len) {
-			if (pskb_trim_rcsum(skb, ulen))
-				goto short_packet;
-			saddr = &ipv6_hdr(skb)->saddr;
-			daddr = &ipv6_hdr(skb)->daddr;
-			uh = udp_hdr(skb);
-		}
+		saddr = &ipv6_hdr(skb)->saddr;
+		daddr = &ipv6_hdr(skb)->daddr;
+		uh = udp_hdr(skb);
 	}
 
 	if (udp6_csum_init(skb, uh))
@@ -1017,7 +1014,7 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 */
 	if (ipv6_addr_is_multicast(daddr))
 		return __udp6_lib_mcast_deliver(net, skb,
-				saddr, daddr, udptable, proto);
+						saddr, daddr, udptable);
 
 	/* Unicast */
 	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
@@ -1048,8 +1045,7 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 short_packet:
 	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
 		reason = SKB_DROP_REASON_PKT_TOO_SMALL;
-	net_dbg_ratelimited("UDP%sv6: short packet: From [%pI6c]:%u %d/%d to [%pI6c]:%u\n",
-			    proto == IPPROTO_UDPLITE ? "-Lite" : "",
+	net_dbg_ratelimited("UDPv6: short packet: From [%pI6c]:%u %d/%d to [%pI6c]:%u\n",
 			    saddr, ntohs(uh->source),
 			    ulen, skb->len,
 			    daddr, ntohs(uh->dest));
@@ -1138,7 +1134,7 @@ void udp_v6_early_demux(struct sk_buff *skb)
 
 INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
 {
-	return __udp6_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table, IPPROTO_UDP);
+	return __udp6_lib_rcv(skb, dev_net(skb->dev)->ipv4.udp_table);
 }
 
 /*
-- 
2.30.2



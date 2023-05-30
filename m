Return-Path: <netdev+bounces-6200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4137152D7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D175628100A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3215F7F4;
	Tue, 30 May 2023 01:08:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272117ED
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:08:08 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C92ACF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408886; x=1716944886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y47W/QIoqcycmY/SO0UpcCh/11OwolmY7EGs3jeMRnU=;
  b=U5ybjth/Qqa6Gcez53Hir7INNufipAkYfOK5tT7GGd5fF11SM+eVXExC
   b1fgQgv0OhJkAO0yzyUP+9IUSuCG7a8M7vKVQgt6BQ5IDy9GwqJ8Hm4eH
   gRRlO0y+gPe+M9/SuniLmcSTVlP0SJWvQkAOSHVBoBfpmUlDBU/xd/nek
   o=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="336829830"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:08:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id CCDF4802EA;
	Tue, 30 May 2023 01:08:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:07:55 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:07:52 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 09/14] udp: Don't pass proto to udp[46]_csum_init().
Date: Mon, 29 May 2023 18:03:43 -0700
Message-ID: <20230530010348.21425-10-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB004.ant.amazon.com (10.13.139.164) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We passed IPPROTO_UDPLITE as proto to __udp[46]_lib_rcv(), which passes
it to udp[46]_csum_init().

However, we no longer call __udp[46]_lib_rcv() with IPPROTO_UDPLITE, so
proto is always IPPROTO_UDP in udp[46]_csum_init(), and we can hard-code
it.

Also, udp6_csum_init() is not called from other functions, so we move it
to net/ipv6/udp.c as a static function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/ip6_checksum.h |  1 -
 net/ipv4/udp.c             |  7 +++----
 net/ipv6/ip6_checksum.c    | 33 ---------------------------------
 net/ipv6/udp.c             | 34 +++++++++++++++++++++++++++++++++-
 4 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index c8a96b888277..f9e03cc7a19c 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -83,5 +83,4 @@ void udp6_set_csum(bool nocheck, struct sk_buff *skb,
 		   const struct in6_addr *saddr,
 		   const struct in6_addr *daddr, int len);
 
-int udp6_csum_init(struct sk_buff *skb, struct udphdr *uh, int proto);
 #endif
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aee075fb5f4f..f8a545c6e3e7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2247,15 +2247,14 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
  * Otherwise, csum completion requires checksumming packet body,
  * including udp header and folding it to skb->csum.
  */
-static inline int udp4_csum_init(struct sk_buff *skb, struct udphdr *uh,
-				 int proto)
+static inline int udp4_csum_init(struct sk_buff *skb, struct udphdr *uh)
 {
 	int err;
 
 	/* Note, we are only interested in != 0 or == 0, thus the
 	 * force to int.
 	 */
-	err = (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
+	err = (__force int)skb_checksum_init_zero_check(skb, IPPROTO_UDP, uh->check,
 							inet_compute_pseudo);
 	if (err)
 		return err;
@@ -2335,7 +2334,7 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		uh = udp_hdr(skb);
 	}
 
-	if (udp4_csum_init(skb, uh, proto))
+	if (udp4_csum_init(skb, uh))
 		goto csum_error;
 
 	sk = skb_steal_sock(skb, &refcounted);
diff --git a/net/ipv6/ip6_checksum.c b/net/ipv6/ip6_checksum.c
index 1362db7a3660..e1a594873675 100644
--- a/net/ipv6/ip6_checksum.c
+++ b/net/ipv6/ip6_checksum.c
@@ -62,39 +62,6 @@ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 EXPORT_SYMBOL(csum_ipv6_magic);
 #endif
 
-int udp6_csum_init(struct sk_buff *skb, struct udphdr *uh, int proto)
-{
-	int err;
-
-	/* To support RFC 6936 (allow zero checksum in UDP/IPV6 for tunnels)
-	 * we accept a checksum of zero here. When we find the socket
-	 * for the UDP packet we'll check if that socket allows zero checksum
-	 * for IPv6 (set by socket option).
-	 *
-	 * Note, we are only interested in != 0 or == 0, thus the
-	 * force to int.
-	 */
-	err = (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
-							ip6_compute_pseudo);
-	if (err)
-		return err;
-
-	if (skb->ip_summed == CHECKSUM_COMPLETE && !skb->csum_valid) {
-		/* If SW calculated the value, we know it's bad */
-		if (skb->csum_complete_sw)
-			return 1;
-
-		/* HW says the value is bad. Let's validate that.
-		 * skb->csum is no longer the full packet checksum,
-		 * so don't treat is as such.
-		 */
-		skb_checksum_complete_unset(skb);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(udp6_csum_init);
-
 /* Function to set UDP checksum for an IPv6 UDP packet. This is intended
  * for the simple case like when setting the checksum for a UDP tunnel.
  */
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 21d48f8803d0..170bbaa4a9d4 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -896,6 +896,38 @@ static void udp6_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	}
 }
 
+static int udp6_csum_init(struct sk_buff *skb, struct udphdr *uh)
+{
+	int err;
+
+	/* To support RFC 6936 (allow zero checksum in UDP/IPV6 for tunnels)
+	 * we accept a checksum of zero here. When we find the socket
+	 * for the UDP packet we'll check if that socket allows zero checksum
+	 * for IPv6 (set by socket option).
+	 *
+	 * Note, we are only interested in != 0 or == 0, thus the
+	 * force to int.
+	 */
+	err = (__force int)skb_checksum_init_zero_check(skb, IPPROTO_UDP, uh->check,
+							ip6_compute_pseudo);
+	if (err)
+		return err;
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE && !skb->csum_valid) {
+		/* If SW calculated the value, we know it's bad */
+		if (skb->csum_complete_sw)
+			return 1;
+
+		/* HW says the value is bad. Let's validate that.
+		 * skb->csum is no longer the full packet checksum,
+		 * so don't treat is as such.
+		 */
+		skb_checksum_complete_unset(skb);
+	}
+
+	return 0;
+}
+
 /* wrapper for udp_queue_rcv_skb tacking care of csum conversion and
  * return code conversion for ip layer consumption
  */
@@ -956,7 +988,7 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		}
 	}
 
-	if (udp6_csum_init(skb, uh, proto))
+	if (udp6_csum_init(skb, uh))
 		goto csum_error;
 
 	/* Check if the socket is already available, e.g. due to early demux */
-- 
2.30.2



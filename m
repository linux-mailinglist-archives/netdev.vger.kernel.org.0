Return-Path: <netdev+bounces-6197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBF57152D1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389E3280CA7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F29B7EC;
	Tue, 30 May 2023 01:07:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4FB636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:07:12 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521CC9D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408831; x=1716944831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gRnBxPUGhd3Si4K/R287a7lstenKYT2FO6ZrtJGccXw=;
  b=HpYG1vLcBKJ20AlNNwrzyAU1seF0wiR06h7yxsD6fyxsvEyLd1ItQjaf
   7Ogce/P4bmAucWvYAuXRGFPGgkAhLGMwqrqeIVb936ssuaW/KrmNFX1/r
   a3GjL171SAttRb2GhmErsZCvrMtynoQA4wmjxEovG3C1O0kf8UjhiwLdq
   A=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="288205143"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:07:09 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id 3276E609A4;
	Tue, 30 May 2023 01:07:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:07:05 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 30 May 2023 01:07:02 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 07/14] udp: Remove pcslen, pcrlen, and pcflag in struct udp_sock.
Date: Mon, 29 May 2023 18:03:41 -0700
Message-ID: <20230530010348.21425-8-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We removed partial checksum coverage support in the previous commit;
thus, udp_sk(sk)->{pcslen,pcrlen,pcflag} are always zero.  We can safely
remove the related code guarded by pcflag.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
After removing these members, the layout of udp_sock changes as follows.
We may want to move encap/gro functions on the last cache line to save
one cache line ?

Before:

struct udp_sock {
        struct inet_sock           inet __attribute__((__aligned__(8))); /*     0   976 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 15 boundary (960 bytes) was 16 bytes ago --- */
...
        unsigned char              accept_udp_fraglist:1; /*   985: 5  1 */

        /* XXX 2 bits hole, try to pack */

        __u16                      len;                  /*   986     2 */
        __u16                      gso_size;             /*   988     2 */
        __u16                      pcslen;               /*   990     2 */
        __u16                      pcrlen;               /*   992     2 */
        __u8                       pcflag;               /*   994     1 */
        __u8                       unused[3];            /*   995     3 */

        /* XXX 2 bytes hole, try to pack */

        int                        (*encap_rcv)(struct sock *, struct sk_buff *); /*  1000     8 */
        void                       (*encap_err_rcv)(struct sock *, struct sk_buff *, int, __be16, u32, u8 *); /*  1008     8 */
        int                        (*encap_err_lookup)(struct sock *, struct sk_buff *); /*  1016     8 */
        /* --- cacheline 16 boundary (1024 bytes) --- */
        void                       (*encap_destroy)(struct sock *); /*  1024     8 */
        struct sk_buff *           (*gro_receive)(struct sock *, struct list_head *, struct sk_buff *); /*  1032     8 */
        int                        (*gro_complete)(struct sock *, struct sk_buff *, int); /*  1040     8 */

        /* XXX 40 bytes hole, try to pack */

        /* --- cacheline 17 boundary (1088 bytes) --- */
        struct sk_buff_head        reader_queue __attribute__((__aligned__(64))); /*  1088    24 */
        int                        forward_deficit;      /*  1112     4 */
        int                        forward_threshold;    /*  1116     4 */

        /* size: 1152, cachelines: 18, members: 25 */
        /* sum members: 1077, holes: 2, sum holes: 42 */
        /* sum bitfield members: 6 bits, bit holes: 1, sum bit holes: 2 bits */
        /* padding: 32 */
        /* paddings: 1, sum paddings: 4 */
        /* forced alignments: 2, forced holes: 1, sum forced holes: 40 */
} __attribute__((__aligned__(64)));

After:

struct udp_sock {
        struct inet_sock           inet __attribute__((__aligned__(8))); /*     0   976 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 15 boundary (960 bytes) was 16 bytes ago --- */
...
        unsigned char              accept_udp_fraglist:1; /*   985: 5  1 */

        /* XXX 2 bits hole, try to pack */

        __u16                      len;                  /*   986     2 */
        __u16                      gso_size;             /*   988     2 */

        /* XXX 2 bytes hole, try to pack */

        int                        (*encap_rcv)(struct sock *, struct sk_buff *); /*   992     8 */
        void                       (*encap_err_rcv)(struct sock *, struct sk_buff *, int, __be16, u32, u8 *); /*  1000     8 */
        int                        (*encap_err_lookup)(struct sock *, struct sk_buff *); /*  1008     8 */
        void                       (*encap_destroy)(struct sock *); /*  1016     8 */
        /* --- cacheline 16 boundary (1024 bytes) --- */
        struct sk_buff *           (*gro_receive)(struct sock *, struct list_head *, struct sk_buff *); /*  1024     8 */
        int                        (*gro_complete)(struct sock *, struct sk_buff *, int); /*  1032     8 */

        /* XXX 48 bytes hole, try to pack */

        /* --- cacheline 17 boundary (1088 bytes) --- */
        struct sk_buff_head        reader_queue __attribute__((__aligned__(64))); /*  1088    24 */
        int                        forward_deficit;      /*  1112     4 */
        int                        forward_threshold;    /*  1116     4 */

        /* size: 1152, cachelines: 18, members: 21 */
        /* sum members: 1069, holes: 2, sum holes: 50 */
        /* sum bitfield members: 6 bits, bit holes: 1, sum bit holes: 2 bits */
        /* padding: 32 */
        /* paddings: 1, sum paddings: 4 */
        /* forced alignments: 2, forced holes: 1, sum forced holes: 48 */
} __attribute__((__aligned__(64)));
---
 include/linux/udp.h   | 12 +-----------
 include/net/udplite.h |  6 ------
 net/ipv4/udp.c        | 34 ----------------------------------
 net/ipv6/udp.c        | 17 -----------------
 4 files changed, 1 insertion(+), 68 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 43c1fb2d2c21..f2f44ad62ea0 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -57,17 +57,7 @@ struct udp_sock {
 	 */
 	__u16		 len;		/* total length of pending frames */
 	__u16		 gso_size;
-	/*
-	 * Fields specific to UDP-Lite.
-	 */
-	__u16		 pcslen;
-	__u16		 pcrlen;
-/* indicator bits used by pcflag: */
-#define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
-#define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
-#define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
-	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
-	__u8		 unused[3];
+
 	/*
 	 * For encapsulation sockets.
 	 */
diff --git a/include/net/udplite.h b/include/net/udplite.h
index f4c513cff753..1bc9393f2890 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -59,15 +59,9 @@ static inline int udplite_checksum_init(struct sk_buff *skb, struct udphdr *uh)
 /* Fast-path computation of checksum. Socket may not be locked. */
 static inline __wsum udplite_csum(struct sk_buff *skb)
 {
-	const struct udp_sock *up = udp_sk(skb->sk);
 	const int off = skb_transport_offset(skb);
 	int len = skb->len - off;
 
-	if ((up->pcflag & UDPLITE_SEND_CC) && up->pcslen < len) {
-		if (0 < up->pcslen)
-			len = up->pcslen;
-		udp_hdr(skb)->len = htons(up->pcslen);
-	}
 	skb->ip_summed = CHECKSUM_NONE;     /* no HW support for checksumming */
 
 	return skb_checksum(skb, off, len, 0);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index dc416db001c8..345a6364a969 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2129,40 +2129,6 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		/* FALLTHROUGH -- it's a UDP Packet */
 	}
 
-	/*
-	 * 	UDP-Lite specific tests, ignored on UDP sockets
-	 */
-	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
-
-		/*
-		 * MIB statistics other than incrementing the error count are
-		 * disabled for the following two types of errors: these depend
-		 * on the application settings, not on the functioning of the
-		 * protocol stack as such.
-		 *
-		 * RFC 3828 here recommends (sec 3.3): "There should also be a
-		 * way ... to ... at least let the receiving application block
-		 * delivery of packets with coverage values less than a value
-		 * provided by the application."
-		 */
-		if (up->pcrlen == 0) {          /* full coverage was set  */
-			net_dbg_ratelimited("UDPLite: partial coverage %d while full coverage %d requested\n",
-					    UDP_SKB_CB(skb)->cscov, skb->len);
-			goto drop;
-		}
-		/* The next case involves violating the min. coverage requested
-		 * by the receiver. This is subtle: if receiver wants x and x is
-		 * greater than the buffersize/MTU then receiver will complain
-		 * that it wants x while sender emits packets of smaller size y.
-		 * Therefore the above ...()->partial_cov statement is essential.
-		 */
-		if (UDP_SKB_CB(skb)->cscov  <  up->pcrlen) {
-			net_dbg_ratelimited("UDPLite: coverage %d too small, need min %d\n",
-					    UDP_SKB_CB(skb)->cscov, up->pcrlen);
-			goto drop;
-		}
-	}
-
 	prefetch(&sk->sk_rmem_alloc);
 	if (rcu_access_pointer(sk->sk_filter) &&
 	    udp_lib_checksum_complete(skb))
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ecd304bbecb4..5c4b0e662ff5 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -738,23 +738,6 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		/* FALLTHROUGH -- it's a UDP Packet */
 	}
 
-	/*
-	 * UDP-Lite specific tests, ignored on UDP sockets (see net/ipv4/udp.c).
-	 */
-	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
-
-		if (up->pcrlen == 0) {          /* full coverage was set  */
-			net_dbg_ratelimited("UDPLITE6: partial coverage %d while full coverage %d requested\n",
-					    UDP_SKB_CB(skb)->cscov, skb->len);
-			goto drop;
-		}
-		if (UDP_SKB_CB(skb)->cscov  <  up->pcrlen) {
-			net_dbg_ratelimited("UDPLITE6: coverage %d too small, need min %d\n",
-					    UDP_SKB_CB(skb)->cscov, up->pcrlen);
-			goto drop;
-		}
-	}
-
 	prefetch(&sk->sk_rmem_alloc);
 	if (rcu_access_pointer(sk->sk_filter) &&
 	    udp_lib_checksum_complete(skb))
-- 
2.30.2



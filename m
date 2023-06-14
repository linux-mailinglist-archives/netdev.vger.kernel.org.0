Return-Path: <netdev+bounces-10906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE1F730B1C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B82E71C20DA2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F038114A97;
	Wed, 14 Jun 2023 23:02:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F3D134B8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:02:08 +0000 (UTC)
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DDD2130
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686783727; x=1718319727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q8tDzfHRGrtGTyeGvcXO2QhHHT6ZBjg1STfUofwiPXA=;
  b=REzUPhfBfWRBAdu8juD3Y//HpbDyQ17qAKWHFNfdjRm3KjQsIytBv5Cx
   DTY7Ej2cHcx/UeY2U9QFxOMXujbLhy+0E7yseGUNF7EpqHx4L2CQPhP8e
   xvjyONQ2Z3lS7UlQ2OVNI79naA3I1ySHx1dYikKWPFhkSZO1zmaIVNRGA
   g=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="654252218"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 23:02:01 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 09970808C0;
	Wed, 14 Jun 2023 23:01:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:01:45 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:01:42 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 1/5] ipv6: rpl: Remove pskb(_may)?_pull() in ipv6_rpl_srh_rcv().
Date: Wed, 14 Jun 2023 16:01:03 -0700
Message-ID: <20230614230107.22301-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230614230107.22301-1-kuniyu@amazon.com>
References: <20230614230107.22301-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.18]
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As Eric Dumazet pointed out [0], ipv6_rthdr_rcv() pulls these data

  - Segment Routing Header : 8
  - Hdr Ext Len            : skb_transport_header(skb)[1] << 3

needed by ipv6_rpl_srh_rcv().  We can remove pskb_may_pull() and
replace pskb_pull() with skb_pull() in ipv6_rpl_srh_rcv().

Link: https://lore.kernel.org/netdev/CANn89iLboLwLrHXeHJucAqBkEL_S0rJFog68t7wwwXO-aNf5Mg@mail.gmail.com/ [0]
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/rpl.h  |  3 ---
 net/ipv6/exthdrs.c | 17 +----------------
 net/ipv6/rpl.c     |  7 -------
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/include/net/rpl.h b/include/net/rpl.h
index 30fe780d1e7c..74734191c458 100644
--- a/include/net/rpl.h
+++ b/include/net/rpl.h
@@ -23,9 +23,6 @@ static inline int rpl_init(void)
 static inline void rpl_exit(void) {}
 #endif
 
-size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
-			 unsigned char cmpre);
-
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
 			     const struct ipv6_rpl_sr_hdr *inhdr,
 			     const struct in6_addr *daddr, unsigned char n);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a543df57801f..65adc11b59aa 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -517,11 +517,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
-
-			if (!pskb_pull(skb, offset)) {
-				kfree_skb(skb);
-				return -1;
-			}
+			skb_pull(skb, offset);
 			skb_postpull_rcsum(skb, skb_transport_header(skb),
 					   offset);
 
@@ -543,11 +539,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 		return 1;
 	}
 
-	if (!pskb_may_pull(skb, sizeof(*hdr))) {
-		kfree_skb(skb);
-		return -1;
-	}
-
 	n = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre);
 	r = do_div(n, (16 - hdr->cmpri));
 	/* checks if calculation was without remainder and n fits into
@@ -567,12 +558,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 		return -1;
 	}
 
-	if (!pskb_may_pull(skb, ipv6_rpl_srh_size(n, hdr->cmpri,
-						  hdr->cmpre))) {
-		kfree_skb(skb);
-		return -1;
-	}
-
 	hdr->segments_left--;
 	i = n - hdr->segments_left;
 
diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index d1876f192225..e186998bfbf7 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -29,13 +29,6 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 	return (void *)&hdr->rpl_segdata[i * IPV6_PFXTAIL_LEN(hdr->cmpri)];
 }
 
-size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
-			 unsigned char cmpre)
-{
-	return sizeof(struct ipv6_rpl_sr_hdr) + (n * IPV6_PFXTAIL_LEN(cmpri)) +
-		IPV6_PFXTAIL_LEN(cmpre);
-}
-
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
 			     const struct ipv6_rpl_sr_hdr *inhdr,
 			     const struct in6_addr *daddr, unsigned char n)
-- 
2.30.2



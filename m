Return-Path: <netdev+bounces-6202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 372177152DA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5546280FFB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA31803;
	Tue, 30 May 2023 01:09:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AF17ED
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:09:04 +0000 (UTC)
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E750CF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408943; x=1716944943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0sdub9kZ2cnJvmKWO+bpSzH8rjq1wcxkLmkdm1fLDTE=;
  b=F8lyUOtadg2GzOfFZYkkYDAM+VCg1p37ZUbi7YOrUpjB/3VxsUZ0oxS+
   PdGaUagrcGyal5E2d+25rXrSq+pTSFgsixFMxjXI48xRijz1nILYyEazM
   /mAhuIHYzKpCzF1qaJkXOUMCJ9MMepii3hGyX2g2z2DtELYsnbevR0jni
   g=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="1134335531"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:09:01 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id D161BE5DD4;
	Tue, 30 May 2023 01:08:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:08:45 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:08:42 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 11/14] udp: Optimise ulen tests in __udp[46]_lib_rcv().
Date: Mon, 29 May 2023 18:03:45 -0700
Message-ID: <20230530010348.21425-12-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In __udp4_lib_rcv(), we need not call udp_hdr() unless we call
pskb_trim_rcsum().

In __udp6_lib_rcv(), we can save two unneeded conditions for every
jumbo payload that never be true.

	if (ulen > skb->len)
		goto short_packet;
	if (ulen == 0)
		ulen = skb->len;
	if (ulen < skb->len)

Note the number of tests for non-jumbo IPv6 payload is not changed.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c |  8 +++++---
 net/ipv6/udp.c | 30 +++++++++++++++++-------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 23ebea2b84e4..eb968d20d5a8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2325,10 +2325,12 @@ static int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 	if (ulen > skb->len)
 		goto short_packet;
 
-	if (ulen < sizeof(*uh) || pskb_trim_rcsum(skb, ulen))
-		goto short_packet;
+	if (ulen < sizeof(*uh)) {
+		if (pskb_trim_rcsum(skb, ulen))
+			goto short_packet;
 
-	uh = udp_hdr(skb);
+		uh = udp_hdr(skb);
+	}
 
 	if (udp4_csum_init(skb, uh))
 		goto csum_error;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ee859679427a..6f5c29af4157 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -966,23 +966,27 @@ static int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable)
 	uh = udp_hdr(skb);
 
 	ulen = ntohs(uh->len);
-	if (ulen > skb->len)
-		goto short_packet;
+	if (ulen) {
+		if (ulen > skb->len)
+			goto short_packet;
 
-	/* Check for jumbo payload */
-	if (ulen == 0)
-		ulen = skb->len;
+		if (ulen < sizeof(*uh))
+			goto short_packet;
 
-	if (ulen < sizeof(*uh))
-		goto short_packet;
+		if (ulen < skb->len) {
+			if (pskb_trim_rcsum(skb, ulen))
+				goto short_packet;
 
-	if (ulen < skb->len) {
-		if (pskb_trim_rcsum(skb, ulen))
-			goto short_packet;
+			saddr = &ipv6_hdr(skb)->saddr;
+			daddr = &ipv6_hdr(skb)->daddr;
+			uh = udp_hdr(skb);
+		}
+	} else {
+		/* jumbo payload */
+		ulen = skb->len;
 
-		saddr = &ipv6_hdr(skb)->saddr;
-		daddr = &ipv6_hdr(skb)->daddr;
-		uh = udp_hdr(skb);
+		if (ulen < sizeof(*uh))
+			goto short_packet;
 	}
 
 	if (udp6_csum_init(skb, uh))
-- 
2.30.2



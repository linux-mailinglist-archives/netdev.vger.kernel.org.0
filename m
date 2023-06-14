Return-Path: <netdev+bounces-10907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2F6730B1E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1702628135C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CDB14A97;
	Wed, 14 Jun 2023 23:02:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B44C1549F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:02:15 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234302684
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686783734; x=1718319734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cWs0I9Wnft337BUwZmFp8xFa85ztLixYK43wLVDybk4=;
  b=CimVQNTaTKcGddkKQFvXeXC5BFgp3R3Rh/r7hgIlDi51yttMGiMJjRmh
   TGcpLlIIg8AgYpIe07U2VJ7P01Iy15jsx8lM6AxmgChkaF9v8AV25dx57
   zXbO2ERmpjaa/AbttBaAVf8kzpr5b6ZjLvWlic7fvV3YJvos2LTHEiFfl
   E=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="338928731"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 23:02:11 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 0EF7CA2D5C;
	Wed, 14 Jun 2023 23:02:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:02:09 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:02:06 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 2/5] ipv6: rpl: Remove redundant multicast tests in ipv6_rpl_srh_rcv().
Date: Wed, 14 Jun 2023 16:01:04 -0700
Message-ID: <20230614230107.22301-3-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D039UWB004.ant.amazon.com (10.13.138.57) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

ipv6_rpl_srh_rcv() checks if ipv6_hdr(skb)->daddr or ohdr->rpl_segaddr[i]
is the multicast address with ipv6_addr_type().

We have the same check for ipv6_hdr(skb)->daddr in ipv6_rthdr_rcv(), so we
need not recheck it in ipv6_rpl_srh_rcv().

Also, we should use ipv6_addr_is_multicast() for ohdr->rpl_segaddr[i]
instead of ipv6_addr_type().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/exthdrs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 65adc11b59aa..6259e907f0d9 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -571,8 +571,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	ipv6_rpl_srh_decompress(ohdr, hdr, &ipv6_hdr(skb)->daddr, n);
 	chdr = (struct ipv6_rpl_sr_hdr *)(buf + ((ohdr->hdrlen + 1) << 3));
 
-	if ((ipv6_addr_type(&ipv6_hdr(skb)->daddr) & IPV6_ADDR_MULTICAST) ||
-	    (ipv6_addr_type(&ohdr->rpl_segaddr[i]) & IPV6_ADDR_MULTICAST)) {
+	if (ipv6_addr_is_multicast(&ohdr->rpl_segaddr[i])) {
 		kfree_skb(skb);
 		kfree(buf);
 		return -1;
-- 
2.30.2



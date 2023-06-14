Return-Path: <netdev+bounces-10908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30170730B1F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60D3C1C20D9D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804D715485;
	Wed, 14 Jun 2023 23:02:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7512611CAE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:02:41 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CF02684
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686783760; x=1718319760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hOtzXVoJamibvuvqMFaXVhESKXaZVb1rtmYyiRKVDm0=;
  b=eG7NLj9pLYtyDGQAsaIgn05bpekXJLLdAzdA8qlkBDKc2Tm+aqVXy3ra
   HqtsskV0D/dcay2VSPrMEpQYCmr/AqVobiIQJhLgxPAYeAE9VYEZN/PBD
   QbOxebBoHtwVrwbGZMyAEUdpMpN8yOS+hvbyiFsjDwNwEIoL7w8msU7cm
   A=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="10269653"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 23:02:37 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 19CD9C1AB9;
	Wed, 14 Jun 2023 23:02:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:02:33 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:02:31 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 3/5] ipv6: exthdrs: Replace pskb_pull() with skb_pull() in ipv6_srh_rcv().
Date: Wed, 14 Jun 2023 16:01:05 -0700
Message-ID: <20230614230107.22301-4-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

ipv6_rthdr_rcv() pulls these data

  - Segment Routing Header : 8
  - Hdr Ext Len            : skb_transport_header(skb)[1] << 3

needed by ipv6_srh_rcv(), so pskb_pull() in ipv6_srh_rcv() never
fails and can be replaced with skb_pull().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/exthdrs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6259e907f0d9..e62e26ac99ef 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -402,11 +402,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 
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
 
-- 
2.30.2



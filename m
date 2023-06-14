Return-Path: <netdev+bounces-10910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1CC730B22
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEA421C20DED
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55F215497;
	Wed, 14 Jun 2023 23:03:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EAD1548A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:03:27 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808CF2684
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686783806; x=1718319806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uXe6Edl/spgSpJvxVp07+V38pGfsDTMMlphr6M2Wlew=;
  b=HQh05bavFFujWkWR6zAEO8FIfDAGCa1X3F75oTaEq31ghmJr3Ijyxd0C
   x4uAgP3qVu77FCUdKBaPkh9IrNSOqZFKDvzaQcSzjTFdby9QhGpfMlaeh
   9kQx+PcHz7UlYM9RZ2qjdz8QTQmxyD5UfJBucGgzE5Qro/QHA2LWkRICF
   E=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="587376331"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 23:03:24 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id E1FFC46D95;
	Wed, 14 Jun 2023 23:03:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:03:22 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Wed, 14 Jun 2023 23:03:19 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 5/5] ipv6: exthdrs: Remove redundant skb_headlen() check in ip6_parse_tlv().
Date: Wed, 14 Jun 2023 16:01:07 -0700
Message-ID: <20230614230107.22301-6-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

ipv6_destopt_rcv() and ipv6_parse_hopopts() pulls these data

  - Hop-by-Hop/Destination Options Header : 8
  - Hdr Ext Len                           : skb_transport_header(skb)[1] << 3

and calls ip6_parse_tlv(), so it need not check if skb_headlen() is less
than skb_transport_offset(skb) + (skb_transport_header(skb)[1] << 3).

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/exthdrs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index dd23531387e3..202fc3aaa83c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -126,9 +126,6 @@ static bool ip6_parse_tlv(bool hopbyhop,
 		max_count = -max_count;
 	}
 
-	if (skb_transport_offset(skb) + len > skb_headlen(skb))
-		goto bad;
-
 	off += 2;
 	len -= 2;
 
-- 
2.30.2



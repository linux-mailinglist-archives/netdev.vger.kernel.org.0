Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBDE59EC0A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiHWTRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiHWTQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:16:38 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB780E8E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277237; x=1692813237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xPluUW9NioNNMw+y8Fb93UL6h1Y47k0AhjYaFy7MaI8=;
  b=SbtGBJxN9lz6I8Q5KKkObdeT3GZGweWPZZvK2AHO8kvxkcinJX5Z0I5a
   03H7BlXtXv93k5KHj9mXBemy8JBZ4tEIVe3mUfGlt7IhPm4Lp29g3h+rZ
   gDqT13KVJk6dShlkc37E2TOsQgaunTKWnWN3I2pRNJiWL7gqzLAPvf0NT
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="1047381719"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:51:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 5177F44A7F;
        Tue, 23 Aug 2022 17:51:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:51:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:50:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v4 net 11/17] net: Fix data-races around sysctl_max_skb_frags.
Date:   Tue, 23 Aug 2022 10:46:54 -0700
Message-ID: <20220823174700.88411-12-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823174700.88411-1-kuniyu@amazon.com>
References: <20220823174700.88411-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_max_skb_frags, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5f74f82ea34c ("net:Add sysctl_max_skb_frags")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
---
 net/ipv4/tcp.c       | 4 ++--
 net/mptcp/protocol.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bbe218753662..e5011c136fdb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1000,7 +1000,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 
 	i = skb_shinfo(skb)->nr_frags;
 	can_coalesce = skb_can_coalesce(skb, i, page, offset);
-	if (!can_coalesce && i >= sysctl_max_skb_frags) {
+	if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
@@ -1354,7 +1354,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
-				if (i >= sysctl_max_skb_frags) {
+				if (i >= READ_ONCE(sysctl_max_skb_frags)) {
 					tcp_mark_push(tp, skb);
 					goto new_segment;
 				}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index da4257504fad..d398f3810662 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1263,7 +1263,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 		i = skb_shinfo(skb)->nr_frags;
 		can_coalesce = skb_can_coalesce(skb, i, dfrag->page, offset);
-		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+		if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
 			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
-- 
2.30.2


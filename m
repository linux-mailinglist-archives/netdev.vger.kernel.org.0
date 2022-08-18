Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD5598B39
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345483AbiHRSbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345479AbiHRSa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:56 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC87D1266
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847446; x=1692383446;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EgaVRC+7vWxeIwD8zl6wtfo2yvkHSTDHxB3/Sm0gvy0=;
  b=qkeBV3fSD0Vz7E1D82H8uQRIMiSAEdyEd2V4jZ/w+AeYhALbxZATISMI
   8EmHbO8Qu58MG3Wpkh5HrvN6kwy/hORHxMVCOL0tCJv3U5/udENwzW02k
   qinctbkypEcHG5TMuzHwnuddb9CxSD4cFVqtFOdSkBhICJJbCq6D6WzxG
   0=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="120814419"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:30:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 7964644056;
        Thu, 18 Aug 2022 18:30:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:30:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:30:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v3 net 11/17] net: Fix data-races around sysctl_max_skb_frags.
Date:   Thu, 18 Aug 2022 11:26:47 -0700
Message-ID: <20220818182653.38940-12-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_max_skb_frags, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5f74f82ea34c ("net:Add sysctl_max_skb_frags")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
CC: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
---
 net/ipv4/tcp.c       | 4 ++--
 net/mptcp/protocol.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 970e9a2cca4a..9a6fe3d6ab26 100644
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


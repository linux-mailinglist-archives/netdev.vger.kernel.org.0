Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9BC595482
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiHPIGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiHPIFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:05:18 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6E82644;
        Mon, 15 Aug 2022 22:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627682; x=1692163682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ROg/26DfcY2/K1jwJJXHREca9UxCB+YTz15mnrjueV8=;
  b=ZplOZfcVc7l/Aio+73tPG5eWx80AqSTtGg6JN9eAIInGFy1V88mtax3O
   bsUOSQqFLQQGNHjE/ZECVETLZu2T94Bez+e+L58F7tE8dPPUqt1UmSGF+
   Asjp85MC4PuOwf4pQB+LJPFfgzAyZPZG6JWFwwntSpX/9X8ZJBKuJounL
   8=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="218222264"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:28:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com (Postfix) with ESMTPS id 79CF1449BE;
        Tue, 16 Aug 2022 05:27:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:27:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:27:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v1 net 15/15] net: Fix data-races around sysctl_max_skb_frags.
Date:   Mon, 15 Aug 2022 22:23:47 -0700
Message-ID: <20220816052347.70042-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816052347.70042-1-kuniyu@amazon.com>
References: <20220816052347.70042-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
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


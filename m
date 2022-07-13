Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38776573E53
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiGMUzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiGMUzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:55:23 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98741260C
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745723; x=1689281723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tVJRckurZqjQOCg+ngLQo7Qd571Q2xzRPXarPGE3g0w=;
  b=lB04Ixu0NejMt/xT+16DshbekuEPNdznrQzPZL7b3uBxkei1I6Q+u4Ty
   jBKU5VSOdGN0f5wItgqW3H2RKry0GP5aViFt1kxv0+c3yfTilOFCoVwNi
   R02u5KerTnJCrUCSzS+vMHgJD7t9aRaP+eU4ipHOrT+zvsnCyH6JyxdYQ
   k=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="221335058"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 13 Jul 2022 20:55:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 1F92D812C3;
        Wed, 13 Jul 2022 20:55:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:55:09 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:55:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, John Heffner <jheffner@psc.edu>
Subject: [PATCH v1 net 10/15] tcp: Fix data-races around sysctl_tcp_mtu_probing.
Date:   Wed, 13 Jul 2022 13:52:00 -0700
Message-ID: <20220713205205.15735-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_mtu_probing, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5d424d5a674f ("[TCP]: MTU probing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: John Heffner <jheffner@psc.edu>
---
 net/ipv4/tcp_output.c | 2 +-
 net/ipv4/tcp_timer.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 11aa0ab10bba..3fcfc0f1e9f9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1762,7 +1762,7 @@ void tcp_mtup_init(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
 
-	icsk->icsk_mtup.enabled = net->ipv4.sysctl_tcp_mtu_probing > 1;
+	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
 	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d..98bb00e29e1e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -163,7 +163,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	int mss;
 
 	/* Black hole detection */
-	if (!net->ipv4.sysctl_tcp_mtu_probing)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing))
 		return;
 
 	if (!icsk->icsk_mtup.enabled) {
-- 
2.30.2


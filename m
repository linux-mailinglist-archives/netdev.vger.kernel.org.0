Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B075765CD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbiGORWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiGORWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:22:04 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C0D83F31
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905722; x=1689441722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DIQXXk3cbjelaUBbUNfF1EcgxQcOTSnGD8rnLw1GJDY=;
  b=NMOk6RAVsUlZa1OEAEWy0o8f1btE7YRVAMGOk/XeaVmOc3fO2bRcOR+p
   Sbkfd8Rsr9VcWHjhdn49grbb7PWaSpee/64eG8BQ0hHNzIZmv/Ki2Wsz7
   etS1d1sHl4b1/R6uAlkfmFlVOwODeNMldMbrM5uX3x4df2NCyP7wymkon
   w=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="218896622"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 15 Jul 2022 17:22:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id 6279444330;
        Fri, 15 Jul 2022 17:21:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:21:58 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:21:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>
Subject: [PATCH v1 net 15/15] tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
Date:   Fri, 15 Jul 2022 10:17:55 -0700
Message-ID: <20220715171755.38497-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_fastopen_blackhole_timeout, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: cf1ef3f0719b ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Wei Wang <weiwan@google.com>
---
 net/ipv4/tcp_fastopen.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 0acdb5473850..825b216d11f5 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -489,7 +489,7 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout))
 		return;
 
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
@@ -510,7 +510,8 @@ void tcp_fastopen_active_disable(struct sock *sk)
  */
 bool tcp_fastopen_active_should_disable(struct sock *sk)
 {
-	unsigned int tfo_bh_timeout = sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout;
+	unsigned int tfo_bh_timeout =
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout);
 	unsigned long timeout;
 	int tfo_da_times;
 	int multiplier;
-- 
2.30.2


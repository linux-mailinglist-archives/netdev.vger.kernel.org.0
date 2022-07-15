Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F935765C9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbiGORVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbiGORVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:21:16 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2888879682
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905677; x=1689441677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SZa8BwPwY1hQwxsvgN9f1icLn8H0f7JrlzIi8QHfW/w=;
  b=gmwvXqarFwOG2WPlyrsEtkE1rkmd3Sx/yDrl8kOqMo0e0+RINsJLZvvp
   /NcuOHrNkZXZLhz/HRyfO9/MUNm8gHuzfUiIE3iM7rt4fqDSqmTo+1RIN
   I0aneYHTrHr1M8yOFmSb2xPddXwHYLTFYvDQT/mYFnAGuyp4rs6uC8iSB
   E=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="238840049"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Jul 2022 17:21:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id B349D43DE2;
        Fri, 15 Jul 2022 17:21:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:21:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:21:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 12/15] tcp: Fix a data-race around sysctl_tcp_tw_reuse.
Date:   Fri, 15 Jul 2022 10:17:52 -0700
Message-ID: <20220715171755.38497-13-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_tw_reuse, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index da5a3c44c4fb..d16e6e40f47b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -108,10 +108,10 @@ static u32 tcp_v4_init_ts_off(const struct net *net, const struct sk_buff *skb)
 
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 {
+	int reuse = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tw_reuse);
 	const struct inet_timewait_sock *tw = inet_twsk(sktw);
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int reuse = sock_net(sk)->ipv4.sysctl_tcp_tw_reuse;
 
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
-- 
2.30.2


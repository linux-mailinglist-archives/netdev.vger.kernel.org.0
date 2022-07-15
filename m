Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3BB5765CE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiGORUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiGORUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:20:16 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135B6286CA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905615; x=1689441615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oRpWLG/0a0T6dlbmpF7DIbxw9CBZaBUtouHETSKvZEM=;
  b=t76Mxt+CEEMSIz0ImvssPnyO9hMM3ZpvCMlW4qAF/pgSGNtfTLQkMggz
   AYn0O6ztG7eXSSToqWFnQ4dPEEFpEUCTZsyM+pi+c5ya5zK/JGuAFyNbs
   +EoVl7anHekHrMMuW/Ttdpg/q6cH5x+vaG0MvnYnoAtl6cAHtY8DrwgTG
   k=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="108935574"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 15 Jul 2022 17:20:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 84DAF440D1;
        Fri, 15 Jul 2022 17:20:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:20:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:20:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 08/15] tcp: Fix data-races around sysctl_tcp_migrate_req.
Date:   Fri, 15 Jul 2022 10:17:48 -0700
Message-ID: <20220715171755.38497-9-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_migrate_req, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: f9ac779f881c ("net: Introduce net.ipv4.tcp_migrate_req.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/sock_reuseport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 3f00a28fe762..5daa1fa54249 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -387,7 +387,7 @@ void reuseport_stop_listen_sock(struct sock *sk)
 		prog = rcu_dereference_protected(reuse->prog,
 						 lockdep_is_held(&reuseport_lock));
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req ||
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req) ||
 		    (prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
 			/* Migration capable, move sk from the listening section
 			 * to the closed section.
@@ -545,7 +545,7 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	hash = migrating_sk->sk_hash;
 	prog = rcu_dereference(reuse->prog);
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req))
 			goto select_by_hash;
 		goto failure;
 	}
-- 
2.30.2


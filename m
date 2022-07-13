Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6B2573E52
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiGMUzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237347AbiGMUy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:54:58 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C512F012
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745697; x=1689281697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=39Drn+MVObR0dnfPuHQ8wkLccRvtiU9DqDHVRTuV/Mg=;
  b=FHZwHTLDAAXItzFleFeoOK5uGXjt4SuiAKL9aQoE89J7+RFQznD+OhWH
   k2E/ZxKgSW+KHbm3xCQi2MOFg6KHm/l4aKFT90vMQ2mFkfkYQE8lpYigv
   M5io0Ltstq9Hus1bS+BlxSt44/6Ul+UT4iJ0a50vTZnxfJbflviszOVHn
   c=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="217997477"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 13 Jul 2022 20:54:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com (Postfix) with ESMTPS id D9612160CA3;
        Wed, 13 Jul 2022 20:54:54 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:54:53 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:54:51 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 09/15] tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
Date:   Wed, 13 Jul 2022 13:51:59 -0700
Message-ID: <20220713205205.15735-10-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 6dd9a14e92e5 ("net: Allow accepted sockets to be bound to l3mdev domain")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h | 2 +-
 include/net/inet_sock.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ebfa3df6f8dc..fd6b510d114b 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -179,7 +179,7 @@ static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 					int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_tcp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index b29108f0973a..6395f6b9a5d2 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -121,7 +121,7 @@ static inline int inet_request_bound_dev_if(const struct sock *sk,
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
@@ -133,7 +133,7 @@ static inline int inet_sk_bound_l3mdev(const struct sock *sk)
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net,
 						      sk->sk_bound_dev_if);
 #endif
-- 
2.30.2


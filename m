Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104E35EC92F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiI0QNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiI0QNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:13:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A7E915D5;
        Tue, 27 Sep 2022 09:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664295213; x=1695831213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4gy6y9RluD7Ishn0pzYcwsWmftF1WClFyBmqV8OA2xs=;
  b=Hekt2o2ez/lZUHbbZnMVOz81q+cvUuB4h5QpI8zTyVx/Ea1iZXxyjXqg
   XgqMPVVnWvMpQL8KMw0xiJTpEOHD3GdMUCtNQo2LSpDuxriibQdo6kGJn
   ilVL4SgtF0BULRSyX6lBCQ/cLfQ/e/tv3rVdS/ZkWrQzaljyqjq0U/Glm
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,349,1654560000"; 
   d="scan'208";a="228971190"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 16:13:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 24AE7804B3;
        Tue, 27 Sep 2022 16:13:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 27 Sep 2022 16:13:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 27 Sep 2022 16:13:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        "Vladislav Yasevich" <vyasevic@redhat.com>
Subject: [PATCH v1 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv4 sk_prot->destroy().
Date:   Tue, 27 Sep 2022 09:12:07 -0700
Message-ID: <20220927161209.32939-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927161209.32939-1-kuniyu@amazon.com>
References: <20220927161209.32939-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D13UWA002.ant.amazon.com (10.43.160.172) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
Add lockless sendmsg() support") added a lockless memory allocation path,
which could cause a memory leak:

setsockopt(IPV6_ADDRFORM)                 sendmsg()
+-----------------------+                 +-------+
- do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
  - lock_sock(sk)                           ^._ called via udpv6_prot
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
  - inet6_destroy_sock()
  - release_sock(sk)                        - ip6_make_skb(sk, ...)
                                              ^._ lockless fast path for
                                                  the non-corking case

                                              - __ip6_append_data(sk, ...)
                                                - ipv6_local_rxpmtu(sk, ...)
                                                  - xchg(&np->rxpmtu, skb)
                                                    ^._ rxpmtu is never freed.

                                            - lock_sock(sk)

For now, rxpmtu is only the case, but let's call inet6_destroy_sock()
in both TCP/UDP v4 destroy functions not to miss the future change.

We can consolidate TCP/UDP v4/v6 destroy functions, but such changes
are too invasive to backport to stable.  So, they can be posted as a
follow-up later for net-next.

Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Vladislav Yasevich <vyasevic@redhat.com>
---
 net/ipv4/tcp_ipv4.c | 5 +++++
 net/ipv4/udp.c      | 6 ++++++
 net/ipv6/tcp_ipv6.c | 1 -
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b019ba2b9d2..035b6c52a243 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2263,6 +2263,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
 	tcp_saved_syn_free(tp);
 
 	sk_sockets_allocated_dec(sk);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_prot_creator == &tcpv6_prot)
+		inet6_destroy_sock(sk);
+#endif
 }
 EXPORT_SYMBOL(tcp_v4_destroy_sock);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 560d9eadeaa5..cdf131c0a819 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -115,6 +115,7 @@
 #include <net/udp_tunnel.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
+#include <net/transp_v6.h>
 #endif
 
 struct udp_table udp_table __read_mostly;
@@ -2666,6 +2667,11 @@ void udp_destroy_sock(struct sock *sk)
 		if (up->encap_enabled)
 			static_branch_dec(&udp_encap_needed_key);
 	}
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_prot_creator == &udpv6_prot)
+		inet6_destroy_sock(sk);
+#endif
 }
 
 /*
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e54eee80ce5f..1ff6a92f7774 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1945,7 +1945,6 @@ static int tcp_v6_init_sock(struct sock *sk)
 static void tcp_v6_destroy_sock(struct sock *sk)
 {
 	tcp_v4_destroy_sock(sk);
-	inet6_destroy_sock(sk);
 }
 
 #ifdef CONFIG_PROC_FS
-- 
2.30.2


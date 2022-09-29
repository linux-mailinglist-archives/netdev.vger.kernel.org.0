Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BD85EEAE8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiI2B04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiI2B0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:26:52 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E901E118DFD;
        Wed, 28 Sep 2022 18:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664414810; x=1695950810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=juZrWuPhrQCL6QFv/8tceKhTkSm+otOiz6Eh6Vzhh2c=;
  b=V2EHUWODywLSK8HrDJTC+q52+4AykN2hNMs9n01n5xBDx3RWiObV8i+5
   aIVNsjZtIG3xPSKI0QULyk8nowI23zNx7A7c+0K8D9SrLrAxwOtDXZqvc
   skCdtTSteQcE4f1eIVse2NeugLeITSROtiJUcaVr3GrMehDLwLsH21DSt
   E=;
X-IronPort-AV: E=Sophos;i="5.93,353,1654560000"; 
   d="scan'208";a="229388589"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 01:26:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 6413B1A000D;
        Thu, 29 Sep 2022 01:26:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 01:26:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 29 Sep 2022 01:26:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net 2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
Date:   Wed, 28 Sep 2022 18:25:39 -0700
Message-ID: <20220929012542.55424-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929012542.55424-1-kuniyu@amazon.com>
References: <20220929012542.55424-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D30UWB004.ant.amazon.com (10.43.161.51) To
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

Commit 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support") forgot
to add a change to free inet6_sk(sk)->rxpmtu while converting an IPv6
socket into IPv4 with IPV6_ADDRFORM.  After conversion, sk_prot is
changed to udp_prot and ->destroy() never cleans it up, resulting in
a memory leak.

This is due to the discrepancy between inet6_destroy_sock() and
IPV6_ADDRFORM, so let's call inet6_destroy_sock() from IPV6_ADDRFORM
to remove the difference.

However, this is not enough for now because rxpmtu can be changed
without lock_sock() after commit 03485f2adcde ("udpv6: Add lockless
sendmsg() support").  We will fix this case in the following patch.

Note we will rename inet6_destroy_sock() to inet6_cleanup_sock() and
remove unnecessary inet6_destroy_sock() calls in sk_prot->destroy()
in the future.

Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/af_inet6.c      |  6 ++++++
 net/ipv6/ipv6_sockglue.c | 20 ++++++++------------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index de9dcc5652c4..dfa70789b771 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1178,6 +1178,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
+void inet6_cleanup_sock(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index dbb1430d6cc2..83b9e432f3df 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -510,6 +510,12 @@ void inet6_destroy_sock(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet6_destroy_sock);
 
+void inet6_cleanup_sock(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+EXPORT_SYMBOL_GPL(inet6_cleanup_sock);
+
 /*
  *	This does both peername and sockname.
  */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index b61066ac8648..d258c94745ca 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -431,9 +431,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen < sizeof(int))
 			goto e_inval;
 		if (val == PF_INET) {
-			struct ipv6_txoptions *opt;
-			struct sk_buff *pktopt;
-
 			if (sk->sk_type == SOCK_RAW)
 				break;
 
@@ -464,7 +461,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				break;
 			}
 
-			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
 			__ipv6_sock_ac_close(sk);
 
@@ -501,14 +497,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
 			}
-			opt = xchg((__force struct ipv6_txoptions **)&np->opt,
-				   NULL);
-			if (opt) {
-				atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
-				txopt_put(opt);
-			}
-			pktopt = xchg(&np->pktoptions, NULL);
-			kfree_skb(pktopt);
+
+			/* Disable all options not to allocate memory anymore,
+			 * but there is still a race.  See the lockless path
+			 * in udpv6_sendmsg() and ipv6_local_rxpmtu().
+			 */
+			np->rxopt.all = 0;
+
+			inet6_cleanup_sock(sk);
 
 			/*
 			 * ... and add it to the refcnt debug socks count
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2823A5F6DC3
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 20:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJFSzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 14:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJFSzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 14:55:04 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069C389817;
        Thu,  6 Oct 2022 11:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665082503; x=1696618503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HUYI0ewwVgtBWh/sr3SVaJWOAc8q9Q73+dm0isNOJAY=;
  b=V11Y5CysU1B1TCxCYUnA0D6KhWpPySGmN9CuJhxpJIfm51GI/6PrKcLG
   1FXAhP36PVpUI3TC5VrBKzcSWhLh04zIlBjk6ZNrVkGhB65OJ01t+r+sF
   m+6cURLUJnCL1GFuBywV8+iXGfBIHncw9NMmFOMSkpIcWzHVNWwxzHbCu
   o=;
X-IronPort-AV: E=Sophos;i="5.95,164,1661817600"; 
   d="scan'208";a="249194658"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:54:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 9084880445;
        Thu,  6 Oct 2022 18:54:47 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 6 Oct 2022 18:54:35 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.176) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 6 Oct 2022 18:54:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, "Brian Haley" <brian.haley@hp.com>
Subject: [PATCH v5 net 2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
Date:   Thu, 6 Oct 2022 11:53:46 -0700
Message-ID: <20221006185349.74777-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221006185349.74777-1-kuniyu@amazon.com>
References: <20221006185349.74777-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D18UWA003.ant.amazon.com (10.43.160.238) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Cc: Brian Haley <brian.haley@hp.com>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/af_inet6.c      |  6 ++++++
 net/ipv6/ipv6_sockglue.c | 20 ++++++++------------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d664ba5812d8..335a49ecd8a0 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1182,6 +1182,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
 void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
 
+void inet6_cleanup_sock(struct sock *sk);
 int inet6_release(struct socket *sock);
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d40b7d60e00e..ded827944fa6 100644
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
index 408345fc4c5c..a20edae868fd 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -431,9 +431,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen < sizeof(int))
 			goto e_inval;
 		if (val == PF_INET) {
-			struct ipv6_txoptions *opt;
-			struct sk_buff *pktopt;
-
 			if (sk->sk_type == SOCK_RAW)
 				break;
 
@@ -464,7 +461,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				break;
 			}
 
-			fl6_free_socklist(sk);
 			__ipv6_sock_mc_close(sk);
 			__ipv6_sock_ac_close(sk);
 
@@ -501,14 +497,14 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
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


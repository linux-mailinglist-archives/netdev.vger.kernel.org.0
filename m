Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FCE5ED202
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiI1A2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiI1A2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:28:39 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102CC112640;
        Tue, 27 Sep 2022 17:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664324919; x=1695860919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cG5QFUOse6ZgSXn7rkvIFVfd2FWaMEJExfj2H+4EF94=;
  b=R6c8xmfrsTsyQB/i+NhtUKOX0DrWd3t+j6p3jrmQiJ711IPH+4sGKmO5
   MDGGAZhOvNQ5fxurKWa7lowsmqBzY5HczSTVStXG9ltIIGoS/fB7lyavU
   4d+1BtfEIOrbrk3JSGm/CSnuEXihI1Tx2eiFDYnezNkLYSoFLDPmx4n0I
   A=;
X-IronPort-AV: E=Sophos;i="5.93,350,1654560000"; 
   d="scan'208";a="134676797"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 00:28:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com (Postfix) with ESMTPS id 24825C0262;
        Wed, 28 Sep 2022 00:28:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 00:28:18 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 28 Sep 2022 00:28:16 +0000
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
Subject: [PATCH v2 net 2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
Date:   Tue, 27 Sep 2022 17:27:38 -0700
Message-ID: <20220928002741.64237-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220928002741.64237-1-kuniyu@amazon.com>
References: <20220928002741.64237-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
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

Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/ipv6_sockglue.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index b61066ac8648..030a4cf23ceb 100644
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
 
@@ -501,14 +497,9 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
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
+			np->rxopt.all = 0;
+			inet6_destroy_sock(sk);
 
 			/*
 			 * ... and add it to the refcnt debug socks count
-- 
2.30.2


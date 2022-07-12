Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C905E570EEA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGLAWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiGLAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:21:41 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212548B493;
        Mon, 11 Jul 2022 17:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585255; x=1689121255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpFsWJFzay/J0RJVIAQkY1+S1ovBvAqv3a/fYcGd3C8=;
  b=X9A5lUAg9ubXaflkA2fDTWzvoC2dfRtMQOtgjjDYP6SwBezqCOuar0Vi
   fhOeC/7g3//UR/4ITHxkSeWcJFWw7a2AJ3fN+KfPIyMFV+Nwrq31s1DKJ
   wFpyvli7YBZKpWPYbTEuNlp5eNLhJGspAzIp/CgwWbuwmYnlmLEiP48sg
   A=;
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 Jul 2022 00:20:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id C774C812AF;
        Tue, 12 Jul 2022 00:20:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:20:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:20:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH v1 net 15/15] nexthop: Fix data-races around nexthop_compat_mode.
Date:   Mon, 11 Jul 2022 17:15:33 -0700
Message-ID: <20220712001533.89927-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
References: <20220712001533.89927-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading nexthop_compat_mode, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f80116d3df3 ("net: ipv4: add sysctl for nexthop api compatibility mode")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 net/ipv4/nexthop.c       | 5 +++--
 net/ipv6/route.c         | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a57ba23571c9..16dbd5075284 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1811,7 +1811,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
-		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
+		if (!READ_ONCE(fi->fib_net->ipv4.sysctl_nexthop_compat_mode))
 			goto offload;
 	}
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e459a391e607..853a75a8fbaf 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1858,7 +1858,7 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
 		ipv6_stub->ip6_del_rt(net, f6i,
-				      !net->ipv4.sysctl_nexthop_compat_mode);
+				      !READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode));
 	}
 }
 
@@ -2361,7 +2361,8 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
-		if (replace_notify && net->ipv4.sysctl_nexthop_compat_mode)
+		if (replace_notify &&
+		    READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode))
 			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 828355710c57..916417944ec8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5741,7 +5741,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (nexthop_is_blackhole(rt->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
 
-		if (net->ipv4.sysctl_nexthop_compat_mode &&
+		if (READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode) &&
 		    rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
 			goto nla_put_failure;
 
-- 
2.30.2


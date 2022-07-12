Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF25570ED5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiGLATI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiGLASn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:18:43 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE0E419B6;
        Mon, 11 Jul 2022 17:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585050; x=1689121050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bELWj50x0r6pox5hBuqrntCvwN+QJVG+vistDS8tNgo=;
  b=UVHfilRPIhWrLtUj7MYddtzIlbKrgdYUFHkXeC98GRTRcyrmoWEb+99C
   jH0z3qcxJVGA85pQ7XMGfWDQbj9cixow9JbHL2WWG9qqTJz61xs3Bvgjo
   0ynJ5GeolAgVnPUZF7GY3o4qdGYaNUCxnQUt1DqEUcydQFGNKvAC8DfYL
   c=;
X-IronPort-AV: E=Sophos;i="5.92,264,1650931200"; 
   d="scan'208";a="107193886"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 12 Jul 2022 00:17:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id 20A528178A;
        Tue, 12 Jul 2022 00:17:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:17:27 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:17:23 +0000
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
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v1 net 05/15] icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
Date:   Mon, 11 Jul 2022 17:15:23 -0700
Message-ID: <20220712001533.89927-6-kuniyu@amazon.com>
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

While reading sysctl_icmp_echo_enable_probe, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Fixes: 1fd07f33c3ea ("ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Andreas Roeseler <andreas.a.roeseler@gmail.com>
CC: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/icmp.c | 2 +-
 net/ipv6/icmp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1df4aae310e0..c406e324c594 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1028,7 +1028,7 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	u16 ident_len;
 	u8 status;
 
-	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 		return false;
 
 	/* We currently only support probing interfaces on the proxy node
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 61770220774e..9d92d51c4757 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -925,7 +925,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		break;
 	case ICMPV6_EXT_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
-		    net->ipv4.sysctl_icmp_echo_enable_probe)
+		    READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 			icmpv6_echo_reply(skb);
 		break;
 
-- 
2.30.2


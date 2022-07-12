Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B75570EE5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiGLAVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiGLAV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:21:27 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE0E48CB0;
        Mon, 11 Jul 2022 17:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585230; x=1689121230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uYn04R1QKPzx8CqsEpbFD6fgLYV73ozT9ItEiZYtZN8=;
  b=HTOuKkdFGgGmfmYRrL4QbZKBelWPuJ1Yxi0FekIaDP7W2Ia3dsf4T2Xn
   HzqPgA/DOktfm2WPIsxPZ0+mOHGHzNnIBB6YArAepx9GTEO7H3fiB1MH4
   VOWjOkBAfZd77DZkY/PNeKtQ7Twa4nCz0M9jYtDZ9WntZy40NUpEcOytl
   k=;
X-IronPort-AV: E=Sophos;i="5.92,264,1650931200"; 
   d="scan'208";a="220431765"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 Jul 2022 00:20:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 5A8BF43D40;
        Tue, 12 Jul 2022 00:20:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:20:25 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:20:22 +0000
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
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Mirja=20K=C3=BChlewind?= 
        <mirja.kuehlewind@tik.ee.ethz.ch>,
        Brian Trammell <trammell@tik.ee.ethz.ch>
Subject: [PATCH v1 net 13/15] tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
Date:   Mon, 11 Jul 2022 17:15:31 -0700
Message-ID: <20220712001533.89927-14-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
References: <20220712001533.89927-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_ecn_fallback, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 492135557dc0 ("tcp: add rfc3168, section 6.1.1.1. fallback")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Daniel Borkmann <daniel@iogearbox.net>
CC: Florian Westphal <fw@strlen.de>
CC: Mirja Kühlewind <mirja.kuehlewind@tik.ee.ethz.ch>
CC: Brian Trammell <trammell@tik.ee.ethz.ch>
---
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 net/ipv4/tcp_output.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5e308c1715af..108fd86f2718 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -685,6 +685,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_dynaddr",
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3dc17551ce25..11aa0ab10bba 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -346,7 +346,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 
 static void tcp_ecn_clear_syn(struct sock *sk, struct sk_buff *skb)
 {
-	if (sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback))
 		/* tp->ecn_flags are cleared at a later point in time when
 		 * SYN ACK is ultimatively being received.
 		 */
-- 
2.30.2


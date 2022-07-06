Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89B567DBB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiGFFYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiGFFYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:24:10 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327A221262;
        Tue,  5 Jul 2022 22:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085050; x=1688621050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UREuWIA4n/gQgUYFb12EHn5QU00DoLCLIVMfPtDRmXs=;
  b=kfyRI0U5nG4nNsWr+V8vDop6KfxKJVrErChfMrV4/4skFFvsOMK/+Fd8
   fUV88WEioBQLq/RjnUASH2RiiFpkmtMsqtcT8EJI6H0/Ob7nCqpurZ5Fz
   WgdvB5+I4GeiilDcT52ABk+uemeysCS8z95/qjUL/sjlguy6RICns1ZAJ
   I=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="235271105"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 Jul 2022 05:24:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 7EF4E4C0079;
        Wed,  6 Jul 2022 05:24:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:24:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:24:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 10/16] inetpeer: Fix data-races around sysctl.
Date:   Tue, 5 Jul 2022 22:21:24 -0700
Message-ID: <20220706052130.16368-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706052130.16368-1-kuniyu@amazon.com>
References: <20220706052130.16368-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D18UWA004.ant.amazon.com (10.43.160.45) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl variables, they can be changed concurrently.  So, we
need to add READ_ONCE().  Then we can set lockless variants as the handler
to mark them safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inetpeer.c        | 13 ++++++++-----
 net/ipv4/sysctl_net_ipv4.c |  6 +++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index da21dfce24d7..69e1342a9068 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -141,16 +141,19 @@ static void inet_peer_gc(struct inet_peer_base *base,
 			 struct inet_peer *gc_stack[],
 			 unsigned int gc_cnt)
 {
+	int i, peer_threshold, peer_maxttl, peer_minttl;
 	struct inet_peer *p;
 	__u32 delta, ttl;
-	int i;
 
-	if (base->total >= inet_peer_threshold)
+	peer_threshold = READ_ONCE(inet_peer_threshold);
+	peer_maxttl = READ_ONCE(inet_peer_maxttl);
+	peer_minttl = READ_ONCE(inet_peer_minttl);
+
+	if (base->total >= peer_threshold)
 		ttl = 0; /* be aggressive */
 	else
-		ttl = inet_peer_maxttl
-				- (inet_peer_maxttl - inet_peer_minttl) / HZ *
-					base->total / inet_peer_threshold * HZ;
+		ttl = peer_maxttl - (peer_maxttl - peer_minttl) / HZ *
+			base->total / peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index aa5adf136556..eea11218a663 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -483,21 +483,21 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &inet_peer_threshold,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_lockless,
 	},
 	{
 		.procname	= "inet_peer_minttl",
 		.data		= &inet_peer_minttl,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies_lockless,
 	},
 	{
 		.procname	= "inet_peer_maxttl",
 		.data		= &inet_peer_maxttl,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies_lockless,
 	},
 	{
 		.procname	= "tcp_mem",
-- 
2.30.2


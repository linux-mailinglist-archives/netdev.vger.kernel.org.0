Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E05567DBA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiGFFZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiGFFZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:25:26 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33AB21832;
        Tue,  5 Jul 2022 22:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085125; x=1688621125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PAHZJLR0VKsPtaE3Lf0xNPA4gDWSGnYveB872veX8og=;
  b=chbTU772vvFcaMfoyjw/Jo8SCDgDOnxTbJaaQVFR2a+PXosDmCkXqxZA
   V6UgjhKPY2+pUgNaz6g4Y/6sjCkGChPRxtqOmYY8pUUnxzbqvlodwJSC/
   ukmYNt9kSU5ivK+ug7Nf3ZzsMKojPeka96Af+TtxZiI+lCQoleemEzieq
   A=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="105282730"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Jul 2022 05:25:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id 2598583A35;
        Wed,  6 Jul 2022 05:25:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:25:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:25:22 +0000
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
Subject: [PATCH v1 net 15/16] icmp: Fix data-races around sysctl.
Date:   Tue, 5 Jul 2022 22:21:29 -0700
Message-ID: <20220706052130.16368-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706052130.16368-1-kuniyu@amazon.com>
References: <20220706052130.16368-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D18UWA004.ant.amazon.com (10.43.160.45) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl variables, it can be changed concurrently.  So, we
need to add READ_ONCE().  Then we can set proc_dointvec_minmax_lockless()
as the handler to mark it safe.

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/icmp.c            | 5 +++--
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index efea0e796f06..0f9e61d29f73 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -253,11 +253,12 @@ bool icmp_global_allow(void)
 	spin_lock(&icmp_global.lock);
 	delta = min_t(u32, now - icmp_global.stamp, HZ);
 	if (delta >= HZ / 50) {
-		incr = sysctl_icmp_msgs_per_sec * delta / HZ ;
+		incr = READ_ONCE(sysctl_icmp_msgs_per_sec) * delta / HZ;
 		if (incr)
 			WRITE_ONCE(icmp_global.stamp, now);
 	}
-	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
+	credit = min_t(u32, icmp_global.credit + incr,
+		       READ_ONCE(sysctl_icmp_msgs_burst));
 	if (credit) {
 		/* We want to use a credit of one in average, but need to randomize
 		 * it for security reasons.
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 706795a3b369..3b1d18be0857 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -555,7 +555,7 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_icmp_msgs_per_sec,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_lockless,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
@@ -563,7 +563,7 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_icmp_msgs_burst,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_lockless,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
-- 
2.30.2


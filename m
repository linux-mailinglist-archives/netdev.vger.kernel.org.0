Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB91D567DCE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiGFFYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiGFFX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:58 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01055E24;
        Tue,  5 Jul 2022 22:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085038; x=1688621038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RL9MqhtNP4Ugne5QDUZKCAePLOhZ+YJB8hMatNmUWcU=;
  b=tBS1h8G+JAFEoMA1is0wW3zX71jLb/d6H0gMIrzid8dQCCwRg/HlGQKr
   o/wPBCaExuTkJE9hePU7pRIrOABxnk4H117EYZXSywD9BsdrDEvQHxC5T
   hEoBRWX84reNnyfqKkkRLokOd6rG1xOpvd9fE0bgQ3WWjG5VIni9TENyY
   U=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="105282475"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Jul 2022 05:23:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 5974843CB2;
        Wed,  6 Jul 2022 05:23:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:23:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:23:52 +0000
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
Subject: [PATCH v1 net 09/16] tcp: Fix a data-race around sysctl_tcp_max_orphans.
Date:   Tue, 5 Jul 2022 22:21:23 -0700
Message-ID: <20220706052130.16368-10-kuniyu@amazon.com>
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

While reading sysctl_tcp_max_orphans, it can be changed concurrently.  So,
we need to add READ_ONCE().  Then we can set proc_dointvec_lockless() as
the handler to mark it safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/sysctl_net_ipv4.c | 2 +-
 net/ipv4/tcp.c             | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index cd448cdd3b38..aa5adf136556 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -476,7 +476,7 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_tcp_max_orphans,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_lockless,
 	},
 	{
 		.procname	= "inet_peer_threshold",
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 028513d3e2a2..2222dfdde316 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2715,7 +2715,8 @@ static void tcp_orphan_update(struct timer_list *unused)
 
 static bool tcp_too_many_orphans(int shift)
 {
-	return READ_ONCE(tcp_orphan_cache) << shift > sysctl_tcp_max_orphans;
+	return READ_ONCE(tcp_orphan_cache) << shift >
+		READ_ONCE(sysctl_tcp_max_orphans);
 }
 
 bool tcp_check_oom(struct sock *sk, int shift)
-- 
2.30.2


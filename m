Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86059567DC6
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiGFFYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiGFFY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:24:29 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F81DFA3;
        Tue,  5 Jul 2022 22:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085069; x=1688621069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+cH8pDBZl8/HQwEHXwH86DKS0pMpJjRpbkVZtbXxfPs=;
  b=R7J3cmSv2ET+N3wEa6BZoooVsc3Q3HvFBpJRIXtPIgfYkqyz8h03hhrn
   rqEnU4/i7DJd18TavtuEFldFAZqVFWiYY3ad7W9Eqelmc/dWNQi6zK5L6
   maspq7QND53p/m8UuwqX3+/g/WmV1QJA7nYayH7FhpstJbU3Hn1gvdHfQ
   k=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="207627504"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Jul 2022 05:24:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 6A12E43CD4;
        Wed,  6 Jul 2022 05:24:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:24:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:24:22 +0000
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: [PATCH v1 net 11/16] net: Fix a data-race around sysctl_mem.
Date:   Tue, 5 Jul 2022 22:21:25 -0700
Message-ID: <20220706052130.16368-12-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading .sysctl_mem, it can be changed concurrently.  So, we need to
add READ_ONCE().  Then we can set proc_doulongvec_minmax_lockless() as the
handler to mark it safe.

Fixes: 3847ce32aea9 ("core: add tracepoints for queueing skb to rcvbuf")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Satoru Moriya <satoru.moriya@hds.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/sock.h             | 2 +-
 include/trace/events/sock.h    | 6 +++---
 net/decnet/sysctl_net_decnet.c | 2 +-
 net/ipv4/sysctl_net_ipv4.c     | 4 ++--
 net/sctp/sysctl.c              | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 72ca97ccb460..9fa54762e077 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1529,7 +1529,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 12c315782766..3c36c2812782 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -122,9 +122,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
 		__entry->name,
-		__entry->sysctl_mem[0],
-		__entry->sysctl_mem[1],
-		__entry->sysctl_mem[2],
+		READ_ONCE(__entry->sysctl_mem[0]),
+		READ_ONCE(__entry->sysctl_mem[1]),
+		READ_ONCE(__entry->sysctl_mem[2]),
 		__entry->allocated,
 		__entry->sysctl_rmem,
 		__entry->rmem_alloc,
diff --git a/net/decnet/sysctl_net_decnet.c b/net/decnet/sysctl_net_decnet.c
index 67b5ab2657b7..e7e658f1ba67 100644
--- a/net/decnet/sysctl_net_decnet.c
+++ b/net/decnet/sysctl_net_decnet.c
@@ -315,7 +315,7 @@ static struct ctl_table dn_table[] = {
 		.data = &sysctl_decnet_mem,
 		.maxlen = sizeof(sysctl_decnet_mem),
 		.mode = 0644,
-		.proc_handler = proc_doulongvec_minmax
+		.proc_handler = proc_doulongvec_minmax_lockless,
 	},
 	{
 		.procname = "decnet_rmem",
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index eea11218a663..b14931ca5c85 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -504,7 +504,7 @@ static struct ctl_table ipv4_table[] = {
 		.maxlen		= sizeof(sysctl_tcp_mem),
 		.data		= &sysctl_tcp_mem,
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax_lockless,
 	},
 	{
 		.procname	= "tcp_low_latency",
@@ -570,7 +570,7 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_udp_mem,
 		.maxlen		= sizeof(sysctl_udp_mem),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax_lockless,
 	},
 	{
 		.procname	= "fib_sync_mem",
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b46a416787ec..fa79bf4059d1 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -64,7 +64,7 @@ static struct ctl_table sctp_table[] = {
 		.data		= &sysctl_sctp_mem,
 		.maxlen		= sizeof(sysctl_sctp_mem),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax
+		.proc_handler	= proc_doulongvec_minmax_lockless,
 	},
 	{
 		.procname	= "sctp_rmem",
-- 
2.30.2


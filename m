Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D78B567DB4
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiGFFXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiGFFXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:02 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFABA2180D;
        Tue,  5 Jul 2022 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084976; x=1688620976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mKWxbo4eRi3u9tBD8C1LmmWJYH/wd8q8AiV00I6QWKU=;
  b=ITbuIF+E3OLRzFapurihekpwkaBbR0x6tVc9BIjR28yFkX54anVd6pUB
   3YzQuxFiEY2C2Jq80hejs7HPXes0j5ej58mwXiu8oyLFGwz97K3n3tGmV
   Uar4hvy5wdG4oCSKwZjeiNOwWliiiVkhl/+sN1ARiPOqVgkQLHZ6PJp3R
   E=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="235270838"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 Jul 2022 05:22:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com (Postfix) with ESMTPS id 17506C0858;
        Wed,  6 Jul 2022 05:22:40 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:22:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:22:36 +0000
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
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH v1 net 04/16] sysctl: Add proc_douintvec_lockless().
Date:   Tue, 5 Jul 2022 22:21:18 -0700
Message-ID: <20220706052130.16368-5-kuniyu@amazon.com>
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

A sysctl variable is accessed concurrently, and there is always a chance of
data-race.  So, all readers and writers need some basic protection to avoid
load/store-tearing.

This patch changes proc_douintvec() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now,
proc_douintvec() itself is tolerant to a data-race, but we still need to
add annotations on the other subsystem's side.

In case we miss such fixes, this patch converts proc_douintvec() to a
wrapper of proc_douintvec_lockless().  When we fix a data-race in the other
subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_douintvec()'s document and adds
proc_douintvec_lockless()'s one so that no one will use proc_douintvec()
anymore.

Fixes: e7d316a02f68 ("sysctl: handle error writing UINT_MAX to u32 fields")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index cb87919b5508..770ee1833c25 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -85,6 +85,7 @@ PROC_HANDLER(proc_do_static_key);
 
 PROC_HANDLER(proc_dobool_lockless);
 PROC_HANDLER(proc_dointvec_lockless);
+PROC_HANDLER(proc_douintvec_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 50d9b78aa0b3..be8a7d912180 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -474,9 +474,11 @@ static int do_proc_douintvec_conv(unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		*valp = *lvalp;
+
+		WRITE_ONCE(*valp, *lvalp);
 	} else {
-		unsigned int val = *valp;
+		unsigned int val = READ_ONCE(*valp);
+
 		*lvalp = (unsigned long)val;
 	}
 	return 0;
@@ -775,7 +777,7 @@ static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
 #endif
 
 /**
- * proc_douintvec - read a vector of unsigned integers
+ * proc_douintvec_lockless - read/write a vector of unsigned integers locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -787,13 +789,19 @@ static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
  *
  * Returns 0 on success.
  */
-int proc_douintvec(struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos)
+int proc_douintvec_lockless(struct ctl_table *table, int write, void *buffer,
+			    size_t *lenp, loff_t *ppos)
 {
 	return do_proc_douintvec(table, write, buffer, lenp, ppos,
 				 do_proc_douintvec_conv, NULL);
 }
 
+int proc_douintvec(struct ctl_table *table, int write, void *buffer,
+		   size_t *lenp, loff_t *ppos)
+{
+	return proc_douintvec_lockless(table, write, buffer, lenp, ppos);
+}
+
 /*
  * Taint values can only be increased
  * This means we can safely use a temporary.
@@ -1513,6 +1521,7 @@ PROC_HANDLER_ENOSYS(proc_do_large_bitmap);
 
 PROC_HANDLER_ENOSYS(proc_dobool_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_lockless);
+PROC_HANDLER_ENOSYS(proc_douintvec_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2425,3 +2434,4 @@ EXPORT_SYMBOL(proc_do_large_bitmap);
 
 EXPORT_SYMBOL(proc_dobool_lockless);
 EXPORT_SYMBOL(proc_dointvec_lockless);
+EXPORT_SYMBOL(proc_douintvec_lockless);
-- 
2.30.2


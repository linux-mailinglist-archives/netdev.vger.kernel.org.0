Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945AD567DCD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiGFFX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiGFFXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:45 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5017DFA3;
        Tue,  5 Jul 2022 22:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085025; x=1688621025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uJwiKDdUCE6ejBVfaNJ0Ksuef2MfhE73OPMC2pigcSU=;
  b=ip44yNYxVTvFZiW5SkFBN+O+hc9hWowPPNP59tYv+z+HnBTUkaaaWcWR
   FcP9TQWtqHZ95DYu1CCpFDV4W4m4vLaQN1X14zTQnBHc5WNdAFhZFeto0
   WCijZyhKROb4mmgyKYE/Vdt5p0q967GUEjpXlETm+T99BbcvgPb9Sn6VI
   M=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="215167311"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 06 Jul 2022 05:23:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 357E043CB2;
        Wed,  6 Jul 2022 05:23:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:23:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:23:36 +0000
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
Subject: [PATCH v1 net 08/16] sysctl: Add proc_dointvec_jiffies_lockless().
Date:   Tue, 5 Jul 2022 22:21:22 -0700
Message-ID: <20220706052130.16368-9-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sysctl variable is accessed concurrently, and there is always a chance of
data-race.  So, all readers and writers need some basic protection to avoid
load/store-tearing.

This patch changes proc_dointvec_jiffies() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now,
proc_dointvec_jiffies() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

In case we miss such fixes, this patch converts proc_dointvec_jiffies() to
a wrapper of proc_dointvec_jiffies_lockless().  When we fix a data-race in
the other subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_dointvec_jiffies()'s document and adds
proc_dointvec_jiffies_lockless()'s one so that no one will use
proc_dointvec_jiffies() anymore.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c23b6beef748..8747dbc721f5 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -89,6 +89,7 @@ PROC_HANDLER(proc_douintvec_lockless);
 PROC_HANDLER(proc_dointvec_minmax_lockless);
 PROC_HANDLER(proc_douintvec_minmax_lockless);
 PROC_HANDLER(proc_doulongvec_minmax_lockless);
+PROC_HANDLER(proc_dointvec_jiffies_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 931ab58985f2..11a1ce837623 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1221,10 +1221,15 @@ static int do_proc_dointvec_jiffies_conv(bool *negp, unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > INT_MAX / HZ)
 			return 1;
-		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
+
+		if (*negp)
+			WRITE_ONCE(*valp, -(*lvalp * HZ));
+		else
+			WRITE_ONCE(*valp, *lvalp * HZ);
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		unsigned long lval;
+
 		if (val < 0) {
 			*negp = true;
 			lval = -(unsigned long)val;
@@ -1286,7 +1291,8 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 }
 
 /**
- * proc_dointvec_jiffies - read a vector of integers as seconds
+ * proc_dointvec_jiffies_lockless - read/write a vector of integers as
+ * seconds locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -1294,17 +1300,23 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  * The values read are assumed to be in seconds, and are converted into
  * jiffies.
  *
  * Returns 0 on success.
  */
+int proc_dointvec_jiffies_lockless(struct ctl_table *table, int write,
+				   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_jiffies_conv, NULL);
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    do_proc_dointvec_jiffies_conv,NULL);
+	return proc_dointvec_jiffies_lockless(table, write, buffer, lenp, ppos);
 }
 
 /**
@@ -1552,6 +1564,7 @@ PROC_HANDLER_ENOSYS(proc_douintvec_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_minmax_lockless);
 PROC_HANDLER_ENOSYS(proc_douintvec_minmax_lockless);
 PROC_HANDLER_ENOSYS(proc_doulongvec_minmax_lockless);
+PROC_HANDLER_ENOSYS(proc_dointvec_jiffies_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2468,3 +2481,4 @@ EXPORT_SYMBOL(proc_douintvec_lockless);
 EXPORT_SYMBOL(proc_dointvec_minmax_lockless);
 EXPORT_SYMBOL_GPL(proc_douintvec_minmax_lockless);
 EXPORT_SYMBOL(proc_doulongvec_minmax_lockless);
+EXPORT_SYMBOL(proc_dointvec_jiffies_lockless);
-- 
2.30.2


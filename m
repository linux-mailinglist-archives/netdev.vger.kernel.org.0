Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA36C567DB3
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiGFFW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiGFFW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:22:28 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AD4205F0;
        Tue,  5 Jul 2022 22:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084947; x=1688620947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nXgol3t1QpvI6in0uKJ77IASldBl9uWqY9rKUYy3dVc=;
  b=R5tB7PqpH13hGGQFdzTOcZche8ElVXvks24T1vkKTgFqdom4ixemnmm+
   Cb19zPnWbFkW/79WZ08xQnVh9QibyNzo8JZUZBA7aHjM+vvupa524Re56
   2INnnJ8vND8rh2veu3gDcF4IdqNdPElkMLwuMoW6K0Te3kdKIKwxR5CVP
   I=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="1031201485"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 06 Jul 2022 05:22:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 7134943B52;
        Wed,  6 Jul 2022 05:22:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:22:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:22:07 +0000
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
        Jia He <hejianet@gmail.com>
Subject: [PATCH v1 net 02/16] sysctl: Add proc_dobool_lockless().
Date:   Tue, 5 Jul 2022 22:21:16 -0700
Message-ID: <20220706052130.16368-3-kuniyu@amazon.com>
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

A sysctl variable is accessed concurrently, and there is always a chance of
data-race.  So, all readers and writers need some basic protection to avoid
load/store-tearing.

This patch changes proc_dobool() to use READ_ONCE()/WRITE_ONCE() internally
to fix a data-race on the sysctl side.  For now, proc_dobool() itself is
tolerant to a data-race, but we still need to add annotations on the other
subsystem's side.

In case we miss such fixes, this patch converts proc_dobool() to a wrapper
of proc_dobool_lockless().  When we fix a data-race in the other subsystem,
we can explicitly set it as a handler.

Also, this patch removes proc_dobool()'s document and adds
proc_dobool_lockless()'s one so that no one will use proc_dobool() anymore.

Fixes: a2071573d634 ("sysctl: introduce new proc handler proc_dobool")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Jia He <hejianet@gmail.com>
---
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 9beab3a4de3d..fcafc16abbad 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -83,6 +83,8 @@ PROC_HANDLER(proc_dointvec_ms_jiffies);
 PROC_HANDLER(proc_do_large_bitmap);
 PROC_HANDLER(proc_do_static_key);
 
+PROC_HANDLER(proc_dobool_lockless);
+
 /*
  * Register a set of sysctl names by calling register_sysctl_table
  * with an initialised array of struct ctl_table's.  An entry with 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1082c8bc5ba5..bc6fcc64eeaf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -424,13 +424,12 @@ static void proc_put_char(void **buf, size_t *size, char c)
 }
 
 static int do_proc_dobool_conv(bool *negp, unsigned long *lvalp,
-				int *valp,
-				int write, void *data)
+			       int *valp, int write, void *data)
 {
 	if (write) {
-		*(bool *)valp = *lvalp;
+		WRITE_ONCE(*(bool *)valp, *lvalp);
 	} else {
-		int val = *(bool *)valp;
+		int val = READ_ONCE(*(bool *)valp);
 
 		*lvalp = (unsigned long)val;
 		*negp = false;
@@ -701,7 +700,7 @@ int do_proc_douintvec(struct ctl_table *table, int write,
 }
 
 /**
- * proc_dobool - read/write a bool
+ * proc_dobool_lockless - read/write a bool locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -713,13 +712,19 @@ int do_proc_douintvec(struct ctl_table *table, int write,
  *
  * Returns 0 on success.
  */
-int proc_dobool(struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos)
+int proc_dobool_lockless(struct ctl_table *table, int write, void *buffer,
+			 size_t *lenp, loff_t *ppos)
 {
 	return do_proc_dointvec(table, write, buffer, lenp, ppos,
 				do_proc_dobool_conv, NULL);
 }
 
+int proc_dobool(struct ctl_table *table, int write, void *buffer,
+		size_t *lenp, loff_t *ppos)
+{
+	return proc_dobool_lockless(table, write, buffer, lenp, ppos);
+}
+
 /**
  * proc_dointvec - read a vector of integers
  * @table: the sysctl table
@@ -1497,6 +1502,8 @@ PROC_HANDLER_ENOSYS(proc_dointvec_ms_jiffies);
 PROC_HANDLER_ENOSYS(proc_do_cad_pid);
 PROC_HANDLER_ENOSYS(proc_do_large_bitmap);
 
+PROC_HANDLER_ENOSYS(proc_dobool_lockless);
+
 #endif /* CONFIG_PROC_SYSCTL */
 
 #if defined(CONFIG_SYSCTL)
@@ -2405,3 +2412,5 @@ EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
 EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_do_large_bitmap);
+
+EXPORT_SYMBOL(proc_dobool_lockless);
-- 
2.30.2


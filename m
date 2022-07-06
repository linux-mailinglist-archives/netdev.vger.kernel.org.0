Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8CE567DB9
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiGFFWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGFFWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:22:42 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0047020F71;
        Tue,  5 Jul 2022 22:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084959; x=1688620959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vvTkQI5kZROfLMtnVMR0jXY5cgp4oarvGhfx+4aDV60=;
  b=FgBALXTashDb6KrKBVo2VYGUIdBd3WG231pg8K2CNFINgdZMfZByEBqP
   PKoCy2eO+NmRegISezQC19THxkOfmMtvJVi6PbsLG+1PfinnSq18lwlg6
   kOElMSGPBpR2ait61eUEfYtc32o8TIVVfBdQGyF9eTvMVxtVzXWMAZhSI
   8=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 06 Jul 2022 05:22:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 63C684C0077;
        Wed,  6 Jul 2022 05:22:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:22:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:22:22 +0000
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
Subject: [PATCH v1 net 03/16] sysctl: Add proc_dointvec_lockless().
Date:   Tue, 5 Jul 2022 22:21:17 -0700
Message-ID: <20220706052130.16368-4-kuniyu@amazon.com>
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

A sysctl variable is accessed concurrently, and there is always a chance of
data-race.  So, all readers and writers need some basic protection to avoid
load/store-tearing.

This patch changes proc_dointvec() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now, proc_dointvec()
itself is tolerant to a data-race, but we still need to add annotations on
the other subsystem's side.

In case we miss such fixes, this patch converts proc_dointvec() to a
wrapper of proc_dointvec_lockless().  When we fix a data-race in the other
subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_dointvec()'s document and adds
proc_dointvec_lockless()'s one so that no one will use proc_dointvec()
anymore.

While we are on it, we remove some trailing spaces.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 27 +++++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index fcafc16abbad..cb87919b5508 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -84,6 +84,7 @@ PROC_HANDLER(proc_do_large_bitmap);
 PROC_HANDLER(proc_do_static_key);
 
 PROC_HANDLER(proc_dobool_lockless);
+PROC_HANDLER(proc_dointvec_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bc6fcc64eeaf..50d9b78aa0b3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -445,14 +445,17 @@ static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 		if (*negp) {
 			if (*lvalp > (unsigned long) INT_MAX + 1)
 				return -EINVAL;
-			*valp = -*lvalp;
+
+			WRITE_ONCE(*valp, -*lvalp);
 		} else {
 			if (*lvalp > (unsigned long) INT_MAX)
 				return -EINVAL;
-			*valp = *lvalp;
+
+			WRITE_ONCE(*valp, *lvalp);
 		}
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
+
 		if (val < 0) {
 			*negp = true;
 			*lvalp = -(unsigned long)val;
@@ -491,12 +494,12 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	int *i, vleft, first = 1, err = 0;
 	size_t left;
 	char *p;
-	
+
 	if (!tbl_data || !table->maxlen || !*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	i = (int *) tbl_data;
 	vleft = table->maxlen / sizeof(*i);
 	left = *lenp;
@@ -726,7 +729,7 @@ int proc_dobool(struct ctl_table *table, int write, void *buffer,
 }
 
 /**
- * proc_dointvec - read a vector of integers
+ * proc_dointvec_lockless - read/write a vector of integers locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -734,14 +737,20 @@ int proc_dobool(struct ctl_table *table, int write, void *buffer,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  *
  * Returns 0 on success.
  */
+int proc_dointvec_lockless(struct ctl_table *table, int write, void *buffer,
+			   size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
+}
+
 int proc_dointvec(struct ctl_table *table, int write, void *buffer,
 		  size_t *lenp, loff_t *ppos)
 {
-	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
+	return proc_dointvec_lockless(table, write, buffer, lenp, ppos);
 }
 
 #ifdef CONFIG_COMPACTION
@@ -1503,6 +1512,7 @@ PROC_HANDLER_ENOSYS(proc_do_cad_pid);
 PROC_HANDLER_ENOSYS(proc_do_large_bitmap);
 
 PROC_HANDLER_ENOSYS(proc_dobool_lockless);
+PROC_HANDLER_ENOSYS(proc_dointvec_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2414,3 +2424,4 @@ EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_do_large_bitmap);
 
 EXPORT_SYMBOL(proc_dobool_lockless);
+EXPORT_SYMBOL(proc_dointvec_lockless);
-- 
2.30.2


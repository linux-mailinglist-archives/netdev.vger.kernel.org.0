Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09E8567DD4
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiGFFXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiGFFX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:27 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F333B0;
        Tue,  5 Jul 2022 22:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085006; x=1688621006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FH3JnsOgIqucU/O/kiHTcxh5RtV6tKMeFYEzhhc+/GI=;
  b=F8GbKNSV/eaqqyE+MlfTPBvXX07vN4cyB+wfd8dJM2VXW/BIQV4L1HgM
   KGvbkd2v235X4bzzppgTEeVl9GKnpk6HU2MqQM6IGTxOqOhEIrnZoPPWn
   f4Gq3GaluuNfpLXNtD5UmEA4+lPPMxBzBZJpcV0lhHwQRk1rqIDhoH1/r
   I=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="235270987"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 Jul 2022 05:23:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id B321F43A09;
        Wed,  6 Jul 2022 05:23:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:23:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:23:22 +0000
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
Subject: [PATCH v1 net 07/16] sysctl: Add proc_doulongvec_minmax_lockless().
Date:   Tue, 5 Jul 2022 22:21:21 -0700
Message-ID: <20220706052130.16368-8-kuniyu@amazon.com>
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

This patch changes proc_doulongvec_minmax() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now,
proc_doulongvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

In case we miss such fixes, this patch converts proc_doulongvec_minmax() to
a wrapper of proc_doulongvec_minmax_lockless().  When we fix a data-race in
the other subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_doulongvec_minmax()'s document and adds
proc_doulongvec_minmax_lockless()'s one so that no one will use
proc_doulongvec_minmax() anymore.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 830d1a8f21d4..c23b6beef748 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -88,6 +88,7 @@ PROC_HANDLER(proc_dointvec_lockless);
 PROC_HANDLER(proc_douintvec_lockless);
 PROC_HANDLER(proc_dointvec_minmax_lockless);
 PROC_HANDLER(proc_douintvec_minmax_lockless);
+PROC_HANDLER(proc_doulongvec_minmax_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8ff57b8d1212..931ab58985f2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1127,9 +1127,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 				err = -EINVAL;
 				break;
 			}
-			*i = val;
+
+			WRITE_ONCE(*i, val);
 		} else {
-			val = convdiv * (*i) / convmul;
+			val = convdiv * READ_ONCE(*i) / convmul;
+
 			if (!first)
 				proc_put_char(&buffer, &left, '\t');
 			proc_put_long(&buffer, &left, val, false);
@@ -1157,7 +1159,8 @@ static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 }
 
 /**
- * proc_doulongvec_minmax - read a vector of long integers with min/max values
+ * proc_doulongvec_minmax_lockless - read/write a vector of long integers
+ * with min/max values locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -1172,10 +1175,18 @@ static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
  *
  * Returns 0 on success.
  */
+int proc_doulongvec_minmax_lockless(struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos,
+					 1l, 1l);
+}
+
 int proc_doulongvec_minmax(struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos, 1l, 1l);
+	return proc_doulongvec_minmax_lockless(table, write, buffer,
+					       lenp, ppos);
 }
 
 /**
@@ -1540,6 +1551,7 @@ PROC_HANDLER_ENOSYS(proc_dointvec_lockless);
 PROC_HANDLER_ENOSYS(proc_douintvec_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_minmax_lockless);
 PROC_HANDLER_ENOSYS(proc_douintvec_minmax_lockless);
+PROC_HANDLER_ENOSYS(proc_doulongvec_minmax_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2455,3 +2467,4 @@ EXPORT_SYMBOL(proc_dointvec_lockless);
 EXPORT_SYMBOL(proc_douintvec_lockless);
 EXPORT_SYMBOL(proc_dointvec_minmax_lockless);
 EXPORT_SYMBOL_GPL(proc_douintvec_minmax_lockless);
+EXPORT_SYMBOL(proc_doulongvec_minmax_lockless);
-- 
2.30.2


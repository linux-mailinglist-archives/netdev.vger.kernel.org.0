Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85150567DB5
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiGFFXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiGFFXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:13 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CBA2124F;
        Tue,  5 Jul 2022 22:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084992; x=1688620992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YXuh7vJXEQMSPq64wbRPnqP7B9hkeIKY5sqtiuHZaPc=;
  b=r/p2tNZc9GUR1jWFc6Uh3tZUs2CmBV6xKaAa+VKyB/OrNQN0ztRO9iW9
   4BMMrEh7F1Z5yvLXM5NljwCA06rhQAp+3Q7xq43ONhg+Z3XYUJTnGp3Yy
   e6VYT2YBAJ9VBKTwNVlb4W9H0Ea3JU9/C+sbnntIwZ7xRyKiGB/nvDS3B
   U=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="105282277"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Jul 2022 05:22:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id A9B5942040;
        Wed,  6 Jul 2022 05:22:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:22:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:22:53 +0000
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
Subject: [PATCH v1 net 05/16] sysctl: Add proc_dointvec_minmax_lockless().
Date:   Tue, 5 Jul 2022 22:21:19 -0700
Message-ID: <20220706052130.16368-6-kuniyu@amazon.com>
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

This patch changes proc_dointvec_minmax() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now,
proc_dointvec_minmax() itself is tolerant to a data-race, but we still need
to add annotations on the other subsystem's side.

In case we miss such fixes, this patch converts proc_dointvec_minmax() to a
wrapper of proc_dointvec_minmax_lockless().  When we fix a data-race in the
other subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_dointvec_minmax()'s document and adds
proc_dointvec_minmax_lockless()'s one so that no one will use
proc_dointvec_minmax() anymore.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 770ee1833c25..7f91cc625d56 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -86,6 +86,7 @@ PROC_HANDLER(proc_do_static_key);
 PROC_HANDLER(proc_dobool_lockless);
 PROC_HANDLER(proc_dointvec_lockless);
 PROC_HANDLER(proc_douintvec_lockless);
+PROC_HANDLER(proc_dointvec_minmax_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index be8a7d912180..aead731ae74b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -879,14 +879,16 @@ static int do_proc_dointvec_minmax_conv(bool *negp, unsigned long *lvalp,
 		if ((param->min && *param->min > tmp) ||
 		    (param->max && *param->max < tmp))
 			return -EINVAL;
-		*valp = tmp;
+
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
 }
 
 /**
- * proc_dointvec_minmax - read a vector of integers with min/max values
+ * proc_dointvec_minmax_lockless - read/write a vector of integers with
+ * min/max values locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -901,8 +903,8 @@ static int do_proc_dointvec_minmax_conv(bool *negp, unsigned long *lvalp,
  *
  * Returns 0 on success or -EINVAL on write when the range check fails.
  */
-int proc_dointvec_minmax(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
+int proc_dointvec_minmax_lockless(struct ctl_table *table, int write,
+				  void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct do_proc_dointvec_minmax_conv_param param = {
 		.min = (int *) table->extra1,
@@ -912,6 +914,13 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+int proc_dointvec_minmax(struct ctl_table *table, int write,
+			 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_dointvec_minmax_lockless(table, write, buffer,
+					     lenp, ppos);
+}
+
 /**
  * struct do_proc_douintvec_minmax_conv_param - proc_douintvec_minmax() range checking structure
  * @min: pointer to minimum allowable value
@@ -1522,6 +1531,7 @@ PROC_HANDLER_ENOSYS(proc_do_large_bitmap);
 PROC_HANDLER_ENOSYS(proc_dobool_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_lockless);
 PROC_HANDLER_ENOSYS(proc_douintvec_lockless);
+PROC_HANDLER_ENOSYS(proc_dointvec_minmax_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2435,3 +2445,4 @@ EXPORT_SYMBOL(proc_do_large_bitmap);
 EXPORT_SYMBOL(proc_dobool_lockless);
 EXPORT_SYMBOL(proc_dointvec_lockless);
 EXPORT_SYMBOL(proc_douintvec_lockless);
+EXPORT_SYMBOL(proc_dointvec_minmax_lockless);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF673567DC7
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiGFFXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiGFFX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:23:26 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4396DE6;
        Tue,  5 Jul 2022 22:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657085004; x=1688621004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jh0a+absz9pAb5bIlORUQ/Q1+4cClz2C63wKgA8hG5I=;
  b=orhJLYQcJiu/kREOpdVNW9a8I2XTwrjwMVg7EZmQu+6wdjdUfAtKcIdF
   bK12O0bJBf47CLArOqMGig8yFS1mBNeqElC9ryjy7cRd5ta+LaqKiLjrL
   bPRc4/qvbqjP6H/RN8Z8hQC+EsIz2FI1VPB0Fgs3uq4vcE27KXFMO2fvE
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="215167206"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 06 Jul 2022 05:23:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 4BA3644103;
        Wed,  6 Jul 2022 05:23:11 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:23:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:23:08 +0000
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
Subject: [PATCH v1 net 06/16] sysctl: Add proc_douintvec_minmax_lockless().
Date:   Tue, 5 Jul 2022 22:21:20 -0700
Message-ID: <20220706052130.16368-7-kuniyu@amazon.com>
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

This patch changes proc_douintvec_minmax() to use READ_ONCE()/WRITE_ONCE()
internally to fix a data-race on the sysctl side.  For now,
proc_douintvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

In case we miss such fixes, this patch converts proc_douintvec_minmax() to
a wrapper of proc_douintvec_minmax_lockless().  When we fix a data-race in
the other subsystem, we can explicitly set it as a handler.

Also, this patch removes proc_douintvec_minmax()'s document and adds
proc_douintvec_minmax_lockless()'s one so that no one will use
proc_douintvec_minmax() anymore.

Fixes: 61d9b56a8920 ("sysctl: add unsigned int range support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Luis R. Rodriguez <mcgrof@kernel.org>
---
 include/linux/sysctl.h |  1 +
 kernel/sysctl.c        | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 7f91cc625d56..830d1a8f21d4 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -87,6 +87,7 @@ PROC_HANDLER(proc_dobool_lockless);
 PROC_HANDLER(proc_dointvec_lockless);
 PROC_HANDLER(proc_douintvec_lockless);
 PROC_HANDLER(proc_dointvec_minmax_lockless);
+PROC_HANDLER(proc_douintvec_minmax_lockless);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index aead731ae74b..8ff57b8d1212 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -954,14 +954,15 @@ static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
 		    (param->max && *param->max < tmp))
 			return -ERANGE;
 
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
 }
 
 /**
- * proc_douintvec_minmax - read a vector of unsigned ints with min/max values
+ * proc_douintvec_minmax_lockless - read/write a vector of unsigned ints
+ * with min/max values locklessly
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
  * @buffer: the user buffer
@@ -979,8 +980,8 @@ static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
  *
  * Returns 0 on success or -ERANGE on write when the range check fails.
  */
-int proc_douintvec_minmax(struct ctl_table *table, int write,
-			  void *buffer, size_t *lenp, loff_t *ppos)
+int proc_douintvec_minmax_lockless(struct ctl_table *table, int write,
+				   void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct do_proc_douintvec_minmax_conv_param param = {
 		.min = (unsigned int *) table->extra1,
@@ -990,6 +991,12 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
+int proc_douintvec_minmax(struct ctl_table *table, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_douintvec_minmax_lockless(table, write, buffer, lenp, ppos);
+}
+
 /**
  * proc_dou8vec_minmax - read a vector of unsigned chars with min/max values
  * @table: the sysctl table
@@ -1532,6 +1539,7 @@ PROC_HANDLER_ENOSYS(proc_dobool_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_lockless);
 PROC_HANDLER_ENOSYS(proc_douintvec_lockless);
 PROC_HANDLER_ENOSYS(proc_dointvec_minmax_lockless);
+PROC_HANDLER_ENOSYS(proc_douintvec_minmax_lockless);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2446,3 +2454,4 @@ EXPORT_SYMBOL(proc_dobool_lockless);
 EXPORT_SYMBOL(proc_dointvec_lockless);
 EXPORT_SYMBOL(proc_douintvec_lockless);
 EXPORT_SYMBOL(proc_dointvec_minmax_lockless);
+EXPORT_SYMBOL_GPL(proc_douintvec_minmax_lockless);
-- 
2.30.2


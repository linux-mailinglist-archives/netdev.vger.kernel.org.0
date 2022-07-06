Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C61567DAF
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiGFFWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGFFWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:22:12 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1B8201AE;
        Tue,  5 Jul 2022 22:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657084929; x=1688620929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ktErGUxee0HxFn0K3EFz92GAteW37Trp2iCXAPhjIE=;
  b=U3e7gdG/E2vvw5VUyJ2RAMDjD62cQWuXSTRgbKz09/fUXYopOH8tzGNu
   7f6vyoe8pK/fuOECq6MOkz3pyzuTDJ3kOE3EsDtTUqrX3kw7zErtVXFJi
   6k8dccjlr9x+Ehj54dPFb5ckQiooxFa1kldlRCNokYo99N3XYcKrOLV+9
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="105210165"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 06 Jul 2022 05:21:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 2A39E43400;
        Wed,  6 Jul 2022 05:21:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 05:21:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 05:21:52 +0000
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
Subject: [PATCH v1 net 01/16] sysctl: Clean up proc_handler definitions.
Date:   Tue, 5 Jul 2022 22:21:15 -0700
Message-ID: <20220706052130.16368-2-kuniyu@amazon.com>
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

All proc_handler variants have almost the same function prototypes in
sysctl.h and empty functions in sysctl.c in case CONFIG_PROC_SYSCTL is
disabled.

This patch arranges them in the same order and defines them cleanly with
two macros so that we can add lockless helpers easily in the following
commits.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/sysctl.h |  43 ++++++++---------
 kernel/sysctl.c        | 105 ++++++++++-------------------------------
 2 files changed, 45 insertions(+), 103 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 80263f7cdb77..9beab3a4de3d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -62,29 +62,26 @@ extern const int sysctl_vals[];
 extern const unsigned long sysctl_long_vals[];
 
 typedef int proc_handler(struct ctl_table *ctl, int write, void *buffer,
-		size_t *lenp, loff_t *ppos);
-
-int proc_dostring(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_dobool(struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos);
-int proc_dointvec(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos);
-int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
-			size_t *lenp, loff_t *ppos);
-int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-int proc_dointvec_ms_jiffies(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-int proc_doulongvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int, void *,
-		size_t *, loff_t *);
-int proc_do_large_bitmap(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_do_static_key(struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos);
+			 size_t *lenp, loff_t *ppos);
+
+#define PROC_HANDLER(function)						\
+	int function(struct ctl_table *table, int write, void *buffer,	\
+		     size_t *lenp, loff_t *ppos)
+
+PROC_HANDLER(proc_dostring);
+PROC_HANDLER(proc_dobool);
+PROC_HANDLER(proc_dointvec);
+PROC_HANDLER(proc_douintvec);
+PROC_HANDLER(proc_dointvec_minmax);
+PROC_HANDLER(proc_douintvec_minmax);
+PROC_HANDLER(proc_dou8vec_minmax);
+PROC_HANDLER(proc_doulongvec_minmax);
+PROC_HANDLER(proc_doulongvec_ms_jiffies_minmax);
+PROC_HANDLER(proc_dointvec_jiffies);
+PROC_HANDLER(proc_dointvec_userhz_jiffies);
+PROC_HANDLER(proc_dointvec_ms_jiffies);
+PROC_HANDLER(proc_do_large_bitmap);
+PROC_HANDLER(proc_do_static_key);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e52b6e372c60..1082c8bc5ba5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1016,7 +1016,6 @@ int proc_dou8vec_minmax(struct ctl_table *table, int write,
 		*data = val;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
 
 #ifdef CONFIG_MAGIC_SYSRQ
 static int sysrq_sysctl_handler(struct ctl_table *table, int write,
@@ -1475,83 +1474,28 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 
 #else /* CONFIG_PROC_SYSCTL */
 
-int proc_dostring(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dobool(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dointvec(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_douintvec(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dointvec_minmax(struct ctl_table *table, int write,
-		    void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_douintvec_minmax(struct ctl_table *table, int write,
-			  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dou8vec_minmax(struct ctl_table *table, int write,
-			void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
 
-int proc_dointvec_jiffies(struct ctl_table *table, int write,
-		    void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
-		    void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_dointvec_ms_jiffies(struct ctl_table *table, int write,
-			     void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_doulongvec_minmax(struct ctl_table *table, int write,
-		    void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
-				      void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+#define PROC_HANDLER_ENOSYS(function)				\
+	int function(struct ctl_table *table, int write,	\
+		 void *buffer, size_t *lenp, loff_t *ppos)	\
+	{							\
+		return -ENOSYS;					\
+	}
 
-int proc_do_large_bitmap(struct ctl_table *table, int write,
-			 void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
+PROC_HANDLER_ENOSYS(proc_dostring);
+PROC_HANDLER_ENOSYS(proc_dobool);
+PROC_HANDLER_ENOSYS(proc_dointvec);
+PROC_HANDLER_ENOSYS(proc_douintvec);
+PROC_HANDLER_ENOSYS(proc_dointvec_minmax);
+PROC_HANDLER_ENOSYS(proc_douintvec_minmax);
+PROC_HANDLER_ENOSYS(proc_dou8vec_minmax);
+PROC_HANDLER_ENOSYS(proc_doulongvec_minmax);
+PROC_HANDLER_ENOSYS(proc_doulongvec_ms_jiffies_minmax);
+PROC_HANDLER_ENOSYS(proc_dointvec_jiffies);
+PROC_HANDLER_ENOSYS(proc_dointvec_userhz_jiffies);
+PROC_HANDLER_ENOSYS(proc_dointvec_ms_jiffies);
+PROC_HANDLER_ENOSYS(proc_do_cad_pid);
+PROC_HANDLER_ENOSYS(proc_do_large_bitmap);
 
 #endif /* CONFIG_PROC_SYSCTL */
 
@@ -2448,15 +2392,16 @@ int __init sysctl_init_bases(void)
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
  */
+EXPORT_SYMBOL(proc_dostring);
 EXPORT_SYMBOL(proc_dobool);
 EXPORT_SYMBOL(proc_dointvec);
 EXPORT_SYMBOL(proc_douintvec);
-EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL_GPL(proc_douintvec_minmax);
-EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
-EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
-EXPORT_SYMBOL(proc_dostring);
+EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
+EXPORT_SYMBOL(proc_dointvec_jiffies);
+EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
+EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_do_large_bitmap);
-- 
2.30.2


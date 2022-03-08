Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77234D15BA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbiCHLJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiCHLJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:09:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2237BC2;
        Tue,  8 Mar 2022 03:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FAF8615F5;
        Tue,  8 Mar 2022 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0929FC340EB;
        Tue,  8 Mar 2022 11:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646737729;
        bh=RsDHmXZhUkUqXQm90YfwcTD4LIpS2YJRqfj/Ma2sdKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGvTZaVzezZo7a9fqQY36l73omZty/NLQATRDT9iHrXv6uS8RVBGgP+LYya+nZFtC
         sczENzGcFsYO1ygHpWp5D9RWqYPNFfZT9mV+KZIN9ZqKWPwgzsH5biTkTbIbKfHq0W
         B8T2RiemsVJjc2othFCKvd/do/pwsPZNDRWjNbMk2V6ccHc0XlHkznVwoZqJegCTPk
         8lLbQ3TvLzaB/yDR2NXlslnR1gevXPG2Oz/MkWCCDFxIodea/P9wptloJSo6rra15j
         gcYiGWqgiGdkmNCCHtut5GSCvWJRXWqTbQXqKWgLluMgYLLCDVM5L0ejc/PMEIo0Tg
         XtGcYIsuy8okA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v10 01/12] ftrace: Add ftrace_set_filter_ips function
Date:   Tue,  8 Mar 2022 20:08:43 +0900
Message-Id: <164673772293.1984170.3030991549686897265.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164673771096.1984170.8155877393151850116.stgit@devnote2>
References: <164673771096.1984170.8155877393151850116.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding ftrace_set_filter_ips function to be able to set filter on
multiple ip addresses at once.

With the kprobe multi attach interface we have cases where we need to
initialize ftrace_ops object with thousands of functions, so having
single function diving into ftrace_hash_move_and_update_ops with
ftrace_lock is faster.

The functions ips are passed as unsigned long array with count.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Changes in v6: [Masami]
  - Fix a typo and add a comment.
---
 include/linux/ftrace.h |    3 ++
 kernel/trace/ftrace.c  |   58 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9999e29187de..60847cbce0da 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -512,6 +512,8 @@ struct dyn_ftrace {
 
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset);
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			  unsigned int cnt, int remove, int reset);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -802,6 +804,7 @@ static inline unsigned long ftrace_location(unsigned long ip)
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
 #define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
+#define ftrace_set_filter_ips(ops, ips, cnt, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a4b462b6f944..93e992962ada 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4958,7 +4958,7 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 }
 
 static int
-ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
+__ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 {
 	struct ftrace_func_entry *entry;
 
@@ -4976,9 +4976,30 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
+static int
+ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
+		  unsigned int cnt, int remove)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < cnt; i++) {
+		err = __ftrace_match_addr(hash, ips[i], remove);
+		if (err) {
+			/*
+			 * This expects the @hash is a temporary hash and if this
+			 * fails the caller must free the @hash.
+			 */
+			return err;
+		}
+	}
+	return 0;
+}
+
 static int
 ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
-		unsigned long ip, int remove, int reset, int enable)
+		unsigned long *ips, unsigned int cnt,
+		int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *hash;
@@ -5008,8 +5029,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		ret = -EINVAL;
 		goto out_regex_unlock;
 	}
-	if (ip) {
-		ret = ftrace_match_addr(hash, ip, remove);
+	if (ips) {
+		ret = ftrace_match_addr(hash, ips, cnt, remove);
 		if (ret < 0)
 			goto out_regex_unlock;
 	}
@@ -5026,10 +5047,10 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 }
 
 static int
-ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
-		int reset, int enable)
+ftrace_set_addr(struct ftrace_ops *ops, unsigned long *ips, unsigned int cnt,
+		int remove, int reset, int enable)
 {
-	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
+	return ftrace_set_hash(ops, NULL, 0, ips, cnt, remove, reset, enable);
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
@@ -5634,10 +5655,29 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
 {
 	ftrace_ops_init(ops);
-	return ftrace_set_addr(ops, ip, remove, reset, 1);
+	return ftrace_set_addr(ops, &ip, 1, remove, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
 
+/**
+ * ftrace_set_filter_ips - set functions to filter on in ftrace by addresses
+ * @ops - the ops to set the filter with
+ * @ips - the array of addresses to add to or remove from the filter.
+ * @cnt - the number of addresses in @ips
+ * @remove - non zero to remove ips from the filter
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enabled
+ * If @ips array or any ip specified within is NULL , it fails to update filter.
+ */
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			  unsigned int cnt, int remove, int reset)
+{
+	ftrace_ops_init(ops);
+	return ftrace_set_addr(ops, ips, cnt, remove, reset, 1);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_filter_ips);
+
 /**
  * ftrace_ops_set_global_filter - setup ops to use global filters
  * @ops - the ops which will use the global filters
@@ -5659,7 +5699,7 @@ static int
 ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		 int reset, int enable)
 {
-	return ftrace_set_hash(ops, buf, len, 0, 0, reset, enable);
+	return ftrace_set_hash(ops, buf, len, NULL, 0, 0, reset, enable);
 }
 
 /**


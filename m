Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF114A698B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243639AbiBBBNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbiBBBNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:23 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915D4C06173E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a19so11455826pfx.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iQhK3QJDPOtx3ex2lFMNHo4XnsW4IlmYbsO1LGXKA2k=;
        b=OE+S8yOtgvhE7N+F8yc6DaUog1MmceemA18bRckGOGcXxxFpSXqKewt4HwhP1JaKbo
         hxHxF7epWxICw6FfBttBZaHVcafu2M57BcpoCn1DpCf2JX5UiHEq5gQ+/erVjEhPdFkA
         N3iB7AUhkvKKsHHjYZOZE86GwN6+qwCe/JS+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iQhK3QJDPOtx3ex2lFMNHo4XnsW4IlmYbsO1LGXKA2k=;
        b=W+k4/wdFVUbY2CZqUNaf3Z+mRbgzmBIQz3NQVf//YBKkDTxfSWI1NDVhNJkzmnlmIW
         eSq0DE/jfXw+4zjht64bcT4g8n5+tVqf7efy/IN29hDDeqIkUIsu+TAmsCUe83ZjTs1d
         ZL8KbK93wMbfbqgTrkq0J4XMMZHhcB4lDYIHczCqsXQq2v1KvSbYLstpFfhd/kK+LzLP
         dqgGKFWePt05MzE2F1cR29Gi2RW5tnAyIgpNNjRiFYD3fX42yJJH6bqUQNyG0cN7ahrq
         9ouoGGD2tbetrK1watpKUgwi7uz07TeLy44yjdKRMtZbBEte8lLZ5tYoj+TFe+EYPZ3e
         C/pw==
X-Gm-Message-State: AOAM532873Ez2RyucJbzl19J3cAsvrNwH5qSSY1l8j8GkAkko81P1r+l
        fdI7dlZ/paLRKhvKGGAI41niMuV1k/JPCdtXJgLLFB30CE/e6M6WvMH7s8NU90Yjx7bDMNYDQcv
        0Ti2CWfSVqee8k1P4lSLVrV/QfRg6RvoomyXomrWXAEwLN4XCesV8Zjk4Srfq5a3PVYxA
X-Google-Smtp-Source: ABdhPJyV2jjFIZKgCqgZcpXcGkB0kVhb4DzhXobw81O7ScaTNiQb1P0z4/F2+EzozsW34oCRe5kYLg==
X-Received: by 2002:a63:396:: with SMTP id 144mr22546262pgd.288.1643764402570;
        Tue, 01 Feb 2022 17:13:22 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:21 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 10/10] net-procfs: Show page pool stats in proc
Date:   Tue,  1 Feb 2022 17:12:16 -0800
Message-Id: <1643764336-63864-11-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-cpu page pool allocation stats are exported in the file
/proc/net/page_pool_stat allowing users to better understand the
interaction between their drivers and kernel memory allocation.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 net/core/net-procfs.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 88cc0ad..3bc6e53 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -4,6 +4,10 @@
 #include <linux/seq_file.h>
 #include <net/wext.h>
 
+#ifdef CONFIG_PAGE_POOL_STATS
+#include <net/page_pool.h>
+#endif
+
 #define BUCKET_SPACE (32 - NETDEV_HASHBITS - 1)
 
 #define get_bucket(x) ((x) >> BUCKET_SPACE)
@@ -310,6 +314,57 @@ static const struct seq_operations ptype_seq_ops = {
 	.show  = ptype_seq_show,
 };
 
+#ifdef CONFIG_PAGE_POOL_STATS
+static struct page_pool_stats *page_pool_stat_get_online(loff_t *pos)
+{
+	struct page_pool_stats *pp_stat = NULL;
+
+	while (*pos < nr_cpu_ids) {
+		if (cpu_online(*pos)) {
+			pp_stat = per_cpu_ptr(&page_pool_stats, *pos);
+			break;
+		}
+
+		++*pos;
+	}
+
+	return pp_stat;
+}
+
+static void *page_pool_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return page_pool_stat_get_online(pos);
+}
+
+static void *page_pool_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	++*pos;
+	return page_pool_stat_get_online(pos);
+}
+
+static void page_pool_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int page_pool_seq_show(struct seq_file *seq, void *v)
+{
+	struct page_pool_stats *pp_stat = v;
+
+	seq_printf(seq, "%08llx %08llx %08llx %08llx %08llx %08llx %08llx\n",
+		   seq->index, pp_stat->alloc.fast,
+		   pp_stat->alloc.slow, pp_stat->alloc.slow_high_order,
+		   pp_stat->alloc.empty, pp_stat->alloc.refill, pp_stat->alloc.waive);
+	return 0;
+}
+
+static const struct seq_operations page_pool_seq_ops = {
+	.start = page_pool_seq_start,
+	.next = page_pool_seq_next,
+	.stop = page_pool_seq_stop,
+	.show = page_pool_seq_show,
+};
+#endif
+
 static int __net_init dev_proc_net_init(struct net *net)
 {
 	int rc = -ENOMEM;
@@ -326,6 +381,15 @@ static int __net_init dev_proc_net_init(struct net *net)
 
 	if (wext_proc_init(net))
 		goto out_ptype;
+
+#ifdef CONFIG_PAGE_POOL_STATS
+	if (!proc_create_seq("page_pool_stat", 0444, net->proc_net,
+			     &page_pool_seq_ops)) {
+		wext_proc_exit(net);
+		goto out_ptype;
+	}
+#endif
+
 	rc = 0;
 out:
 	return rc;
@@ -342,6 +406,9 @@ static void __net_exit dev_proc_net_exit(struct net *net)
 {
 	wext_proc_exit(net);
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	remove_proc_entry("page_pool_stat", net->proc_net);
+#endif
 	remove_proc_entry("ptype", net->proc_net);
 	remove_proc_entry("softnet_stat", net->proc_net);
 	remove_proc_entry("dev", net->proc_net);
-- 
2.7.4


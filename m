Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258B34A32AC
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353467AbiA2XkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353460AbiA2XkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:18 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6A3C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:18 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id s6so3823461plg.12
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OcKHYlUmrKmGbdNWNifNKpXqnTivrjtnzcz+DoQJ60o=;
        b=KyRVYs86ghuRCzykjGMif3/NH6u2yT/LopkuWA0id1rzjh46XRKVki4w8NFcYxkoF5
         WpLHmVywG109Dd/mKi21Dd4Z7d7WO47Ghuit5d+pqP3/BSBHeaA+P41GOsj3CaAvvf2F
         l4JMNy8/ZZs27ySRin7NjlFUK5anRwJvwFmTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OcKHYlUmrKmGbdNWNifNKpXqnTivrjtnzcz+DoQJ60o=;
        b=7a9zXvSe0YMqiG8QeFIpVSCe5FxXELvTfGvQTWQxoy/I82UtpAfoiNsMwfM+/AJNiV
         hifrzLGIUJVdscpcfCELm6kwmRIMkElFv4TkkqiQgv6UcrGnAimkq9vxs1tKHmxLK1KO
         4A9EP5KzeYItEId5s2USbbTEcSsg1hDe7CdwYad+m6zXxsu6296lCkLTuQUnZXZXxY7P
         9nckzGeS9Hvnioh8fL3syJ3HAm1yFbV3M2TtXp8kjHHJyFWFlXN0wc0vihmB1CxLSztp
         yGMvDAoXSi5gk9Nu0qL1ZuzI3YXpIO3aJmELhCS/mjHNfp0+cmN6nhR/SktV10HM+VFY
         zIGQ==
X-Gm-Message-State: AOAM531LiGvOCyt9sLiGK81yux+vTXmS1C+eE3tKvP5vJypWpSqsekPx
        aR5K+of/bz8jChYRAfw2B5J/34Gnnrg/ne4FUxvGJ6MCtJNPxzXYmy6tykhq9b3wW1+zkqa4wZK
        OhqTym93usyCC9mj1Rapk5dPTYt8juvW6YlK99EL92xJcBX0gSZmC8YEMO3P0XIStSMjV
X-Google-Smtp-Source: ABdhPJwcppAguYZSfiDPvakaJfC/d5PCCFjI9E98usHjo40Q9JBCeFYPikD5PbV0lid758z/vsnyjQ==
X-Received: by 2002:a17:902:db0a:: with SMTP id m10mr14632255plx.92.1643499617265;
        Sat, 29 Jan 2022 15:40:17 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:16 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 10/10] net-procfs: Show page pool stats in proc
Date:   Sat, 29 Jan 2022 15:39:00 -0800
Message-Id: <1643499540-8351-11-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-cpu page pool allocation stats are exported in the file
/proc/net/page_pool_stat allowing users to better understand the
interaction between their drivers and kernel memory allocation.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/core/net-procfs.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 88cc0ad..3d3f3e8 100644
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
@@ -310,6 +314,58 @@ static const struct seq_operations ptype_seq_ops = {
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
+	seq_printf(seq, "%08llx %08llx %08llx %08llx %08llx %08llx %08llx %08llx\n",
+		   seq->index, pp_stat->alloc.fast,
+		   pp_stat->alloc.slow, pp_stat->alloc.slow_high_order,
+		   pp_stat->alloc.empty, pp_stat->alloc.refill,
+		   pp_stat->alloc.refill, pp_stat->alloc.waive);
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
@@ -323,12 +379,23 @@ static int __net_init dev_proc_net_init(struct net *net)
 	if (!proc_create_net("ptype", 0444, net->proc_net, &ptype_seq_ops,
 			sizeof(struct seq_net_private)))
 		goto out_softnet;
+#ifdef CONFIG_PAGE_POOL_STATS
+	if (!proc_create_seq("page_pool_stat", 0444, net->proc_net,
+			     &page_pool_seq_ops))
+		goto out_ptype;
+#endif
 
 	if (wext_proc_init(net))
-		goto out_ptype;
+		goto out_page_pool;
 	rc = 0;
 out:
 	return rc;
+
+out_page_pool:
+#ifdef CONFIG_PAGE_POOL_STATS
+	remove_proc_entry("page_pool_stat", net->proc_net);
+#endif
+
 out_ptype:
 	remove_proc_entry("ptype", net->proc_net);
 out_softnet:
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648BB41D509
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348999AbhI3IGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348961AbhI3IEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89DC9610A4;
        Thu, 30 Sep 2021 08:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988968;
        bh=5fyu5724fJ6RxXuSY955V+ykW2cT2y5ZmHdiMVs5DA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGtXf4YFEpJKThNUCOWhHFVTOh/5lKITIsjZ3W37QJhHCZjfEKqfH39gaYwI++yTs
         2Qp3As+Bv5OlBKijeWC12S8uuZeozcGPoLH0WA/lThLG0JQMxHJARbQascFd2MkVhM
         wWC+rabKgN9lBBL/xFSqFqCA1ntceNRWNULBDXSoHksrTSjAeMLvwfuBP6vyw5LtuS
         3TGbKkatFvZFwBYB1NlZ3CfeKdg4uBuqLWdA1p6XkwoRlC7zMY1/F2hulHvSu3j7qs
         AYaebOdlu4SwVnO9q266S4Lb786NSIlqa7Gr2dZ8CWFaPPHBX3SWGPtIeQmrQrOw7o
         fdNa5hn9nbVmA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 05/13] RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
Date:   Thu, 30 Sep 2021 11:02:21 +0300
Message-Id: <1d49884d3e77273fe714cc49d688cc0c1bae2e80.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add a bitmap in rdma_hw_stat structure, with each bit indicates whether
the corresponding counter is currently disabled or not. By default
hwcounters are enabled.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 11 ++++++++++-
 drivers/infiniband/core/verbs.c | 14 +++++++++++++-
 include/rdma/ib_verbs.h         |  3 +++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 3f6b98a87566..67519730b1ac 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
 	if (!table_attr)
 		return -EMSGSIZE;
 
-	for (i = 0; i < st->num_counters; i++)
+	mutex_lock(&st->lock);
+	for (i = 0; i < st->num_counters; i++) {
+		if (test_bit(i, st->is_disabled))
+			continue;
 		if (rdma_nl_stat_hwcounter_entry(msg, st->descs[i].name,
 						 st->value[i]))
 			goto err;
+	}
+	mutex_unlock(&st->lock);
 
 	nla_nest_end(msg, table_attr);
 	return 0;
 
 err:
+	mutex_unlock(&st->lock);
 	nla_nest_cancel(msg, table_attr);
 	return -EMSGSIZE;
 }
@@ -2104,6 +2110,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 		goto err_stats;
 	}
 	for (i = 0; i < num_cnts; i++) {
+		if (test_bit(i, stats->is_disabled))
+			continue;
+
 		v = stats->value[i] +
 			rdma_counter_get_hwstat_value(device, port, i);
 		if (rdma_nl_stat_hwcounter_entry(msg,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 71ece4b00234..890593d5100d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2987,16 +2987,28 @@ struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 	if (!stats)
 		return NULL;
 
+	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
+				     sizeof(long), GFP_KERNEL);
+	if (!stats->is_disabled)
+		goto err;
+
 	stats->descs = descs;
 	stats->num_counters = num_counters;
 	stats->lifespan = msecs_to_jiffies(lifespan);
 
 	return stats;
+
+err:
+	kfree(stats);
+	return NULL;
 }
 EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
 
 void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
 {
-	kfree(stats);
+	if (stats) {
+		kfree(stats->is_disabled);
+		kfree(stats);
+	}
 }
 EXPORT_SYMBOL(rdma_free_hw_stats_struct);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5e8a5ed47e9a..30bbbf21d248 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -565,6 +565,8 @@ struct rdma_stat_desc {
  *   their own value during their allocation routine.
  * @descs - Array of pointers to static descriptors used for the counters
  *   in directory.
+ * @is_disabled - A bitmap to indicate each counter is currently disabled
+ *   or not.
  * @num_counters - How many hardware counters there are.  If name is
  *   shorter than this number, a kernel oops will result.  Driver authors
  *   are encouraged to leave BUILD_BUG_ON(ARRAY_SIZE(@name) < num_counters)
@@ -577,6 +579,7 @@ struct rdma_hw_stats {
 	unsigned long	timestamp;
 	unsigned long	lifespan;
 	const struct rdma_stat_desc *descs;
+	unsigned long	*is_disabled;
 	int		num_counters;
 	u64		value[];
 };
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02440BBEA
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhINXJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbhINXJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0730B61165;
        Tue, 14 Sep 2021 23:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660865;
        bh=ImILxZg8hc6GJ31vkArULeaPC8M4UyuLapyIfB1eDFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+NV9GbN9gU360b0klsOSyvj2helgt5COxtxcxLjVqqAR3bUiuoRRQcGbL+nN164m
         CiwRAW/hJBvvH/1Z+qBdsVxu5TxJ3uC/Su+RzBDhIrNZ+Rxi5vnDKLemyizJL2aHgD
         ZvRA1LnnQb4d7hNy96ZqF16DfO+5u+xtw952dLuXJimuHhMraH6Mze32tJlUjh92J/
         iXiky9VEXPAtI4eoGN41k5uGZnW7UlLxdcSA+ASJJK93RhitJOLF2MYyk187DNGWU4
         fiF06nQlOemJnGE23/pMIW1VPqeXEJLfBVbclnCprxE0qDy7j3F+qJWf+XkTMrMfjq
         aV21Qx6oUb/lQ==
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
Subject: [PATCH rdma-next v1 04/11] RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
Date:   Wed, 15 Sep 2021 02:07:23 +0300
Message-Id: <97ef07eab2b56b39f3c93e12364237d5aec2acb6.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660727.git.leonro@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
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
 drivers/infiniband/core/counters.c |  8 +++++++-
 drivers/infiniband/core/nldev.c    | 11 ++++++++++-
 drivers/infiniband/core/sysfs.c    |  7 ++++++-
 include/rdma/ib_verbs.h            | 12 ++++++++++++
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index df9e6c5e4ddf..a9559e33a113 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -165,6 +165,7 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 	return counter;
 
 err_mode:
+	kfree(counter->stats->is_disabled);
 	kfree(counter->stats);
 err_stats:
 	rdma_restrack_put(&counter->res);
@@ -186,6 +187,7 @@ static void rdma_counter_free(struct rdma_counter *counter)
 	mutex_unlock(&port_counter->lock);
 
 	rdma_restrack_del(&counter->res);
+	kfree(counter->stats->is_disabled);
 	kfree(counter->stats);
 	kfree(counter);
 }
@@ -618,6 +620,7 @@ void rdma_counter_init(struct ib_device *dev)
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
 		port_counter = &dev->port_data[port].port_counter;
+		kfree(port_counter->hstats->is_disabled);
 		kfree(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
@@ -631,7 +634,10 @@ void rdma_counter_release(struct ib_device *dev)
 
 	rdma_for_each_port(dev, port) {
 		port_counter = &dev->port_data[port].port_counter;
-		kfree(port_counter->hstats);
+		if (port_counter->hstats) {
+			kfree(port_counter->hstats->is_disabled);
+			kfree(port_counter->hstats);
+		}
 		mutex_destroy(&port_counter->lock);
 	}
 }
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
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c3663cfdcd52..a26bf960f7ef 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -754,8 +754,10 @@ static void ib_port_release(struct kobject *kobj)
 
 	for (i = 0; i != ARRAY_SIZE(port->groups); i++)
 		kfree(port->groups[i].attrs);
-	if (port->hw_stats_data)
+	if (port->hw_stats_data) {
+		kfree(port->hw_stats_data->stats->is_disabled);
 		kfree(port->hw_stats_data->stats);
+	}
 	kfree(port->hw_stats_data);
 	kfree(port);
 }
@@ -919,6 +921,7 @@ alloc_hw_stats_device(struct ib_device *ibdev)
 err_free_data:
 	kfree(data);
 err_free_stats:
+	kfree(stats->is_disabled);
 	kfree(stats);
 	return ERR_PTR(-ENOMEM);
 }
@@ -926,6 +929,7 @@ alloc_hw_stats_device(struct ib_device *ibdev)
 void ib_device_release_hw_stats(struct hw_stats_device_data *data)
 {
 	kfree(data->group.attrs);
+	kfree(data->stats->is_disabled);
 	kfree(data->stats);
 	kfree(data);
 }
@@ -1018,6 +1022,7 @@ alloc_hw_stats_port(struct ib_port *port, struct attribute_group *group)
 err_free_data:
 	kfree(data);
 err_free_stats:
+	kfree(stats->is_disabled);
 	kfree(stats);
 	return ERR_PTR(-ENOMEM);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6e484678b1fd..f016bc0cd9de 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -566,6 +566,8 @@ struct rdma_stat_desc {
  *   their own value during their allocation routine.
  * @descs - Array of pointers to static descriptors used for the counters
  *   in directory.
+ * @is_disabled - A bitmap to indicate each counter is currently disabled
+ *   or not.
  * @num_counters - How many hardware counters there are.  If name is
  *   shorter than this number, a kernel oops will result.  Driver authors
  *   are encouraged to leave BUILD_BUG_ON(ARRAY_SIZE(@name) < num_counters)
@@ -578,6 +580,7 @@ struct rdma_hw_stats {
 	unsigned long	timestamp;
 	unsigned long	lifespan;
 	const struct rdma_stat_desc *descs;
+	unsigned long	*is_disabled;
 	int		num_counters;
 	u64		value[];
 };
@@ -601,11 +604,20 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 	if (!stats)
 		return NULL;
 
+	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
+				      sizeof(long), GFP_KERNEL);
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
 
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9FB30787B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhA1Op2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhA1Oow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:44:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE6364DE2;
        Thu, 28 Jan 2021 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845051;
        bh=2arO9EYEEjPZwb3AGMNnI3tjt5dOsCgVOQaz+CdTdUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIXf7rZM+poV0MNpKEDZbOwPEAjTY8BNQhGSJzjhs4imGU0e+08ST/jcxzjS/laH5
         lIkqthUZfTcD8mDqJNfxbji4fYV8cDbxy4+xCxA5CQOoKsiu8iFHEoK5btoSS7W7UO
         aSRtuAXfhFy3gItq2VMnhh5CR8Zt491PJxWi03B8wM4mijPIS12I1ZHM8WjZTSdKJu
         9GZppGK/jdzt7o8O1pnqxPMTK9tYBKl+iwEIjZkJL2ki7f3/untlUEjRsQ0K9HnyR7
         pRfUmQnsaIhO5uXMn51oi8sH+6E4HABCp+hlE4CSMvES5K0+8edudW6wcuIAWpb8+q
         ciaoQxhswFLjQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 01/11] net-sysfs: convert xps_cpus_show to bitmap_zalloc
Date:   Thu, 28 Jan 2021 15:43:55 +0100
Message-Id: <20210128144405.4157244-2-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc instead if zalloc_cpumask_var in xps_cpus_show to
align with xps_rxqs_show. This will improve maintenance and allow us to
factorize the two functions. The function should behave the same.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index daf502c13d6d..e052fc5f7e94 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1320,8 +1320,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	cpumask_var_t mask;
-	unsigned long index;
+	unsigned long *mask, index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1349,7 +1348,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 		}
 	}
 
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
+	if (!mask) {
 		ret = -ENOMEM;
 		goto err_rtnl_unlock;
 	}
@@ -1367,7 +1367,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 			for (i = map->len; i--;) {
 				if (map->queues[i] == index) {
-					cpumask_set_cpu(cpu, mask);
+					set_bit(cpu, mask);
 					break;
 				}
 			}
@@ -1377,8 +1377,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	rtnl_unlock();
 
-	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
-	free_cpumask_var(mask);
+	len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
+	bitmap_free(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
 
 err_rtnl_unlock:
-- 
2.29.2


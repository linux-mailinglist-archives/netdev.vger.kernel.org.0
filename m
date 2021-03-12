Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC03390AA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhCLPFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhCLPEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:04:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A65F64F77;
        Fri, 12 Mar 2021 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561489;
        bh=V8FFZJKr/fjyAn8LXI9YH/ZhAckd3YMLQ0Q0jEu07Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8+LZLzlwirkiSkib1IwNCX5LnE0s8/VtJFdSw+krKtQxMA/PniNug0CN4JSmwhjl
         DQL1H30Sk5REn+rur6TegwvKK9dMO2bzcUelagv/6t6zubrd762C5PZnJnkyb10Y3n
         9LRqF+/bSzLAmrZWOn/mbABuo021gYITWEZD+gItZGT0SG1aFQoKq/EuyMJvxa8v9H
         65+BOAQJCuNg/Cfk/6Lul1W5o4DN4CTympCZqAoZcTC2YmovW8jAXzkicLghcq615p
         kFute+1i0c7028ODlLxkSw+KNuCtG+CqbnnwZnMYJjhWohEjAs7BWmOnyUId4LWRcV
         GxAOnh4Qw7p1Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 01/16] net-sysfs: convert xps_cpus_show to bitmap_zalloc
Date:   Fri, 12 Mar 2021 16:04:29 +0100
Message-Id: <20210312150444.355207-2-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc instead of zalloc_cpumask_var in xps_cpus_show to
align with xps_rxqs_show. This will improve maintenance and allow us to
factorize the two functions. The function should behave the same.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 307628fdf380..3a083c0c9dd3 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1367,8 +1367,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	cpumask_var_t mask;
-	unsigned long index;
+	unsigned long *mask, index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1396,7 +1395,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 		}
 	}
 
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
+	if (!mask) {
 		ret = -ENOMEM;
 		goto err_rtnl_unlock;
 	}
@@ -1414,7 +1414,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 			for (i = map->len; i--;) {
 				if (map->queues[i] == index) {
-					cpumask_set_cpu(cpu, mask);
+					set_bit(cpu, mask);
 					break;
 				}
 			}
@@ -1424,8 +1424,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	rtnl_unlock();
 
-	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
-	free_cpumask_var(mask);
+	len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
+	bitmap_free(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
 
 err_rtnl_unlock:
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5C340D3D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhCRSi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhCRSh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 190F764F1B;
        Thu, 18 Mar 2021 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092678;
        bh=RaMtDP2M+t/jAHp/NmmGeRQedsANoETBVwxrII9s2FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IF2zZns/tSvhMmHKGUMyzVritQSqYRPEgcmU0wPql8qNS26XVEhezV+nVo9ykg7eJ
         kku1rIGUjUuXgylbdcZK92eUyQPdXJDwU04P1L58bCkl5n+49ZBUkIRlJnOzt6yFUj
         4n8wjptwV76F52saZoUILibKAWExnLSORZFzVjDXEpNcZuo8fqocvPVg4jBKAkkjAh
         GLJVAler7l/zV8JZaYhREugzpcao9W47K05tkspYiDqINcOX4SbmdVjBtvTafRhZ0w
         9LZHd/4iOQVpqQq+GB1bxHWuD4R1TugMCzz7K2dPgLPriW5cj8l97whBO9dvbYhwNz
         0VxdclMpv0A0A==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 01/13] net-sysfs: convert xps_cpus_show to bitmap_zalloc
Date:   Thu, 18 Mar 2021 19:37:40 +0100
Message-Id: <20210318183752.2612563-2-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
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
2.30.2


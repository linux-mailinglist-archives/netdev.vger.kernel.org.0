Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB763390AB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhCLPFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhCLPEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:04:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E964464F77;
        Fri, 12 Mar 2021 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561495;
        bh=++YZELZPcLZWiZKJwsBz+YU9mmpmYURGyxz8dkpwo8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjILpSZqEyMPrGZth+ApFZVAeH5wlBGHu0BIfJbUKETlxqOR+hwi925zSTE+60rH2
         8w7TcY1VTdo+6pLaV1TX1Dlj5CkecxkvUBCb8sVHfF8m8JLy5Pg+MKVaGNBW/ehfV+
         2+QHrZTWjqpjvR4Ks55Pdj/TzuAQymajExu+c836AbB4twQzELIetLdIEpEWxWnHFR
         ULQ3CLWPHBL8pwxgP0BmMhKO02RRpXZpV3aI8bJ9gDlBeMLY/0O+X401jm/toJ4xA/
         ZYXxOd3iKvzQaVkOxvNDk7ZbbWU2asf49idcdugfSGTzpvbpWj84bxhne11fBormXE
         0kVXlN9nOxyAg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 03/16] net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
Date:   Fri, 12 Mar 2021 16:04:31 +0100
Message-Id: <20210312150444.355207-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the implementations of xps_cpus_show and xps_rxqs_show to converge,
as the two share the same logic but diverted over time. This should not
modify their behaviour but will help future changes and improve
maintenance.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5dc4223f6b68..5f76183ad5bc 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1364,7 +1364,7 @@ static const struct attribute_group dql_group = {
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
-	int cpu, len, ret, num_tc = 1, tc = 0;
+	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
 	unsigned long *mask;
@@ -1404,23 +1404,26 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_cpus_map);
-	if (dev_maps) {
-		for_each_possible_cpu(cpu) {
-			int i, tci = cpu * num_tc + tc;
-			struct xps_map *map;
-
-			map = rcu_dereference(dev_maps->attr_map[tci]);
-			if (!map)
-				continue;
-
-			for (i = map->len; i--;) {
-				if (map->queues[i] == index) {
-					set_bit(cpu, mask);
-					break;
-				}
+	if (!dev_maps)
+		goto out_no_maps;
+
+	for (j = -1; j = netif_attrmask_next(j, NULL, nr_cpu_ids),
+	     j < nr_cpu_ids;) {
+		int i, tci = j * num_tc + tc;
+		struct xps_map *map;
+
+		map = rcu_dereference(dev_maps->attr_map[tci]);
+		if (!map)
+			continue;
+
+		for (i = map->len; i--;) {
+			if (map->queues[i] == index) {
+				set_bit(j, mask);
+				break;
 			}
 		}
 	}
+out_no_maps:
 	rcu_read_unlock();
 
 	rtnl_unlock();
-- 
2.29.2


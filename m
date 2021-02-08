Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C27313ABD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBHRVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234563AbhBHRUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:20:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2698E64E92;
        Mon,  8 Feb 2021 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804767;
        bh=+fvNftx24TMqBGRpY9EhzN8hW+2R9TUBeBKmVTyeC1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP7qw+BUkz/ST5U0y3rYw7Bn84qbRuGdk2fEUB0HjUnH0n0n/0QIo0qcZLZbB+Zli
         DLdwy+2jK4Yok8gVB1iksyDUF2WlvEmYiEpgEJBfWRoBZc9Lrig8cO1cfmwzx4/+S6
         coiamo95aNO3YbqSFN1OIb2UG0uHJdYbG8FjLQP3kFCWay2t0OTYFmKSRD5nJ2M3Rv
         FAvLKIeG+hoe708+2seKeTLibjfhB7T1hEVwT3nP+FxFt56Q7sDuGtyXkh9yF6ShVN
         alcD1ktWgrt7WtLV9qsCoUy2KrrZEB7lrjVvpem1Q1rvl7CShyU3qRvqrNI0k/SMJh
         Q56nzmYmz9ZDw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 03/12] net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
Date:   Mon,  8 Feb 2021 18:19:08 +0100
Message-Id: <20210208171917.1088230-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
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
index 5a39e9b38e5f..3915b1826814 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1317,7 +1317,7 @@ static const struct attribute_group dql_group = {
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
-	int cpu, len, ret, num_tc = 1, tc = 0;
+	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
 	unsigned long *mask;
@@ -1357,23 +1357,26 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AB1572B47
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 04:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiGMCZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 22:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGMCZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 22:25:06 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58C65C8E95
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 19:25:05 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:55564.272008146
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 575C42800DB;
        Wed, 13 Jul 2022 10:25:00 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id a27974adc43b49f38a2368effe4da669 for netdev@vger.kernel.org;
        Wed, 13 Jul 2022 10:25:02 CST
X-Transaction-ID: a27974adc43b49f38a2368effe4da669
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alexanderduyck@fb.com,
        liyonglong@chinatelecom.cn
Subject: [PATCH] net: sort queues in xps maps
Date:   Wed, 13 Jul 2022 10:24:56 +0800
Message-Id: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the following case that set xps of each tx-queue with same cpu mask,
packets in the same tcp stream may be hash to different tx queue. Because
the order of queues in each xps map is not the same.

first set each tx-queue with different cpu mask
echo 0 > /sys/class/net/eth0/queues/tx-0
echo 1 > /sys/class/net/eth0/queues/tx-1
echo 2 > /sys/class/net/eth0/queues/tx-2
echo 4 > /sys/class/net/eth0/queues/tx-3
and then set each tx-queue with same cpu mask
echo f > /sys/class/net/eth0/queues/tx-0
echo f > /sys/class/net/eth0/queues/tx-1
echo f > /sys/class/net/eth0/queues/tx-2
echo f > /sys/class/net/eth0/queues/tx-3

at this point the order of each map queues is differnet, It will cause
packets in the same stream be hashed to diffetent tx queue:
attr_map[0].queues = [0,1,2,3]
attr_map[1].queues = [1,0,2,3]
attr_map[2].queues = [2,0,1,3]
attr_map[3].queues = [3,0,1,2]

It is more reasonable that pacekts in the same stream be hashed to the same
tx queue when all tx queue bind with the same CPUs.

Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
---
 net/core/dev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 978ed06..aab26b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -150,6 +150,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
+#include <linux/sort.h>
 
 #include "dev.h"
 #include "net-sysfs.h"
@@ -199,6 +200,11 @@ static int call_netdevice_notifiers_extack(unsigned long val,
 
 static DECLARE_RWSEM(devnet_rename_sem);
 
+static int cmp_u16(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
 static inline void dev_base_seq_inc(struct net *net)
 {
 	while (++net->dev_base_seq == 0)
@@ -2654,6 +2660,13 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 					  skip_tc);
 	}
 
+	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
+	     j < nr_ids;) {
+		tci = j * num_tc + tc;
+		map = xmap_dereference(new_dev_maps->attr_map[tci]);
+		sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
+	}
+
 	rcu_assign_pointer(dev->xps_maps[type], new_dev_maps);
 
 	/* Cleanup old maps */
-- 
1.8.3.1


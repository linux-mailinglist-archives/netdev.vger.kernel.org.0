Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76FE9B667
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405733AbfHWSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:51:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44544 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390860AbfHWSv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:51:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Aug 2019 21:51:19 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7NIpJED012807;
        Fri, 23 Aug 2019 21:51:19 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 02/10] net: sched: change tcf block offload counter type to atomic_t
Date:   Fri, 23 Aug 2019 21:50:48 +0300
Message-Id: <20190823185056.12536-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823185056.12536-1-vladbu@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for running proto ops functions without rtnl lock, change
offload counter type to atomic. This is necessary to allow updating the
counter by multiple concurrent users when offloading filters to hardware
from unlocked classifiers.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/sch_generic.h | 7 ++++---
 net/sched/cls_api.c       | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index a3eaf5f9d28f..d778c502decd 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/atomic.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
@@ -401,7 +402,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
-	unsigned int offloadcnt; /* Number of oddloaded filters */
+	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
 	struct {
 		struct tcf_chain *chain;
@@ -443,7 +444,7 @@ static inline void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
 	if (*flags & TCA_CLS_FLAGS_IN_HW)
 		return;
 	*flags |= TCA_CLS_FLAGS_IN_HW;
-	block->offloadcnt++;
+	atomic_inc(&block->offloadcnt);
 }
 
 static inline void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
@@ -451,7 +452,7 @@ static inline void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
 	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
 		return;
 	*flags &= ~TCA_CLS_FLAGS_IN_HW;
-	block->offloadcnt--;
+	atomic_dec(&block->offloadcnt);
 }
 
 static inline void
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 959b7ca1ca02..f2c2f8159e35 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -629,7 +629,7 @@ static void tc_indr_block_call(struct tcf_block *block,
 
 static bool tcf_block_offload_in_use(struct tcf_block *block)
 {
-	return block->offloadcnt;
+	return atomic_read(&block->offloadcnt);
 }
 
 static int tcf_block_offload_cmd(struct tcf_block *block,
-- 
2.21.0


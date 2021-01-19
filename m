Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0E82FB8F4
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395135AbhASOHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:07:03 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40511 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393784AbhASNJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 08:09:13 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 19 Jan 2021 14:08:15 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10JC8FR2021916;
        Tue, 19 Jan 2021 14:08:15 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 1/5] net: sched: Add multi-queue support to sch_tree_lock
Date:   Tue, 19 Jan 2021 14:08:11 +0200
Message-Id: <20210119120815.463334-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119120815.463334-1-maximmi@mellanox.com>
References: <20210119120815.463334-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing qdiscs that set TCQ_F_MQROOT don't use sch_tree_lock.
However, hardware-offloaded HTB will start setting this flag while also
using sch_tree_lock.

The current implementation of sch_tree_lock basically locks on
qdisc->dev_queue->qdisc, and it works fine when the tree is attached to
some queue. However, it's not the case for MQROOT qdiscs: such a qdisc
is the root itself, and its dev_queue just points to queue 0, while not
actually being used, because there are real per-queue qdiscs.

This patch changes the logic of sch_tree_lock and sch_tree_unlock to
lock the qdisc itself if it's the MQROOT.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/sch_generic.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 639e465a108f..9448e8cf1ee6 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -551,14 +551,20 @@ static inline struct net_device *qdisc_dev(const struct Qdisc *qdisc)
 	return qdisc->dev_queue->dev;
 }
 
-static inline void sch_tree_lock(const struct Qdisc *q)
+static inline void sch_tree_lock(struct Qdisc *q)
 {
-	spin_lock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_lock_bh(qdisc_lock(q));
+	else
+		spin_lock_bh(qdisc_root_sleeping_lock(q));
 }
 
-static inline void sch_tree_unlock(const struct Qdisc *q)
+static inline void sch_tree_unlock(struct Qdisc *q)
 {
-	spin_unlock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_unlock_bh(qdisc_lock(q));
+	else
+		spin_unlock_bh(qdisc_root_sleeping_lock(q));
 }
 
 extern struct Qdisc noop_qdisc;
-- 
2.25.1


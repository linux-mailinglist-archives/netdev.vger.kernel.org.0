Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8412A380C38
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhENOuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:50:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35220 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhENOua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:50:30 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 187FE6415E;
        Fri, 14 May 2021 16:48:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf 1/2] netfilter: flowtable: Remove redundant hw refresh bit
Date:   Fri, 14 May 2021 16:49:11 +0200
Message-Id: <20210514144912.4519-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210514144912.4519-1-pablo@netfilter.org>
References: <20210514144912.4519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Offloading conns could fail for multiple reasons and a hw refresh bit is
set to try to reoffload it in next sw packet.
But it could be in some cases and future points that the hw refresh bit
is not set but a refresh could succeed.
Remove the hw refresh bit and do offload refresh if requested.
There won't be a new work entry if a work is already pending
anyway as there is the hw pending bit.

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 1 -
 net/netfilter/nf_flow_table_core.c    | 3 +--
 net/netfilter/nf_flow_table_offload.c | 7 ++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 51d8eb99764d..48ef7460ff30 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -157,7 +157,6 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_REFRESH,
 	NF_FLOW_HW_PENDING,
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 39c02d1aeedf..1d02650dd715 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -306,8 +306,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 {
 	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table) ||
-		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
+	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
 
 	nf_flow_offload_add(flow_table, flow);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2af7bdb38407..528b2f172684 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -902,10 +902,11 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
-	else
-		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+		goto out;
+
+	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 
+out:
 	nf_flow_offload_destroy(flow_rule);
 }
 
-- 
2.20.1


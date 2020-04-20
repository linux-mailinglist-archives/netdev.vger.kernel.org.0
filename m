Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B1D1B1A56
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgDTXzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:55:47 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4269 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgDTXzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:55:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E52524145E;
        Tue, 21 Apr 2020 07:55:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: act_ct: update nf_conn_acct for act_ct SW offload in flowtable
Date:   Tue, 21 Apr 2020 07:55:43 +0800
Message-Id: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTkJCQkJDT0xPSklKSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006Nio6ATg3PAMwKRQJPzwz
        DAlPCRZVSlVKTkNMT0lNQk9PS0pDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNTUs3Bg++
X-HM-Tid: 0a719a04e3cf2086kuqye52524145e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When the act_ct SW offload in flowtable, The counter of the conntrack
entry will never update. So update the nf_conn_acct conuter in act_ct
flowtable software offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1a76639..9adff83 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -30,6 +30,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
@@ -536,6 +537,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
+	nf_ct_acct_update(ct, dir, skb->len);
 
 	return true;
 }
-- 
1.8.3.1


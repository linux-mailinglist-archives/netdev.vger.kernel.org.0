Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C28305E69
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhA0OfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:35:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46341 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234266AbhA0Odm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:33:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@nvidia.com)
        with SMTP; 27 Jan 2021 16:32:49 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10REWnmr010762;
        Wed, 27 Jan 2021 16:32:49 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 2/3] net: flow_offload: Add original direction flag to ct_metadata
Date:   Wed, 27 Jan 2021 16:32:46 +0200
Message-Id: <1611757967-18236-3-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give offloading drivers the direction of the offloaded ct flow,
this will be used for matches on direction (ct_state +/-rpl).

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/act_ct.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 123b1e9..e6bd8eb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -245,6 +245,7 @@ struct flow_action_entry {
 			unsigned long cookie;
 			u32 mark;
 			u32 labels[4];
+			bool orig_dir;
 		} ct_metadata;
 		struct {				/* FLOW_ACTION_MPLS_PUSH */
 			u32		label;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b344207..f0a0aa1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -183,6 +183,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 					     IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
+	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
 
 	act_ct_labels = entry->ct_metadata.labels;
 	ct_labels = nf_ct_labels_find(ct);
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A253217D418
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 15:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgCHOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 10:11:11 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40604 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726442AbgCHOLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 10:11:10 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Mar 2020 16:11:03 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 028EB3Cx032146;
        Sun, 8 Mar 2020 16:11:03 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v2 05/13] net/sched: act_ct: Enable hardware offload of flow table entires
Date:   Sun,  8 Mar 2020 16:10:54 +0200
Message-Id: <1583676662-15180-6-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the zone's flow table instance on the flow action to the drivers.
Thus, allowing drivers to register FT add/del/stats callbacks.

Finally, enable hardware offload on the flow table instance.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h |  1 +
 include/net/tc_act/tc_ct.h | 10 ++++++++++
 net/sched/act_ct.c         |  2 ++
 net/sched/cls_api.c        |  1 +
 4 files changed, 14 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index fc79c8c..af317c4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -197,6 +197,7 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_CT */
 			int action;
 			u16 zone;
+			struct nf_flowtable *flow_table;
 		} ct;
 		struct {
 			unsigned long cookie;
diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 735da59..79654bc 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -27,6 +27,7 @@ struct tcf_ct_params {
 	struct rcu_head rcu;
 
 	struct tcf_ct_flow_table *ct_ft;
+	struct nf_flowtable *nf_ft;
 };
 
 struct tcf_ct {
@@ -50,9 +51,18 @@ static inline int tcf_ct_action(const struct tc_action *a)
 	return to_ct_params(a)->ct_action;
 }
 
+static inline struct nf_flowtable *tcf_ct_ft(const struct tc_action *a)
+{
+	return to_ct_params(a)->nf_ft;
+}
+
 #else
 static inline uint16_t tcf_ct_zone(const struct tc_action *a) { return 0; }
 static inline int tcf_ct_action(const struct tc_action *a) { return 0; }
+static inline struct nf_flowtable *tcf_ct_ft(const struct tc_action *a)
+{
+	return NULL;
+}
 #endif /* CONFIG_NF_CONNTRACK */
 
 #if IS_ENABLED(CONFIG_NET_ACT_CT)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 84d5abf..d52185d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -292,6 +292,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 		goto err_insert;
 
 	ct_ft->nf_ft.type = &flowtable_ct;
+	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
@@ -299,6 +300,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	__module_get(THIS_MODULE);
 take_ref:
 	params->ct_ft = ct_ft;
+	params->nf_ft = &ct_ft->nf_ft;
 	ct_ft->ref++;
 	spin_unlock_bh(&zones_lock);
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e604ebe..67221fc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3600,6 +3600,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
 			entry->ct.zone = tcf_ct_zone(act);
+			entry->ct.flow_table = tcf_ct_ft(act);
 		} else if (is_tcf_mpls(act)) {
 			switch (tcf_mpls_action(act)) {
 			case TCA_MPLS_ACT_PUSH:
-- 
1.8.3.1


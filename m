Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F4816975F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgBWLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:45:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47925 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726236AbgBWLpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:45:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Feb 2020 13:45:36 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01NBjZEX006598;
        Sun, 23 Feb 2020 13:45:36 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 4/6] net/sched: act_ct: Create nf flow table per zone
Date:   Sun, 23 Feb 2020 13:45:05 +0200
Message-Id: <1582458307-17067-5-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the NF flow tables infrastructure for CT offload.

Create a nf flow table per zone.

Next patches will add FT entries to this table, and do
the software offload.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
 include/net/tc_act/tc_ct.h                      |   2 +
 net/sched/Kconfig                               |   2 +-
 net/sched/act_ct.c                              | 159 +++++++++++++++++++++++-
 4 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 70b5fe2..eb16136 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -45,6 +45,7 @@
 #include <net/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_ct.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include "en.h"
diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index a8b1564..cf3492e 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -25,6 +25,8 @@ struct tcf_ct_params {
 	u16 ct_action;
 
 	struct rcu_head rcu;
+
+	struct tcf_ct_flow_table *ct_ft;
 };
 
 struct tcf_ct {
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index edde0e5..bfbefb7 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
 	tristate "connection tracking tc action"
-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
+	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f685c0d..4267d7d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -15,6 +15,7 @@
 #include <linux/pkt_cls.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/rhashtable.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -24,6 +25,7 @@
 #include <uapi/linux/tc_act/tc_ct.h>
 #include <net/tc_act/tc_ct.h>
 
+#include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
@@ -31,6 +33,133 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
+static struct workqueue_struct *act_ct_wq;
+
+struct tcf_ct_flow_table {
+	struct rhash_head node; /* In zones tables */
+
+	struct rcu_work rwork;
+	struct nf_flowtable nf_ft;
+	u16 zone;
+	u32 ref;
+
+	bool dying;
+};
+
+static const struct rhashtable_params zones_params = {
+	.head_offset = offsetof(struct tcf_ct_flow_table, node),
+	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
+	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
+	.automatic_shrinking = true,
+};
+
+static struct rhashtable zones_ht;
+static DEFINE_SPINLOCK(zones_lock);
+
+static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
+{
+	spin_lock(&zones_lock);
+	--params->ct_ft->ref;
+	spin_unlock(&zones_lock);
+}
+
+static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
+{
+	struct tcf_ct_flow_table *ct_ft;
+
+	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
+			     rwork);
+	nf_flow_table_free(&ct_ft->nf_ft);
+	kfree(ct_ft);
+
+	module_put(THIS_MODULE);
+}
+
+static int tcf_ct_flow_table_cleanup(struct nf_flowtable *nf_ft)
+{
+	struct tcf_ct_flow_table *ct_ft;
+	int err = -EBUSY;
+
+	spin_lock(&zones_lock);
+
+	/* Delete the FT if there is no rules with CT action for this zone.
+	 *
+	 * This method will be called by the FT GC until the FT table will
+	 * be freed. Set the dying flags to avoid multiple cleanups
+	 * till it's actually freed in work cb.
+	 */
+	ct_ft = container_of(nf_ft, struct tcf_ct_flow_table, nf_ft);
+	if (ct_ft->ref == 0 && !ct_ft->dying) {
+		ct_ft->dying = true;
+
+		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
+		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
+		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
+
+		err = 0;
+	}
+
+	spin_unlock(&zones_lock);
+
+	return err;
+}
+
+static struct nf_flowtable_type flowtable_ct = {
+	.cleanup	= tcf_ct_flow_table_cleanup,
+	.owner		= THIS_MODULE,
+};
+
+static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+{
+	struct tcf_ct_flow_table *ct_ft;
+	int err = -ENOMEM;
+
+	spin_lock(&zones_lock);
+	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
+	if (ct_ft)
+		goto take_ref;
+
+	ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
+	if (!ct_ft)
+		goto alloc_err;
+
+	ct_ft->zone = params->zone;
+	err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
+	if (err)
+		goto insert_err;
+
+	ct_ft->nf_ft.type = &flowtable_ct;
+	err = nf_flow_table_init(&ct_ft->nf_ft);
+	if (err)
+		goto init_err;
+
+	__module_get(THIS_MODULE);
+take_ref:
+	params->ct_ft = ct_ft;
+	ct_ft->ref++;
+	spin_unlock(&zones_lock);
+
+	return 0;
+
+init_err:
+	rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
+insert_err:
+	kfree(ct_ft);
+alloc_err:
+	spin_unlock(&zones_lock);
+	return err;
+}
+
+static int tcf_ct_flow_tables_init(void)
+{
+	return rhashtable_init(&zones_ht, &zones_params);
+}
+
+static void tcf_ct_flow_tables_uninit(void)
+{
+	rhashtable_destroy(&zones_ht);
+}
+
 static struct tc_action_ops act_ct_ops;
 static unsigned int ct_net_id;
 
@@ -207,6 +336,8 @@ static void tcf_ct_params_free(struct rcu_head *head)
 	struct tcf_ct_params *params = container_of(head,
 						    struct tcf_ct_params, rcu);
 
+	tcf_ct_flow_table_put(params);
+
 	if (params->tmpl)
 		nf_conntrack_put(&params->tmpl->ct_general);
 	kfree(params);
@@ -730,6 +861,10 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
+	err = tcf_ct_flow_table_get(params);
+	if (err)
+		goto cleanup;
+
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	params = rcu_replace_pointer(c->params, params,
@@ -974,12 +1109,34 @@ static void __net_exit ct_exit_net(struct list_head *net_list)
 
 static int __init ct_init_module(void)
 {
-	return tcf_register_action(&act_ct_ops, &ct_net_ops);
+	int err;
+
+	act_ct_wq = alloc_ordered_workqueue("act_ct_workqueue", 0);
+	if (!act_ct_wq)
+		return -ENOMEM;
+
+	err = tcf_ct_flow_tables_init();
+	if (err)
+		goto err_tbl_init;
+
+	err = tcf_register_action(&act_ct_ops, &ct_net_ops);
+	if (err)
+		goto err_register;
+
+	return 0;
+
+err_tbl_init:
+	destroy_workqueue(act_ct_wq);
+err_register:
+	tcf_ct_flow_tables_uninit();
+	return err;
 }
 
 static void __exit ct_cleanup_module(void)
 {
 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
+	tcf_ct_flow_tables_uninit();
+	destroy_workqueue(act_ct_wq);
 }
 
 module_init(ct_init_module);
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719C31D31C2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgENNtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:49:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53781 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726051AbgENNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:49:03 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:49:00 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDmxb9025987;
        Thu, 14 May 2020 16:48:59 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 2/3] net/sched: act_ct: Add policy_pkts tuple offload control policy
Date:   Thu, 14 May 2020 16:48:29 +0300
Message-Id: <1589464110-7571-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netfilter packet accounting to add support for tc user
specifying per zone policy_pkts, which determines after how
many packets a tuple will be offloaded to the zone's flow table.

To avoid conflicting policies, the same policy must be given for all
act ct instances of the same zone.

Usage example:
$ tc filter add dev ens1f0_0 ingress chain 0 flower ct_state -trk \
action ct policy_pkts 10 pipe action goto chain 1

$ tc filter add dev ens1f0_0 ingress chain 1 flower ct_state \
action ct commit policy_pkts 10 pipe \
action mirred egress redirect dev ens1f0_1

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_ct.h        |  4 +++
 include/uapi/linux/tc_act/tc_ct.h |  1 +
 net/sched/act_ct.c                | 74 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 79654bc..9d9fdcc 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -19,6 +19,10 @@ struct tcf_ct_params {
 	u32 labels[NF_CT_LABELS_MAX_SIZE / sizeof(u32)];
 	u32 labels_mask[NF_CT_LABELS_MAX_SIZE / sizeof(u32)];
 
+	struct {
+		u32 pkts;
+	} offload_policy;
+
 	struct nf_nat_range2 range;
 	bool ipv4_range;
 
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index 5fb1d7a..a97e740 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -21,6 +21,7 @@ enum {
 	TCA_CT_NAT_IPV6_MAX,	/* struct in6_addr */
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
+	TCA_CT_OFFLOAD_POLICY_PKTS,	/* u32 */
 	TCA_CT_PAD,
 	__TCA_CT_MAX
 };
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9adff83..5b18d62 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -27,6 +27,7 @@
 
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -46,6 +47,10 @@ struct tcf_ct_flow_table {
 	refcount_t ref;
 	u16 zone;
 
+	struct {
+		u32 pkts;
+	} offload_policy;
+
 	bool dying;
 };
 
@@ -267,12 +272,57 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	return err;
 }
 
+static int tcf_ct_flow_table_policy_set(struct net *net,
+					struct tcf_ct_params *params,
+					struct netlink_ext_ack *extack,
+					bool ct_ft_created)
+{
+	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
+
+	if (!ct_ft_created) {
+		if (params->offload_policy.pkts != ct_ft->offload_policy.pkts) {
+			NL_SET_ERR_MSG_MOD(extack, "Policy pkts must match previous action ct instance");
+			return -EOPNOTSUPP;
+		}
+		return 0;
+	}
+
+	if (params->offload_policy.pkts) {
+		ct_ft->offload_policy.pkts = params->offload_policy.pkts;
+		if (!nf_ct_acct_enabled(net))
+			nf_ct_set_acct(net, true);
+	}
+	return 0;
+}
+
+static bool tcf_ct_check_offload_policy(struct tcf_ct_flow_table *ct_ft,
+					struct nf_conn *ct)
+{
+	struct nf_conn_counter *counter;
+	struct nf_conn_acct *acct;
+	u64 pkts;
+
+	if (!ct_ft->offload_policy.pkts)
+		return true;
+
+	acct = nf_conn_acct_find(ct);
+	if (!acct)
+		return false;
+
+	counter = acct->counter;
+	pkts = atomic64_read(&counter[IP_CT_DIR_ORIGINAL].packets) +
+	       atomic64_read(&counter[IP_CT_DIR_REPLY].packets);
+
+	return pkts >= ct_ft->offload_policy.pkts;
+}
+
 static struct nf_flowtable_type flowtable_ct = {
 	.action		= tcf_ct_flow_table_fill_actions,
 	.owner		= THIS_MODULE,
 };
 
-static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+static int tcf_ct_flow_table_get(struct tcf_ct_params *params,
+				 bool *ct_ft_created)
 {
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
@@ -299,6 +349,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 		goto err_init;
 
 	__module_get(THIS_MODULE);
+	*ct_ft_created = true;
 out_unlock:
 	params->ct_ft = ct_ft;
 	params->nf_ft = &ct_ft->nf_ft;
@@ -345,6 +396,9 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 	struct flow_offload *entry;
 	int err;
 
+	if (!tcf_ct_check_offload_policy(ct_ft, ct))
+		return;
+
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		return;
 
@@ -1034,6 +1088,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 				   .len = sizeof(struct in6_addr) },
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+	[TCA_CT_OFFLOAD_POLICY_PKTS] = { .type = NLA_U32 },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -1179,6 +1234,10 @@ static int tcf_ct_fill_params(struct net *net,
 				   sizeof(p->zone));
 	}
 
+	if (tb[TCA_CT_OFFLOAD_POLICY_PKTS])
+		p->offload_policy.pkts =
+			nla_get_u32(tb[TCA_CT_OFFLOAD_POLICY_PKTS]);
+
 	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
 		return 0;
 
@@ -1205,6 +1264,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	struct tcf_ct_params *params = NULL;
 	struct nlattr *tb[TCA_CT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
+	bool ct_ft_created = false;
 	struct tc_ct *parm;
 	struct tcf_ct *c;
 	int err, res = 0;
@@ -1262,7 +1322,11 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(params, &ct_ft_created);
+	if (err)
+		goto cleanup;
+
+	err = tcf_ct_flow_table_policy_set(net, params, extack, ct_ft_created);
 	if (err)
 		goto cleanup;
 
@@ -1282,6 +1346,8 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	return res;
 
 cleanup:
+	if (params->ct_ft)
+		tcf_ct_flow_table_put(params);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	kfree(params);
@@ -1414,6 +1480,10 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 	if (tcf_ct_dump_nat(skb, p))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_CT_OFFLOAD_POLICY_PKTS,
+			p->offload_policy.pkts))
+		goto nla_put_failure;
+
 skip_dump:
 	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
1.8.3.1


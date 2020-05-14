Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4857B1D31C3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgENNtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:49:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49160 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726124AbgENNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:49:03 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:49:00 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDmxbA025987;
        Thu, 14 May 2020 16:49:00 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 3/3] net/sched: act_ct: Add policy_timeout tuple offload control policy
Date:   Thu, 14 May 2020 16:48:30 +0300
Message-Id: <1589464110-7571-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use nf flow table flow timeout param, to add support for tc user
specifying per zone policy_timeout, which determines the time, in
seconds, a tuple will remain offloaded in the flow table after
last seen packet.

To avoid conflicting policies, the same policy must be given for all
act ct instances of the same zone.

Usage example:
$ tc filter add dev ens1f0_0 ingress chain 0 flower ct_state -trk \
action ct policy_timeout 120 pipe action goto chain 1

$ tc filter add dev ens1f0_0 ingress chain 1 flower ct_state \
action ct commit policy_timeout 120 pipe \
action mirred egress redirect dev ens1f0_1

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_ct.h        |  1 +
 include/uapi/linux/tc_act/tc_ct.h |  1 +
 net/sched/act_ct.c                | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 9d9fdcc..1de3769 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -21,6 +21,7 @@ struct tcf_ct_params {
 
 	struct {
 		u32 pkts;
+		u32 timeout;
 	} offload_policy;
 
 	struct nf_nat_range2 range;
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index a97e740..501709e 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -22,6 +22,7 @@ enum {
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
 	TCA_CT_OFFLOAD_POLICY_PKTS,	/* u32 */
+	TCA_CT_OFFLOAD_POLICY_TIMEOUT,	/* u32 */
 	TCA_CT_PAD,
 	__TCA_CT_MAX
 };
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5b18d62..de95d9d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -49,6 +49,7 @@ struct tcf_ct_flow_table {
 
 	struct {
 		u32 pkts;
+		u32 timeout;
 	} offload_policy;
 
 	bool dying;
@@ -284,6 +285,12 @@ static int tcf_ct_flow_table_policy_set(struct net *net,
 			NL_SET_ERR_MSG_MOD(extack, "Policy pkts must match previous action ct instance");
 			return -EOPNOTSUPP;
 		}
+
+		if (params->offload_policy.timeout !=
+		    ct_ft->offload_policy.timeout) {
+			NL_SET_ERR_MSG_MOD(extack, "Policy timeout must match previous action ct instance");
+			return -EOPNOTSUPP;
+		}
 		return 0;
 	}
 
@@ -292,6 +299,8 @@ static int tcf_ct_flow_table_policy_set(struct net *net,
 		if (!nf_ct_acct_enabled(net))
 			nf_ct_set_acct(net, true);
 	}
+
+	ct_ft->offload_policy.timeout = params->offload_policy.timeout;
 	return 0;
 }
 
@@ -344,6 +353,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params,
 
 	ct_ft->nf_ft.type = &flowtable_ct;
 	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
+	ct_ft->nf_ft.flow_timeout = params->offload_policy.timeout;
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
@@ -1089,6 +1099,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
 	[TCA_CT_OFFLOAD_POLICY_PKTS] = { .type = NLA_U32 },
+	[TCA_CT_OFFLOAD_POLICY_TIMEOUT] = { .type = NLA_U32 },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -1238,6 +1249,10 @@ static int tcf_ct_fill_params(struct net *net,
 		p->offload_policy.pkts =
 			nla_get_u32(tb[TCA_CT_OFFLOAD_POLICY_PKTS]);
 
+	if (tb[TCA_CT_OFFLOAD_POLICY_TIMEOUT])
+		p->offload_policy.timeout =
+			nla_get_u32(tb[TCA_CT_OFFLOAD_POLICY_TIMEOUT]);
+
 	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
 		return 0;
 
@@ -1484,6 +1499,10 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 			p->offload_policy.pkts))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_CT_OFFLOAD_POLICY_TIMEOUT,
+			p->offload_policy.timeout))
+		goto nla_put_failure;
+
 skip_dump:
 	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
1.8.3.1


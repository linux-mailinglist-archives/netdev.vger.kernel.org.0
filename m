Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D2B17766D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgCCMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:53:04 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53310 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728056AbgCCMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:53:03 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 14:52:56 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023Cqu3t009481;
        Tue, 3 Mar 2020 14:52:56 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 2/3] net/sched: act_ct: Offload established connections to flow table
Date:   Tue,  3 Mar 2020 14:52:52 +0200
Message-Id: <1583239973-3728-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
References: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a ft entry when connections enter an established state and delete
the connections when they leave the established state.

The flow table assumes ownership of the connection. In the following
patch act_ct will lookup the ct state from the FT. In future patches,
drivers will register for callbacks for ft add/del events and will be
able to use the information to offload the connections.

Note that connection aging is managed by the FT.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/act_ct.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d36417f..6ad0553 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -125,6 +125,67 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 	spin_unlock_bh(&zones_lock);
 }
 
+static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
+				  struct nf_conn *ct,
+				  bool tcp)
+{
+	struct flow_offload *entry;
+	int err;
+
+	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
+		return;
+
+	entry = flow_offload_alloc(ct);
+	if (!entry) {
+		WARN_ON_ONCE(1);
+		goto err_alloc;
+	}
+
+	if (tcp) {
+		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	}
+
+	err = flow_offload_add(&ct_ft->nf_ft, entry);
+	if (err)
+		goto err_add;
+
+	return;
+
+err_add:
+	flow_offload_free(entry);
+err_alloc:
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
+}
+
+static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
+					   struct nf_conn *ct,
+					   enum ip_conntrack_info ctinfo)
+{
+	bool tcp = false;
+
+	if (ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY)
+		return;
+
+	switch (nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+		tcp = true;
+		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
+			return;
+		break;
+	case IPPROTO_UDP:
+		break;
+	default:
+		return;
+	}
+
+	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
+	    ct->status & IPS_SEQ_ADJUST)
+		return;
+
+	tcf_ct_flow_table_add(ct_ft, ct, tcp);
+}
+
 static int tcf_ct_flow_tables_init(void)
 {
 	return rhashtable_init(&zones_ht, &zones_params);
@@ -578,6 +639,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		nf_conntrack_confirm(skb);
 	}
 
+	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
+
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-- 
1.8.3.1


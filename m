Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7847B174D66
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCAM67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:58:59 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60231 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726465AbgCAM66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 07:58:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Mar 2020 14:58:52 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 021CwpcM011348;
        Sun, 1 Mar 2020 14:58:51 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v2 2/3] net/sched: act_ct: Offload established connections to flow table
Date:   Sun,  1 Mar 2020 14:58:42 +0200
Message-Id: <1583067523-1960-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583067523-1960-1-git-send-email-paulb@mellanox.com>
References: <1583067523-1960-1-git-send-email-paulb@mellanox.com>
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
index 43dfdd1..b512f20 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -134,6 +134,67 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
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
@@ -587,6 +648,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		nf_conntrack_confirm(skb);
 	}
 
+	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
+
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-- 
1.8.3.1


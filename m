Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E529017A8EE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgCEPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:34:55 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39075 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726905AbgCEPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:34:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Mar 2020 17:34:35 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 025FYYsR010824;
        Thu, 5 Mar 2020 17:34:34 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload 03/13] net/sched: act_ct: Support restoring conntrack info on skbs
Date:   Thu,  5 Mar 2020 17:34:18 +0200
Message-Id: <1583422468-8456-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an API to restore the ct state pointer.

This may be used by drivers to restore the ct state if they
miss in tc chain after they already did the hardware connection
tracking action (ct_metadata action).

For example, consider the following rule on chain 0 that is in_hw,
however chain 1 is not_in_hw:

$ tc filter add dev ... chain 0 ... \
  flower ... action ct pipe action goto chain 1

Packets of a flow offloaded (via nf flow table offload) by the driver
hit this rule in hardware, will be marked with the ct metadata action
(mark, label, zone) that does the equivalent of the software ct action,
and when the packet jumps to hardware chain 1, there would be a miss.

CT was already processed in hardware. Therefore, the driver's miss
handling should restore the ct state on the skb, using the provided API,
and continue the packet processing in chain 1.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h |  1 +
 include/net/tc_act/tc_ct.h |  7 +++++++
 net/sched/act_ct.c         | 15 +++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f7215fa..9670f15 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -199,6 +199,7 @@ struct flow_action_entry {
 			u16 zone;
 		} ct;
 		struct {
+			unsigned long cookie;
 			u32 mark;
 			u32 labels[4];
 			u16 zone;
diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index cf3492e..735da59 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -55,6 +55,13 @@ static inline int tcf_ct_action(const struct tc_action *a)
 static inline int tcf_ct_action(const struct tc_action *a) { return 0; }
 #endif /* CONFIG_NF_CONNTRACK */
 
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie);
+#else
+static inline void
+tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie) { }
+#endif
+
 static inline bool is_tcf_ct(const struct tc_action *a)
 {
 #if defined(CONFIG_NET_CLS_ACT) && IS_ENABLED(CONFIG_NF_CONNTRACK)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0773456..47cdba6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -175,6 +175,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 {
 	struct nf_conn_labels *ct_labels;
 	struct flow_action_entry *entry;
+	enum ip_conntrack_info ctinfo;
 	u32 *act_ct_labels;
 
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
@@ -183,6 +184,10 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = ct->mark;
 #endif
+	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
+					     IP_CT_ESTABLISHED_REPLY;
+	/* aligns with the CT reference on the SKB nf_ct_set */
+	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 
 	act_ct_labels = entry->ct_metadata.labels;
 	ct_labels = nf_ct_labels_find(ct);
@@ -1517,6 +1522,16 @@ static void __exit ct_cleanup_module(void)
 	destroy_workqueue(act_ct_wq);
 }
 
+void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
+{
+	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
+	struct nf_conn *ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
+
+	nf_conntrack_get(&ct->ct_general);
+	nf_ct_set(skb, ct, ctinfo);
+}
+EXPORT_SYMBOL_GPL(tcf_ct_flow_table_restore_skb);
+
 module_init(ct_init_module);
 module_exit(ct_cleanup_module);
 MODULE_AUTHOR("Paul Blakey <paulb@mellanox.com>");
-- 
1.8.3.1


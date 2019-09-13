Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A657CB235E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390559AbfIMP3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:29:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35522 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388392AbfIMP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 11:29:03 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Sep 2019 18:28:56 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8DFSuJD018845;
        Fri, 13 Sep 2019 18:28:56 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 1/3] net: sched: extend flow_action_entry with destructor
Date:   Fri, 13 Sep 2019 18:28:39 +0300
Message-Id: <20190913152841.15755-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190913152841.15755-1-vladbu@mellanox.com>
References: <20190913152841.15755-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generalize flow_action_entry cleanup by extending the structure with
pointer to destructor function. Set the destructor in
tc_setup_flow_action(). Refactor tc_cleanup_flow_action() to call
entry->destructor() instead of using switch that dispatches by entry->id
and manually executes cleanup.

This refactoring is necessary for following patches in this series that
require destructor to use tc_action->ops callbacks that can't be easily
obtained in tc_cleanup_flow_action().

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h |  6 ++-
 net/sched/cls_api.c        | 77 ++++++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index fc881875f856..86c567f531f3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -154,8 +154,12 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
+typedef void (*action_destr)(void *priv);
+
 struct flow_action_entry {
 	enum flow_action_id		id;
+	action_destr			destructor;
+	void				*destructor_priv;
 	union {
 		u32			chain_index;	/* FLOW_ACTION_GOTO */
 		struct net_device	*dev;		/* FLOW_ACTION_REDIRECT */
@@ -170,7 +174,7 @@ struct flow_action_entry {
 			u32		mask;
 			u32		val;
 		} mangle;
-		const struct ip_tunnel_info *tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
+		struct ip_tunnel_info	*tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
 		u16                     ptype;          /* FLOW_ACTION_PTYPE */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 05c4fe1c3ca2..c668195379bd 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3282,25 +3282,48 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 	struct flow_action_entry *entry;
 	int i;
 
-	flow_action_for_each(i, entry, flow_action) {
-		switch (entry->id) {
-		case FLOW_ACTION_REDIRECT:
-		case FLOW_ACTION_MIRRED:
-		case FLOW_ACTION_REDIRECT_INGRESS:
-		case FLOW_ACTION_MIRRED_INGRESS:
-			if (entry->dev)
-				dev_put(entry->dev);
-			break;
-		case FLOW_ACTION_TUNNEL_ENCAP:
-			kfree(entry->tunnel);
-			break;
-		default:
-			break;
-		}
-	}
+	flow_action_for_each(i, entry, flow_action)
+		if (entry->destructor)
+			entry->destructor(entry->destructor_priv);
 }
 EXPORT_SYMBOL(tc_cleanup_flow_action);
 
+static void tcf_mirred_put_dev(void *priv)
+{
+	struct net_device *dev = priv;
+
+	dev_put(dev);
+}
+
+static void tcf_mirred_get_dev(struct flow_action_entry *entry,
+			       const struct tc_action *act)
+{
+	entry->dev = tcf_mirred_dev(act);
+	if (!entry->dev)
+		return;
+	dev_hold(entry->dev);
+	entry->destructor = tcf_mirred_put_dev;
+	entry->destructor_priv = entry->dev;
+}
+
+static void tcf_tunnel_encap_put_tunnel(void *priv)
+{
+	struct ip_tunnel_info *tunnel = priv;
+
+	kfree(tunnel);
+}
+
+static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
+				       const struct tc_action *act)
+{
+	entry->tunnel = tcf_tunnel_info_copy(act);
+	if (!entry->tunnel)
+		return -ENOMEM;
+	entry->destructor = tcf_tunnel_encap_put_tunnel;
+	entry->destructor_priv = entry->tunnel;
+	return 0;
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
@@ -3329,24 +3352,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->chain_index = tcf_gact_goto_chain_index(act);
 		} else if (is_tcf_mirred_egress_redirect(act)) {
 			entry->id = FLOW_ACTION_REDIRECT;
-			entry->dev = tcf_mirred_dev(act);
-			if (entry->dev)
-				dev_hold(entry->dev);
+			tcf_mirred_get_dev(entry, act);
 		} else if (is_tcf_mirred_egress_mirror(act)) {
 			entry->id = FLOW_ACTION_MIRRED;
-			entry->dev = tcf_mirred_dev(act);
-			if (entry->dev)
-				dev_hold(entry->dev);
+			tcf_mirred_get_dev(entry, act);
 		} else if (is_tcf_mirred_ingress_redirect(act)) {
 			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
-			entry->dev = tcf_mirred_dev(act);
-			if (entry->dev)
-				dev_hold(entry->dev);
+			tcf_mirred_get_dev(entry, act);
 		} else if (is_tcf_mirred_ingress_mirror(act)) {
 			entry->id = FLOW_ACTION_MIRRED_INGRESS;
-			entry->dev = tcf_mirred_dev(act);
-			if (entry->dev)
-				dev_hold(entry->dev);
+			tcf_mirred_get_dev(entry, act);
 		} else if (is_tcf_vlan(act)) {
 			switch (tcf_vlan_action(act)) {
 			case TCA_VLAN_ACT_PUSH:
@@ -3370,11 +3385,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			}
 		} else if (is_tcf_tunnel_set(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
-			entry->tunnel = tcf_tunnel_info_copy(act);
-			if (!entry->tunnel) {
-				err = -ENOMEM;
+			err = tcf_tunnel_encap_get_tunnel(entry, act);
+			if (err)
 				goto err_out;
-			}
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else if (is_tcf_pedit(act)) {
-- 
2.21.0


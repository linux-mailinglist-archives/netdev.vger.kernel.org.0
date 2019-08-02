Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5197F9C5
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394912AbfHBN3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:29:34 -0400
Received: from correo.us.es ([193.147.175.20]:41502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394910AbfHBN3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:29:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0264FB453
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0BBF11510A
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 835FC1150DF; Fri,  2 Aug 2019 15:29:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D83B01150CE;
        Fri,  2 Aug 2019 15:29:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 02 Aug 2019 15:29:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.181.192])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 95DDA4265A31;
        Fri,  2 Aug 2019 15:29:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: [PATCH net-next 1/3,v2] net: sched: use major priority number as hardware priority
Date:   Fri,  2 Aug 2019 15:28:44 +0200
Message-Id: <20190802132846.3067-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190802132846.3067-1-pablo@netfilter.org>
References: <20190802132846.3067-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc transparently maps the software priority number to hardware. Update
it to pass the major priority which is what most drivers expect. Update
drivers too so they do not need to lshift the priority field of the
flow_cls_common_offload object. The stmmac driver is an exception, since
this code assumes the tc software priority is fine, therefore, lshift it
just to be conservative.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c            | 12 +++---------
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c      |  2 +-
 include/net/pkt_cls.h                                |  2 +-
 6 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cc096f6011d9..744c0c640c10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3158,7 +3158,7 @@ mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *esw_attr,
 
 	esw_attr->parse_attr = parse_attr;
 	esw_attr->chain = f->common.chain_index;
-	esw_attr->prio = TC_H_MAJ(f->common.prio) >> 16;
+	esw_attr->prio = f->common.prio;
 
 	esw_attr->in_rep = in_rep;
 	esw_attr->in_mdev = in_mdev;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index e8ac90564dbe..84a87d059333 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -471,7 +471,7 @@ int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei)
 void mlxsw_sp_acl_rulei_priority(struct mlxsw_sp_acl_rule_info *rulei,
 				 unsigned int priority)
 {
-	rulei->priority = priority >> 16;
+	rulei->priority = priority;
 }
 
 void mlxsw_sp_acl_rulei_keymask_u32(struct mlxsw_sp_acl_rule_info *rulei,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 59487d446a09..b894bc0c9c16 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -13,12 +13,6 @@ struct ocelot_port_block {
 	struct ocelot_port *port;
 };
 
-static u16 get_prio(u32 prio)
-{
-	/* prio starts from 0x1000 while the ids starts from 0 */
-	return prio >> 16;
-}
-
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *rule)
 {
@@ -168,7 +162,7 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 	}
 
 finished_key_parsing:
-	ocelot_rule->prio = get_prio(f->common.prio);
+	ocelot_rule->prio = f->common.prio;
 	ocelot_rule->id = f->cookie;
 	return ocelot_flower_parse_action(f, ocelot_rule);
 }
@@ -218,7 +212,7 @@ static int ocelot_flower_destroy(struct flow_cls_offload *f,
 	struct ocelot_ace_rule rule;
 	int ret;
 
-	rule.prio = get_prio(f->common.prio);
+	rule.prio = f->common.prio;
 	rule.port = port_block->port;
 	rule.id = f->cookie;
 
@@ -236,7 +230,7 @@ static int ocelot_flower_stats_update(struct flow_cls_offload *f,
 	struct ocelot_ace_rule rule;
 	int ret;
 
-	rule.prio = get_prio(f->common.prio);
+	rule.prio = f->common.prio;
 	rule.port = port_block->port;
 	rule.id = f->cookie;
 	ret = ocelot_ace_rule_stats_update(&rule);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 86e968cd5ffd..124a43dc136a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -93,7 +93,7 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 
-	if (flow->common.prio != (1 << 16)) {
+	if (flow->common.prio != 1) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload requires highest priority");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 58ea18af9813..5cd040215469 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -94,7 +94,7 @@ static int tc_fill_entry(struct stmmac_priv *priv,
 	struct stmmac_tc_entry *entry, *frag = NULL;
 	struct tc_u32_sel *sel = cls->knode.sel;
 	u32 off, data, mask, real_off, rem;
-	u32 prio = cls->common.prio;
+	u32 prio = cls->common.prio << 16;
 	int ret;
 
 	/* Only 1 match per entry */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e429809ca90d..98be18ef1ed3 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -646,7 +646,7 @@ tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
 {
 	cls_common->chain_index = tp->chain->index;
 	cls_common->protocol = tp->protocol;
-	cls_common->prio = tp->prio;
+	cls_common->prio = tp->prio >> 16;
 	if (tc_skip_sw(flags) || flags & TCA_CLS_FLAGS_VERBOSE)
 		cls_common->extack = extack;
 }
-- 
2.11.0


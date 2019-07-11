Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB5064F71
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 02:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfGKAMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 20:12:53 -0400
Received: from mail.us.es ([193.147.175.20]:35042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfGKAMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 20:12:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3EF2080D0B
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 02:12:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FE0910219C
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 02:12:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25795A6B0; Thu, 11 Jul 2019 02:12:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9028DA7B6;
        Thu, 11 Jul 2019 02:12:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jul 2019 02:12:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 870EC4265A32;
        Thu, 11 Jul 2019 02:12:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next 1/3] net: flow_offload: remove netns parameter from flow_block_cb_alloc()
Date:   Thu, 11 Jul 2019 02:12:33 +0200
Message-Id: <20190711001235.20686-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to annotate the netns on the flow block callback object,
flow_block_cb_is_busy() already checks for used blocks.

Fixes: d63db30c8537 ("net: flow_offload: add flow_block_cb_alloc() and flow_block_cb_free()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    | 3 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      | 5 ++---
 drivers/net/ethernet/mscc/ocelot_flower.c           | 3 +--
 drivers/net/ethernet/mscc/ocelot_tc.c               | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 6 ++----
 include/net/flow_offload.h                          | 3 +--
 net/core/flow_offload.c                             | 9 +++------
 net/dsa/slave.c                                     | 2 +-
 8 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7245d287633d..2162412073c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -735,8 +735,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(f->net,
-					       mlx5e_rep_indr_setup_block_cb,
+		block_cb = flow_block_cb_alloc(mlx5e_rep_indr_setup_block_cb,
 					       indr_priv, indr_priv,
 					       mlx5e_rep_indr_tc_block_unbind);
 		if (IS_ERR(block_cb)) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4d34d42b3b0e..a469035400cf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1610,8 +1610,7 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = flow_block_cb_alloc(f->net,
-					       mlxsw_sp_setup_tc_block_cb_flower,
+		block_cb = flow_block_cb_alloc(mlxsw_sp_setup_tc_block_cb_flower,
 					       mlxsw_sp, acl_block,
 					       mlxsw_sp_tc_block_flower_release);
 		if (IS_ERR(block_cb)) {
@@ -1702,7 +1701,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 					  &mlxsw_sp_block_cb_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
+		block_cb = flow_block_cb_alloc(cb, mlxsw_sp_port,
 					       mlxsw_sp_port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7aaddc09c185..6a11aea8b186 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -323,8 +323,7 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 		if (!port_block)
 			return -ENOMEM;
 
-		block_cb = flow_block_cb_alloc(f->net,
-					       ocelot_setup_tc_block_cb_flower,
+		block_cb = flow_block_cb_alloc(ocelot_setup_tc_block_cb_flower,
 					       port, port_block,
 					       ocelot_tc_block_unbind);
 		if (IS_ERR(block_cb)) {
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 9e6464ffae5d..abbcb66bf5ac 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -156,7 +156,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		if (flow_block_cb_is_busy(cb, port, &ocelot_block_cb_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
+		block_cb = flow_block_cb_alloc(cb, port, port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7e725fa60347..a0f8892bb4b5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1324,8 +1324,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 					  &nfp_block_cb_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(f->net,
-					       nfp_flower_setup_tc_block_cb,
+		block_cb = flow_block_cb_alloc(nfp_flower_setup_tc_block_cb,
 					       repr, repr, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
@@ -1430,8 +1429,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = flow_block_cb_alloc(f->net,
-					       nfp_flower_setup_indr_block_cb,
+		block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
 					       cb_priv, cb_priv,
 					       nfp_flower_setup_indr_tc_release);
 		if (IS_ERR(block_cb)) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index db337299e81e..aa9b5287b231 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -264,7 +264,6 @@ struct flow_block_offload {
 struct flow_block_cb {
 	struct list_head	driver_list;
 	struct list_head	list;
-	struct net		*net;
 	tc_setup_cb_t		*cb;
 	void			*cb_ident;
 	void			*cb_priv;
@@ -272,7 +271,7 @@ struct flow_block_cb {
 	unsigned int		refcnt;
 };
 
-struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(tc_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 76f8db3841d7..507de4b48815 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -165,7 +165,7 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
 
-struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(tc_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
 {
@@ -175,7 +175,6 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
-	block_cb->net = net;
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
 	block_cb->cb_priv = cb_priv;
@@ -200,8 +199,7 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
 	struct flow_block_cb *block_cb;
 
 	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
-		if (block_cb->net == f->net &&
-		    block_cb->cb == cb &&
+		if (block_cb->cb == cb &&
 		    block_cb->cb_ident == cb_ident)
 			return block_cb;
 	}
@@ -261,8 +259,7 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 		if (flow_block_cb_is_busy(cb, cb_ident, driver_block_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident,
-					       cb_priv, NULL);
+		block_cb = flow_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 614c38ece104..6ca9ec58f881 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -967,7 +967,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 		if (flow_block_cb_is_busy(cb, dev, &dsa_slave_block_cb_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
+		block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
-- 
2.11.0



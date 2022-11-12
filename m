Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAEE6268D7
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiKLKWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiKLKWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C70C2AC59
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 273AAB8069E
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA21CC433C1;
        Sat, 12 Nov 2022 10:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248526;
        bh=SeR7lrYPyIHQgwudhjty7OKGSmyYXQUNu2dBaemAnyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsOB7pEP5bG+rT/F8VhAzQRqfOo8fWGDJeh2swTtxNEEDJcbpn4R9aGKR/0o9KKRi
         9eOCDDQFl6SdH6uc30DmoC96BYuLTgP6Eec7lYr26xMQKg5WOuwOY2vm/5qPrr7gFc
         p9DQkqbcSBIzVTMY9gPt67174kQas7lOtOmX3nqpXG0HjLmc5ajW+IrXGYQr6iQAzr
         sMEmODoOxSn0t2RHFpIFrzB8kiYASKpL/SSfKkawR/rzAHneJ39g6F/yxblqzua1Tk
         4SdntKzaRPEWyIgJ9XmVmUpXOTS4IWU6Wfc2vmCzkqpSdPXm7C3q35U+c5OcJXy1AQ
         vL6wiCGeRgwzA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: CT, optimize pre_ct table lookup
Date:   Sat, 12 Nov 2022 02:21:46 -0800
Message-Id: <20221112102147.496378-15-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

The pre_ct table realizes in hardware the act_ct cache logic, bypassing
the CT table if the ct state was already set by a previous ct lookup.
As such, the pre_ct table will always miss for chain 0 filters.

Optimize the pre_ct table lookup for rules installed on chain 0.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 89 ++++++++++++-------
 1 file changed, 56 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 864ce0c393e6..a69849e0deed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1774,35 +1774,42 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 
 /* We translate the tc filter with CT action to the following HW model:
  *
- * +---------------------+
- * + ft prio (tc chain)  +
- * + original match      +
- * +---------------------+
- *      | set chain miss mapping
- *      | set fte_id
- *      | set tunnel_id
- *      | do decap
- *      v
- * +---------------------+
- * + pre_ct/pre_ct_nat   +  if matches     +-------------------------+
- * + zone+nat match      +---------------->+ post_act (see below)    +
- * +---------------------+  set zone       +-------------------------+
- *      | set zone
- *      v
- * +--------------------+
- * + CT (nat or no nat) +
- * + tuple + zone match +
- * +--------------------+
- *      | set mark
- *      | set labels_id
- *      | set established
- *	| set zone_restore
- *      | do nat (if needed)
- *      v
- * +--------------+
- * + post_act     + original filter actions
- * + fte_id match +------------------------>
- * +--------------+
+ *	+---------------------+
+ *	+ ft prio (tc chain)  +
+ *	+ original match      +
+ *	+---------------------+
+ *		 | set chain miss mapping
+ *		 | set fte_id
+ *		 | set tunnel_id
+ *		 | do decap
+ *		 |
+ * +-------------+
+ * | Chain 0	 |
+ * | optimization|
+ * |		 v
+ * |	+---------------------+
+ * |	+ pre_ct/pre_ct_nat   +  if matches     +----------------------+
+ * |	+ zone+nat match      +---------------->+ post_act (see below) +
+ * |	+---------------------+  set zone       +----------------------+
+ * |		 |
+ * +-------------+ set zone
+ *		 |
+ *		 v
+ *	+--------------------+
+ *	+ CT (nat or no nat) +
+ *	+ tuple + zone match +
+ *	+--------------------+
+ *		 | set mark
+ *		 | set labels_id
+ *		 | set established
+ *		 | set zone_restore
+ *		 | do nat (if needed)
+ *		 v
+ *	+--------------+
+ *	+ post_act     + original filter actions
+ *	+ fte_id match +------------------------>
+ *	+--------------+
+ *
  */
 static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
@@ -1818,6 +1825,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_flow *ct_flow;
 	int chain_mapping = 0, err;
 	struct mlx5_ct_ft *ft;
+	u16 zone;
 
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
 	if (!ct_flow) {
@@ -1884,6 +1892,25 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 		}
 	}
 
+	/* Change original rule point to ct table
+	 * Chain 0 sets the zone and jumps to ct table
+	 * Other chains jump to pre_ct table to align with act_ct cached logic
+	 */
+	pre_ct_attr->dest_chain = 0;
+	if (!attr->chain) {
+		zone = ft->zone & MLX5_CT_ZONE_MASK;
+		err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
+						ZONE_TO_REG, zone);
+		if (err) {
+			ct_dbg("Failed to set zone register mapping");
+			goto err_mapping;
+		}
+
+		pre_ct_attr->dest_ft = nat ? ct_priv->ct_nat : ct_priv->ct;
+	} else {
+		pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.ft : ft->pre_ct.ft;
+	}
+
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
 					   pre_mod_acts->num_actions,
 					   pre_mod_acts->actions);
@@ -1893,10 +1920,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 		goto err_mapping;
 	}
 	pre_ct_attr->modify_hdr = mod_hdr;
-
-	/* Change original rule point to ct table */
-	pre_ct_attr->dest_chain = 0;
-	pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.ft : ft->pre_ct.ft;
 	ct_flow->pre_ct_rule = mlx5_tc_rule_insert(priv, orig_spec,
 						   pre_ct_attr);
 	if (IS_ERR(ct_flow->pre_ct_rule)) {
-- 
2.38.1


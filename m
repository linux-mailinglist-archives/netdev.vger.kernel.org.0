Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4B5305E68
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhA0Oel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:34:41 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46342 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234270AbhA0Odm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:33:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@nvidia.com)
        with SMTP; 27 Jan 2021 16:32:50 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10REWnms010762;
        Wed, 27 Jan 2021 16:32:49 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: CT: Add support for matching on ct_state reply flag
Date:   Wed, 27 Jan 2021 16:32:47 +0200
Message-Id: <1611757967-18236-4-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for matching on ct_state reply flag.

Example:
$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est+rpl \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est-rpl \
  action mirred egress redirect dev ens1f0_0

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e20c1da..68bdf5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -27,6 +27,7 @@
 #define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
 #define MLX5_CT_STATE_TRK_BIT BIT(2)
 #define MLX5_CT_STATE_NAT_BIT BIT(3)
+#define MLX5_CT_STATE_REPLY_BIT BIT(4)
 
 #define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
@@ -635,6 +636,7 @@ struct mlx5_ct_entry {
 	}
 
 	ct_state |= MLX5_CT_STATE_ESTABLISHED_BIT | MLX5_CT_STATE_TRK_BIT;
+	ct_state |= meta->ct_metadata.orig_dir ? 0 : MLX5_CT_STATE_REPLY_BIT;
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, &mod_acts,
 					     ct_state,
 					     meta->ct_metadata.mark,
@@ -1080,8 +1082,8 @@ void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_
 		     struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	bool trk, est, untrk, unest, new, rpl, unrpl;
 	struct flow_dissector_key_ct *mask, *key;
-	bool trk, est, untrk, unest, new;
 	u32 ctstate = 0, ctstate_mask = 0;
 	u16 ct_state_on, ct_state_off;
 	u16 ct_state, ct_state_mask;
@@ -1107,9 +1109,10 @@ void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_
 
 	if (ct_state_mask & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 			      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED |
-			      TCA_FLOWER_KEY_CT_FLAGS_NEW)) {
+			      TCA_FLOWER_KEY_CT_FLAGS_NEW |
+			      TCA_FLOWER_KEY_CT_FLAGS_REPLY)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "only ct_state trk, est and new are supported for offload");
+				   "only ct_state trk, est, new and rpl are supported for offload");
 		return -EOPNOTSUPP;
 	}
 
@@ -1118,13 +1121,17 @@ void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_
 	trk = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
 	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
+	rpl = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_REPLY;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
+	unrpl = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_REPLY;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
 	ctstate |= est ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
+	ctstate |= rpl ? MLX5_CT_STATE_REPLY_BIT : 0;
 	ctstate_mask |= (untrk || trk) ? MLX5_CT_STATE_TRK_BIT : 0;
 	ctstate_mask |= (unest || est) ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
+	ctstate_mask |= (unrpl || rpl) ? MLX5_CT_STATE_REPLY_BIT : 0;
 
 	if (new) {
 		NL_SET_ERR_MSG_MOD(extack,
-- 
1.8.3.1


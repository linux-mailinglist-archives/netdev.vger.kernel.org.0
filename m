Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0986353668
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhDDEUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhDDEUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26A56137B;
        Sun,  4 Apr 2021 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510007;
        bh=al5RVSzY6nwFq3eyKzIjcbrYaO6F+fJ/u4k9FJKw/94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmOTH2rkau+Z4zDTh3rHAA/TNIWCqC4HCea2SO4a7gOcZgRNDkz3XdfBKjgvRjKpA
         nfVhGl990Xpw+DsLPQo5+vBkS1jxVbnpZwLtgkFVHFB0UFcD4IU1eTEn8POKw2HTS7
         W4EtGihHrPgax6ZI9XeFg3U+aXsNZ1aFSn3uZCXJgcnMzd62dst+D0uTwyRdNMyF/x
         F+tGMIp3fhF1vjDfRD1agzikGl5QijDBy+q316ri0yCXjfOUjnqYpXPYgbcQc8akNK
         VjoEIcCJ9SOprC8TO9+0CCEOSuhSJ1dtPioPWAsMYjAuEWn/fErgZGWe3l9OsftnBe
         Yz5oVUZfwxWHQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: CT: Add support for matching on ct_state inv and rel flags
Date:   Sat,  3 Apr 2021 21:19:39 -0700
Message-Id: <20210404041954.146958-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Add support for matching on ct_state inv and rel flags.

Currently the support is only for match on -inv and -rel.
Matching on +inv and +rel will be rejected.

Example:
$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state -est-rel+trk \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est-inv \
  action mirred egress redirect dev ens1f0_0

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index df13e5094034..1c44000ad675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -29,6 +29,8 @@
 #define MLX5_CT_STATE_TRK_BIT BIT(2)
 #define MLX5_CT_STATE_NAT_BIT BIT(3)
 #define MLX5_CT_STATE_REPLY_BIT BIT(4)
+#define MLX5_CT_STATE_RELATED_BIT BIT(5)
+#define MLX5_CT_STATE_INVALID_BIT BIT(6)
 
 #define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
@@ -1207,8 +1209,8 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct mlx5_ct_attr *ct_attr,
 		     struct netlink_ext_ack *extack)
 {
+	bool trk, est, untrk, unest, new, rpl, unrpl, rel, unrel, inv, uninv;
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	bool trk, est, untrk, unest, new, rpl, unrpl;
 	struct flow_dissector_key_ct *mask, *key;
 	u32 ctstate = 0, ctstate_mask = 0;
 	u16 ct_state_on, ct_state_off;
@@ -1236,7 +1238,9 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 	if (ct_state_mask & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 			      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED |
 			      TCA_FLOWER_KEY_CT_FLAGS_NEW |
-			      TCA_FLOWER_KEY_CT_FLAGS_REPLY)) {
+			      TCA_FLOWER_KEY_CT_FLAGS_REPLY |
+			      TCA_FLOWER_KEY_CT_FLAGS_RELATED |
+			      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "only ct_state trk, est, new and rpl are supported for offload");
 		return -EOPNOTSUPP;
@@ -1248,9 +1252,13 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	rpl = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_REPLY;
+	rel = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_RELATED;
+	inv = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_INVALID;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	unrpl = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_REPLY;
+	unrel = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_RELATED;
+	uninv = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_INVALID;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
 	ctstate |= est ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
@@ -1258,6 +1266,20 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 	ctstate_mask |= (untrk || trk) ? MLX5_CT_STATE_TRK_BIT : 0;
 	ctstate_mask |= (unest || est) ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
 	ctstate_mask |= (unrpl || rpl) ? MLX5_CT_STATE_REPLY_BIT : 0;
+	ctstate_mask |= unrel ? MLX5_CT_STATE_RELATED_BIT : 0;
+	ctstate_mask |= uninv ? MLX5_CT_STATE_INVALID_BIT : 0;
+
+	if (rel) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "matching on ct_state +rel isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (inv) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "matching on ct_state +inv isn't supported");
+		return -EOPNOTSUPP;
+	}
 
 	if (new) {
 		NL_SET_ERR_MSG_MOD(extack,
-- 
2.30.2


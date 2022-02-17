Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7A4B9A3B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiBQH5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiBQH5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:57:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DA9DE94
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1EA961AA8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E62C36AE2;
        Thu, 17 Feb 2022 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084602;
        bh=q+9l0IXHmkh58YrTte7TVGgHtGa8mRPNAfWsSTMvcW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF3AZYNnl2RKZ6z9JUvQy3e5IEnhDbqbZm2Ot5KWk8RW5A9fXOLHkxcB+b5Kklo4X
         Bo6KrUSFV3YM1+HzYUk1i3UpIM4XV/GOpc1dmZj0wo6NSqA+Y/vjkeqHpFMSyistnd
         kPJBeNJThbAUIAT8Bm1QDcWy46Dn+JFAMBKcl6fGEqt77VmunQM5+St7kZwS/YRYuG
         OmUCF39JufqNts8ShPTjiHaA5ePPzzWZjIbKDaaNn6D9rII57afwFGROXEYH5jp5PB
         CF52vzIluf9G/MOceshIxleo3xeWJ/MVRFLtDz003gwz0G/oWnQbvCPBdytBCZhdH9
         FFeBNGP4pENSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: TC, Allow sample action with CT
Date:   Wed, 16 Feb 2022 23:56:32 -0800
Message-Id: <20220217075632.831542-16-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Allow sample+CT actions but still block sample+CT NAT
as it is not supported.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c    | 6 ------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c    | 8 +++++---
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 1492d3e49c59..7368f95f2310 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -14,12 +14,6 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	struct netlink_ext_ack *extack = parse_state->extack;
 
-	if (flow_flag_test(parse_state->flow, SAMPLE)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Sample action with connection tracking is not supported");
-		return false;
-	}
-
 	if (parse_state->ct && !clear_action) {
 		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index f39538e3d027..2c0196431302 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -13,10 +13,12 @@ tc_act_can_offload_sample(struct mlx5e_tc_act_parse_state *parse_state,
 			  struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
+	bool ct_nat;
 
-	if (flow_flag_test(parse_state->flow, CT)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Sample action with connection tracking is not supported");
+	ct_nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
+
+	if (flow_flag_test(parse_state->flow, CT) && ct_nat) {
+		NL_SET_ERR_MSG_MOD(extack, "Sample action with CT NAT is not supported");
 		return false;
 	}
 
-- 
2.34.1


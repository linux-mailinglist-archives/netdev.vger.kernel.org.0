Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC84C207C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbiBXANO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245199AbiBXAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9CA5F4D1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B870AB8119A
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167DEC340F3;
        Thu, 24 Feb 2022 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661544;
        bh=NZeQ+wwrCQZ8vfRNFi38OmhFvr6Kq3fkbb92bPDrZVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nX24W3NaLCS9yvB1LS2KnHGnI01IpYiGfB88FBEJSNCubzStolxHuTLpGVWZxAXpb
         07gm5/gzgbl0bXGfVUUMIAQI4acQ3KYsZq+Xq6UygiHOwx1GQvRiKxth3h+Mf87JVU
         szLElfVr8CPdWIJQOn4SShrChNpJUZGWoDSnjvC6k6M3s9w1LrK7iyhLgLPxVCEalu
         +s28Bhj0I6dWf7Ter7zSFPLw/MeLXy/gU5dKcZ0M4rlTv/cWus220lHkJ//CM8k0qe
         YdVxXx0QNkrsnNqqOtTxkaRr6Xgoyga8muaNTnANhCcW1R91XKMoAqi8ZVq5bdEIXB
         2WYJ0ewJgAXgg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 13/19] net/mlx5e: TC, Reject rules with forward and drop actions
Date:   Wed, 23 Feb 2022 16:11:17 -0800
Message-Id: <20220224001123.365265-14-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Such rules are redundant but allowed and passed to the driver.
The driver does not support offloading such rules so return an error.

Fixes: 03a9d11e6eeb ("net/mlx5e: Add TC drop and mirred/redirect action parsing for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 34700cf1285e..b27532a9301e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3204,6 +3204,12 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
-- 
2.35.1


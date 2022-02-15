Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25E4B638D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiBOGdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbiBOGdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E94AB44A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C0461521
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC82BC340F3;
        Tue, 15 Feb 2022 06:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906762;
        bh=Fhz+HG1j4Vplakv4fpgu/h/kmrOjJ1z8yq+f8xmLQM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHKuTuXMhf2ISY6fm2qDrq5t42zo2b6u22uYvXOIEJFXyZkAStFoknP9Tja/ijT6S
         ReNmguKPLpnq1ZyaM9XStQNa/luDasBgEXjY+LkFjQR6weLZBYfZ9Pj46lOPe6IAY5
         FG2J+wTOqsoIu+GwslBy3vSRTunSnTly8pC2sxZ/fzqPNpea0aiTmgDa2U9/uIbCmV
         ZX8Frd/7xeLjAJhOsSXPPoaZhKrsGWKfK4/XlgRUToDIbeu2uwqVPOQRWnFusxrmXY
         QWGwVGs8jvydf6MIZzOy9jDb4qRex5rxQFnvVxrjUGH5rL/BsXabngDaNC8WGvG1rK
         gXVQU/I9mPQPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Move repeating code that gets TC prio into a function
Date:   Mon, 14 Feb 2022 22:32:25 -0800
Message-Id: <20220215063229.737960-12-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Both mlx5e_select_queue and mlx5e_select_ptpsq contain the same logic to
get user priority of a packet, according to the current trust state
settings. This commit moves this repeating code to its own function.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 36 ++++++++-----------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index a0bed47fd392..aab2046da45b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -110,24 +110,25 @@ static int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb)
 }
 #endif
 
+static int mlx5e_get_up(struct mlx5e_priv *priv, struct sk_buff *skb)
+{
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
+		return mlx5e_get_dscp_up(priv, skb);
+#endif
+	if (skb_vlan_tag_present(skb))
+		return skb_vlan_tag_get_prio(skb);
+	return 0;
+}
+
 static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb,
 			      struct mlx5e_selq_params *selq)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	int up = 0;
+	int up;
 
-	if (selq->num_tcs <= 1)
-		goto return_txq;
+	up = selq->num_tcs > 1 ? mlx5e_get_up(priv, skb) : 0;
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
-		up = mlx5e_get_dscp_up(priv, skb);
-	else
-#endif
-		if (skb_vlan_tag_present(skb))
-			up = skb_vlan_tag_get_prio(skb);
-
-return_txq:
 	return selq->num_regular_queues + up;
 }
 
@@ -152,8 +153,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_selq_params *selq;
-	int txq_ix;
-	int up = 0;
+	int txq_ix, up;
 
 	selq = rcu_dereference_bh(priv->selq.active);
 
@@ -189,13 +189,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	if (selq->num_tcs <= 1)
 		return txq_ix;
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_DSCP)
-		up = mlx5e_get_dscp_up(priv, skb);
-	else
-#endif
-		if (skb_vlan_tag_present(skb))
-			up = skb_vlan_tag_get_prio(skb);
+	up = mlx5e_get_up(priv, skb);
 
 	/* Normalize any picked txq_ix to [0, num_channels),
 	 * So we can return a txq_ix that matches the channel and
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F3844047E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhJ2U7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhJ2U7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 265EB610EA;
        Fri, 29 Oct 2021 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541006;
        bh=cxpredUX3o/FlB0k1LvnVMY1Y1uhd446kIjaZHN2ppc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmsulJBw5w0V9FJj7KhudX95vZP+YdY19TfuNOf/G2Jg8OIuNkKjy0eyduF1JZwSx
         ly1BTcRQgsIhoxF8LCji4NnV37jihXVvz3e6zWPdcvyUG6Pam8YAHwNzs/FCe/VBJM
         ptJNLnYM4Qh5vSOIe+xY+0Es6qxqj89hKGtRVibTFxp0VXoqp7FSkEWkRqxZeI1fLK
         CqFJXHi4LS146cam3loT/o5IEZFhX+YMd/Nb66WSxjdLI2K3YEShwAHovdrW1HRIdl
         REwRoAwe+OVx6Yuyfp0BZ4bXk98tvnAt6NG5AbXQK2bbMcMi9ZaAVpV3PCWq4Wrl7G
         1sn0CKtp5Gngw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/14] net/mlx5e: Use generic name for the forwarding dev pointer
Date:   Fri, 29 Oct 2021 13:56:25 -0700
Message-Id: <20211029205632.390403-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Rename tun_dev to fwd_dev within mlx5e_tc_update_priv struct
since future implementation may introduce other device types
which the handler is forwarding to.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h     | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index eb960eba6027..de683724e184 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -612,8 +612,8 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 		return false;
 	}
 
-	/* Set tun_dev so we do dev_put() after datapath */
-	tc_priv->tun_dev = dev;
+	/* Set fwd_dev so we do dev_put() after datapath */
+	tc_priv->fwd_dev = dev;
 
 	skb->dev = dev;
 
@@ -655,8 +655,8 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
 
 static void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
 {
-	if (tc_priv->tun_dev)
-		dev_put(tc_priv->tun_dev);
+	if (tc_priv->fwd_dev)
+		dev_put(tc_priv->fwd_dev);
 }
 
 static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1a4cd882f0fb..df0f63c21e72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -56,7 +56,7 @@
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
-	struct net_device *tun_dev;
+	struct net_device *fwd_dev;
 };
 
 struct mlx5_nic_flow_attr {
-- 
2.31.1


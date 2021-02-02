Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F92630B868
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBBHIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhBBHHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:07:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E0964EE8;
        Tue,  2 Feb 2021 07:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249634;
        bh=kZbPJ6B7sPM1Z+PThnJwxki9PhKg1yLJLSxqGLaduG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWDcCl2uMZ76nIUCOFTpRNpIhX5TnNGBEAw2mUlI0spT6v7MfErSV2rsvF4HqAOzA
         ilx08vNMqwR25qnuASz7Gy6BXUgNP2rlPLFlx9ex3rbA+gf+yR1OBrZLWRyXwP46iD
         VMA18OOPBGSw0JNds1ho4eKx+Qy4QdsGZtjJkX5T+dGyvJwA8WQFCZPyRVDYN5L9uj
         cjiQaNFh1/th3KoGTZvgYxNyXDgYUxtYIHPL1QggQvJbPIdPhvcfrPOae4RuxwCXnO
         RWp2FAIXaHJ74AqFBmOpF/6dYf8bcH0KIZM5tyyS0cTRjNFU9KCl9LAhDV5zPaIqjX
         38byHKQPYoceg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/4] net/mlx5e: Release skb in case of failure in tc update skb
Date:   Mon,  1 Feb 2021 23:07:03 -0800
Message-Id: <20210202070703.617251-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202070703.617251-1-saeed@kernel.org>
References: <20210202070703.617251-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

In case of failure in tc update skb the packet is dropped
without freeing the skb.

Fixed by freeing the skb in case failure in tc update skb.

Fixes: d6d27782864f ("net/mlx5: E-Switch, Restore chain id on miss")
Fixes: c75690972228 ("net/mlx5e: Add tc chains offload support for nic flows")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7f5851c61218..ca4b55839a8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1262,8 +1262,10 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb))
+		if (!mlx5e_tc_update_skb(cqe, skb)) {
+			dev_kfree_skb_any(skb);
 			goto free_wqe;
+		}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1316,8 +1318,10 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+		dev_kfree_skb_any(skb);
 		goto free_wqe;
+	}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1371,8 +1375,10 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
+	}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1528,8 +1534,10 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb))
+		if (!mlx5e_tc_update_skb(cqe, skb)) {
+			dev_kfree_skb_any(skb);
 			goto mpwrq_cqe_out;
+		}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
-- 
2.29.2


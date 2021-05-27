Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3F3935AF
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhE0S6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236052AbhE0S6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2DCA61132;
        Thu, 27 May 2021 18:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141797;
        bh=t1Bf3tDvMMU1AYVSiyXGmWEiDHEdNN8DGK6ek+PW/20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTCVqr46ZyPUdvH3bepMfiSgwbvxSUs3oMJVtHs+I7JsZH9pw5hvQiCPiIi/qmuof
         FA+ttVJuOmQ/WDeqJPwvt/jQFMOugAIY9QLlfwmzoQOyokAurOIWuTF7BXmxaS5edf
         YBQJ/0sGJ0NkTTkbUP0O5Pd2LDB3SBbQ9YTFrc8cjXeVqEGLilmqK5+edoEWjiqMNL
         tu5crCq0RANq5EYRqCWQqJD9hVP+r9416x5rg0LbnEaYy9Zq+IJv/O/5BkuT4/GmYm
         35wXWaAegHIEQCAppve1Q176S98BV9xXzL8/EEihHcocXRO1WQgAjmLADyVSsg+uhd
         tD5Z20BYodEsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 05/15] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
Date:   Thu, 27 May 2021 11:56:14 -0700
Message-Id: <20210527185624.694304-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

rep_tc copy REG_C1 to REG_B. IPsec crypto utilizes the whole REG_B
register with BIT31 as IPsec marker. rep_tc_update_skb drops
IPsec because it thought REG_B contains bad value.

In previous patch, BIT 31 of REG_C1 is reserved for IPsec.
Skip the rep_tc_update_skb if BIT31 of REG_B is set.

Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f90894eea9e0..5346271974f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1310,7 +1310,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto free_wqe;
 	}
@@ -1367,7 +1368,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
 	}
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDA5392678
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhE0EiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhE0EiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DA4610A5;
        Thu, 27 May 2021 04:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090193;
        bh=t1Bf3tDvMMU1AYVSiyXGmWEiDHEdNN8DGK6ek+PW/20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH0xdjSh8DOzimqA3Ehs0y2Hj9XEUpEZuhb8KPcedXAz1WcwmygRf1bVG/GYuT1qV
         zXEvE7N/b3cWLQ5Uhgh5sdyot4wcu3gzY6a8oD0ekNECPn9fEiVfa8TKWzb6/cIHYK
         hxX3F2Fjdo/pV/bdaAXiTJRRvyv2K1PR67ggjgXv9JWxMWW7QV+ntx5KekOqRxbEXQ
         NodfqJpdLalKG3/tHRrMMuPMLPUmh6OpE1oIlFAdPkRgYwKXzyZ6HYmyiPuxYqgEFQ
         Qxg5dd3QG5VKTh8RITxtSZCJQf01QH+C4Ump6x8OkB3Q01sekYn0jtAFxiubEQYz/W
         uAiS06ECQ1WeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/17] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
Date:   Wed, 26 May 2021 21:35:57 -0700
Message-Id: <20210527043609.654854-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
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


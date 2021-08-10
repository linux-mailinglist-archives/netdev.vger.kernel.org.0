Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ACA3E51A8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbhHJEAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236861AbhHJD76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E40A6601FF;
        Tue, 10 Aug 2021 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567977;
        bh=44PF6o63SCsrucW40/EdEgb/r/j/twEpfG8aT4uLmRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSSNXVWzoZ39k2JaL3cED2NJhsp1ot8NAUyNwpH1kbDeHF4NFtzUPuCK3YpY8rU6P
         E/9xg44SrDJnwsJLs1+tuT0y2FdbeXGOpzW5o+IpbisiHYlJy9VYfPsPGU/PTqGCc3
         8y+xanPAe49u9kp6INrg/RNHnj2lbZFP6T++jzzoHNHn3sKZU97KAZ05w7wANxOlkT
         LwtDO9Ey9Ci8hq2QoTOrNosMZ5H/lGKu88nw7KndaOy9Ostdya+tEXw1iTOQ7GuERt
         fHGv5VrPLR4/ttlTVW0HKwU/Nd8+4eYcEKRPR1iRLIZuFdhsfK9JsoNsaJc2fSKUBL
         wFhnU4TGrDN5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/12] net/mlx5: DR, Add fail on error check on decap
Date:   Mon,  9 Aug 2021 20:59:13 -0700
Message-Id: <20210810035923.345745-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

While processing encapsulated packet on RX, one of the fields that is
checked is the inner packet length. If the length as specified in the header
doesn't match the actual inner packet length, the packet is invalid
and should be dropped. However, such packet caused the NIC to hang.

This patch turns on a 'fail_on_error' HW bit which allows HW to drop
such an invalid packet while processing RX packet and trying to decap it.

Fixes: ad17dc8cf910 ("net/mlx5: DR, Move STEv0 action apply logic")
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index f1950e4968da..e4dd4eed5aee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -352,6 +352,7 @@ static void dr_ste_v0_set_rx_decap(u8 *hw_ste_p)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_DECAP);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, fail_on_error, 1);
 }
 
 static void dr_ste_v0_set_rx_pop_vlan(u8 *hw_ste_p)
@@ -365,6 +366,7 @@ static void dr_ste_v0_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_L3_DECAP);
 	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, fail_on_error, 1);
 }
 
 static void dr_ste_v0_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
-- 
2.31.1


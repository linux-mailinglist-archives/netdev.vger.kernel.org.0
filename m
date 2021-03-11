Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD43380B3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhCKWh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCKWhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 372AA64F93;
        Thu, 11 Mar 2021 22:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502260;
        bh=KT7CpD4zM0tl0e6SVybHbEYbQUJYmXbhF6dTZXXW5KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH3IgRt6qS3boVzekbQi2vBZze/wCy9H0SBBAHiFKwFt4G4+FF0LN11do1Jekus+t
         CybQnS90M1xyY4XIpEwEVkAY0JvA4iual16ZGr611S9VmjdPUrav2tntY8aoS8HBze
         RCk3zvdpemnuAHYsPp/5eGloG5ciQwfT/BZtz/fdVSvrB4yqiU5e6wMSHwtoFxGTFe
         iYSR/lOfPP3dM88VPqDG8uDVUeCCH3fKbW/Uj0tshKlJfzicZ5M8IZksu7wOWeDhmk
         /Lwcv10EZfF1B9MxV40KVIBLjWqKEXagIXmL3Zbq/ykeiGgw50xC0IqGz3ZAZgOfuy
         Xg4LxG9cWtsog==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: rep: Improve reg_cX conditions
Date:   Thu, 11 Mar 2021 14:37:21 -0800
Message-Id: <20210311223723.361301-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

There is no point of calculating reg_c1 or overriding reg_c0 if we are
going to abort the function.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 065126370acd..fcae3c0a4e9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -621,11 +621,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
-	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
-		reg_c0 = 0;
-	reg_c1 = be32_to_cpu(cqe->ft_metadata);
-
-	if (!reg_c0)
+	if (!reg_c0 || reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
 		return true;
 
 	/* If reg_c0 is not equal to the default flow tag then skb->mark
@@ -633,6 +629,8 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	 */
 	skb->mark = 0;
 
+	reg_c1 = be32_to_cpu(cqe->ft_metadata);
+
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 
-- 
2.29.2


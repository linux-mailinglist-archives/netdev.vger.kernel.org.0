Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8F336CEF
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCKHKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhCKHJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B460D65032;
        Thu, 11 Mar 2021 07:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446582;
        bh=WFMa45+CEoXb8OrdiWLoLrgsh5hgseRb4L9n2C6ykAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3BnXnWliYx0a++tqfbk09liryeOEfbzjs3E+ejR9ISSLs0t8f8O5vNezgdwNH1dr
         Z2Ph1Ncm2N8KrRuYn8+t6NyfQzeGCqhfpRQ3z1fqTIvNo2EUXfe9LdzHJ3uP/o5wxV
         PFndGUC9GZfIzycOa0bTnyaSOmSP9pFzPNgycOH2R47hBQlpS/WssNbRVMhEw//I+O
         CV70aPV3vj61xPTY8CY1Ar5+MK4CWXNktI3J6wlu0LftKz3NXz2PxP8PbPeOApeuRt
         ARcQRxqZlQinNQSQBBydoYSsd25XvoxHlAep9yddkOytVil0MatJf/S4JeHLCns3j+
         1ysPz0L++kaag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 5/9] net/mlx5: E-Switch, Add eswitch pointer to each representor
Date:   Wed, 10 Mar 2021 23:09:11 -0800
Message-Id: <20210311070915.321814-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Store the managing E-Switch of each representor. This will be used
when a representor is created on eswitch manager 0 but the vport
belongs to eswitch manager 1.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 include/linux/mlx5/eswitch.h                               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index fd5f8b830584..f6c0e7e05ad5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3153,6 +3153,7 @@ void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
 	esw->offloads.rep_ops[rep_type] = ops;
 	mlx5_esw_for_all_reps(esw, i, rep) {
 		if (likely(mlx5_eswitch_vport_has_rep(esw, i))) {
+			rep->esw = esw;
 			rep_data = &rep->rep_data[rep_type];
 			atomic_set(&rep_data->state, REP_REGISTERED);
 		}
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 994c2c8cb4fd..72d480df2a03 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -48,6 +48,7 @@ struct mlx5_eswitch_rep {
 	/* Only IB rep is using vport_index */
 	u16		       vport_index;
 	u32		       vlan_refcount;
+	struct                 mlx5_eswitch *esw;
 };
 
 void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
-- 
2.29.2


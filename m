Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8219341E4B0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350119AbhI3XWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhI3XWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7796561A35;
        Thu, 30 Sep 2021 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044055;
        bh=qHceXo0aGV2t35YxBD7wDaNrgm4HwPXe/aVexuXlNqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t28pGnPclRjZI8xqNd+MoSvsZcqvaHoKqlBM5rL0rguYbUHpHBKWS6D3h/Z9ZH53u
         mEgp7G7g01WaytkIrUwOCe1W+gM3RAGjY5tBVEkL+BwRnDBr2pTtMSui8K2mOoQIfU
         P6QNZkPVCXVw/8rucqEpdvtHyO03KKuPx7/wqY0IKzeNNAIp1X3QaUlhzlBWKS1gdS
         cjEfIbSNYCyFvYs2GXH8FEVvAHKMcqWBjHemMjveWpFi5CEmk5q5vF0OYq7x0QsgsA
         MjSR+M+1FZxLJvtzaZokNSuwkjXqEMsuhndOTDPKfK7D+OXZYSvblaAOEy7lK+kEL/
         JScbp0UjP/BRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Align error messages for failure to obtain vport caps
Date:   Thu, 30 Sep 2021 16:20:39 -0700
Message-Id: <20210930232050.41779-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Print similar error messages when an invalid vport number is
provided during action creation and during STEv0/1 creation.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 8ca8fb804798..d09e99afc171 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1769,7 +1769,9 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 
 	vport_cap = mlx5dr_get_vport_cap(&vport_dmn->info.caps, vport);
 	if (!vport_cap) {
-		mlx5dr_dbg(dmn, "Failed to get vport %d caps\n", vport);
+		mlx5dr_err(dmn,
+			   "Failed to get vport 0x%x caps - vport is disabled or invalid\n",
+			   vport);
 		return NULL;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 9c704bce3c12..507719322af8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1670,7 +1670,7 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	if (source_gvmi_set) {
 		vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
 		if (!vport_cap) {
-			mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
+			mlx5dr_err(dmn, "Vport 0x%x is disabled or invalid\n",
 				   misc->source_port);
 			return -EINVAL;
 		}
-- 
2.31.1


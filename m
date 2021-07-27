Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52A23D83D0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhG0XVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhG0XUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E040260FC2;
        Tue, 27 Jul 2021 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428054;
        bh=37/3bzpTa9W95WTyqcx/+wdBlmK7AxMxt7U5RRb+URw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2Svpo8ySPhKeB7VJblMjBNr9wYzvVNYemSd0GvCWFuD3yEf0YWfQzH8SelTwwOpz
         NAuR1HencsWbq1Yuz6dabTEf+81YmY8VaN+1X3kkIGnCFxzjAjF1ZaYMt9pIbI1z2l
         1E97FufvJ4ExnSmo9RK0+DfpA1HNIhckLgoqfrCpvPVZpVD0Jvpiha704JiCirRMw6
         rlkpe4KnMX01X+40MGCqRibp+oi3aI/RtTwBYrPMBvIeXwwB8MTHoyWyFu9T1qwA8B
         JaClvFdl4zrcmvmiPMqLjdPXqYfubvCvJ9gcp1Kl44ljhFs0hb/ygurzu1BwtC+n5X
         5QQrFnDyDLUWg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/12] net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported
Date:   Tue, 27 Jul 2021 16:20:41 -0700
Message-Id: <20210727232050.606896-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Destination vport vhca id is valid flag is set only merged eswitch isn't supported.
Change destination vport vhca id value to be set also only when merged eswitch
is supported.

Fixes: e4ad91f23f10 ("net/mlx5e: Split offloaded eswitch TC rules for port mirroring")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7579f3402776..b0a2ca9037ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -382,10 +382,11 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 {
 	dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest[dest_idx].vport.num = esw_attr->dests[attr_idx].rep->vport;
-	dest[dest_idx].vport.vhca_id =
-		MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		dest[dest_idx].vport.vhca_id =
+			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
 		if (pkt_reformat) {
 			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-- 
2.31.1


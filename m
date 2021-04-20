Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73413650C8
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhDTDVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233717AbhDTDVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15AB261220;
        Tue, 20 Apr 2021 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888836;
        bh=dSNgguo7JWfcOXwSLISdKIdqJVwV+Qdaicl1r/WTCSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blPehkLRC+lqpYsi7ZrUeIBzWjMSJd0bCce1QoDyB7w2cM4DijdSI1MwUkVuwRQSc
         BvACPXj9RlPDrsjOe2aA7QUh7SK17JhIcuNCEewBkJzzLJGREMN8I0aT2ToElGD3WY
         G/2agIoZKlMfT3Fa11bIiLfBj+dH4Zb/CFEpUtDvjcsDAQO5c4mLEYdBYzi0DOPNUZ
         8/D6UuASCJt+6V1C4sZ0Pdasccbi5blgAyoidviIJpq+IVKEMoCx+gX78IL6f8Bgzf
         2QKR+27665N/yAWUCF5+6WtZCd/ChfdImQcKsdyKzmO9+tEkU98VLWBZ3OYktS98q4
         TU8tdAPgskqkg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: E-Switch, Improve error messages in term table creation
Date:   Mon, 19 Apr 2021 20:20:09 -0700
Message-Id: <20210420032018.58639-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add error code to the error messages and removed duplicated message:
if termination table creation failed, we already get an error message
in mlx5_eswitch_termtbl_create, so no need for the additional error print
in the calling function.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index ec679560a95d..a81ece94f599 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -83,14 +83,16 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
-		esw_warn(dev, "Failed to create termination table\n");
+		esw_warn(dev, "Failed to create termination table (error %d)\n",
+			 IS_ERR(tt->termtbl));
 		return -EOPNOTSUPP;
 	}
 
 	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
 	if (IS_ERR(tt->rule)) {
-		esw_warn(dev, "Failed to create termination table rule\n");
+		esw_warn(dev, "Failed to create termination table rule (error %d)\n",
+			 IS_ERR(tt->rule));
 		goto add_flow_err;
 	}
 	return 0;
@@ -140,10 +142,9 @@ mlx5_eswitch_termtbl_get_create(struct mlx5_eswitch *esw,
 	memcpy(&tt->flow_act, flow_act, sizeof(*flow_act));
 
 	err = mlx5_eswitch_termtbl_create(esw->dev, tt, flow_act);
-	if (err) {
-		esw_warn(esw->dev, "Failed to create termination table\n");
+	if (err)
 		goto tt_create_err;
-	}
+
 	hash_add(esw->offloads.termtbl_tbl, &tt->termtbl_hlist, hash_key);
 tt_add_ref:
 	tt->ref_count++;
@@ -282,7 +283,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
 		if (IS_ERR(tt)) {
-			esw_warn(esw->dev, "Failed to create termination table\n");
+			esw_warn(esw->dev, "Failed to get termination table (error %d)\n",
+				 IS_ERR(tt));
 			goto revert_changes;
 		}
 		attr->dests[num_vport_dests].termtbl = tt;
-- 
2.30.2


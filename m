Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136FD69FF33
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBVXDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbjBVXCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:02:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC7449895
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60D26B818CE
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CF8C433D2;
        Wed, 22 Feb 2023 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677106933;
        bh=4tBwvhio0LwAZCFApbQDxKTdHQDMTYLQ3YCp7pyWHBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9o82QQTKYT3+fpbF2HDxA2ELrSzqBmLlhiIdzkJhjUtdCvYc/mCOyhXIypHvZ10H
         4c+dwy2ip4aYwh7TjXUGmfFiyXV5BDioAWdhSoGd+q1UkfWXqtuPgyGtPbECAnZ5Y8
         rSrPeCjChEG2+iJQl8khqIZnbIr0i8BLkb1bC3l8cvShv3IYXiCpcC7P3/4+bbGeB4
         +qxys61n3erTJXggfn3es04pL99ZuOigbt71JPsNqPsQAEwjhB/o1DqSC808ZenGhW
         boXIoJlFmAjxLZpKm6bs+YIRIH0IyylN9RE9NOxXJhXN46j9c/XGnZoRJgZF8GQVdt
         O4egw6cZdrwSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next V2 4/4] net/mlx5e: Add more information to hairpin table dump
Date:   Wed, 22 Feb 2023 15:02:02 -0800
Message-Id: <20230222230202.523667-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222230202.523667-1-saeed@kernel.org>
References: <20230222230202.523667-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Print the number of hairpin queues and size as part of the hairpin table
dump.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2e6351ef4d9c..a139b5e88e2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -583,6 +583,7 @@ struct mlx5e_hairpin {
 	struct mlx5e_tir direct_tir;
 
 	int num_channels;
+	u8 log_num_packets;
 	struct mlx5e_rqt indir_rqt;
 	struct mlx5e_tir indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5_ttc_table *ttc;
@@ -929,6 +930,7 @@ mlx5e_hairpin_create(struct mlx5e_priv *priv, struct mlx5_hairpin_params *params
 	hp->func_mdev = func_mdev;
 	hp->func_priv = priv;
 	hp->num_channels = params->num_channels;
+	hp->log_num_packets = params->log_num_packets;
 
 	err = mlx5e_hairpin_create_transport(hp);
 	if (err)
@@ -1070,9 +1072,11 @@ static int debugfs_hairpin_table_dump_show(struct seq_file *file, void *priv)
 
 	mutex_lock(&tc->hairpin_tbl_lock);
 	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
-		seq_printf(file, "Hairpin peer_vhca_id %u prio %u refcnt %u\n",
+		seq_printf(file,
+			   "Hairpin peer_vhca_id %u prio %u refcnt %u num_channels %u num_packets %lu\n",
 			   hpe->peer_vhca_id, hpe->prio,
-			   refcount_read(&hpe->refcnt));
+			   refcount_read(&hpe->refcnt), hpe->hp->num_channels,
+			   BIT(hpe->hp->log_num_packets));
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	return 0;
-- 
2.39.1


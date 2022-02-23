Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCA4C0B74
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiBWFKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiBWFKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A3E60CF5;
        Tue, 22 Feb 2022 21:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11789B81E81;
        Wed, 23 Feb 2022 05:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50327C340F5;
        Wed, 23 Feb 2022 05:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593011;
        bh=q/QH9SsazgS+rTp/eGrM/twH4pN5D14hKwibEtqalEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2JOb2HEWrIWaWCzRy5izqmBctRV9iJZJ75uOsnWdMnqA7mDtZa7hXgFbhs7X02Gh
         PPSmmHN9jLbNosbYwMvtLARlkQQfeh1oCd0N27CjYjgtLdVyRzaVhx/NC7APHbH8Z/
         Lo+SHS+ejq8cCn9k/TeJFaBp57HFpoGqrJUopBDDq8sxQoub4PmUSfem8PXTGvBPRb
         W84SG3H7R2B1AtnCatfa4UUPUUdJ0QiErDBrtj7GbV3m21jb+XyT1i81X6FZxyvPAy
         ZQWzIArixQkEFa+cSgcMPMgVxu/oQ0pcDFWBlDK0wKpRydZc8D/TfPwXI5D7tErYT/
         5xXqmP5d6aB5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Sunil Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 03/17] net/mlx5: E-Switch, reserve and use same uplink metadata across ports
Date:   Tue, 22 Feb 2022 21:09:18 -0800
Message-Id: <20220223050932.244668-4-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Rani <sunrani@nvidia.com>

When in switchdev mode wire traffic will hit the FDB in one of two
scenarios.

- Shared FDB, in that case traffic from both physical ports should be
  tagged by the same metadata value so a single FDB rule could catch
  traffic from both ports.

- Two E-Switches, traffic from each physical port will hit the native
  E-Switch which means traffic from one physical port can't reach the
  E-Switch of the other one.

Looking at those two scenarios it means we can always use the same metadata
value to tag wire traffic regardless of the mode.

Reserve a single metadata value to be used to tag wire traffic.

Signed-off-by: Sunil Rani <sunrani@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 28 +++++++++++++++++--
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9a7b25692505..efaf3be73a7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2845,6 +2845,19 @@ bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	return true;
 }
 
+#define MLX5_ESW_METADATA_RSVD_UPLINK 1
+
+/* Share the same metadata for uplink's. This is fine because:
+ * (a) In shared FDB mode (LAG) both uplink's are treated the
+ *     same and tagged with the same metadata.
+ * (b) In non shared FDB mode, packets from physical port0
+ *     cannot hit eswitch of PF1 and vice versa.
+ */
+static u32 mlx5_esw_match_metadata_reserved(struct mlx5_eswitch *esw)
+{
+	return MLX5_ESW_METADATA_RSVD_UPLINK;
+}
+
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 {
 	u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
@@ -2859,8 +2872,10 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 		return 0;
 
 	/* Metadata is 4 bits of PFNUM and 12 bits of unique id */
-	/* Use only non-zero vport_id (1-4095) for all PF's */
-	id = ida_alloc_range(&esw->offloads.vport_metadata_ida, 1, vport_end_ida, GFP_KERNEL);
+	/* Use only non-zero vport_id (2-4095) for all PF's */
+	id = ida_alloc_range(&esw->offloads.vport_metadata_ida,
+			     MLX5_ESW_METADATA_RSVD_UPLINK + 1,
+			     vport_end_ida, GFP_KERNEL);
 	if (id < 0)
 		return 0;
 	id = (pf_num << ESW_VPORT_BITS) | id;
@@ -2878,7 +2893,11 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
 static int esw_offloads_vport_metadata_setup(struct mlx5_eswitch *esw,
 					     struct mlx5_vport *vport)
 {
-	vport->default_metadata = mlx5_esw_match_metadata_alloc(esw);
+	if (vport->vport == MLX5_VPORT_UPLINK)
+		vport->default_metadata = mlx5_esw_match_metadata_reserved(esw);
+	else
+		vport->default_metadata = mlx5_esw_match_metadata_alloc(esw);
+
 	vport->metadata = vport->default_metadata;
 	return vport->metadata ? 0 : -ENOSPC;
 }
@@ -2889,6 +2908,9 @@ static void esw_offloads_vport_metadata_cleanup(struct mlx5_eswitch *esw,
 	if (!vport->default_metadata)
 		return;
 
+	if (vport->vport == MLX5_VPORT_UPLINK)
+		return;
+
 	WARN_ON(vport->metadata != vport->default_metadata);
 	mlx5_esw_match_metadata_free(esw, vport->default_metadata);
 }
-- 
2.35.1


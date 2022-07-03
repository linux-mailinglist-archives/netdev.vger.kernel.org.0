Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490275649CA
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiGCUy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGCUyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA7E2649;
        Sun,  3 Jul 2022 13:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 633D2611CE;
        Sun,  3 Jul 2022 20:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D98C341CB;
        Sun,  3 Jul 2022 20:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881663;
        bh=Aq+5JO45p9+LXFjblIeo+KR/hx646BExMnXdB1Cshv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Her3AN+svKcaaMAUrQyLvuGy5nnty9d9JHSig50ST7C9+d/eU8oQFrJZDJQ9uUOF6
         kshcdllGBaoHysS6B7Y9ObIy8d9IhVlUlFFyxFuZl8sF3iFAhgQU1sbl9eJVNbyZKh
         MPb9UwtK9WtdDh+drWMBho7TmFv0cCZLExK05UJWPSp2Rp2c1kgxvGAtr0GQT2EW1E
         vpvtok2s5DCImRwCLR/opgHzIj3bIoq7UMgUGc5QDTZ+R9a+zyxjducZhx/ddT7uLC
         b/TgHAwfRPBkSaw26djnz2/J/pEVwsgbtImKAFLyvFLik2Tm6q/tjO1jIwA8UrbU5q
         dlVX0bPZmEaVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: fs, expose flow table ID to users
Date:   Sun,  3 Jul 2022 13:54:04 -0700
Message-Id: <20220703205407.110890-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Expose the flow table ID to users. This will be used by downstream
patches to allow creating steering rules that point to a flow table ID.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++++
 include/linux/mlx5/fs.h                           | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 14187e50e2f9..1da3dc7c95fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1195,6 +1195,12 @@ struct mlx5_flow_table *mlx5_create_flow_table(struct mlx5_flow_namespace *ns,
 }
 EXPORT_SYMBOL(mlx5_create_flow_table);
 
+u32 mlx5_flow_table_id(struct mlx5_flow_table *ft)
+{
+	return ft->id;
+}
+EXPORT_SYMBOL(mlx5_flow_table_id);
+
 struct mlx5_flow_table *
 mlx5_create_vport_flow_table(struct mlx5_flow_namespace *ns,
 			     struct mlx5_flow_table_attr *ft_attr, u16 vport)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index ece3e35622d7..eee07d416b56 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -315,4 +315,5 @@ struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 				  struct mlx5_pkt_reformat *reformat);
 
+u32 mlx5_flow_table_id(struct mlx5_flow_table *ft);
 #endif
-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5B46E2C48
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDNWJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDNWJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390B44227
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA88D64A72
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34414C4339B;
        Fri, 14 Apr 2023 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510185;
        bh=qu0gwzcX1yLwrZg6dPl2OQY9yUigbff2ucMhBfw4xvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVzw0LObl/dN9dCSqpoeVKRlqLKNKPtVtX+zJ+v4UeAjw6W3mOvE9dl4NIVKDJ8bg
         FghXMaNWVgND5Xb9VaZdtiV30hhqzdO2uipjXzkjbGed/ZQLG/CO5rJv9v3mGJoXKI
         4tj+pPLRewEOigepLQLt1O9PCAeXdV7PPq2NYBWdI8n3dQyZqxejFUsIPp3DeqLFcA
         i/9pIlqhEPxBwCCeFfeeyJ8msrbO7fQDUPJa2evJoQkLp7xfMYsLSlwzaNWQMTNo4O
         l+Q5r5XFvkyXJ71IYGA/g9NtuoltX/rUaHwKTgtB/V8CxlT+fY5Q8+dQ4by/4dgBjc
         BorVFIwU6Z97g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Check for modify_header_argument device capabilities
Date:   Fri, 14 Apr 2023 15:09:28 -0700
Message-Id: <20230414220939.136865-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c | 11 +++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h   |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 229f3684100c..e2cbc2b5bc27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -132,6 +132,17 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 
 	caps->isolate_vl_tc = MLX5_CAP_GEN(mdev, isolate_vl_tc_new);
 
+	caps->support_modify_argument =
+		MLX5_CAP_GEN_64(mdev, general_obj_types) &
+		MLX5_GENERAL_OBJ_TYPES_CAP_HEADER_MODIFY_ARGUMENT;
+
+	if (caps->support_modify_argument) {
+		caps->log_header_modify_argument_granularity =
+			MLX5_CAP_GEN(mdev, log_header_modify_argument_granularity);
+		caps->log_header_modify_argument_max_alloc =
+			MLX5_CAP_GEN(mdev, log_header_modify_argument_max_alloc);
+	}
+
 	/* geneve_tlv_option_0_exist is the indication of
 	 * STE support for lookup type flex_parser_ok
 	 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a1c549fed9ca..9187e9d6ea54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -896,6 +896,9 @@ struct mlx5dr_cmd_caps {
 	struct mlx5dr_vports vports;
 	bool prio_tag_required;
 	struct mlx5dr_roce_cap roce_caps;
+	u16 log_header_modify_argument_granularity;
+	u16 log_header_modify_argument_max_alloc;
+	bool support_modify_argument;
 	u8 is_ecpf:1;
 	u8 isolate_vl_tc:1;
 };
-- 
2.39.2


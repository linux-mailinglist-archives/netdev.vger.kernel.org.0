Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A715EEED3
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiI2HW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiI2HWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A9A1176E0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F275B8233F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BB0C433D6;
        Thu, 29 Sep 2022 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436163;
        bh=ZHr47/SgSxh+sSNwXbl3jMLCZK0tkcVOsUmzykG4Ags=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBc0+bTTCecC+TbRnSVUNxnoFIBYFg1RFjuKvNAWgrLaGVxEdW+F2DN5D0EdiQIFf
         IaKsLuRjLrSCQO8vqFz6m08HuKp4ZpW9BvN694H/+h/aCv+ccXqxFhiBhRc+XL73HE
         N4Yk7hsJYsXO0vDL+rJ5lyOEgbL3v9Ax2ox2t5Ds2Jer1vjo+xXeEEiebSeKrDU/E8
         KRfavqUlIHUazOP3GexEPGNgz7ufy+Rt3XxQAJQQ1U2QN89VFlbKvNuJlpHb6jXZaG
         nuxqLAp6tVhPHhfjQx5YSJElFjpCc81zs+go6AF094J3nAM9vVI22bd64K5RU21j7z
         1d0Lk543zfSwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 05/16] net/mlx5: Add MLX5_FLEXIBLE_INLEN to safely calculate cmd inlen
Date:   Thu, 29 Sep 2022 00:21:45 -0700
Message-Id: <20220929072156.93299-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Some commands use a flexible array after a common header. Add a macro to
safely calculate the total input length of the command, detecting
overflows and printing errors with specific values when such overflows
happen.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index ad61b86d5769..a806e3de7b7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -143,6 +143,36 @@ enum mlx5_semaphore_space_address {
 
 #define MLX5_DEFAULT_PROF       2
 
+static inline int mlx5_flexible_inlen(struct mlx5_core_dev *dev, size_t fixed,
+				      size_t item_size, size_t num_items,
+				      const char *func, int line)
+{
+	int inlen;
+
+	if (fixed > INT_MAX || item_size > INT_MAX || num_items > INT_MAX) {
+		mlx5_core_err(dev, "%s: %s:%d: input values too big: %zu + %zu * %zu\n",
+			      __func__, func, line, fixed, item_size, num_items);
+		return -ENOMEM;
+	}
+
+	if (check_mul_overflow((int)item_size, (int)num_items, &inlen)) {
+		mlx5_core_err(dev, "%s: %s:%d: multiplication overflow: %zu + %zu * %zu\n",
+			      __func__, func, line, fixed, item_size, num_items);
+		return -ENOMEM;
+	}
+
+	if (check_add_overflow((int)fixed, inlen, &inlen)) {
+		mlx5_core_err(dev, "%s: %s:%d: addition overflow: %zu + %zu * %zu\n",
+			      __func__, func, line, fixed, item_size, num_items);
+		return -ENOMEM;
+	}
+
+	return inlen;
+}
+
+#define MLX5_FLEXIBLE_INLEN(dev, fixed, item_size, num_items) \
+	mlx5_flexible_inlen(dev, fixed, item_size, num_items, __func__, __LINE__)
+
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
-- 
2.37.3


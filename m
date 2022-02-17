Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9864A4B9A41
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiBQH5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiBQH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D9765E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCE90B82161
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AB4C340ED;
        Thu, 17 Feb 2022 07:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084597;
        bh=AHoHimJwUZxksgHaN0cpkQVD0QDBtAWYzySli50Nio8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjdlVfWr0ftmHadUR99rnGvAkVKVq6T9yLxx7o931A5O67z02ZfA8Il2f14v0Ujbv
         hSaFPl2Xb6n7ivy2cY9Se6vo1uIPxRP+U+xxJqLNV4iB4+xyjbJVwclxBufa7lC+mQ
         qGLt+olufb61XcjkK6Lv9hUza5bqYoLKuuR9rsNDsQS5Vntrbqerbq0mYgPVwQYwPp
         emH55XZZ8zhdC6j4S/KzGKHCAvFxp0qOslzgo5z/NaXMFh1E4OAKBegW6756IRRvL6
         t0Hl1JZXxswcbKTjii3uK2GU9XlzK4nHOsPWvIoG0BeQ1ggqHZ3eGjVnZb6VSlgMFa
         Md0wN0wX5hHjQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: E-Switch, Add PTP counters for uplink representor
Date:   Wed, 16 Feb 2022 23:56:23 -0800
Message-Id: <20220217075632.831542-7-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

There is a configuration where the uplink interface is the synchronizer.
Add PTP counters for this interface for monitoring.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a3f257623af4..4459e5585075 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1094,6 +1094,7 @@ static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] = {
 	&MLX5E_STATS_GRP(ipsec_sw),
 	&MLX5E_STATS_GRP(ipsec_hw),
 #endif
+	&MLX5E_STATS_GRP(ptp),
 };
 
 static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 26e326fe503c..3e5d8c788026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2348,7 +2348,7 @@ MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
-static MLX5E_DEFINE_STATS_GRP(ptp, 0);
+MLX5E_DEFINE_STATS_GRP(ptp, 0);
 static MLX5E_DEFINE_STATS_GRP(qos, 0);
 
 /* The stats groups order is opposite to the update_stats() order calls */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2c1ed5b81be6..14eaf923e7b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -459,5 +459,6 @@ extern MLX5E_DECLARE_STATS_GRP(channels);
 extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
 extern MLX5E_DECLARE_STATS_GRP(ipsec_hw);
 extern MLX5E_DECLARE_STATS_GRP(ipsec_sw);
+extern MLX5E_DECLARE_STATS_GRP(ptp);
 
 #endif /* __MLX5_EN_STATS_H__ */
-- 
2.34.1


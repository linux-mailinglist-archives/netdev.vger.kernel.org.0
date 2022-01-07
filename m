Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D06486ED7
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiAGAag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344195AbiAGAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9E8C034000
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DB66B822D8
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79755C36AF4;
        Fri,  7 Jan 2022 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515413;
        bh=FTn/Uqly8ewd3vwG6azIb2OIjNO0m4VvFWO26mneOjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBD7RRVSZwEDrX8+XeTzae3ymVNkKnTP7MT2K9i5ndcEMs1mY+1Ig5hUIswpBQAyl
         awB2yfwMI3mPTMAd1HSHhmH+4CKjOd4jUS1Xiq14B6XPwzmwVagsNLedDXw5/YhR2H
         J16wlN7HwDLD/sR467UlINeSyixtnvMzQi3Pq9HRaJuNDFcyMLZOa8Y2cNNZhWyS+z
         VLYSI3Uz0Fa9Zt/MYv0zQQ1SdfSmqu6AcyD9ebY1SS0YfyaxTDIQ2njEWMfzuRFxT4
         TyAiH4TqyomM1Rx6E5Y/C+o8S8L66ZxJ3q78DR80dqTKFBlngYmFu7ku46Jf2kPsnX
         PgLWzpM44xiew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 07/15] net/mlx5: Update log_max_qp value to FW max capability
Date:   Thu,  6 Jan 2022 16:29:48 -0800
Message-Id: <20220107002956.74849-8-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

log_max_qp in driver's default profile #2 was set to 18, but FW actually
supports 17 at the most - a situation that led to the concerning print
when the driver is loaded:
"log_max_qp value in current profile is 18, changing to HCA capabaility
limit (17)"

The expected behavior from mlx5_profile #2 is to match the maximum FW
capability in regards to log_max_qp. Thus, log_max_qp in profile #2 is
initialized to a defined static value (0xff) - which basically means that
when loading this profile, log_max_qp value  will be what the currently
installed FW supports at most.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6b225bb5751a..2c774f367199 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -98,6 +98,8 @@ enum {
 	MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS = 0x1,
 };
 
+#define LOG_MAX_SUPPORTED_QPS 0xff
+
 static struct mlx5_profile profile[] = {
 	[0] = {
 		.mask           = 0,
@@ -109,7 +111,7 @@ static struct mlx5_profile profile[] = {
 	[2] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE |
 				  MLX5_PROF_MASK_MR_CACHE,
-		.log_max_qp	= 18,
+		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
 		.mr_cache[0]	= {
 			.size	= 500,
 			.limit	= 250
@@ -523,7 +525,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		 to_fw_pkey_sz(dev, 128));
 
 	/* Check log_max_qp from HCA caps to set in current profile */
-	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
+	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
+		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,
 			       MLX5_CAP_GEN_MAX(dev, log_max_qp));
-- 
2.33.1


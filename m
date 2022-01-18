Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DEB491A06
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245007AbiARC5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345655AbiARCs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:48:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B053FC061774;
        Mon, 17 Jan 2022 18:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E19960C96;
        Tue, 18 Jan 2022 02:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B561CC36AEF;
        Tue, 18 Jan 2022 02:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473581;
        bh=TvWm8VA0FL0gbTrcAIrjiYnHCBn+7z1eGZmV+NVBhVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR6xN0y8hKg9B1C9J3XCk3jl20H0p5N+TJ4Mu91C2Dzl0uUzEm8QRs5eWdzxhgrXJ
         HE8768UGImlhkAMyRwV0A4IRHjbC4EU9GNufGG5kwAXb0wYojpHDnFeTdmqAHfipeT
         xkgbDwpSDagzdnsXM695fgESaoiH4rSp6yJQD3UpdUst/ZGVMPUXMUgdWWrWbOOx2i
         ugafaXYLaw2/ovxKWXXNX0QJgskf3sXNe/FbBtqXvc7GZOgnckNTYsKuXdcbhK4+RL
         WcmIldUe/0xNu9XYQaZF1VpUSYWMdnq7oNEb6o3SoIVjtZSAC1ZzP+yu2F4xP8QV5u
         Yt2pzkG6/3/Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 180/188] net/mlx5: Update log_max_qp value to FW max capability
Date:   Mon, 17 Jan 2022 21:31:44 -0500
Message-Id: <20220118023152.1948105-180-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit f79a609ea6bf54ad2d2c24e4de4524288b221666 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 92b01858d7f3e..29b7297a836a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -97,6 +97,8 @@ enum {
 	MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS = 0x1,
 };
 
+#define LOG_MAX_SUPPORTED_QPS 0xff
+
 static struct mlx5_profile profile[] = {
 	[0] = {
 		.mask           = 0,
@@ -108,7 +110,7 @@ static struct mlx5_profile profile[] = {
 	[2] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE |
 				  MLX5_PROF_MASK_MR_CACHE,
-		.log_max_qp	= 18,
+		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
 		.mr_cache[0]	= {
 			.size	= 500,
 			.limit	= 250
@@ -513,7 +515,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
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
2.34.1


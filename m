Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B154917BB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiARCmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345831AbiARCcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:32:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEEDC061774;
        Mon, 17 Jan 2022 18:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA0ECB81235;
        Tue, 18 Jan 2022 02:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62211C36AEF;
        Tue, 18 Jan 2022 02:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473083;
        bh=1yXJMUXEkxTPzr5/L/0e1NWZ8NvwKPJ/QiqyCsCia7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMvQiPZami7/M15Yh6gyanOIAgYt/o4HqOhOy/xnYTUWyHJdOGw1bpaC84SEXaY9f
         erCUj3av5z9Ne+L5thvhaHGmSoh+66zZVfWzJFXrE2wovL6og6QSL18Egn1C2ip5gO
         ZxIkBGVPzVdDQohj8OjrDBKXLXLQutOdS0gDRmDCoXbSE8fi2+yFfhFZja6g7MMJVy
         Yr4sVgGBs4TVHcl1+29xJAWmezeOo0Tv1dfIFmEDJ7suQ+TsmuWKdsv+BIxUHDWKU6
         CYqBrKNgBdgN6WyxFUy472xisQwY+timzuuEPt1LeB9IR5yUZ5DajSMiXd6bi8XPGY
         JjIcPBM8XpPCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 209/217] net/mlx5: Update log_max_qp value to FW max capability
Date:   Mon, 17 Jan 2022 21:19:32 -0500
Message-Id: <20220118021940.1942199-209-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 65083496f9131..6e381111f1d2f 100644
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
@@ -507,7 +509,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF1273776
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgIVAbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgIVAbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:18 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8835023A9B;
        Tue, 22 Sep 2020 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734677;
        bh=Y2oFJpsXKuz9brmOv2nDm4K1ApXJ4gVoN8Gr0WY4Aew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve+7ZyotoNDN3fTvlA1oPhRL7Kg1dWxtgviz6CqJNj4OGGHKnsA5BXpNG2sFiZQv7
         OIWhWs6v6IlBdxsRY5VJ4YxmWzv/Fs9YFpHkjt/whX/lszn8X32zLaQkR82Uc4XWJK
         wGafA15+g9vEchw31WnaaougbcXvvtIp0cbO7Bbw=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 10/15] net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported
Date:   Mon, 21 Sep 2020 17:30:56 -0700
Message-Id: <20200922003101.529117-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The set of TLS TX global SW counters in mlx5e_tls_sw_stats_desc
is updated from all rings by using atomic ops.
This set of stats is used only in the FPGA TLS use case, not in
the Connect-X TLS one, where regular per-ring counters are used.

Do not expose them in the Connect-X use case, as this would cause
counter duplication. For example, tx_tls_drop_no_sync_data would
appear twice in the ethtool stats.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/tls_stats.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
index 01468ec27446..b949b9a7538b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -35,7 +35,6 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "accel/tls.h"
 #include "fpga/sdk.h"
 #include "en_accel/tls.h"
 
@@ -51,9 +50,14 @@ static const struct counter_desc mlx5e_tls_sw_stats_desc[] = {
 
 #define NUM_TLS_SW_COUNTERS ARRAY_SIZE(mlx5e_tls_sw_stats_desc)
 
+static bool is_tls_atomic_stats(struct mlx5e_priv *priv)
+{
+	return priv->tls && !mlx5_accel_is_ktls_device(priv->mdev);
+}
+
 int mlx5e_tls_get_count(struct mlx5e_priv *priv)
 {
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	return NUM_TLS_SW_COUNTERS;
@@ -63,7 +67,7 @@ int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data)
 {
 	unsigned int i, idx = 0;
 
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)
@@ -77,7 +81,7 @@ int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data)
 {
 	int i, idx = 0;
 
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)
-- 
2.26.2


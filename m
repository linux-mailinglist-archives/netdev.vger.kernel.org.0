Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E27A35366D
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhDDEUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhDDEUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DFD6135C;
        Sun,  4 Apr 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510009;
        bh=MxQRLmS+R7nB+i4yBvHmPGkoFLTmBpr+hBv/f6e3KpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+kEdrhfOt7/iYLzQ5/2anNjgRrBciRiigN8RurskX6aGND6hCSqUOtAzLI0yxxru
         jDPNKQrZtqnI9t/7CWWUoby9VX2cpVYVjgFGk1Y47Mt3usi5MbwRrVI1BgPNr+zDDO
         FwgObITRugbFF1LXg01Y+MYZ3I/6s4ai6QbZkdIiHRgYaAjqIOax2SCU5nMY9AfBrt
         pRkScQ1SuoS0pbANZH2YW6/UtpKANV4JQxfJCwkoaYYlpfkf1Jy+UEIHI4XaMDCPom
         ID4U+c1vUxWy+kxX25uQBp2AnBwN/sUFLf0J4DxYD7Y6I1rY0en8/MfeK5m9Nb7upg
         hTu6HjH4Y9z6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5: Do not hold mutex while reading table constants
Date:   Sat,  3 Apr 2021 21:19:44 -0700
Message-Id: <20210404041954.146958-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Table max_size, min and max rate are constants initialized while table
is created. Reading it doesn't need to hold a table mutex. Hence, read
them without holding table mutex.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 99039c47ef33..2accc0f324f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -180,16 +180,18 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 	int err = 0;
 	u32 rate;
 
-	rate = MLX5_GET(set_pp_rate_limit_context, rl_in, rate_limit);
-	mutex_lock(&table->rl_lock);
+	if (!table->max_size)
+		return -EOPNOTSUPP;
 
+	rate = MLX5_GET(set_pp_rate_limit_context, rl_in, rate_limit);
 	if (!rate || !mlx5_rl_is_in_range(dev, rate)) {
 		mlx5_core_err(dev, "Invalid rate: %u, should be %u to %u\n",
 			      rate, table->min_rate, table->max_rate);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
+	mutex_lock(&table->rl_lock);
+
 	entry = find_rl_entry(table, rl_in, uid, dedicated_entry);
 	if (!entry) {
 		mlx5_core_err(dev, "Max number of %u rates reached\n",
-- 
2.30.2


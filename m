Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2299236A00C
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhDXIDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232649AbhDXICU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC16A6157F;
        Sat, 24 Apr 2021 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251285;
        bh=BQMtCkATzxk0uw6A1/7KrrJCHQMK9wipdDV2sn6I6L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlVGGycTzKaqFlyGuq5b/2VYBqo7JsJmTFjwsLn2R37eRcHTUOckunx1mxzxdWnnQ
         tpcUJ7TeWSY5VMUB7J4Tx5FORrc08EfYTc0rPTE6otpnNX7Vf1MPXSYaUSloguTw9C
         s/GNT+qPnJYuNsxSBmyJ2/ZE6go0AoXZclCLYtJnSsaCq/d6XxfFmNG0UKj3h/ycWz
         socr7IOw9rmceyLCqIQA3JczySRxs+25ZZQK804p2sRA5Rz//V2y+hapNiML60oO6r
         tUQ4TvWbW7iu+1RJ54+Q4vQkegggykqaDWnxEloSSizEO7/R+OTIjPmJ9Bigdy9xUz
         4izbs1iJ9Oemw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/11] net/mlx5: SF, Consider own vhca events of SF devices
Date:   Sat, 24 Apr 2021 01:01:12 -0700
Message-Id: <20210424080115.97273-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210424080115.97273-1-saeed@kernel.org>
References: <20210424080115.97273-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Vhca events on eswitch manager are received for all the functions on the
NIC, including for SFs of external host PF controllers.

While SF device handler is only interested in SF devices events related
to its own PF.
Hence, validate if the function belongs to self or not.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 90b524c59f3c..6a0c6f965ad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -148,9 +148,19 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 	struct mlx5_sf_dev_table *table = container_of(nb, struct mlx5_sf_dev_table, nb);
 	const struct mlx5_vhca_state_event *event = data;
 	struct mlx5_sf_dev *sf_dev;
+	u16 max_functions;
 	u16 sf_index;
+	u16 base_id;
+
+	max_functions = mlx5_sf_max_functions(table->dev);
+	if (!max_functions)
+		return 0;
+
+	base_id = MLX5_CAP_GEN(table->dev, sf_base_id);
+	if (event->function_id < base_id || event->function_id >= (base_id + max_functions))
+		return 0;
 
-	sf_index = event->function_id - MLX5_CAP_GEN(table->dev, sf_base_id);
+	sf_index = event->function_id - base_id;
 	sf_dev = xa_load(&table->devices, sf_index);
 	switch (event->new_vhca_state) {
 	case MLX5_VHCA_STATE_ALLOCATED:
-- 
2.30.2


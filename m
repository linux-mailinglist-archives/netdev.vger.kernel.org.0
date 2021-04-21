Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC73671C2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhDURs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243465AbhDURsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C736B6144E;
        Wed, 21 Apr 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027262;
        bh=BQMtCkATzxk0uw6A1/7KrrJCHQMK9wipdDV2sn6I6L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjlcHFxMJnC+OWyOXgGZkFd9aXoOU35P+wEjJyQ6k5i4IFvbljs0TcbelkEFC06RJ
         ShiVYzuivDdkTQWvbQg/I2mgCbOnjC7mkvnYAK+VN6gcGOof3OKD6tlcUmVigOn7dT
         X67vJmIVs4w8F0v8JLmAQliW3zqgkr4hBN/vMZzH2wrw8/r1s4eLKHWqiwFs5091yz
         Pqc+CA2ApvrENJgWVDM3vSZ6zP8jf56+EGnPulXRmxLEiykE5pNWfkwRZfp1t5FPMm
         GVvmm84WniKlSmT5XGu8BvRLyqBTmJ3PgdHbu3t9h2V+xI/dLMnqLn4ioWKUaKH5GG
         UebFlfg+YDAiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/11] net/mlx5: SF, Consider own vhca events of SF devices
Date:   Wed, 21 Apr 2021 10:47:20 -0700
Message-Id: <20210421174723.159428-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
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


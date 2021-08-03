Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4B3DE45B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhHCC3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhHCC3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2459F6104F;
        Tue,  3 Aug 2021 02:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957739;
        bh=D+2aqunjycshga51BsEjuGMCfnLoEvXVhqKvrI3ALXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlpIrrbz4GpwGVlkzH3Scq9+2U2F0TUIPYOuC4iJv9+8xTOXE0J+G/9Pm/F8omuB9
         a16KWK27R6xdIeLZAom1LB8EkvF+1QfdUMUqnEIGiYRwcrXA+DijGuV1NO+xw6dDNy
         Yq4ya3l5jZyBQeGNqsoanjk5yYehM1XGWOljyucd3dpV7l6zuGHbvsPSYAHqP0j2qX
         Mux28SrogelKxuDwa8AfdJkZi/BArp1yQOoYYCXmk0gg3LDS7Se7pv+jyiMdDCbEes
         68GZIo68wQrNyDg07VPGCNHch7KLAw8PNxalCXFadvAbJpMfr656hJCB5OZQjOcRKo
         BkphpSOWpiAUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5e: Introduce mlx5e_channels API to get RQNs
Date:   Mon,  2 Aug 2021 19:28:39 -0700
Message-Id: <20210803022853.106973-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Currently, struct mlx5e_channels is defined in en.h, along with a lot of
other stuff. In the following commit mlx5e_rx_res will need to get RQNs
(RQ hardware IDs), given a pointer to mlx5e_channels and the channel
index. In order to make it possible without including the whole en.h,
this commit introduces functions that will hide the implementation
details of mlx5e_channels.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/channels.c | 46 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/channels.h | 16 +++++++
 3 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 6378dc815df7..e8522ccb3519 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -28,7 +28,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
 		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o en/tir.o \
-		en/rx_res.o
+		en/rx_res.o en/channels.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/channels.c b/drivers/net/ethernet/mellanox/mlx5/core/en/channels.c
new file mode 100644
index 000000000000..e7c14c0de0a7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/channels.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#include "channels.h"
+#include "en.h"
+#include "en/ptp.h"
+
+unsigned int mlx5e_channels_get_num(struct mlx5e_channels *chs)
+{
+	return chs->num;
+}
+
+void mlx5e_channels_get_regular_rqn(struct mlx5e_channels *chs, unsigned int ix, u32 *rqn)
+{
+	struct mlx5e_channel *c;
+
+	WARN_ON(ix >= mlx5e_channels_get_num(chs));
+	c = chs->c[ix];
+
+	*rqn = c->rq.rqn;
+}
+
+bool mlx5e_channels_get_xsk_rqn(struct mlx5e_channels *chs, unsigned int ix, u32 *rqn)
+{
+	struct mlx5e_channel *c;
+
+	WARN_ON(ix >= mlx5e_channels_get_num(chs));
+	c = chs->c[ix];
+
+	if (!test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		return false;
+
+	*rqn = c->xskrq.rqn;
+	return true;
+}
+
+bool mlx5e_channels_get_ptp_rqn(struct mlx5e_channels *chs, u32 *rqn)
+{
+	struct mlx5e_ptp *c = chs->ptp;
+
+	if (!c || !test_bit(MLX5E_PTP_STATE_RX, c->state))
+		return false;
+
+	*rqn = c->rq.rqn;
+	return true;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/channels.h b/drivers/net/ethernet/mellanox/mlx5/core/en/channels.h
new file mode 100644
index 000000000000..ca00cbc827cb
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/channels.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_CHANNELS_H__
+#define __MLX5_EN_CHANNELS_H__
+
+#include <linux/kernel.h>
+
+struct mlx5e_channels;
+
+unsigned int mlx5e_channels_get_num(struct mlx5e_channels *chs);
+void mlx5e_channels_get_regular_rqn(struct mlx5e_channels *chs, unsigned int ix, u32 *rqn);
+bool mlx5e_channels_get_xsk_rqn(struct mlx5e_channels *chs, unsigned int ix, u32 *rqn);
+bool mlx5e_channels_get_ptp_rqn(struct mlx5e_channels *chs, u32 *rqn);
+
+#endif /* __MLX5_EN_CHANNELS_H__ */
-- 
2.31.1


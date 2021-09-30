Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10641E4A7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350417AbhI3XRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350002AbhI3XQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B1B61A78;
        Thu, 30 Sep 2021 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043708;
        bh=yrWSIGoSSF2+PeYQ2L6bxSi2DMnVo1+1BwsYV14hZhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKqgVIFo0+b40ZWvCfzB9Iz5vcxNdPDoSqWpZN3JBFF5AywZpWtNMdQJr532JTBlS
         vY0/1WZJM/wiYfbM7U40s7Fn47/gUvL0Zj9NTh9YNpxrn+o+rDFlQ9p1huSAGyaKtK
         50fjLtIkR8Jrj7fbAXlRQbK8nGpxR2pzSe1IXS7AKKN3/52ry0aC6vp8ZrmAEwpTX/
         mV/mVd9Il1ZiLDTjtXouV8cNXpdYjcMMzEqFroSfgrP555oAnqaTvz+gKffXhXcwC8
         xSEdAhcHf+DB4NaHda3xEkx8aUYu7k9PaSRYetvY0Gkjy2HtF/LSOSrni4FD9O+nys
         Gm7Up+FTEzfAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/10] net/mlx5e: Mutually exclude setting of TX-port-TS and MQPRIO in channel mode
Date:   Thu, 30 Sep 2021 16:15:01 -0700
Message-Id: <20210930231501.39062-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

TX-port-TS hijacks the PTP traffic to a specific HW TX-queue. This
conflicts with MQPRIO in channel mode, which specifies explicitly which
TC accepts the packet. This patch mutually excludes the above
configuration.

Fixes: ec60c4581bd9 ("net/mlx5e: Support MQPRIO channel mode")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 306fb5d6a36d..9d451b8ee467 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2036,6 +2036,17 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	}
 
 	new_params = priv->channels.params;
+	/* Don't allow enabling TX-port-TS if MQPRIO mode channel  offload is
+	 * active, since it defines explicitly which TC accepts the packet.
+	 * This conflicts with TX-port-TS hijacking the PTP traffic to a specific
+	 * HW TX-queue.
+	 */
+	if (enable && new_params.mqprio.mode == TC_MQPRIO_MODE_CHANNEL) {
+		netdev_err(priv->netdev,
+			   "%s: MQPRIO mode channel offload is active, cannot set the TX-port-TS\n",
+			   __func__);
+		return -EINVAL;
+	}
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_TX_PORT_TS, enable);
 	/* No need to verify SQ stop room as
 	 * ptpsq.txqsq.stop_room <= generic_sq->stop_room, and both
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0390395f421f..0c5197f9cea3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2945,9 +2945,17 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 					 struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct net_device *netdev = priv->netdev;
+	struct mlx5e_ptp *ptp_channel;
 	int agg_count = 0;
 	int i;
 
+	ptp_channel = priv->channels.ptp;
+	if (ptp_channel && test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state)) {
+		netdev_err(netdev,
+			   "Cannot activate MQPRIO mode channel since it conflicts with TX port TS\n");
+		return -EINVAL;
+	}
+
 	if (mqprio->qopt.offset[0] != 0 || mqprio->qopt.num_tc < 1 ||
 	    mqprio->qopt.num_tc > MLX5E_MAX_NUM_MQPRIO_CH_TC)
 		return -EINVAL;
-- 
2.31.1


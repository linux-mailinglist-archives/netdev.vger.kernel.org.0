Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6762B33476E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhCJTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhCJTD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BBFE64FB1;
        Wed, 10 Mar 2021 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403036;
        bh=wT14TkWNyI+D1zr2XEPrcqQQppEi/muTDrRtB7IjWsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K92Cr6DR1TtOUR+/YGB0pAZngTZpdQXsjiF7ZOBqCMf2HP6URFrrG+J6/YcDO4A/Z
         yUPvrmf1k15tqP50ihycXmdvmRuLQDv/UDM+VPIcz1hfWXjboku3eylTm70zITItXf
         11lElCulLXkVYanFqV1jK4Q5QPY3cY8YJbfD6CFzOpedqo5/0+laD1HKWtN9GD3G7S
         uEnxBWIXGDPbgAVIrQV7BGf779SciEg2dufPK5tG4T5ChJJ9/AsHfTtHdaXaNtZjh8
         rXOLRVo/GrFcfqRN6dNCBXBvE33Id2YUfLkVTLdSVj9cV2rbH1YJC7xdcXfD+RV3Hz
         dJy+WUU7pLe1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/18] net/mlx5e: Revert parameters on errors when changing PTP state without reset
Date:   Wed, 10 Mar 2021 11:03:30 -0800
Message-Id: <20210310190342.238957-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Port timestamping for PTP can be enabled/disabled while the channels are
closed. In that case mlx5e_safe_switch_channels is skipped, and the
preactivate hook is called directly. However, if that hook returns an
error, the channel parameters must be reverted back to their old values.
This commit adds missing handling on this case.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index abdf721bb264..0e059d5c57ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2014,8 +2014,13 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	 */
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params = priv->channels.params;
 		priv->channels.params = new_channels.params;
 		err = mlx5e_num_channels_changed(priv);
+		if (err)
+			priv->channels.params = old_params;
 		goto out;
 	}
 
-- 
2.29.2


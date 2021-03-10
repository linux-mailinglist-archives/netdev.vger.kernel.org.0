Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D412334771
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhCJTEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhCJTDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4133964FD2;
        Wed, 10 Mar 2021 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403034;
        bh=1t0moZM3TTMU79C0k2FyFpCzeCThM9pHG54AVQfzc8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzmUrQhMwvtPqtBzz3ti0xSuCRlVWusUqaAt8cv4kLz6V4fHyI4Dk+Dx54RuRuORi
         RyZChzCiQgq4A4flaev/m/v7NqVZG8v435JXuCOc6cNgq/Z90rzDbk5jLFrjFAwQh+
         iRJNj4zIBbiimwXjXvPaMN9w0x+7pWm9agmlxnEZfW+Q8o0+RG3UHcinTmTP+dBDoG
         RJTfF6Ra0xoP4RmZ/77BUcGibkQW8ePQhNGGRWzlsJiaSFZz9nZ0l5HK6GI9idsjJm
         utjeel2mk1a0USTn1GLPm6nM5/5hAnKLqtDcIPZ71nR/kkJ53tZhcFnWKqX6yNAad6
         8MwEp9AJrzp2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/18] net/mlx5e: Accumulate port PTP TX stats with other channels stats
Date:   Wed, 10 Mar 2021 11:03:27 -0800
Message-Id: <20210310190342.238957-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In addition to .get_ethtool_stats, add port PTP TX stats to
.ndo_get_stats64.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 831f5495ff39..9e2a30dc5e4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3811,6 +3811,15 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 		for (j = 0; j < priv->max_opened_tc; j++) {
 			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
 
+			s->tx_packets    += sq_stats->packets;
+			s->tx_bytes      += sq_stats->bytes;
+			s->tx_dropped    += sq_stats->dropped;
+		}
+	}
+	if (priv->port_ptp_opened) {
+		for (i = 0; i < priv->max_opened_tc; i++) {
+			struct mlx5e_sq_stats *sq_stats = &priv->port_ptp_stats.sq[i];
+
 			s->tx_packets    += sq_stats->packets;
 			s->tx_bytes      += sq_stats->bytes;
 			s->tx_dropped    += sq_stats->dropped;
-- 
2.29.2


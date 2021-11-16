Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F19453AE1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhKPU0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhKPU0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EC2B617E4;
        Tue, 16 Nov 2021 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094215;
        bh=C4kA3mTngcCF/BRSoBn1vrv5jVztZ9fqZ73BO8oPGRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeuNXsqKztrbN20+zGSOUdxwmLZAZT3WJAoW2y7wyqEqaHYEljTpAF0x8gE1px8p7
         kV4GPHU3HF5VSOhJt8EkO7f2EZAgdEXdit6VXSdH0JJ//Yz8EowFLj+dB2FHTDXn3g
         o9tsUvsO8fD5qfYq7Qm76PxeA0tWqFS1lUEn2uqEODXWoeKeX7IwyEkvAI6Y0fGJqo
         dsF7Rzx/uthv+af72hSwWPckUSN1ikVjPAhr6Jd3ZYVNMdCYdmcD4faboq2ptqVGqW
         /fDhEWR46G0hq1PuDbKHrhBGhBj+1UFRDnzdNkNCsRhO1FffZIC2xCixLUrgqYmRCJ
         H81T53r96G2OQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/12] net/mlx5e: kTLS, Fix crash in RX resync flow
Date:   Tue, 16 Nov 2021 12:23:10 -0800
Message-Id: <20211116202321.283874-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

For the TLS RX resync flow, we maintain a list of TLS contexts
that require some attention, to communicate their resync information
to the HW.
Here we fix list corruptions, by protecting the entries against
movements coming from resync_handle_seq_match(), until their resync
handling in napi is fully completed.

Fixes: e9ce991bce5b ("net/mlx5e: kTLS, Add resiliency to RX resync failures")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 62abce008c7b..a2a9f68579dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -55,6 +55,7 @@ struct mlx5e_ktls_offload_context_rx {
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
 
 	/* resync */
+	spinlock_t lock; /* protects resync fields */
 	struct mlx5e_ktls_rx_resync_ctx resync;
 	struct list_head list;
 };
@@ -386,14 +387,18 @@ static void resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_r
 	struct mlx5e_icosq *sq;
 	bool trigger_poll;
 
-	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
-
 	sq = &c->async_icosq;
 	ktls_resync = sq->ktls_resync;
+	trigger_poll = false;
 
 	spin_lock_bh(&ktls_resync->lock);
-	list_add_tail(&priv_rx->list, &ktls_resync->list);
-	trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	spin_lock_bh(&priv_rx->lock);
+	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
+	if (list_empty(&priv_rx->list)) {
+		list_add_tail(&priv_rx->list, &ktls_resync->list);
+		trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	}
+	spin_unlock_bh(&priv_rx->lock);
 	spin_unlock_bh(&ktls_resync->lock);
 
 	if (!trigger_poll)
@@ -617,6 +622,8 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_create_key;
 
+	INIT_LIST_HEAD(&priv_rx->list);
+	spin_lock_init(&priv_rx->lock);
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 
@@ -730,10 +737,14 @@ bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 		priv_rx = list_first_entry(&local_list,
 					   struct mlx5e_ktls_offload_context_rx,
 					   list);
+		spin_lock(&priv_rx->lock);
 		cseg = post_static_params(sq, priv_rx);
-		if (IS_ERR(cseg))
+		if (IS_ERR(cseg)) {
+			spin_unlock(&priv_rx->lock);
 			break;
-		list_del(&priv_rx->list);
+		}
+		list_del_init(&priv_rx->list);
+		spin_unlock(&priv_rx->lock);
 		db_cseg = cseg;
 	}
 	if (db_cseg)
-- 
2.31.1


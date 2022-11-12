Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D96268D2
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiKLKWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiKLKWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6FD22521
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5E84B8069E
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F23C433D6;
        Sat, 12 Nov 2022 10:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248521;
        bh=Agdv16/uasl6vmSpbL1wuwA7ASRTQYHsH3BKJ7uiAIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmBzdzUU9UGzdvhnYHWdphMtEA4QSPW9HeS4Y93nk8CVnVTEvY80MrJBjIKG1aUy4
         tbP7KNnLtpYsAELCdjrpEkbIBHtY+BIyTLxkvL0TgST7g+IoKabicZzDfDo2SDEHkz
         q0kZYuQl+QL1lIDWmEN+ikZOU+wXVcq7lhFZov0ypxqpOFzyiDdkfYMJX7v8rKTtyX
         56pkbUzF4xqzKPMZltFlzGPHU9ZSPsRzJy1XylpUF1gBcHoCN18VAXZIcxvEcBXGPJ
         iBjLd4awmVb1f22kLGAvtPoErHrKubbSjtZgotPoPaycUFmWxSwJY7VnzEdKNsSAvC
         55ziJfrCx/U7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Guy Truzman <gtruzman@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Add error flow when failing update_rx
Date:   Sat, 12 Nov 2022 02:21:41 -0800
Message-Id: <20221112102147.496378-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guy Truzman <gtruzman@nvidia.com>

Up until now, return value of update_rx was ignored. Therefore, flow
continues even if it fails. Add error flow in case of update_rx fails in
mlx5e_open_locked, mlx5i_open and mlx5i_pkey_open.

Signed-off-by: Guy Truzman <gtruzman@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c | 6 +++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5df04e002589..14bd86e368d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3069,7 +3069,10 @@ int mlx5e_open_locked(struct net_device *netdev)
 	if (err)
 		goto err_clear_state_opened_flag;
 
-	priv->profile->update_rx(priv);
+	err = priv->profile->update_rx(priv);
+	if (err)
+		goto err_close_channels;
+
 	mlx5e_selq_apply(&priv->selq);
 	mlx5e_activate_priv_channels(priv);
 	mlx5e_apply_traps(priv, true);
@@ -3079,6 +3082,8 @@ int mlx5e_open_locked(struct net_device *netdev)
 	mlx5e_queue_update_stats(priv);
 	return 0;
 
+err_close_channels:
+	mlx5e_close_channels(&priv->channels);
 err_clear_state_opened_flag:
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 	mlx5e_selq_cancel(&priv->selq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 4e3a75496dd9..7c5c500fd215 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -561,12 +561,17 @@ static int mlx5i_open(struct net_device *netdev)
 	if (err)
 		goto err_remove_fs_underlay_qp;
 
-	epriv->profile->update_rx(epriv);
+	err = epriv->profile->update_rx(epriv);
+	if (err)
+		goto err_close_channels;
+
 	mlx5e_activate_priv_channels(epriv);
 
 	mutex_unlock(&epriv->state_lock);
 	return 0;
 
+err_close_channels:
+	mlx5e_close_channels(&epriv->channels);
 err_remove_fs_underlay_qp:
 	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qpn);
 err_reset_qp:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 0227a521d301..4d9c9e49645c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -221,12 +221,16 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 		mlx5_core_warn(mdev, "opening child channels failed, %d\n", err);
 		goto err_clear_state_opened_flag;
 	}
-	epriv->profile->update_rx(epriv);
+	err = epriv->profile->update_rx(epriv);
+	if (err)
+		goto err_close_channels;
 	mlx5e_activate_priv_channels(epriv);
 	mutex_unlock(&epriv->state_lock);
 
 	return 0;
 
+err_close_channels:
+	mlx5e_close_channels(&epriv->channels);
 err_clear_state_opened_flag:
 	mlx5e_destroy_tis(mdev, epriv->tisn[0][0]);
 err_remove_rx_uderlay_qp:
-- 
2.38.1


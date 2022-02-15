Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEB4B638F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiBOGcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:32:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbiBOGcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513C7AB44A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E451C614B7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EA1C34100;
        Tue, 15 Feb 2022 06:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906758;
        bh=WyX2jzd4kUHwGCo7KO8hjGIxX/gy16XdCqXR4TTRzgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuuhSeUYmYFe5O0IIp/NcaEi1EG+o1FYu6jzTz2NAP6+DusQ2ho9kbbh7YBWrOhlX
         ILHe+3QlfIh3jBb9uNsf6Nd1IbB14IvclqApJjA7/5SgC5OtOZjREYXjAZOkD0umtb
         3E/3wOMIISDtSOaYl+0R69DgMC71alhB5/HIE43o9mrw3cinzmu7KFc1HLiJt9e2bO
         jlnUfDb/UfZ7tSnJWQkPeXHXfZ7dIUpTXKdpKdqHza7u7zK2bI7UhKz7CJw4/qym79
         SnAdbDFMNgr84gL+u5febJEOtuBA3AkxEfRRi6aCHZcBE7cvQPMctCE5JRYyjff2Ea
         ZmXtNMcagefoA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Cleanup of start/stop all queues
Date:   Mon, 14 Feb 2022 22:32:18 -0800
Message-Id: <20220215063229.737960-5-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_activate_priv_channels() and mlx5e_deactivate_priv_channels()
start and stop all netdev TX queues. This commit removes the unneeded
call to netif_tx_stop_all_queues and adds explanatory comments why these
operations are needed.

netif_tx_disable() does the same thing that netif_tx_stop_all_queues(),
but taking the TX lock, thus guaranteeing that ndo_start_xmit is not
running after return. That means that the netif_tx_stop_all_queues()
call is not really necessary.

The comments are improved: the TX watchdog timeout explanation is moved
to the start stage where it really belongs (it used to be in both
places, but was lost during some old refactoring) and rephrased in more
details; the explanation for stopping all TX queues is added.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 59427c5f5622..8507ebec1266 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2716,6 +2716,11 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_qos_activate_queues(priv);
 	mlx5e_xdp_tx_enable(priv);
+
+	/* dev_watchdog() wants all TX queues to be started when the carrier is
+	 * OK, including the ones in range real_num_tx_queues..num_tx_queues-1.
+	 * Make it happy to avoid TX timeout false alarms.
+	 */
 	netif_tx_start_all_queues(priv->netdev);
 
 	if (mlx5e_is_vport_rep(priv))
@@ -2735,11 +2740,13 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 	if (mlx5e_is_vport_rep(priv))
 		mlx5e_remove_sqs_fwd_rules(priv);
 
-	/* FIXME: This is a W/A only for tx timeout watch dog false alarm when
-	 * polling for inactive tx queues.
+	/* The results of ndo_select_queue are unreliable, while netdev config
+	 * is being changed (real_num_tx_queues, num_tc). Stop all queues to
+	 * prevent ndo_start_xmit from being called, so that it can assume that
+	 * the selected queue is always valid.
 	 */
-	netif_tx_stop_all_queues(priv->netdev);
 	netif_tx_disable(priv->netdev);
+
 	mlx5e_xdp_tx_disable(priv);
 	mlx5e_deactivate_channels(&priv->channels);
 }
-- 
2.34.1


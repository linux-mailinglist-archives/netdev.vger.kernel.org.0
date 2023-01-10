Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC7663914
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjAJGLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjAJGLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA4C1D0FC
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 981F9614E9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E56C433F1;
        Tue, 10 Jan 2023 06:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331101;
        bh=MGmQOk50cvfvxhtrz0+/XiE0OT8lI3NYjsP8qmnBnis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSOBRdPBqAe2Vo1mKzHW4dWfe8+1G30U7lP1x/b2Hrv889WxB6dQbWaxcZddYdo8m
         a8Yu1NZkC6A5ccL5zn0kyJDV4pon/+iSy+xZg2kqHKRnOspQDHtJuUdHZ/ScIY6h4v
         ndUu+bIj7HpzJsMwLpnFPMNJrpgquRVgFzLBaTlRBaqU2HDnutnqXy+WmEc8H41A8a
         bAVNddQ+1XMhCvSPFR8ODK/N5KgFGJiRoxeiMqOsegve1Rxm4sJs/zzlTvNuR2izkY
         lDavBAVJaW3xEd22GEsgxhAbS/7jtJZOy8ntEsXCN4CCkIHYmk7j3KzCNHx3BmeI8J
         6w0pLSlqpLTLA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 05/16] net/mlx5e: Verify dev is present for fix features ndo
Date:   Mon,  9 Jan 2023 22:11:12 -0800
Message-Id: <20230110061123.338427-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Roy Novich <royno@nvidia.com>

The native NIC port net device instance is being used as Uplink
representor.  While changing profiles private resources are not
available, fix features ndo does not check if the netdev is present.
Add driver protection to verify private resources are ready.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..abcc614b6191 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4084,6 +4084,9 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	struct mlx5e_vlan_table *vlan;
 	struct mlx5e_params *params;
 
+	if (!netif_device_present(netdev))
+		return features;
+
 	vlan = mlx5e_fs_get_vlan(priv->fs);
 	mutex_lock(&priv->state_lock);
 	params = &priv->channels.params;
-- 
2.39.0


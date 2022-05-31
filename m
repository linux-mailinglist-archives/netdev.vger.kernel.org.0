Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D479153984F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiEaUzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245243AbiEaUzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A32E9CF77
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B86F561319
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BFAC3411C;
        Tue, 31 May 2022 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030509;
        bh=xgHC+gx3+NQDa0Kg9L4ApC/ffA0UofU+k9Y3HVSLMw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgcc6IHTBu2FFfsHSE0v+pbOcuwOJk6iZXdf7r1mZFX7EW0OlA3zcsa/JFMgRR0zC
         ujVp5BwVXdcFuu6xTz2117K4gD24lzGlHS3ClK/5jACq4lLw2eUz7tFl9C+354gx1p
         6I3i5Ow8SNxXCgwQWI+LXRpziNLo4uvz2rJEfaWUY8ftAQ8V8Cyxtkl8S3RI/ynIvV
         IzTXM5D2oVmsCDn5S1s0BuKeDGJ0xpuE+JdhkkISeoQ7zAnEHA26NHeT16DJO9j76h
         yR3Gky6K2TMUCiqy5BYGKETv3qNEnxm1MwZHvOM3hpr/7y8D30mZ/xubtthtarX2AS
         yQXica5SZ7eXw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/7] net/mlx5e: Update netdev features after changing XDP state
Date:   Tue, 31 May 2022 13:54:46 -0700
Message-Id: <20220531205447.99236-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Some features (LRO, HW GRO) conflict with XDP. If there is an attempt to
enable such features while XDP is active, they will be set to `off
[requested on]`. In order to activate these features after XDP is turned
off, the driver needs to call netdev_update_features(). This commit adds
this missing call after XDP state changes.

Fixes: cf6e34c8c22f ("net/mlx5e: Properly block LRO when XDP is enabled")
Fixes: b0617e7b3500 ("net/mlx5e: Properly block HW GRO when XDP is enabled")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 930a5402c817..087952b84ccb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4569,6 +4569,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
 unlock:
 	mutex_unlock(&priv->state_lock);
+
+	/* Need to fix some features. */
+	if (!err)
+		netdev_update_features(netdev);
+
 	return err;
 }
 
-- 
2.36.1


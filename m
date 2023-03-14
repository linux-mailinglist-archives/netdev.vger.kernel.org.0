Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD06B8AB7
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCNFnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjCNFnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B9B6544D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED103B81891
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87792C433D2;
        Tue, 14 Mar 2023 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772565;
        bh=8GZLOv0EQ0VcQt7Z9arHCARnb42F7y6PgFY2D6wsXZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qx/h1ImdiuvKTV26Sj0lBdqRuo6XfrTnEm20hDEZ2OlR4Pt9Sxp4tt6sC34eA0E7J
         oJ1e3rP+dIwbe+4Ng7KQEI1D3uOa4ZBLdfM3NMFUoQue/Jn7hVqIhgZmsytCBaNWOy
         siLz0P3Lmp47+4eVOQPJ6wZP+PbX8EAp5ywByJ2xRKZoPJ8uwSeP4B7BKa8X1/gayI
         0Xk/741grnDs98fX2hs5sAgXsg6LwEInY+2WbTh9NkEZ08cuhDd2nwvIyR+ubZA25u
         YPRtm3hsLeq1MkCyxagEQBmBfRJJeVh9rv9fRmZYSDCJDklX8OChIMVvldFZyU4/fz
         +fMp4Qs6SoRFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [net-next 02/15] net/mlx5: Stop waiting for PCI up if teardown was triggered
Date:   Mon, 13 Mar 2023 22:42:21 -0700
Message-Id: <20230314054234.267365-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@mellanox.com>

If driver teardown is called while PCI is turned off, there is a race
between health recovery and teardown. If health recovery already started
it will wait 60 sec trying to see if PCI gets back and it can recover,
but actually there is no need to wait anymore once teardown was called.

Use the MLX5_BREAK_FW_WAIT flag which is set on driver teardown to break
waiting for PCI up.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index f9438d4e43ca..016c5f99c470 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -325,6 +325,10 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 	while (sensor_pci_not_working(dev)) {
 		if (time_after(jiffies, end))
 			return -ETIMEDOUT;
+		if (test_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state)) {
+			mlx5_core_warn(dev, "device is being removed, stop waiting for PCI\n");
+			return -ENODEV;
+		}
 		msleep(100);
 	}
 	return 0;
-- 
2.39.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93EB633345
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiKVC20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKVC2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0618E1705E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65FF161541
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD30FC433D7;
        Tue, 22 Nov 2022 02:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084103;
        bh=IZecA7zQVFd5s77oAL7LRnnOMLyLHgEYFevUsMQMQeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bw/1IYIhZ0doyywUFLBpBDpCUxgQR685GHAHkeyuAZZOBCicMeqFGUrP9eT7Xcoeb
         wZbvjM0SQ06gzpYdm9H2aq7oJchWR8YyLNqgL1/x+vPCGg295oDioOPFRbYrdCnpYz
         IKxa38JkZvNohWR8Denns846/yB3c4hzAGBhyabOXWezLF+HBCULZp2BjovwxQFbAK
         BJrYyqTaXoazIkjZC0Ct3jr0b+yZgkfxbMiiWP2juBoyjGec4xpr2sEfaWN6TQ/p4i
         gtTp8Yvd27r/xU8gD4JUeOkEENonpspP0MmNqongAMmnfy4pq6ErnwE2swMl69s8+v
         ep2kffoQMrY5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 01/14] net/mlx5: Do not query pci info while pci disabled
Date:   Mon, 21 Nov 2022 18:25:46 -0800
Message-Id: <20221122022559.89459-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

The driver should not interact with PCI while PCI is disabled. Trying to
do so may result in being unable to get vital signs during PCI reset,
driver gets timed out and fails to recover.

Fixes: fad1783a6d66 ("net/mlx5: Print more info on pci error handlers")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 283c4cc28944..e58775a7d955 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1798,7 +1798,8 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
 
-	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, res, result2str(res));
 	return res;
 }
 
@@ -1837,7 +1838,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_pci_trace(dev, "Enter\n");
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Enter\n",
+		       __func__, dev->state, dev->pci_status);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
@@ -1859,7 +1861,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 
 	res = PCI_ERS_RESULT_RECOVERED;
 out:
-	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, err = %d, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, err, res, result2str(res));
 	return res;
 }
 
-- 
2.38.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E84E609A4E
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiJXGOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiJXGNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8605F9B0
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02536B80ECD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF39C433D7;
        Mon, 24 Oct 2022 06:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666592011;
        bh=VR4cjo8PYzxLQmHP5P3rcBhN9h1bGFNLccU9pIbzqrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE2mrQWFEUDGwR6lA3CvIa3yeUFuGePMn6Aj8DiM9QaLUM7l8hRna62p4x6MVI1fK
         Q1GVCa9DI4AKcoOmghIP727xE2wbJ7S3tJ0t/5MnO/F5r5zTig9uL2BWrNlSQ3qYIK
         +5NzTdMX8bTG5mwwYO4U1SEYUtv173BcX4+8LJ7jk59zoNqB7FTxQPuF0aA1tAQYT2
         SayB9s8QQRRap0HfcpepEpDTAqJAlH3beWRUlXhNQlzIkLOHhJ7wUyLDGSN1dEAG/F
         rewNNuNFYSu4iJLvvF5ROYO38heH6L6EVcBb777ARPI86NmOqf6aa9xxMU1Kbi3GVQ
         6VkrOcRPviE4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [V2 net 11/16] net/mlx5: Update fw fatal reporter state on PCI handlers successful recover
Date:   Mon, 24 Oct 2022 07:12:15 +0100
Message-Id: <20221024061220.81662-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024061220.81662-1-saeed@kernel.org>
References: <20221024061220.81662-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

Update devlink health fw fatal reporter state to "healthy" is needed by
strictly calling devlink_health_reporter_state_update() after recovery
was done by PCI error handler. This is needed when fw_fatal reporter was
triggered due to PCI error. Poll health is called and set reporter state
to error. Health recovery failed (since EEH didn't re-enable the PCI).
PCI handlers keep on recover flow and succeed later without devlink
acknowledgment. Fix this by adding devlink state update at the end of
the PCI handler recovery process.

Fixes: 6181e5cb752e ("devlink: add support for reporter recovery completion")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0b459d841c3a..283c4cc28944 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1872,6 +1872,10 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	err = mlx5_load_one(dev, false);
 
+	if (!err)
+		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
 	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
 		       !err ? "recovered" : "Failed");
 }
-- 
2.37.3


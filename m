Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1AA60E2AA
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiJZNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiJZNxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C773F6C31
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2969561EFA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A38C433B5;
        Wed, 26 Oct 2022 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792362;
        bh=VR4cjo8PYzxLQmHP5P3rcBhN9h1bGFNLccU9pIbzqrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MANkD72BSlMgNhkk8+bgZNwkoLYPqib4yAOkSj4NYQDvJDgoJbVGeCqTdfO+7KBmw
         hW8eanI7/5C/KhBmJlYJXLzHiponj1pTdzuETmNkRH+9+Io+OehAAJzwu85WvE2c2u
         A5nQBB+IhA5ovdcwADuNoY+H8gSQtZNBYM5o4YeyYLf5INnQ91KD5TjjrdxubP/vhE
         WLTcrglZx2/OyI12/FOJOznA0W2/TrLLGAZJJNAFyPssdKLEbfiZZPXSd5hjdPY/Sj
         eOih8ggn84gBE+h/dZn/GwizdWUhmK4Bn8bdvkeWvIraccHtpYjeJSTJ2Ap8btYK00
         tukOilnzGubQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [V4 net 10/15] net/mlx5: Update fw fatal reporter state on PCI handlers successful recover
Date:   Wed, 26 Oct 2022 14:51:48 +0100
Message-Id: <20221026135153.154807-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
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


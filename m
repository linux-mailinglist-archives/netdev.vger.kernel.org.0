Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13444C2074
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245194AbiBXANJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245165AbiBXAMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4AE5F4DE
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCBE0B8228E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3718CC340F3;
        Thu, 24 Feb 2022 00:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661540;
        bh=U9e7jCWAX927tzAzoTU1SUJ+qStw52GEagclpM2SylE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfvDJNZLDJJBMwXWC9i84I9otd5bKtSlKvKaNsNK6rvosfo/BZt8+a/Ac4DK3YfQX
         q0cV8G+4zv7U8N1WRTMyoJoFIyH666Am7+XAxe0Xlh47s8ZUsGzd2PH5yLFuh1Xp3f
         P7l4GLKoomqsoxHEj93j8FWM+m+jV7v+ci3szbAh+0zDKE4K3G7nN8AB4QtKRm35A8
         n6pNoo4/szgItRSxm4yQg7BKpP5HLHfLASt2qbc/K9r89SvZwuINv2RLZiCakIKqQI
         S+qnG7tlvEzIs8oT58KtCGdrqbGvGNmIAxJE93DKb6h08VSnw4ZP+TbTmPCRG8rgyE
         My/ee2tEODoFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 06/19] net/mlx5: Update log_max_qp value to be 17 at most
Date:   Wed, 23 Feb 2022 16:11:10 -0800
Message-Id: <20220224001123.365265-7-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Currently, log_max_qp value is dependent on what FW reports as its max capability.
In reality, due to a bug, some FWs report a value greater than 17, even though they
don't support log_max_qp > 17.

This FW issue led the driver to exhaust memory on startup.
Thus, log_max_qp value is set to be no more than 17 regardless
of what FW reports, as it was before the cited commit.

Fixes: f79a609ea6bf ("net/mlx5: Update log_max_qp value to FW max capability")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 13f913c13a2d..bba72b220cc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -526,7 +526,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	/* Check log_max_qp from HCA caps to set in current profile */
 	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
-		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = min_t(u8, 17, MLX5_CAP_GEN_MAX(dev, log_max_qp));
 	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3F671693
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjARIwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A905DC04
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BED02B81B9A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BEBC433EF;
        Wed, 18 Jan 2023 08:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029069;
        bh=qtSswc2uaxTuNVcL2so6pCr2nT40luVp6eTTIf3XbSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoOiOGKFtHV1s95XyGQpgBHl/6AuhH+RqEDT5x7X2hAdi16/r7uc4ztZYK05jF9V+
         HUB9iCwT1/kgDP6cR8QtJqfEFObX6xo5V31zpb7mH5vH0bDQmyYq5WIoCOOynoA1Z8
         PlDPFRUybpA+TrsKho/FeHIOkDDN3UqeaPLZ+591ws/tj2l2qVg2Bk4QA6a+MMB8H6
         3T/3azugOOX/CCNnnlmYUP7RQv3eifevROXkfE/epNQk97bH7hd9CLxOwW+f1HqiZK
         BTQrwjETtP4Y8FDzqq3NrThGrVckxAEegIePSKsQVuJ106hNBUv1cprnChDGy61wbc
         c4MJExKzVuxIA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net 01/10] net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()
Date:   Wed, 18 Jan 2023 00:04:05 -0800
Message-Id: <20230118080414.77902-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

Add missing mutex_unlock() before returning from
mlx5_fw_fatal_reporter_err_work().

Fixes: 9078e843efec ("net/mlx5: Avoid recovery in probe flows")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 96417c5feed7..879555ba847d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -677,6 +677,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
 	mutex_unlock(&dev->intf_state_mutex);
-- 
2.39.0


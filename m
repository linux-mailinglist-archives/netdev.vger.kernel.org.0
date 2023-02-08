Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B680768E50B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBHAhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBHAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68AD3D089
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 132C3B819CA
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFAEC433D2;
        Wed,  8 Feb 2023 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816640;
        bh=iASdozn/L67/QgiGFhvM/OXhEFalL0vOZ0HiMI0LE64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGf2PFmmlJe6TMhOdOrkS6ROzPBkKPS2OILQ7HsM8xKjd556up0CStDo8F1uyoaWt
         T+bKZ/1BLnb0rexCbY6w81hkVYCOObovScUk5n7uwc1BvPC6Kt/iQ4Wqx0sPMWw1+W
         6yxnDkVdeTxE+3Gy6blgUkjD9Vv5SohY0bYb+22IYuDjTLDeKFaBPdc9yE9ghoA/5I
         v8Ruxg6cE8j/qpQd45IoclSWPw1B2h2GZ/DKVe8jajHZJx2c2UF/0+AgVm8svAqjPj
         ZtEIIx1+gCMBs67bMbW/T0nJVZPfvYFuNaBvTATTG5rJZl+GZ1S3009uJkA8gOqBdd
         pgJojOtfKxAyA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [net-next 03/15] net/mlx5: fw reset: Skip device ID check if PCI link up failed
Date:   Tue,  7 Feb 2023 16:37:00 -0800
Message-Id: <20230208003712.68386-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

In case where after reset the PCI link is not ready within timeout, skip
reading device ID as if there is no PCI link up we can't have FW
response to pci config cycles either.

This also fixes err value not used and overwritten in such flow.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 1da4da564e6d..63290da84010 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -371,6 +371,7 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "PCI link not ready (0x%04x) after %llu ms\n",
 			      reg16, mlx5_tout_ms(dev, PCI_TOGGLE));
 		err = -ETIMEDOUT;
+		goto restore;
 	}
 
 	do {
-- 
2.39.1


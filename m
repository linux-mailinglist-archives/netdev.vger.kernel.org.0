Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705B647E7E2
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349916AbhLWTEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbhLWTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E34C061756
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5217061F6D
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD372C36AE9;
        Thu, 23 Dec 2021 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286289;
        bh=05kx9K7jSc6HCojxjT4pjAmVe6YMIYCxEQyAgR7RkDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPLTfdNWYSQwQyc9Gj083cSohWj4onbVYhT6oL5Sc0CSd0tYxvVyXObviI2pVia8Y
         K1OymQC/I4tud9gXPL5/HQ1q5Tv1dxLRBr6C042alsBRSA88VDyDfVfSZxEa9H3qmJ
         kGDYyPGlhZcnBzNwi1DrHzehFcnckkHHQpXIqAdDowcUQF4EMihd3d5ILmLwwuDah1
         /dau0yMpkocZrMvvSjRRSmFyve4YlyERRVHW4oCXPO4MIFCRaJnJw9bh5WJfdIT4xB
         yFvKds+lQ8hRHX2aeEw4dWyjXN5YiUs91BtLwaKgzj0xyK9w5j25JXdUMTl2FAjd28
         jr0hrIY4i2L8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 05/12] net/mlx5: Fix SF health recovery flow
Date:   Thu, 23 Dec 2021 11:04:34 -0800
Message-Id: <20211223190441.153012-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

SF do not directly control the PCI device. During recovery flow SF
should not be allowed to do pci disable or pci reset, its PF will do it.

It fixes the following kernel trace:
mlx5_core.sf mlx5_core.sf.25: mlx5_health_try_recover:387:(pid 40948): starting health recovery flow
mlx5_core 0000:03:00.0: mlx5_pci_slot_reset was called
mlx5_core 0000:03:00.0: wait vital counter value 0xab175 after 1 iterations
mlx5_core.sf mlx5_core.sf.25: firmware version: 24.32.532
mlx5_core.sf mlx5_core.sf.23: mlx5_health_try_recover:387:(pid 40946): starting health recovery flow
mlx5_core 0000:03:00.0: mlx5_pci_slot_reset was called
mlx5_core 0000:03:00.0: wait vital counter value 0xab193 after 1 iterations
mlx5_core.sf mlx5_core.sf.23: firmware version: 24.32.532
mlx5_core.sf mlx5_core.sf.25: mlx5_cmd_check:813:(pid 40948): ENABLE_HCA(0x104) op_mod(0x0) failed,
status bad resource state(0x9), syndrome (0x658908)
mlx5_core.sf mlx5_core.sf.25: mlx5_function_setup:1292:(pid 40948): enable hca failed
mlx5_core.sf mlx5_core.sf.25: mlx5_health_try_recover:389:(pid 40948): health recovery failed

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7df9c7f8d9c8..65083496f913 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1809,12 +1809,13 @@ void mlx5_disable_device(struct mlx5_core_dev *dev)
 
 int mlx5_recover_device(struct mlx5_core_dev *dev)
 {
-	int ret = -EIO;
+	if (!mlx5_core_is_sf(dev)) {
+		mlx5_pci_disable_device(dev);
+		if (mlx5_pci_slot_reset(dev->pdev) != PCI_ERS_RESULT_RECOVERED)
+			return -EIO;
+	}
 
-	mlx5_pci_disable_device(dev);
-	if (mlx5_pci_slot_reset(dev->pdev) == PCI_ERS_RESULT_RECOVERED)
-		ret = mlx5_load_one(dev);
-	return ret;
+	return mlx5_load_one(dev);
 }
 
 static struct pci_driver mlx5_core_driver = {
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81EE47D890
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbhLVVMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41280 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhLVVMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EBB161CFD
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D588C36AEB;
        Wed, 22 Dec 2021 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207527;
        bh=05kx9K7jSc6HCojxjT4pjAmVe6YMIYCxEQyAgR7RkDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR0plPibLDWbIMi+8pku4oAgWWxCjjc2tMkUPpdMKuulmEqOgg60JlLEPe1ZlM9Po
         /JiHzngMGfSINVa96b/lp35kJ3NSXbXFsg9Xg8MGdarypZOUA3cWctgfqcv0S7dQYm
         lROWX77SzL8whR0CrBzD1ewUf3ZGMq//ExqJH5PzXCQ+e0p0UZWCwqIWbNFm4Ar7bA
         GNxwhxLnNIYIeN5WoD/n/pmFyrpJpbakVoC3/LHCBPRo6ev1TabDtj28nND9J2xuVD
         fhu+8YYcH/H65ZoH6kH1GPLYSMPpbWub8uCWl4qJCYci8l9gGi+gFFZLer8Pk5vFeR
         ImSge9BaXAsAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/11] net/mlx5: Fix SF health recovery flow
Date:   Wed, 22 Dec 2021 13:11:55 -0800
Message-Id: <20211222211201.77469-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
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


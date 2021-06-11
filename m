Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF8C3A3E4D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhFKIu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:50:58 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:53848 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhFKIu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:50:56 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15B8muo1022147;
        Fri, 11 Jun 2021 01:48:57 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net 2/3] cxgb4: fix sleep in atomic when flashing PHY firmware
Date:   Fri, 11 Jun 2021 12:17:46 +0530
Message-Id: <ef7ce471759b21428ba258a0355615b73646d073.1623400558.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before writing new PHY firmware to on-chip memory, driver queries
firmware for current running PHY firmware version, which can result
in sleep waiting for reply. So, move spinlock closer to the actual
on-chip memory write operation, instead of taking it at the callers.

Fixes: 5fff701c838e ("cxgb4: always sync access when flashing PHY firmware")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 2 --
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 61ea3ec5c3fc..bc2de01d0539 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1337,9 +1337,7 @@ static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
 		return ret;
 	}
 
-	spin_lock_bh(&adap->win0_lock);
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, NULL, data, size);
-	spin_unlock_bh(&adap->win0_lock);
 	if (ret)
 		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 1f601de02e70..762113a04dde 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -4424,10 +4424,8 @@ static int adap_init0_phy(struct adapter *adap)
 
 	/* Load PHY Firmware onto adapter.
 	 */
-	spin_lock_bh(&adap->win0_lock);
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, phy_info->phy_fw_version,
 			     (u8 *)phyf->data, phyf->size);
-	spin_unlock_bh(&adap->win0_lock);
 	if (ret < 0)
 		dev_err(adap->pdev_dev, "PHY Firmware transfer error %d\n",
 			-ret);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 1293505025c1..a0555f4d76fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3820,9 +3820,11 @@ int t4_load_phy_fw(struct adapter *adap, int win,
 	/* Copy the supplied PHY Firmware image to the adapter memory location
 	 * allocated by the adapter firmware.
 	 */
+	spin_lock_bh(&adap->win0_lock);
 	ret = t4_memory_rw(adap, win, mtype, maddr,
 			   phy_fw_size, (__be32 *)phy_fw_data,
 			   T4_MEMORY_WRITE);
+	spin_unlock_bh(&adap->win0_lock);
 	if (ret)
 		return ret;
 
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708703A3E4E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhFKIvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:51:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:29900 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhFKIu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:50:59 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15B8mxQ5022150;
        Fri, 11 Jun 2021 01:49:00 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net 3/3] cxgb4: halt chip before flashing PHY firmware image
Date:   Fri, 11 Jun 2021 12:17:47 +0530
Message-Id: <fead13617a4cdcac8cc918be34d9e3a111ef625b.1623400558.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using firmware-assisted PHY firmware image write to flash,
halt the chip before beginning the flash write operation to allow
the running firmware to store the image persistently. Otherwise,
the running firmware will only store the PHY image in local on-chip
RAM, which will be lost after next reset.

Fixes: 4ee339e1e92a ("cxgb4: add support to flash PHY image")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 22 ++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index bc2de01d0539..df20485b5744 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1337,11 +1337,27 @@ static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
 		return ret;
 	}
 
+	/* We have to RESET the chip/firmware because we need the
+	 * chip in uninitialized state for loading new PHY image.
+	 * Otherwise, the running firmware will only store the PHY
+	 * image in local RAM which will be lost after next reset.
+	 */
+	ret = t4_fw_reset(adap, adap->mbox, PIORSTMODE_F | PIORST_F);
+	if (ret < 0) {
+		dev_err(adap->pdev_dev,
+			"Set FW to RESET for flashing PHY FW failed. ret: %d\n",
+			ret);
+		return ret;
+	}
+
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, NULL, data, size);
-	if (ret)
-		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
+	if (ret < 0) {
+		dev_err(adap->pdev_dev, "Failed to load PHY FW. ret: %d\n",
+			ret);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int cxgb4_ethtool_flash_fw(struct net_device *netdev,
-- 
2.27.0


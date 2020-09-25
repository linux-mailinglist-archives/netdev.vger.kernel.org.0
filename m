Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13ED277E4B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgIYDAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:00:32 -0400
Received: from mail5.windriver.com ([192.103.53.11]:46022 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgIYDAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 23:00:32 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 23:00:21 EDT
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 08P2im3i024410
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Thu, 24 Sep 2020 19:44:58 -0700
Received: from pek-lpggp6.wrs.com (128.224.153.40) by ALA-HCB.corp.ad.wrs.com
 (147.11.189.41) with Microsoft SMTP Server id 14.3.487.0; Thu, 24 Sep 2020
 19:44:20 -0700
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     <bgolaszewski@baylibre.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()"
Date:   Fri, 25 Sep 2020 10:42:47 +0800
Message-ID: <20200925024247.993-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 09ef193fef7efb0175a04634853862d717adbb95.

For C3000 family of SoCs, they have four ixgbe devices sharing a single MDIO bus.
ixgbe_mii_bus_init() returns -ENODEV for other three devices. The propagation
of the error code makes other three ixgbe devices unregistered.

Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cfc5fa1..5e5223becf86 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11031,14 +11031,10 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			IXGBE_LINK_SPEED_10GB_FULL | IXGBE_LINK_SPEED_1GB_FULL,
 			true);
 
-	err = ixgbe_mii_bus_init(hw);
-	if (err)
-		goto err_netdev;
+	ixgbe_mii_bus_init(hw);
 
 	return 0;
 
-err_netdev:
-	unregister_netdev(netdev);
 err_register:
 	ixgbe_release_hw_control(adapter);
 	ixgbe_clear_interrupt_scheme(adapter);
-- 
2.14.4


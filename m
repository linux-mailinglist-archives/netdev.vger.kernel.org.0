Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A581E2CCC5E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgLCCTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLCCTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:19:00 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        jakub.pawlak@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] iavf: fix double-release of rtnl_lock
Date:   Wed,  2 Dec 2020 18:18:06 -0800
Message-Id: <20201203021806.692194-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code does not jump to exit on an error in iavf_lan_add_device(),
so the rtnl_unlock() from the normal path will follow.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95543dfd4fe7..0a867d64d467 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1829,21 +1829,19 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		}
 	}
 
 	adapter->netdev_registered = true;
 
 	netif_tx_stop_all_queues(netdev);
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_add_device(adapter);
-		if (err) {
-			rtnl_unlock();
+		if (err)
 			dev_info(&pdev->dev, "Failed to add VF to client API service list: %d\n",
 				 err);
-		}
 	}
 	dev_info(&pdev->dev, "MAC address: %pM\n", adapter->hw.mac.addr);
 	if (netdev->features & NETIF_F_GRO)
 		dev_info(&pdev->dev, "GRO is enabled\n");
 
 	adapter->state = __IAVF_DOWN;
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	rtnl_unlock();
-- 
2.26.2


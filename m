Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDFA12DC29
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfLaW2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:28:03 -0500
Received: from mga05.intel.com ([192.55.52.43]:29322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfLaW1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403607"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:52 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Joe Perches <joe@perches.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/11] e1000e: Use netdev_info instead of pr_info for link messages
Date:   Tue, 31 Dec 2019 14:27:49 -0800
Message-Id: <20191231222750.3749984-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
References: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Replace the pr_info calls with netdev_info in all cases related to the
netdevice link state.

As a result of this patch the link messages will change as shown below.
Before:
e1000e: ens3 NIC Link is Down
e1000e: ens3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

After:
e1000e 0000:00:03.0 ens3: NIC Link is Down
e1000e 0000:00:03.0 ens3: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4c220600ea9a..8797913b2702 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4723,7 +4723,7 @@ int e1000e_close(struct net_device *netdev)
 		e1000_free_irq(adapter);
 
 		/* Link status message must follow this format */
-		pr_info("%s NIC Link is Down\n", netdev->name);
+		netdev_info(netdev, "NIC Link is Down\n");
 	}
 
 	napi_disable(&adapter->napi);
@@ -5073,12 +5073,13 @@ static void e1000_print_link_info(struct e1000_adapter *adapter)
 	u32 ctrl = er32(CTRL);
 
 	/* Link status message must follow this format for user tools */
-	pr_info("%s NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
-		adapter->netdev->name, adapter->link_speed,
-		adapter->link_duplex == FULL_DUPLEX ? "Full" : "Half",
-		(ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE) ? "Rx/Tx" :
-		(ctrl & E1000_CTRL_RFCE) ? "Rx" :
-		(ctrl & E1000_CTRL_TFCE) ? "Tx" : "None");
+	netdev_info(adapter->netdev,
+		    "NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
+		    adapter->link_speed,
+		    adapter->link_duplex == FULL_DUPLEX ? "Full" : "Half",
+		    (ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE) ? "Rx/Tx" :
+		    (ctrl & E1000_CTRL_RFCE) ? "Rx" :
+		    (ctrl & E1000_CTRL_TFCE) ? "Tx" : "None");
 }
 
 static bool e1000e_has_link(struct e1000_adapter *adapter)
@@ -5307,7 +5308,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			adapter->link_speed = 0;
 			adapter->link_duplex = 0;
 			/* Link status message must follow this format */
-			pr_info("%s NIC Link is Down\n", adapter->netdev->name);
+			netdev_info(netdev, "NIC Link is Down\n");
 			netif_carrier_off(netdev);
 			netif_stop_queue(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))
-- 
2.24.1


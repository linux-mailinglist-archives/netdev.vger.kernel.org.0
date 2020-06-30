Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97920EAE3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgF3B16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:27:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:7475 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgF3B1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:53 -0400
IronPort-SDR: JzTgAR/a2yJYZQpDIsVI7rU9cGvMbYUOuq1LzWHii0xhIqmu9mWpm64J09YzPfaHlYhBzcfNj1
 Rf30tPl02lAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134413753"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="134413753"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:51 -0700
IronPort-SDR: vYJ7RcQqcYwcPOqhsSk+AQnnQHC2Z+cqEAr24IRk+vRqQaBiIkKGeOrZ0y2kSDY3qMfF6gXRqR
 wi0vKSt1KddQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017723"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/13] igc: Refactor the igc_power_down_link()
Date:   Mon, 29 Jun 2020 18:27:46 -0700
Message-Id: <20200630012748.518705-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Currently the implementation of igc_power_down_link()
method was just calling igc_power_down_phy_copper_base()
method.
We can just call igc_power_down_phy_copper_base()
method directly.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6a11f897aa62..555c6633f1c3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -61,16 +61,6 @@ enum latency_range {
 	latency_invalid = 255
 };
 
-/**
- * igc_power_down_link - Power down the phy/serdes link
- * @adapter: address of board private structure
- */
-static void igc_power_down_link(struct igc_adapter *adapter)
-{
-	if (adapter->hw.phy.media_type == igc_media_type_copper)
-		igc_power_down_phy_copper_base(&adapter->hw);
-}
-
 void igc_reset(struct igc_adapter *adapter)
 {
 	struct net_device *dev = adapter->netdev;
@@ -106,7 +96,7 @@ void igc_reset(struct igc_adapter *adapter)
 	igc_set_eee_i225(hw, true, true, true);
 
 	if (!netif_running(adapter->netdev))
-		igc_power_down_link(adapter);
+		igc_power_down_phy_copper_base(&adapter->hw);
 
 	/* Re-enable PTP, where applicable. */
 	igc_ptp_reset(adapter);
@@ -4615,7 +4605,7 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	igc_free_irq(adapter);
 err_req_irq:
 	igc_release_hw_control(adapter);
-	igc_power_down_link(adapter);
+	igc_power_down_phy_copper_base(&adapter->hw);
 	igc_free_all_rx_resources(adapter);
 err_setup_rx:
 	igc_free_all_tx_resources(adapter);
@@ -5313,7 +5303,7 @@ static int __igc_shutdown(struct pci_dev *pdev, bool *enable_wake,
 
 	wake = wufc || adapter->en_mng_pt;
 	if (!wake)
-		igc_power_down_link(adapter);
+		igc_power_down_phy_copper_base(&adapter->hw);
 	else
 		igc_power_up_link(adapter);
 
-- 
2.26.2


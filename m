Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AEE130669
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgAEHOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:54704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAEHOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607347"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] igc: Remove no need declaration of the igc_power_down_link
Date:   Sat,  4 Jan 2020 23:14:07 -0800
Message-Id: <20200105071420.3778982-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_power_down_link function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c156cd68532b..17b83638efc9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -54,7 +54,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
 static void igc_configure(struct igc_adapter *adapter);
-static void igc_power_down_link(struct igc_adapter *adapter);
 static void igc_set_default_mac_filter(struct igc_adapter *adapter);
 static void igc_set_rx_mode(struct net_device *netdev);
 static void igc_write_itr(struct igc_q_vector *q_vector);
@@ -76,6 +75,16 @@ enum latency_range {
 	latency_invalid = 255
 };
 
+/**
+ * igc_power_down_link - Power down the phy/serdes link
+ * @adapter: address of board private structure
+ */
+static void igc_power_down_link(struct igc_adapter *adapter)
+{
+	if (adapter->hw.phy.media_type == igc_media_type_copper)
+		igc_power_down_phy_copper_base(&adapter->hw);
+}
+
 void igc_reset(struct igc_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
@@ -127,16 +136,6 @@ static void igc_power_up_link(struct igc_adapter *adapter)
 	igc_setup_link(&adapter->hw);
 }
 
-/**
- * igc_power_down_link - Power down the phy link
- * @adapter: address of board private structure
- */
-static void igc_power_down_link(struct igc_adapter *adapter)
-{
-	if (adapter->hw.phy.media_type == igc_media_type_copper)
-		igc_power_down_phy_copper_base(&adapter->hw);
-}
-
 /**
  * igc_release_hw_control - release control of the h/w to f/w
  * @adapter: address of board private structure
-- 
2.24.1


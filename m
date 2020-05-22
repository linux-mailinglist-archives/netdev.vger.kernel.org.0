Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B11DDBD0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgEVALR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:41703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbgEVALO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:14 -0400
IronPort-SDR: Xz4/stJfr4RItoTcDYfHsKJSkOCuYfNC+8MO+9NvAEcN5rR+wEEFHqkWwJMhKxlGor2uJWAEGA
 WZerzeZGSbHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:11 -0700
IronPort-SDR: sauFqQN+Lg90xdzI0vQlX0XmSukpmif9TwVM5V2PZL0Ry8wZSgmT256ilHZdZNTA4VYeoiANf5
 83vSMlADRAKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133955"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 10/15] igc: Get rid of igc_max_channels()
Date:   Thu, 21 May 2020 17:11:03 -0700
Message-Id: <20200522001108.1675149-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The local function igc_max_channels() is a pointless wrapper around
igc_get_max_rss_queues(). This patch removes it and updates the callers
accordingly. It also does some cleanup on igc_get_max_rss_queues().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 9 ++-------
 drivers/net/ethernet/intel/igc/igc_main.c    | 7 +------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 42ecb493c1a2..9081f36ee1f7 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1508,18 +1508,13 @@ static int igc_set_rxfh(struct net_device *netdev, const u32 *indir,
 	return 0;
 }
 
-static unsigned int igc_max_channels(struct igc_adapter *adapter)
-{
-	return igc_get_max_rss_queues(adapter);
-}
-
 static void igc_get_channels(struct net_device *netdev,
 			     struct ethtool_channels *ch)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
 	/* Report maximum channels */
-	ch->max_combined = igc_max_channels(adapter);
+	ch->max_combined = igc_get_max_rss_queues(adapter);
 
 	/* Report info for other vector */
 	if (adapter->flags & IGC_FLAG_HAS_MSIX) {
@@ -1546,7 +1541,7 @@ static int igc_set_channels(struct net_device *netdev,
 		return -EINVAL;
 
 	/* Verify the number of channels doesn't exceed hw limits */
-	max_combined = igc_max_channels(adapter);
+	max_combined = igc_get_max_rss_queues(adapter);
 	if (count > max_combined)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 398a9307af2b..843e8a2aaf24 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2731,12 +2731,7 @@ void igc_set_flag_queue_pairs(struct igc_adapter *adapter,
 
 unsigned int igc_get_max_rss_queues(struct igc_adapter *adapter)
 {
-	unsigned int max_rss_queues;
-
-	/* Determine the maximum number of RSS queues supported. */
-	max_rss_queues = IGC_MAX_RX_QUEUES;
-
-	return max_rss_queues;
+	return IGC_MAX_RX_QUEUES;
 }
 
 static void igc_init_queue_configuration(struct igc_adapter *adapter)
-- 
2.26.2


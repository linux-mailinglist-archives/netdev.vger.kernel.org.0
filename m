Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22271AFDD7
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDSTvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:45114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbgDSTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:34 -0400
IronPort-SDR: kz7em1yeOiaBl4mTeHc227Nxq2l/tmMCKSvIvShcUMcb/OxWmGNceA7YUPupeAS4YO9i+xAmdP
 Z3/BHTdCUm1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:33 -0700
IronPort-SDR: iLkH4uCwPuGDL3d6Y3QHKixyKstiPOxvU3G7H6PtaQgBT6oSvgCNVVnxL+ACP+lLhohPsJjRog
 q6FNVGwXhtGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034408"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/14] igc: Change igc_add_mac_filter() returning value
Date:   Sun, 19 Apr 2020 12:51:22 -0700
Message-Id: <20200419195131.1068144-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In case of success, igc_add_mac_filter() returns the index in
adapter->mac_table where the requested filter was added. This
information, however, is not used by any caller of that function.
In fact, callers have extra code just to handle this returning
index as 0 (success).

So this patch changes the function to return 0 on success instead,
and cleans up the extra code.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 2 --
 drivers/net/ethernet/intel/igc/igc_main.c    | 7 ++-----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ff2a40496e4e..c9f4552c018b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1269,7 +1269,6 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 		err = igc_add_mac_steering_filter(adapter,
 						  input->filter.dst_addr,
 						  input->action, 0);
-		err = min_t(int, err, 0);
 		if (err)
 			return err;
 	}
@@ -1279,7 +1278,6 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 						  input->filter.src_addr,
 						  input->action,
 						  IGC_MAC_STATE_SRC_ADDR);
-		err = min_t(int, err, 0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 66b3a689bb05..7c060c731a7e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2217,7 +2217,7 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE | flags;
 
 		igc_rar_set_index(adapter, i);
-		return i;
+		return 0;
 	}
 
 	return -ENOSPC;
@@ -2276,11 +2276,8 @@ static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
-	int ret;
-
-	ret = igc_add_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
 
-	return min_t(int, ret, 0);
+	return igc_add_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
 }
 
 static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
-- 
2.25.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0823F30E8CB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhBDApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:45:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234494AbhBDAn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:58 -0500
IronPort-SDR: j23RGbFCo7OSEIloqS7WcY78cBSuZf/fZ7EJ9yfYkNrQETnrTbewwTsbM+QFMYPYiQ5/tmKITu
 dOs1rN+diK3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638227"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638227"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: 8cnYR27mmjbv2j26TlxMGqeQWSlfrqeugyQMGZRCPAE55fR9ctJY10uWF/CI+mrj9oZWJFjOya
 +VdpEDTEEdvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687490"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 05/15] igc: Expose the NVM version
Date:   Wed,  3 Feb 2021 16:42:49 -0800
Message-Id: <20210204004259.3662059-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Expose the NVM map version via drvinfo in ethtool
NVM image version is reported as firmware version for i225 device
Minor typo fix - remove space

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 35baae900c1f..2d8b1716a20c 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -217,6 +217,8 @@ struct igc_adapter {
 	struct timecounter tc;
 	struct timespec64 prev_ptp_time; /* Pre-reset PTP clock */
 	ktime_t ptp_reset_start; /* Reset time in clock mono */
+
+	char fw_version[16];
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 6cc958031fce..4b7251d0c4e1 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -160,6 +160,7 @@
 #define IGC_NVM_RW_REG_START	1    /* Start operation */
 #define IGC_NVM_RW_ADDR_SHIFT	2    /* Shift to the address bits */
 #define IGC_NVM_POLL_READ	0    /* Flag for polling for read complete */
+#define IGC_NVM_DEV_STARTER	5    /* Dev_starter Version */
 
 /* NVM Word Offsets */
 #define NVM_CHECKSUM_REG		0x003F
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 29da2710b500..7dd1ca7f3ed5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -129,10 +129,22 @@ static void igc_ethtool_get_drvinfo(struct net_device *netdev,
 				    struct ethtool_drvinfo *drvinfo)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	u16 nvm_version = 0;
+
+	strscpy(drvinfo->driver, igc_driver_name, sizeof(drvinfo->driver));
+
+	/* NVM image version is reported as firmware version for i225 device */
+	hw->nvm.ops.read(hw, IGC_NVM_DEV_STARTER, 1, &nvm_version);
+
+	scnprintf(adapter->fw_version,
+		  sizeof(adapter->fw_version),
+		  "%x",
+		  nvm_version);
 
-	strlcpy(drvinfo->driver,  igc_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, adapter->fw_version,
+		sizeof(drvinfo->fw_version));
 
-	/* add fw_version here */
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
-- 
2.26.2


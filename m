Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F95571C1
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFZTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:41403 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfFZTae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762456"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/10] ixgbe: Check DDM existence in transceiver before access
Date:   Wed, 26 Jun 2019 12:30:54 -0700
Message-Id: <20190626193103.2169-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

Some transceivers may comply with SFF-8472 but not implement the Digital
Diagnostic Monitoring (DDM) interface described in it. The existence of
such area is specified by bit 6 of byte 92, set to 1 if implemented.

Currently, due to not checking this bit ixgbe fails trying to read SFP
module's eeprom with the follow message:

ethtool -m enP51p1s0f0
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it was assumed
to exist the DDM data.

This issue was noticed using a Mellanox Passive DAC PN 01FT738. The eeprom
data was confirmed by Mellanox as correct and present in other Passive
DACs in from other manufacturers.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index acba067cc15a..7c52ae8ac005 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3226,7 +3226,8 @@ static int ixgbe_get_module_info(struct net_device *dev,
 		page_swap = true;
 	}
 
-	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap) {
+	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap ||
+	    !(addr_mode & IXGBE_SFF_DDM_IMPLEMENTED)) {
 		/* We have a SFP, but it does not support SFF-8472 */
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
index 214b01085718..6544c4539c0d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
@@ -45,6 +45,7 @@
 #define IXGBE_SFF_SOFT_RS_SELECT_10G		0x8
 #define IXGBE_SFF_SOFT_RS_SELECT_1G		0x0
 #define IXGBE_SFF_ADDRESSING_MODE		0x4
+#define IXGBE_SFF_DDM_IMPLEMENTED		0x40
 #define IXGBE_SFF_QSFP_DA_ACTIVE_CABLE		0x1
 #define IXGBE_SFF_QSFP_DA_PASSIVE_CABLE		0x8
 #define IXGBE_SFF_QSFP_CONNECTOR_NOT_SEPARABLE	0x23
-- 
2.21.0


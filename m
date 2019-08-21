Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732E79855A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfHUUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:16:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:19346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfHUUQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:16:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203148179"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 13:16:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] i40e: Check if transceiver implements DDM before access
Date:   Wed, 21 Aug 2019 13:16:10 -0700
Message-Id: <20190821201623.5506-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

Similar to the ixgbe issue fixed in:
655c91414579 ("ixgbe: Check DDM existence in transceiver before access)

i40e has the same issue when reading eeprom from SFP's module that comply
with SFF-8472 but not implement the Digital Diagnostic Monitoring (DDM)
interface described in it. The existence of such area is specified by bit
6 of byte 92, set to 1 if implemented.

Without this patch, due to not checking this bit i40e fails to read SFP
module's eeprom with the follow message:

ethtool -m enP51p1s0f0
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it was assumed
to exist the DDM data.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 6 ++++++
 drivers/net/ethernet/intel/i40e/i40e_type.h    | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 01e4615b1b4b..41e1240acaea 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5137,6 +5137,12 @@ static int i40e_get_module_info(struct net_device *netdev,
 			/* Module is not SFF-8472 compliant */
 			modinfo->type = ETH_MODULE_SFF_8079;
 			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+		} else if (!(sff8472_swap & I40E_MODULE_SFF_DDM_IMPLEMENTED)) {
+			/* Module is SFF-8472 compliant but doesn't implement
+			 * Digital Diagnostic Monitoring (DDM).
+			 */
+			modinfo->type = ETH_MODULE_SFF_8079;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8472;
 			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 8f43aa47c263..2a6219d66771 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -443,6 +443,7 @@ struct i40e_nvm_access {
 #define I40E_MODULE_SFF_8472_COMP	0x5E
 #define I40E_MODULE_SFF_8472_SWAP	0x5C
 #define I40E_MODULE_SFF_ADDR_MODE	0x04
+#define I40E_MODULE_SFF_DDM_IMPLEMENTED 0x40
 #define I40E_MODULE_TYPE_QSFP_PLUS	0x0D
 #define I40E_MODULE_TYPE_QSFP28		0x11
 #define I40E_MODULE_QSFP_MAX_LEN	640
-- 
2.21.0


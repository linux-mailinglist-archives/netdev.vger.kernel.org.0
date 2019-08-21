Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8F59855B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfHUUQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:16:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:19351 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbfHUUQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:16:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203148189"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 13:16:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sylwia Wnuczko <sylwia.wnuczko@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] i40e: Add drop mode parameter to set mac config
Date:   Wed, 21 Aug 2019 13:16:13 -0700
Message-Id: <20190821201623.5506-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwia Wnuczko <sylwia.wnuczko@intel.com>

This patch adds "drop mode" parameter to set mac config AQ command.
This bit controls the behavior when a no-drop packet is blocking a TC
queue.
0 – The PF driver is notified.
1 – The blocking packet is dropped and then the PF driver is notified.

Signed-off-by: Sylwia Wnuczko <sylwia.wnuczko@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  4 ++-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h | 29 ++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 814acbe79ffd..72c04881d290 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -610,8 +610,10 @@ i40e_status i40e_init_adminq(struct i40e_hw *hw)
 
 	if (hw->aq.api_maj_ver > 1 ||
 	    (hw->aq.api_maj_ver == 1 &&
-	     hw->aq.api_min_ver >= 8))
+	     hw->aq.api_min_ver >= 8)) {
 		hw->flags |= I40E_HW_FLAG_FW_LLDP_PERSISTENT;
+		hw->flags |= I40E_HW_FLAG_DROP_MODE;
+	}
 
 	if (hw->aq.api_maj_ver > I40E_FW_API_VERSION_MAJOR) {
 		ret_code = I40E_ERR_FIRMWARE_API_VERSION;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 6536023fa074..4d966d80305f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -2051,20 +2051,21 @@ I40E_CHECK_CMD_LENGTH(i40e_aq_set_phy_config);
 struct i40e_aq_set_mac_config {
 	__le16	max_frame_size;
 	u8	params;
-#define I40E_AQ_SET_MAC_CONFIG_CRC_EN		0x04
-#define I40E_AQ_SET_MAC_CONFIG_PACING_MASK	0x78
-#define I40E_AQ_SET_MAC_CONFIG_PACING_SHIFT	3
-#define I40E_AQ_SET_MAC_CONFIG_PACING_NONE	0x0
-#define I40E_AQ_SET_MAC_CONFIG_PACING_1B_13TX	0xF
-#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_9TX	0x9
-#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_4TX	0x8
-#define I40E_AQ_SET_MAC_CONFIG_PACING_3DW_7TX	0x7
-#define I40E_AQ_SET_MAC_CONFIG_PACING_2DW_3TX	0x6
-#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_1TX	0x5
-#define I40E_AQ_SET_MAC_CONFIG_PACING_3DW_2TX	0x4
-#define I40E_AQ_SET_MAC_CONFIG_PACING_7DW_3TX	0x3
-#define I40E_AQ_SET_MAC_CONFIG_PACING_4DW_1TX	0x2
-#define I40E_AQ_SET_MAC_CONFIG_PACING_9DW_1TX	0x1
+#define I40E_AQ_SET_MAC_CONFIG_CRC_EN			0x04
+#define I40E_AQ_SET_MAC_CONFIG_PACING_MASK		0x78
+#define I40E_AQ_SET_MAC_CONFIG_PACING_SHIFT		3
+#define I40E_AQ_SET_MAC_CONFIG_PACING_NONE		0x0
+#define I40E_AQ_SET_MAC_CONFIG_PACING_1B_13TX		0xF
+#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_9TX		0x9
+#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_4TX		0x8
+#define I40E_AQ_SET_MAC_CONFIG_PACING_3DW_7TX		0x7
+#define I40E_AQ_SET_MAC_CONFIG_PACING_2DW_3TX		0x6
+#define I40E_AQ_SET_MAC_CONFIG_PACING_1DW_1TX		0x5
+#define I40E_AQ_SET_MAC_CONFIG_PACING_3DW_2TX		0x4
+#define I40E_AQ_SET_MAC_CONFIG_PACING_7DW_3TX		0x3
+#define I40E_AQ_SET_MAC_CONFIG_PACING_4DW_1TX		0x2
+#define I40E_AQ_SET_MAC_CONFIG_PACING_9DW_1TX		0x1
+#define I40E_AQ_SET_MAC_CONFIG_DROP_BLOCKING_PACKET_EN	0x80
 	u8	tx_timer_priority; /* bitmap */
 	__le16	tx_timer_value;
 	__le16	fc_refresh_threshold;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 2a6219d66771..7c1d57683b53 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -624,6 +624,7 @@ struct i40e_hw {
 #define I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK BIT_ULL(3)
 #define I40E_HW_FLAG_FW_LLDP_STOPPABLE      BIT_ULL(4)
 #define I40E_HW_FLAG_FW_LLDP_PERSISTENT     BIT_ULL(5)
+#define I40E_HW_FLAG_DROP_MODE              BIT_ULL(7)
 	u64 flags;
 
 	/* Used in set switch config AQ command */
-- 
2.21.0


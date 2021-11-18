Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7604551EE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhKRBDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:03:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:30896 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242098AbhKRBDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 20:03:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="233923247"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="233923247"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 17:00:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="646235560"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2021 17:00:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 5/5] ixgbevf: Add support for new mailbox communication between PF and VF
Date:   Wed, 17 Nov 2021 16:58:32 -0800
Message-Id: <20211118005832.245978-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
References: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Provide improved mailbox communication, between PF and VF,
which is defined as API version 1.5.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c        |  1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  9 +++++++++
 drivers/net/ethernet/intel/ixgbevf/mbx.h          |  1 +
 drivers/net/ethernet/intel/ixgbevf/vf.c           | 14 ++++++++++++--
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index d9935a42f0b7..e763cee0695e 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -623,6 +623,7 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 
 	switch (adapter->hw.api_version) {
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_15:
 		break;
 	default:
 		return;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index cd93b47a61cd..b1dfbaff8b31 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2266,6 +2266,7 @@ static void ixgbevf_negotiate_api(struct ixgbevf_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
 	static const int api[] = {
+		ixgbe_mbox_api_15,
 		ixgbe_mbox_api_14,
 		ixgbe_mbox_api_13,
 		ixgbe_mbox_api_12,
@@ -2284,6 +2285,12 @@ static void ixgbevf_negotiate_api(struct ixgbevf_adapter *adapter)
 		idx++;
 	}
 
+	if (hw->api_version >= ixgbe_mbox_api_15) {
+		hw->mbx.ops.init_params(hw);
+		memcpy(&hw->mbx.ops, &ixgbevf_mbx_ops,
+		       sizeof(struct ixgbe_mbx_operations));
+	}
+
 	spin_unlock_bh(&adapter->mbx_lock);
 }
 
@@ -2627,6 +2634,7 @@ static void ixgbevf_set_num_queues(struct ixgbevf_adapter *adapter)
 		case ixgbe_mbox_api_12:
 		case ixgbe_mbox_api_13:
 		case ixgbe_mbox_api_14:
+		case ixgbe_mbox_api_15:
 			if (adapter->xdp_prog &&
 			    hw->mac.max_tx_queues == rss)
 				rss = rss > 3 ? 2 : 1;
@@ -4625,6 +4633,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	case ixgbe_mbox_api_12:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_15:
 		netdev->max_mtu = IXGBE_MAX_JUMBO_FRAME_SIZE -
 				  (ETH_HLEN + ETH_FCS_LEN);
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.h b/drivers/net/ethernet/intel/ixgbevf/mbx.h
index b3b83c95babf..7346ccf014a5 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.h
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.h
@@ -65,6 +65,7 @@ enum ixgbe_pfvf_api_rev {
 	ixgbe_mbox_api_12,	/* API version 1.2, linux/freebsd VF driver */
 	ixgbe_mbox_api_13,	/* API version 1.3, linux/freebsd VF driver */
 	ixgbe_mbox_api_14,	/* API version 1.4, linux/freebsd VF driver */
+	ixgbe_mbox_api_15,	/* API version 1.5, linux/freebsd VF driver */
 	/* This value should always be last */
 	ixgbe_mbox_api_unknown,	/* indicates that API version is not known */
 };
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index a1672e518d97..61d8970c6d1d 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -74,6 +74,9 @@ static s32 ixgbevf_reset_hw_vf(struct ixgbe_hw *hw)
 
 	/* reset the api version */
 	hw->api_version = ixgbe_mbox_api_10;
+	hw->mbx.ops.init_params(hw);
+	memcpy(&hw->mbx.ops, &ixgbevf_mbx_ops_legacy,
+	       sizeof(struct ixgbe_mbx_operations));
 
 	IXGBE_WRITE_REG(hw, IXGBE_VFCTRL, IXGBE_CTRL_RST);
 	IXGBE_WRITE_FLUSH(hw);
@@ -310,6 +313,7 @@ int ixgbevf_get_reta_locked(struct ixgbe_hw *hw, u32 *reta, int num_rx_queues)
 	 * is not supported for this device type.
 	 */
 	switch (hw->api_version) {
+	case ixgbe_mbox_api_15:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_12:
@@ -378,6 +382,7 @@ int ixgbevf_get_rss_key_locked(struct ixgbe_hw *hw, u8 *rss_key)
 	 * or if the operation is not supported for this device type.
 	 */
 	switch (hw->api_version) {
+	case ixgbe_mbox_api_15:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_12:
@@ -544,8 +549,9 @@ static s32 ixgbevf_update_xcast_mode(struct ixgbe_hw *hw, int xcast_mode)
 		if (xcast_mode == IXGBEVF_XCAST_MODE_PROMISC)
 			return -EOPNOTSUPP;
 		fallthrough;
-	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
+	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_15:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -704,8 +710,11 @@ static s32 ixgbevf_check_mac_link_vf(struct ixgbe_hw *hw,
 	/* if the read failed it could just be a mailbox collision, best wait
 	 * until we are called again and don't report an error
 	 */
-	if (mbx->ops.read(hw, &in_msg, 1))
+	if (mbx->ops.read(hw, &in_msg, 1)) {
+		if (hw->api_version >= ixgbe_mbox_api_15)
+			mac->get_link_status = false;
 		goto out;
+	}
 
 	if (!(in_msg & IXGBE_VT_MSGTYPE_CTS)) {
 		/* msg is not CTS and is NACK we must have lost CTS status */
@@ -901,6 +910,7 @@ int ixgbevf_get_queues(struct ixgbe_hw *hw, unsigned int *num_tcs,
 	case ixgbe_mbox_api_12:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_15:
 		break;
 	default:
 		return 0;
-- 
2.31.1


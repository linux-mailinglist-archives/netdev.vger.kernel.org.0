Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC834551E9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242078AbhKRBDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:03:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:59858 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242069AbhKRBDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 20:03:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="221302864"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="221302864"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 17:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="646235524"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2021 17:00:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 1/5] ixgbevf: Rename MSGTYPE to SUCCESS and FAILURE
Date:   Wed, 17 Nov 2021 16:58:28 -0800
Message-Id: <20211118005832.245978-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
References: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

There is name similarity within IXGBE_VT_MSGTYPE_ACK and
PFMAILBOX.ACK / VFMAILBOX.ACK. MSGTYPE macros are renamed to SUCCESS and
FAILURE because they are not specified in datasheet and now will be
easily distinguishable.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c |  2 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h   | 17 +++++++-----
 drivers/net/ethernet/intel/ixgbevf/vf.c    | 31 +++++++++++-----------
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index e3e4676af9e4..9b84e122c7c3 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -49,7 +49,7 @@ static int ixgbevf_ipsec_set_pf_sa(struct ixgbevf_adapter *adapter,
 		goto out;
 
 	ret = (int)msgbuf[1];
-	if (msgbuf[0] & IXGBE_VT_MSGTYPE_NACK && ret >= 0)
+	if (msgbuf[0] & IXGBE_VT_MSGTYPE_FAILURE && ret >= 0)
 		ret = -1;
 
 out:
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.h b/drivers/net/ethernet/intel/ixgbevf/mbx.h
index 853796c8ef0e..a461b7d16206 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.h
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.h
@@ -39,14 +39,17 @@
 
 /* If it's a IXGBE_VF_* msg then it originates in the VF and is sent to the
  * PF.  The reverse is true if it is IXGBE_PF_*.
- * Message ACK's are the value or'd with 0xF0000000
+ * Message results are the value or'd with 0xF0000000
  */
-/* Messages below or'd with this are the ACK */
-#define IXGBE_VT_MSGTYPE_ACK	0x80000000
-/* Messages below or'd with this are the NACK */
-#define IXGBE_VT_MSGTYPE_NACK	0x40000000
-/* Indicates that VF is still clear to send requests */
-#define IXGBE_VT_MSGTYPE_CTS	0x20000000
+#define IXGBE_VT_MSGTYPE_SUCCESS	0x80000000 /* Messages or'd with this
+						    * have succeeded
+						    */
+#define IXGBE_VT_MSGTYPE_FAILURE	0x40000000 /* Messages or'd with this
+						    * have failed
+						    */
+#define IXGBE_VT_MSGTYPE_CTS		0x20000000 /* Indicates that VF is still
+						    * clear to send requests
+						    */
 #define IXGBE_VT_MSGINFO_SHIFT	16
 /* bits 23:16 are used for exra info for certain messages */
 #define IXGBE_VT_MSGINFO_MASK	(0xFF << IXGBE_VT_MSGINFO_SHIFT)
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index d459f5c8e98f..f5d0d7969144 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -108,11 +108,11 @@ static s32 ixgbevf_reset_hw_vf(struct ixgbe_hw *hw)
 	 * to indicate that no MAC address has yet been assigned for
 	 * the VF.
 	 */
-	if (msgbuf[0] != (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_ACK) &&
-	    msgbuf[0] != (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_NACK))
+	if (msgbuf[0] != (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_SUCCESS) &&
+	    msgbuf[0] != (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_FAILURE))
 		return IXGBE_ERR_INVALID_MAC_ADDR;
 
-	if (msgbuf[0] == (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_ACK))
+	if (msgbuf[0] == (IXGBE_VF_RESET | IXGBE_VT_MSGTYPE_SUCCESS))
 		ether_addr_copy(hw->mac.perm_addr, addr);
 
 	hw->mac.mc_filter_type = msgbuf[IXGBE_VF_MC_TYPE_WORD];
@@ -269,7 +269,7 @@ static s32 ixgbevf_set_uc_addr_vf(struct ixgbe_hw *hw, u32 index, u8 *addr)
 	if (!ret_val) {
 		msgbuf[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 
-		if (msgbuf[0] == (msgbuf_chk | IXGBE_VT_MSGTYPE_NACK))
+		if (msgbuf[0] == (msgbuf_chk | IXGBE_VT_MSGTYPE_FAILURE))
 			return -ENOMEM;
 	}
 
@@ -336,14 +336,14 @@ int ixgbevf_get_reta_locked(struct ixgbe_hw *hw, u32 *reta, int num_rx_queues)
 	msgbuf[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 
 	/* If the operation has been refused by a PF return -EPERM */
-	if (msgbuf[0] == (IXGBE_VF_GET_RETA | IXGBE_VT_MSGTYPE_NACK))
+	if (msgbuf[0] == (IXGBE_VF_GET_RETA | IXGBE_VT_MSGTYPE_FAILURE))
 		return -EPERM;
 
 	/* If we didn't get an ACK there must have been
 	 * some sort of mailbox error so we should treat it
 	 * as such.
 	 */
-	if (msgbuf[0] != (IXGBE_VF_GET_RETA | IXGBE_VT_MSGTYPE_ACK))
+	if (msgbuf[0] != (IXGBE_VF_GET_RETA | IXGBE_VT_MSGTYPE_SUCCESS))
 		return IXGBE_ERR_MBX;
 
 	/* ixgbevf doesn't support more than 2 queues at the moment */
@@ -403,14 +403,14 @@ int ixgbevf_get_rss_key_locked(struct ixgbe_hw *hw, u8 *rss_key)
 	msgbuf[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 
 	/* If the operation has been refused by a PF return -EPERM */
-	if (msgbuf[0] == (IXGBE_VF_GET_RSS_KEY | IXGBE_VT_MSGTYPE_NACK))
+	if (msgbuf[0] == (IXGBE_VF_GET_RSS_KEY | IXGBE_VT_MSGTYPE_FAILURE))
 		return -EPERM;
 
 	/* If we didn't get an ACK there must have been
 	 * some sort of mailbox error so we should treat it
 	 * as such.
 	 */
-	if (msgbuf[0] != (IXGBE_VF_GET_RSS_KEY | IXGBE_VT_MSGTYPE_ACK))
+	if (msgbuf[0] != (IXGBE_VF_GET_RSS_KEY | IXGBE_VT_MSGTYPE_SUCCESS))
 		return IXGBE_ERR_MBX;
 
 	memcpy(rss_key, msgbuf + 1, IXGBEVF_RSS_HASH_KEY_SIZE);
@@ -442,7 +442,7 @@ static s32 ixgbevf_set_rar_vf(struct ixgbe_hw *hw, u32 index, u8 *addr,
 
 	/* if nacked the address was rejected, use "perm_addr" */
 	if (!ret_val &&
-	    (msgbuf[0] == (IXGBE_VF_SET_MAC_ADDR | IXGBE_VT_MSGTYPE_NACK))) {
+	    (msgbuf[0] == (IXGBE_VF_SET_MAC_ADDR | IXGBE_VT_MSGTYPE_FAILURE))) {
 		ixgbevf_get_mac_addr_vf(hw, hw->mac.addr);
 		return IXGBE_ERR_MBX;
 	}
@@ -561,7 +561,7 @@ static s32 ixgbevf_update_xcast_mode(struct ixgbe_hw *hw, int xcast_mode)
 		return err;
 
 	msgbuf[0] &= ~IXGBE_VT_MSGTYPE_CTS;
-	if (msgbuf[0] == (IXGBE_VF_UPDATE_XCAST_MODE | IXGBE_VT_MSGTYPE_NACK))
+	if (msgbuf[0] == (IXGBE_VF_UPDATE_XCAST_MODE | IXGBE_VT_MSGTYPE_FAILURE))
 		return -EPERM;
 
 	return 0;
@@ -606,7 +606,7 @@ static s32 ixgbevf_set_vfta_vf(struct ixgbe_hw *hw, u32 vlan, u32 vind,
 	msgbuf[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 	msgbuf[0] &= ~(0xFF << IXGBE_VT_MSGINFO_SHIFT);
 
-	if (msgbuf[0] != (IXGBE_VF_SET_VLAN | IXGBE_VT_MSGTYPE_ACK))
+	if (msgbuf[0] != (IXGBE_VF_SET_VLAN | IXGBE_VT_MSGTYPE_SUCCESS))
 		err = IXGBE_ERR_INVALID_ARGUMENT;
 
 mbx_err:
@@ -710,7 +710,7 @@ static s32 ixgbevf_check_mac_link_vf(struct ixgbe_hw *hw,
 
 	if (!(in_msg & IXGBE_VT_MSGTYPE_CTS)) {
 		/* msg is not CTS and is NACK we must have lost CTS status */
-		if (in_msg & IXGBE_VT_MSGTYPE_NACK)
+		if (in_msg & IXGBE_VT_MSGTYPE_FAILURE)
 			ret_val = -1;
 		goto out;
 	}
@@ -816,7 +816,7 @@ static s32 ixgbevf_set_rlpml_vf(struct ixgbe_hw *hw, u16 max_size)
 	if (ret_val)
 		return ret_val;
 	if ((msgbuf[0] & IXGBE_VF_SET_LPE) &&
-	    (msgbuf[0] & IXGBE_VT_MSGTYPE_NACK))
+	    (msgbuf[0] & IXGBE_VT_MSGTYPE_FAILURE))
 		return IXGBE_ERR_MBX;
 
 	return 0;
@@ -863,7 +863,8 @@ static int ixgbevf_negotiate_api_version_vf(struct ixgbe_hw *hw, int api)
 		msg[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 
 		/* Store value and return 0 on success */
-		if (msg[0] == (IXGBE_VF_API_NEGOTIATE | IXGBE_VT_MSGTYPE_ACK)) {
+		if (msg[0] == (IXGBE_VF_API_NEGOTIATE |
+			      IXGBE_VT_MSGTYPE_SUCCESS)) {
 			hw->api_version = api;
 			return 0;
 		}
@@ -918,7 +919,7 @@ int ixgbevf_get_queues(struct ixgbe_hw *hw, unsigned int *num_tcs,
 		 * some sort of mailbox error so we should treat it
 		 * as such
 		 */
-		if (msg[0] != (IXGBE_VF_GET_QUEUE | IXGBE_VT_MSGTYPE_ACK))
+		if (msg[0] != (IXGBE_VF_GET_QUEUE | IXGBE_VT_MSGTYPE_SUCCESS))
 			return IXGBE_ERR_MBX;
 
 		/* record and validate values from message */
-- 
2.31.1


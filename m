Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D148D44B2B
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfFMSxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:53:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:64323 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbfFMSxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:53:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 11:53:31 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2019 11:53:31 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/12] i40e: Missing response checks in driver when starting/stopping FW LLDP
Date:   Thu, 13 Jun 2019 11:53:46 -0700
Message-Id: <20190613185347.16361-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Driver updated pf->flags before calling i40e_aq_start_lldp().
This patch moved down updating pf->flags down so flags will be
updated only in case of successful i40e_aq_start_lldp() call.
Also was introduced is_reset_needed local flag to avoid unnecessary h/w
reset in case 40e_aq_start_lldp() didn't change lldp state.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 45 ++++++++++---------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 0837c6b3e15e..bc70b0d581a1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4856,6 +4856,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	enum i40e_admin_queue_err adq_err;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
+	bool is_reset_needed;
 	i40e_status status;
 	u32 i, j;
 
@@ -4900,6 +4901,10 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 flags_complete:
 	changed_flags = orig_flags ^ new_flags;
 
+	is_reset_needed = !!(changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
+		I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED |
+		I40E_FLAG_DISABLE_FW_LLDP));
+
 	/* Before we finalize any flag changes, we need to perform some
 	 * checks to ensure that the changes are supported and safe.
 	 */
@@ -4934,13 +4939,6 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		return -EOPNOTSUPP;
 	}
 
-	/* Now that we've checked to ensure that the new flags are valid, load
-	 * them into place. Since we only modify flags either (a) during
-	 * initialization or (b) while holding the RTNL lock, we don't need
-	 * anything fancy here.
-	 */
-	pf->flags = new_flags;
-
 	/* Process any additional changes needed as a result of flag changes.
 	 * The changed_flags value reflects the list of bits that were
 	 * changed in the code above.
@@ -4948,7 +4946,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 
 	/* Flush current ATR settings if ATR was disabled */
 	if ((changed_flags & I40E_FLAG_FD_ATR_ENABLED) &&
-	    !(pf->flags & I40E_FLAG_FD_ATR_ENABLED)) {
+	    !(new_flags & I40E_FLAG_FD_ATR_ENABLED)) {
 		set_bit(__I40E_FD_ATR_AUTO_DISABLED, pf->state);
 		set_bit(__I40E_FD_FLUSH_REQUESTED, pf->state);
 	}
@@ -4957,7 +4955,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		u16 sw_flags = 0, valid_flags = 0;
 		int ret;
 
-		if (!(pf->flags & I40E_FLAG_TRUE_PROMISC_SUPPORT))
+		if (!(new_flags & I40E_FLAG_TRUE_PROMISC_SUPPORT))
 			sw_flags = I40E_AQ_SET_SWITCH_CFG_PROMISC;
 		valid_flags = I40E_AQ_SET_SWITCH_CFG_PROMISC;
 		ret = i40e_aq_set_switch_config(&pf->hw, sw_flags, valid_flags,
@@ -4976,13 +4974,13 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	    (changed_flags & I40E_FLAG_BASE_R_FEC)) {
 		u8 fec_cfg = 0;
 
-		if (pf->flags & I40E_FLAG_RS_FEC &&
-		    pf->flags & I40E_FLAG_BASE_R_FEC) {
+		if (new_flags & I40E_FLAG_RS_FEC &&
+		    new_flags & I40E_FLAG_BASE_R_FEC) {
 			fec_cfg = I40E_AQ_SET_FEC_AUTO;
-		} else if (pf->flags & I40E_FLAG_RS_FEC) {
+		} else if (new_flags & I40E_FLAG_RS_FEC) {
 			fec_cfg = (I40E_AQ_SET_FEC_REQUEST_RS |
 				   I40E_AQ_SET_FEC_ABILITY_RS);
-		} else if (pf->flags & I40E_FLAG_BASE_R_FEC) {
+		} else if (new_flags & I40E_FLAG_BASE_R_FEC) {
 			fec_cfg = (I40E_AQ_SET_FEC_REQUEST_KR |
 				   I40E_AQ_SET_FEC_ABILITY_KR);
 		}
@@ -4990,14 +4988,14 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 			dev_warn(&pf->pdev->dev, "Cannot change FEC config\n");
 	}
 
-	if ((changed_flags & pf->flags &
+	if ((changed_flags & new_flags &
 	     I40E_FLAG_LINK_DOWN_ON_CLOSE_ENABLED) &&
-	    (pf->flags & I40E_FLAG_MFP_ENABLED))
+	    (new_flags & I40E_FLAG_MFP_ENABLED))
 		dev_warn(&pf->pdev->dev,
 			 "Turning on link-down-on-close flag may affect other partitions\n");
 
 	if (changed_flags & I40E_FLAG_DISABLE_FW_LLDP) {
-		if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP) {
+		if (new_flags & I40E_FLAG_DISABLE_FW_LLDP) {
 			struct i40e_dcbx_config *dcbcfg;
 
 			i40e_aq_stop_lldp(&pf->hw, true, false, NULL);
@@ -5022,7 +5020,8 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 				case I40E_AQ_RC_EEXIST:
 					dev_warn(&pf->pdev->dev,
 						 "FW LLDP agent is already running\n");
-					return 0;
+					is_reset_needed = false;
+					break;
 				case I40E_AQ_RC_EPERM:
 					dev_warn(&pf->pdev->dev,
 						 "Device configuration forbids SW from starting the LLDP agent.\n");
@@ -5040,13 +5039,17 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		}
 	}
 
+	/* Now that we've checked to ensure that the new flags are valid, load
+	 * them into place. Since we only modify flags either (a) during
+	 * initialization or (b) while holding the RTNL lock, we don't need
+	 * anything fancy here.
+	 */
+	pf->flags = new_flags;
+
 	/* Issue reset to cause things to take effect, as additional bits
 	 * are added we will need to create a mask of bits requiring reset
 	 */
-	if (changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
-			     I40E_FLAG_LEGACY_RX |
-			     I40E_FLAG_SOURCE_PRUNING_DISABLED |
-			     I40E_FLAG_DISABLE_FW_LLDP))
+	if (is_reset_needed)
 		i40e_do_reset(pf, BIT(__I40E_PF_RESET_REQUESTED), true);
 
 	return 0;
-- 
2.21.0


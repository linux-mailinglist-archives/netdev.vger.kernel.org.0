Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0238B3023E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfE3Sul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:30432 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfE3Suh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Cleanup ice_update_link_info
Date:   Thu, 30 May 2019 11:50:36 -0700
Message-Id: <20190530185045.3886-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Do not allocate memory for the Get PHY Abilities command data buffer when
it is not necessary, change one local variable to another to reduce the
number of de-references, reduce the scope of some local variables, and
reorder the code and change exit points to get rid of an unnecessary goto
label.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 35 +++++++++++----------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c24dc9969858..6988eb8695f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1998,36 +1998,37 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
  */
 enum ice_status ice_update_link_info(struct ice_port_info *pi)
 {
-	struct ice_aqc_get_phy_caps_data *pcaps;
-	struct ice_phy_info *phy_info;
+	struct ice_link_status *li;
 	enum ice_status status;
-	struct ice_hw *hw;
 
 	if (!pi)
 		return ICE_ERR_PARAM;
 
-	hw = pi->hw;
-
-	pcaps = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*pcaps), GFP_KERNEL);
-	if (!pcaps)
-		return ICE_ERR_NO_MEMORY;
+	li = &pi->phy.link_info;
 
-	phy_info = &pi->phy;
 	status = ice_aq_get_link_info(pi, true, NULL, NULL);
 	if (status)
-		goto out;
+		return status;
+
+	if (li->link_info & ICE_AQ_MEDIA_AVAILABLE) {
+		struct ice_aqc_get_phy_caps_data *pcaps;
+		struct ice_hw *hw;
+
+		hw = pi->hw;
+		pcaps = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*pcaps),
+				     GFP_KERNEL);
+		if (!pcaps)
+			return ICE_ERR_NO_MEMORY;
 
-	if (phy_info->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG,
 					     pcaps, NULL);
-		if (status)
-			goto out;
+		if (!status)
+			memcpy(li->module_type, &pcaps->module_type,
+			       sizeof(li->module_type));
 
-		memcpy(phy_info->link_info.module_type, &pcaps->module_type,
-		       sizeof(phy_info->link_info.module_type));
+		devm_kfree(ice_hw_to_dev(hw), pcaps);
 	}
-out:
-	devm_kfree(ice_hw_to_dev(hw), pcaps);
+
 	return status;
 }
 
-- 
2.21.0


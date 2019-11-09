Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A332FF5C73
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfKIAod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:25215 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfKIAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111199"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 3/6] i40e: Fix for ethtool -m issue on X722 NIC
Date:   Fri,  8 Nov 2019 16:44:27 -0800
Message-Id: <20191109004430.7219-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

This patch contains fix for a problem with command:
'ethtool -m <dev>'
which breaks functionality of:
'ethtool <dev>'
when called on X722 NIC

Disallowed update of link phy_types on X722 NIC
Currently correct value cannot be obtained from FW
Previously wrong value returned by FW was used and was
a root cause for incorrect output of 'ethtool <dev>' command

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index d37c6e0e5f08..7560f06768e0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1876,7 +1876,8 @@ i40e_status i40e_aq_get_link_info(struct i40e_hw *hw,
 	     hw->aq.fw_min_ver < 40)) && hw_link_info->phy_type == 0xE)
 		hw_link_info->phy_type = I40E_PHY_TYPE_10GBASE_SFPP_CU;
 
-	if (hw->flags & I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE) {
+	if (hw->flags & I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE &&
+	    hw->mac.type != I40E_MAC_X722) {
 		__le32 tmp;
 
 		memcpy(&tmp, resp->link_type, sizeof(tmp));
-- 
2.21.0


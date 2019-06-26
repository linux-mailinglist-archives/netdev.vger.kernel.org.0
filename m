Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD411571C3
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfFZTah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:41403 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbfFZTaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762466"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Martyna Szapar <martyna.szapar@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/10] i40e: Fix for missing "link modes" info in ethtool
Date:   Wed, 26 Jun 2019 12:30:57 -0700
Message-Id: <20190626193103.2169-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

Fix for missing "Supported link modes" and "Advertised link modes"
info in ethtool after changed speed on X722 devices with BASE-T PHY
with FW API version >= 1.7.
The same FW API version on X710 and X722 does not mean the same
feature set so the change was needed as mac type of the device
should also be checked instead of FW API version only.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 641b500ad919..906cf68d3453 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1861,8 +1861,7 @@ i40e_status i40e_aq_get_link_info(struct i40e_hw *hw,
 	     hw->aq.fw_min_ver < 40)) && hw_link_info->phy_type == 0xE)
 		hw_link_info->phy_type = I40E_PHY_TYPE_10GBASE_SFPP_CU;
 
-	if (hw->aq.api_maj_ver == I40E_FW_API_VERSION_MAJOR &&
-	    hw->aq.api_min_ver >= 7) {
+	if (hw->flags & I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE) {
 		__le32 tmp;
 
 		memcpy(&tmp, resp->link_type, sizeof(tmp));
-- 
2.21.0


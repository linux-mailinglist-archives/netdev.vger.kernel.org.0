Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB235FEE0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhDOA3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:27428 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231503AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: CiXHzS61BsWv34Ff+7sWf5RFvkTRJB8V3R8WlN+Yyfolk4cywjb2azRakDl1aFmFsKrWK+rUrg
 lNRRYyuq1JWQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262236"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262236"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: /UOaQLOvzcF4ixLWdcIQO3TFKwQNwLRP6gbRRioXWPsER1PtsT4nBKLFmJPt1Pr2e3Kk/Xbd22
 paUAA9BiURwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379519"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Scott W Taylor <scott.w.taylor@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 08/15] ice: Reimplement module reads used by ethtool
Date:   Wed, 14 Apr 2021 17:30:06 -0700
Message-Id: <20210415003013.19717-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Scott W Taylor <scott.w.taylor@intel.com>

There was an excessive increment of the QSFP page, which is
now fixed. Additionally, this new update now reads 8 bytes
at a time and will retry each request if the module/bus is
busy.

Also, prevent reading from upper pages if module does not
support those pages.

Signed-off-by: Scott W Taylor <scott.w.taylor@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 49 ++++++++++++++++----
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 68c8ad8d157e..d9ddd0bcf65f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3914,30 +3914,33 @@ ice_get_module_eeprom(struct net_device *netdev,
 		      struct ethtool_eeprom *ee, u8 *data)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+#define SFF_READ_BLOCK_SIZE 8
+	u8 value[SFF_READ_BLOCK_SIZE] = { 0 };
 	u8 addr = ICE_I2C_EEPROM_DEV_ADDR;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	bool is_sfp = false;
-	unsigned int i;
+	unsigned int i, j;
 	u16 offset = 0;
-	u8 value = 0;
 	u8 page = 0;
 
 	if (!ee || !ee->len || !data)
 		return -EINVAL;
 
-	status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, 0, &value, 1, 0,
+	status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, 0, value, 1, 0,
 				   NULL);
 	if (status)
 		return -EIO;
 
-	if (value == ICE_MODULE_TYPE_SFP)
+	if (value[0] == ICE_MODULE_TYPE_SFP)
 		is_sfp = true;
 
-	for (i = 0; i < ee->len; i++) {
+	memset(data, 0, ee->len);
+	for (i = 0; i < ee->len; i += SFF_READ_BLOCK_SIZE) {
 		offset = i + ee->offset;
+		page = 0;
 
 		/* Check if we need to access the other memory page */
 		if (is_sfp) {
@@ -3953,11 +3956,37 @@ ice_get_module_eeprom(struct net_device *netdev,
 			}
 		}
 
-		status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, !is_sfp,
-					   &value, 1, 0, NULL);
-		if (status)
-			value = 0;
-		data[i] = value;
+		/* Bit 2 of EEPROM address 0x02 declares upper
+		 * pages are disabled on QSFP modules.
+		 * SFP modules only ever use page 0.
+		 */
+		if (page == 0 || !(data[0x2] & 0x4)) {
+			/* If i2c bus is busy due to slow page change or
+			 * link management access, call can fail. This is normal.
+			 * So we retry this a few times.
+			 */
+			for (j = 0; j < 4; j++) {
+				status = ice_aq_sff_eeprom(hw, 0, addr, offset, page,
+							   !is_sfp, value,
+							   SFF_READ_BLOCK_SIZE,
+							   0, NULL);
+				netdev_dbg(netdev, "SFF %02X %02X %02X %X = %02X%02X%02X%02X.%02X%02X%02X%02X (%X)\n",
+					   addr, offset, page, is_sfp,
+					   value[0], value[1], value[2], value[3],
+					   value[4], value[5], value[6], value[7],
+					   status);
+				if (status) {
+					usleep_range(1500, 2500);
+					memset(value, 0, SFF_READ_BLOCK_SIZE);
+					continue;
+				}
+				break;
+			}
+
+			/* Make sure we have enough room for the new block */
+			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
+				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
+		}
 	}
 	return 0;
 }
-- 
2.26.2


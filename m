Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0E67E480
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbfHAUvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:51:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:8390 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfHAUvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 16:51:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:51:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="163734557"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2019 13:51:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Czeslaw Zagorski <czeslawx.zagorski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/9] i40e: Update visual effect for advertised FEC mode.
Date:   Thu,  1 Aug 2019 13:51:46 -0700
Message-Id: <20190801205149.4114-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Czeslaw Zagorski <czeslawx.zagorski@intel.com>

Updates visual effect for advertised mode after setting desired mode.
The mode appears in advertised FEC mode correctly, when ethtool
interface command is called. Without this commit advertised FEC
is displayed regardless of the settings as "None BaseR RS".

Signed-off-by: Czeslaw Zagorski <czeslawx.zagorski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 63 ++++++++++---------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 65e016f54f58..ceca57a261dc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -710,6 +710,35 @@ static void i40e_phy_type_to_ethtool(struct i40e_pf *pf,
 	}
 }
 
+/**
+ * i40e_get_settings_link_up_fec - Get the FEC mode encoding from mask
+ * @req_fec_info: mask request FEC info
+ * @ks: ethtool ksettings to fill in
+ **/
+static void i40e_get_settings_link_up_fec(u8 req_fec_info,
+					  struct ethtool_link_ksettings *ks)
+{
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
+
+	if (I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) {
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+	} else if (I40E_AQ_SET_FEC_REQUEST_KR & req_fec_info) {
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_BASER);
+	} else {
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_NONE);
+		if (I40E_AQ_SET_FEC_AUTO & req_fec_info) {
+			ethtool_link_ksettings_add_link_mode(ks, advertising,
+							     FEC_RS);
+			ethtool_link_ksettings_add_link_mode(ks, advertising,
+							     FEC_BASER);
+		}
+	}
+}
+
 /**
  * i40e_get_settings_link_up - Get the Link settings for when link is up
  * @hw: hw structure
@@ -769,13 +798,7 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 						     25000baseSR_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     25000baseSR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     FEC_BASER);
+		i40e_get_settings_link_up_fec(hw_link_info->req_fec_info, ks);
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseSR_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
@@ -892,9 +915,6 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 						     40000baseKR4_Full);
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseKR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     20000baseKR2_Full);
 		ethtool_link_ksettings_add_link_mode(ks, supported,
@@ -908,10 +928,7 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 						     40000baseKR4_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     25000baseKR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     FEC_BASER);
+		i40e_get_settings_link_up_fec(hw_link_info->req_fec_info, ks);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     20000baseKR2_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
@@ -929,13 +946,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 						     25000baseCR_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     25000baseCR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     FEC_BASER);
+		i40e_get_settings_link_up_fec(hw_link_info->req_fec_info, ks);
+
 		break;
 	case I40E_PHY_TYPE_25GBASE_AOC:
 	case I40E_PHY_TYPE_25GBASE_ACC:
@@ -945,13 +957,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 						     25000baseCR_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     25000baseCR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     FEC_BASER);
+		i40e_get_settings_link_up_fec(hw_link_info->req_fec_info, ks);
+
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseCR_Full);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
-- 
2.21.0


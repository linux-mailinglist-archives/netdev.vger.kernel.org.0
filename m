Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABE0E5550
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 22:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfJYUnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 16:43:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:63953 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfJYUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 16:42:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 13:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="202713958"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 13:42:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jaroslaw Gawin <jaroslawx.gawin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 2/9] i40e: Wrong 'Advertised FEC modes' after set FEC to AUTO
Date:   Fri, 25 Oct 2019 13:42:35 -0700
Message-Id: <20191025204242.10535-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

Fix display of parameters "Configured FEC encodings:" and "Advertised
FEC modes:" in ethtool.  Implemented by setting proper FEC bits in
“advertising” bitmask of link_modes struct and “fec” bitmask in
ethtool_fecparam struct. Without this patch wrong FEC settings
can be shown.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 13 ++++++--
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 32 +++++++++----------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index d37c6e0e5f08..f1d67267c983 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2570,9 +2570,16 @@ noinline_for_stack i40e_status i40e_update_link_info(struct i40e_hw *hw)
 		if (status)
 			return status;
 
-		hw->phy.link_info.req_fec_info =
-			abilities.fec_cfg_curr_mod_ext_info &
-			(I40E_AQ_REQUEST_FEC_KR | I40E_AQ_REQUEST_FEC_RS);
+		if (abilities.fec_cfg_curr_mod_ext_info &
+		    I40E_AQ_ENABLE_FEC_AUTO)
+			hw->phy.link_info.req_fec_info =
+				(I40E_AQ_REQUEST_FEC_KR |
+				 I40E_AQ_REQUEST_FEC_RS);
+		else
+			hw->phy.link_info.req_fec_info =
+				abilities.fec_cfg_curr_mod_ext_info &
+				(I40E_AQ_REQUEST_FEC_KR |
+				 I40E_AQ_REQUEST_FEC_RS);
 
 		memcpy(hw->phy.link_info.module_type, &abilities.module_type,
 		       sizeof(hw->phy.link_info.module_type));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 41e1240acaea..b577e6adf3bf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -722,7 +722,14 @@ static void i40e_get_settings_link_up_fec(u8 req_fec_info,
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
 
-	if (I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) {
+	if ((I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) &&
+	    (I40E_AQ_SET_FEC_REQUEST_KR & req_fec_info)) {
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_NONE);
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_BASER);
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+	} else if (I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
 	} else if (I40E_AQ_SET_FEC_REQUEST_KR & req_fec_info) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
@@ -730,12 +737,6 @@ static void i40e_get_settings_link_up_fec(u8 req_fec_info,
 	} else {
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     FEC_NONE);
-		if (I40E_AQ_SET_FEC_AUTO & req_fec_info) {
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     FEC_RS);
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     FEC_BASER);
-		}
 	}
 }
 
@@ -1437,6 +1438,7 @@ static int i40e_get_fec_param(struct net_device *netdev,
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status status = 0;
 	int err = 0;
+	u8 fec_cfg;
 
 	/* Get the current phy config */
 	memset(&abilities, 0, sizeof(abilities));
@@ -1448,18 +1450,16 @@ static int i40e_get_fec_param(struct net_device *netdev,
 	}
 
 	fecparam->fec = 0;
-	if (abilities.fec_cfg_curr_mod_ext_info & I40E_AQ_SET_FEC_AUTO)
+	fec_cfg = abilities.fec_cfg_curr_mod_ext_info;
+	if (fec_cfg & I40E_AQ_SET_FEC_AUTO)
 		fecparam->fec |= ETHTOOL_FEC_AUTO;
-	if ((abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_REQUEST_RS) ||
-	    (abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_ABILITY_RS))
+	else if (fec_cfg & (I40E_AQ_SET_FEC_REQUEST_RS |
+		 I40E_AQ_SET_FEC_ABILITY_RS))
 		fecparam->fec |= ETHTOOL_FEC_RS;
-	if ((abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_REQUEST_KR) ||
-	    (abilities.fec_cfg_curr_mod_ext_info & I40E_AQ_SET_FEC_ABILITY_KR))
+	else if (fec_cfg & (I40E_AQ_SET_FEC_REQUEST_KR |
+		 I40E_AQ_SET_FEC_ABILITY_KR))
 		fecparam->fec |= ETHTOOL_FEC_BASER;
-	if (abilities.fec_cfg_curr_mod_ext_info == 0)
+	if (fec_cfg == 0)
 		fecparam->fec |= ETHTOOL_FEC_OFF;
 
 	if (hw->phy.link_info.fec_info & I40E_AQ_CONFIG_FEC_KR_ENA)
-- 
2.21.0


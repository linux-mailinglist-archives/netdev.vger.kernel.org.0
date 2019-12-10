Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4CA1196D1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfLJVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfLJVKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22FE8246B8;
        Tue, 10 Dec 2019 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012211;
        bh=fPVTs/fg7aQhDVEVKsn+kl9tgK6QXcIfCPo695DbGS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTe/j59fGQwAwcruTCr1QG/cTeclCTGyAQ9ay6Ql9aJIwLpsKN1kwM3cTcZV3Z5VV
         ZodC40zvjctW5J0NrzBxl7TVqeOwKI+NaCaFpFK0O0++OlqJ1x3UA5zFRcG8jfS1Yx
         fSDoYUpDFfdYi4BcqqdEsjdIqZSSxvfZgnzVCLXY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 163/350] i40e: Wrong 'Advertised FEC modes' after set FEC to AUTO
Date:   Tue, 10 Dec 2019 16:04:28 -0500
Message-Id: <20191210210735.9077-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

[ Upstream commit e42b7e9cefca9dd008cbafffca97285cf264f72d ]

Fix display of parameters "Configured FEC encodings:" and "Advertised
FEC modes:" in ethtool.  Implemented by setting proper FEC bits in
“advertising” bitmask of link_modes struct and “fec” bitmask in
ethtool_fecparam struct. Without this patch wrong FEC settings
can be shown.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 13 ++++++--
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 32 +++++++++----------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 7560f06768e06..3160b5bbe6728 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2571,9 +2571,16 @@ noinline_for_stack i40e_status i40e_update_link_info(struct i40e_hw *hw)
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
index 41e1240acaea5..b577e6adf3bff 100644
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
2.20.1


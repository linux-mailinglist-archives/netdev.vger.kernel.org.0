Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250452CD7CA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403752AbgLCN37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388928AbgLCN36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:58 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 06/39] iwlwifi: sta: set max HE max A-MPDU according to HE capa
Date:   Thu,  3 Dec 2020 08:28:00 -0500
Message-Id: <20201203132834.930999-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit c8a2e7a29702fe4626b7aa81149b7b7164e20606 ]

Currently, our max tpt is limited to max HT A-MPDU for LB,
and max VHT A-MPDU for HB. Configure HE exponent value correctly to
achieve HE max A-MPDU, both on LB and HB.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201107104557.4486852ebb56.I9eb0d028e31f183597fb90120e7d4ca87e0dd6cb@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/fw/api/sta.h    | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
index c010e6febbf47..6a071b3c8118c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
@@ -5,10 +5,9 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012-2014, 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,10 +27,9 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012-2014, 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -128,7 +126,9 @@ enum iwl_sta_flags {
 	STA_FLG_MAX_AGG_SIZE_256K	= (5 << STA_FLG_MAX_AGG_SIZE_SHIFT),
 	STA_FLG_MAX_AGG_SIZE_512K	= (6 << STA_FLG_MAX_AGG_SIZE_SHIFT),
 	STA_FLG_MAX_AGG_SIZE_1024K	= (7 << STA_FLG_MAX_AGG_SIZE_SHIFT),
-	STA_FLG_MAX_AGG_SIZE_MSK	= (7 << STA_FLG_MAX_AGG_SIZE_SHIFT),
+	STA_FLG_MAX_AGG_SIZE_2M		= (8 << STA_FLG_MAX_AGG_SIZE_SHIFT),
+	STA_FLG_MAX_AGG_SIZE_4M		= (9 << STA_FLG_MAX_AGG_SIZE_SHIFT),
+	STA_FLG_MAX_AGG_SIZE_MSK	= (0xf << STA_FLG_MAX_AGG_SIZE_SHIFT),
 
 	STA_FLG_AGG_MPDU_DENS_SHIFT	= 23,
 	STA_FLG_AGG_MPDU_DENS_2US	= (4 << STA_FLG_AGG_MPDU_DENS_SHIFT),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9e124755a3cee..2158fd2eff736 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -196,6 +196,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		mpdu_dens = sta->ht_cap.ampdu_density;
 	}
 
+
 	if (sta->vht_cap.vht_supported) {
 		agg_size = sta->vht_cap.cap &
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
@@ -205,6 +206,23 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		agg_size = sta->ht_cap.ampdu_factor;
 	}
 
+	/* D6.0 10.12.2 A-MPDU length limit rules
+	 * A STA indicates the maximum length of the A-MPDU preEOF padding
+	 * that it can receive in an HE PPDU in the Maximum A-MPDU Length
+	 * Exponent field in its HT Capabilities, VHT Capabilities,
+	 * and HE 6 GHz Band Capabilities elements (if present) and the
+	 * Maximum AMPDU Length Exponent Extension field in its HE
+	 * Capabilities element
+	 */
+	if (sta->he_cap.has_he)
+		agg_size += u8_get_bits(sta->he_cap.he_cap_elem.mac_cap_info[3],
+					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK);
+
+	/* Limit to max A-MPDU supported by FW */
+	if (agg_size > (STA_FLG_MAX_AGG_SIZE_4M >> STA_FLG_MAX_AGG_SIZE_SHIFT))
+		agg_size = (STA_FLG_MAX_AGG_SIZE_4M >>
+			    STA_FLG_MAX_AGG_SIZE_SHIFT);
+
 	add_sta_cmd.station_flags |=
 		cpu_to_le32(agg_size << STA_FLG_MAX_AGG_SIZE_SHIFT);
 	add_sta_cmd.station_flags |=
-- 
2.27.0


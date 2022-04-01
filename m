Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3834EF261
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348276AbiDAOwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349239AbiDAOpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:45:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E001FA62;
        Fri,  1 Apr 2022 07:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 506EC60A53;
        Fri,  1 Apr 2022 14:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697BAC340EE;
        Fri,  1 Apr 2022 14:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823738;
        bh=bRdx8OImyd8hpObz/0qEKfFH0PdnVpMb4ukSvdDBojU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5kz6w43u4NRu8jtjCZ+Bw/fQW3WQOb8P0lDWnNlpdTUsPlYHcozVb3lonVUfGKiN
         qGQjGvobxN3XdMuKfbIwPksL/MtHxGZlUiJeRCMzWTfb2HYz1yN//99yMs3aDYQM5L
         lq68113HPpCbLLFL8t6m+tlblXHNnIvr08Y2wVtRMyULwqPY8T7uQ6h2riKR6bDrqS
         jgEWuDe+s1H6OwewJHCc71fUVaZjdBTZNUnqfcUebkCqEI0PgIm9OqDNNCBpsAUpTC
         hLPFObg/viH393Jx00jZnk1FB2evCAmzYOKCgATBUJIxyHrxkLnL92/ngmV9BQ2HwV
         EphG06SpTXncw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 056/109] iwlwifi: mvm: move only to an enabled channel
Date:   Fri,  1 Apr 2022 10:32:03 -0400
Message-Id: <20220401143256.1950537-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit e04135c07755d001b5cde61048c69a7cc84bb94b ]

During disassociation we're decreasing the phy's ref count.
If the ref count becomes 0, we're configuring the phy ctxt
to the default channel (the lowest channel which the device
can operate on). Currently we're not checking whether the
the default channel is enabled or not. Fix it by configuring
the phy ctxt to the lowest channel which is enabled.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220210181930.03f281b6a6bc.I5b63d43ec41996d599e6f37ec3f32e878b3e405e@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 31 +++++++++++++------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 035336a9e755..6d82725cb87d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -295,18 +295,31 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
 	 * otherwise we might not be able to reuse this phy.
 	 */
 	if (ctxt->ref == 0) {
-		struct ieee80211_channel *chan;
+		struct ieee80211_channel *chan = NULL;
 		struct cfg80211_chan_def chandef;
-		struct ieee80211_supported_band *sband = NULL;
-		enum nl80211_band band = NL80211_BAND_2GHZ;
+		struct ieee80211_supported_band *sband;
+		enum nl80211_band band;
+		int channel;
 
-		while (!sband && band < NUM_NL80211_BANDS)
-			sband = mvm->hw->wiphy->bands[band++];
+		for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
+			sband = mvm->hw->wiphy->bands[band];
 
-		if (WARN_ON(!sband))
-			return;
+			if (!sband)
+				continue;
+
+			for (channel = 0; channel < sband->n_channels; channel++)
+				if (!(sband->channels[channel].flags &
+						IEEE80211_CHAN_DISABLED)) {
+					chan = &sband->channels[channel];
+					break;
+				}
 
-		chan = &sband->channels[0];
+			if (chan)
+				break;
+		}
+
+		if (WARN_ON(!chan))
+			return;
 
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
 		iwl_mvm_phy_ctxt_changed(mvm, ctxt, &chandef, 1, 1);
-- 
2.34.1


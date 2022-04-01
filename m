Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B5F4EF2F9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348448AbiDAOys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351941AbiDAOtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136BD2B120E;
        Fri,  1 Apr 2022 07:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CEAA60C9B;
        Fri,  1 Apr 2022 14:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AE3C2BBE4;
        Fri,  1 Apr 2022 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823997;
        bh=kGf7ZIV+v4tY82G8Mz72jUPIY7jgqniLJ05Zmhp+eIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SElphT/VYwHN1zbJW2GJew4foS9gdxmhtrZrqfIny8NDpEoEguHSGDd4ydcE18+RN
         kLOvHVRfZBVNFhWaQxnOIVDZxyTVLHVC5ndz3REHmt9G18ZLRzrkpdlLrhb90ugG8/
         Q/s48ewAgz3bXKk3kdOH96Y1q91GUiuo/XeCt+R1HpLH6E6fB25NXjvfx1JwAMN6+h
         Zv1dqsZD/0gmj8BOI/PFcvMImziJpjz70zZd+4yp3gUTiXjcZn6qWXFIIFEacq0QRb
         WYEmyM7/z7jCGcD18LlrwhxysNSY+yslrylqxZmrQ6xDHEZ/iO9FZZ9cUm9eGrT9q9
         w8MvSPvQenB9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, ayala.beker@intel.com,
        avraham.stern@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 45/98] iwlwifi: mvm: Passively scan non PSC channels only when requested so
Date:   Fri,  1 Apr 2022 10:36:49 -0400
Message-Id: <20220401143742.1952163-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 9966904e9472703a05861f343157cd78f47514fd ]

Non PSC channels should generally be scanned based on information about
collocated APs obtained during scan on legacy bands, and otherwise
should not be scanned unless specifically requested so (as there are
relatively many non PSC channels, scanning them passively is time consuming
and interferes with regular data traffic).

Thus, modify the scan logic to avoid passively scanning PSC channels
if there is no information about collocated APs and the scan is not
a passive scan.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220204122220.457da4cc95eb.Ic98472bab5f5475f1e102547644caaae89ce4c4a@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 42 ++++++++++++++-----
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 65e382756de6..f1217e2b7a11 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1733,27 +1733,37 @@ iwl_mvm_umac_scan_fill_6g_chan_list(struct iwl_mvm *mvm,
 }
 
 /* TODO: this function can be merged with iwl_mvm_scan_umac_fill_ch_p_v6 */
-static void
-iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm_scan_params *params,
+static u32
+iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm *mvm,
+				     struct iwl_mvm_scan_params *params,
 				     u32 n_channels,
 				     struct iwl_scan_probe_params_v4 *pp,
 				     struct iwl_scan_channel_params_v6 *cp,
 				     enum nl80211_iftype vif_type)
 {
-	struct iwl_scan_channel_cfg_umac *channel_cfg = cp->channel_config;
 	int i;
 	struct cfg80211_scan_6ghz_params *scan_6ghz_params =
 		params->scan_6ghz_params;
+	u32 ch_cnt;
 
-	for (i = 0; i < params->n_channels; i++) {
+	for (i = 0, ch_cnt = 0; i < params->n_channels; i++) {
 		struct iwl_scan_channel_cfg_umac *cfg =
-			&cp->channel_config[i];
+			&cp->channel_config[ch_cnt];
 
 		u32 s_ssid_bitmap = 0, bssid_bitmap = 0, flags = 0;
 		u8 j, k, s_max = 0, b_max = 0, n_used_bssid_entries;
 		bool force_passive, found = false, allow_passive = true,
 		     unsolicited_probe_on_chan = false, psc_no_listen = false;
 
+		/*
+		 * Avoid performing passive scan on non PSC channels unless the
+		 * scan is specifically a passive scan, i.e., no SSIDs
+		 * configured in the scan command.
+		 */
+		if (!cfg80211_channel_is_psc(params->channels[i]) &&
+		    !params->n_6ghz_params && params->n_ssids)
+			continue;
+
 		cfg->v1.channel_num = params->channels[i]->hw_value;
 		cfg->v2.band = 2;
 		cfg->v2.iter_count = 1;
@@ -1872,8 +1882,16 @@ iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm_scan_params *params,
 		    (!flags && !cfg80211_channel_is_psc(params->channels[i])))
 			flags |= IWL_UHB_CHAN_CFG_FLAG_FORCE_PASSIVE;
 
-		channel_cfg[i].flags |= cpu_to_le32(flags);
+		cfg->flags |= cpu_to_le32(flags);
+		ch_cnt++;
 	}
+
+	if (params->n_channels > ch_cnt)
+		IWL_DEBUG_SCAN(mvm,
+			       "6GHz: reducing number channels: (%u->%u)\n",
+			       params->n_channels, ch_cnt);
+
+	return ch_cnt;
 }
 
 static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
@@ -2406,10 +2424,14 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_umac_scan_cfg_channels_v6_6g(params,
-					     params->n_channels,
-					     pb, cp, vif->type);
-	cp->count = params->n_channels;
+	cp->count = iwl_mvm_umac_scan_cfg_channels_v6_6g(mvm, params,
+							 params->n_channels,
+							 pb, cp, vif->type);
+	if (!cp->count) {
+		mvm->scan_uid_status[uid] = 0;
+		return -EINVAL;
+	}
+
 	if (!params->n_ssids ||
 	    (params->n_ssids == 1 && !params->ssids[0].ssid_len))
 		cp->flags |= IWL_SCAN_CHANNEL_FLAG_6G_PSC_NO_FILTER;
-- 
2.34.1


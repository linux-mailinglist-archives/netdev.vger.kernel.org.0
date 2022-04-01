Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42E4EF0A7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbiDAOgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347588AbiDAOdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F8F24F291;
        Fri,  1 Apr 2022 07:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26765B8250B;
        Fri,  1 Apr 2022 14:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F89FC340F2;
        Fri,  1 Apr 2022 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823399;
        bh=bQHH1mY6aTg8iDORT8gr9BI0rqtlsMuolgkU5jHa954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yl7PFo9UFC4CVnEkRdx6OkTYmC8fYv7LCFKMqeRWZrZL/CJ3/QAjzsu2EdUG5gOTk
         Kn8v0LUa2IpVB6bUX2892m5Wr8RJHKYfn9vv41h5/3KR5I2d55C7hTdT9Efe27DaYE
         hNeQmD7wLB22/ulFTAP3RGju4jkvaPUxcprgmQBA6HYx+hsCoQg85SW3NoP39p/1Gq
         WDCVhq8XjPyEZ2vUAHgspI74g+jswiqFnmTKoWEpX95RKgqRjyXWcXhxQWs5fvqEk+
         w93zD1/ufdI5mrtHtqZvliW6Wj24nA1RiwL41YuHH5XX3E4b2aS5PAtpwsNhtiTuGt
         n2fCbfJ67IE7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        ayala.beker@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 079/149] iwlwifi: mvm: Passively scan non PSC channels only when requested so
Date:   Fri,  1 Apr 2022 10:24:26 -0400
Message-Id: <20220401142536.1948161-79-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index 4cd507cb412d..630cfb64c6b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1735,27 +1735,37 @@ iwl_mvm_umac_scan_fill_6g_chan_list(struct iwl_mvm *mvm,
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
@@ -1875,8 +1885,16 @@ iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm_scan_params *params,
 		else
 			flags |= bssid_bitmap | (s_ssid_bitmap << 16);
 
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
@@ -2424,10 +2442,14 @@ static int iwl_mvm_scan_umac_v14_and_above(struct iwl_mvm *mvm,
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


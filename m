Return-Path: <netdev+bounces-405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 948FF6F761D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6684D28136D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6A8168AD;
	Thu,  4 May 2023 19:47:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB39168A3
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CC5C4339E;
	Thu,  4 May 2023 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229673;
	bh=JAPuOxWhBsan5hPSxnWhnAjp48qyhtSOWi8YeO40rHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cu1od6yiYl6+QhM4w1/uF1a9KVAn6x4jflQZmyuwKLDyyIm/6+u16vBgXWQxFY9C5
	 RmuIQlm71lBKFjECZXsRwanYkLR7wpHCBosERwP4PRajfg85f9ryKAHKwksTaXKYpy
	 o+mcKOdKqzYBrE4eCnGoEdzf3jOJjXMTwfF5ogfn38/mSSkBFBmdrcp+UGZWfWakop
	 YWoyRSzrUdWb6I3Z+diIWZQpP1Bn5GudsiDPyiLIge0Jd22sXd/sogEzdqMJm13os0
	 q36LsixosTRKG30pmsPHi9nSDfCxCp6vJUpRHbYntIR3aeUzePcsBq3doPTpEZwEy2
	 cB2ydHDjHy6Yw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	avraham.stern@intel.com,
	shaul.triebitz@intel.com,
	ilan.peer@intel.com,
	greearb@candelatech.com,
	mordechay.goodstein@intel.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 34/49] wifi: iwlwifi: fix iwl_mvm_max_amsdu_size() for MLO
Date: Thu,  4 May 2023 15:46:11 -0400
Message-Id: <20230504194626.3807438-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194626.3807438-1-sashal@kernel.org>
References: <20230504194626.3807438-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b2bc600cced23762d4e97db8989b18772145604f ]

For MLO, we cannot use vif->bss_conf.chandef.chan->band, since
that will lead to a NULL-ptr dereference as bss_conf isn't used.
However, in case of real MLO, we also need to take both LMACs
into account if they exist, since the station might be active
on both LMACs at the same time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230417113648.3588afc85d79.I11592893bbc191b9548518b8bd782de568a9f848@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 37 +++++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ba944175546d4..542cfcad6e0e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -788,10 +788,11 @@ unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
 				    struct ieee80211_sta *sta, unsigned int tid)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	enum nl80211_band band = mvmsta->vif->bss_conf.chandef.chan->band;
 	u8 ac = tid_to_mac80211_ac[tid];
+	enum nl80211_band band;
 	unsigned int txf;
-	int lmac = iwl_mvm_get_lmac_id(mvm->fw, band);
+	unsigned int val;
+	int lmac;
 
 	/* For HE redirect to trigger based fifos */
 	if (sta->deflink.he_cap.has_he && !WARN_ON(!iwl_mvm_has_new_tx_api(mvm)))
@@ -805,7 +806,37 @@ unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
 	 * We also want to have the start of the next packet inside the
 	 * fifo to be able to send bursts.
 	 */
-	return min_t(unsigned int, mvmsta->max_amsdu_len,
+	val = mvmsta->max_amsdu_len;
+
+	if (hweight16(sta->valid_links) <= 1) {
+		if (sta->valid_links) {
+			struct ieee80211_bss_conf *link_conf;
+			unsigned int link = ffs(sta->valid_links) - 1;
+
+			rcu_read_lock();
+			link_conf = rcu_dereference(mvmsta->vif->link_conf[link]);
+			if (WARN_ON(!link_conf))
+				band = NL80211_BAND_2GHZ;
+			else
+				band = link_conf->chandef.chan->band;
+			rcu_read_unlock();
+		} else {
+			band = mvmsta->vif->bss_conf.chandef.chan->band;
+		}
+
+		lmac = iwl_mvm_get_lmac_id(mvm->fw, band);
+	} else if (fw_has_capa(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_CAPA_CDB_SUPPORT)) {
+		/* for real MLO restrict to both LMACs if they exist */
+		lmac = IWL_LMAC_5G_INDEX;
+		val = min_t(unsigned int, val,
+			    mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
+		lmac = IWL_LMAC_24G_INDEX;
+	} else {
+		lmac = IWL_LMAC_24G_INDEX;
+	}
+
+	return min_t(unsigned int, val,
 		     mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
 }
 
-- 
2.39.2



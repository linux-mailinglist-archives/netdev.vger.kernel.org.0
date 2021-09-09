Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F58404D6B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344483AbhIIMCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346638AbhIIMAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C4C61462;
        Thu,  9 Sep 2021 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187969;
        bh=NtxiJotfvSHrPqcHKU2qSeQshjA17BTklKdd5THu/yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sesdug4dO3oeZLNxZ7sdvNeBJsT7L5uzFwfgJ0j8N9QbdgnnuWjZ+WebxhBBWMPU6
         zvdI1QveKgHJUKuMkLvreXh/Sqcv5uOU4mrIG/RQlNVJt7m91LTeT3pOiTnw1HvCU6
         tic9e3oyVs2Rr0CsginF7f4mLqDz8zdk6vUfwZtH+1G3LtJq2MqphdiEeBEvdk6HBL
         pC3+NBHnM2vRRroicsl6pM+WT9MFmW9dBJFElbZt0dnJRPKDF3ZV77Cs7P5AyclPNl
         91Wr6v7cMtbEt2wnbWbBdftUazd6j+CNoG2pOZTW25bS8l+Oafud5GycxvHTFgd1m8
         pKI62FGHHRfeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 233/252] iwlwifi: mvm: fix access to BSS elements
Date:   Thu,  9 Sep 2021 07:40:47 -0400
Message-Id: <20210909114106.141462-233-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6c608cd6962ebdf84fd3de6d42f88ed64d2f4e1b ]

BSS elements are protected using RCU, so we need to use
RCU properly to access them, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210805130823.fd8b5791ab44.Iba26800a6301078d3782fb249c476dd8ac2bf3c6@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 70ebecb73c24..79f44435972e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2987,16 +2987,20 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 						    void *_data)
 {
 	struct iwl_mvm_he_obss_narrow_bw_ru_data *data = _data;
+	const struct cfg80211_bss_ies *ies;
 	const struct element *elem;
 
-	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, bss->ies->data,
-				  bss->ies->len);
+	rcu_read_lock();
+	ies = rcu_dereference(bss->ies);
+	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
+				  ies->len);
 
 	if (!elem || elem->datalen < 10 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
 	}
+	rcu_read_unlock();
 }
 
 static void iwl_mvm_check_he_obss_narrow_bw_ru(struct ieee80211_hw *hw,
-- 
2.30.2


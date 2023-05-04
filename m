Return-Path: <netdev+bounces-385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB9D6F755B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35FB21C21486
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC410964;
	Thu,  4 May 2023 19:46:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDE610944
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD14C433D2;
	Thu,  4 May 2023 19:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229562;
	bh=RsNOV0EPmfZckX+21rdsSrb+cHo2tv2tYFdzs7k/Z+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWkI/XuvjUCJGXciY+Sur2ZS9bUnP4mj7FimUKHa9m4jUbSRSvbVH5/AHHiXJGXWc
	 yKQgNeg8OvtPaSG9Es8lmwvNC3DuC3KCUqrEJH58I/Upu6yxAebw+rtVPYwkjSr9Z9
	 i8vP72zGVthtrYkRx4yi0/BIWVkWR1stVuNtickW2MGiDUAW+pRcRw0/9AT72I4qsX
	 4SG1voIsWiPHPEMA73K8+tsN64tW849hJULOdrR4EdsDLyTD4UHusANTwfaTLnKhf2
	 i8VrpNjyyixSNlM46t27R3JimVW341u3EpGxqL0drY8uZa2WIUGla80kkvaAXB5ok/
	 GWVVGNpHkEggg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	gregory.greenman@intel.com,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	benjamin.berg@intel.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 39/53] wifi: iwlwifi: dvm: Fix memcpy: detected field-spanning write backtrace
Date: Thu,  4 May 2023 15:43:59 -0400
Message-Id: <20230504194413.3806354-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194413.3806354-1-sashal@kernel.org>
References: <20230504194413.3806354-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ef16799640865f937719f0771c93be5dca18adc6 ]

A received TKIP key may be up to 32 bytes because it may contain
MIC rx/tx keys too. These are not used by iwl and copying these
over overflows the iwl_keyinfo.key field.

Add a check to not copy more data to iwl_keyinfo.key then will fit.

This fixes backtraces like this one:

 memcpy: detected field-spanning write (size 32) of single field "sta_cmd.key.key" at drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103 (size 16)
 WARNING: CPU: 1 PID: 946 at drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103 iwlagn_send_sta_key+0x375/0x390 [iwldvm]
 <snip>
 Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A21 05/08/2017
 RIP: 0010:iwlagn_send_sta_key+0x375/0x390 [iwldvm]
 <snip>
 Call Trace:
  <TASK>
  iwl_set_dynamic_key+0x1f0/0x220 [iwldvm]
  iwlagn_mac_set_key+0x1e4/0x280 [iwldvm]
  drv_set_key+0xa4/0x1b0 [mac80211]
  ieee80211_key_enable_hw_accel+0xa8/0x2d0 [mac80211]
  ieee80211_key_replace+0x22d/0x8e0 [mac80211]
 <snip>

Link: https://www.alionet.org/index.php?topic=1469.0
Link: https://lore.kernel.org/linux-wireless/20230218191056.never.374-kees@kernel.org/
Link: https://lore.kernel.org/linux-wireless/68760035-7f75-1b23-e355-bfb758a87d83@redhat.com/
Cc: Kees Cook <keescook@chromium.org>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index cef43cf80620a..8b01ab986cb13 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -1081,6 +1081,7 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 {
 	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
+	size_t to_copy;
 	int i;
 
 	spin_lock_bh(&priv->sta_lock);
@@ -1100,7 +1101,9 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 		sta_cmd.key.tkip_rx_tsc_byte2 = tkip_iv32;
 		for (i = 0; i < 5; i++)
 			sta_cmd.key.tkip_rx_ttak[i] = cpu_to_le16(tkip_p1k[i]);
-		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
+		/* keyconf may contain MIC rx/tx keys which iwl does not use */
+		to_copy = min_t(size_t, sizeof(sta_cmd.key.key), keyconf->keylen);
+		memcpy(sta_cmd.key.key, keyconf->key, to_copy);
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
-- 
2.39.2



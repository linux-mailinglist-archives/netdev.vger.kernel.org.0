Return-Path: <netdev+bounces-421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEA76F769E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FD47281215
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CEA17AC1;
	Thu,  4 May 2023 19:49:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD7F4ED
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6873AC433EF;
	Thu,  4 May 2023 19:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229766;
	bh=tHNCniWDgY4VtmfVvTqf1L/rTVX3QQEKktO4dpi2r9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opf6x6KYbqYlr7EqR1K+7NhyJGTlReWaOqnKJuBekhuUQBLJUOxx6k/1b7gkEgeJg
	 yj95wRFPL+76WIfHVXZKGuSFUoHdq9QJN5MOMm4FtUmaGd9mLASqByXdD77ueWtwQM
	 bwnlOBoZ2TqKtwC5NbDch81ZNpQOqiCuUU4CwNIHuWY3HpUGEOrzYQMLtaZYGDtsue
	 4cTY8C+myb7P1kOvqGdc9LhzNUebS2Oa4S6c27lnsyP6fFZB0E2ga+dNPgwk57xvK0
	 L4dvf/S98U7CnezsPVMOMwqP806NcnVwsjqaI889i8Ckp4baA1S8jlCJIb31OZKs6D
	 dlVXgVzoEaxYw==
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
Subject: [PATCH AUTOSEL 5.15 24/30] wifi: iwlwifi: dvm: Fix memcpy: detected field-spanning write backtrace
Date: Thu,  4 May 2023 15:48:17 -0400
Message-Id: <20230504194824.3808028-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194824.3808028-1-sashal@kernel.org>
References: <20230504194824.3808028-1-sashal@kernel.org>
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
index ddc14059b07d1..7c3168145e58a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -1086,6 +1086,7 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 {
 	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
+	size_t to_copy;
 	int i;
 
 	spin_lock_bh(&priv->sta_lock);
@@ -1105,7 +1106,9 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
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



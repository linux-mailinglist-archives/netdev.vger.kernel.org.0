Return-Path: <netdev+bounces-392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B411D6F75A9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0D061C20FD2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87641548F;
	Thu,  4 May 2023 19:46:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D07F15484
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34CDC433EF;
	Thu,  4 May 2023 19:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229590;
	bh=Wn4gTbf57LwpDRCHeR+QJZofpS9uoSncq21OSvW/Kd4=;
	h=From:To:Cc:Subject:Date:From;
	b=BsrZBQe7OwLK7GQ2QigABoltvwm/4jzzfF7pDWyHNMZYmkTWqZOaRhlin4K0a4k0J
	 1x/SX6kl/JcFAcTYLO9NK6STkIiUaPYPxfWmrVrZ1E/H3L+f98a2BWYnGcUdC5oxQk
	 BSSqWNJKppo2qsHWI3RM9VkXJNK7uJf7yYIWWiB9017nCShOULjjwsyxwhJozShC2s
	 xmu0Q2b8dr/iXbO31uljOfX9dFfy+RGSdMmCoWX8s+NboeLkCPIeCwvL/hF34QjD+q
	 UCXiylUKJENX+yhkYCY+BhN6vYHhbX6HaQ0kQeU1pdHpZ44ElVSqnM/u++rs4BeIaH
	 2Pnuf86hgYpNg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 01/49] wifi: ath: Silence memcpy run-time false positive warning
Date: Thu,  4 May 2023 15:45:38 -0400
Message-Id: <20230504194626.3807438-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit bfcc8ba45eb87bfaaff900bbad2b87b204899d41 ]

The memcpy() in ath_key_config() was attempting to write across
neighboring struct members in struct ath_keyval. Introduce a wrapping
struct_group, kv_values, to be the addressable target of the memcpy
without overflowing an individual member. Silences the false positive
run-time warning:

  memcpy: detected field-spanning write (size 32) of single field "hk.kv_val" at drivers/net/wireless/ath/key.c:506 (size 16)

Link: https://bbs.archlinux.org/viewtopic.php?id=282254
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230210054310.never.554-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath.h | 12 +++++++-----
 drivers/net/wireless/ath/key.c |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f083fb9038c36..f02a308a9ffc5 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -96,11 +96,13 @@ struct ath_keyval {
 	u8 kv_type;
 	u8 kv_pad;
 	u16 kv_len;
-	u8 kv_val[16]; /* TK */
-	u8 kv_mic[8]; /* Michael MIC key */
-	u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
-			 * supports both MIC keys in the same key cache entry;
-			 * in that case, kv_mic is the RX key) */
+	struct_group(kv_values,
+		u8 kv_val[16]; /* TK */
+		u8 kv_mic[8]; /* Michael MIC key */
+		u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
+				 * supports both MIC keys in the same key cache entry;
+				 * in that case, kv_mic is the RX key) */
+	);
 };
 
 enum ath_cipher {
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 61b59a804e308..b7b61d4f02bae 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -503,7 +503,7 @@ int ath_key_config(struct ath_common *common,
 
 	hk.kv_len = key->keylen;
 	if (key->keylen)
-		memcpy(hk.kv_val, key->key, key->keylen);
+		memcpy(&hk.kv_values, key->key, key->keylen);
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		switch (vif->type) {
-- 
2.39.2



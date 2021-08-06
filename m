Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB33E316A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245394AbhHFVvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245378AbhHFVvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 17:51:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3C9C061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 14:51:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u2so8841931plg.10
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 14:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWEiCkw+fSiz6EiygCnTJiJ8o5BtcEILDKNkLL6Uu3s=;
        b=BX3+BEAylAbE/hNGLDIXMbDFoR+/KM+Z/rF4MghjRq7IjV4KWs0jpcGEkJ6fKEsODl
         Sljvlv9qUJMBY5XiRx9uKD/LhdqKaGq6TLZPuICLdBGv1ppOSNElnsGhKuN4jDK9cpni
         2w2ZKDN5VMjaV5qs5QjjNdjIC11LlKq5QilWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWEiCkw+fSiz6EiygCnTJiJ8o5BtcEILDKNkLL6Uu3s=;
        b=ZlJ6Vla5D3Lu5Otl3yAh9jakyAMFCsUPmF5OEGPJc9OMxWnRI3EpiNMpmTua9rhAqS
         fJe9nzaE3RbQSLxGIh1fA2/lyPg4xRs5q9ZLcOB6wrLqNNXSyRAzWpSAETziLo4P+Ovb
         cc/HQhlAiqHjOLBlmPU6Z+UfIinkT7z4B25SN1eY78dlvk2avCrEv7DDh8AQeGeJLoTb
         UKmeuQc94do4WgqyrjIAvRXdEWGBItzfwH2BhsQ7fumB2OfSphGQbr0h/0dX46D+yec6
         U5RseWZKKIfB1lLwECYftiELqJEbOhAyqNXFs9zUz8IbgVcUVupb+2C0FwYRRBfAZ8/0
         nfhg==
X-Gm-Message-State: AOAM532iUXLs0XfLp/Q88TCYFxe/kBasCGwNkc6sSdWK7SdNHZqwaCqc
        7UbOzL6QonJwGOrpGMByNX05+g==
X-Google-Smtp-Source: ABdhPJz6V63GlXJdSmLLP/MTaSIOKcIhloT+lM9y1AYLFfR1I8ESY4FgdjJkGIx6PLfRg6qjDqmUnQ==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr12475598pfc.70.1628286674964;
        Fri, 06 Aug 2021 14:51:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y2sm10734979pjl.6.2021.08.06.14.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:51:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kees Cook <keescook@chromium.org>, David Sterba <dsterba@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] mac80211: radiotap: Use BIT() instead of shifts
Date:   Fri,  6 Aug 2021 14:51:12 -0700
Message-Id: <20210806215112.2874773-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8683; h=from:subject; bh=czSMCGdMP4Zyrr8fUtCTJKV3QkH9XMp2P84y9iqGzvE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhDa7Q05vzCyv/C+X37SFm9tonPHNTDPmeDyfL6WJM WkJDsZeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQ2u0AAKCRCJcvTf3G3AJtu4D/ 9A0n0fkYoVF8zOcW4lzqhOH07vbnwGmnmVpT5O2rGg06I/UNQb+aRBQMa829A3FDw6fcXwgBe5sY6N 8EHPntfbYtlXviGJbn8pwD4kW412i9EkJcTvNMsg77pSGe0q+UhfRNCp+aGY4y5yXbKhAnFGUFBQIs IoJ91oCvEEcjSZS3cUvERUUd5ZyqfAcB6Eof/qUE1+kUyNooIwvDITDWi6LvlGQsa4mwvn5sJzRAJ6 rIAmQ92s2nVPwLpMhhT4ASNMmjiqAlTE+p7bBdHe/lZ0yDV5U1kP8CbP5vkFmNvNNuNJLyeLXVSdye 1OgWpKWJI8I3Tag3wFyiziPzMEILbN28XB5W7tIwKC68FfBAdAX2Nym4aufAyaGLuY5mzvgQTP4vIE 2eVEin4OZzRMGgntdVZWXFGEdHVOqrvERClSqA/ttEBP+0ayFvqmYQDCaPIqTF7cWEgkaYl8ChhxCp 87ILfTh+5N+GGQWCmCRYcy3gdUD/R5ZJkCMBNfXy9VenyN5O6kSo5ZawqC+/aP2mtyZxRzAMuDpRqa OMJdnxN97T9OYKHTZC5uKvjVW3Ny8Icp5u2QPPecYL240muMsKE6vSYgMXMddFMfUJlrXEZYGZ3Ssu heeaGoUa6GKH6XLFykaCXSrPGZDo1XP1s72Ys09ItwmovFscP3HhNjUmXgEg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE80211_RADIOTAP_EXT has a value of 31, which means if shift was ever
cast to 64-bit, the result would become sign-extended. As a matter of
robustness, just replace all the open-coded shifts with BIT().

Suggested-by: David Sterba <dsterba@suse.cz>
Link: https://lore.kernel.org/lkml/20210728092323.GW5047@twin.jikos.cz/
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac80211/rx.c       | 22 +++++++++++-----------
 net/mac80211/status.c   | 16 ++++++++--------
 net/wireless/radiotap.c |  4 ++--
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2563473b5cf1..3eb7b03b23c6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -372,7 +372,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			ieee80211_calculate_rx_timestamp(local, status,
 							 mpdulen, 0),
 			pos);
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_TSFT));
 		pos += 8;
 	}
 
@@ -396,7 +396,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = 0;
 	} else {
 		int shift = 0;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_RATE));
 		if (status->bw == RATE_INFO_BW_10)
 			shift = 1;
 		else if (status->bw == RATE_INFO_BW_5)
@@ -433,7 +433,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_DBM_ANTSIGNAL));
 		pos++;
 	}
 
@@ -459,7 +459,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->encoding == RX_ENC_HT) {
 		unsigned int stbc;
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_MCS));
 		*pos++ = local->hw.radiotap_mcs_details;
 		*pos = 0;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
@@ -483,7 +483,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		while ((pos - (u8 *)rthdr) & 3)
 			pos++;
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_AMPDU_STATUS));
 		put_unaligned_le32(status->ampdu_reference, pos);
 		pos += 4;
 		if (status->flag & RX_FLAG_AMPDU_LAST_KNOWN)
@@ -510,7 +510,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->encoding == RX_ENC_VHT) {
 		u16 known = local->hw.radiotap_vht_details;
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_VHT));
 		put_unaligned_le16(known, pos);
 		pos += 2;
 		/* flags */
@@ -554,7 +554,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		u8 flags = IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT;
 
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_TIMESTAMP);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_TIMESTAMP));
 
 		/* ensure 8 byte alignment */
 		while ((pos - (u8 *)rthdr) & 7)
@@ -642,7 +642,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_HE));
 		memcpy(pos, &he, sizeof(he));
 		pos += sizeof(he);
 	}
@@ -652,14 +652,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE_MU);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_HE_MU));
 		memcpy(pos, &he_mu, sizeof(he_mu));
 		pos += sizeof(he_mu);
 	}
 
 	if (status->flag & RX_FLAG_NO_PSDU) {
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_ZERO_LEN_PSDU);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_ZERO_LEN_PSDU));
 		*pos++ = status->zero_length_psdu_type;
 	}
 
@@ -667,7 +667,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_LSIG);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_LSIG));
 		memcpy(pos, &lsig, sizeof(lsig));
 		pos += sizeof(lsig);
 	}
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index bae321ff77f6..1f295e5721ef 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -305,8 +305,8 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 	memset(rthdr, 0, rtap_len);
 	rthdr->it_len = cpu_to_le16(rtap_len);
 	rthdr->it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES));
+		cpu_to_le32(BIT(IEEE80211_RADIOTAP_TX_FLAGS) |
+			    BIT(IEEE80211_RADIOTAP_DATA_RETRIES));
 	pos = (unsigned char *)(rthdr + 1);
 
 	/*
@@ -331,7 +331,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 			sband->bitrates[info->status.rates[0].idx].bitrate;
 
 	if (legacy_rate) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_RATE));
 		*pos = DIV_ROUND_UP(legacy_rate, 5 * (1 << shift));
 		/* padding for tx flags */
 		pos += 2;
@@ -358,7 +358,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 
 	if (status && status->rate &&
 	    (status->rate->flags & RATE_INFO_FLAGS_MCS)) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_MCS));
 		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
 			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
@@ -374,7 +374,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 			(IEEE80211_RADIOTAP_VHT_KNOWN_GI |
 			 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH);
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_VHT));
 
 		/* required alignment from rthdr */
 		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
@@ -419,7 +419,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 		   (status->rate->flags & RATE_INFO_FLAGS_HE_MCS)) {
 		struct ieee80211_radiotap_he *he;
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_HE));
 
 		/* required alignment from rthdr */
 		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
@@ -495,7 +495,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_MCS
 	 * IEEE80211_RADIOTAP_VHT */
 	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_MCS));
 		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
 			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
@@ -512,7 +512,7 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 			(IEEE80211_RADIOTAP_VHT_KNOWN_GI |
 			 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH);
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_VHT));
 
 		/* required alignment from rthdr */
 		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 36f1b59a78bf..8099c9564a59 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -125,13 +125,13 @@ int ieee80211_radiotap_iterator_init(
 
 	/* find payload start allowing for extended bitmap(s) */
 
-	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+	if (iterator->_bitmap_shifter & (BIT(IEEE80211_RADIOTAP_EXT))) {
 		if ((unsigned long)iterator->_arg -
 		    (unsigned long)iterator->_rtheader + sizeof(uint32_t) >
 		    (unsigned long)iterator->_max_length)
 			return -EINVAL;
 		while (get_unaligned_le32(iterator->_arg) &
-					(1 << IEEE80211_RADIOTAP_EXT)) {
+					(BIT(IEEE80211_RADIOTAP_EXT))) {
 			iterator->_arg += sizeof(uint32_t);
 
 			/*
-- 
2.30.2


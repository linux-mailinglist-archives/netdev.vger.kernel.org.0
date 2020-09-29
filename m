Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB8B27BA38
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgI2Bga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgI2Bav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87043221E8;
        Tue, 29 Sep 2020 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343051;
        bh=Teh2OF51j5GQpR2E2cre2gfVUdcI0zZAKAiH2EDcWUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGf1Z00mm6AlDf6pMULyaGH5znikdPs8mtUZOrbp3mFX23LuJs87e4YhGANxM6I4r
         PtwKs7kmuNHBQH3dQvRoIQt+vTL4cQtBJrssh+hUoNnwltDB1r/pi9V2KpVVdFJEnQ
         /IFAvviaeSk0a7dmYNNhwot4FmBX9Y1z1cGjd3mc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aloka Dixit <alokad@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 18/29] mac80211: Fix radiotap header channel flag for 6GHz band
Date:   Mon, 28 Sep 2020 21:30:15 -0400
Message-Id: <20200929013027.2406344-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aloka Dixit <alokad@codeaurora.org>

[ Upstream commit 412a84b5714af56f3eb648bba155107b5edddfdf ]

Radiotap header field 'Channel flags' has '2 GHz spectrum' set to
'true' for 6GHz packet.
Change it to 5GHz as there isn't a separate option available for 6GHz.

Signed-off-by: Aloka Dixit <alokad@codeaurora.org>
Link: https://lore.kernel.org/r/010101747ab7b703-1d7c9851-1594-43bf-81f7-f79ce7a67cc6-000000@us-west-2.amazonses.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c5af4b5fc080..f2c3ac648fc08 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -451,7 +451,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	else if (status->bw == RATE_INFO_BW_5)
 		channel_flags |= IEEE80211_CHAN_QUARTER;
 
-	if (status->band == NL80211_BAND_5GHZ)
+	if (status->band == NL80211_BAND_5GHZ ||
+	    status->band == NL80211_BAND_6GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
 	else if (status->encoding != RX_ENC_LEGACY)
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
-- 
2.25.1


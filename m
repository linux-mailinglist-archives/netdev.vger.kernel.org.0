Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78727B987
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgI2Bbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgI2Bb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1982922204;
        Tue, 29 Sep 2020 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343080;
        bh=E1UUb+UT5H5jKz1MdfScJ8hMsgsDOOU4qDs/5khlm5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tb7BVGW1NYxMjL5e05RFUlZEghVfxlU0yaJwlymbkmtoif+x2MupNGNRLvqVvLKS
         1ug4TlC4PitDkC5hiNYNE91vwPDp1tp2aABnmcQoj5BvcuFU0YaLvkLsfYM0meLqwi
         RcvIYIOuPgNXecBuGkVOA5QHnmmhLeu2mSdTeB/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aloka Dixit <alokad@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/18] mac80211: Fix radiotap header channel flag for 6GHz band
Date:   Mon, 28 Sep 2020 21:30:58 -0400
Message-Id: <20200929013105.2406634-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
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
index e5fb9002d3147..3ab85e1e38d82 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -419,7 +419,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
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


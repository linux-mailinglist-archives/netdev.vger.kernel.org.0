Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034BD3BD13C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhGFLiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhGFLfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843B5610F7;
        Tue,  6 Jul 2021 11:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570671;
        bh=bGPPZWBLMVLgaINi7y8s9K25vCFRqscWNsCygy0K0NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuNMC0aXhOlbVt7yVDRqJV7y2JeQCx+eDhu7EwZsNhU4wbppl6rfaFQnlYNjwK8AY
         pxGt8iOtcLLOOF/7Pby2P0F+XX2HQfwrIUUiL0bUoIzu1iKZk1rftFdcYw73Fzvq1O
         Cc8UVNtQ0moacChh/YJNKMVdQ1Sy6QAzKu9TGiVT+Y52UX9jQfN7mbg2NG4J/wBFMk
         fvZkKvZuAIqQax06H4lx3kWSs/jihQ86yyCtuBs0C4HVZFb3bw47lOBGJGjSOnIy4f
         xfSVYtgDpB5XP1Sf5pIsWPgR7kEYdSGfc12HbbwFu9tDVweMNP+2725uZL+eI4KNxI
         /U9tWZuruRkaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 114/137] cfg80211: fix default HE tx bitrate mask in 2G band
Date:   Tue,  6 Jul 2021 07:21:40 -0400
Message-Id: <20210706112203.2062605-114-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 9df66d5b9f45c39b3925d16e8947cc10009b186d ]

In 2G band, a HE sta can only supports HT and HE, but not supports VHT.
In this case, default HE tx bitrate mask isn't filled, when we use iw to
set bitrates without any parameter.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20210609075944.51130-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index daf3f29c7f0c..8fb0478888fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4625,11 +4625,10 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 		       sband->ht_cap.mcs.rx_mask,
 		       sizeof(mask->control[i].ht_mcs));
 
-		if (!sband->vht_cap.vht_supported)
-			continue;
-
-		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
-		vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
+		if (sband->vht_cap.vht_supported) {
+			vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+			vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
+		}
 
 		he_cap = ieee80211_get_he_iftype_cap(sband, wdev->iftype);
 		if (!he_cap)
-- 
2.30.2


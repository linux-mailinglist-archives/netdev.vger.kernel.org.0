Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183F93BCDDF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbhGFLXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233100AbhGFLVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D90F61CDA;
        Tue,  6 Jul 2021 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570266;
        bh=AEFMNni0q72L8/+5niW7zEZN13RimeOt/iWZevfRFVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/CvIf0IaYzNfLyqT+gzRIUDQhMrmAcvIna9w2vhKnBM7x3wl1RwF4j/vUy90taj7
         CkPbwAUMlv62PcUbvByfs8U2HF2t+EI30OPCbiGZu9C1cluksPdQGB/dy9+Pzqg/zO
         6+tB4Ur5DnXVdK4sYRKoLyBz4kz2TGK87cXGtrzyqFgfkNWzWw30W3/zEYw4CDx2rm
         ZYHMczJO2mC28BSdGVURpzje7IoEupfBDbH69kE5TKRR9tzhUD3fGmyEci7A21BBx8
         ase+kNo1WnynltLqKjAotYh3HQFtk1vezNALpjOaSHBT4nt5hZE5D3/pP0oqxt25fo
         corgHEur1eJdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 161/189] cfg80211: fix default HE tx bitrate mask in 2G band
Date:   Tue,  6 Jul 2021 07:13:41 -0400
Message-Id: <20210706111409.2058071-161-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index fc9286afe3c9..912977bf3ec8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4781,11 +4781,10 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
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


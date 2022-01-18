Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F64B4915EA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345893AbiARCcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344711AbiARCam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06E1C0613A9;
        Mon, 17 Jan 2022 18:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2A560AAF;
        Tue, 18 Jan 2022 02:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33618C36AF5;
        Tue, 18 Jan 2022 02:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472852;
        bh=PVYBpWgLxzFqn93XSAf0x7uJa2crGkS0cprCA6JoWiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmQIS5I56YTs5s2TjBtTZJO0tG1CVN46V/PtifFNEJTBlBbQORyg181c2lzMW51SB
         cPrUZpPqjsMiECSX4w6NWgLdBnzy6TXKtuToJUKJuzcu4PwhyHpJwvYbMiMMKiKIHQ
         pHMK06GOS6a03eJasClJbOClwlWWLIZFYNv9qf1qv1V5mFihpni6W+YgqAsOXLQmz1
         Ar60yRQLtWf8X8WRYtMT7ZO9ChRoPkPCzpO8p1hrIX7pinDMK4ZQ2Yy5KqZ21XCtRo
         t5nlsOvAq5AYmn0+3wWlpq6MYEFIGuWcLWgElaUEL/grf3dZ7h+PH4GTCRePGMJMLN
         a5RopO8FHvKRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 154/217] mt76: connac: fix a theoretical NULL pointer dereference in mt76_connac_get_phy_mode
Date:   Mon, 17 Jan 2022 21:18:37 -0500
Message-Id: <20220118021940.1942199-154-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c9dbeac4988f6d4c4211b3747ec9c9c75ea87967 ]

Even if it is not a real bug since mt76_connac_get_phy_mode runs just
for mt7921 where only STA is supported, fix a theoretical NULL pointer
dereference if new added modes do not support HE

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 26b4b875dcc02..bcb596664b3e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1179,7 +1179,7 @@ mt76_connac_get_phy_mode(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		if (ht_cap->ht_supported)
 			mode |= PHY_MODE_GN;
 
-		if (he_cap->has_he)
+		if (he_cap && he_cap->has_he)
 			mode |= PHY_MODE_AX_24G;
 	} else if (band == NL80211_BAND_5GHZ || band == NL80211_BAND_6GHZ) {
 		mode |= PHY_MODE_A;
@@ -1190,7 +1190,7 @@ mt76_connac_get_phy_mode(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		if (vht_cap->vht_supported)
 			mode |= PHY_MODE_AC;
 
-		if (he_cap->has_he) {
+		if (he_cap && he_cap->has_he) {
 			if (band == NL80211_BAND_6GHZ)
 				mode |= PHY_MODE_AX_6G;
 			else
-- 
2.34.1


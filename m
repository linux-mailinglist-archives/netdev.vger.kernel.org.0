Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB53BD120
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhGFLi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236744AbhGFLfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DDA61E1A;
        Tue,  6 Jul 2021 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570649;
        bh=ZxhQ/s8KZpLwV9wFhgLlnsSd4+04GTiheMdXUWADhsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOQVM3nrbqpkXwyxTrR7xomE7wnW1DTa7CqC2OnX7HY/jyLa4ezfbeiG5bW5GTBAj
         ZA4H+GuFZRZAP/8kQNNz/bHtbyNVZlp9K3P0ya8lq+liTcyPBuOzsRfo4eR2O+rMA0
         2M21KAab8ifZRPm/P60CA5vShO2WjdFr3jP9hJb2EUlNqDzPZi/JBGaVEfZjfePJ8Q
         E8DJguI3AyA3+Id4mr4f4eqqbR1a6tZcXaycQrjyI1NpxWwfGk/oKznKwdl9ImuBJ+
         w2i5smrIn0+V60zi+80JzJzyaV7TejFpZE6PJ8kw+AayREL8gqCwTIVvO6z8a7nR7O
         +UHCI/XdHBPvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 097/137] mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode
Date:   Tue,  6 Jul 2021 07:21:23 -0400
Message-Id: <20210706112203.2062605-97-sashal@kernel.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 2707ff4dd7b1479dbd44ebb3c74788084cc95245 ]

The value of station mode is always 0.

Fixed: 00b2e16e0063 ("mt76: mt7915: add TxBF capabilities")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 0232b66acb4f..8f01ca1694bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -335,6 +335,9 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
 	if (nss < 2)
 		return;
 
+	/* the maximum cap is 4 x 3, (Nr, Nc) = (3, 2) */
+	elem->phy_cap_info[7] |= min_t(int, nss - 1, 2) << 3;
+
 	if (vif != NL80211_IFTYPE_AP)
 		return;
 
@@ -348,9 +351,6 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
 	c = IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
 	    IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB;
 	elem->phy_cap_info[6] |= c;
-
-	/* the maximum cap is 4 x 3, (Nr, Nc) = (3, 2) */
-	elem->phy_cap_info[7] |= min_t(int, nss - 1, 2) << 3;
 }
 
 static void
-- 
2.30.2


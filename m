Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65C53BD043
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhGFLdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhGFL3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBAA461D94;
        Tue,  6 Jul 2021 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570453;
        bh=PYndkoxT8VJSQCBBjAEcCYBPObdOP0m3A43bg4uEqJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9iX0r272KaqvZ7n7SGNw3Qejkk3pdMVIOimBMuYCIg4KqkVMhAfEFzGxur7YViaI
         /wC08r0uE+AinizUVMLxMgGwbcIEum8sEdukNrt2sWyRMBh3wG+k+9UtFUd6ntMGRL
         z8xsLD/IRa+Eq32QFZZSQvGloLoLCbaS9OMAI2G8Eb1xT3wu+aFMFbKv/xCKZUIufq
         14EHWLotIMkPXHZsRSstfwGFx58MQO4t9QNsKi51cY3yYVWgSLI2myXKneLAoPgcay
         8tkgliSAkSKt3RLASNN2ZeDtrzXheRCsF1OrwdFnN8E3uWqaiHW5QsSxqhy+IVrOIE
         0FWwn0YkqR+HA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 110/160] mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode
Date:   Tue,  6 Jul 2021 07:17:36 -0400
Message-Id: <20210706111827.2060499-110-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index c7d4268d860a..5ab34606c021 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -452,6 +452,9 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
 	if (nss < 2)
 		return;
 
+	/* the maximum cap is 4 x 3, (Nr, Nc) = (3, 2) */
+	elem->phy_cap_info[7] |= min_t(int, nss - 1, 2) << 3;
+
 	if (vif != NL80211_IFTYPE_AP)
 		return;
 
@@ -465,9 +468,6 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
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


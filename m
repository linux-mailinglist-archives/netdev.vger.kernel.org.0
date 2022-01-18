Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DBB4919CA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351930AbiARC4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348370AbiARCpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DCEC08EAD5;
        Mon, 17 Jan 2022 18:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 714E261118;
        Tue, 18 Jan 2022 02:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3F0C36AE3;
        Tue, 18 Jan 2022 02:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473484;
        bh=RrUyY9uG7ZVfU+KF3Jfwg3xQPcg+XRDfLecSIqdmf5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyY1Zca72zC+61swKTu+RyJM7pdzJva2os8UKkJKhW5dJIS9OeuhuiuCbHkBItDcq
         mXr5GzmlnO7b1wo2NsK23pDDkOg1SgdJPygWtOti4ERNTBBcV1nvBxC6U0j3FpN70a
         yEnhA3q3yrYVhYWdgpy0mzABb2fjaQMrzaxxOPJ8WSDBOWFKWWb/1CeZPHFXMtiUZ6
         4olls587tvEYIQdTXA0MCjNjuUPLbOZ+It7RFBFa86Yc+buB7taTshafv4TRbanIFI
         b6tnYeUo5/zpiF9/7CDqDWp+Sl2kKZKVsfpVfpGy80e2TvQdhR0bLRReOxQz2MOFwJ
         vrpDuDd0W38kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xing Song <xing.song@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, greearb@candelatech.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 131/188] mt76: do not pass the received frame with decryption error
Date:   Mon, 17 Jan 2022 21:30:55 -0500
Message-Id: <20220118023152.1948105-131-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit dd28dea52ad9376d2b243a8981726646e1f60b1a ]

MAC80211 doesn't care any decryption error in 802.3 path, so received
frame will be dropped if HW tell us that the cipher configuration is not
matched as well as the header has been translated to 802.3. This case only
appears when IEEE80211_FCTL_PROTECTED is 0 and cipher suit is not none in
the corresponding HW entry.

The received frame is only reported to monitor interface if HW decryption
block tell us there is ICV error or CCMP/BIP/WPI MIC error. Note in this
case the reported frame is decrypted 802.11 frame and the payload may be
malformed due to mismatched key.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 9 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 9 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 9 ++++++++-
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 3972c56136a20..65f1f2bb80835 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -525,6 +525,10 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
 	if (rxd2 & MT_RXD2_NORMAL_TKIP_MIC_ERR)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
+	/* ICV error or CCMP/BIP/WPI MIC error */
+	if (rxd2 & MT_RXD2_NORMAL_ICV_ERR)
+		status->flag |= RX_FLAG_ONLY_MONITOR;
+
 	if (FIELD_GET(MT_RXD2_NORMAL_SEC_MODE, rxd2) != 0 &&
 	    !(rxd2 & (MT_RXD2_NORMAL_CLM | MT_RXD2_NORMAL_CM))) {
 		status->flag |= RX_FLAG_DECRYPTED;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 5455231f51881..f2704149834a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -286,9 +286,16 @@ static int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 	if (rxd2 & MT_RXD2_NORMAL_AMSDU_ERR)
 		return -EINVAL;
 
+	hdr_trans = rxd1 & MT_RXD1_NORMAL_HDR_TRANS;
+	if (hdr_trans && (rxd2 & MT_RXD2_NORMAL_CM))
+		return -EINVAL;
+
+	/* ICV error or CCMP/BIP/WPI MIC error */
+	if (rxd2 & MT_RXD2_NORMAL_ICV_ERR)
+		status->flag |= RX_FLAG_ONLY_MONITOR;
+
 	unicast = (rxd1 & MT_RXD1_NORMAL_ADDR_TYPE) == MT_RXD1_NORMAL_U2M;
 	idx = FIELD_GET(MT_RXD2_NORMAL_WLAN_IDX, rxd2);
-	hdr_trans = rxd1 & MT_RXD1_NORMAL_HDR_TRANS;
 	status->wcid = mt7615_rx_get_wcid(dev, idx, unicast);
 
 	if (status->wcid) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index bbc996f86b5c3..ff613d7056119 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -349,9 +349,16 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	if (rxd2 & MT_RXD2_NORMAL_AMSDU_ERR)
 		return -EINVAL;
 
+	hdr_trans = rxd2 & MT_RXD2_NORMAL_HDR_TRANS;
+	if (hdr_trans && (rxd1 & MT_RXD1_NORMAL_CM))
+		return -EINVAL;
+
+	/* ICV error or CCMP/BIP/WPI MIC error */
+	if (rxd1 & MT_RXD1_NORMAL_ICV_ERR)
+		status->flag |= RX_FLAG_ONLY_MONITOR;
+
 	unicast = FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3) == MT_RXD3_NORMAL_U2M;
 	idx = FIELD_GET(MT_RXD1_NORMAL_WLAN_IDX, rxd1);
-	hdr_trans = rxd2 & MT_RXD2_NORMAL_HDR_TRANS;
 	status->wcid = mt7915_rx_get_wcid(dev, idx, unicast);
 
 	if (status->wcid) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 8a16f3f4d5253..04a288029c98e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -383,10 +383,17 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 	if (rxd2 & MT_RXD2_NORMAL_AMSDU_ERR)
 		return -EINVAL;
 
+	hdr_trans = rxd2 & MT_RXD2_NORMAL_HDR_TRANS;
+	if (hdr_trans && (rxd1 & MT_RXD1_NORMAL_CM))
+		return -EINVAL;
+
+	/* ICV error or CCMP/BIP/WPI MIC error */
+	if (rxd1 & MT_RXD1_NORMAL_ICV_ERR)
+		status->flag |= RX_FLAG_ONLY_MONITOR;
+
 	chfreq = FIELD_GET(MT_RXD3_NORMAL_CH_FREQ, rxd3);
 	unicast = FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3) == MT_RXD3_NORMAL_U2M;
 	idx = FIELD_GET(MT_RXD1_NORMAL_WLAN_IDX, rxd1);
-	hdr_trans = rxd2 & MT_RXD2_NORMAL_HDR_TRANS;
 	status->wcid = mt7921_rx_get_wcid(dev, idx, unicast);
 
 	if (status->wcid) {
-- 
2.34.1


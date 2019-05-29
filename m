Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D12E044
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfE2Ozc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:55:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfE2Ozc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:55:32 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CE637923F8ECAF1FEEB2;
        Wed, 29 May 2019 22:55:27 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 22:55:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <royluo@google.com>,
        <kvalo@codeaurora.org>, <matthias.bgg@gmail.com>,
        <sgruszka@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mt76: Remove set but not used variables 'pid' and 'final_mpdu'
Date:   Wed, 29 May 2019 22:53:56 +0800
Message-ID: <20190529145356.13872-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warnings:

drivers/net/wireless/mediatek/mt76/mt7603/mac.c: In function mt7603_fill_txs:
drivers/net/wireless/mediatek/mt76/mt7603/mac.c:969:5: warning: variable pid set but not used [-Wunused-but-set-variable]
drivers/net/wireless/mediatek/mt76/mt7603/mac.c:961:7: warning: variable final_mpdu set but not used [-Wunused-but-set-variable]
drivers/net/wireless/mediatek/mt76/mt7615/mac.c: In function mt7615_fill_txs:
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:555:5: warning: variable pid set but not used [-Wunused-but-set-variable]
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:552:19: warning: variable final_mpdu set but not used [-Wunused-but-set-variable]

They are never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 4 ----
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 5 +----
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 6d506e34c3ee..5182a36276fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -958,7 +958,6 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	int final_idx = 0;
 	u32 final_rate;
 	u32 final_rate_flags;
-	bool final_mpdu;
 	bool ack_timeout;
 	bool fixed_rate;
 	bool probe;
@@ -966,7 +965,6 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	bool cck = false;
 	int count;
 	u32 txs;
-	u8 pid;
 	int idx;
 	int i;
 
@@ -974,9 +972,7 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 
 	txs = le32_to_cpu(txs_data[4]);
-	final_mpdu = txs & MT_TXS4_ACKED_MPDU;
 	ampdu = !fixed_rate && (txs & MT_TXS4_AMPDU);
-	pid = FIELD_GET(MT_TXS4_PID, txs);
 	count = FIELD_GET(MT_TXS4_TX_COUNT, txs);
 
 	txs = le32_to_cpu(txs_data[0]);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index b8f48d10f27a..a51bfb6990b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -549,23 +549,20 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 {
 	struct ieee80211_supported_band *sband;
 	int i, idx, count, final_idx = 0;
-	bool fixed_rate, final_mpdu, ack_timeout;
+	bool fixed_rate, ack_timeout;
 	bool probe, ampdu, cck = false;
 	u32 final_rate, final_rate_flags, final_nss, txs;
-	u8 pid;
 
 	fixed_rate = info->status.rates[0].count;
 	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 
 	txs = le32_to_cpu(txs_data[1]);
-	final_mpdu = txs & MT_TXS1_ACKED_MPDU;
 	ampdu = !fixed_rate && (txs & MT_TXS1_AMPDU);
 
 	txs = le32_to_cpu(txs_data[3]);
 	count = FIELD_GET(MT_TXS3_TX_COUNT, txs);
 
 	txs = le32_to_cpu(txs_data[0]);
-	pid = FIELD_GET(MT_TXS0_PID, txs);
 	final_rate = FIELD_GET(MT_TXS0_TX_RATE, txs);
 	ack_timeout = txs & MT_TXS0_ACK_TIMEOUT;
 
-- 
2.17.1



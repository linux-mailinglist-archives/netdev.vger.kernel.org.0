Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36A3BD5E2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbhGFMZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237188AbhGFLf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E85C61ECA;
        Tue,  6 Jul 2021 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570763;
        bh=oTXnUvz0slsKflEsBKdqqMyiiLfrMZBjJk4ARDbji2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aitDmLcF+O0WQSI4uELVI/MBfR24Xw5V/R/QUNjdxUdtY0grCx4anZdehGPeOyVBM
         iS4vUGOGNo7+V0vImnbqjEceqtrgvVmRp2hSqpS2D375nGFhGTn/Sqa/URH/6TB0SB
         TRKdZbWxyOGl0lEwJEpknAsa7SDh3P8loDOaHPj1JJ601ebdMkLYP6QcUQ+XFyT0o8
         Pj3EC1pnJEpkOJkjediZYFJDOiUgtmdtGj0FB9IeRP1U9+hvidxcNra+QcEplHdK5Z
         7omwgkaw3Jgwam+Re4ylNTB+AwxT7UjxOCK4RRuDUFKCIkgO3BegL66bX0CJJ269va
         1DPL/pfvRvr4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 48/74] mt76: mt7615: fix fixed-rate tx status reporting
Date:   Tue,  6 Jul 2021 07:24:36 -0400
Message-Id: <20210706112502.2064236-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ec8f1a90d006f7cedcf86ef19fd034a406a213d6 ]

Rely on the txs fixed-rate bit instead of info->control.rates

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 111e38ff954a..a6c530b9ceee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -840,22 +840,20 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 	int first_idx = 0, last_idx;
 	int i, idx, count;
 	bool fixed_rate, ack_timeout;
-	bool probe, ampdu, cck = false;
+	bool ampdu, cck = false;
 	bool rs_idx;
 	u32 rate_set_tsf;
 	u32 final_rate, final_rate_flags, final_nss, txs;
 
-	fixed_rate = info->status.rates[0].count;
-	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
-
 	txs = le32_to_cpu(txs_data[1]);
-	ampdu = !fixed_rate && (txs & MT_TXS1_AMPDU);
+	ampdu = txs & MT_TXS1_AMPDU;
 
 	txs = le32_to_cpu(txs_data[3]);
 	count = FIELD_GET(MT_TXS3_TX_COUNT, txs);
 	last_idx = FIELD_GET(MT_TXS3_LAST_TX_RATE, txs);
 
 	txs = le32_to_cpu(txs_data[0]);
+	fixed_rate = txs & MT_TXS0_FIXED_RATE;
 	final_rate = FIELD_GET(MT_TXS0_TX_RATE, txs);
 	ack_timeout = txs & MT_TXS0_ACK_TIMEOUT;
 
@@ -877,7 +875,7 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 
 	first_idx = max_t(int, 0, last_idx - (count + 1) / MT7615_RATE_RETRY);
 
-	if (fixed_rate && !probe) {
+	if (fixed_rate) {
 		info->status.rates[0].count = count;
 		i = 0;
 		goto out;
-- 
2.30.2


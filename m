Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD23BD5C3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhGFMYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236647AbhGFLfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B26B761DF6;
        Tue,  6 Jul 2021 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570640;
        bh=2yH1Q5BU3iPSLHbfiFuatKCYie8JbZm55iV0HyO/LBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5/PdCuozualgorYr393IMyewjkADtaJRcwYP4EfSWUbFHKafXX06ZfQwVGRh9cDG
         tTqSuVIxtzHr5y/pSE85VC5bf6fkA4KzCD6jcISe4i3XKawqhi7D5nvkZyUjGr+FzS
         K9qf53cKOlbsrjscmwRlLVDGKknIm0M1u/PzplJ0CBLuB+9ZkAGkc50akY5uvzPZK7
         Rfb2guTwtJB+qfduKFAvD0NNpvE1q7PpHzamJHyWtGSjWyZBHWaFSe41WsCkFRnpcA
         Cel6lQk0EHSvTYsxK06LlK6vdeeUkp6uU8PM9PX8tU/dM7g0kxhiik4AcCQqWKeKrN
         zyRyLgf0KucZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 090/137] mt76: mt7615: fix fixed-rate tx status reporting
Date:   Tue,  6 Jul 2021 07:21:16 -0400
Message-Id: <20210706112203.2062605-90-sashal@kernel.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ec8f1a90d006f7cedcf86ef19fd034a406a213d6 ]

Rely on the txs fixed-rate bit instead of info->control.rates

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 5795e44f8a52..f44f478bb970 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1177,22 +1177,20 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
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
 
@@ -1214,7 +1212,7 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 
 	first_idx = max_t(int, 0, last_idx - (count - 1) / MT7615_RATE_RETRY);
 
-	if (fixed_rate && !probe) {
+	if (fixed_rate) {
 		info->status.rates[0].count = count;
 		i = 0;
 		goto out;
-- 
2.30.2


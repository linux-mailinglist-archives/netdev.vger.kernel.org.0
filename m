Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64F119472
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfLJVN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbfLJVN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2110214AF;
        Tue, 10 Dec 2019 21:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012405;
        bh=qLpA8Hj/Bemhj0QN8KheWl81yCIKzadDZCnWM+wT4+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWTPuRBRL9oqkiZsne/R6P40FbVQJsAhf44cR38Ypa/s9F6PzUnC+jmbnIp0ExGjU
         YjU/YQFBwb5zWE5P3e6Uj7bs1w6zrftrePRgAGUhEs2vwV0R5b5WTptKTwNqXJRPFo
         khOH5MrfjQ686J8ltzFHiEPiOO3HGTT285+1tRzE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 324/350] mt76: fix possible out-of-bound access in mt7615_fill_txs/mt7603_fill_txs
Date:   Tue, 10 Dec 2019 16:07:09 -0500
Message-Id: <20191210210735.9077-285-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e8b970c8e367e85fab9b8ac4f36080e5d653c38e ]

Fix possible out-of-bound access of status rates array in
mt7615_fill_txs/mt7603_fill_txs routines

Fixes: c5211e997eca ("mt76: mt7603: rework and fix tx status reporting")
Fixes: 4af81f02b49c ("mt76: mt7615: sync with mt7603 rate control changes")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index c328192307c48..ff3f3d98b6252 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1032,8 +1032,10 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		if (idx && (cur_rate->idx != info->status.rates[i].idx ||
 			    cur_rate->flags != info->status.rates[i].flags)) {
 			i++;
-			if (i == ARRAY_SIZE(info->status.rates))
+			if (i == ARRAY_SIZE(info->status.rates)) {
+				i--;
 				break;
+			}
 
 			info->status.rates[i] = *cur_rate;
 			info->status.rates[i].count = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index e07ce2c100133..111e38ff954a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -914,8 +914,10 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 		if (idx && (cur_rate->idx != info->status.rates[i].idx ||
 			    cur_rate->flags != info->status.rates[i].flags)) {
 			i++;
-			if (i == ARRAY_SIZE(info->status.rates))
+			if (i == ARRAY_SIZE(info->status.rates)) {
+				i--;
 				break;
+			}
 
 			info->status.rates[i] = *cur_rate;
 			info->status.rates[i].count = 0;
-- 
2.20.1


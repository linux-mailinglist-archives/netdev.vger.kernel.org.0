Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44D233E319
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhCQA4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCQAzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EEC64F96;
        Wed, 17 Mar 2021 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942539;
        bh=eA7/9pe2sz93Lf4T19BPa+kc4xC7T19g9c4E0cRbi8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuo+uFgP2+plQlzAeYBolHZjH5Gx3DWlEdCyWT+Y2zOPeb07hOzWSsvYMZ44Mw+fX
         LpoRWlS575KPCrA22pamHZAJQkdBKts3MOIyBB+Pha7/uWtmaaAZ3SgIrLJoVVkIk1
         nkphnKNbakg1aZK3PiO91MXX2Vw1HEclOIJX3GmoikbDGJqwyfpcQ9oSOPK5W0U7Ih
         6NeVEAJ2G5uy6zZRLhs5M3IRnRYDxtXtQUX+lTlaOpGzdqJaTat9vAwAXoUQtm01P8
         DVa18BMMUoArIMI6DsyDckvez9C1mBgWuJbOl5BHCO/L622t//oqPzvrEaj6pFykSC
         6uOqTUMurbS7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 02/61] mt76: mt7915: only modify tx buffer list after allocating tx token id
Date:   Tue, 16 Mar 2021 20:54:36 -0400
Message-Id: <20210317005536.724046-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94f0e6256c2ab6803c935634aa1f653174c94879 ]

Modifying the tx buffer list too early can leak DMA mappings

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210216135119.23809-2-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 1b4d65310b88..c9dd6867e125 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -957,11 +957,6 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	}
 	txp->nbuf = nbuf;
 
-	/* pass partial skb header to fw */
-	tx_info->buf[1].len = MT_CT_PARSE_LEN;
-	tx_info->buf[1].skip_unmap = true;
-	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
-
 	txp->flags = cpu_to_le16(MT_CT_INFO_APPLY_TXD | MT_CT_INFO_FROM_HOST);
 
 	if (!key)
@@ -999,6 +994,11 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		txp->rept_wds_wcid = cpu_to_le16(0x3ff);
 	tx_info->skb = DMA_DUMMY_DATA;
 
+	/* pass partial skb header to fw */
+	tx_info->buf[1].len = MT_CT_PARSE_LEN;
+	tx_info->buf[1].skip_unmap = true;
+	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
+
 	return 0;
 }
 
-- 
2.30.1


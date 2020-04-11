Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2461A5B1A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgDKXrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbgDKXFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA92E21841;
        Sat, 11 Apr 2020 23:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646302;
        bh=w68oapllwXBcXuPwr+A/R2ShE4TVv5AB6GPxa7PIA1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3Dgskd7nGUMEBBHuGSQoYj9yAvax7I2NUvGpeeMCeNst65cbnSrMWJR9XUB+TW73
         lFmGYK41NlbIaA6lUJwqe8km3LmP5OhqNpuu/LA79a0A7ezSMTuJl1WeW6tFPpWXQB
         WCtpsCErDMA0Fk1xSpNfSitmywZnY1h1rVfRhYcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 061/149] mt76: fix handling full tx queues in mt76_dma_tx_queue_skb_raw
Date:   Sat, 11 Apr 2020 19:02:18 -0400
Message-Id: <20200411230347.22371-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 93eaec7625f13cffb593b471405b017c7e64d4ee ]

Fixes a theoretical issue where it could potentially overwrite an existing
descriptor entry (and leaking its skb)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1847f55e199b0..c001d94958d83 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -261,10 +261,13 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 
+	if (q->queued + 1 >= q->ndesc - 1)
+		goto error;
+
 	addr = dma_map_single(dev->dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev->dev, addr)))
-		return -ENOMEM;
+		goto error;
 
 	buf.addr = addr;
 	buf.len = skb->len;
@@ -275,6 +278,10 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	spin_unlock_bh(&q->lock);
 
 	return 0;
+
+error:
+	dev_kfree_skb(skb);
+	return -ENOMEM;
 }
 
 static int
-- 
2.20.1


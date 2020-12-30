Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9467A2E7A23
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgL3O7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 09:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3O7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 09:59:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C5921973;
        Wed, 30 Dec 2020 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609340310;
        bh=YmXXZasBhC28kFabVxJRx0dXwyd4dmoFQ/gA9h33sCo=;
        h=From:To:Cc:Subject:Date:From;
        b=UW34aLh145QaqjBnp+g6dzEwT+Oueu1jffOyUTwBaoepdYBlMQ/IvRhOH0OU79Ntx
         5rc6EZOchQ394ucyO/7FRiDl/DcRRqmb8gLpoO7saF8Caju+ZNt6ojeLTpId+v2emU
         BHA6nKigaeOQRewQxVSdBRQXeg6m85l3NhHeaGQv0+DXpI2599jM3ec3Lhtvd5gsFx
         QJ59lICWsUvlUFwnIOq0FwBRQ//WeqbdqetvUW/oki/c4bNz/GinNyw++/4hK9P+6i
         Cn+H+sKLrODLDOYgaISGmsOBtqeWDiOV9HB8omGlnvObaLRXttoSMAxttec22XtU8C
         sQoYl4Vh+5+HA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <objelf@gmail.com>,
        Wan-Feng Jiang <Wan-Feng.Jiang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: fix enum conversion warning
Date:   Wed, 30 Dec 2020 15:57:55 +0100
Message-Id: <20201230145824.3203726-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A recent patch changed some enum values, but not the type
declaration for the assignment:

drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: error: implicit conversion from enumeration type 'enum mt76_mcuq_id' to different enumeration type 'enum mt76_txq_id' [-Werror,-Wenum-conversion]
                qid = MT_MCUQ_WM;
                    ~ ^~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: error: implicit conversion from enumeration type 'enum mt76_mcuq_id' to different enumeration type 'enum mt76_txq_id' [-Werror,-Wenum-conversion]
                qid = MT_MCUQ_FWDL;
                    ~ ^~~~~~~~~~~~

Change the type to match again.

Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index a44b7766dec6..c13547841a4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -231,7 +231,7 @@ mt7615_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 			int cmd, int *seq)
 {
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
-	enum mt76_txq_id qid;
+	enum mt76_mcuq_id qid;
 
 	mt7615_mcu_fill_msg(dev, skb, cmd, seq);
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 5fdd1a6d32ee..22753fbb05e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -256,7 +256,7 @@ mt7915_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
 	struct mt7915_mcu_txd *mcu_txd;
 	u8 seq, pkt_fmt, qidx;
-	enum mt76_txq_id txq;
+	enum mt76_mcuq_id txq;
 	__le32 *txd;
 	u32 val;
 
-- 
2.29.2


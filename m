Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730EE4915D8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345761AbiARCcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41398 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343965AbiARC2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:28:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3984B8123F;
        Tue, 18 Jan 2022 02:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C1CC36AEF;
        Tue, 18 Jan 2022 02:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472902;
        bh=v+u+FK55eeNns6Q4kPKeSccsEGXeFL+oJr9NAaPDubA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eh40pJBmfGjObfNL8T8grpl6u2nXgr+ZxOR1yeUXkXCBQ8Jx9xhJKRWG4cK18Gvxn
         FWNcVY7K0Qy2HHntcW1q6CsMwWxggReF4xt8AnSoc3MgW3yPgK4GpsAL6TDA9RqQ+1
         QNo9YjdDEYLRIfsZrMMcGczB0L6i9rsdWSd1CuPPBagI2GTEvMCQJ70dI1krnP4I2v
         D0MbIFC4JVMZqObvSqH+JVYtsPlHpcvyzucta94FNkxTt/rYkNoqJq6qLWPRG2Zdnh
         HJEbL7UnIVza6GwOYdQff/6h8JRbmI/TWIr+FWq0kw/ibNuBit3oG4ttj5/eDL2LQa
         8sPFEDMpi0wkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, sean.wang@mediatek.com,
        Soul.Huang@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 157/217] mt76: mt7921: fix network buffer leak by txs missing
Date:   Mon, 17 Jan 2022 21:18:40 -0500
Message-Id: <20220118021940.1942199-157-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit e0bf699ad8e52330d848144a9624a067ad588bd6 ]

TXS in mt7921 may be forwared to tx_done event. Should try to catch
TXS information in tx_done event as well.

Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 14 ++++++++++
 .../net/wireless/mediatek/mt76/mt7921/mcu.h   | 27 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  1 +
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 27550385c35f9..4df272f93dd47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1072,7 +1072,7 @@ mt7921_mac_add_txs_skb(struct mt7921_dev *dev, struct mt76_wcid *wcid, int pid,
 	return !!skb;
 }
 
-static void mt7921_mac_add_txs(struct mt7921_dev *dev, void *data)
+void mt7921_mac_add_txs(struct mt7921_dev *dev, void *data)
 {
 	struct mt7921_sta *msta = NULL;
 	struct mt76_wcid *wcid;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 6ada1ebe7d68b..46ec9f713d772 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -418,6 +418,17 @@ mt7921_mcu_low_power_event(struct mt7921_dev *dev, struct sk_buff *skb)
 	trace_lp_event(dev, event->state);
 }
 
+static void
+mt7921_mcu_tx_done_event(struct mt7921_dev *dev, struct sk_buff *skb)
+{
+	struct mt7921_mcu_tx_done_event *event;
+
+	skb_pull(skb, sizeof(struct mt7921_mcu_rxd));
+	event = (struct mt7921_mcu_tx_done_event *)skb->data;
+
+	mt7921_mac_add_txs(dev, event->txs);
+}
+
 static void
 mt7921_mcu_rx_unsolicited_event(struct mt7921_dev *dev, struct sk_buff *skb)
 {
@@ -445,6 +456,9 @@ mt7921_mcu_rx_unsolicited_event(struct mt7921_dev *dev, struct sk_buff *skb)
 	case MCU_EVENT_LP_INFO:
 		mt7921_mcu_low_power_event(dev, skb);
 		break;
+	case MCU_EVENT_TX_DONE:
+		mt7921_mcu_tx_done_event(dev, skb);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index edc0c73f8c01c..68cb0ce013dbd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -91,6 +91,33 @@ enum {
 	MCU_EVENT_COREDUMP = 0xf0,
 };
 
+struct mt7921_mcu_tx_done_event {
+	u8 pid;
+	u8 status;
+	__le16 seq;
+
+	u8 wlan_idx;
+	u8 tx_cnt;
+	__le16 tx_rate;
+
+	u8 flag;
+	u8 tid;
+	u8 rsp_rate;
+	u8 mcs;
+
+	u8 bw;
+	u8 tx_pwr;
+	u8 reason;
+	u8 rsv0[1];
+
+	__le32 delay;
+	__le32 timestamp;
+	__le32 applied_flag;
+	u8 txs[28];
+
+	u8 rsv1[32];
+} __packed;
+
 /* ext event table */
 enum {
 	MCU_EXT_EVENT_RATE_REPORT = 0x87,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index e9c7c3a195076..7a6c38fbb940a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -463,4 +463,5 @@ int mt7921s_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			   struct mt76_tx_info *tx_info);
 void mt7921s_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue_entry *e);
 bool mt7921s_tx_status_data(struct mt76_dev *mdev, u8 *update);
+void mt7921_mac_add_txs(struct mt7921_dev *dev, void *data);
 #endif
-- 
2.34.1


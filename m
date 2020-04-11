Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE08A1A5AC8
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgDKXFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgDKXFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E40F21775;
        Sat, 11 Apr 2020 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646332;
        bh=s4vRQIJwcxkL6l2FldF0HlhnWS37JsVCYYVOD5lTqjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paRSp/q0r+PEf4tf/sVB45ij3JW+71lpAlY9OkbNRgEEMt9gB17GuRHca8gXgotLh
         VU3urQE4fhqGs1eNJmxPhJzll7YYSdZ7Ynj0DQbSrXkJSnpuISFDRo36NsISp7j58+
         SA7Pyh1k4bi3lrOkNPQ35wcmyYQl7RwjxtZ1KXA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 084/149] mt76: mt7603: fix input validation issues for powersave-filtered frames
Date:   Sat, 11 Apr 2020 19:02:41 -0400
Message-Id: <20200411230347.22371-84-sashal@kernel.org>
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

[ Upstream commit d55aa5e17461b8b423adae376978032c4a10a1d8 ]

Before extracting the tid out of the packet, check if it was qos-data.
Only accept tid values 0-7
Also, avoid accepting the hardware queue as skb queue mapping, it could
lead to an overrun. Instead, derive the hardware queue from the tid number,
in order to avoid issues with packets being filtered multiple times.
This also fixes a mismatch between hardware and software queue indexes.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index a6ab73060aada..57428467fe967 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -30,6 +30,16 @@ mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_sw_queue *q,
 static void
 mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 {
+	static const u8 tid_to_ac[8] = {
+		IEEE80211_AC_BE,
+		IEEE80211_AC_BK,
+		IEEE80211_AC_BK,
+		IEEE80211_AC_BE,
+		IEEE80211_AC_VI,
+		IEEE80211_AC_VI,
+		IEEE80211_AC_VO,
+		IEEE80211_AC_VO
+	};
 	__le32 *txd = (__le32 *)skb->data;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sta *sta;
@@ -38,7 +48,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	void *priv;
 	int idx;
 	u32 val;
-	u8 tid;
+	u8 tid = 0;
 
 	if (skb->len < MT_TXD_SIZE + sizeof(struct ieee80211_hdr))
 		goto free;
@@ -56,15 +66,16 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 
 	priv = msta = container_of(wcid, struct mt7603_sta, wcid);
 	val = le32_to_cpu(txd[0]);
-	skb_set_queue_mapping(skb, FIELD_GET(MT_TXD0_Q_IDX, val));
-
 	val &= ~(MT_TXD0_P_IDX | MT_TXD0_Q_IDX);
 	val |= FIELD_PREP(MT_TXD0_Q_IDX, MT_TX_HW_QUEUE_MGMT);
 	txd[0] = cpu_to_le32(val);
 
 	sta = container_of(priv, struct ieee80211_sta, drv_priv);
 	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
-	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		tid = *ieee80211_get_qos_ctl(hdr) &
+		      IEEE80211_QOS_CTL_TAG1D_MASK;
+	skb_set_queue_mapping(skb, tid_to_ac[tid]);
 	ieee80211_sta_set_buffered(sta, tid, true);
 
 	spin_lock_bh(&dev->ps_lock);
-- 
2.20.1


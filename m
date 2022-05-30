Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825ED5380F5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbiE3OJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiE3OI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1B779827;
        Mon, 30 May 2022 06:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 576D760FCC;
        Mon, 30 May 2022 13:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22962C3411E;
        Mon, 30 May 2022 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918141;
        bh=z0nAyk/VU0ksVU4YbjsvPBgUNPDMbbrVaHL11Of9pZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcXUM9Mt00yqROSr4JfU7kluOvUjdAknUI2SlVrSKG3DEbo6oBNNqurQYE5X8MSXg
         gQxUx9jP8QhM43z1uz6cfOQUhN/KzDzt2k3rnsvsWuaG0uwYPvfkg2K6TUqVIbXifo
         VQznQaLbo3RLRYCQ3ghfP4w/UMwAIwKW34fsTyCvrsCXmvKUroeEVQurnNnl5TJkVq
         FvbomnConRUsXi3coHcXUWikpQT3QHLQz8rgwxwq0DjfiKdxJQrAsbxV7DalEo/8j1
         IXEb44q5+DLBbcuGv2kUX6ryAald9QmtkF+pTpBG+/kRUvl/ESW7pNbmDi62BAtXu8
         cOjDI3Q0pzQuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Thibaut=20VAR=C3=88NE?= <hacks+kernel@slashdirt.org>,
        Sasha Levin <sashal@kernel.org>, lorenzo@kernel.org,
        ryder.lee@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, shayne.chen@mediatek.com,
        greearb@candelatech.com, sean.wang@mediatek.com,
        deren.wu@mediatek.com, xing.song@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 075/109] mt76: fix encap offload ethernet type check
Date:   Mon, 30 May 2022 09:37:51 -0400
Message-Id: <20220530133825.1933431-75-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bc98e7fdd80d215b4b55eea001023231eb8ce12e ]

The driver needs to check if the format is 802.2 vs 802.3 in order to set
a tx descriptor flag. skb->protocol can't be used, since it may not be properly
initialized for packets coming in from a packet socket.
Fix misdetection by checking the ethertype from the skb data instead

Reported-by: Thibaut VARÈNE <hacks+kernel@slashdirt.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 7691292526e0..a8a0e6af51f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -799,6 +799,7 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -812,7 +813,8 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 5024ddf07cbc..bef8d4a76ed9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -681,6 +681,7 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 {
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -694,7 +695,8 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
-- 
2.35.1


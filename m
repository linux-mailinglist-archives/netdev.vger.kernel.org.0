Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D865538011
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbiE3NxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239304AbiE3Nv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:51:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A9384A2C;
        Mon, 30 May 2022 06:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04DA7B80DAC;
        Mon, 30 May 2022 13:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E4EC3411C;
        Mon, 30 May 2022 13:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917773;
        bh=WXE3h52fOurnVlECd+Kj5Tga/VKW/SB9MyprE7My13k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/JirQRGC/n8ozTuSMPkWaIsS5pyXA3pi9SDx67N3DrF0gappJufL9QnvP3c6kv3t
         FJvnI9hOyTB2zrsSCbmcqukUkq00XhLg00uYc4O8O0QGISIcCz4C4dXD0OSTspcGOZ
         8YJ2TFUOVpgPLpzVeKp7+HbFYIfM2nTUMDb2K3XnEUc0Bp0XWsKS+lVfVibiytGVdQ
         QCkP6K0i0pJ+k/IEXcsR2qsFpNkS+kIUqE2LqKlWf9irntdA3Wce9tFR3t94pffjD7
         5w6SWIwoRofdOn1gM30Ps+mn7guGkbLUf5Cmd5zbz0TzoOso6iD9YWB3mMtc4NAAxd
         6lWP04tPE5c2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Thibaut=20VAR=C3=88NE?= <hacks+kernel@slashdirt.org>,
        Sasha Levin <sashal@kernel.org>, lorenzo@kernel.org,
        ryder.lee@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, greearb@candelatech.com,
        sean.wang@mediatek.com, deren.wu@mediatek.com,
        xing.song@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 092/135] mt76: fix encap offload ethernet type check
Date:   Mon, 30 May 2022 09:30:50 -0400
Message-Id: <20220530133133.1931716-92-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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
index e4c300aa1526..efc04f7a3c71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -982,6 +982,7 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -995,7 +996,8 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index e07707f518a2..eac2d85b5864 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -816,6 +816,7 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 {
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -829,7 +830,8 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
-- 
2.35.1


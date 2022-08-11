Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C858FF57
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiHKP3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbiHKP3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:29:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B9C17596;
        Thu, 11 Aug 2022 08:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 034E8B8214A;
        Thu, 11 Aug 2022 15:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A89C433D7;
        Thu, 11 Aug 2022 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231749;
        bh=5wTtuUIFeTcRyFWGyYy6LDbITmPaqwM+5MxDB0K12yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjJU4qZdRWIj+5WOFcXCTYzk89RhlYxGBwxoKoIlFQfjhWN1/tOY/8CdKHewwY2l5
         LiKshJ1iRcTrP3qNwxJNBQgjQVFKCGX7Y9NBbYguwLxruyb6vN318YRlRyM37RDrGG
         QRYvFeaTB/bdUIGz7oqBPnsVH0jkSWMap18VyQ6v95qt0HDhJEXp967JVDZlm3xn1o
         gKX0fhsKLitKrBudOzhQ2Eho61hDl3K9YNpsVfQLVjY6SuOEXXbpJ9hcLknPtWa4lr
         At4nBBQGvY6uZzUL9LMAl2oeAvlv0g/6zjan5OKICZLdUltpdNvYl4mi644jzw00ED
         Glmb5WSypbsOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Zhijun You <hujy652@gmail.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 003/105] ath10k: htt_tx: do not interpret Eth frames as WiFi
Date:   Thu, 11 Aug 2022 11:26:47 -0400
Message-Id: <20220811152851.1520029-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Sergey Ryazanov <ryazanov.s.a@gmail.com>

[ Upstream commit 70f119fb82af7f7417dc659faf02c91e1f853739 ]

The xmit path for the Ethernet encapsulated frames become more or less
usable since d740d8fd2439 ("ath10k: unify tx mode and dispatch"). This
change reorganize the xmit path in a manageable way to properly support
various tx modes, but misses that the Ethernet encapsulated frame is a
special case. We do not have an IEEE 802.11 header at the begining of
them. But the HTT Tx handler still interprets first bytes of each frame
as an IEEE 802.11 Frame Control field.

Than this code was copied by e62ee5c381c5 ("ath10k: Add support for
htt_data_tx_desc_64 descriptor") and a2097d6444c3 ("ath10k: htt: High
latency TX support") to another handlers. In fact the issue in the high
latency (HL) handler was introduced by 83ac260151e7 ("ath10k: add mic
bytes for pmf management packet").

Ethernet encapsulated frame tx mode stay unused until 75d85fd9993c
("ath10k: introduce basic tdls functionality") started using it for TDLS
frames to avoid key selection issue in some firmwares.

Trying to interpret the begining of an Ethernet encapsulated frame as an
IEEE 802.11 header was not hurt us noticeably since we need to meet two
conditions: (1) xmit should be performed towards a TDLS peer, and (2)
the TDLS peer should have a specific OUI part of its MAC address. Looks
like that the rareness in TDLS communications of OUIs that can be
interpreted as an 802.11 management frame saves users from facing this
issue earlier.

Improve Ethernet tx mode support in the HTT Tx handler by avoiding
interpreting its first bytes as an IEEE 802.11 header. While at it, make
the ieee80211_hdr variable local to the code block that is guarded by
!is_eth check. In this way, we clarify in which cases a frame can be
interpreted as IEEE 802.11, and saves us from similar issues in the
future.

Credits: this change as part of xmit encapsulation offloading support
was originally made by QCA and then submitted for inclusion by John
Crispin [1]. But the whole work was not accepted due to the lack of a
part for 64-bits descriptors [2]. Zhijun You then pointed this out to me
in a reply to my initial RFC patch series. And I made this slightly
reworked version that covered all the HTT Tx handler variants.

1. https://lore.kernel.org/all/20191216092207.31032-1-john@phrozen.org/
2. https://patchwork.kernel.org/project/linux-wireless/patch/20191216092207.31032-1-john@phrozen.org/

Reported-by: Zhijun You <hujy652@gmail.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220516032519.29831-3-ryazanov.s.a@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 61 ++++++++++++++----------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 9842a4b2f78f..a19b0795c86d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1275,7 +1275,6 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	struct ath10k *ar = htt->ar;
 	int res, data_len;
 	struct htt_cmd_hdr *cmd_hdr;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct htt_data_tx_desc *tx_desc;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct sk_buff *tmp_skb;
@@ -1286,11 +1285,15 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	u16 flags1 = 0;
 	u16 msdu_id = 0;
 
-	if ((ieee80211_is_action(hdr->frame_control) ||
-	     ieee80211_is_deauth(hdr->frame_control) ||
-	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	if (!is_eth) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+
+		if ((ieee80211_is_action(hdr->frame_control) ||
+		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control)) &&
+		     ieee80211_has_protected(hdr->frame_control)) {
+			skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+		}
 	}
 
 	data_len = msdu->len;
@@ -1387,7 +1390,6 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
@@ -1419,15 +1421,19 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 	txbuf_paddr = htt->txbuf.paddr +
 		      (sizeof(struct ath10k_htt_txbuf_32) * msdu_id);
 
-	if ((ieee80211_is_action(hdr->frame_control) ||
-	     ieee80211_is_deauth(hdr->frame_control) ||
-	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
-	} else if (!(skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT) &&
-		   txmode == ATH10K_HW_TXRX_RAW &&
-		   ieee80211_has_protected(hdr->frame_control)) {
-		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	if (!is_eth) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+
+		if ((ieee80211_is_action(hdr->frame_control) ||
+		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control)) &&
+		     ieee80211_has_protected(hdr->frame_control)) {
+			skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+		} else if (!(skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT) &&
+			   txmode == ATH10K_HW_TXRX_RAW &&
+			   ieee80211_has_protected(hdr->frame_control)) {
+			skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+		}
 	}
 
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
@@ -1589,7 +1595,6 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
@@ -1621,15 +1626,19 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 	txbuf_paddr = htt->txbuf.paddr +
 		      (sizeof(struct ath10k_htt_txbuf_64) * msdu_id);
 
-	if ((ieee80211_is_action(hdr->frame_control) ||
-	     ieee80211_is_deauth(hdr->frame_control) ||
-	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
-	} else if (!(skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT) &&
-		   txmode == ATH10K_HW_TXRX_RAW &&
-		   ieee80211_has_protected(hdr->frame_control)) {
-		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	if (!is_eth) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+
+		if ((ieee80211_is_action(hdr->frame_control) ||
+		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control)) &&
+		     ieee80211_has_protected(hdr->frame_control)) {
+			skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+		} else if (!(skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT) &&
+			   txmode == ATH10K_HW_TXRX_RAW &&
+			   ieee80211_has_protected(hdr->frame_control)) {
+			skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+		}
 	}
 
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
-- 
2.35.1


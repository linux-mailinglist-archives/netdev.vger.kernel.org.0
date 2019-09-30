Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F61C1D5B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbfI3IsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:48:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3181 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfI3IsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:12 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 33FDE3A4053CE2472D4C;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:48:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 4/6] rtlwifi: rtl8192ee: Remove set but not used variables 'short_gi','buf_len'
Date:   Mon, 30 Sep 2019 16:54:50 +0800
Message-ID: <1569833692-93288-5-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c: In function rtl92ee_tx_fill_desc:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c:656:5: warning: variable short_gi set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c: In function rtl92ee_tx_fill_desc:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c:648:15: warning: variable buf_len set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 27f1a63..36a8a51 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -651,7 +651,6 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 	struct rtlwifi_tx_info *tx_info = rtl_tx_skb_cb_info(skb);
 	u16 seq_number;
 	__le16 fc = hdr->frame_control;
-	unsigned int buf_len;
 	u8 fw_qsel = _rtl92ee_map_hwqueue_to_fwqueue(skb, hw_queue);
 	bool firstseg = ((hdr->seq_ctrl &
 			    cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
@@ -659,7 +658,6 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 			   cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
 	dma_addr_t mapping;
 	u8 bw_40 = 0;
-	u8 short_gi;
 	__le32 *pdesc = (__le32 *)pdesc8;

 	if (mac->opmode == NL80211_IFTYPE_STATION) {
@@ -677,7 +675,6 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 		skb_push(skb, EM_HDR_LEN);
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
-	buf_len = skb->len;
 	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
@@ -724,11 +721,6 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 			}
 		}

-		if (ptcb_desc->hw_rate > DESC_RATEMCS0)
-			short_gi = (ptcb_desc->use_shortgi) ? 1 : 0;
-		else
-			short_gi = (ptcb_desc->use_shortpreamble) ? 1 : 0;
-
 		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 			set_tx_desc_agg_enable(pdesc, 1);
 			set_tx_desc_max_agg_num(pdesc, 0x14);
--
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56956EC40B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfKANuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:50:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfKANuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 09:50:54 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8417EDCDBFA1A1135DD7;
        Fri,  1 Nov 2019 21:50:47 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 21:50:40 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <yuehaibing@huawei.com>,
        <christophe.jaillet@wanadoo.fr>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmsmac: remove set but not used variables
Date:   Fri, 1 Nov 2019 21:50:35 +0800
Message-ID: <20191101135035.11612-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:841:7: warning: variable free_pdu set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:842:30: warning: variable tx_rts_count set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:842:6: warning: variable tx_rts set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:843:7: warning: variable totlen set but not used [-Wunused-but-set-variable]

They are never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 6bb34a12..ff39773 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -838,9 +838,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	struct dma_pub *dma = NULL;
 	struct d11txh *txh = NULL;
 	struct scb *scb = NULL;
-	bool free_pdu;
-	int tx_rts, tx_frame_count, tx_rts_count;
-	uint totlen, supr_status;
+	int tx_frame_count;
+	uint supr_status;
 	bool lastframe;
 	struct ieee80211_hdr *h;
 	u16 mcl;
@@ -917,11 +916,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 			     CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 	}
 
-	tx_rts = le16_to_cpu(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
 	    (txs->status & TX_STATUS_FRM_RTX_MASK) >> TX_STATUS_FRM_RTX_SHIFT;
-	tx_rts_count =
-	    (txs->status & TX_STATUS_RTS_RTX_MASK) >> TX_STATUS_RTS_RTX_SHIFT;
 
 	lastframe = !ieee80211_has_morefrags(h->frame_control);
 
@@ -989,9 +985,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	totlen = p->len;
-	free_pdu = true;
-
 	if (lastframe) {
 		/* remove PLCP & Broadcom tx descriptor header */
 		skb_pull(p, D11_PHY_HDR_LEN);
-- 
2.7.4



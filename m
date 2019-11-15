Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9A9FDD0E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKOMJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:09:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43379 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKOMJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:09:58 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iVaQD-0006GE-BL; Fri, 15 Nov 2019 12:09:53 +0000
From:   Colin King <colin.king@canonical.com>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wil6210: fix break that is never reached because of zero'ing of a retry counter
Date:   Fri, 15 Nov 2019 12:09:53 +0000
Message-Id: <20191115120953.48137-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a check on the retry counter invalid_buf_id_retry that is always
false because invalid_buf_id_retry is initialized to zero on each iteration
of a while-loop.  Fix this by initializing the retry counter before the
while-loop starts.

Addresses-Coverity: ("Logically dead code")
Fixes: b4a967b7d0f5 ("wil6210: reset buff id in status message after completion")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

Note: not tested, so I'm not sure if the loop retry threshold is high enough

---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 778b63be6a9a..02548d40253c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -869,6 +869,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	u8 data_offset;
 	struct wil_rx_status_extended *s;
 	u16 sring_idx = sring - wil->srings;
+	int invalid_buff_id_retry;
 
 	BUILD_BUG_ON(sizeof(struct wil_rx_status_extended) > sizeof(skb->cb));
 
@@ -882,9 +883,9 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	/* Extract the buffer ID from the status message */
 	buff_id = le16_to_cpu(wil_rx_status_get_buff_id(msg));
 
+	invalid_buff_id_retry = 0;
 	while (!buff_id) {
 		struct wil_rx_status_extended *s;
-		int invalid_buff_id_retry = 0;
 
 		wil_dbg_txrx(wil,
 			     "buff_id is not updated yet by HW, (swhead 0x%x)\n",
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27AF15F540
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395017AbgBNS0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbgBNPtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C54F24680;
        Fri, 14 Feb 2020 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695341;
        bh=RgAX4s5PvLf12O0Wh0R3zX85TiTmkInjzwWw9mxZ/6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu6zXySW9Q86wbK6Yy19eLGdRVmARK1UngenWfpDk89ZH846dzGLpf5m6zp9VJe66
         DOkUa9r9+IQhMviF+Sm4r1jUXS4PN4V4tSmgWhTt2HXbtxTjybvqtcnPmoJsWglpUv
         wdwpS6UZmQB/85DOS8ApICAfeXvOJGCt+p3cCVA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 005/542] wil6210: fix break that is never reached because of zero'ing of a retry counter
Date:   Fri, 14 Feb 2020 10:39:57 -0500
Message-Id: <20200214154854.6746-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5b1413f00b5beb9f5fed94e43ea0c497d5db9633 ]

There is a check on the retry counter invalid_buf_id_retry that is always
false because invalid_buf_id_retry is initialized to zero on each iteration
of a while-loop.  Fix this by initializing the retry counter before the
while-loop starts.

Addresses-Coverity: ("Logically dead code")
Fixes: b4a967b7d0f5 ("wil6210: reset buff id in status message after completion")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 778b63be6a9a4..02548d40253c7 100644
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


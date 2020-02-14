Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DED615EF41
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbgBNQB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389204AbgBNQB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:01:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2BB2467D;
        Fri, 14 Feb 2020 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696115;
        bh=D16FOP0LatLu1py7M1wt/ReSX/H32Uopazlzwfr6bX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiyRfK3mCp2axTQgSO1JgUHnUrmSUYgTVr47syi7TY5dgJQfazPbUrpcpZz2PgCno
         rS5S0JshSeAVIJToWXWXYvFhDGJXZxi25Xi/djaEaZxcDPbDpX27+1ICPufpDL9MA9
         6U/UkxIcDlc1EYOIZGgHGTcg1+DHw0KmSpAN2gFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 004/459] wil6210: fix break that is never reached because of zero'ing of a retry counter
Date:   Fri, 14 Feb 2020 10:54:14 -0500
Message-Id: <20200214160149.11681-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 04d576deae72c..6cb0d7bcfe765 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -880,6 +880,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	u8 data_offset;
 	struct wil_rx_status_extended *s;
 	u16 sring_idx = sring - wil->srings;
+	int invalid_buff_id_retry;
 
 	BUILD_BUG_ON(sizeof(struct wil_rx_status_extended) > sizeof(skb->cb));
 
@@ -893,9 +894,9 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
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


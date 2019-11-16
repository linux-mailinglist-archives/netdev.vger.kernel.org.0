Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D1EFF255
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbfKPQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbfKPPq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B9B2083B;
        Sat, 16 Nov 2019 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919188;
        bh=nOskZj0L/b7ymmq40aLThte2XvXczGSoKhi6G9WlnOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGlWnYCBBIA5NHgiP9+8EHBgGPsBWvG/OIVsMAwuz2ry7CCV9FWTiqcZ/B2Xnj4lt
         0AOx+ZAYqi6wIrH7Oryhx4lS49s7hYUG1su9kQs38SnQb0iFXO0k18El9e9t7JxeYa
         0CaX9vJijIFD1kvC8ZiEp7XmxtsGGEuCoaSJHpyk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 197/237] wil6210: fix L2 RX status handling
Date:   Sat, 16 Nov 2019 10:40:32 -0500
Message-Id: <20191116154113.7417-197-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 04de15010aa42a92add66b159e3ae44b4287390f ]

L2 RX status errors should not be treated as a bitmap and the actual
error values should be checked.
Print L2 errors as wil_err_ratelimited for easier debugging
when such errors occurs.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 23 ++++++++++----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 409a6fa8b6c8f..5fa8d6ad66482 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -808,23 +808,24 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "L2 RX error, l2_rx_status=0x%x\n",
 			     l2_rx_status);
 		/* Due to HW issue, KEY error will trigger a MIC error */
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_MIC) {
-			wil_dbg_txrx(wil,
-				     "L2 MIC/KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_MIC) {
+			wil_err_ratelimited(wil,
+					    "L2 MIC/KEY error, dropping packet\n");
 			stats->rx_mic_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_KEY) {
-			wil_dbg_txrx(wil, "L2 KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_KEY) {
+			wil_err_ratelimited(wil,
+					    "L2 KEY error, dropping packet\n");
 			stats->rx_key_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_REPLAY) {
-			wil_dbg_txrx(wil,
-				     "L2 REPLAY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_REPLAY) {
+			wil_err_ratelimited(wil,
+					    "L2 REPLAY error, dropping packet\n");
 			stats->rx_replay++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_AMSDU) {
-			wil_dbg_txrx(wil,
-				     "L2 AMSDU error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_AMSDU) {
+			wil_err_ratelimited(wil,
+					    "L2 AMSDU error, dropping packet\n");
 			stats->rx_amsdu_error++;
 		}
 		return -EFAULT;
-- 
2.20.1


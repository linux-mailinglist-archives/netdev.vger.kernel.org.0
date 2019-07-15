Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306A268B9D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbfGONiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbfGONiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:38:20 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A802080A;
        Mon, 15 Jul 2019 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197899;
        bh=jtIGX7QQt3juwRiIEJhbVV6v+rMt/kTvO0hy90dvnaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl24HgK38Ae3GRF4bXgQiEodIsJX7Ie77knSuNpZEobvMS/dF96vsSsi7K1T1G4ww
         RWE6uK80d48R/oK/w9tEzbSRF0gHFsn91kzOdwAqRFbRP//nkRcIJYlnyVbIQF6cg/
         diAtYJ7UzCEx1gny2y5RHK8nPfOVl3RXVpX2Bkag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 002/219] ath10k: htt: don't use txdone_fifo with SDIO
Date:   Mon, 15 Jul 2019 09:34:34 -0400
Message-Id: <20190715133811.2441-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133811.2441-1-sashal@kernel.org>
References: <20190715133811.2441-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

[ Upstream commit e2a6b711282a371c5153239e0468a48254f17ca6 ]

HTT High Latency (ATH10K_DEV_TYPE_HL) does not use txdone_fifo at all, we don't
even initialise it by skipping ath10k_htt_tx_alloc_buf() in
ath10k_htt_tx_start(). Because of this using QCA6174 SDIO
ath10k_htt_rx_tx_compl_ind() will crash when it accesses unitialised
txdone_fifo. So skip txdone_fifo when using High Latency mode.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1acc622d2183..f22840bbc389 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2277,7 +2277,9 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		 *  Note that with only one concurrent reader and one concurrent
 		 *  writer, you don't need extra locking to use these macro.
 		 */
-		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
+			ath10k_txrx_tx_unref(htt, &tx_done);
+		} else if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
 			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
 				    tx_done.msdu_id, tx_done.status);
 			ath10k_txrx_tx_unref(htt, &tx_done);
-- 
2.20.1


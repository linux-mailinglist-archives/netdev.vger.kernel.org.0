Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C294690D8
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390931AbfGOOYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389736AbfGOOY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:24:28 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4882053B;
        Mon, 15 Jul 2019 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200667;
        bh=zLjJz4j/V9u6RrHfWRmvPDzXOxeNJWw2bkDI75p59SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaWoVG9ezyckQXply5ldcitZQHVzgmFRPJUtTU4oRXYAqu9HaqXT87BnI93nVM7U3
         mWvI5FgLkYGcLO8J82rOpmCM/yM2pM7Zhc/hPKxjA+Ri79szJOEPjwzvNg+YEHoqO+
         fUVIdVsjOanSXnRIWyz4HrM0Ti+rLCvy+yNcqyPY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claire Chang <tientzu@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 108/158] ath10k: add missing error handling
Date:   Mon, 15 Jul 2019 10:17:19 -0400
Message-Id: <20190715141809.8445-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 4b553f3ca4cbde67399aa3a756c37eb92145b8a1 ]

In function ath10k_sdio_mbox_rx_alloc() [sdio.c],
ath10k_sdio_mbox_alloc_rx_pkt() is called without handling the error cases.
This will make the driver think the allocation for skb is successful and
try to access the skb. If we enable failslab, system will easily crash with
NULL pointer dereferencing.

Call trace of CONFIG_FAILSLAB:
ath10k_sdio_irq_handler+0x570/0xa88 [ath10k_sdio]
process_sdio_pending_irqs+0x4c/0x174
sdio_run_irqs+0x3c/0x64
sdio_irq_work+0x1c/0x28

Fixes: d96db25d2025 ("ath10k: add initial SDIO support")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 7f61591ce0de..cb527a21f1ac 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -613,6 +613,10 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 						    full_len,
 						    last_in_bundle,
 						    last_in_bundle);
+		if (ret) {
+			ath10k_warn(ar, "alloc_rx_pkt error %d\n", ret);
+			goto err;
+		}
 	}
 
 	ar_sdio->n_rx_pkts = i;
-- 
2.20.1


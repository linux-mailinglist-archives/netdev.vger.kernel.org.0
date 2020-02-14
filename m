Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0842715EFDA
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbgBNP7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:59:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388760AbgBNP7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757C32067D;
        Fri, 14 Feb 2020 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695939;
        bh=72jwIr70tZSmKLso6PZnaN8QwHlfCrUagBq8IFNznWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCpsgHSUWONT3uXS7FOGr+LXEWW8YHK7KMPkCk6gt6CohZEuk65RUbTozM3VCyYwN
         tz2RZ6S5dQctyfPeQ66YsIKG55ApfT2ckqFxHs1X4L1PDo7FoqGMTi03bR3aP//TE6
         /rP8ocurhshBviGWFUfSq/NGdtslMrRrO6xYTF+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 473/542] rtw88: fix potential NULL skb access in TX ISR
Date:   Fri, 14 Feb 2020 10:47:45 -0500
Message-Id: <20200214154854.6746-473-sashal@kernel.org>
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

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

[ Upstream commit f4f84ff8377d4cedf18317747bc407b2cf657d0f ]

Sometimes the TX queue may be empty and we could possible
dequeue a NULL pointer, crash the kernel. If the skb is NULL
then there is nothing to do, just leave the ISR.

And the TX queue should not be empty here, so print an error
to see if there is anything wrong for DMA ring.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a58e8276a41a3..a6746b5a9ff2d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -832,6 +832,11 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 
 	while (count--) {
 		skb = skb_dequeue(&ring->queue);
+		if (!skb) {
+			rtw_err(rtwdev, "failed to dequeue %d skb TX queue %d, BD=0x%08x, rp %d -> %d\n",
+				count, hw_queue, bd_idx, ring->r.rp, cur_rp);
+			break;
+		}
 		tx_data = rtw_pci_get_tx_data(skb);
 		pci_unmap_single(rtwpci->pdev, tx_data->dma, skb->len,
 				 PCI_DMA_TODEVICE);
-- 
2.20.1


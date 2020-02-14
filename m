Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243CC15EA65
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404693AbgBNRNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392061AbgBNQMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:12:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059E3246BC;
        Fri, 14 Feb 2020 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696766;
        bh=5Fhczh3d5ACBAPgBle5laQq97KcyH5Y4JkPUrNJoFDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LJYn/PozuIs7qp9Y3k5lkO9wP2oG4tL9FWzC8XfEBiwrTYe+ZGuIHRwzSeJ4Pxb5
         W4lEUwTUyXGuM1h/D+t28IgKQYjNCkQVtesqalUcSxG+S/hELa1ptOeyptemmVXbRd
         xXHR7s/GirWhtbLdAfSd5D44TErOO3TuNmUZ/RK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/252] ath10k: Correct the DMA direction for management tx buffers
Date:   Fri, 14 Feb 2020 11:08:21 -0500
Message-Id: <20200214161147.15842-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 6ba8b3b6bd772f575f7736c8fd893c6981fcce16 ]

The management packets, send to firmware via WMI, are
mapped using the direction DMA_TO_DEVICE. Currently in
case of wmi cleanup, these buffers are being unmapped
using an incorrect DMA direction. This can cause unwanted
behavior when the host driver is handling a restart
of the wlan firmware.

We might see a trace like below

[<ffffff8008098b18>] __dma_inv_area+0x28/0x58
[<ffffff8001176734>] ath10k_wmi_mgmt_tx_clean_up_pending+0x60/0xb0 [ath10k_core]
[<ffffff80088c7c50>] idr_for_each+0x78/0xe4
[<ffffff80011766a4>] ath10k_wmi_detach+0x4c/0x7c [ath10k_core]
[<ffffff8001163d7c>] ath10k_core_stop+0x58/0x68 [ath10k_core]
[<ffffff800114fb74>] ath10k_halt+0xec/0x13c [ath10k_core]
[<ffffff8001165110>] ath10k_core_restart+0x11c/0x1a8 [ath10k_core]
[<ffffff80080c36bc>] process_one_work+0x16c/0x31c

Fix the incorrect DMA direction during the wmi
management tx buffer cleanup.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: dc405152bb6 ("ath10k: handle mgmt tx completion event")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0f6ff7a78e49d..3372dfa0deccf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9193,7 +9193,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
+			 msdu->len, DMA_TO_DEVICE);
 	ieee80211_free_txskb(ar->hw, msdu);
 
 	return 0;
-- 
2.20.1


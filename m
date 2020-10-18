Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBFB291CD6
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732714AbgJRTlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730666AbgJRTYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06323222E9;
        Sun, 18 Oct 2020 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049052;
        bh=a8CGfV1/BjFZ1fhJM2DyX1eMIpEyq3beSEbIQk/tMCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuz6LbAW9+fQblVVfZbHoEUkcvy3JrUDNFaTZfR9lt22y/QdyeHHfyCu9RbRisjcn
         aZS4rB7unZR95+7+V/evfeBHHkee4h01jM1eXvpTsQXzGP3cEl6eAwcUK9PSt4bAtI
         apj1gQ9YqO6LPIoByfGlVC/Jb5Ex3nfJ93a3bNDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 80/80] ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()
Date:   Sun, 18 Oct 2020 15:22:31 -0400
Message-Id: <20201018192231.4054535-80-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit bad60b8d1a7194df38fd7fe4b22f3f4dcf775099 ]

The idx in __ath10k_htt_rx_ring_fill_n function lives in
consistent dma region writable by the device. Malfunctional
or malicious device could manipulate such idx to have a OOB
write. Either by
    htt->rx_ring.netbufs_ring[idx] = skb;
or by
    ath10k_htt_set_paddrs_ring(htt, paddr, idx);

The idx can also be negative as it's signed, giving a large
memory space to write to.

It's possibly exploitable by corruptting a legit pointer with
a skb pointer. And then fill skb with payload as rougue object.

Part of the log here. Sometimes it appears as UAF when writing
to a freed memory by chance.

 [   15.594376] BUG: unable to handle page fault for address: ffff887f5c1804f0
 [   15.595483] #PF: supervisor write access in kernel mode
 [   15.596250] #PF: error_code(0x0002) - not-present page
 [   15.597013] PGD 0 P4D 0
 [   15.597395] Oops: 0002 [#1] SMP KASAN PTI
 [   15.597967] CPU: 0 PID: 82 Comm: kworker/u2:2 Not tainted 5.6.0 #69
 [   15.598843] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
 BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [   15.600438] Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 [   15.601389] RIP: 0010:__ath10k_htt_rx_ring_fill_n
 (linux/drivers/net/wireless/ath/ath10k/htt_rx.c:173) ath10k_core

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200623221105.3486-1-bruceshenzk@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9f0e7b4943ec6..8ca0a808a644d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -142,6 +142,14 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 	BUILD_BUG_ON(HTT_RX_RING_FILL_LEVEL >= HTT_RX_RING_SIZE / 2);
 
 	idx = __le32_to_cpu(*htt->rx_ring.alloc_idx.vaddr);
+
+	if (idx < 0 || idx >= htt->rx_ring.size) {
+		ath10k_err(htt->ar, "rx ring index is not valid, firmware malfunctioning?\n");
+		idx &= htt->rx_ring.size_mask;
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	while (num > 0) {
 		skb = dev_alloc_skb(HTT_RX_BUF_SIZE + HTT_RX_DESC_ALIGN);
 		if (!skb) {
-- 
2.25.1


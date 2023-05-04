Return-Path: <netdev+bounces-363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2646F7441
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 005971C21409
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84405101E0;
	Thu,  4 May 2023 19:43:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45406101DC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC303C433EF;
	Thu,  4 May 2023 19:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229431;
	bh=jY04o1EPXJzQvN2WWPPKNlEl+rWfPtb4YloCDiiBgAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz4CoQTO3xJiVrthljTzq5DoPrjPXVjlSyK02jsPoyxtEafpp2Mh/xYERzVc25Xiz
	 69eVNqIDHn8WXQegG5pb/OPur9jyvPRGFarQLiRnlvWLrkjh1GHgDU9mQPqhgkXLCw
	 4mJDEuSKRzdieReqkRhYdzYOd489HexXsShDxVnP/bGNxFFmhJmb6iWDsnC0WDKS21
	 iJPqZgUtOrt8Yh9ShReXmulkDTctGF06N79FuGRS7h3EAhXjgZ3HcI7hXZKRXDNWgQ
	 BmeenNmjmZAYhV3Ic/SwEyyeqsBeJ1FNDbOuKyb+R83Y9TSdW5AJSjA9OxcF1xjsE3
	 3vQdpcWMkI6Tw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nagarajan Maran <quic_nmaran@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 46/59] wifi: ath11k: Fix SKB corruption in REO destination ring
Date: Thu,  4 May 2023 15:41:29 -0400
Message-Id: <20230504194142.3805425-46-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nagarajan Maran <quic_nmaran@quicinc.com>

[ Upstream commit f9fff67d2d7ca6fa8066132003a3deef654c55b1 ]

While running traffics for a long time, randomly an RX descriptor
filled with value "0" from REO destination ring is received.
This descriptor which is invalid causes the wrong SKB (SKB stored in
the IDR lookup with buffer id "0") to be fetched which in turn
causes SKB memory corruption issue and the same leads to crash
after some time.

Changed the start id for idr allocation to "1" and the buffer id "0"
is reserved for error validation. Introduced Sanity check to validate
the descriptor, before processing the SKB.

Crash Signature :

Unable to handle kernel paging request at virtual address 3f004900
PC points to "b15_dma_inv_range+0x30/0x50"
LR points to "dma_cache_maint_page+0x8c/0x128".
The Backtrace obtained is as follows:
[<8031716c>] (b15_dma_inv_range) from [<80313a4c>] (dma_cache_maint_page+0x8c/0x128)
[<80313a4c>] (dma_cache_maint_page) from [<80313b90>] (__dma_page_dev_to_cpu+0x28/0xcc)
[<80313b90>] (__dma_page_dev_to_cpu) from [<7fb5dd68>] (ath11k_dp_process_rx+0x1e8/0x4a4 [ath11k])
[<7fb5dd68>] (ath11k_dp_process_rx [ath11k]) from [<7fb53c20>] (ath11k_dp_service_srng+0xb0/0x2ac [ath11k])
[<7fb53c20>] (ath11k_dp_service_srng [ath11k]) from [<7f67bba4>] (ath11k_pci_ext_grp_napi_poll+0x1c/0x78 [ath11k_pci])
[<7f67bba4>] (ath11k_pci_ext_grp_napi_poll [ath11k_pci]) from [<807d5cf4>] (__napi_poll+0x28/0xb8)
[<807d5cf4>] (__napi_poll) from [<807d5f28>] (net_rx_action+0xf0/0x280)
[<807d5f28>] (net_rx_action) from [<80302148>] (__do_softirq+0xd0/0x280)
[<80302148>] (__do_softirq) from [<80320408>] (irq_exit+0x74/0xd4)
[<80320408>] (irq_exit) from [<803638a4>] (__handle_domain_irq+0x90/0xb4)
[<803638a4>] (__handle_domain_irq) from [<805bedec>] (gic_handle_irq+0x58/0x90)
[<805bedec>] (gic_handle_irq) from [<80301a78>] (__irq_svc+0x58/0x8c)

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nagarajan Maran <quic_nmaran@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230403191533.28114-1-quic_nmaran@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 294c6fcfa1aa8..32a4f88861d58 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -389,10 +389,10 @@ int ath11k_dp_rxbufs_replenish(struct ath11k_base *ab, int mac_id,
 			goto fail_free_skb;
 
 		spin_lock_bh(&rx_ring->idr_lock);
-		buf_id = idr_alloc(&rx_ring->bufs_idr, skb, 0,
-				   rx_ring->bufs_max * 3, GFP_ATOMIC);
+		buf_id = idr_alloc(&rx_ring->bufs_idr, skb, 1,
+				   (rx_ring->bufs_max * 3) + 1, GFP_ATOMIC);
 		spin_unlock_bh(&rx_ring->idr_lock);
-		if (buf_id < 0)
+		if (buf_id <= 0)
 			goto fail_dma_unmap;
 
 		desc = ath11k_hal_srng_src_get_next_entry(ab, srng);
@@ -2665,6 +2665,9 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 				   cookie);
 		mac_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_PDEV_ID, cookie);
 
+		if (unlikely(buf_id == 0))
+			continue;
+
 		ar = ab->pdevs[mac_id].ar;
 		rx_ring = &ar->dp.rx_refill_buf_ring;
 		spin_lock_bh(&rx_ring->idr_lock);
-- 
2.39.2



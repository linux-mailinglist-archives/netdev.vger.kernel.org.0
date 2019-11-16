Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37C8FF075
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbfKPQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730699AbfKPPvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:15 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364E221846;
        Sat, 16 Nov 2019 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919474;
        bh=pGb1BqwB7ESBJvqdqPLH3dpMcxPSPCZBWyBfFsXlnac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPB2h6KhUe/VfpPlJAWfz1t11ZbIXZIG0wx6ZZzQIvN9Qg879LvQ5ApdKlD68R1/n
         TO1fglEAPAdvDNQ57B9OEECYQb96QXnvHhPh9ZBIeqCZDinhev7fDiVaI1tDGa3NA+
         QIEStu9T2CTePZK4el8wbP5eqZfFDNsXOaUH8FYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        Brian Norris <briannorris@chomium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/99] ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem
Date:   Sat, 16 Nov 2019 10:49:31 -0500
Message-Id: <20191116155103.10971-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 0738b4998c6d1caf9ca2447b946709a7278c70f1 ]

ath10k_pci_diag_write_mem may allocate big size of the dma memory
based on the parameter nbytes. Take firmware diag download as
example, the biggest size is about 500K. In some systems, the
allocation is likely to fail because it can't acquire such a large
contiguous dma memory.

The fix is to allocate a small size dma memory. In the loop,
driver copies the data to the allocated dma memory and writes to
the destination until all the data is written.

Tested with QCA6174 PCI with
firmware-6.bin_WLAN.RM.4.4.1-00119-QCARMSWP-1, this also affects
QCA9377 PCI.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Reviewed-by: Brian Norris <briannorris@chomium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 25b8d501d437e..176cf4fef6296 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1039,10 +1039,9 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret = 0;
 	u32 *buf;
-	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
+	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
 	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
-	u32 ce_data;	/* Host buffer address in CE space */
 	dma_addr_t ce_data_base = 0;
 	int i;
 
@@ -1056,9 +1055,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 *   1) 4-byte alignment
 	 *   2) Buffer in DMA-able space
 	 */
-	orig_nbytes = nbytes;
+	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
+
 	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
-						       orig_nbytes,
+						       alloc_nbytes,
 						       &ce_data_base,
 						       GFP_ATOMIC);
 	if (!data_buf) {
@@ -1066,9 +1066,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		goto done;
 	}
 
-	/* Copy caller's data to allocated DMA buf */
-	memcpy(data_buf, data, orig_nbytes);
-
 	/*
 	 * The address supplied by the caller is in the
 	 * Target CPU virtual address space.
@@ -1081,12 +1078,14 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 */
 	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
-	remaining_bytes = orig_nbytes;
-	ce_data = ce_data_base;
+	remaining_bytes = nbytes;
 	while (remaining_bytes) {
 		/* FIXME: check cast */
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
+		/* Copy caller's data to allocated DMA buf */
+		memcpy(data_buf, data, nbytes);
+
 		/* Set up to receive directly into Target(!) address */
 		ret = __ath10k_ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
@@ -1096,7 +1095,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data,
+		ret = ath10k_ce_send_nolock(ce_diag, NULL, ce_data_base,
 					    nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
@@ -1137,12 +1136,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
 		remaining_bytes -= nbytes;
 		address += nbytes;
-		ce_data += nbytes;
+		data += nbytes;
 	}
 
 done:
 	if (data_buf) {
-		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
 				  ce_data_base);
 	}
 
-- 
2.20.1


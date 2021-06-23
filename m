Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240183B20BD
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFWTDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:03:25 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:51170 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWTDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:03:25 -0400
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 15:03:24 EDT
Received: from MTA-06-3.privateemail.com (mta-06.privateemail.com [68.65.122.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 718C8809C4;
        Wed, 23 Jun 2021 14:46:23 -0400 (EDT)
Received: from MTA-06.privateemail.com (localhost [127.0.0.1])
        by MTA-06.privateemail.com (Postfix) with ESMTP id E826C600BA;
        Wed, 23 Jun 2021 14:46:21 -0400 (EDT)
Received: from hal-station.. (unknown [10.20.151.223])
        by MTA-06.privateemail.com (Postfix) with ESMTPA id 11D5760071;
        Wed, 23 Jun 2021 14:46:20 -0400 (EDT)
From:   Hamza Mahfooz <someguy@effective-light.com>
To:     linux-kernel@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Hamza Mahfooz <someguy@effective-light.com>
Subject: [PATCH] iwlwifi: remove redundant calls to unlikely()
Date:   Wed, 23 Jun 2021 14:45:46 -0400
Message-Id: <20210623184546.14769-1-someguy@effective-light.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per commit a7f3d3d3600c ("dma-mapping: add unlikely hint to error path
in dma_mapping_error"), dma_mapping_error now internally calls unlikely(),
so we don't need to call it directly anymore.

Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 4f6c187eed69..3bf56d30f741 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1253,7 +1253,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		dma_addr_t tb_phys = dma_map_single(trans->dev,
 						    skb->data + hdr_len,
 						    head_tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		if (dma_mapping_error(trans->dev, tb_phys))
 			return -EINVAL;
 		trace_iwlwifi_dev_tx_tb(trans->dev, skb, skb->data + hdr_len,
 					tb_phys, head_tb_len);
@@ -1272,7 +1272,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		if (dma_mapping_error(trans->dev, tb_phys))
 			return -EINVAL;
 		trace_iwlwifi_dev_tx_tb(trans->dev, skb, skb_frag_address(frag),
 					tb_phys, skb_frag_size(frag));
@@ -1380,7 +1380,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		hdr_tb_len = hdr_page->pos - start_hdr;
 		hdr_tb_phys = dma_map_single(trans->dev, start_hdr,
 					     hdr_tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, hdr_tb_phys)))
+		if (dma_mapping_error(trans->dev, hdr_tb_phys))
 			return -EINVAL;
 		iwl_pcie_txq_build_tfd(trans, txq, hdr_tb_phys,
 				       hdr_tb_len, false);
@@ -1400,7 +1400,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 
 			tb_phys = dma_map_single(trans->dev, tso.data,
 						 size, DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+			if (dma_mapping_error(trans->dev, tb_phys))
 				return -EINVAL;
 
 			iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
@@ -1551,7 +1551,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
+	if (dma_mapping_error(trans->dev, tb1_phys))
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 451b06069350..2b409fb33c99 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -211,7 +211,7 @@ static int iwl_txq_gen2_set_tb_with_wa(struct iwl_trans *trans,
 	struct page *page;
 	int ret;
 
-	if (unlikely(dma_mapping_error(trans->dev, phys)))
+	if (dma_mapping_error(trans->dev, phys))
 		return -ENOMEM;
 
 	if (likely(!iwl_txq_crosses_4g_boundary(phys, len))) {
@@ -251,7 +251,7 @@ static int iwl_txq_gen2_set_tb_with_wa(struct iwl_trans *trans,
 
 	phys = dma_map_single(trans->dev, page_address(page), len,
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, phys)))
+	if (dma_mapping_error(trans->dev, phys))
 		return -ENOMEM;
 	ret = iwl_txq_gen2_set_tb(trans, tfd, phys, len);
 	if (ret < 0) {
@@ -405,7 +405,7 @@ static int iwl_txq_gen2_build_amsdu(struct iwl_trans *trans,
 		tb_len = hdr_page->pos - start_hdr;
 		tb_phys = dma_map_single(trans->dev, start_hdr,
 					 tb_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		if (dma_mapping_error(trans->dev, tb_phys))
 			goto out_err;
 		/*
 		 * No need for _with_wa, this is from the TSO page and
@@ -487,7 +487,7 @@ iwl_tfh_tfd *iwl_txq_gen2_build_tx_amsdu(struct iwl_trans *trans,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb_phys = dma_map_single(trans->dev, tb1_addr, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+	if (dma_mapping_error(trans->dev, tb_phys))
 		goto out_err;
 	/*
 	 * No need for _with_wa(), we ensure (via alignment) that the data
@@ -582,7 +582,7 @@ iwl_tfh_tfd *iwl_txq_gen2_build_tx(struct iwl_trans *trans,
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+	if (dma_mapping_error(trans->dev, tb_phys))
 		goto out_err;
 	/*
 	 * No need for _with_wa(), we ensure (via alignment) that the data
-- 
2.32.0


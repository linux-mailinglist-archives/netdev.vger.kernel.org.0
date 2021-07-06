Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE43BCFD5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhGFLbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235496AbhGFLaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D7761DB8;
        Tue,  6 Jul 2021 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570475;
        bh=m/uSeaYwYSy3F559zEKb0I+NuHdp+bdo7Pc8iYTmtEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qon9gLfFS7l/2NpZgNmVYu+OhtFqxlKVgo5IESkAyDUqRFVHYGiAHzeIT1yd6kTNz
         ztmDI6fT99xx5yMdU0xMl83bhtClHdaemWpx1zfIg7oGaDCrKmnirUsoZwiCXwh7VF
         4R/j+rNLkyyxf0Go4LU2Ixv4WJBPPO+3d1NHZ4pCOhbv0X/QP4IsOuCGUBvAQG8t5D
         LrhyRz7PvbhDsdaAGIv8SVVmoksoA7NPREza9uPrJT83jbUmM+XN9L0AAcPCd5VJCD
         pHfUi8xMzNZNHNSohOEmfOYTEVLjqqzKgUjMvFl2bN0fUMtWz+k6cmS0fFLhSDF3Vr
         vEnjwgcLpRU4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 125/160] iwlwifi: pcie: free IML DMA memory allocation
Date:   Tue,  6 Jul 2021 07:17:51 -0400
Message-Id: <20210706111827.2060499-125-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 310f60f53a86eba680d9bc20a371e13b06a5f903 ]

In the case of gen3 devices with image loader (IML) support,
we were leaking the IML DMA allocation and never freeing it.
Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618105614.07e117dbedb7.I7bb9ebbe0617656986c2a598ea5e827b533bd3b9@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  | 15 ++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/internal.h    |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index cecc32e7dbe8..2dbc51daa2f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -79,7 +79,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
 	struct iwl_prph_info *prph_info;
-	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
 	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
@@ -187,14 +186,15 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	trans_pcie->prph_scratch = prph_scratch;
 
 	/* Allocate IML */
-	iml_img = dma_alloc_coherent(trans->dev, trans->iml_len,
-				     &trans_pcie->iml_dma_addr, GFP_KERNEL);
-	if (!iml_img) {
+	trans_pcie->iml = dma_alloc_coherent(trans->dev, trans->iml_len,
+					     &trans_pcie->iml_dma_addr,
+					     GFP_KERNEL);
+	if (!trans_pcie->iml) {
 		ret = -ENOMEM;
 		goto err_free_ctxt_info;
 	}
 
-	memcpy(iml_img, trans->iml, trans->iml_len);
+	memcpy(trans_pcie->iml, trans->iml, trans->iml_len);
 
 	iwl_enable_fw_load_int_ctx_info(trans);
 
@@ -243,6 +243,11 @@ void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)
 	trans_pcie->ctxt_info_dma_addr = 0;
 	trans_pcie->ctxt_info_gen3 = NULL;
 
+	dma_free_coherent(trans->dev, trans->iml_len, trans_pcie->iml,
+			  trans_pcie->iml_dma_addr);
+	trans_pcie->iml_dma_addr = 0;
+	trans_pcie->iml = NULL;
+
 	iwl_pcie_ctxt_info_free_fw_img(trans);
 
 	dma_free_coherent(trans->dev, sizeof(*trans_pcie->prph_scratch),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d9688c7bed07..53af3f29eab8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -279,6 +279,8 @@ struct cont_rec {
  *	Context information addresses will be taken from here.
  *	This is driver's local copy for keeping track of size and
  *	count for allocating and freeing the memory.
+ * @iml: image loader image virtual address
+ * @iml_dma_addr: image loader image DMA address
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @kw: keep warm address
@@ -329,6 +331,7 @@ struct iwl_trans_pcie {
 	};
 	struct iwl_prph_info *prph_info;
 	struct iwl_prph_scratch *prph_scratch;
+	void *iml;
 	dma_addr_t ctxt_info_dma_addr;
 	dma_addr_t prph_info_dma_addr;
 	dma_addr_t prph_scratch_dma_addr;
-- 
2.30.2


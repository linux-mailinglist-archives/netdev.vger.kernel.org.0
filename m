Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC73BD5CB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbhGFMZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236807AbhGFLfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C4B6135A;
        Tue,  6 Jul 2021 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570664;
        bh=UgTOyG//4UrPg7Ha48n4W39sIt64DI2Mai1IMIbKssA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjykY6nhAjSnP1TC5EQvRusK6oIrFYCbkpNjRW0BrUK2gDcqYlsMUqmbKLLNVOkBZ
         +IBl8WYhycwdeeYimIsqPOpIZmvK6nRGIt5fg04SmPuv8wie16KEdiIjVGWr4AJFoD
         bChyjuHSTCz2gj8IiH9Sx0rjfNUu9+G6xnar0l8Zk0nJFT/GGQ2e+mLFKlrMHmNVW3
         wQRHBuKLm/Dz8xm1P7R5ubPHQrqWD5C/4b0jVUTlEn29Ar1SRPiQEzE6TdJOA0V2ST
         +rH6iMZxWo1igRXW9r1gIam1GZMwHqyGfbtOV5A44ccbVbnfUx6XGN715/uux0iXD/
         NyY3EhqSDMycw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 108/137] iwlwifi: pcie: free IML DMA memory allocation
Date:   Tue,  6 Jul 2021 07:21:34 -0400
Message-Id: <20210706112203.2062605-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index ec1d6025081d..56f63f5f5dd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -126,7 +126,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
 	struct iwl_prph_info *prph_info;
-	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
 	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
@@ -234,14 +233,15 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
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
 
@@ -290,6 +290,11 @@ void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)
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
index ff542d2f0054..f05025e8d11d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -336,6 +336,8 @@ struct cont_rec {
  *	Context information addresses will be taken from here.
  *	This is driver's local copy for keeping track of size and
  *	count for allocating and freeing the memory.
+ * @iml: image loader image virtual address
+ * @iml_dma_addr: image loader image DMA address
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @kw: keep warm address
@@ -388,6 +390,7 @@ struct iwl_trans_pcie {
 	};
 	struct iwl_prph_info *prph_info;
 	struct iwl_prph_scratch *prph_scratch;
+	void *iml;
 	dma_addr_t ctxt_info_dma_addr;
 	dma_addr_t prph_info_dma_addr;
 	dma_addr_t prph_scratch_dma_addr;
-- 
2.30.2


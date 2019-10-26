Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A5E5D27
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJZNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfJZNRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 965F321655;
        Sat, 26 Oct 2019 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095831;
        bh=2t4kefleT8FFtV7eoVBTsdG7Vg2fUXwzYOT4ZkZ0+lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/yaQMwH335Y0j7eqlc9BPB80bfBySTbrx9m398LEUzF5MUid/E0Rm0SQmIsUkC/5
         f8Zt37a+V2/31jZmVJ3Y3bCq9BdJ48og0WjOsIMTJ9proqXVKBwr5phHJZOYfahAm5
         LxCCFAtX+2TZC5RnjmNvUxHHQxxT2oC8yDNT0E3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 37/99] iwlwifi: pcie: fix memory leaks in iwl_pcie_ctxt_info_gen3_init
Date:   Sat, 26 Oct 2019 09:14:58 -0400
Message-Id: <20191026131600.2507-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 0f4f199443faca715523b0659aa536251d8b978f ]

In iwl_pcie_ctxt_info_gen3_init there are cases that the allocated dma
memory is leaked in case of error.

DMA memories prph_scratch, prph_info, and ctxt_info_gen3 are allocated
and initialized to be later assigned to trans_pcie. But in any error case
before such assignment the allocated memories should be released.

First of such error cases happens when iwl_pcie_init_fw_sec fails.
Current implementation correctly releases prph_scratch. But in two
sunsequent error cases where dma_alloc_coherent may fail, such
releases are missing.

This commit adds release for prph_scratch when allocation for
prph_info fails, and adds releases for prph_scratch and prph_info when
allocation for ctxt_info_gen3 fails.

Fixes: 2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 5e86783d616b6..ab48ed258b1d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -107,13 +107,9 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &prph_scratch->dram);
-	if (ret) {
-		dma_free_coherent(trans->dev,
-				  sizeof(*prph_scratch),
-				  prph_scratch,
-				  trans_pcie->prph_scratch_dma_addr);
-		return ret;
-	}
+	if (ret)
+		goto err_free_prph_scratch;
+
 
 	/* Allocate prph information
 	 * currently we don't assign to the prph info anything, but it would get
@@ -121,16 +117,20 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	prph_info = dma_alloc_coherent(trans->dev, sizeof(*prph_info),
 				       &trans_pcie->prph_info_dma_addr,
 				       GFP_KERNEL);
-	if (!prph_info)
-		return -ENOMEM;
+	if (!prph_info) {
+		ret = -ENOMEM;
+		goto err_free_prph_scratch;
+	}
 
 	/* Allocate context info */
 	ctxt_info_gen3 = dma_alloc_coherent(trans->dev,
 					    sizeof(*ctxt_info_gen3),
 					    &trans_pcie->ctxt_info_dma_addr,
 					    GFP_KERNEL);
-	if (!ctxt_info_gen3)
-		return -ENOMEM;
+	if (!ctxt_info_gen3) {
+		ret = -ENOMEM;
+		goto err_free_prph_info;
+	}
 
 	ctxt_info_gen3->prph_info_base_addr =
 		cpu_to_le64(trans_pcie->prph_info_dma_addr);
@@ -186,6 +186,20 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 		iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
 
 	return 0;
+
+err_free_prph_info:
+	dma_free_coherent(trans->dev,
+			  sizeof(*prph_info),
+			prph_info,
+			trans_pcie->prph_info_dma_addr);
+
+err_free_prph_scratch:
+	dma_free_coherent(trans->dev,
+			  sizeof(*prph_scratch),
+			prph_scratch,
+			trans_pcie->prph_scratch_dma_addr);
+	return ret;
+
 }
 
 void iwl_pcie_ctxt_info_gen3_free(struct iwl_trans *trans)
-- 
2.20.1


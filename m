Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9846630C47C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhBBPwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235084AbhBBPMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B1FD64F84;
        Tue,  2 Feb 2021 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278425;
        bh=CTrKFKFw9wzgKDGrZqscRZtG58ni4CENVIvrkbvqplU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgO/Sd3SyaZcIM8g3mMifszoy4nnRNWo7IfLdFtCr+X4RVm3E2BMrXaWFstVsLEXn
         CVLEJP7WFHF5AuR+kSA1kcaKOwCdaShxXpBxmCpXBbszvKt8MR7MRxZwLze6NX7qLW
         rYUKn+0nNTx5oqAZ/kOe2ZyiDt2L3j80NqPYQfMSdgv1HJEUkHljKiQgaCYEb0OtSW
         ruqwDBStEbR+RxhLI2LNKPrGNt6SorBqrugmFUYECs9YyV9VONW/diWHE5NVpFMBQX
         A+7lWiA0OIy6cAtUgJzKsLP0MFcU2OJ0a6rQtANco8zvk4jK64ibF4he2ksWBNbZD1
         je6TR/3OLTrUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/17] iwlwifi: pcie: fix context info memory leak
Date:   Tue,  2 Feb 2021 10:06:45 -0500
Message-Id: <20210202150651.1864426-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2d6bc752cc2806366d9a4fd577b3f6c1f7a7e04e ]

If the image loader allocation fails, we leak all the previously
allocated memory. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.97172cbaa67c.I3473233d0ad01a71aa9400832fb2b9f494d88a11@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 7a5b024a6d384..eab159205e48b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -164,8 +164,10 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	/* Allocate IML */
 	iml_img = dma_alloc_coherent(trans->dev, trans->iml_len,
 				     &trans_pcie->iml_dma_addr, GFP_KERNEL);
-	if (!iml_img)
-		return -ENOMEM;
+	if (!iml_img) {
+		ret = -ENOMEM;
+		goto err_free_ctxt_info;
+	}
 
 	memcpy(iml_img, trans->iml, trans->iml_len);
 
@@ -207,6 +209,11 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
 	return 0;
 
+err_free_ctxt_info:
+	dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info_gen3),
+			  trans_pcie->ctxt_info_gen3,
+			  trans_pcie->ctxt_info_dma_addr);
+	trans_pcie->ctxt_info_gen3 = NULL;
 err_free_prph_info:
 	dma_free_coherent(trans->dev,
 			  sizeof(*prph_info),
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0430C33B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhBBPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhBBPLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:11:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F22E64F6A;
        Tue,  2 Feb 2021 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278397;
        bh=PZkgaS6zU3kWPQvzWpKAbL1NUiXHw96lH5K6n34oUpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9r0HRlMOcNe9bTOpmS3/83MgMJ+WCCL0HE6DvPr3CctuodtD4HLobQVJoH9GDAeX
         btQ3dPZjmjbiiHpsyA+SzuYvGYJIHFyXsVvbz2Do/sE8oRWhQL5sP2aMBdntP4UlZE
         5oFQLgLZc+B85gsfOG/fDRVpl+a/yahqj+lQroUAc8hm0eXe1S3LPq8ksnAHUIoHp7
         BCes0qkzZdO7UPW5Yr2mqT+qnOmiNtoTbgGEnnMY1uW6OHvq75vqRfctaI+17geoKs
         CDoZ78JdZpfI7972MHEjt16x7uKdxMzt5Micg735LC3ACDd97Cztz/LFBhVrP1+1jx
         9SfRxCoJs/4+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/25] iwlwifi: pcie: fix context info memory leak
Date:   Tue,  2 Feb 2021 10:06:06 -0500
Message-Id: <20210202150615.1864175-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
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
index 5512e3c630c31..2078b7b0bb7f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -236,8 +236,10 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
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
 
@@ -279,6 +281,11 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1E7C0CEC
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfI0U4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 16:56:20 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38080 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfI0U4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 16:56:19 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so19900956iom.5;
        Fri, 27 Sep 2019 13:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6XWDs202HxUMQZwjYYpTO5aVNS5TRVFQi//IFrYDeeY=;
        b=L55gU92RCxo9GNVu0j7NUeyo3YCMTbuo25tgLSLVNxFov7l77Bov+cwbWcukwIMGmi
         uQ11xfLgUDttTuKPXKLZDN9SXki7uN/vSBZJjGwRaPASn4ZdEpkR54UxwTGhuzDi4Z5e
         l8Xea2ALVip9/5WqRkO4tXSvqA1llwWS889D/XRPyBwoBv4nAUYijYD+vJ7SsLGeULiy
         86xYsrGPscwG8DThH7DuLFMb/AmppggrpgbQ73OviP5K+aUd5taDOel92JLovRZd/g1/
         lNPGt27Kuum7GLKO6cf/tpQgV8Dd3i1pUkpK9LHr3lW0Hu8VRN7t+1rcgm8ta8+tYWQT
         TZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6XWDs202HxUMQZwjYYpTO5aVNS5TRVFQi//IFrYDeeY=;
        b=ZCsn1QXkwGfgdOs1NGCn3eJB3hQP5yiTcogEnximLT94JtBYsSswsyRbwrTg+mb+gh
         YVkwca/swl2DHJ0haGzJUwfz2ifcWIzpPauryuRsitgIxJdaVZl/AGwaXqDjhhd3M/rR
         pKumL7yEXgngHjn6+mHih5D5GyqAFuuh5ljoMBF5mYNivY6xxNEhrV9RkrClAnu2TZms
         V0MYT0wcapm+P+dcJ5DXJeCa0+3e06Pi7EOuZp2y97dX1rl4/OWiOasBqvW0Z1Up9Zo7
         OcZwcEUebXiNikVQkp+GMBNVS1ppV77hQ+g2oP3fqomzm9uYhq4lgmxEA71eizlnni9a
         Ifhw==
X-Gm-Message-State: APjAAAUpSIgBWmLsiNcrAwTCJY1dx0bA6mp/2ywHupDeT9f5Lcw1wbPj
        P9OPhXPJxcLx90JQEvanEo4=
X-Google-Smtp-Source: APXvYqxIcYCc3Etak50jxb9W0VgkeBkDrg7+srVbZp7ZubSS9Bq9i9G37DHrUcaMh7iYwl9mc9fWIA==
X-Received: by 2002:a6b:6d07:: with SMTP id a7mr10591163iod.261.1569617778856;
        Fri, 27 Sep 2019 13:56:18 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id 197sm3197316ioc.78.2019.09.27.13.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 13:56:18 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix memory leaks in iwl_pcie_ctxt_info_gen3_init
Date:   Fri, 27 Sep 2019 15:56:04 -0500
Message-Id: <20190927205608.8755-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In iwl_pcie_ctxt_info_gen3_init there are cases that the allocated dma
memory is leaked in case of error.
DMA memories prph_scratch, prph_info, and ctxt_info_gen3 are allocated
and initialized to be later assigned to trans_pcie. But in any error case
before such assignment the allocated memories should be released.
First of such error cases happens when iwl_pcie_init_fw_sec fails.
Current implementation correctly releases prph_scratch. But in two
sunsequent error cases where dma_alloc_coherent may fail, such releases
are missing. This commit adds release for prph_scratch when allocation
for prph_info fails, and adds releases for prph_scratch and prph_info
when allocation for ctxt_info_gen3 fails.

Fixes: 2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 75fa8a6aafee..b2759c751822 100644
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
2.17.1


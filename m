Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4A215025
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgGEWWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729D1C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g67so16605372pgc.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=KDzIJkKXoByQ5M61v/QPNY9vOtgFA0fzJZod852JUc1luQuTNdfTrrYnxZjLkbsgLN
         qaPc+qElmDqrl8b+/bodtEqy3ap0FDZ3nphk5fCCSpQSLLLxtl+sAVGT8prV0zmqRORF
         tIoK2DXSqjtuLuINQ5ARq8ewjC9EAwbpHdekI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=Wq/2gcMxu3ld1oEW77my57rG3VMdGVRCrDNkCGBlRXnId53scDrH3zfpEErXm4DbEq
         T7vug533wXbzRgYILBNR4ceMV/c0jAul//EOmyxxdQ+gjSqyimpLjCfj0NEZOYPw78U6
         d2pZkqBDLrHsMRTzJuFTtqINSsDFh4G6aA5b9G32npHvagdVJkpuf+NCDNwtb64PcJdG
         gA/H97p+oc7y8TKwte0r5bp45jP8tL//JsIa5RJ9MHeD1vfiAtDyZgSgrd3hghitxh2o
         Ja/eZps8fXGpHrfw8A3lpe//NjZN0NLz+bs4wAEhuqZrRA2mIqpfZnueN8YkZLUyO9yv
         P33A==
X-Gm-Message-State: AOAM530KNusuhj36yMY+8qp2FgsVro6SMBwuTQ3cZjZohuppOirN0Ne+
        iOTPMAzRMmcu33KRKqq+I8K2cnuBnRY=
X-Google-Smtp-Source: ABdhPJyMOU8AwlKmWXUktAI3PdmhPtsfMJqGEI7Mma14XOx/ltHgrimZq5i820JfgkaEDINaf0NVcw==
X-Received: by 2002:a63:2946:: with SMTP id p67mr38296627pgp.227.1593987758805;
        Sun, 05 Jul 2020 15:22:38 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 1/8] bnxt_en: Set up the chip specific RSS table size.
Date:   Sun,  5 Jul 2020 18:22:05 -0400
Message-Id: <1593987732-1336-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we allocate one page for the hardware DMA RSS indirection
table.  While the size is currently big enough for all chips, future
chip variations may support bigger sizes, so it is better to calculate
and store the chip specific size and allocate accordingly.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  7 +++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a884df..4afc1df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3538,7 +3538,7 @@ static void bnxt_free_vnic_attributes(struct bnxt *bp)
 		}
 
 		if (vnic->rss_table) {
-			dma_free_coherent(&pdev->dev, PAGE_SIZE,
+			dma_free_coherent(&pdev->dev, vnic->rss_table_size,
 					  vnic->rss_table,
 					  vnic->rss_table_dma_addr);
 			vnic->rss_table = NULL;
@@ -3603,7 +3603,13 @@ static int bnxt_alloc_vnic_attributes(struct bnxt *bp)
 			continue;
 
 		/* Allocate rss table and hash key */
-		vnic->rss_table = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+		size = L1_CACHE_ALIGN(HW_HASH_INDEX_SIZE * sizeof(u16));
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			size = L1_CACHE_ALIGN(BNXT_MAX_RSS_TABLE_SIZE_P5);
+
+		vnic->rss_table_size = size + HW_HASH_KEY_SIZE;
+		vnic->rss_table = dma_alloc_coherent(&pdev->dev,
+						     vnic->rss_table_size,
 						     &vnic->rss_table_dma_addr,
 						     GFP_KERNEL);
 		if (!vnic->rss_table) {
@@ -3611,8 +3617,6 @@ static int bnxt_alloc_vnic_attributes(struct bnxt *bp)
 			goto out;
 		}
 
-		size = L1_CACHE_ALIGN(HW_HASH_INDEX_SIZE * sizeof(u16));
-
 		vnic->rss_hash_key = ((void *)vnic->rss_table) + size;
 		vnic->rss_hash_key_dma_addr = vnic->rss_table_dma_addr + size;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 78e2fd6..5883b246 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1017,6 +1017,13 @@ struct bnxt_vnic_info {
 	__le16		*rss_table;
 	dma_addr_t	rss_hash_key_dma_addr;
 	u64		*rss_hash_key;
+	int		rss_table_size;
+#define BNXT_RSS_TABLE_ENTRIES_P5	64
+#define BNXT_RSS_TABLE_SIZE_P5		(BNXT_RSS_TABLE_ENTRIES_P5 * 4)
+#define BNXT_RSS_TABLE_MAX_TBL_P5	8
+#define BNXT_MAX_RSS_TABLE_SIZE_P5				\
+	(BNXT_RSS_TABLE_SIZE_P5 * BNXT_RSS_TABLE_MAX_TBL_P5)
+
 	u32		rx_mask;
 
 	u8		*mc_list;
-- 
1.8.3.1


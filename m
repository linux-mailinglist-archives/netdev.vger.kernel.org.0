Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A756C20E1F5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389883AbgF2VBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731192AbgF2TM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F03C08EB27
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:48 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f3so7855217pgr.2
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=A2FgBuJLXxjSk8HMCuXsuIk0/N6U8/fEojrgb6Cs7g4Tp28PLr4HjDrL/PyG3b85cb
         doRw2RkzNxdkOTjQVLPw3bYp8SAyw8BfZc9TPAxzgTHv6tvg/Wu/k7sqBYbTpFl27rGk
         v3dztKnd9pS1p0xzblnW1kLH5VwvQa+u6314c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=baIjdEXsosKgbrRRewk8eMyxeWQFmkIXzksRdEUNnzZDsWY4vE+7pO1tJfvApndCB5
         EW6lTc0fFZ7EMbjfF8en8QZHE7YEk4Ag80GU8/+AnoaRZnGhfbDBh1919oFbyor/w9FD
         sGN/sN9qViU37jQIqogHOwBIHlzE/RVv/zmQZJ8lDX02anVGTgB+vHQI54M7qQum/9VT
         NM9VUtJNayMtmtkRHYqllNV5yayBljthe+PVYd61+9SNco+l+5eprKky+c8zQKTBXU6B
         KLqk1e7v+EbMR16txG/d+c5xmHl3wMGKghKSh+56eRTDRCQySjgpIIZTMTSSACrUx5RI
         c2xQ==
X-Gm-Message-State: AOAM533EPH8u8vKYVBviZw+gpEnc2a6HIQhK8mnU6GJGXN1UYArQx2YF
        s3gov7AhKLxBEcvY72dX/fCQYSrB7ho=
X-Google-Smtp-Source: ABdhPJwL8mpLpB7sWbdgb217Amz+REHxUp6tK5J8FCjjEKxsdBC6Ccn6U7AwO+PNR/5GMvQZ56bbsQ==
X-Received: by 2002:a62:1b91:: with SMTP id b139mr13354421pfb.298.1593412488069;
        Sun, 28 Jun 2020 23:34:48 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:47 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/8] bnxt_en: Set up the chip specific RSS table size.
Date:   Mon, 29 Jun 2020 02:34:17 -0400
Message-Id: <1593412464-503-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
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


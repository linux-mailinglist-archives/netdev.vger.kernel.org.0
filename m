Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19592134D0
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGCHUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgGCHUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F4AC08C5DD
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so31509446wrw.12
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=C57AqW6wFeaIvgcqTW5tjTXzJcXFsaN/KaUNVy8vGPK3IZx1VBijtBokbhd8QmFWiC
         8GV7FrWubhpiUQEgaYIZjPRI5UwukLP41d8hJko9Y63vVJKFyTXJtBvZ0FnZGmjGiEdX
         WjcTPypw+rxGmkRRcFXty3CZxxdEyEDFu5Ur4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=T44RE8/z7i/ZqYwyG4q/+THf75tn5W90LBHVfS3LfAV5SZ0dOXBMqHQd9gQpFSHjiD
         mmQ1b4R0mVpWM4AnW39FCgi23daCoHxvI4UrP/5jEOHuvOv1j8cFyhTSnyYenGCVsgNf
         Ce9QILYFaCzdtFSpsIg+sYOBXT/naOp/6LHdYdEQMp/OQVVLiY8wRhfp2bua4NpTzqOV
         dZ8lTp0jWYqIdOjuLDf+S+Tz5D6+BgykZYl5qwNG3HwW7acEyQWCJalmDCsb9bpN5st8
         L7OvBofJID81Aj0O/AUacrRV/gdlIusDjIYCBMLT5zVOLLKZuzrqVmKzV0h7auvyxcDX
         5d5g==
X-Gm-Message-State: AOAM530f+Q+OiW9hbUBh9pM6IPrj3X//p725v6/AXPZGDsc8zb2wwiCo
        s33ZLAtHgAGYS7th/SW2cNOZu+xX/y0=
X-Google-Smtp-Source: ABdhPJyCOOz0pyteSCJYv1PYY/FNjycpdTkqMld4HGX0zcjOzt2mTTXwnqLNFlildMh2hZDAuda9gQ==
X-Received: by 2002:adf:9307:: with SMTP id 7mr34514071wro.414.1593760802285;
        Fri, 03 Jul 2020 00:20:02 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 1/8] bnxt_en: Set up the chip specific RSS table size.
Date:   Fri,  3 Jul 2020 03:19:40 -0400
Message-Id: <1593760787-31695-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
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


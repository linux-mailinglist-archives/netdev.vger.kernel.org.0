Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E62B21866A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgGHLyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgGHLyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:22 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BB5C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so2690898wmi.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=DQK1RwH+1dfjOFtfLEWoyRkIj1D/0Ykb+nd+UgRqyvL2wW5HBKFfCGfB5oh9sXBZJ+
         9FUmu0w8Uerr7zK8LSyMpyU4/Fd3tTHRtHG6oA0uv81g4pWsFqifnAsPI6mxJxXU860a
         YX2dkSBBYVX/5Zn8aSV96d7cvHQ0pFsYeX4XI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg006q5RyQ/uTG7Kl3vPaOGeaSDpBJZult0HSaRbsSs=;
        b=EE3yhv+Rl+hrDMdxLuM3gnTvSQl1tltiwXMOVbPVMt90+y3XKPClJbeL36lczkwoqz
         CQ3JEwO4a8f3iXy6yHhQSMDEXqW1Vk8R2dy5LylXZZBw9dme5Hitq+iDELhdTGM03xHB
         Nkw+KzVfXS6zz8c3y55NgL9u+mN2U2RualvCmgLTydK1rpjX9Xp8IjWa5AtIxi6cS/fg
         PfOCBr1kDJTUP1TxiccRw1uhbo5i+8MUxKcaK1CPqKtVs7U7yPKl/5BiMdNH+bQliXOv
         TZBI2uAZPjfvrDAG3/OvTuVOWbMPiTcegPA51KjvVBUuqCYN05mTnvNMZbadruJYkfKj
         XuJA==
X-Gm-Message-State: AOAM531yF/c4CuY/FXhND5vckWPaz0IP/J/MV4avqLFgGdhuSDE7/Mke
        yDKX7ITz+KGiwwDuzYjhSPd5Qp1XzAA=
X-Google-Smtp-Source: ABdhPJyzbO9vWRXiWMr/EmsUJSJBnOFGtc9MU6vKveKoMMG6IpHBRkEKvvKCt52HaqnAg4FwM60Ezw==
X-Received: by 2002:a1c:f609:: with SMTP id w9mr8980619wmc.150.1594209261107;
        Wed, 08 Jul 2020 04:54:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 1/9] bnxt_en: Set up the chip specific RSS table size.
Date:   Wed,  8 Jul 2020 07:53:53 -0400
Message-Id: <1594209241-1692-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
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


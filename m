Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9CD4F9141
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiDHJB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiDHJBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:01:55 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C2FFF9A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WVdrP9lICpBOAHZrMqmRMLrdH83xWHdb6DPbICcPRtE=; b=bGkRNW8rTuD/J+fdgjgofMTM/0
        Am1RZmQ42mzAmnCUsT3J06EpXD0AKPufXWl0BQi78xsMTXyr37ixyKzByQvqOcVA5oWmDuuwk85sy
        CgpDKaFJxtVS/T6LunX77+mcjFH5JzR3VfsU5pnYwEfMrZ/uBzZv6hsrPgJn4OvyVf7U=;
Received: from p200300daa70ef200411eb61494300c34.dip0.t-ipconnect.de ([2003:da:a70e:f200:411e:b614:9430:c34] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nckT6-0004bk-K6; Fri, 08 Apr 2022 10:59:48 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc/wed: fix sparse endian warnings
Date:   Fri,  8 Apr 2022 10:59:45 +0200
Message-Id: <20220408085945.64227-1-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Descriptor fields are little-endian

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index f0eacf819cd9..fbe3e112e829 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -144,16 +144,17 @@ mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 
 		for (s = 0; s < MTK_WED_BUF_PER_PAGE; s++) {
 			u32 txd_size;
+			u32 ctrl;
 
 			txd_size = dev->wlan.init_buf(buf, buf_phys, token++);
 
-			desc->buf0 = buf_phys;
-			desc->buf1 = buf_phys + txd_size;
-			desc->ctrl = FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN0,
-						txd_size) |
-				     FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN1,
-						MTK_WED_BUF_SIZE - txd_size) |
-				     MTK_WDMA_DESC_CTRL_LAST_SEG1;
+			desc->buf0 = cpu_to_le32(buf_phys);
+			desc->buf1 = cpu_to_le32(buf_phys + txd_size);
+			ctrl = FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN0, txd_size) |
+			       FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN1,
+					  MTK_WED_BUF_SIZE - txd_size) |
+			       MTK_WDMA_DESC_CTRL_LAST_SEG1;
+			desc->ctrl = cpu_to_le32(ctrl);
 			desc->info = 0;
 			desc++;
 
@@ -184,12 +185,14 @@ mtk_wed_free_buffer(struct mtk_wed_device *dev)
 
 	for (i = 0, page_idx = 0; i < dev->buf_ring.size; i += MTK_WED_BUF_PER_PAGE) {
 		void *page = page_list[page_idx++];
+		dma_addr_t buf_addr;
 
 		if (!page)
 			break;
 
-		dma_unmap_page(dev->hw->dev, desc[i].buf0,
-			       PAGE_SIZE, DMA_BIDIRECTIONAL);
+		buf_addr = le32_to_cpu(desc[i].buf0);
+		dma_unmap_page(dev->hw->dev, buf_addr, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
 		__free_page(page);
 	}
 
-- 
2.35.1


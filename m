Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD2D6270B8
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiKMQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiKMQgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:36:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E1810FE0;
        Sun, 13 Nov 2022 08:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Apfp3Ntcah1dnmwtlE2hUcJ6OtLUs/yxuytUk8ohreQ=; b=GU53um0FBYaAiJuynSgJeWhHiA
        rCZFQYQ8j9b9DUMZM9RwUKBc71btd+rroHfHIaPMS/Fxp2UYdMvCRBcgpwRgPcUQEQd/vrOnBq0B9
        VkOTpncaIWoMw4vZ1/nvSRxONexbg+kPZU6VZLOKO34N7ze0R7J1HBkIq41zCzYpUD7vOWZQnOhbl
        30h41fe8KnQioNICCHkD0ajEgHxT8CFM/Vvyh3EbTmvxMBNVUeWmS2DwBDY5QMpN7WPuJbJh/HYdP
        OdFOdUFo/ZdkkEiVNqed57AtWzOxiHQq8x8FvpMInyG9aYm1ZCb0mk/919YOxWxWaQumasHPqoUgI
        0uKHuF/w==;
Received: from 213-225-8-167.nat.highway.a1.net ([213.225.8.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouFxi-00CLX8-TZ; Sun, 13 Nov 2022 16:36:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 5/7] s390/ism: don't pass bogus GFP_ flags to dma_alloc_coherent
Date:   Sun, 13 Nov 2022 17:35:33 +0100
Message-Id: <20221113163535.884299-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221113163535.884299-1-hch@lst.de>
References: <20221113163535.884299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
for allocation context control.  Don't pass __GFP_COMP which makes no
sense for an allocation that can't in any way be converted to a page
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/net/ism_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index d34bb6ec1490f..dfd401d9e3623 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -243,7 +243,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
 
 	dmb->cpu_addr = dma_alloc_coherent(&ism->pdev->dev, dmb->dmb_len,
 					   &dmb->dma_addr,
-					   GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC | __GFP_COMP | __GFP_NORETRY);
+					   GFP_KERNEL | __GFP_NOWARN |
+					   __GFP_NOMEMALLOC | __GFP_NORETRY);
 	if (!dmb->cpu_addr)
 		clear_bit(dmb->sba_idx, ism->sba_bitmap);
 
-- 
2.30.2


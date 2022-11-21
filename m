Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25785631D83
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiKUJ4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiKUJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:56:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28302603;
        Mon, 21 Nov 2022 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XA5Uk4Jqr3EzkRGc1SJfAPurCcuwLt5SF1EzetIfQQY=; b=CkGXa1mk2zHKvuchxSVR0LMuTa
        Da66jQf0+9mTx5Nb2vAdEYX8xgHFR/i7eZfScJ9rcz0wAXQz5xgkNYwHiPWGZAJWjqUSiVf7UljWB
        UCzIq/sEf4rKG56Set1L45qfW1LIX4NL8mJe8AP5ZKV0boBomRl6laAXI9oipmMWWOJRhsMBNizSh
        XO4pGZPPjze5352bKB8/ruFTG2b3JozvS+03Rgs5VPg5W5rwLaV5QD0589VrQdGWX9O5pxpRPWvK9
        aRpJWb9AhTJnp+UWMB2HB/f9TLOTyHwPoa288kA8CVNzhtVkeGbJ8/VHTV4VQPQOmdXL9fJTGpuVy
        mZZKKMjg==;
Received: from [2001:4bb8:199:6d04:3c43:44c4:4e80:d8ad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ox3Xb-00C2Fq-Af; Mon, 21 Nov 2022 09:56:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Ungerer <gerg@linux-m68k.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] m68k: return NULL from dma_alloc_coherent for nommu or coldfire
Date:   Mon, 21 Nov 2022 10:56:31 +0100
Message-Id: <20221121095631.216209-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121095631.216209-1-hch@lst.de>
References: <20221121095631.216209-1-hch@lst.de>
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

m68knommu and coldfire platforms can't support allocating coherent DMA
memory.  Instead of just returning noncoherent memory, just fail the
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/m68k/kernel/dma.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 2e192a5df949b..63618fce5dc7f 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -37,23 +37,13 @@ pgprot_t pgprot_dmacoherent(pgprot_t prot)
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs)
 {
-	void *ret;
-
-	if (dev == NULL || (*dev->dma_mask < 0xffffffff))
-		gfp |= GFP_DMA;
-	ret = (void *)__get_free_pages(gfp, get_order(size));
-
-	if (ret != NULL) {
-		memset(ret, 0, size);
-		*dma_handle = virt_to_phys(ret);
-	}
-	return ret;
+	return NULL;
 }
 
 void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, unsigned long attrs)
 {
-	free_pages((unsigned long)vaddr, get_order(size));
+	WARN_ON_ONCE(1);
 }
 
 #endif /* CONFIG_MMU && !CONFIG_COLDFIRE */
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747EB6E4D30
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjDQP3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjDQP2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7A47683
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5435661FF1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE0C4339B;
        Mon, 17 Apr 2023 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681745288;
        bh=knIu6FEJ3h9f84quYLzg3Bq0OPPPZ2M1XoLrnjA4v2A=;
        h=From:To:Cc:Subject:Date:From;
        b=D6mLuWr3hM3agVnkCaNxb4jjLvtRrhiEtmPMHoxxYBq/gAoDsTs6eL2Z6wJvZz3AG
         b8ZwbZdg1KO5xcnyy/E+J4ll0KInBaiQCbMti9pIa/TCi+0bhBQxRqgldFjr6pGYza
         fc6TmdVn67EJLcFa5HL0U72cZJjHTYwPx4N0UuneD5REJBZKallD04YR068sg+159c
         n11ZHsRyy2uL9oU91KPCEoN2fYxWhAk5b5yoeetOvl86vS7+3Miaiae28ai+6Vu6/w
         9kKk6HWry8C8NHSTceL0vrAKP+WK6QAWzQUmMlfujwMWa0rHHfYf83zFDaPCftu8iF
         jCr6RSMzw9wqQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        michael.chan@broadcom.com, Jakub Kicinski <kuba@kernel.org>,
        hawk@kernel.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all mappings
Date:   Mon, 17 Apr 2023 08:28:05 -0700
Message-Id: <20230417152805.331865-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
to a few more drivers (possibly as a copy'n'paste).

DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
the rarity of these platforms is likely why we never bothered adding
the attribute in the page pool, even though it should be safe to add.

To make the page pool migration in drivers which set this flag less
of a risk (of regressing the precious sparc database workloads or
whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
page pool DMA mappings.

We could make this a driver opt-in but frankly I don't think it's
worth complicating the API. I can't think of a reason why device
accesses to packet memory would have to be ordered.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: hawk@kernel.org
CC: ilias.apalodimas@linaro.org
---
 net/core/page_pool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2f6bf422ed30..97f20f7ff4fc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	 */
 	dma = dma_map_page_attrs(pool->p.dev, page, 0,
 				 (PAGE_SIZE << pool->p.order),
-				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC |
+						  DMA_ATTR_WEAK_ORDERING);
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
@@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 	/* When page is unmapped, it cannot be returned to our pool */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
-			     DMA_ATTR_SKIP_CPU_SYNC);
+			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
 	page_pool_clear_pp_info(page);
-- 
2.39.2


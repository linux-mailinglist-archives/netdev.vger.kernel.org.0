Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5013563E317
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiK3WIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiK3WIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153BC54370
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KVwdkzfVnP5EP4tQZn9lMmK56vptL30ngyKIzYXqTBI=; b=McjGfY4gNhzYVbnp5nZaYeOHTG
        KAeKPIAHwtc5vQ9bJv4C+uoAID2SsyNsIytkpGeYfaDQBCJAdE80IvHsUDwBMdW1ZdfxzNfJMOpLB
        0TzuD4+fDsm2liDEQcamnSahCyq094YpB4BzZapJPFAn1jACSW3SXBsrt0JmuiOwvq8P3m92CTWCD
        G3E0o6O4eELmJU+PHTaaVmIS8zstljPRWT8Cq7wYScE6xX/bgr535fkrUMcSqWUoYoMAH2SQ2tZf2
        M4kdf4aPA6FK7BmMZYNdvyNqi9N8CK5yP3fO1UInC08czIdYLrTQ9JKD6PJlICZSHgqWbupN7aCbn
        pjUDl75w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFM-00FLUr-IL; Wed, 30 Nov 2022 22:08:04 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 00/24] Split page pools from struct page
Date:   Wed, 30 Nov 2022 22:07:39 +0000
Message-Id: <20221130220803.3657490-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MM subsystem is trying to reduce struct page to a single pointer.
The first step towards that is splitting struct page by its individual
users, as has already been done with folio and slab.  This attempt chooses
'netmem' as a name, but I am not even slightly committed to that name,
and will happily use another.

There are some relatively significant reductions in kernel text
size from these changes.  I'm not qualified to judge how they
might affect performance, but every call to put_page() includes
a call to compound_head(), which is now rather more complex
than it once was (at least in a distro config which enables
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP).

I've only converted one user of the page_pool APIs to use the new netmem
APIs, all the others continue to use the page based ones.

Uh, I see I left netmem_to_virt() as its own commit instead of squashing
it into "netmem: Add utility functions".  I'll fix that in the next
version, because I'm sure you'll want some changes anyway.

Happy to answer questions.

Matthew Wilcox (Oracle) (24):
  netmem: Create new type
  netmem: Add utility functions
  page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
  page_pool: Convert page_pool_release_page() to
    page_pool_release_netmem()
  page_pool: Start using netmem in allocation path.
  page_pool: Convert page_pool_return_page() to
    page_pool_return_netmem()
  page_pool: Convert __page_pool_put_page() to __page_pool_put_netmem()
  page_pool: Convert pp_alloc_cache to contain netmem
  page_pool: Convert page_pool_defrag_page() to
    page_pool_defrag_netmem()
  page_pool: Convert page_pool_put_defragged_page() to netmem
  page_pool: Convert page_pool_empty_ring() to use netmem
  page_pool: Convert page_pool_alloc_pages() to page_pool_alloc_netmem()
  page_pool: Convert page_pool_dma_sync_for_device() to take a netmem
  page_pool: Convert page_pool_recycle_in_cache() to netmem
  page_pool: Remove page_pool_defrag_page()
  page_pool: Use netmem in page_pool_drain_frag()
  page_pool: Convert page_pool_return_skb_page() to use netmem
  page_pool: Convert frag_page to frag_nmem
  xdp: Convert to netmem
  mm: Remove page pool members from struct page
  netmem_to_virt
  page_pool: Pass a netmem to init_callback()
  net: Add support for netmem in skb_frag
  mvneta: Convert to netmem

 drivers/net/ethernet/marvell/mvneta.c |  48 ++---
 include/linux/mm_types.h              |  22 ---
 include/linux/skbuff.h                |  11 ++
 include/net/page_pool.h               | 181 ++++++++++++++---
 include/trace/events/page_pool.h      |  28 +--
 net/bpf/test_run.c                    |   4 +-
 net/core/page_pool.c                  | 274 +++++++++++++-------------
 net/core/xdp.c                        |   7 +-
 8 files changed, 344 insertions(+), 231 deletions(-)


base-commit: 13ee7ef407cfcf63f4f047460ac5bb6ba5a3447d
-- 
2.35.1


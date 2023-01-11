Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E46F6652CC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbjAKEYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbjAKEXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:23:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8A013DF1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ccAV47NGyzUKHaLwSknHK+4sPU0V4c7X6TXLSvHsxhw=; b=u6UqEDOXVSQEhy0PFpvN1BjT65
        VRd3zaSADszmGctqM8BVv2VeH4OFJfGVoAf1jfkgXa2jTsSMJamaRnhllD//2pYsKfV8vq2PGAXO9
        6HzigS86/bXNxbCc1uRROKLX7PMeyNHjT0GYP0QuvxsoBr1qhDgd5WT7w/uwIq71LUAR05/5s+gr2
        unG3VwVesKOex+n2TR3ozXIexpkKX7xvmCmWwIQCmKRWENEM6UsMtUP/VtxadTzCmDbD1KlLImmVg
        fnXLhg+T7QTl19EaH3Gf5A8YAAJLhInuNPPBS4MFouYOAKGz27zvPAxucDprEwfxTqHTVDzWTZa6O
        CjaCKHkQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxg-4N; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v3 00/26] Split netmem from struct page
Date:   Wed, 11 Jan 2023 04:21:48 +0000
Message-Id: <20230111042214.907030-1-willy@infradead.org>
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
users, as has already been done with folio and slab.  This patchset does
that for netmem which is used for page pools.

There are some relatively significant reductions in kernel text size
from these changes.  They don't appear to affect performance at all,
but it's nice to save a bit of memory.

v3:
 - Rebase to next-20230110
 - Add received Acked-by and Reviewed-by tags (thanks!)
 - Mark compat functions in page_pool.h (Ilias)
 - Correct a patch title
 - Convert hns3 driver (and page_pool_dev_alloc_frag())
 - Make page_pool_recycle_direct() accept a netmem or page pointer

Matthew Wilcox (Oracle) (26):
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
  page_pool: Remove __page_pool_put_page()
  page_pool: Use netmem in page_pool_drain_frag()
  page_pool: Convert page_pool_return_skb_page() to use netmem
  page_pool: Allow page_pool_recycle_direct() to take a netmem or a page
  page_pool: Convert frag_page to frag_nmem
  xdp: Convert to netmem
  mm: Remove page pool members from struct page
  page_pool: Pass a netmem to init_callback()
  net: Add support for netmem in skb_frag
  mvneta: Convert to netmem
  mlx5: Convert to netmem
  hns3: Convert to netmem

 Documentation/networking/page_pool.rst        |   5 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  16 +-
 drivers/net/ethernet/marvell/mvneta.c         |  48 +--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  24 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 130 +++++----
 include/linux/mm_types.h                      |  22 --
 include/linux/skbuff.h                        |  11 +
 include/net/page_pool.h                       | 228 ++++++++++++---
 include/trace/events/page_pool.h              |  28 +-
 net/bpf/test_run.c                            |   4 +-
 net/core/page_pool.c                          | 274 +++++++++---------
 net/core/xdp.c                                |   7 +-
 16 files changed, 493 insertions(+), 332 deletions(-)

-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA7D247EFE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHRHIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:08:15 -0400
Received: from mx55.baidu.com ([61.135.168.55]:18138 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726043AbgHRHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:08:14 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id B9A2611C005B;
        Tue, 18 Aug 2020 15:07:57 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH][v3] i40e: optimise prefetch page refcount
Date:   Tue, 18 Aug 2020 15:07:57 +0800
Message-Id: <1597734477-27859-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount of rx_buffer page will be added here originally, so prefetchw
is needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
 better handle incrementing page count"), and refcount is not added
everytime, so change prefetchw as prefetch,

now it mainly services page_address(), but which accesses struct page
only when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined otherwise
it returns address based on offset, so we prefetch it conditionally

Jakub suggested to define prefetch_page_address in a common header

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v2: fix a build warning -Wvisibility 
diff with v1: create a common function prefetch_page_address
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
 include/linux/prefetch.h                    | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 62f5b2d35f63..5f9fe55bb66d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1953,7 +1953,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 	struct i40e_rx_buffer *rx_buffer;
 
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-	prefetchw(rx_buffer->page);
+	prefetch_page_address(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index 13eafebf3549..b83a3f944f28 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -15,6 +15,7 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct page;
 /*
 	prefetch(x) attempts to pre-emptively get the memory pointed to
 	by address "x" into the CPU L1 cache. 
@@ -62,4 +63,11 @@ static inline void prefetch_range(void *addr, size_t len)
 #endif
 }
 
+static inline void prefetch_page_address(struct page *page)
+{
+#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
+	prefetch(page);
+#endif
+}
+
 #endif
-- 
2.16.2


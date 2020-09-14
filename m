Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D952D269370
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgINRcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:32:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:61362 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgINRci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:32:38 -0400
IronPort-SDR: NJJopbuFf92Z5MwpyoN0TVJvogD6je2eW4CRgl7f+kT+RC3KJS2xJgUc13ruaRVD/7fZMUm1bA
 R4udQUPJo1zQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160056113"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160056113"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
IronPort-SDR: I0y1i/y270dnuRoB8b+tq2+R/DlqfxFdAk1gHMauygn1OipKB7IlxKM12uumoHYHpmU6MnoHIL
 np6JvmExcEBg==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="319137314"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        kernel test robot <lkp@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 2/5] i40e: optimise prefetch page refcount
Date:   Mon, 14 Sep 2020 10:32:21 -0700
Message-Id: <20200914173224.692707-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
References: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

refcount of rx_buffer page will be added here originally, so prefetchw
is needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
better handle incrementing page count"), and refcount is not added
every time, so change prefetchw as prefetch.

Now it mainly services page_address(), but which accesses struct page
only when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined otherwise
it returns address based on offset, so we prefetch it conditionally.

Jakub suggested to define prefetch_page_address in a common header.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
 include/linux/prefetch.h                    | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 91ab824926b9..8500e1c1a16b 100644
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
2.26.2


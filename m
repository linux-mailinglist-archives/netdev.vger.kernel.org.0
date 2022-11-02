Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D7A616EE8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiKBUkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiKBUkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:40:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A96556
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667421622; x=1698957622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deEemwORbGPxwtZ/k/K/+fU7pHp6OFY9978IJsRhS0A=;
  b=iZcaaJMTM9VkKSNILrz6WGk450wNnOdk12bLALqUSv2pLZIstuQ4rDuF
   WeYqdvybRMzLS+9ovkeRxJYNYm/rzaoiwaAWVjkQth0TRFZ7W5i/q3ZXl
   eFdfU3eKKc+Iti1mJEwaGpyPM6UKjE7TJxg7mTqo/xJfq/NqP+TKtapf0
   PQ1Z4qcJOYny3N0rw+BE2EeoCivXEHKoIixfcb6WIDoGzTGaEBwKMfacV
   fXoBKrHSl+NVRms8pDjSnsvt9mjCS8zkXje9ZCbSYJeb4KkvTospnx5rN
   z7T97m//0Wm5hO/JGbF9JWLIj8Wm+llGif4b+qx/syO/VlaRDpkHleRws
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="336202187"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="336202187"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 13:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="612385337"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="612385337"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2022 13:40:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 4/6] e1000e: Remove unnecessary use of kmap_atomic()
Date:   Wed,  2 Nov 2022 13:39:55 -0700
Message-Id: <20221102203957.2944396-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
References: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

alloc_rx_buf() allocates ps_page->page and buffer_info->page using either
GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC can't
come from highmem and so there's no need to kmap() them. Just use
page_address().

I don't have access to a 32-bit system so did some limited testing on qemu
(qemu-system-i386 -m 4096 -smp 4 -device e1000e) with a 32-bit Debian 11.04
image.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f0e015673f48..36bc4fd91ef4 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1391,26 +1391,18 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 
 			/* page alloc/put takes too long and effects small
 			 * packet throughput, so unsplit small packets and
-			 * save the alloc/put only valid in softirq (napi)
-			 * context to call kmap_*
+			 * save the alloc/put
 			 */
 			if (l1 && (l1 <= copybreak) &&
 			    ((length + l1) <= adapter->rx_ps_bsize0)) {
-				u8 *vaddr;
-
 				ps_page = &buffer_info->ps_pages[0];
 
-				/* there is no documentation about how to call
-				 * kmap_atomic, so we can't hold the mapping
-				 * very long
-				 */
 				dma_sync_single_for_cpu(&pdev->dev,
 							ps_page->dma,
 							PAGE_SIZE,
 							DMA_FROM_DEVICE);
-				vaddr = kmap_atomic(ps_page->page);
-				memcpy(skb_tail_pointer(skb), vaddr, l1);
-				kunmap_atomic(vaddr);
+				memcpy(skb_tail_pointer(skb),
+				       page_address(ps_page->page), l1);
 				dma_sync_single_for_device(&pdev->dev,
 							   ps_page->dma,
 							   PAGE_SIZE,
@@ -1610,11 +1602,9 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 				 */
 				if (length <= copybreak &&
 				    skb_tailroom(skb) >= length) {
-					u8 *vaddr;
-					vaddr = kmap_atomic(buffer_info->page);
-					memcpy(skb_tail_pointer(skb), vaddr,
+					memcpy(skb_tail_pointer(skb),
+					       page_address(buffer_info->page),
 					       length);
-					kunmap_atomic(vaddr);
 					/* re-use the page, so don't erase
 					 * buffer_info->page
 					 */
-- 
2.35.1


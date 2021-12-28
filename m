Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7AB480C39
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhL1R7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:59:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:41226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhL1R7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 12:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640714343; x=1672250343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csKwla5a5wzK7Q6Sqj3lLGvBQvVOtqdOdA98qBoi0NY=;
  b=duUpwd9RTwIR4Myk4ADrpv9CSX2BE7wpl3hgKp5kO1TEl3aSiEIbCUrs
   jkqAicEDRkjm/i7N5yXZfc+Io/LnHe6yt9LCfNfCQU15TygMREQiHLAV7
   hjUMwZX9MtQ2L5/CLw7/gK90VZ9fNsLvPxOL6cEotaI0D/PNZCLvET/GM
   /9IQ7H98NQi6t49RAR3jbcrak75RDn9TnQFt1N6G60qz2e9lyxSG2we9V
   ezMtGHB256HaE0PmOnwuDMBCkvPMwA5ki0hEnyl+uHAgwfYoBTo8BUSxM
   rl17sTzKe+mqJ/xc0qq3keA19qjUndoepji4r74O355mBrvb3jeUSrbx8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="228705144"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="228705144"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 09:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="589071989"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 28 Dec 2021 09:59:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 1/9] e1000: switch to napi_consume_skb()
Date:   Tue, 28 Dec 2021 09:58:07 -0800
Message-Id: <20211228175815.281449-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
References: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

In order to take the best from per-cpu NAPI skbuff_head caches and
CPU cycles, let's switch from dev_kfree_skb_any(), which passes skb
back to the mm layer, to napi_consume_skb(), which feeds those
caches on non-zero budget instead (falls back to the former on 0).
Do the replacement in e1000_unmap_and_free_tx_resource(). There are
4 call sites of this function throughout the driver:
 * e1000_clean_tx_ring(). Slowpath, process context, cleans the
   whole Tx ring on ifdown. Use budget of 0 here;
 * e1000_tx_map(). Hotpath, net Tx softirq, unmaps the buffers in
   case of error. Use 0 as well;
 * e1000_clean_tx_irq(). Hotpath, NAPI Tx completion polling cycle.
   As the driver doesn't count completed Tx entries towards the NAPI
   budget, just use the poll budget of 64 to utilize caches.

Apart from being a preparation for switching to napi_build_skb(),
this is useful on its own as well, as napi_consume_skb() flushes
skb caches by batches of 32 instead of one-at-a-time.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 669060a2e6aa..975a145d48ef 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1953,7 +1953,8 @@ void e1000_free_all_tx_resources(struct e1000_adapter *adapter)
 
 static void
 e1000_unmap_and_free_tx_resource(struct e1000_adapter *adapter,
-				 struct e1000_tx_buffer *buffer_info)
+				 struct e1000_tx_buffer *buffer_info,
+				 int budget)
 {
 	if (buffer_info->dma) {
 		if (buffer_info->mapped_as_page)
@@ -1966,7 +1967,7 @@ e1000_unmap_and_free_tx_resource(struct e1000_adapter *adapter,
 		buffer_info->dma = 0;
 	}
 	if (buffer_info->skb) {
-		dev_kfree_skb_any(buffer_info->skb);
+		napi_consume_skb(buffer_info->skb, budget);
 		buffer_info->skb = NULL;
 	}
 	buffer_info->time_stamp = 0;
@@ -1990,7 +1991,7 @@ static void e1000_clean_tx_ring(struct e1000_adapter *adapter,
 
 	for (i = 0; i < tx_ring->count; i++) {
 		buffer_info = &tx_ring->buffer_info[i];
-		e1000_unmap_and_free_tx_resource(adapter, buffer_info);
+		e1000_unmap_and_free_tx_resource(adapter, buffer_info, 0);
 	}
 
 	netdev_reset_queue(adapter->netdev);
@@ -2958,7 +2959,7 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 			i += tx_ring->count;
 		i--;
 		buffer_info = &tx_ring->buffer_info[i];
-		e1000_unmap_and_free_tx_resource(adapter, buffer_info);
+		e1000_unmap_and_free_tx_resource(adapter, buffer_info, 0);
 	}
 
 	return 0;
@@ -3856,7 +3857,8 @@ static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
 				}
 
 			}
-			e1000_unmap_and_free_tx_resource(adapter, buffer_info);
+			e1000_unmap_and_free_tx_resource(adapter, buffer_info,
+							 64);
 			tx_desc->upper.data = 0;
 
 			if (unlikely(++i == tx_ring->count))
-- 
2.31.1


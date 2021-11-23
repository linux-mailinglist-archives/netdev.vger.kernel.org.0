Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997A445A9F2
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhKWR1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:27:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:31051 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238958AbhKWR1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:27:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215098701"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215098701"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 09:20:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="597151909"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2021 09:20:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANHK9Qf024401;
        Tue, 23 Nov 2021 17:20:10 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] e1000: switch to napi_consume_skb()
Date:   Tue, 23 Nov 2021 18:18:32 +0100
Message-Id: <20211123171840.157471-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123171840.157471-1-alexandr.lobakin@intel.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1623B45A9F1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhKWR1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:27:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:11148 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238615AbhKWR1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:27:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="234892559"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="234892559"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 09:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="591264974"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2021 09:20:14 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANHK9Qj024401;
        Tue, 23 Nov 2021 17:20:13 GMT
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
Subject: [PATCH net-next 5/9] ice: switch to napi_build_skb()
Date:   Tue, 23 Nov 2021 18:18:36 +0100
Message-Id: <20211123171840.157471-6-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123171840.157471-1-alexandr.lobakin@intel.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order
to save some cycles on freeing/allocating skbuff_heads on every
new Rx or completed Tx.
ice driver runs Tx completion polling cycle right before the Rx
one and uses napi_consume_skb() to feed the cache with skbuff_heads
of completed entries, so it's never empty and always warm at that
moment. Switch to the napi_build_skb() to relax mm pressure on
heavy Rx.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..b7be441efe54 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -933,7 +933,7 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	 */
 	net_prefetch(xdp->data_meta);
 	/* build an skb around the page buffer */
-	skb = build_skb(xdp->data_hard_start, truesize);
+	skb = napi_build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
 		return NULL;

--
2.33.1


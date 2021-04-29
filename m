Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB34536EDF9
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhD2QRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:17:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:13478 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhD2QRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 12:17:07 -0400
IronPort-SDR: 4lcGCzecOmrAFRztIGs/7k6++Khn+BDxCzEVHdnlQyrmeB6Mfyq9PFvwU3fGcEDctws7Fyvm1o
 /gcprPp9Uslg==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="193858111"
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="193858111"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 09:16:20 -0700
IronPort-SDR: za7ODJ5wimsjzX7ocHYQoMe+Nh5mRVPp5SEN5oQcC+q3xB5XsRVolq7zcVk99U01ldzrsCcNuV
 jmXsBeR7GgDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="426062676"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 29 Apr 2021 09:16:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net 1/1] i40e: fix broken XDP support
Date:   Thu, 29 Apr 2021 09:18:20 -0700
Message-Id: <20210429161820.827651-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Commit 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c") broke
XDP support in the i40e driver. That commit was fixing a sparse error
in the code by introducing a new variable xdp_res instead of
overloading this into the skb pointer. The problem is that the code
later uses the skb pointer in if statements and these where not
extended to also test for the new xdp_res variable. Fix this by adding
the correct tests for xdp_res in these places.

The skb pointer was used to store the result of the XDP program by
overloading the results in the error pointer
ERR_PTR(-result). Therefore, the allocation failure test that used to
only test for !skb now need to be extended to also consider !xdp_res.

i40e_cleanup_headers() had a check that based on the skb value being
an error pointer, i.e. a result from the XDP program != XDP_PASS, and
if so start to process a new packet immediately, instead of populating
skb fields and sending the skb to the stack. This check is not needed
anymore, since we have added an explicit test for xdp_res being set
and if so just do continue to pick the next packet from the NIC.

Fixes: 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 06b4271219b1..70b515049540 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1961,10 +1961,6 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 				 union i40e_rx_desc *rx_desc)
 
 {
-	/* XDP packets use error pointer so abort at this point */
-	if (IS_ERR(skb))
-		return true;
-
 	/* ERR_MASK will only have valid bits if EOP set, and
 	 * what we are doing here is actually checking
 	 * I40E_RX_DESC_ERROR_RXE_SHIFT, since it is the zeroth bit in
@@ -2534,7 +2530,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		}
 
 		/* exit if we failed to retrieve a buffer */
-		if (!skb) {
+		if (!xdp_res && !skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			rx_buffer->pagecnt_bias++;
 			break;
@@ -2547,7 +2543,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-		if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
+		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
 			skb = NULL;
 			continue;
 		}
-- 
2.26.2


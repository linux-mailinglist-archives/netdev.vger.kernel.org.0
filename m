Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B43231A7FB
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhBLWpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:45:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:44260 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232373AbhBLWmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:42:15 -0500
IronPort-SDR: kbnJ+9D8IZnS7RZKc9Nh14SG6UD3CT4c/gFv21Cvbx1WfK9bsJwYSNUUNGgwQVeuMpdeeJVdCp
 YdMk2XQ2bfWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617158"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617158"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:00 -0800
IronPort-SDR: RmyMkJJqC98h18IpLciywTN0xUxfitoAH+aCpP9LIMuuMWlxXxd0mcTqdihmy6rNXT7AeOL15S
 dnm+QBHq4IaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885356"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 03/11] i40e: adjust i40e_is_non_eop
Date:   Fri, 12 Feb 2021 14:39:44 -0800
Message-Id: <20210212223952.1172568-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

i40e_is_non_eop had a leftover comment and unused skb argument which was
used for placing the skb onto rx_buf in case when current buffer was
non-eop one. This is not relevant anymore as commit e72e56597ba1
("i40e/i40evf: Moves skb from i40e_rx_buffer to i40e_ring") pulled the
non-complete skb handling out of rx_bufs up to rx_ring.  Therefore,
let's adjust the function arguments that i40e_is_non_eop takes.

Furthermore, since there is already a function responsible for bumping
the ntc, make use of that and drop that logic from i40e_is_non_eop so
that the scope of this function is limited to what the name actually
states.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 23 ++++++---------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 5f6aa13e85ca..79ca608ee152 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2271,25 +2271,13 @@ static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
  * i40e_is_non_eop - process handling of non-EOP buffers
  * @rx_ring: Rx ring being processed
  * @rx_desc: Rx descriptor for current buffer
- * @skb: Current socket buffer containing buffer in progress
  *
- * This function updates next to clean.  If the buffer is an EOP buffer
- * this function exits returning false, otherwise it will place the
- * sk_buff in the next buffer to be chained and return true indicating
- * that this is in fact a non-EOP buffer.
- **/
+ * If the buffer is an EOP buffer, this function exits returning false,
+ * otherwise return true indicating that this is in fact a non-EOP buffer.
+ */
 static bool i40e_is_non_eop(struct i40e_ring *rx_ring,
-			    union i40e_rx_desc *rx_desc,
-			    struct sk_buff *skb)
+			    union i40e_rx_desc *rx_desc)
 {
-	u32 ntc = rx_ring->next_to_clean + 1;
-
-	/* fetch, update, and store next to clean */
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
-
 	/* if we are the last buffer then there is nothing else to do */
 #define I40E_RXD_EOF BIT(I40E_RX_DESC_STATUS_EOF_SHIFT)
 	if (likely(i40e_test_staterr(rx_desc, I40E_RXD_EOF)))
@@ -2568,7 +2556,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
 		cleaned_count++;
 
-		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
+		i40e_inc_ntc(rx_ring);
+		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
 		if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
-- 
2.26.2


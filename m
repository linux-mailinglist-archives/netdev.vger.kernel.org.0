Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4466996E7
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBPOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBPOPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:15:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506DFA5C7;
        Thu, 16 Feb 2023 06:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676556933; x=1708092933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8VWWNqJ/ZkjsHE6fhyCY030LG6tahcl5cgZa5zjKV34=;
  b=ZLKHwVugqarTHYJD5XeuzvuQMlfH5MtAYxLCc+phqW7o3S+0E4O/T9LW
   JcYD5+U4ZsYtE/4pHwv4udNWSh6BT4w6wNe+QHjBdzcbLovNn6LUdQ4+D
   Qt4HqnjsCmq2a4lJtSFdUC82K69slLsMJ20vlZMVS1n42M/sKOrqe67dI
   opbv9/HDtL7e9cyNFGUBAL5xjSsJhJhIdh3wGKKbsxzhpiNaEs0zafkDo
   KpU4bPnHM7Rxm8VwDNXpI9tpCoc6bCF5cXS1ZX5lTFQGsUngbJgKfDmtS
   dlxdvaOSGJfMKTUR6GZKDt/vnRTjAVDIYyfjAsqDIO1MFd/6S2npwdM3m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359154778"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359154778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:15:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="738838187"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="738838187"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:15:26 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH intel-next v5 6/8] i40e: introduce next_to_process to i40e_ring
Date:   Thu, 16 Feb 2023 19:30:41 +0530
Message-Id: <20230216140043.109345-7-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216140043.109345-1-tirthendu.sarkar@intel.com>
References: <20230216140043.109345-1-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new field called next_to_process in the i40e_ring that is
advanced for every buffer and change the semantics of next_to_clean to
point to the first buffer of a packet. Driver will use next_to_process
in the same way next_to_clean was used previously.

For the non multi-buffer case, next_to_process and next_to_clean will
always be the same since each packet consists of a single buffer.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 26 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  4 ++++
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 01340f620d96..94c50fa223bd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1524,6 +1524,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_process = 0;
 	rx_ring->next_to_use = 0;
 }
 
@@ -1576,6 +1577,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_process = 0;
 	rx_ring->next_to_use = 0;
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
@@ -2076,7 +2078,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 {
 	struct i40e_rx_buffer *rx_buffer;
 
-	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_process);
 	rx_buffer->page_count =
 #if (PAGE_SIZE < 8192)
 		page_count(rx_buffer->page);
@@ -2375,16 +2377,16 @@ void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 }
 
 /**
- * i40e_inc_ntc: Advance the next_to_clean index
+ * i40e_inc_ntp: Advance the next_to_process index
  * @rx_ring: Rx ring
  **/
-static void i40e_inc_ntc(struct i40e_ring *rx_ring)
+static void i40e_inc_ntp(struct i40e_ring *rx_ring)
 {
-	u32 ntc = rx_ring->next_to_clean + 1;
+	u32 ntp = rx_ring->next_to_process + 1;
 
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
+	ntp = (ntp < rx_ring->count) ? ntp : 0;
+	rx_ring->next_to_process = ntp;
+	prefetch(I40E_RX_DESC(rx_ring, ntp));
 }
 
 /**
@@ -2421,6 +2423,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
+		u16 ntp = rx_ring->next_to_process;
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
 		unsigned int size;
@@ -2433,7 +2436,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			cleaned_count = 0;
 		}
 
-		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		rx_desc = I40E_RX_DESC(rx_ring, ntp);
 
 		/* status_error_len will always be zero for unused descriptors
 		 * because it's cleared in cleanup, and overlaps with hdr_addr
@@ -2452,8 +2455,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
-			rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-			i40e_inc_ntc(rx_ring);
+			rx_buffer = i40e_rx_bi(rx_ring, ntp);
+			i40e_inc_ntp(rx_ring);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
 			cleaned_count++;
 			continue;
@@ -2509,7 +2512,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		i40e_put_rx_buffer(rx_ring, rx_buffer);
 		cleaned_count++;
 
-		i40e_inc_ntc(rx_ring);
+		i40e_inc_ntp(rx_ring);
+		rx_ring->next_to_clean = rx_ring->next_to_process;
 		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 3e2935365104..6e0fd73367df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -338,6 +338,10 @@ struct i40e_ring {
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 __iomem *tail;
 
+	/* Next descriptor to be processed; next_to_clean is updated only on
+	 * processing EOP descriptor
+	 */
+	u16 next_to_process;
 	/* high bit set means dynamic, use accessor routines to read/write.
 	 * hardware only supports 2us resolution for the ITR registers.
 	 * these values always store the USER setting, and must be converted
-- 
2.34.1


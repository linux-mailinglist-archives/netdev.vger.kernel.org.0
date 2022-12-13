Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D60C64B3BC
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiLMLEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiLMLEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:04:22 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C53B25C9;
        Tue, 13 Dec 2022 03:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670929461; x=1702465461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qF6yS4zMzR+LCrE83ZBnpHGSSoW4ONErsaC5DvvUk3Q=;
  b=lCzLa3kpSr+Cp3FsXnrwN0tkj1MyWrrIU++wl1NUVwmZSHSq4or3DyK8
   0PnqgD+M3c6TJlAgyzJC4w4eBdlQi4w/rXFLZCPL//2OKRkIMhgo9N4IN
   1+tT7d7HILVS3SuHtzCvDPHjzUR5QTLRFM8RvsW9Du9lhg7jHEvGH689C
   D0bVUxprZZl9xOG/QO09xMRGTxwjAt/49+5wWoELiiDbIcAW5q2sZfL4r
   0yefGa2PPv9ca+ki8DmTzg5i7Cu0n7CwGQONV/kf7NkcdNXIjOIdix/FL
   7751JG4XEtzD6c6iknT+84IxPGxxOjtpD/a7aiY67ryg6X1rmUUmvKb18
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305744390"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="305744390"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679263042"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="679263042"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:18 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Subject: [PATCH intel-next 3/5] i40e: introduce next_to_process to i40e_ring
Date:   Tue, 13 Dec 2022 16:20:21 +0530
Message-Id: <20221213105023.196409-4-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 15 ++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  4 ++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index c6296cf08294..e01bcc91a196 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -13,6 +13,7 @@
 
 #define I40E_TXD_CMD (I40E_TX_DESC_CMD_EOP | I40E_TX_DESC_CMD_RS)
 #define I40E_IDX_NEXT(n, max) { if (++(n) > (max)) n = 0; }
+#define I40E_INC_NEXT(p, c, max) do { I40E_IDX_NEXT(p, max); c = p; } while (0)
 /**
  * i40e_fdir - Generate a Flow Director descriptor based on fdata
  * @tx_ring: Tx ring to send buffer on
@@ -1526,6 +1527,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
+	rx_ring->next_to_process = 0;
 }
 
 /**
@@ -1576,6 +1578,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	}
 
 	rx_ring->next_to_alloc = 0;
+	rx_ring->next_to_process = 0;
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 
@@ -2425,6 +2428,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
 	struct sk_buff *skb = rx_ring->skb;
+	u16 ntp = rx_ring->next_to_process;
 	u16 ntc = rx_ring->next_to_clean;
 	u16 rmax = rx_ring->count - 1;
 	unsigned int xdp_xmit = 0;
@@ -2453,7 +2457,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			cleaned_count = 0;
 		}
 
-		rx_desc = I40E_RX_DESC(rx_ring, ntc);
+		rx_desc = I40E_RX_DESC(rx_ring, ntp);
 
 		/* status_error_len will always be zero for unused descriptors
 		 * because it's cleared in cleanup, and overlaps with hdr_addr
@@ -2472,8 +2476,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
-			rx_buffer = i40e_rx_bi(rx_ring, ntc);
-			I40E_IDX_NEXT(ntc, rmax);
+			rx_buffer = i40e_rx_bi(rx_ring, ntp);
+			I40E_INC_NEXT(ntp, ntc, rmax);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
 			cleaned_count++;
 			continue;
@@ -2485,7 +2489,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size, ntc);
+		rx_buffer = i40e_get_rx_buffer(rx_ring, size, ntp);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2529,7 +2533,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		i40e_put_rx_buffer(rx_ring, rx_buffer);
 		cleaned_count++;
 
-		I40E_IDX_NEXT(ntc, rmax);
+		I40E_INC_NEXT(ntp, ntc, rmax);
 		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
@@ -2551,6 +2555,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		/* update budget accounting */
 		total_rx_packets++;
 	}
+	rx_ring->next_to_process = ntp;
 	rx_ring->next_to_clean = ntc;
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index eec4a4a99b9c..c1b5013f5c9c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -337,6 +337,10 @@ struct i40e_ring {
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 __iomem *tail;
 
+	u16 next_to_process;		/* Next descriptor to be processed; for MB packet
+					 * next_to_clean will be updated only after all
+					 * buffers have been processed.
+					 */
 	/* high bit set means dynamic, use accessor routines to read/write.
 	 * hardware only supports 2us resolution for the ITR registers.
 	 * these values always store the USER setting, and must be converted
-- 
2.34.1


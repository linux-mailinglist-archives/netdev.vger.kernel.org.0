Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2B6557772
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiFWKJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiFWKJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:09:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5EF443E5;
        Thu, 23 Jun 2022 03:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655978947; x=1687514947;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jA77PzIoNXk7nFImbHRx1GPrP2Ro2H86IsqPha9kQtg=;
  b=VYyu7fgzIIefFU23oidUum1hzvP7MGvqqtts0sC9E/WCkN9cxr4yHqp/
   mSOs+OwmH9OUobQ+CFty66Ap/ezlv9IxdBZMUvC4sj0xbj+ZHQPczpCOj
   y0k7qY8HWOIl/atx8lA4C8ngZioCZUXEevF0Sp/XhJP8s0jyLXTGJqIm7
   mUDlp8ePLORJQRZB3RIl0HfiWRQzenn7JNd3SHZ+96yE3AOU9DNHIaPTn
   T1ZQ02+Nwxs1Q9Rmb94LLhFITRJ09N5MMuPcg2Sy18paK1k19PSzmtJqE
   i7xEyRiegK56+C5eFflo+8J2b8ciwybJJtrwcK66jW8f1ZDM5ZmnB4CXy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="263712755"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="263712755"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 03:09:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="915126988"
Received: from silpixa00401086.ir.intel.com ([10.55.128.124])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 03:09:04 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        zeffron@riotgames.com, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH net-next v2] i40e: read the XDP program once per NAPI
Date:   Thu, 23 Jun 2022 10:08:52 +0000
Message-Id: <20220623100852.7867-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to how it's done in the ice driver since 'eb087cd82864 ("ice:
propagate xdp_ring onto rx_ring")', read the XDP program once per NAPI
instead of once per descriptor cleaned. I measured an improvement in
throughput of 2% for the AF_XDP xdpsock l2fwd benchmark for zero copy mode
and 1% for copy mode.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 ++++++-----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 17 ++++++++++-------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index dadef56e5f9b..a327189deda0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2289,16 +2289,14 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
  * i40e_run_xdp - run an XDP program
  * @rx_ring: Rx ring being processed
  * @xdp: XDP buffer containing the frame
+ * @xdp_prog: XDP program to run
  **/
-static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
-	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-
 	if (!xdp_prog)
 		goto xdp_out;
 
@@ -2443,6 +2441,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	unsigned int offset = rx_ring->rx_offset;
 	struct sk_buff *skb = rx_ring->skb;
 	unsigned int xdp_xmit = 0;
+	struct bpf_prog *xdp_prog;
 	bool failure = false;
 	struct xdp_buff xdp;
 	int xdp_res = 0;
@@ -2452,6 +2451,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 #endif
 	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
@@ -2512,7 +2513,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
 #endif
-			xdp_res = i40e_run_xdp(rx_ring, &xdp);
+			xdp_res = i40e_run_xdp(rx_ring, &xdp, xdp_prog);
 		}
 
 		if (xdp_res) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index af3e7e6afc85..6d4009e0cbd6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -143,20 +143,17 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
  * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
+ * @xdp_prog: XDP program to run
  *
  * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
  **/
-static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
+			   struct bpf_prog *xdp_prog)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
-	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	/* NB! xdp_prog will always be !NULL, due to the fact that
-	 * this path is enabled by setting an XDP program.
-	 */
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (likely(act == XDP_REDIRECT)) {
@@ -339,9 +336,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
+	struct bpf_prog *xdp_prog;
 	bool failure = false;
 	u16 cleaned_count;
 
+	/* NB! xdp_prog will always be !NULL, due to the fact that
+	 * this path is enabled by setting an XDP program.
+	 */
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
 		unsigned int rx_packets;
@@ -378,7 +381,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, bi, xdp_prog);
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
 					  &rx_bytes, size, xdp_res, &failure);
 		if (failure)
-- 
2.25.1


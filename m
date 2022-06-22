Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE7554665
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbiFVJPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFVJPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:15:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA52E4;
        Wed, 22 Jun 2022 02:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655889315; x=1687425315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qkIbc9bgxwlz5t1sR0ht0Cvk/IpQWMrSNCWK6J6W2/A=;
  b=X4cIlpYb4Ne449deqTVWfktSJ5+mVOUkdKIYUISZbjn57Kf1RT8tWF95
   iu5Jwc6Fk4BrYShfSI4glkudRpekP8nRNEp8+fQGoM7RwM5vBlyMZWKiw
   WmOl1/0DNJ2MkH7bpKzTyUyf1j5cPICrqnRHIMdq4TlwUYfAyYHgJ0V5l
   JHS711pqwT4l98oLWyzbXK6FakAmYnlB84iKZ4sZa6mIEAOuO9WzN7fSW
   vWMBbO5Ggr0JyTMnM/6F86zkmk6f0Jg8Ub0fGKxEjxaUYAhTwRlI32jde
   GiCQq/97Rn8vKJVeJzzXyOAVr8V6NMBSyKMDIICvV8ssuVyrFaKkpEYLa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="344354844"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="344354844"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:15:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="562883193"
Received: from silpixa00401086.ir.intel.com ([10.55.128.124])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:15:12 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH net-next] i40e: xsk: read the XDP program once per NAPI
Date:   Wed, 22 Jun 2022 09:14:47 +0000
Message-Id: <20220622091447.243101-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to how it's done in the ice driver since 'eb087cd82864 ("ice:
propagate xdp_ring onto rx_ring")', read the XDP program once per NAPI
instead of once per descriptor cleaned. I measured an improvement in
throughput of 2% for the AF_XDP xdpsock l2fwd benchmark in busy polling
mode on my platform.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index af3e7e6afc85..2f422c61ac11 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -146,17 +146,13 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
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
@@ -339,9 +335,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
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
@@ -378,7 +380,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, bi, xdp_prog);
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
 					  &rx_bytes, size, xdp_res, &failure);
 		if (failure)
-- 
2.25.1


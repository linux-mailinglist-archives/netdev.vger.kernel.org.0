Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB08E346
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfHODqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:46:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:56741 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfHODqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 23:46:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 20:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,387,1559545200"; 
   d="scan'208";a="352124058"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2019 20:46:23 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: [PATCH bpf-next 3/5] i40e: Enable XDP_SKIP_BPF option for AF_XDP sockets
Date:   Wed, 14 Aug 2019 20:46:21 -0700
Message-Id: <1565840783-8269-4-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch skips calling BPF program in the receive path if
the queue is associated with UMEM that is not shared and
bound to an AF_XDP socket that has enabled skip bpf during
bind() call.

Here are some performance numbers collected on 
  - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
  - Intel 40Gb Ethernet NIC (i40e)

All tests use 2 cores and the results are in Mpps.

turbo on (default)
---------------------------------------------	
                      no-skip-bpf    skip-bpf
---------------------------------------------	
rxdrop zerocopy           21.9         38.5 
l2fwd  zerocopy           17.0         20.5
rxdrop copy               11.1         13.3
l2fwd  copy                1.9          2.0

no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
---------------------------------------------	
                      no-skip-bpf    skip-bpf
---------------------------------------------	
rxdrop zerocopy           15.4         29.0
l2fwd  zerocopy           11.8         18.2
rxdrop copy                8.2         10.5
l2fwd  copy                1.7          1.7
---------------------------------------------	

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 22 +++++++++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  6 ++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e3f29dc8b290..5e63e3644e87 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2199,6 +2199,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	struct xdp_umem *umem;
 	u32 act;
 
 	rcu_read_lock();
@@ -2209,6 +2210,13 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
+	umem = xdp_get_umem_from_qid(rx_ring->netdev, rx_ring->queue_index);
+	if (xsk_umem_skip_bpf(umem)) {
+		err = xsk_umem_rcv(umem, xdp);
+		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		goto xdp_out;
+	}
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
@@ -2303,8 +2311,18 @@ void i40e_update_rx_stats(struct i40e_ring *rx_ring,
  **/
 void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 {
-	if (xdp_res & I40E_XDP_REDIR)
-		xdp_do_flush_map();
+	if (xdp_res & I40E_XDP_REDIR) {
+		struct xdp_umem *umem;
+
+		umem = rx_ring->xsk_umem;
+		if (!umem)
+			umem = xdp_get_umem_from_qid(rx_ring->netdev,
+						     rx_ring->queue_index);
+		if (xsk_umem_skip_bpf(umem))
+			xsk_umem_flush(umem);
+		else
+			xdp_do_flush_map();
+	}
 
 	if (xdp_res & I40E_XDP_TX) {
 		struct i40e_ring *xdp_ring =
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 32bad014d76c..cc538479c95d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -195,6 +195,12 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
+	if (xsk_umem_skip_bpf(rx_ring->xsk_umem)) {
+		err = xsk_umem_rcv(rx_ring->xsk_umem, xdp);
+		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		return result;
+	}
+
 	rcu_read_lock();
 	/* NB! xdp_prog will always be !NULL, due to the fact that
 	 * this path is enabled by setting an XDP program.
-- 
2.20.1


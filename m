Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9DE8E353
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbfHODqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:46:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:56741 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbfHODqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 23:46:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 20:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,387,1559545200"; 
   d="scan'208";a="352124060"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2019 20:46:23 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: [PATCH bpf-next 4/5] ixgbe: Enable XDP_SKIP_BPF option for AF_XDP sockets
Date:   Wed, 14 Aug 2019 20:46:22 -0700
Message-Id: <1565840783-8269-5-git-send-email-sridhar.samudrala@intel.com>
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

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 +++++++++++++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 16 +++++++++++++--
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index dc7b128c780e..594792860cdd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2197,6 +2197,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
 	struct xdp_frame *xdpf;
+	struct xdp_umem *umem;
 	u32 act;
 
 	rcu_read_lock();
@@ -2207,6 +2208,13 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
+	umem = xdp_get_umem_from_qid(rx_ring->netdev, rx_ring->queue_index);
+	if (xsk_umem_skip_bpf(umem)) {
+		err = xsk_umem_rcv(umem, xdp);
+		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		goto xdp_out;
+	}
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
@@ -2400,8 +2408,16 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		total_rx_packets++;
 	}
 
-	if (xdp_xmit & IXGBE_XDP_REDIR)
-		xdp_do_flush_map();
+	if (xdp_xmit & IXGBE_XDP_REDIR) {
+		struct xdp_umem *umem;
+
+		umem = xdp_get_umem_from_qid(rx_ring->netdev,
+					     rx_ring->queue_index);
+		if (xsk_umem_skip_bpf(umem))
+			xsk_umem_flush(umem);
+		else
+			xdp_do_flush_map();
+	}
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
 		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6b609553329f..9ea8a769d7a8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -148,6 +148,12 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	struct xdp_frame *xdpf;
 	u32 act;
 
+	if (xsk_umem_skip_bpf(rx_ring->xsk_umem)) {
+		err = xsk_umem_rcv(rx_ring->xsk_umem, xdp);
+		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		return result;
+	}
+
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
@@ -527,8 +533,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		ixgbe_rx_skb(q_vector, skb);
 	}
 
-	if (xdp_xmit & IXGBE_XDP_REDIR)
-		xdp_do_flush_map();
+	if (xdp_xmit & IXGBE_XDP_REDIR) {
+		struct xdp_umem *umem = rx_ring->xsk_umem;
+
+		if (xsk_umem_skip_bpf(umem))
+			xsk_umem_flush(umem);
+		else
+			xdp_do_flush_map();
+	}
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
 		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
-- 
2.20.1


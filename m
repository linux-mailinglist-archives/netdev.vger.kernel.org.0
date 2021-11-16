Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D5B452BA7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhKPHle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhKPHle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099064"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099064"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857339"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:34 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 4/8] i40e: handle the XDP_REDIRECT_XSK action
Date:   Tue, 16 Nov 2021 07:37:38 +0000
Message-Id: <20211116073742.7941-5-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the BPF program returns XDP_REDIRECT_XSK, obtain the pointer to the
socket from the netdev_rx_queue struct and call the newly exposed xsk_rcv
function to push the XDP descriptor to the Rx ring. Then use xsk_flush to
flush the socket.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 13 +++++++++++-
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 +++++++++++++------
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5385c7..b6a883a8d088 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -4,6 +4,7 @@
 #include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
 #include <net/xdp.h>
+#include <net/xdp_sock_drv.h>
 #include "i40e.h"
 #include "i40e_trace.h"
 #include "i40e_prototype.h"
@@ -2296,6 +2297,7 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	struct xdp_sock *xs;
 	u32 act;
 
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
@@ -2315,6 +2317,12 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		if (result == I40E_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_REDIRECT_XSK:
+		xs = xsk_get_redirect_xsk(&rx_ring->netdev->_rx[xdp->rxq->queue_index]);
+		err = xsk_rcv(xs, xdp);
+		if (err)
+			goto out_failure;
+		return I40E_XDP_REDIR_XSK;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
@@ -2401,6 +2409,9 @@ void i40e_update_rx_stats(struct i40e_ring *rx_ring,
  **/
 void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 {
+	if (xdp_res & I40E_XDP_REDIR_XSK)
+		xsk_flush(xsk_get_redirect_xsk(&rx_ring->netdev->_rx[rx_ring->queue_index]));
+
 	if (xdp_res & I40E_XDP_REDIR)
 		xdp_do_flush_map();
 
@@ -2516,7 +2527,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		}
 
 		if (xdp_res) {
-			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
+			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR | I40E_XDP_REDIR_XSK)) {
 				xdp_xmit |= xdp_res;
 				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
 			} else {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 19da3b22160f..17e521a71201 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -20,6 +20,7 @@ void i40e_release_rx_desc(struct i40e_ring *rx_ring, u32 val);
 #define I40E_XDP_CONSUMED	BIT(0)
 #define I40E_XDP_TX		BIT(1)
 #define I40E_XDP_REDIR		BIT(2)
+#define I40E_XDP_REDIR_XSK	BIT(3)
 
 /*
  * build_ctob - Builds the Tx descriptor (cmd, offset and type) qword
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index ea06e957393e..31b794672ea5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -144,13 +144,14 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
  *
- * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
+ * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR, REDIR_XSK}
  **/
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	struct xdp_sock *xs;
 	u32 act;
 
 	/* NB! xdp_prog will always be !NULL, due to the fact that
@@ -159,14 +160,21 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
-	if (likely(act == XDP_REDIRECT)) {
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+	if (likely(act == XDP_REDIRECT_XSK)) {
+		xs = xsk_get_redirect_xsk(&rx_ring->netdev->_rx[xdp->rxq->queue_index]);
+		err = xsk_rcv(xs, xdp);
 		if (err)
 			goto out_failure;
-		return I40E_XDP_REDIR;
+		return I40E_XDP_REDIR_XSK;
 	}
 
 	switch (act) {
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		if (err)
+			goto out_failure;
+		result = I40E_XDP_REDIR;
+		break;
 	case XDP_PASS:
 		break;
 	case XDP_TX:
@@ -275,7 +283,8 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 	*rx_packets = 1;
 	*rx_bytes = size;
 
-	if (likely(xdp_res == I40E_XDP_REDIR) || xdp_res == I40E_XDP_TX)
+	if (likely(xdp_res == I40E_XDP_REDIR_XSK) || xdp_res == I40E_XDP_REDIR ||
+	    xdp_res == I40E_XDP_TX)
 		return;
 
 	if (xdp_res == I40E_XDP_CONSUMED) {
@@ -371,7 +380,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 					  &rx_bytes, size, xdp_res);
 		total_rx_packets += rx_packets;
 		total_rx_bytes += rx_bytes;
-		xdp_xmit |= xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR);
+		xdp_xmit |= xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR | I40E_XDP_REDIR_XSK);
 		next_to_clean = (next_to_clean + 1) & count_mask;
 	}
 
-- 
2.17.1


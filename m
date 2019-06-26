Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721F456C3D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfFZOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59867 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbfFZOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:19 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY4027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 06/16] xsk: Return the whole xdp_desc from xsk_umem_consume_tx
Date:   Wed, 26 Jun 2019 17:35:28 +0300
Message-Id: <1561559738-4213-7-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Some drivers want to access the data transmitted in order to implement
acceleration features of the NICs. It is also useful in AF_XDP TX flow.

Change the xsk_umem_consume_tx API to return the whole xdp_desc, that
contains the data pointer, length and DMA address, instead of only the
latter two. Adapt the implementation of i40e and ixgbe to this change.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 12 +++++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 15 +++++++++------
 include/net/xdp_sock.h                       |  6 +++---
 net/xdp/xsk.c                                | 10 +++-------
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 557c565c26fc..32bad014d76c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -641,8 +641,8 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 	struct i40e_tx_desc *tx_desc = NULL;
 	struct i40e_tx_buffer *tx_bi;
 	bool work_done = true;
+	struct xdp_desc desc;
 	dma_addr_t dma;
-	u32 len;
 
 	while (budget-- > 0) {
 		if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
@@ -651,21 +651,23 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &dma, &len))
+		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
-		dma_sync_single_for_device(xdp_ring->dev, dma, len,
+		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
+
+		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
 					   DMA_BIDIRECTIONAL);
 
 		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
-		tx_bi->bytecount = len;
+		tx_bi->bytecount = desc.len;
 
 		tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
 		tx_desc->buffer_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz =
 			build_ctob(I40E_TX_DESC_CMD_ICRC
 				   | I40E_TX_DESC_CMD_EOP,
-				   0, len, 0);
+				   0, desc.len, 0);
 
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6af55bb3bef3..6b609553329f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -571,8 +571,9 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	union ixgbe_adv_tx_desc *tx_desc = NULL;
 	struct ixgbe_tx_buffer *tx_bi;
 	bool work_done = true;
-	u32 len, cmd_type;
+	struct xdp_desc desc;
 	dma_addr_t dma;
+	u32 cmd_type;
 
 	while (budget-- > 0) {
 		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
@@ -581,14 +582,16 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &dma, &len))
+		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
-		dma_sync_single_for_device(xdp_ring->dev, dma, len,
+		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
+
+		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
 					   DMA_BIDIRECTIONAL);
 
 		tx_bi = &xdp_ring->tx_buffer_info[xdp_ring->next_to_use];
-		tx_bi->bytecount = len;
+		tx_bi->bytecount = desc.len;
 		tx_bi->xdpf = NULL;
 		tx_bi->gso_segs = 1;
 
@@ -599,10 +602,10 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 		cmd_type = IXGBE_ADVTXD_DTYP_DATA |
 			   IXGBE_ADVTXD_DCMD_DEXT |
 			   IXGBE_ADVTXD_DCMD_IFCS;
-		cmd_type |= len | IXGBE_TXD_CMD;
+		cmd_type |= desc.len | IXGBE_TXD_CMD;
 		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 		tx_desc->read.olinfo_status =
-			cpu_to_le32(len << IXGBE_ADVTXD_PAYLEN_SHIFT);
+			cpu_to_le32(desc.len << IXGBE_ADVTXD_PAYLEN_SHIFT);
 
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index b6f5ebae43a1..057b159ff8b9 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -81,7 +81,7 @@ struct xdp_sock {
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
 void xsk_umem_discard_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
-bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t *dma, u32 *len);
+bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
 void xsk_umem_consume_tx_done(struct xdp_umem *umem);
 struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
 struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
@@ -175,8 +175,8 @@ static inline void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
 {
 }
 
-static inline bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t *dma,
-				       u32 *len)
+static inline bool xsk_umem_consume_tx(struct xdp_umem *umem,
+				       struct xdp_desc *desc)
 {
 	return false;
 }
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 35ca531ac74e..74417a851ed5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -172,22 +172,18 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_umem_consume_tx_done);
 
-bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t *dma, u32 *len)
+bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 {
-	struct xdp_desc desc;
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
-		if (!xskq_peek_desc(xs->tx, &desc))
+		if (!xskq_peek_desc(xs->tx, desc))
 			continue;
 
-		if (xskq_produce_addr_lazy(umem->cq, desc.addr))
+		if (xskq_produce_addr_lazy(umem->cq, desc->addr))
 			goto out;
 
-		*dma = xdp_umem_get_dma(umem, desc.addr);
-		*len = desc.len;
-
 		xskq_discard_desc(xs->tx);
 		rcu_read_unlock();
 		return true;
-- 
1.8.3.1


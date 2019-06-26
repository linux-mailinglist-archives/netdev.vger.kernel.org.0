Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8E56C20
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfFZOgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:20 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59828 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727660AbfFZOgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:18 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY0027430;
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
Subject: [PATCH bpf-next V6 02/16] xsk: Add API to check for available entries in FQ
Date:   Wed, 26 Jun 2019 17:35:24 +0300
Message-Id: <1561559738-4213-3-git-send-email-tariqt@mellanox.com>
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

Add a function that checks whether the Fill Ring has the specified
amount of descriptors available. It will be useful for mlx5e that wants
to check in advance, whether it can allocate a bulk of RX descriptors,
to get the best performance.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 21 +++++++++++++++++++++
 net/xdp/xsk.c          |  6 ++++++
 net/xdp/xsk_queue.h    | 14 ++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index ae0f368a62bb..b6f5ebae43a1 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -77,6 +77,7 @@ struct xdp_sock {
 void xsk_flush(struct xdp_sock *xs);
 bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
+bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
 void xsk_umem_discard_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
@@ -99,6 +100,16 @@ static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
 }
 
 /* Reuse-queue aware version of FILL queue helpers */
+static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
+{
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (rq->length >= cnt)
+		return true;
+
+	return xsk_umem_has_addrs(umem, cnt - rq->length);
+}
+
 static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 {
 	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
@@ -146,6 +157,11 @@ static inline bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 	return false;
 }
 
+static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
+{
+	return false;
+}
+
 static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
 	return NULL;
@@ -200,6 +216,11 @@ static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
 	return 0;
 }
 
+static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
+{
+	return false;
+}
+
 static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 {
 	return NULL;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..b68a380f50b3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -37,6 +37,12 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 		READ_ONCE(xs->umem->fq);
 }
 
+bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
+{
+	return xskq_has_addrs(umem->fq, cnt);
+}
+EXPORT_SYMBOL(xsk_umem_has_addrs);
+
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
 	return xskq_peek_addr(umem->fq, addr);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 88b9ae24658d..12b49784a6d5 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -117,6 +117,20 @@ static inline u32 xskq_nb_free(struct xsk_queue *q, u32 producer, u32 dcnt)
 	return q->nentries - (producer - q->cons_tail);
 }
 
+static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
+{
+	u32 entries = q->prod_tail - q->cons_tail;
+
+	if (entries >= cnt)
+		return true;
+
+	/* Refresh the local pointer. */
+	q->prod_tail = READ_ONCE(q->ring->producer);
+	entries = q->prod_tail - q->cons_tail;
+
+	return entries >= cnt;
+}
+
 /* UMEM queue */
 
 static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
-- 
1.8.3.1


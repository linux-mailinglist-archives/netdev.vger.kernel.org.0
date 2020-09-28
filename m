Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8BF27B08A
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgI1PKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1PKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:10:40 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFEF2076D;
        Mon, 28 Sep 2020 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601305839;
        bh=mOYrcyMurLCIEVJc/RTuSXzbsVyUV5OUX+4/vlMC+bQ=;
        h=Date:From:To:Cc:Subject:From;
        b=nXWdkPIm/dNz3CbVxabf2t4P3UguURA2s3zyCky8VJxOc8ebwe3dDFEH2Rse381E8
         sVK0jb9pO1AHue8n+hUFmgz9U40GUEpqMW3CB65eOURUNR17T6XX5A48U+gnjxmum9
         iGk0ER07V8qAD2px31oBJHIvHyWeIYZNuOdhzp6g=
Date:   Mon, 28 Sep 2020 10:16:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] qed/qed_ll2: Replace one-element array with
 flexible-array member
Message-ID: <20200928151617.GA16912@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct qed_ll2_tx_packet, instead of a one-element array and use the
struct_size() helper to calculate the size for the allocations. Commit
f5823fe6897c ("qed: Add ll2 option to limit the number of bds per packet")
was used as a reference point for these changes.

Also, it's important to notice that flexible-array members should occur
last in any structure, and structures containing such arrays and that
are members of other structures, must also occur last in the containing
structure. That's why _cur_completing_packet_ is now moved to the bottom
in struct qed_ll2_tx_queue. _descq_mem_ and _cur_send_packet_ are also
moved for unification.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays

Tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/5f707198.PA1UCZ8MYozYZYAR%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 18 ++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_ll2.h |  8 ++++----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 0452b728c527..49783f365079 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1185,7 +1185,7 @@ static int qed_ll2_acquire_connection_tx(struct qed_hwfn *p_hwfn,
 		.elem_size	= sizeof(struct core_tx_bd),
 	};
 	struct qed_ll2_tx_packet *p_descq;
-	u32 desc_size;
+	size_t desc_size;
 	u32 capacity;
 	int rc = 0;
 
@@ -1198,10 +1198,9 @@ static int qed_ll2_acquire_connection_tx(struct qed_hwfn *p_hwfn,
 		goto out;
 
 	capacity = qed_chain_get_capacity(&p_ll2_info->tx_queue.txq_chain);
-	/* First element is part of the packet, rest are flexibly added */
-	desc_size = (sizeof(*p_descq) +
-		     (p_ll2_info->input.tx_max_bds_per_packet - 1) *
-		     sizeof(p_descq->bds_set));
+	/* All bds_set elements are flexibily added. */
+	desc_size = struct_size(p_descq, bds_set,
+				p_ll2_info->input.tx_max_bds_per_packet);
 
 	p_descq = kcalloc(capacity, desc_size, GFP_KERNEL);
 	if (!p_descq) {
@@ -1524,7 +1523,7 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	struct qed_ptt *p_ptt;
 	int rc = -EINVAL;
 	u32 i, capacity;
-	u32 desc_size;
+	size_t desc_size;
 	u8 qid;
 
 	p_ptt = qed_ptt_acquire(p_hwfn);
@@ -1558,10 +1557,9 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	INIT_LIST_HEAD(&p_tx->sending_descq);
 	spin_lock_init(&p_tx->lock);
 	capacity = qed_chain_get_capacity(&p_tx->txq_chain);
-	/* First element is part of the packet, rest are flexibly added */
-	desc_size = (sizeof(*p_pkt) +
-		     (p_ll2_conn->input.tx_max_bds_per_packet - 1) *
-		     sizeof(p_pkt->bds_set));
+	/* All bds_set elements are flexibily added. */
+	desc_size = struct_size(p_pkt, bds_set,
+				p_ll2_conn->input.tx_max_bds_per_packet);
 
 	for (i = 0; i < capacity; i++) {
 		p_pkt = p_tx->descq_mem + desc_size * i;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.h b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
index 500d0c4f8077..df88d00053a2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
@@ -56,7 +56,7 @@ struct qed_ll2_tx_packet {
 		struct core_tx_bd *txq_bd;
 		dma_addr_t tx_frag;
 		u16 frag_len;
-	} bds_set[1];
+	} bds_set[];
 };
 
 struct qed_ll2_rx_queue {
@@ -86,9 +86,6 @@ struct qed_ll2_tx_queue {
 	struct list_head active_descq;
 	struct list_head free_descq;
 	struct list_head sending_descq;
-	void *descq_mem; /* memory for variable sized qed_ll2_tx_packet*/
-	struct qed_ll2_tx_packet *cur_send_packet;
-	struct qed_ll2_tx_packet cur_completing_packet;
 	u16 cur_completing_bd_idx;
 	void __iomem *doorbell_addr;
 	struct core_db_data db_msg;
@@ -96,6 +93,9 @@ struct qed_ll2_tx_queue {
 	u16 cur_send_frag_num;
 	u16 cur_completing_frag_num;
 	bool b_completing_packet;
+	void *descq_mem; /* memory for variable sized qed_ll2_tx_packet*/
+	struct qed_ll2_tx_packet *cur_send_packet;
+	struct qed_ll2_tx_packet cur_completing_packet;
 };
 
 struct qed_ll2_info {
-- 
2.27.0


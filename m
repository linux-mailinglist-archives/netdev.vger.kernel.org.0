Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04D2542193
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiFHGBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiFHFtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:49:06 -0400
Received: from EX-PRD-EDGE01.vmware.com (ex-prd-edge01.vmware.com [208.91.3.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2922C49F;
        Tue,  7 Jun 2022 20:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=NNMVPO7g7f6Jkv3OjF+afguZ7MsAQZAz3wtqXiB2wJg=;
    b=U+xhvdnF9QD699yCp6bcLULezh9RzuC+XZNjC4FBABRTuKq8nk9fNtEMYHpx+S
      4YBcZXfGOcE65mGUHPtIM+qLB65q+X8SPcvf3ZWbbindsi8jlYdj5JDaRl4yVr
      rdgRyya2mEYqUOtkOhLSbnkKR0qqlTsaWzRUuRsUX5TvTMI=
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX-PRD-EDGE01.vmware.com (10.188.245.6) with Microsoft SMTP Server id
 15.1.2308.20; Tue, 7 Jun 2022 20:23:50 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 5386120298;
        Tue,  7 Jun 2022 20:24:05 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 4DA58AA454; Tue,  7 Jun 2022 20:24:05 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 4/8] vmxnet3: add support for out of order rx completion
Date:   Tue, 7 Jun 2022 20:23:49 -0700
Message-ID: <20220608032353.964-5-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220608032353.964-1-doshir@vmware.com>
References: <20220608032353.964-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE01.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, vmxnet3 processes rx completions in-order i.e. no
out of order completion descriptor is expected. With UPT, if
hardware supports LRO, then hardware can report out of order
rx completions. This patch enhances vmxnet3 to add this support.
This supports gets effective only when the corresponding feature
bit is set.

Also, minor enhancements are done for performance.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 70 ++++++++++++++++++++++++++++++++-------
 drivers/net/vmxnet3/vmxnet3_int.h |  5 +++
 2 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 93f237db463d..94ca3bc1d540 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -585,6 +585,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 
 		rbi = rbi_base + ring->next2fill;
 		gd = ring->base + ring->next2fill;
+		rbi->comp_state = VMXNET3_RXD_COMP_PENDING;
 
 		if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
 			if (rbi->skb == NULL) {
@@ -644,8 +645,10 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 
 		/* Fill the last buffer but dont mark it ready, or else the
 		 * device will think that the queue is full */
-		if (num_allocated == num_to_alloc)
+		if (num_allocated == num_to_alloc) {
+			rbi->comp_state = VMXNET3_RXD_COMP_DONE;
 			break;
+		}
 
 		gd->dword[2] |= cpu_to_le32(ring->gen << VMXNET3_RXD_GEN_SHIFT);
 		num_allocated++;
@@ -1367,6 +1370,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
 	u16 segCnt = 0, mss = 0;
+	int comp_offset, fill_offset;
 #ifdef __BIG_ENDIAN_BITFIELD
 	struct Vmxnet3_RxDesc rxCmdDesc;
 	struct Vmxnet3_RxCompDesc rxComp;
@@ -1639,9 +1643,15 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 
 rcd_done:
 		/* device may have skipped some rx descs */
-		ring->next2comp = idx;
-		num_to_alloc = vmxnet3_cmd_ring_desc_avail(ring);
 		ring = rq->rx_ring + ring_idx;
+		rbi->comp_state = VMXNET3_RXD_COMP_DONE;
+
+		comp_offset = vmxnet3_cmd_ring_desc_avail(ring);
+		fill_offset = (idx > ring->next2fill ? 0 : ring->size) +
+			      idx - ring->next2fill - 1;
+		if (!ring->isOutOfOrder || fill_offset >= comp_offset)
+			ring->next2comp = idx;
+		num_to_alloc = vmxnet3_cmd_ring_desc_avail(ring);
 
 		/* Ensure that the writes to rxd->gen bits will be observed
 		 * after all other writes to rxd objects.
@@ -1649,18 +1659,38 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		dma_wmb();
 
 		while (num_to_alloc) {
-			vmxnet3_getRxDesc(rxd, &ring->base[ring->next2fill].rxd,
-					  &rxCmdDesc);
-			BUG_ON(!rxd->addr);
-
-			/* Recv desc is ready to be used by the device */
-			rxd->gen = ring->gen;
-			vmxnet3_cmd_ring_adv_next2fill(ring);
-			num_to_alloc--;
+			rbi = rq->buf_info[ring_idx] + ring->next2fill;
+			if (!(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_OOORX_COMP)))
+				goto refill_buf;
+			if (ring_idx == 0) {
+				/* ring0 Type1 buffers can get skipped; re-fill them */
+				if (rbi->buf_type != VMXNET3_RX_BUF_SKB)
+					goto refill_buf;
+			}
+			if (rbi->comp_state == VMXNET3_RXD_COMP_DONE) {
+refill_buf:
+				vmxnet3_getRxDesc(rxd, &ring->base[ring->next2fill].rxd,
+						  &rxCmdDesc);
+				WARN_ON(!rxd->addr);
+
+				/* Recv desc is ready to be used by the device */
+				rxd->gen = ring->gen;
+				vmxnet3_cmd_ring_adv_next2fill(ring);
+				rbi->comp_state = VMXNET3_RXD_COMP_PENDING;
+				num_to_alloc--;
+			} else {
+				/* rx completion hasn't occurred */
+				ring->isOutOfOrder = 1;
+				break;
+			}
+		}
+
+		if (num_to_alloc == 0) {
+			ring->isOutOfOrder = 0;
 		}
 
 		/* if needed, update the register */
-		if (unlikely(rq->shared->updateRxProd)) {
+		if (unlikely(rq->shared->updateRxProd) && (ring->next2fill & 0xf) == 0) {
 			VMXNET3_WRITE_BAR0_REG(adapter,
 					       rxprod_reg[ring_idx] + rq->qid * 8,
 					       ring->next2fill);
@@ -1824,6 +1854,7 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 		memset(rq->rx_ring[i].base, 0, rq->rx_ring[i].size *
 		       sizeof(struct Vmxnet3_RxDesc));
 		rq->rx_ring[i].gen = VMXNET3_INIT_GEN;
+		rq->rx_ring[i].isOutOfOrder = 0;
 	}
 	if (vmxnet3_rq_alloc_rx_buf(rq, 0, rq->rx_ring[0].size - 1,
 				    adapter) == 0) {
@@ -2014,8 +2045,17 @@ vmxnet3_poll_rx_only(struct napi_struct *napi, int budget)
 	rxd_done = vmxnet3_rq_rx_complete(rq, adapter, budget);
 
 	if (rxd_done < budget) {
+		struct Vmxnet3_RxCompDesc *rcd;
+#ifdef __BIG_ENDIAN_BITFIELD
+		struct Vmxnet3_RxCompDesc rxComp;
+#endif
 		napi_complete_done(napi, rxd_done);
 		vmxnet3_enable_intr(adapter, rq->comp_ring.intr_idx);
+		/* after unmasking the interrupt, check if any descriptors were completed */
+		vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
+				  &rxComp);
+		if (rcd->gen == rq->comp_ring.gen && napi_reschedule(napi))
+			vmxnet3_disable_intr(adapter, rq->comp_ring.intr_idx);
 	}
 	return rxd_done;
 }
@@ -3612,6 +3652,12 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 			adapter->dev_caps[0] = adapter->devcap_supported[0] &
 							(1UL << VMXNET3_CAP_LARGE_BAR);
 		}
+		if (!(adapter->ptcap_supported[0] & (1UL << VMXNET3_DCR_ERROR)) &&
+		    adapter->ptcap_supported[0] & (1UL << VMXNET3_CAP_OOORX_COMP) &&
+		    adapter->devcap_supported[0] & (1UL << VMXNET3_CAP_OOORX_COMP)) {
+			adapter->dev_caps[0] |= adapter->devcap_supported[0] &
+						(1UL << VMXNET3_CAP_OOORX_COMP);
+		}
 		if (adapter->dev_caps[0])
 			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a4f832f0ad5b..5b495ef253e8 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -136,6 +136,7 @@ struct vmxnet3_cmd_ring {
 	u32		next2fill;
 	u32		next2comp;
 	u8		gen;
+	u8              isOutOfOrder;
 	dma_addr_t	basePA;
 };
 
@@ -260,9 +261,13 @@ enum vmxnet3_rx_buf_type {
 	VMXNET3_RX_BUF_PAGE = 2
 };
 
+#define VMXNET3_RXD_COMP_PENDING        0
+#define VMXNET3_RXD_COMP_DONE           1
+
 struct vmxnet3_rx_buf_info {
 	enum vmxnet3_rx_buf_type buf_type;
 	u16     len;
+	u8      comp_state;
 	union {
 		struct sk_buff *skb;
 		struct page    *page;
-- 
2.11.0


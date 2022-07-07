Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A6A56A3BB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiGGNdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiGGNdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:33:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F3B2DFE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:33:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d10so5619192pfd.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 06:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXBq+4Rx1hm4hjTotuvHZNVq1mHJ+nl/3QChn89gTZk=;
        b=awLy9DpQu8M7TzibbZhyR52rLu3PpnTQ4YrCCiLAEyl5bNYMXxBXgb2FBCQVAWg4Wq
         W5Oz9lgTWdCuyXEVECvR6WfXx1soF8d+uSXzWxMFAese9q24HpD6QBXtgMWN02CBTMV/
         pIlAcQsxtprjh9SI3ZWOr7zvdRuKplmonp4wXA6ofbDtI/vgHGhrnVoSW2rTDalo+9ww
         CyLx4PFAcK2Mas7FzPz8afmkfh0n74i9JgR494IxlkekFOx4kLrB3EgS7rpftz8HY7E2
         ucEn01zHqlVX7kG1RN/aH0qpPvIj2Jt2x+YkJ5DkvZT45UY/QwSUta7cBYo6Im1H7KX3
         Ppzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXBq+4Rx1hm4hjTotuvHZNVq1mHJ+nl/3QChn89gTZk=;
        b=IN4CTeT71enwgrzz0sR+fzdKYZ4wyAkHMrTI7ELnocWCkav1lSe04yIIe59yGi2CBd
         IabkctL9d8nMY4nqjCWyZ/fdX9gXm6uzyN4uK2PUR5iP7AKmrG2qzgM4PbWMw5P1LSYC
         BlGxn7OQtGaj8L1ZYpMrC+zv/RtIHWXJIE0cwBabZeCPL8UmyMr1JYieqa8m6MCdx3er
         7SN+PiW61EccRUmGTshG/FQuKYkh5KQftE/X4fbqxDVSknmgfFLxus65TQb9E6aQk6A3
         B7unpKvD8J8U0nYgXJhweXbdtuV9Q7OMkZ3iow0yWSXfHO8wTDeshfvQj+0B204zTmNJ
         JyRw==
X-Gm-Message-State: AJIora8Zf//6SsKJKnAxoaR1xFfhDzjgBAZIBX2S3/bKyYar3ISGgjqN
        qvhfCIwDAo/HyNMPOFeDE3WBa8dHtgg=
X-Google-Smtp-Source: AGRyM1sf9DuKePFkPVimo0NlGb3KAtGhnem0vK0YC8o+1H9TRiFogtVTretcvTgEKxQMUS6QMhpajg==
X-Received: by 2002:a17:902:c405:b0:16c:3c8:d6e9 with SMTP id k5-20020a170902c40500b0016c03c8d6e9mr8461155plk.152.1657200820027;
        Thu, 07 Jul 2022 06:33:40 -0700 (PDT)
Received: from tuc-a02.vmware.com.com (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b0016bfb09be10sm4744874pla.305.2022.07.07.06.33.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jul 2022 06:33:39 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     doshir@vmware.com, jbrouer@redhat.com, lorenzo.bianconi@redhat.com,
        gyang@vmware.com, tuc@vmware.com
Subject: [RFC PATCH v2] vmxnet3: Add XDP support.
Date:   Thu,  7 Jul 2022 06:33:35 -0700
Message-Id: <20220707133335.68987-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220629014927.2123-1-u9012063@gmail.com>
References: <20220629014927.2123-1-u9012063@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
The vmxnet3 rx consists of three rings: r0, r1, and dataring.
Buffers at r0 are allocated using alloc_skb APIs and dma mapped to the
ring's descriptor. If LRO is enabled and packet size is larger than
3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
allocated using alloc_page. So for LRO packets, the payload will be
in one buffer from r0 and multiple from r1, for non-LRO packets,
only one descriptor in r0 is used for packet size less than 3k.

The first descriptor will have the sop (start of packet) bit set,
and the last descriptor will have the eop (end of packet) bit set.
Non-LRO packets will have only one descriptor with both sop and eop set.

The vmxnet3 dataring is optimized for handling small packet size, usually
128 bytes, defined in VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the
packet to avoid memory mapping/unmapping overhead. In summary, packet
size:
    A. < 128B: use dataring
    B. 128B - 3K: use ring0
    C. > 3K: use ring0 and ring1
As a result, the patch adds XDP support for packets using dataring
and r0 (case A and B), not the large packet size when LRO is enabled.

For TX, vmxnet3 has split header design. Outgoing packets are parsed
first and protocol headers (L2/L3/L4) are copied to the backend. The
rest of the payload are dma mapped. Since XDP_TX does not parse the
packet protocol, the entire XDP frame is using dma mapped for the
transmission.

Tested using two VMs inside one ESXi machine, using single core on each
vmxnet3 device, sender using DPDK testpmd tx-mode attached to vmxnet3
device, sending 64B or 512B packet.

VM1 txgen:
$ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
--forward-mode=txonly --eth-peer=0,<mac addr of vm2>
option: add "--txonly-multi-flow"
option: use --txpkts=512 or 64 byte

VM2 running XDP:
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
options: XDP_DROP, XDP_PASS, XDP_TX

To test REDIRECT to cpu 0, use
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop

Single core performance comparison with skb-mode.
64B:      skb-mode -> native-mode (with this patch)
XDP_DROP: 960Kpps -> 2.4Mpps
XDP_PASS: 240Kpps -> 499Kpps
XDP_TX:   683Kpps -> 2.3Mpps
REDIRECT: 389Kpps -> 449Kpps

Improvement over v1:
Skip the skb allocation when using dataring (small packet size).
Doing redirect at dataring has higher overhead, due to dataring
packet shares page with other packet, so I have to do extra
page allocation and copying.

512B:      skb-mode -> native-mode (with this patch)
XDP_DROP: 640Kpps -> 914Kpps
XDP_PASS: 220Kpps -> 240Kpps
XDP_TX:   483Kpps -> 886Kpps
REDIRECT: 365Mpps -> 1.2Mpps

For DROP, PASS, and TX, same performance as v1.
Doing redirect shows better performance because normal packet
size doesn't need to allocate new page.

Limitations:
a. LRO will be disabled when users load XDP program
b. MTU will be checked and limit to
   VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
   SKB_DATA_ALIGN(sizeof(struct skb_shared_info))

Signed-off-by: William Tu <tuc@vmware.com>
---
v1 -> v2:
- Avoid skb allocation for small packet size (when dataring is used)
- Use rcu_read_lock unlock instead of READ_ONCE
- Peroformance improvement over v1
- Merge xdp drop, tx, pass, and redirect into 1 patch
---
 drivers/net/vmxnet3/vmxnet3_drv.c     | 562 +++++++++++++++++++++++++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
 drivers/net/vmxnet3/vmxnet3_int.h     |  19 +
 3 files changed, 574 insertions(+), 21 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 1565e1808a19..99936e4112b8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -26,6 +26,10 @@
 
 #include <linux/module.h>
 #include <net/ip6_checksum.h>
+#include <linux/filter.h>
+#include <linux/bpf_trace.h>
+#include <linux/netlink.h>
+#include <net/xdp.h>
 
 #include "vmxnet3_int.h"
 
@@ -47,6 +51,13 @@ static int enable_mq = 1;
 
 static void
 vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, const u8 *mac);
+static int
+vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
+static int
+vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
+		       struct xdp_frame *xdpf,
+		       struct sk_buff *skb,
+		       struct vmxnet3_tx_queue *tq);
 
 /*
  *    Enable/Disable the given intr
@@ -351,7 +362,6 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
 	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
 
 	skb = tq->buf_info[eop_idx].skb;
-	BUG_ON(skb == NULL);
 	tq->buf_info[eop_idx].skb = NULL;
 
 	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
@@ -592,6 +602,9 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
 								       rbi->len,
 								       GFP_KERNEL);
+				if (adapter->xdp_enabled)
+					skb_reserve(rbi->skb, XDP_PACKET_HEADROOM);
+
 				if (unlikely(rbi->skb == NULL)) {
 					rq->stats.rx_buf_alloc_failure++;
 					break;
@@ -1387,6 +1400,314 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 	return (hlen + (hdr.tcp->doff << 2));
 }
 
+static int
+vmxnet3_xdp_xmit(struct net_device *dev,
+		 int n, struct xdp_frame **frames, u32 flags)
+{
+	struct vmxnet3_adapter *adapter;
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int i, err, cpu;
+	int tq_number;
+	int nxmit_byte = 0, nxmit = 0;
+
+	adapter = netdev_priv(dev);
+
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
+		return -ENETDOWN;
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
+		return -EINVAL;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	tq = &adapter->tx_queue[cpu % tq_number];
+	if (tq->stopped) {
+		return -ENETDOWN;
+	}
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, cpu);
+	/* Avoids TX time-out as we are sharing with slow path */
+	nq->trans_start = jiffies;
+	for (i = 0; i < n; i++) {
+		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], NULL, tq);
+		if (err) {
+			tq->stats.xdp_xmit_err++;
+			break;
+		}
+		nxmit_byte += frames[i]->len;
+		nxmit++;
+	}
+
+	tq->stats.xdp_xmit += nxmit;
+	__netif_tx_unlock(nq);
+
+	return nxmit;
+}
+
+static int
+vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
+		      struct xdp_frame *xdpf,
+		      struct sk_buff *skb)
+{
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int err = 0, cpu;
+	int tq_number;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	tq = &adapter->tx_queue[cpu % tq_number];
+	if (tq->stopped) {
+		return -ENETDOWN;
+	}
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, cpu);
+
+	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, skb, tq);
+	if (err) {
+		goto exit;
+	}
+
+exit:
+	__netif_tx_unlock(nq);
+
+	return err;
+}
+
+static int
+vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
+		       struct xdp_frame *xdpf,
+		       struct sk_buff *skb,
+		       struct vmxnet3_tx_queue *tq)
+{
+	struct vmxnet3_tx_ctx ctx;
+	struct vmxnet3_tx_buf_info *tbi = NULL;
+	union Vmxnet3_GenericDesc *gdesc;
+	int tx_num_deferred;
+	u32 buf_size;
+	u32 dw2;
+	int ret = 0;
+
+	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
+		tq->stats.tx_ring_full++;
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
+	dw2 |= xdpf->len;
+	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
+	gdesc = ctx.sop_txd;
+
+	buf_size = xdpf->len;
+	tbi = tq->buf_info + tq->tx_ring.next2fill;
+	tbi->map_type = VMXNET3_MAP_SINGLE;
+	tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
+				       xdpf->data, buf_size,
+				       DMA_TO_DEVICE);
+	if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
+		ret = -EFAULT;
+		goto exit;
+	}
+	tbi->len = buf_size;
+
+	gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
+	BUG_ON(gdesc->txd.gen == tq->tx_ring.gen);
+
+	gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
+	gdesc->dword[2] = cpu_to_le32(dw2);
+
+	/* Setup the EOP desc */
+	gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
+
+	gdesc->txd.om = 0;
+	gdesc->txd.msscof = 0;
+	gdesc->txd.hlen = 0;
+	gdesc->txd.ti = 0;
+
+	tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
+	tq->shared->txNumDeferred += 1;
+	tx_num_deferred++;
+
+	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
+
+	/* set the last buf_info for the pkt */
+	tbi->skb = skb;
+	tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
+
+	dma_wmb();
+	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
+						  VMXNET3_TXD_GEN);
+	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
+		tq->shared->txNumDeferred = 0;
+		VMXNET3_WRITE_BAR0_REG(adapter,
+			       VMXNET3_REG_TXPROD + tq->qid * 8,
+			       tq->tx_ring.next2fill);
+	}
+exit:
+	return ret;
+}
+
+static int
+vmxnet3_run_xdp_small(struct vmxnet3_rx_queue *rq, void *data, int data_len,
+		      bool *need_xdp_flush)
+{
+	struct xdp_frame *xdpf;
+	void *buf_hard_start;
+	void *orig_data;
+	struct xdp_buff xdp;
+	struct page *page;
+	int headroom = 0;
+	int err, delta;
+	u32 act;
+
+	if (!rcu_dereference(rq->xdp_bpf_prog))
+		return XDP_PASS;
+
+	buf_hard_start = data;
+	xdp_init_buff(&xdp, rq->data_ring.desc_size, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, false);
+	orig_data = xdp.data;
+
+	act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
+	rq->stats.xdp_packets++;
+
+	switch (act) {
+	case XDP_DROP:
+		rq->stats.xdp_drops++;
+		break;
+	case XDP_PASS:
+		/* There is no headroom reserved for dataring packet */
+		delta = xdp.data - orig_data;
+		WARN_ON(delta > 0);
+		break;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf, NULL)) {
+			rq->stats.xdp_drops++;
+		} else {
+			rq->stats.xdp_tx++;
+		}
+		break;
+	case XDP_ABORTED:
+		trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
+				    act);
+		rq->stats.xdp_aborted++;
+		break;
+	case XDP_REDIRECT:
+		page = alloc_page(GFP_ATOMIC);
+		if (!page) {
+			rq->stats.rx_buf_alloc_failure++;
+			return XDP_DROP;
+		}
+		xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
+		xdp_prepare_buff(&xdp, page_address(page),
+				 XDP_PACKET_HEADROOM,
+				 data_len, false);
+		memcpy(xdp.data, data, data_len);
+		err = xdp_do_redirect(rq->adapter->netdev, &xdp,
+				      rq->xdp_bpf_prog);
+		if (!err) {
+			rq->stats.xdp_redirects++;
+		} else {
+			__free_page(page);
+			rq->stats.xdp_drops++;
+		}
+		*need_xdp_flush = true;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(rq->adapter->netdev,
+					    rq->xdp_bpf_prog, act);
+		break;
+	}
+	return act;
+}
+
+static int
+vmxnet3_run_xdp_skb(struct vmxnet3_rx_queue *rq, struct sk_buff *skb,
+		    int frame_sz, bool *need_xdp_flush)
+{
+	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
+	int delta, delta_len, xdp_metasize;
+	int headroom = XDP_PACKET_HEADROOM;
+	struct xdp_frame *xdpf;
+	struct xdp_buff xdp;
+	struct page *page;
+	void *orig_data;
+	void *buf_hard_start;
+	int err;
+	u32 act;
+
+	buf_hard_start = skb->data - headroom;
+	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, buf_hard_start,
+			 headroom, skb->len, true);
+	orig_data = xdp.data;
+
+	if (!rcu_dereference(rq->xdp_bpf_prog))
+		return 0;
+
+	act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
+	rq->stats.xdp_packets++;
+
+	switch (act) {
+	case XDP_DROP:
+		if (ctx->skb)
+			dev_kfree_skb(ctx->skb);
+		ctx->skb = NULL;
+		rq->stats.xdp_drops++;
+		break;
+	case XDP_PASS:
+		delta = xdp.data - orig_data;
+		skb_reserve(skb, delta);
+		delta_len = (xdp.data_end - xdp.data) - skb->len;
+		xdp_metasize = xdp.data - xdp.data_meta;
+
+		skb_metadata_set(skb, xdp_metasize);
+		skb_put(skb, delta_len);
+		break;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf, skb)) {
+			dev_kfree_skb(ctx->skb);
+			rq->stats.xdp_drops++;
+		} else {
+			rq->stats.xdp_tx++;
+		}
+		ctx->skb = NULL;
+		break;
+	case XDP_ABORTED:
+		trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
+				    act);
+		rq->stats.xdp_aborted++;
+		ctx->skb = NULL;
+		break;
+	case XDP_REDIRECT:
+		page = virt_to_head_page(skb->data);
+		get_page(page);
+		err = xdp_do_redirect(rq->adapter->netdev, &xdp,
+				      rq->xdp_bpf_prog);
+		if (!err) {
+			rq->stats.xdp_redirects++;
+			dev_kfree_skb(ctx->skb);
+		} else {
+			__free_page(page);
+			dev_kfree_skb(ctx->skb);
+			rq->stats.xdp_drops++;
+		}
+		ctx->skb = NULL;
+		*need_xdp_flush = true;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(rq->adapter->netdev,
+					    rq->xdp_bpf_prog, act);
+		break;
+	}
+	return act;
+}
+
 static int
 vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		       struct vmxnet3_adapter *adapter, int quota)
@@ -1404,6 +1725,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxDesc rxCmdDesc;
 	struct Vmxnet3_RxCompDesc rxComp;
 #endif
+	bool need_flush = 0;
+
 	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
 			  &rxComp);
 	while (rcd->gen == rq->comp_ring.gen) {
@@ -1415,6 +1738,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		struct Vmxnet3_RxDesc *rxd;
 		u32 idx, ring_idx;
 		struct vmxnet3_cmd_ring	*ring = NULL;
+		bool rxDataRingUsed;
+
 		if (num_pkts >= quota) {
 			/* we may stop even before we see the EOP desc of
 			 * the current pkt
@@ -1445,7 +1770,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		}
 
 		if (rcd->sop) { /* first buf of the pkt */
-			bool rxDataRingUsed;
 			u16 len;
 
 			BUG_ON(rxd->btype != VMXNET3_RXD_BTYPE_HEAD ||
@@ -1470,29 +1794,58 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			rxDataRingUsed =
 				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
 			len = rxDataRingUsed ? rcd->len : rbi->len;
-			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
-							    len);
-			if (new_skb == NULL) {
-				/* Skb allocation failed, do not handover this
-				 * skb to stack. Reuse it. Drop the existing pkt
-				 */
-				rq->stats.rx_buf_alloc_failure++;
-				ctx->skb = NULL;
-				rq->stats.drop_total++;
-				skip_page_frags = true;
-				goto rcd_done;
-			}
 
 			if (rxDataRingUsed) {
 				size_t sz;
+				void *data;
+				u32 verdict;
 
 				BUG_ON(rcd->len > rq->data_ring.desc_size);
-
-				ctx->skb = new_skb;
 				sz = rcd->rxdIdx * rq->data_ring.desc_size;
-				memcpy(new_skb->data,
-				       &rq->data_ring.base[sz], rcd->len);
+				data = &rq->data_ring.base[sz];
+
+				rcu_read_lock();
+				verdict = vmxnet3_run_xdp_small(rq, data,
+								rcd->len,
+								&need_flush);
+				rcu_read_unlock();
+				if (verdict == XDP_PASS) {
+					new_skb = netdev_alloc_skb_ip_align(
+							adapter->netdev,
+							len);
+					if (new_skb == NULL) {
+						rq->stats.rx_buf_alloc_failure++;
+						ctx->skb = NULL;
+						rq->stats.drop_total++;
+						skip_page_frags = true;
+						goto rcd_done;
+					}
+					ctx->skb = new_skb;
+					memcpy(new_skb->data,
+					       &rq->data_ring.base[sz],
+					       rcd->len);
+				} else {
+					ctx->skb = NULL;
+					goto rcd_done;
+				}
 			} else {
+				new_skb = netdev_alloc_skb_ip_align(
+							adapter->netdev,
+							len);
+				if (new_skb == NULL) {
+					/* Skb allocation failed, do not handover this
+					 * skb to stack. Reuse it. Drop the existing pkt
+					 */
+					rq->stats.rx_buf_alloc_failure++;
+					ctx->skb = NULL;
+					rq->stats.drop_total++;
+					skip_page_frags = true;
+					goto rcd_done;
+				}
+
+				if (adapter->xdp_enabled)
+					skb_reserve(new_skb,
+						    XDP_PACKET_HEADROOM);
 				ctx->skb = rbi->skb;
 
 				new_dma_addr =
@@ -1620,8 +1973,34 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			}
 		}
 
-
 		skb = ctx->skb;
+
+		if (rcd->sop && rcd->eop) {
+			struct bpf_prog *xdp_prog;
+			int buflen = rbi->len;
+			int act = XDP_PASS;
+
+			rcu_read_lock();
+			xdp_prog = rcu_dereference(rq->xdp_bpf_prog);
+			if (!xdp_prog) {
+				rcu_read_unlock();
+				goto skip_xdp;
+			}
+
+			act = vmxnet3_run_xdp_skb(rq, skb, buflen,
+						  &need_flush);
+			rcu_read_unlock();
+			switch (act) {
+			case XDP_PASS:
+				goto skip_xdp;
+			case XDP_DROP:
+			case XDP_TX:
+			case XDP_REDIRECT:
+			default:
+				goto rcd_done;
+			}
+		}
+skip_xdp:
 		if (rcd->eop) {
 			u32 mtu = adapter->netdev->mtu;
 			skb->len += skb->data_len;
@@ -1729,6 +2108,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		vmxnet3_getRxComp(rcd,
 				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
 	}
+	if (need_flush)
+		xdp_do_flush_map();
 
 	return num_pkts;
 }
@@ -1775,6 +2156,7 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 
 	rq->comp_ring.gen = VMXNET3_INIT_GEN;
 	rq->comp_ring.next2proc = 0;
+	rq->xdp_bpf_prog = NULL;
 }
 
 
@@ -1787,6 +2169,32 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
 		vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
 }
 
+static void
+vmxnet3_unregister_xdp_rxq(struct vmxnet3_rx_queue *rq)
+{
+	xdp_rxq_info_unreg_mem_model(&rq->xdp_rxq);
+	xdp_rxq_info_unreg(&rq->xdp_rxq);
+}
+
+static int
+vmxnet3_register_xdp_rxq(struct vmxnet3_rx_queue *rq,
+			struct vmxnet3_adapter *adapter)
+{
+	int err;
+
+	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid, 0);
+	if (err < 0) {
+		return err;
+	}
+
+	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_SHARED,
+					 NULL);
+	if (err < 0) {
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+		return err;
+	}
+	return 0;
+}
 
 static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 			       struct vmxnet3_adapter *adapter)
@@ -1831,6 +2239,8 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 	kfree(rq->buf_info[0]);
 	rq->buf_info[0] = NULL;
 	rq->buf_info[1] = NULL;
+
+	vmxnet3_unregister_xdp_rxq(rq);
 }
 
 static void
@@ -1892,6 +2302,10 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 	}
 	vmxnet3_rq_alloc_rx_buf(rq, 1, rq->rx_ring[1].size - 1, adapter);
 
+	/* always register, even if no XDP prog used */
+	if (vmxnet3_register_xdp_rxq(rq, adapter))
+		return -EINVAL;
+
 	/* reset the comp ring */
 	rq->comp_ring.next2proc = 0;
 	memset(rq->comp_ring.base, 0, rq->comp_ring.size *
@@ -2593,7 +3007,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	if (adapter->netdev->features & NETIF_F_RXCSUM)
 		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
 
-	if (adapter->netdev->features & NETIF_F_LRO) {
+	if (adapter->netdev->features & NETIF_F_LRO &&
+		!adapter->xdp_enabled) {
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
@@ -3033,6 +3448,14 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
 	pci_disable_device(adapter->pdev);
 }
 
+static int
+vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
+{
+	if (adapter->xdp_enabled)
+		return VMXNET3_XDP_ROOM;
+	else
+		return 0;
+}
 
 static void
 vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
@@ -3043,7 +3466,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 		if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
 					    VMXNET3_MAX_ETH_HDR_SIZE) {
 			adapter->skb_buf_size = adapter->netdev->mtu +
-						VMXNET3_MAX_ETH_HDR_SIZE;
+						VMXNET3_MAX_ETH_HDR_SIZE +
+						vmxnet3_xdp_headroom(adapter);
 			if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
 				adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
 
@@ -3564,6 +3988,99 @@ vmxnet3_reset_work(struct work_struct *data)
 	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
 }
 
+static void
+vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
+			     struct bpf_prog *prog)
+{
+	struct vmxnet3_rx_queue *rq;
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		rq = &adapter->rx_queue[i];
+		rcu_assign_pointer(rq->xdp_bpf_prog, prog);
+	}
+	if (prog)
+		adapter->xdp_enabled = true;
+	else
+		adapter->xdp_enabled = false;
+}
+
+static int
+vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
+		struct netlink_ext_ack *extack)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *new_bpf_prog = bpf->prog;
+	struct bpf_prog *old_bpf_prog;
+	bool use_dataring;
+	bool need_update;
+	bool running;
+	int err = 0;
+
+	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	use_dataring = VMXNET3_RX_DATA_RING(adapter, 0);
+	if (new_bpf_prog && use_dataring) {
+		NL_SET_ERR_MSG_MOD(extack, "RX data ring not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	old_bpf_prog = READ_ONCE(adapter->rx_queue[0].xdp_bpf_prog);
+	if (!new_bpf_prog && !old_bpf_prog) {
+		adapter->xdp_enabled = false;
+		return 0;
+	}
+	running = netif_running(netdev);
+	need_update = !!old_bpf_prog != !!new_bpf_prog;
+
+	if (running && need_update) {
+		vmxnet3_quiesce_dev(adapter);
+	}
+
+	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
+	if (old_bpf_prog) {
+		bpf_prog_put(old_bpf_prog);
+	}
+
+	if (running && need_update) {
+		vmxnet3_reset_dev(adapter);
+		vmxnet3_rq_destroy_all(adapter);
+		vmxnet3_adjust_rx_ring_size(adapter);
+		err = vmxnet3_rq_create_all(adapter);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+				   "failed to re-create rx queues for XDP.");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+		err = vmxnet3_activate_dev(adapter);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+				   "failed to activate device for XDP.");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+		clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
+	}
+out:
+	return err;
+}
+
+/* This is the main xdp call used by kernel to set/unset eBPF program. */
+static int
+vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
 
 static int
 vmxnet3_probe_device(struct pci_dev *pdev,
@@ -3586,6 +4103,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 		.ndo_poll_controller = vmxnet3_netpoll,
 #endif
+		.ndo_bpf = vmxnet3_xdp,
+		.ndo_xdp_xmit = vmxnet3_xdp_xmit,
 	};
 	int err;
 	u32 ver;
@@ -3901,6 +4420,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		goto err_register;
 	}
 
+	adapter->xdp_enabled = false;
 	vmxnet3_check_link(adapter, false);
 	return 0;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index ce3993282c0f..b93dab2056e2 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -76,6 +76,10 @@ vmxnet3_tq_driver_stats[] = {
 					 copy_skb_header) },
 	{ "  giant hdr",	offsetof(struct vmxnet3_tq_driver_stats,
 					 oversized_hdr) },
+	{ "  xdp xmit",		offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit) },
+	{ "  xdp xmit err",	offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit_err) },
 };
 
 /* per rq stats maintained by the device */
@@ -106,6 +110,16 @@ vmxnet3_rq_driver_stats[] = {
 					 drop_fcs) },
 	{ "  rx buf alloc fail", offsetof(struct vmxnet3_rq_driver_stats,
 					  rx_buf_alloc_failure) },
+	{ "     xdp packets", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_packets) },
+	{ "     xdp tx", offsetof(struct vmxnet3_rq_driver_stats,
+				  xdp_tx) },
+	{ "     xdp redirects", offsetof(struct vmxnet3_rq_driver_stats,
+					 xdp_redirects) },
+	{ "     xdp drops", offsetof(struct vmxnet3_rq_driver_stats,
+				     xdp_drops) },
+	{ "     xdp aborted", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_aborted) },
 };
 
 /* global stats maintained by the driver */
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3367db23aa13..24ac14c1abc9 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -56,6 +56,8 @@
 #include <linux/if_arp.h>
 #include <linux/inetdevice.h>
 #include <linux/log2.h>
+#include <linux/bpf.h>
+#include <linux/skbuff.h>
 
 #include "vmxnet3_defs.h"
 
@@ -217,6 +219,9 @@ struct vmxnet3_tq_driver_stats {
 	u64 linearized;         /* # of pkts linearized */
 	u64 copy_skb_header;    /* # of times we have to copy skb header */
 	u64 oversized_hdr;
+
+	u64 xdp_xmit;
+	u64 xdp_xmit_err;
 };
 
 struct vmxnet3_tx_ctx {
@@ -285,6 +290,12 @@ struct vmxnet3_rq_driver_stats {
 	u64 drop_err;
 	u64 drop_fcs;
 	u64 rx_buf_alloc_failure;
+
+	u64 xdp_packets;	/* Total packets processed by XDP. */
+	u64 xdp_tx;
+	u64 xdp_redirects;
+	u64 xdp_drops;
+	u64 xdp_aborted;
 };
 
 struct vmxnet3_rx_data_ring {
@@ -307,6 +318,8 @@ struct vmxnet3_rx_queue {
 	struct vmxnet3_rx_buf_info     *buf_info[2];
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
+	struct bpf_prog __rcu *xdp_bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
@@ -415,6 +428,7 @@ struct vmxnet3_adapter {
 	u16    tx_prod_offset;
 	u16    rx_prod_offset;
 	u16    rx_prod2_offset;
+	bool   xdp_enabled;
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
@@ -457,6 +471,11 @@ struct vmxnet3_adapter {
 #define VMXNET3_MAX_ETH_HDR_SIZE    22
 #define VMXNET3_MAX_SKB_BUF_SIZE    (3*1024)
 
+#define VMXNET3_XDP_ROOM SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
+		         XDP_PACKET_HEADROOM
+#define VMXNET3_XDP_MAX_MTU VMXNET3_MAX_SKB_BUF_SIZE - VMXNET3_XDP_ROOM
+
+
 #define VMXNET3_GET_RING_IDX(adapter, rqID)		\
 	((rqID >= adapter->num_rx_queues &&		\
 	 rqID < 2 * adapter->num_rx_queues) ? 1 : 0)	\
-- 
2.30.1 (Apple Git-130)


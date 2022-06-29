Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ABB55F2F5
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 03:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiF2Btk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 21:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2Btg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 21:49:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1769525C4B
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 18:49:35 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q18so12647017pld.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 18:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1PSdXPukbi6aFwDhJ4/qZvYPLDW/1WLX/nPn4Q1wuec=;
        b=TF9kohNo/tsvxWQFyJTbovJKgeJVWYp+O8xTrfrm0qoWNLImsGgKwGP21aFdDQhgN7
         OxfZqd7tA/D2fK9huyiLsPBqHplBOaG9lOx3gJgcq8VmgkyEBfiI9rNB2PMv46Un2Uhg
         vuUba8snzH3pCVYZ7XJ1+kY9ynGWImXd/m2SLTmmz1Re9dLGLcWq8SaO43BXzcQQK3kK
         XhTWXWhpiSNIZ+fPHojhXXkViVVgMu9ielfzilynjTS6hurutJ4XFgZcUnHIRJqINBOR
         PtbRmS91gLkJNH3ipL2CwV2iLOmUkCeXKNuzdwrL6hTPq7Z1drgZ3nw+QSpqioaKc2YL
         Xtdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1PSdXPukbi6aFwDhJ4/qZvYPLDW/1WLX/nPn4Q1wuec=;
        b=UQJW81vc+uheLsT+ITDS8Zj77eYrQ+Pxet8nBrVIcKUkvT6Zgt/EPqRIv0aSPAXCx8
         aWzeaVpNhuwZcMSCWuYicS74+jPjfWhcLOJrgkpmDUKWitBB3aXdYvcK3+FaQiPZUkxl
         14xxg3pxGrsEVlQdr0NizN86XEdAO2bwbr+aFZLsu4xTS504kctNFXmeb3i2Z/W8m5uU
         p3qV2O3MNKCRzO1yFPVslfZOp8UUxyGJpyM/A05Db5ZBWgUWGzf5gjLCh4mNDidDwuyg
         3dO8eQD6U7ffFh0tWw0Tvk3Uu7DM0MyZuA+bvxQfZ2SyKV/1VZZf2vMLiG0u/R6hbSiM
         xx0A==
X-Gm-Message-State: AJIora97c5zs5xO2n2hPi8xvTrvrok60ILP8SeARZpfliUp4TMUmW+ks
        jSoF4RDldwabLYywJkczhVGhssRlnFA=
X-Google-Smtp-Source: AGRyM1tNa5W5OSWU6N2MV816hE0am1MEhTorg2RuakKob3kJ8cVMGYsOYJ/N5rs6U1Xx0Ptx3LzXkA==
X-Received: by 2002:a17:902:c943:b0:16a:3ab8:3678 with SMTP id i3-20020a170902c94300b0016a3ab83678mr7818089pla.56.1656467373908;
        Tue, 28 Jun 2022 18:49:33 -0700 (PDT)
Received: from tuc-a02.vmware.com.com (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id c16-20020a056a00009000b0051c1b445094sm10221273pfj.7.2022.06.28.18.49.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 18:49:33 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     doshir@vmware.com, jbrouer@redhat.com, lorenzo.bianconi@redhat.com,
        gyang@vmware.com, William Tu <tuc@vmware.com>
Subject: [RFC PATCH 1/2] vmxnet3: Add basic XDP support.
Date:   Tue, 28 Jun 2022 18:49:26 -0700
Message-Id: <20220629014927.2123-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

The patch adds native-mode XDP support: XDP_DROP, XDP_PASS, and XDP_TX.
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
    < 128B: dataring
    128B - 3K: ring0
    > 3K: ring0 and ring1
As a result, the patch adds XDP support for packets using dataring
and r0, not the large packet size when LRO is enabled.

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
optional: add "--txonly-multi-flow"

VM2 running XDP:
$ ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP --skb-mode
$ ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP
options: XDP_DROP, XDP_PASS, XDP_TX

Performance comparison with skb-mode.
64B:      skb-mode -> native-mode (with this patch)
XDP_DROP: 960Kpps -> 1.4Mpps
XDP_PASS: 220Kpps -> 240Kpps
XDP_TX:   683Kpps -> 1.25Mpps

512B:      skb-mode -> native-mode (with this patch)
XDP_DROP: 640Kpps -> 914Kpps
XDP_PASS: 220Kpps -> 240Kpps
XDP_TX:   483Kpps -> 886Kpps

Limitations:
a. LRO will be disabled when users load XDP program
b. MTU will be checked and limit to
   VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
   SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
c. XDP_REDIRECT not supported yet.

Need Feebacks:
d. user needs to disable TSO using ethtool
e. I should be able to move the run_xdp before the
   netdev_alloc_skb_ip_align() in vmxnet3_rq_rx_complete
   so avoiding the skb allocation overhead.
f. I looked at "Add XDP support on a NIC driver" from Lorenzo,
   https://legacy.netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf
   and I'm not sure whether I should use page_pool allocator
g. Some drivers are using rcu (virtio_net.c) to access xdp prog
	rcu_read_lock();
	xdp_prog = rcu_dereference(rq->xdp_prog);
   Some are using READ_ONCE. Not sure which one I should use.

Signed-off-by: William Tu <tuc@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c     | 360 +++++++++++++++++++++++++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  10 +
 drivers/net/vmxnet3/vmxnet3_int.h     |  16 ++
 3 files changed, 382 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 1565e1808a19..549e31a1d485 100644
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
 
@@ -47,6 +51,8 @@ static int enable_mq = 1;
 
 static void
 vmxnet3_write_mac_addr(struct vmxnet3_adapter *adapter, const u8 *mac);
+static int
+vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
 
 /*
  *    Enable/Disable the given intr
@@ -592,6 +598,9 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
 								       rbi->len,
 								       GFP_KERNEL);
+				if (adapter->xdp_enabled)
+					skb_reserve(rbi->skb, XDP_PACKET_HEADROOM);
+
 				if (unlikely(rbi->skb == NULL)) {
 					rq->stats.rx_buf_alloc_failure++;
 					break;
@@ -1387,6 +1396,182 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 	return (hlen + (hdr.tcp->doff << 2));
 }
 
+static int
+vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
+		       struct xdp_frame *xdpf,
+		       struct sk_buff *skb,
+		       struct vmxnet3_tx_queue *tq);
+
+static int
+vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
+		      struct xdp_frame *xdpf,
+		      struct sk_buff *skb)
+{
+        struct vmxnet3_tx_queue *tq;
+        struct netdev_queue *nq;
+	int err = 0, cpu;
+	int tq_number;
+
+	tq_number = adapter->num_tx_queues;
+        cpu = smp_processor_id();
+	tq = &adapter->tx_queue[cpu % tq_number];
+        nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+        __netif_tx_lock(nq, cpu);
+
+	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, skb, tq);
+	if (err) {
+		goto exit;
+	}
+
+exit:
+        __netif_tx_unlock(nq);
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
+        int ret = 0;
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
+        gdesc->txd.msscof = 0;
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
+vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct sk_buff *skb,
+		int frame_sz, bool *need_xdp_flush)
+{
+	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
+	int delta, delta_len, xdp_metasize;
+	int headroom = XDP_PACKET_HEADROOM;
+	struct xdp_frame *xdpf;
+	struct xdp_buff xdp;
+	void *orig_data;
+	void *buf_hard_start;
+	u32 act;
+
+	buf_hard_start = skb->data - headroom;
+	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, buf_hard_start,
+			 headroom, skb->len, true);
+	orig_data = xdp.data;
+
+	if (!READ_ONCE(rq->xdp_bpf_prog))
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
+		/* Recalculate length in case bpf program changed it. */
+		delta = xdp.data - orig_data;
+		skb_reserve(skb, delta);
+	        delta_len = (xdp.data_end - xdp.data) - skb->len;
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
+		ctx->skb = NULL;
+		trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog, act);
+		rq->stats.xdp_aborted++;
+		break;
+	case XDP_REDIRECT: /* Not Supported. */
+		ctx->skb = NULL;
+		fallthrough;
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
@@ -1404,6 +1589,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxDesc rxCmdDesc;
 	struct Vmxnet3_RxCompDesc rxComp;
 #endif
+	bool need_xdp_flush = 0;
+
 	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
 			  &rxComp);
 	while (rcd->gen == rq->comp_ring.gen) {
@@ -1469,7 +1656,9 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 
 			rxDataRingUsed =
 				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
-			len = rxDataRingUsed ? rcd->len : rbi->len;
+			len = rxDataRingUsed ?
+				rcd->len + vmxnet3_xdp_headroom(adapter)
+				: rbi->len;
 			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
 							    len);
 			if (new_skb == NULL) {
@@ -1483,6 +1672,9 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				goto rcd_done;
 			}
 
+			if (adapter->xdp_enabled)
+				skb_reserve(new_skb, XDP_PACKET_HEADROOM);
+
 			if (rxDataRingUsed) {
 				size_t sz;
 
@@ -1620,8 +1812,30 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
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
+			xdp_prog = READ_ONCE(rq->xdp_bpf_prog);
+			if (!xdp_prog)
+				goto skip_xdp;
+
+			act = vmxnet3_run_xdp(rq, skb, buflen,
+					      &need_xdp_flush);
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
@@ -1775,6 +1989,7 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 
 	rq->comp_ring.gen = VMXNET3_INIT_GEN;
 	rq->comp_ring.next2proc = 0;
+	rq->xdp_bpf_prog = NULL;
 }
 
 
@@ -1787,6 +2002,32 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
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
@@ -1831,6 +2072,8 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 	kfree(rq->buf_info[0]);
 	rq->buf_info[0] = NULL;
 	rq->buf_info[1] = NULL;
+
+	vmxnet3_unregister_xdp_rxq(rq);
 }
 
 static void
@@ -1892,6 +2135,10 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 	}
 	vmxnet3_rq_alloc_rx_buf(rq, 1, rq->rx_ring[1].size - 1, adapter);
 
+	/* always register, even if no XDP prog used */
+	if (vmxnet3_register_xdp_rxq(rq, adapter))
+		return -EINVAL;
+
 	/* reset the comp ring */
 	rq->comp_ring.next2proc = 0;
 	memset(rq->comp_ring.base, 0, rq->comp_ring.size *
@@ -2593,7 +2840,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	if (adapter->netdev->features & NETIF_F_RXCSUM)
 		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
 
-	if (adapter->netdev->features & NETIF_F_LRO) {
+	if (adapter->netdev->features & NETIF_F_LRO &&
+		!adapter->xdp_enabled) {
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
@@ -3033,6 +3281,14 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
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
@@ -3043,7 +3299,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 		if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
 					    VMXNET3_MAX_ETH_HDR_SIZE) {
 			adapter->skb_buf_size = adapter->netdev->mtu +
-						VMXNET3_MAX_ETH_HDR_SIZE;
+						VMXNET3_MAX_ETH_HDR_SIZE +
+						vmxnet3_xdp_headroom(adapter);
 			if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
 				adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
 
@@ -3564,6 +3821,99 @@ vmxnet3_reset_work(struct work_struct *data)
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
+		WRITE_ONCE(rq->xdp_bpf_prog, prog);
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
@@ -3586,6 +3936,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 		.ndo_poll_controller = vmxnet3_netpoll,
 #endif
+		.ndo_bpf = vmxnet3_xdp,
 	};
 	int err;
 	u32 ver;
@@ -3901,6 +4252,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		goto err_register;
 	}
 
+	adapter->xdp_enabled = false;
 	vmxnet3_check_link(adapter, false);
 	return 0;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index ce3993282c0f..5574c18c0727 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -106,6 +106,16 @@ vmxnet3_rq_driver_stats[] = {
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
index 3367db23aa13..0f3b243302e4 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -56,6 +56,8 @@
 #include <linux/if_arp.h>
 #include <linux/inetdevice.h>
 #include <linux/log2.h>
+#include <linux/bpf.h>
+#include <linux/skbuff.h>
 
 #include "vmxnet3_defs.h"
 
@@ -285,6 +287,12 @@ struct vmxnet3_rq_driver_stats {
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
@@ -307,6 +315,8 @@ struct vmxnet3_rx_queue {
 	struct vmxnet3_rx_buf_info     *buf_info[2];
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
+	struct bpf_prog *xdp_bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
@@ -415,6 +425,7 @@ struct vmxnet3_adapter {
 	u16    tx_prod_offset;
 	u16    rx_prod_offset;
 	u16    rx_prod2_offset;
+	bool   xdp_enabled;
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
@@ -457,6 +468,11 @@ struct vmxnet3_adapter {
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


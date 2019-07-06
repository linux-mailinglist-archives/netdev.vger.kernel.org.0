Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1660F51
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfGFHgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:36:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41229 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfGFHgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:36:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so1954860pls.8
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 00:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wm7gIKriviJal4ksNGd9OT4JMKDI6oBmsP5RndytfL0=;
        b=K8ZFf9ZYTu8OlQy0cfDlbgDiHkxXI7US2eIB7BRbiN231lUuTPT0H4bYjg2+RA2oyC
         op066npA0zNgOPgUuNYl5fUdiPygWxlo7wAHSErEeWaJbqp+yJbU5doLPCufI/vZPwVn
         b2cK2TxMCs8DpnYu8KJ71PcB8b9V5Q9mt0iNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wm7gIKriviJal4ksNGd9OT4JMKDI6oBmsP5RndytfL0=;
        b=n5PXzR30C0QgW3T6DzkHJmRBEmDCIi4gQTJSyyFNrMa2SQ7uzyy1PLNnePmaQe7Lxb
         LcnOPbrMFj/wq64s5rZAS5ysNq9GQc2mHHIKgQuhOqC9vKgSHynNr0FTEqpnE6CEv/iR
         DEDm+Tx7ZkeEWxc/Y9MZWn/JqdlsLASO8/z9pA2LsfnMuWpCgdtH28xR55phJwK8F0Gv
         O0Ib+PiXldrUcDMzbs54AuiAspwN/YsVzWdesHImdkJmUYKI9eyP1Xbz/6fAdVTxZSfr
         yuQJFu2QM87VxpNxpeLtxsZKG1NxRxgC7Mw52r/lawprXcRnz6bYP0dueyTIMbsLnfv7
         JKFw==
X-Gm-Message-State: APjAAAVPp4HVKVn9Z8mBHPWLDb+TFdFSfTSa52RHOiYrBNsB2JcXey3s
        dX4vbYWKeR6RjkTSvfsJD7mqdYAw8f8=
X-Google-Smtp-Source: APXvYqwmDc0o/lgWJW/NhnIibUvgwuhE0KWw0kI8xn3wS7sv1zkgvlU+gJk6EHkYXZobwFKGYBmscw==
X-Received: by 2002:a17:902:a504:: with SMTP id s4mr10007966plq.117.1562398608233;
        Sat, 06 Jul 2019 00:36:48 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm1520144pfc.162.2019.07.06.00.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 00:36:47 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: [PATCH net-next 3/4] bnxt_en: optimized XDP_REDIRECT support
Date:   Sat,  6 Jul 2019 03:36:17 -0400
Message-Id: <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Gospodarek <gospo@broadcom.com>

This adds basic support for XDP_REDIRECT in the bnxt_en driver.  Next
patch adds the more optimized page pool support.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  27 ++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  13 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 108 ++++++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +
 4 files changed, 140 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b7b6227..d8f0846 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1989,6 +1989,9 @@ static int __bnxt_poll_work(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		}
 	}
 
+	if (event & BNXT_REDIRECT_EVENT)
+		xdp_do_flush_map();
+
 	if (event & BNXT_TX_EVENT) {
 		struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
 		u16 prod = txr->tx_prod;
@@ -2254,9 +2257,23 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
 
 		for (j = 0; j < max_idx;) {
 			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
-			struct sk_buff *skb = tx_buf->skb;
+			struct sk_buff *skb;
 			int k, last;
 
+			if (i < bp->tx_nr_rings_xdp &&
+			    tx_buf->action == XDP_REDIRECT) {
+				dma_unmap_single(&pdev->dev,
+					dma_unmap_addr(tx_buf, mapping),
+					dma_unmap_len(tx_buf, len),
+					PCI_DMA_TODEVICE);
+				xdp_return_frame(tx_buf->xdpf);
+				tx_buf->action = 0;
+				tx_buf->xdpf = NULL;
+				j++;
+				continue;
+			}
+
+			skb = tx_buf->skb;
 			if (!skb) {
 				j++;
 				continue;
@@ -2517,6 +2534,13 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 		if (rc < 0)
 			return rc;
 
+		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
+						MEM_TYPE_PAGE_SHARED, NULL);
+		if (rc) {
+			xdp_rxq_info_unreg(&rxr->xdp_rxq);
+			return rc;
+		}
+
 		rc = bnxt_alloc_ring(bp, &ring->ring_mem);
 		if (rc)
 			return rc;
@@ -10233,6 +10257,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_udp_tunnel_add	= bnxt_udp_tunnel_add,
 	.ndo_udp_tunnel_del	= bnxt_udp_tunnel_del,
 	.ndo_bpf		= bnxt_xdp,
+	.ndo_xdp_xmit		= bnxt_xdp_xmit,
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
 	.ndo_bridge_setlink	= bnxt_bridge_setlink,
 	.ndo_get_devlink_port	= bnxt_get_devlink_port,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bf12cfc..8ac51fa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -587,13 +587,18 @@ struct nqe_cn {
 #define BNXT_HWRM_CHNL_CHIMP	0
 #define BNXT_HWRM_CHNL_KONG	1
 
-#define BNXT_RX_EVENT	1
-#define BNXT_AGG_EVENT	2
-#define BNXT_TX_EVENT	4
+#define BNXT_RX_EVENT		1
+#define BNXT_AGG_EVENT		2
+#define BNXT_TX_EVENT		4
+#define BNXT_REDIRECT_EVENT	8
 
 struct bnxt_sw_tx_bd {
-	struct sk_buff		*skb;
+	union {
+		struct sk_buff		*skb;
+		struct xdp_frame	*xdpf;
+	};
 	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
 	u8			is_gso;
 	u8			is_push;
 	u8			action;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 41e232e..12489d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -53,6 +53,20 @@ static void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 	tx_buf->action = XDP_TX;
 }
 
+static void __bnxt_xmit_xdp_redirect(struct bnxt *bp,
+				     struct bnxt_tx_ring_info *txr,
+				     dma_addr_t mapping, u32 len,
+				     struct xdp_frame *xdpf)
+{
+	struct bnxt_sw_tx_bd *tx_buf;
+
+	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len);
+	tx_buf->action = XDP_REDIRECT;
+	tx_buf->xdpf = xdpf;
+	dma_unmap_addr_set(tx_buf, mapping, mapping);
+	dma_unmap_len_set(tx_buf, len, 0);
+}
+
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 {
 	struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
@@ -66,7 +80,17 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	for (i = 0; i < nr_pkts; i++) {
 		tx_buf = &txr->tx_buf_ring[tx_cons];
 
-		if (tx_buf->action == XDP_TX) {
+		if (tx_buf->action == XDP_REDIRECT) {
+			struct pci_dev *pdev = bp->pdev;
+
+			dma_unmap_single(&pdev->dev,
+					 dma_unmap_addr(tx_buf, mapping),
+					 dma_unmap_len(tx_buf, len),
+					 PCI_DMA_TODEVICE);
+			xdp_return_frame(tx_buf->xdpf);
+			tx_buf->action = 0;
+			tx_buf->xdpf = NULL;
+		} else if (tx_buf->action == XDP_TX) {
 			rx_doorbell_needed = true;
 			last_tx_cons = tx_cons;
 		}
@@ -101,19 +125,19 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		return false;
 
 	pdev = bp->pdev;
-	txr = rxr->bnapi->tx_ring;
 	rx_buf = &rxr->rx_buf_ring[cons];
 	offset = bp->rx_offset;
 
+	mapping = rx_buf->mapping - bp->rx_dma_offset;
+	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
+
+	txr = rxr->bnapi->tx_ring;
 	xdp.data_hard_start = *data_ptr - offset;
 	xdp.data = *data_ptr;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = *data_ptr + *len;
 	xdp.rxq = &rxr->xdp_rxq;
 	orig_data = xdp.data;
-	mapping = rx_buf->mapping - bp->rx_dma_offset;
-
-	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
 
 	rcu_read_lock();
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -149,6 +173,30 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 				NEXT_RX(rxr->rx_prod));
 		bnxt_reuse_rx_data(rxr, cons, page);
 		return true;
+	case XDP_REDIRECT:
+		/* if we are calling this here then we know that the
+		 * redirect is coming from a frame received by the
+		 * bnxt_en driver.
+		 */
+		dma_unmap_page_attrs(&pdev->dev, mapping,
+				     PAGE_SIZE, bp->rx_dir,
+				     DMA_ATTR_WEAK_ORDERING);
+
+		/* if we are unable to allocate a new buffer, abort and reuse */
+		if (bnxt_alloc_rx_data(bp, rxr, rxr->rx_prod, GFP_ATOMIC)) {
+			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_reuse_rx_data(rxr, cons, page);
+			return true;
+		}
+
+		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
+			trace_xdp_exception(bp->dev, xdp_prog, act);
+			__free_page(page);
+			return true;
+		}
+
+		*event |= BNXT_REDIRECT_EVENT;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		/* Fall thru */
@@ -162,6 +210,56 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	return true;
 }
 
+int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
+		  struct xdp_frame **frames, u32 flags)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct bpf_prog *xdp_prog = READ_ONCE(bp->xdp_prog);
+	struct pci_dev *pdev = bp->pdev;
+	struct bnxt_tx_ring_info *txr;
+	dma_addr_t mapping;
+	int drops = 0;
+	int ring;
+	int i;
+
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state) ||
+	    !bp->tx_nr_rings_xdp ||
+	    !xdp_prog)
+		return -EINVAL;
+
+	ring = smp_processor_id() % bp->tx_nr_rings_xdp;
+	txr = &bp->tx_ring[ring];
+
+	for (i = 0; i < num_frames; i++) {
+		struct xdp_frame *xdp = frames[i];
+
+		if (!txr || !bnxt_tx_avail(bp, txr) ||
+		    !(bp->bnapi[ring]->flags & BNXT_NAPI_FLAG_XDP)) {
+			xdp_return_frame_rx_napi(xdp);
+			drops++;
+			continue;
+		}
+
+		mapping = dma_map_single(&pdev->dev, xdp->data, xdp->len,
+					 DMA_TO_DEVICE);
+
+		if (dma_mapping_error(&pdev->dev, mapping)) {
+			xdp_return_frame_rx_napi(xdp);
+			drops++;
+			continue;
+		}
+		__bnxt_xmit_xdp_redirect(bp, txr, mapping, xdp->len, xdp);
+	}
+
+	if (flags & XDP_XMIT_FLUSH) {
+		/* Sync BD data before updating doorbell */
+		wmb();
+		bnxt_db_write(bp, &txr->tx_db, txr->tx_prod);
+	}
+
+	return num_frames - drops;
+}
+
 /* Under rtnl_lock */
 static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 20e470c..0df40c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -18,5 +18,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 struct page *page, u8 **data_ptr, unsigned int *len,
 		 u8 *event);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
+int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
+		  struct xdp_frame **frames, u32 flags);
 
 #endif
-- 
2.5.1


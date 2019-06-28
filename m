Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE95A6C7
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfF1WQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:16:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbfF1WP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:15:59 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5SMDkmU015169
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:57 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tdqm4rv06-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:57 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 15:15:57 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8FC17241A3725; Fri, 28 Jun 2019 15:15:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <jakub.kicinski@netronome.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 3/3 bpf-next] ixgbe: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.
Date:   Fri, 28 Jun 2019 15:15:55 -0700
Message-ID: <20190628221555.3009654-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=639 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the XDP program attached to a zero-copy AF_XDP socket returns XDP_TX,
queue the umem frame on the XDP TX ring.  Space on the recycle stack is
pre-allocated when the xsk is created.  (taken from tx_ring, since the 
xdp ring is not initialized yet)

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h     |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 74 +++++++++++++++++---
 2 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 39e73ad60352..aca33e4773f5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -150,6 +150,7 @@ enum ixgbe_tx_flags {
 	/* software defined flags */
 	IXGBE_TX_FLAGS_SW_VLAN	= 0x80,
 	IXGBE_TX_FLAGS_FCOE	= 0x100,
+	IXGBE_TX_FLAGS_ZC_FRAME	= 0x200,
 };
 
 /* VLAN info */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 65feb16200ea..c7a661736ab8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -77,7 +77,8 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	if (!xsk_umem_recycle_alloc(umem, adapter->rx_ring[0]->count))
+	if (!xsk_umem_recycle_alloc(umem, adapter->rx_ring[0]->count +
+					  adapter->tx_ring[0]->count))
 		return -ENOMEM;
 
 	err = ixgbe_xsk_umem_dma_map(adapter, umem);
@@ -135,13 +136,70 @@ int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem *umem,
 		ixgbe_xsk_umem_disable(adapter, qid);
 }
 
+static int ixgbe_xmit_rcvd_zc(struct ixgbe_adapter *adapter,
+			      struct ixgbe_ring *rx_ring,
+			      struct xdp_buff *xdp)
+{
+	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
+	struct ixgbe_tx_buffer *tx_buffer;
+	union ixgbe_adv_tx_desc *tx_desc;
+	struct xdp_frame *xdpf;
+	u32 len, cmd_type;
+	dma_addr_t dma;
+	u16 i;
+
+	if (unlikely(!ixgbe_desc_unused(ring)))
+		return IXGBE_XDP_CONSUMED;
+	xdpf = convert_to_xdp_frame_keep_zc(xdp);
+	if (unlikely(!xdpf))
+		return IXGBE_XDP_CONSUMED;
+	xdpf->handle = xdp->handle;
+	len = xdpf->len;
+
+	dma = xdp_umem_get_dma(rx_ring->xsk_umem, xdp->handle);
+
+	/* record the location of the first descriptor for this packet */
+	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
+	tx_buffer->bytecount = len;
+	tx_buffer->gso_segs = 1;
+	tx_buffer->protocol = 0;
+	tx_buffer->xdpf = xdpf;
+	tx_buffer->tx_flags = IXGBE_TX_FLAGS_ZC_FRAME;
+
+	i = ring->next_to_use;
+	tx_desc = IXGBE_TX_DESC(ring, i);
+
+	tx_desc->read.buffer_addr = cpu_to_le64(dma);
+
+	/* put descriptor type bits */
+	cmd_type = IXGBE_ADVTXD_DTYP_DATA |
+		   IXGBE_ADVTXD_DCMD_DEXT |
+		   IXGBE_ADVTXD_DCMD_IFCS;
+	cmd_type |= len | IXGBE_TXD_CMD;
+	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+	tx_desc->read.olinfo_status =
+		cpu_to_le32(len << IXGBE_ADVTXD_PAYLEN_SHIFT);
+
+	/* Avoid any potential race with xdp_xmit and cleanup */
+	smp_wmb();
+
+	/* set next_to_watch value indicating a packet is present */
+	i++;
+	if (i == ring->count)
+		i = 0;
+
+	tx_buffer->next_to_watch = tx_desc;
+	ring->next_to_use = i;
+
+	return IXGBE_XDP_TX;
+}
+
 static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 			    struct ixgbe_ring *rx_ring,
 			    struct xdp_buff *xdp)
 {
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
-	struct xdp_frame *xdpf;
 	u32 act;
 
 	rcu_read_lock();
@@ -152,12 +210,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdpf = convert_to_xdp_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
-		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		result = ixgbe_xmit_rcvd_zc(adapter, rx_ring, xdp);
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
@@ -576,6 +629,11 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
 				      struct ixgbe_tx_buffer *tx_bi)
 {
+	if (tx_bi->tx_flags & IXGBE_TX_FLAGS_ZC_FRAME) {
+		xsk_umem_recycle_addr(tx_ring->xsk_umem, tx_bi->xdpf->handle);
+		tx_bi->tx_flags = 0;
+		return;
+	}
 	xdp_return_frame(tx_bi->xdpf);
 	dma_unmap_single(tx_ring->dev,
 			 dma_unmap_addr(tx_bi, dma),
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71405A6C6
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF1WQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:16:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726672AbfF1WP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:15:59 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5SMC8Io020356
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:58 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tdabqbewp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:15:57 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 15:15:56 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8B460241A3722; Fri, 28 Jun 2019 15:15:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <jakub.kicinski@netronome.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 2/3 bpf-next] i40e: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.
Date:   Fri, 28 Jun 2019 15:15:54 -0700
Message-ID: <20190628221555.3009654-3-jonathan.lemon@gmail.com>
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
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280252
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 54 +++++++++++++++++++--
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 100e92d2982f..3e7954277737 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -274,6 +274,7 @@ static inline unsigned int i40e_txd_use_count(unsigned int size)
 #define I40E_TX_FLAGS_TSYN		BIT(8)
 #define I40E_TX_FLAGS_FD_SB		BIT(9)
 #define I40E_TX_FLAGS_UDP_TUNNEL	BIT(10)
+#define I40E_TX_FLAGS_ZC_FRAME		BIT(11)
 #define I40E_TX_FLAGS_VLAN_MASK		0xffff0000
 #define I40E_TX_FLAGS_VLAN_PRIO_MASK	0xe0000000
 #define I40E_TX_FLAGS_VLAN_PRIO_SHIFT	29
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index ce8650d06962..020f9859215d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -91,7 +91,8 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	if (!xsk_umem_recycle_alloc(umem, vsi->rx_rings[0]->count))
+	if (!xsk_umem_recycle_alloc(umem, vsi->rx_rings[0]->count +
+					  vsi->tx_rings[0]->count))
 		return -ENOMEM;
 
 	err = i40e_xsk_umem_dma_map(vsi, umem);
@@ -175,6 +176,48 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
 		i40e_xsk_umem_disable(vsi, qid);
 }
 
+static int i40e_xmit_rcvd_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+{
+	struct i40e_ring *xdp_ring;
+	struct i40e_tx_desc *tx_desc;
+	struct i40e_tx_buffer *tx_bi;
+	struct xdp_frame *xdpf;
+	dma_addr_t dma;
+
+	xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
+
+	if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
+		xdp_ring->tx_stats.tx_busy++;
+		return I40E_XDP_CONSUMED;
+	}
+	xdpf = convert_to_xdp_frame_keep_zc(xdp);
+	if (unlikely(!xdpf))
+		return I40E_XDP_CONSUMED;
+	xdpf->handle = xdp->handle;
+
+	dma = xdp_umem_get_dma(rx_ring->xsk_umem, xdp->handle);
+	tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
+	tx_bi->bytecount = xdpf->len;
+	tx_bi->gso_segs = 1;
+	tx_bi->xdpf = xdpf;
+	tx_bi->tx_flags = I40E_TX_FLAGS_ZC_FRAME;
+
+	tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
+	tx_desc->buffer_addr = cpu_to_le64(dma);
+	tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
+						  I40E_TX_DESC_CMD_EOP,
+				                  0, xdpf->len, 0);
+	smp_wmb();
+
+	xdp_ring->next_to_use++;
+	if (xdp_ring->next_to_use == xdp_ring->count)
+		xdp_ring->next_to_use = 0;
+
+	tx_bi->next_to_watch = tx_desc;
+
+	return I40E_XDP_TX;
+}
+
 /**
  * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
  * @rx_ring: Rx ring
@@ -187,7 +230,6 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = I40E_XDP_PASS;
-	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
@@ -202,8 +244,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
-		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
+		result = i40e_xmit_rcvd_zc(rx_ring, xdp);
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
@@ -628,6 +669,11 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
 				     struct i40e_tx_buffer *tx_bi)
 {
+	if (tx_bi->tx_flags & I40E_TX_FLAGS_ZC_FRAME) {
+		xsk_umem_recycle_addr(tx_ring->xsk_umem, tx_bi->xdpf->handle);
+		tx_bi->tx_flags = 0;
+		return;
+	}
 	xdp_return_frame(tx_bi->xdpf);
 	dma_unmap_single(tx_ring->dev,
 			 dma_unmap_addr(tx_bi, dma),
-- 
2.17.1


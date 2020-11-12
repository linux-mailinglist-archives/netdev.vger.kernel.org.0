Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD982B0C5A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKLSKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:10:37 -0500
Received: from inva020.nxp.com ([92.121.34.13]:40916 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgKLSKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 13:10:34 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C1EE91A0042;
        Thu, 12 Nov 2020 19:10:32 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B27321A0216;
        Thu, 12 Nov 2020 19:10:32 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6511F2032C;
        Thu, 12 Nov 2020 19:10:32 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next 7/7] dpaa_eth: implement the A050385 erratum workaround for XDP
Date:   Thu, 12 Nov 2020 20:10:12 +0200
Message-Id: <a3710846e0e831969ff5e769b1813c70a3d33d8b.1605181416.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For XDP TX, even tough we start out with correctly aligned buffers, the
XDP program might change the data's alignment. For REDIRECT, we have no
control over the alignment either.

Create a new workaround for xdp_frame structures to verify the erratum
conditions and move the data to a fresh buffer if necessary. Create a new
xdp_frame for managing the new buffer and free the old one using the XDP
API.

Due to alignment constraints, all frames have a 256 byte headroom that
is offered fully to XDP under the erratum. If the XDP program uses all
of it, the data needs to be move to make room for the xdpf backpointer.

Disable the metadata support since the information can be lost.

Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 82 +++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4b6fbbf..0418153 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2171,6 +2171,52 @@ static int dpaa_a050385_wa_skb(struct net_device *net_dev, struct sk_buff **s)
 
 	return 0;
 }
+
+static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
+				struct xdp_frame **init_xdpf)
+{
+	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
+	void *new_buff;
+	struct page *p;
+
+	/* Check the data alignment and make sure the headroom is large
+	 * enough to store the xdpf backpointer. Use an aligned headroom
+	 * value.
+	 *
+	 * Due to alignment constraints, we give XDP access to the full 256
+	 * byte frame headroom. If the XDP program uses all of it, copy the
+	 * data to a new buffer and make room for storing the backpointer.
+	 */
+	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
+	    xdpf->headroom >= priv->tx_headroom) {
+		xdpf->headroom = priv->tx_headroom;
+		return 0;
+	}
+
+	p = dev_alloc_pages(0);
+	if (unlikely(!p))
+		return -ENOMEM;
+
+	/* Copy the data to the new buffer at a properly aligned offset */
+	new_buff = page_address(p);
+	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
+
+	/* Create an XDP frame around the new buffer in a similar fashion
+	 * to xdp_convert_buff_to_frame.
+	 */
+	new_xdpf = new_buff;
+	new_xdpf->data = new_buff + priv->tx_headroom;
+	new_xdpf->len = xdpf->len;
+	new_xdpf->headroom = priv->tx_headroom;
+	new_xdpf->frame_sz = DPAA_BP_RAW_SIZE;
+	new_xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
+
+	/* Release the initial buffer */
+	xdp_return_frame_rx_napi(xdpf);
+
+	*init_xdpf = new_xdpf;
+	return 0;
+}
 #endif
 
 static netdev_tx_t
@@ -2407,6 +2453,15 @@ static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
 	percpu_priv = this_cpu_ptr(priv->percpu_priv);
 	percpu_stats = &percpu_priv->stats;
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	if (unlikely(fman_has_errata_a050385())) {
+		if (dpaa_a050385_wa_xdpf(priv, &xdpf)) {
+			err = -ENOMEM;
+			goto out_error;
+		}
+	}
+#endif
+
 	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
 		err = -EINVAL;
 		goto out_error;
@@ -2480,6 +2535,20 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
 	xdp.rxq = &dpaa_fq->xdp_rxq;
 
+	/* We reserve a fixed headroom of 256 bytes under the erratum and we
+	 * offer it all to XDP programs to use. If no room is left for the
+	 * xdpf backpointer on TX, we will need to copy the data.
+	 * Disable metadata support since data realignments might be required
+	 * and the information can be lost.
+	 */
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	if (unlikely(fman_has_errata_a050385())) {
+		xdp_set_data_meta_invalid(&xdp);
+		xdp.data_hard_start = vaddr;
+		xdp.frame_sz = DPAA_BP_RAW_SIZE;
+	}
+#endif
+
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
 	/* Update the length and the offset of the FD */
@@ -2487,7 +2556,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 
 	switch (xdp_act) {
 	case XDP_PASS:
-		*xdp_meta_len = xdp.data - xdp.data_meta;
+		*xdp_meta_len = xdp_data_meta_unsupported(&xdp) ? 0 :
+				xdp.data - xdp.data_meta;
 		break;
 	case XDP_TX:
 		/* We can access the full headroom when sending the frame
@@ -3177,10 +3247,16 @@ static u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
 	 */
 	headroom = (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);
 
-	if (port == RX)
+	if (port == RX) {
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+		if (unlikely(fman_has_errata_a050385()))
+			headroom = XDP_PACKET_HEADROOM;
+#endif
+
 		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
-	else
+	} else {
 		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
+	}
 }
 
 static int dpaa_eth_probe(struct platform_device *pdev)
-- 
1.9.1


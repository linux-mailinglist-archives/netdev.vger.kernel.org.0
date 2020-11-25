Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B702C45FF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbgKYQxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:53:53 -0500
Received: from inva020.nxp.com ([92.121.34.13]:45210 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgKYQxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:53:50 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 549871A1898;
        Wed, 25 Nov 2020 17:53:48 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 45D711A1897;
        Wed, 25 Nov 2020 17:53:48 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DE9202030D;
        Wed, 25 Nov 2020 17:53:47 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, maciej.fijalkowski@intel.com, brouer@redhat.com,
        saeed@kernel.org, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v5 5/7] dpaa_eth: add XDP_REDIRECT support
Date:   Wed, 25 Nov 2020 18:53:34 +0200
Message-Id: <f4cc525a0363dc20559393c80cbf731a663f4017.1606322126.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1606322126.git.camelia.groza@nxp.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1606322126.git.camelia.groza@nxp.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After transmission, the frame is returned on confirmation queues for
cleanup. For this, store a backpointer to the xdp_frame in the private
reserved area at the start of the TX buffer.

No TX batching support is implemented at this time.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 48 +++++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  1 +
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c2ed28d..dd08c46 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2305,8 +2305,11 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 {
 	struct dpaa_napi_portal *np =
 			container_of(napi, struct dpaa_napi_portal, napi);
+	int cleaned;
 
-	int cleaned = qman_p_poll_dqrr(np->p, budget);
+	np->xdp_act = 0;
+
+	cleaned = qman_p_poll_dqrr(np->p, budget);
 
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
@@ -2315,6 +2318,9 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
 
+	if (np->xdp_act & XDP_REDIRECT)
+		xdp_do_flush();
+
 	return cleaned;
 }
 
@@ -2457,6 +2463,7 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 xdp_act;
+	int err;
 
 	rcu_read_lock();
 
@@ -2498,6 +2505,17 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 			xdp_return_frame_rx_napi(xdpf);
 
 		break;
+	case XDP_REDIRECT:
+		/* Allow redirect to use the full headroom */
+		xdp.data_hard_start = vaddr;
+		xdp.frame_sz = DPAA_BP_RAW_SIZE;
+
+		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
+		if (err) {
+			trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
+			free_pages((unsigned long)vaddr, 0);
+		}
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
 		fallthrough;
@@ -2527,6 +2545,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	struct dpaa_percpu_priv *percpu_priv;
 	const struct qm_fd *fd = &dq->fd;
 	dma_addr_t addr = qm_fd_addr(fd);
+	struct dpaa_napi_portal *np;
 	enum qm_fd_format fd_format;
 	struct net_device *net_dev;
 	u32 fd_status, hash_offset;
@@ -2541,6 +2560,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 hash;
 	u64 ns;
 
+	np = container_of(&portal, struct dpaa_napi_portal, p);
 	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
 	fd_status = be32_to_cpu(fd->status);
 	fd_format = qm_fd_get_format(fd);
@@ -2614,6 +2634,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	if (likely(fd_format == qm_fd_contig)) {
 		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
 				       dpaa_fq, &xdp_meta_len);
+		np->xdp_act |= xdp_act;
 		if (xdp_act != XDP_PASS) {
 			percpu_stats->rx_packets++;
 			percpu_stats->rx_bytes += qm_fd_get_length(fd);
@@ -2946,6 +2967,30 @@ static int dpaa_xdp(struct net_device *net_dev, struct netdev_bpf *xdp)
 	}
 }
 
+static int dpaa_xdp_xmit(struct net_device *net_dev, int n,
+			 struct xdp_frame **frames, u32 flags)
+{
+	struct xdp_frame *xdpf;
+	int i, err, drops = 0;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	if (!netif_running(net_dev))
+		return -ENETDOWN;
+
+	for (i = 0; i < n; i++) {
+		xdpf = frames[i];
+		err = dpaa_xdp_xmit_frame(net_dev, xdpf);
+		if (err) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	return n - drops;
+}
+
 static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct dpaa_priv *priv = netdev_priv(dev);
@@ -3014,6 +3059,7 @@ static int dpaa_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd)
 	.ndo_setup_tc = dpaa_setup_tc,
 	.ndo_change_mtu = dpaa_change_mtu,
 	.ndo_bpf = dpaa_xdp,
+	.ndo_xdp_xmit = dpaa_xdp_xmit,
 };
 
 static int dpaa_napi_add(struct net_device *net_dev)
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index 5c8d52a..daf894a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -127,6 +127,7 @@ struct dpaa_napi_portal {
 	struct napi_struct napi;
 	struct qman_portal *p;
 	bool down;
+	int xdp_act;
 };
 
 struct dpaa_percpu_priv {
-- 
1.9.1


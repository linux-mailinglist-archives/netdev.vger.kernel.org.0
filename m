Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00C12B460E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgKPOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:42:43 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54224 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbgKPOmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:42:43 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8D10F1A0EAF;
        Mon, 16 Nov 2020 15:42:40 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F1BB1A0E82;
        Mon, 16 Nov 2020 15:42:40 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1E3B0202AF;
        Mon, 16 Nov 2020 15:42:40 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 2/7] dpaa_eth: add basic XDP support
Date:   Mon, 16 Nov 2020 16:42:28 +0200
Message-Id: <e8f6ede91ab1c3fa50953076e7983979de04d2b5.1605535745.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1605535745.git.camelia.groza@nxp.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605535745.git.camelia.groza@nxp.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the XDP_DROP and XDP_PASS actions.

Avoid draining and reconfiguring the buffer pool at each XDP
setup/teardown by increasing the frame headroom and reserving
XDP_PACKET_HEADROOM bytes from the start. Since we always reserve an
entire page per buffer, this change only impacts Jumbo frame scenarios
where the maximum linear frame size is reduced by 256 bytes. Multi
buffer Scatter/Gather frames are now used instead in these scenarios.

Allow XDP programs to access the entire buffer.

The data in the received frame's headroom can be overwritten by the XDP
program. Extract the relevant fields from the headroom while they are
still available, before running the XDP program.

Since the headroom might be resized before the frame is passed up to the
stack, remove the check for a fixed headroom value when building an skb.

Allow the meta data to be updated and pass the information up the stack.

Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
Changes in v2:
- warn only once if extracting the timestamp from a received frame fails

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 148 ++++++++++++++++++++++---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
 2 files changed, 134 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 88533a2..6b9ca60 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -53,6 +53,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/sort.h>
 #include <linux/phy_fixed.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 #include <soc/fsl/bman.h>
 #include <soc/fsl/qman.h>
 #include "fman.h"
@@ -177,7 +179,7 @@
 #define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE + DPAA_TIME_STAMP_SIZE \
 		       + DPAA_HASH_RESULTS_SIZE)
 #define DPAA_RX_PRIV_DATA_DEFAULT_SIZE (DPAA_TX_PRIV_DATA_SIZE + \
-					dpaa_rx_extra_headroom)
+					XDP_PACKET_HEADROOM - DPAA_HWA_SIZE)
 #ifdef CONFIG_DPAA_ERRATUM_A050385
 #define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN - DPAA_HWA_SIZE)
 #define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
@@ -1733,7 +1735,6 @@ static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
 		goto free_buffer;
-	WARN_ON(fd_off != priv->rx_headroom);
 	skb_reserve(skb, fd_off);
 	skb_put(skb, qm_fd_get_length(fd));

@@ -2349,12 +2350,62 @@ static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
 	return qman_cb_dqrr_consume;
 }

+static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
+			unsigned int *xdp_meta_len)
+{
+	ssize_t fd_off = qm_fd_get_offset(fd);
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 xdp_act;
+
+	rcu_read_lock();
+
+	xdp_prog = READ_ONCE(priv->xdp_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		return XDP_PASS;
+	}
+
+	xdp.data = vaddr + fd_off;
+	xdp.data_meta = xdp.data;
+	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
+	xdp.data_end = xdp.data + qm_fd_get_length(fd);
+	xdp.frame_sz = DPAA_BP_RAW_SIZE;
+
+	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
+
+	/* Update the length and the offset of the FD */
+	qm_fd_set_contig(fd, xdp.data - vaddr, xdp.data_end - xdp.data);
+
+	switch (xdp_act) {
+	case XDP_PASS:
+		*xdp_meta_len = xdp.data - xdp.data_meta;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(xdp_act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
+		fallthrough;
+	case XDP_DROP:
+		/* Free the buffer */
+		free_pages((unsigned long)vaddr, 0);
+		break;
+	}
+
+	rcu_read_unlock();
+
+	return xdp_act;
+}
+
 static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 						struct qman_fq *fq,
 						const struct qm_dqrr_entry *dq,
 						bool sched_napi)
 {
+	bool ts_valid = false, hash_valid = false;
 	struct skb_shared_hwtstamps *shhwtstamps;
+	unsigned int skb_len, xdp_meta_len = 0;
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa_percpu_priv *percpu_priv;
 	const struct qm_fd *fd = &dq->fd;
@@ -2364,10 +2415,11 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 fd_status, hash_offset;
 	struct dpaa_bp *dpaa_bp;
 	struct dpaa_priv *priv;
-	unsigned int skb_len;
 	struct sk_buff *skb;
 	int *count_ptr;
+	u32 xdp_act;
 	void *vaddr;
+	u32 hash;
 	u64 ns;

 	fd_status = be32_to_cpu(fd->status);
@@ -2423,35 +2475,58 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
 	(*count_ptr)--;

-	if (likely(fd_format == qm_fd_contig))
+	/* Extract the timestamp stored in the headroom before running XDP */
+	if (priv->rx_tstamp) {
+		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr, &ns))
+			ts_valid = true;
+		else
+			WARN_ONCE(1, "fman_port_get_tstamp failed!\n");
+	}
+
+	/* Extract the hash stored in the headroom before running XDP */
+	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use &&
+	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
+					      &hash_offset)) {
+		hash = be32_to_cpu(*(u32 *)(vaddr + hash_offset));
+		hash_valid = true;
+	}
+
+	if (likely(fd_format == qm_fd_contig)) {
+		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
+				       &xdp_meta_len);
+		if (xdp_act != XDP_PASS) {
+			percpu_stats->rx_packets++;
+			percpu_stats->rx_bytes += qm_fd_get_length(fd);
+			return qman_cb_dqrr_consume;
+		}
 		skb = contig_fd_to_skb(priv, fd);
-	else
+	} else {
+		WARN_ONCE(priv->xdp_prog, "S/G frames not supported under XDP\n");
 		skb = sg_fd_to_skb(priv, fd);
+	}
 	if (!skb)
 		return qman_cb_dqrr_consume;

-	if (priv->rx_tstamp) {
+	if (xdp_meta_len)
+		skb_metadata_set(skb, xdp_meta_len);
+
+	/* Set the previously extracted timestamp */
+	if (ts_valid) {
 		shhwtstamps = skb_hwtstamps(skb);
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
-
-		if (!fman_port_get_tstamp(priv->mac_dev->port[RX], vaddr, &ns))
-			shhwtstamps->hwtstamp = ns_to_ktime(ns);
-		else
-			dev_warn(net_dev->dev.parent, "fman_port_get_tstamp failed!\n");
+		shhwtstamps->hwtstamp = ns_to_ktime(ns);
 	}

 	skb->protocol = eth_type_trans(skb, net_dev);

-	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use &&
-	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
-					      &hash_offset)) {
+	/* Set the previously extracted hash */
+	if (hash_valid) {
 		enum pkt_hash_types type;

 		/* if L4 exists, it was used in the hash generation */
 		type = be32_to_cpu(fd->status) & FM_FD_STAT_L4CV ?
 			PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
-		skb_set_hash(skb, be32_to_cpu(*(u32 *)(vaddr + hash_offset)),
-			     type);
+		skb_set_hash(skb, hash, type);
 	}

 	skb_len = skb->len;
@@ -2671,6 +2746,46 @@ static int dpaa_eth_stop(struct net_device *net_dev)
 	return err;
 }

+static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog *prog)
+{
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct bpf_prog *old_prog;
+	bool up;
+	int err;
+
+	/* S/G fragments are not supported in XDP-mode */
+	if (prog && (priv->dpaa_bp->raw_size <
+	    net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN))
+		return -EINVAL;
+
+	up = netif_running(net_dev);
+
+	if (up)
+		dpaa_eth_stop(net_dev);
+
+	old_prog = xchg(&priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (up) {
+		err = dpaa_open(net_dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int dpaa_xdp(struct net_device *net_dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return dpaa_setup_xdp(net_dev, xdp->prog);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct dpaa_priv *priv = netdev_priv(dev);
@@ -2737,6 +2852,7 @@ static int dpaa_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd)
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
 	.ndo_do_ioctl = dpaa_ioctl,
 	.ndo_setup_tc = dpaa_setup_tc,
+	.ndo_bpf = dpaa_xdp,
 };

 static int dpaa_napi_add(struct net_device *net_dev)
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index da30e5d..94e8613 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -196,6 +196,8 @@ struct dpaa_priv {

 	bool tx_tstamp; /* Tx timestamping enabled */
 	bool rx_tstamp; /* Rx timestamping enabled */
+
+	struct bpf_prog *xdp_prog;
 };

 /* from dpaa_ethtool.c */
--
1.9.1


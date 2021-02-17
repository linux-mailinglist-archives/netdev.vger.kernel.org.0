Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3731DC16
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 16:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhBQPWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 10:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbhBQPS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 10:18:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E12C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 07:18:16 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1lCOai-0004fX-RI; Wed, 17 Feb 2021 16:18:12 +0100
Received: from sha by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1lCOai-0001eU-8S; Wed, 17 Feb 2021 16:18:12 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] Revert "dpaa_eth: add XDP_REDIRECT support"
Date:   Wed, 17 Feb 2021 16:17:58 +0100
Message-Id: <20210217151758.5622-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit a1e031ffb422bb89df9ad9c018420d0deff7f2e3.

This commit introduces a:

	np = container_of(&portal, struct dpaa_napi_portal, p);

Using container_of() on the address of a pointer doesn't make sense as
the pointer is not embedded into the desired struct.

KASAN complains about it like this:

[   17.703277] ==================================================================
[   17.710517] BUG: KASAN: stack-out-of-bounds in rx_default_dqrr+0x994/0x14a0
[   17.717504] Read of size 4 at addr ffff0009336495fc by task systemd/1
[   17.723955]
[   17.725447] CPU: 0 PID: 1 Comm: systemd Not tainted 5.11.0-rc6-20210204-2-00033-gfd6caa9c7514-dirty #63
[   17.734857] Hardware name: TQ TQMLS1046A SoM
[   17.742176] Call trace:
[   17.744621]  dump_backtrace+0x0/0x2e8
[   17.748298]  show_stack+0x1c/0x68
[   17.751622]  dump_stack+0xe8/0x14c
[   17.755033]  print_address_description.constprop.0+0x68/0x304
[   17.760794]  kasan_report+0x1d4/0x238
[   17.764466]  __asan_load4+0x88/0xc0
[   17.767962]  rx_default_dqrr+0x994/0x14a0
[   17.771980]  qman_p_poll_dqrr+0x254/0x278
[   17.776000]  dpaa_eth_poll+0x4c/0xe0
...

It's not clear to me how a the struct dpaa_napi_portal * should be
derived from the struct qman_portal *, so revert the patch for now.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

This merely puts the finger in the wound, I don't know how to properly fix
this issue. If you have a better idea what should be done instead please
let me know.

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 48 +------------------
 .../net/ethernet/freescale/dpaa/dpaa_eth.h    |  1 -
 2 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6faa20bed488..c0cfc7658962 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2389,11 +2389,8 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 {
 	struct dpaa_napi_portal *np =
 			container_of(napi, struct dpaa_napi_portal, napi);
-	int cleaned;
 
-	np->xdp_act = 0;
-
-	cleaned = qman_p_poll_dqrr(np->p, budget);
+	int cleaned = qman_p_poll_dqrr(np->p, budget);
 
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
@@ -2402,9 +2399,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
 
-	if (np->xdp_act & XDP_REDIRECT)
-		xdp_do_flush();
-
 	return cleaned;
 }
 
@@ -2556,7 +2550,6 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 xdp_act;
-	int err;
 
 	rcu_read_lock();
 
@@ -2616,17 +2609,6 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
 			xdp_return_frame_rx_napi(xdpf);
 
-		break;
-	case XDP_REDIRECT:
-		/* Allow redirect to use the full headroom */
-		xdp.data_hard_start = vaddr;
-		xdp.frame_sz = DPAA_BP_RAW_SIZE;
-
-		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
-		if (err) {
-			trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
-			free_pages((unsigned long)vaddr, 0);
-		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
@@ -2657,7 +2639,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	struct dpaa_percpu_priv *percpu_priv;
 	const struct qm_fd *fd = &dq->fd;
 	dma_addr_t addr = qm_fd_addr(fd);
-	struct dpaa_napi_portal *np;
 	enum qm_fd_format fd_format;
 	struct net_device *net_dev;
 	u32 fd_status, hash_offset;
@@ -2672,7 +2653,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 hash;
 	u64 ns;
 
-	np = container_of(&portal, struct dpaa_napi_portal, p);
 	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
 	fd_status = be32_to_cpu(fd->status);
 	fd_format = qm_fd_get_format(fd);
@@ -2746,7 +2726,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	if (likely(fd_format == qm_fd_contig)) {
 		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
 				       dpaa_fq, &xdp_meta_len);
-		np->xdp_act |= xdp_act;
 		if (xdp_act != XDP_PASS) {
 			percpu_stats->rx_packets++;
 			percpu_stats->rx_bytes += qm_fd_get_length(fd);
@@ -3079,30 +3058,6 @@ static int dpaa_xdp(struct net_device *net_dev, struct netdev_bpf *xdp)
 	}
 }
 
-static int dpaa_xdp_xmit(struct net_device *net_dev, int n,
-			 struct xdp_frame **frames, u32 flags)
-{
-	struct xdp_frame *xdpf;
-	int i, err, drops = 0;
-
-	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
-		return -EINVAL;
-
-	if (!netif_running(net_dev))
-		return -ENETDOWN;
-
-	for (i = 0; i < n; i++) {
-		xdpf = frames[i];
-		err = dpaa_xdp_xmit_frame(net_dev, xdpf);
-		if (err) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
-	}
-
-	return n - drops;
-}
-
 static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct dpaa_priv *priv = netdev_priv(dev);
@@ -3171,7 +3126,6 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_setup_tc = dpaa_setup_tc,
 	.ndo_change_mtu = dpaa_change_mtu,
 	.ndo_bpf = dpaa_xdp,
-	.ndo_xdp_xmit = dpaa_xdp_xmit,
 };
 
 static int dpaa_napi_add(struct net_device *net_dev)
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index daf894a97050..5c8d52aa86eb 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -127,7 +127,6 @@ struct dpaa_napi_portal {
 	struct napi_struct napi;
 	struct qman_portal *p;
 	bool down;
-	int xdp_act;
 };
 
 struct dpaa_percpu_priv {
-- 
2.29.2


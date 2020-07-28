Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208B32306E2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgG1Jsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:48:33 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59438 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgG1Jsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:48:30 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6EEE41A0064;
        Tue, 28 Jul 2020 11:48:28 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 62EDF1A0054;
        Tue, 28 Jul 2020 11:48:28 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3399C20328;
        Tue, 28 Jul 2020 11:48:28 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] dpaa2-eth: add reset control for debugfs statistics
Date:   Tue, 28 Jul 2020 12:48:12 +0300
Message-Id: <20200728094812.29002-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728094812.29002-1-ioana.ciornei@nxp.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export two debugfs control files through which the user can reset the
software kept statistics per CPU, per FQ, per channel - reset_stats - as
well as those kept by HW - reset_mc_stats.
This is especially useful in the context of debugging when there is a
need for precise statistics per a run of the test.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 56d9927fbfda..b1264ddb1ed2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -170,6 +170,62 @@ static const struct file_operations dpaa2_dbg_ch_ops = {
 	.release = single_release,
 };
 
+static ssize_t dpaa2_dbg_reset_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *offset)
+{
+	struct dpaa2_eth_priv *priv = file->private_data;
+	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct rtnl_link_stats64 *percpu_stats;
+	struct dpaa2_eth_channel *ch;
+	struct dpaa2_eth_fq *fq;
+	int i;
+
+	for_each_online_cpu(i) {
+		percpu_stats = per_cpu_ptr(priv->percpu_stats, i);
+		memset(percpu_stats, 0, sizeof(*percpu_stats));
+
+		percpu_extras = per_cpu_ptr(priv->percpu_extras, i);
+		memset(percpu_extras, 0, sizeof(*percpu_extras));
+	}
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		fq = &priv->fq[i];
+		memset(&fq->stats, 0, sizeof(fq->stats));
+	}
+
+	for (i = 0; i < priv->num_channels; i++) {
+		ch = priv->channel[i];
+		memset(&ch->stats, 0, sizeof(ch->stats));
+	}
+
+	return count;
+}
+
+static const struct file_operations dpaa2_dbg_reset_ops = {
+	.open = simple_open,
+	.write = dpaa2_dbg_reset_write,
+};
+
+static ssize_t dpaa2_dbg_reset_mc_write(struct file *file,
+					const char __user *buf,
+					size_t count, loff_t *offset)
+{
+	struct dpaa2_eth_priv *priv = file->private_data;
+	int err;
+
+	err = dpni_reset_statistics(priv->mc_io, 0, priv->mc_token);
+	if (err)
+		netdev_err(priv->net_dev,
+			   "dpni_reset_statistics() failed %d\n", err);
+
+	return count;
+}
+
+static const struct file_operations dpaa2_dbg_reset_mc_ops = {
+	.open = simple_open,
+	.write = dpaa2_dbg_reset_mc_write,
+};
+
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
 	struct dentry *dir;
@@ -186,6 +242,14 @@ void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 
 	/* per-fq stats file */
 	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_ops);
+
+	/* reset stats */
+	debugfs_create_file("reset_stats", 0200, dir, priv,
+			    &dpaa2_dbg_reset_ops);
+
+	/* reset MC stats */
+	debugfs_create_file("reset_mc_stats", 0200, dir, priv,
+			    &dpaa2_dbg_reset_mc_ops);
 }
 
 void dpaa2_dbg_remove(struct dpaa2_eth_priv *priv)
-- 
2.25.1


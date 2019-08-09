Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D475887A12
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406965AbfHIMbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406946AbfHIMby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:31:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB1421773;
        Fri,  9 Aug 2019 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353913;
        bh=eLl7AhIdm3vnbKUkQaLttAj1pwsihfL/bHzVwidLy7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLbuivfyRmjkXaKiQQjy7e2ZTmSrYuwLtXYS6q6E2v9MgcgJ4TnnZGci1CuFKnSAX
         UyZ2+Q9dq+pOGJc/eTIhu0WLT0XpKh1F1MMa7LnFFPWm72TuMuUtK3v8EFc5wHKJfK
         etJLoc2Yuvxqq4l6+Zhv789FV8Sy3MFX3vXX8Bhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 10/17] dpaa2: no need to check return value of debugfs_create functions
Date:   Fri,  9 Aug 2019 14:31:01 +0200
Message-Id: <20190809123108.27065-11-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809123108.27065-1-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Because we don't care about the individual files, we can remove the
stored dentry for the files, as they are not needed to be kept track of
at all.

Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 54 +++----------------
 .../freescale/dpaa2/dpaa2-eth-debugfs.h       |  3 --
 2 files changed, 7 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index a027f4a9d0cc..a9afe46b837f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -164,70 +164,30 @@ static const struct file_operations dpaa2_dbg_ch_ops = {
 
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
-	if (!dpaa2_dbg_root)
-		return;
+	struct dentry *dir;
 
 	/* Create a directory for the interface */
-	priv->dbg.dir = debugfs_create_dir(priv->net_dev->name,
-					   dpaa2_dbg_root);
-	if (!priv->dbg.dir) {
-		netdev_err(priv->net_dev, "debugfs_create_dir() failed\n");
-		return;
-	}
+	dir = debugfs_create_dir(priv->net_dev->name, dpaa2_dbg_root);
+	priv->dbg.dir = dir;
 
 	/* per-cpu stats file */
-	priv->dbg.cpu_stats = debugfs_create_file("cpu_stats", 0444,
-						  priv->dbg.dir, priv,
-						  &dpaa2_dbg_cpu_ops);
-	if (!priv->dbg.cpu_stats) {
-		netdev_err(priv->net_dev, "debugfs_create_file() failed\n");
-		goto err_cpu_stats;
-	}
+	debugfs_create_file("cpu_stats", 0444, dir, priv, &dpaa2_dbg_cpu_ops);
 
 	/* per-fq stats file */
-	priv->dbg.fq_stats = debugfs_create_file("fq_stats", 0444,
-						 priv->dbg.dir, priv,
-						 &dpaa2_dbg_fq_ops);
-	if (!priv->dbg.fq_stats) {
-		netdev_err(priv->net_dev, "debugfs_create_file() failed\n");
-		goto err_fq_stats;
-	}
+	debugfs_create_file("fq_stats", 0444, dir, priv, &dpaa2_dbg_fq_ops);
 
 	/* per-fq stats file */
-	priv->dbg.ch_stats = debugfs_create_file("ch_stats", 0444,
-						 priv->dbg.dir, priv,
-						 &dpaa2_dbg_ch_ops);
-	if (!priv->dbg.fq_stats) {
-		netdev_err(priv->net_dev, "debugfs_create_file() failed\n");
-		goto err_ch_stats;
-	}
-
-	return;
-
-err_ch_stats:
-	debugfs_remove(priv->dbg.fq_stats);
-err_fq_stats:
-	debugfs_remove(priv->dbg.cpu_stats);
-err_cpu_stats:
-	debugfs_remove(priv->dbg.dir);
+	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_ops);
 }
 
 void dpaa2_dbg_remove(struct dpaa2_eth_priv *priv)
 {
-	debugfs_remove(priv->dbg.fq_stats);
-	debugfs_remove(priv->dbg.ch_stats);
-	debugfs_remove(priv->dbg.cpu_stats);
-	debugfs_remove(priv->dbg.dir);
+	debugfs_remove_recursive(priv->dbg.dir);
 }
 
 void dpaa2_eth_dbg_init(void)
 {
 	dpaa2_dbg_root = debugfs_create_dir(DPAA2_ETH_DBG_ROOT, NULL);
-	if (!dpaa2_dbg_root) {
-		pr_err("DPAA2-ETH: debugfs create failed\n");
-		return;
-	}
-
 	pr_debug("DPAA2-ETH: debugfs created\n");
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.h
index 4f63de997a26..15598b28f03b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.h
@@ -11,9 +11,6 @@ struct dpaa2_eth_priv;
 
 struct dpaa2_debugfs {
 	struct dentry *dir;
-	struct dentry *fq_stats;
-	struct dentry *ch_stats;
-	struct dentry *cpu_stats;
 };
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.22.0


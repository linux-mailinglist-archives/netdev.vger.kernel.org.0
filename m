Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4313F88ACC
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJKbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfHJKbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:31:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5E42166E;
        Sat, 10 Aug 2019 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565433070;
        bh=1VpqSEukS5sRGvDloeUS/AAIRLLZaGzwqQwNoch3q5U=;
        h=Date:From:To:Cc:Subject:From;
        b=puZu/Wn5vERBaeAJ3FXBSEM4mmBMDonlL39tIcojB+A7MHgNMC6zohYDFNSvE85EO
         ePUrjr2BUv+roD7V2Sp+CMqY0mUG3v7tqHjf9DnyYx1HZjVsuiw6Vj5jsBaQHQqY0E
         z0x7YUWsTvAr27z0Cl4hAiMNHOp7cwxqkDpnswVs=
Date:   Sat, 10 Aug 2019 12:31:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul.durrant@citrix.com>,
        xen-devel@lists.xenproject.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] xen-netback: no need to check return value of debugfs_create
 functions
Message-ID: <20190810103108.GA29487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul.durrant@citrix.com>
Cc: xen-devel@lists.xenproject.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |  3 --
 drivers/net/xen-netback/xenbus.c  | 46 ++++++++-----------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7..e018932abf49 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1653,9 +1653,6 @@ static int __init netback_init(void)
 
 #ifdef CONFIG_DEBUG_FS
 	xen_netback_dbg_root = debugfs_create_dir("xen-netback", NULL);
-	if (IS_ERR_OR_NULL(xen_netback_dbg_root))
-		pr_warn("Init of debugfs returned %ld!\n",
-			PTR_ERR(xen_netback_dbg_root));
 #endif /* CONFIG_DEBUG_FS */
 
 	return 0;
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 41034264bd34..f533b7372d59 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -170,50 +170,26 @@ DEFINE_SHOW_ATTRIBUTE(xenvif_ctrl);
 
 static void xenvif_debugfs_addif(struct xenvif *vif)
 {
-	struct dentry *pfile;
 	int i;
 
-	if (IS_ERR_OR_NULL(xen_netback_dbg_root))
-		return;
-
 	vif->xenvif_dbg_root = debugfs_create_dir(vif->dev->name,
 						  xen_netback_dbg_root);
-	if (!IS_ERR_OR_NULL(vif->xenvif_dbg_root)) {
-		for (i = 0; i < vif->num_queues; ++i) {
-			char filename[sizeof("io_ring_q") + 4];
-
-			snprintf(filename, sizeof(filename), "io_ring_q%d", i);
-			pfile = debugfs_create_file(filename,
-						    0600,
-						    vif->xenvif_dbg_root,
-						    &vif->queues[i],
-						    &xenvif_dbg_io_ring_ops_fops);
-			if (IS_ERR_OR_NULL(pfile))
-				pr_warn("Creation of io_ring file returned %ld!\n",
-					PTR_ERR(pfile));
-		}
+	for (i = 0; i < vif->num_queues; ++i) {
+		char filename[sizeof("io_ring_q") + 4];
 
-		if (vif->ctrl_irq) {
-			pfile = debugfs_create_file("ctrl",
-						    0400,
-						    vif->xenvif_dbg_root,
-						    vif,
-						    &xenvif_ctrl_fops);
-			if (IS_ERR_OR_NULL(pfile))
-				pr_warn("Creation of ctrl file returned %ld!\n",
-					PTR_ERR(pfile));
-		}
-	} else
-		netdev_warn(vif->dev,
-			    "Creation of vif debugfs dir returned %ld!\n",
-			    PTR_ERR(vif->xenvif_dbg_root));
+		snprintf(filename, sizeof(filename), "io_ring_q%d", i);
+		debugfs_create_file(filename, 0600, vif->xenvif_dbg_root,
+				    &vif->queues[i],
+				    &xenvif_dbg_io_ring_ops_fops);
+	}
+
+	if (vif->ctrl_irq)
+		debugfs_create_file("ctrl", 0400, vif->xenvif_dbg_root, vif,
+				    &xenvif_ctrl_fops);
 }
 
 static void xenvif_debugfs_delif(struct xenvif *vif)
 {
-	if (IS_ERR_OR_NULL(xen_netback_dbg_root))
-		return;
-
 	debugfs_remove_recursive(vif->xenvif_dbg_root);
 	vif->xenvif_dbg_root = NULL;
 }
-- 
2.22.0


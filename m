Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164E783686
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfHFQMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387889AbfHFQMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC5C216F4;
        Tue,  6 Aug 2019 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107940;
        bh=yIW5I4jNU8ZxgTIOZUX43QxSzUJrmRVvvUxdtGVi7FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7SY+W+duBsC07xfJd8dzdOjQq1wQvl9hv7/BfpknKQ4jb6BqQUdOPSVbA09GhU1l
         +9RMJUYhFT80/MVUXLHC9XAg8tEkJbWOwHXtNbWsXbl9/KeuagY1aZu9OD5aOZu5pL
         RkYbOV4soAuENBzbChBwNk8nXBHMz9euT5pC9k8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 09/17] stmmac: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:20 +0200
Message-Id: <20190806161128.31232-10-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
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

Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 52 +++----------------
 2 files changed, 8 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 5cd966c154f3..fcc68782f8f8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -188,8 +188,6 @@ struct stmmac_priv {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dbgfs_dir;
-	struct dentry *dbgfs_rings_status;
-	struct dentry *dbgfs_dma_cap;
 #endif
 
 	unsigned long state;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c7c9e5f162e6..f8a8e88ab05b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -105,7 +105,7 @@ MODULE_PARM_DESC(chain_mode, "To use chain instead of ring mode");
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id);
 
 #ifdef CONFIG_DEBUG_FS
-static int stmmac_init_fs(struct net_device *dev);
+static void stmmac_init_fs(struct net_device *dev);
 static void stmmac_exit_fs(struct net_device *dev);
 #endif
 
@@ -3961,45 +3961,20 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
 
-static int stmmac_init_fs(struct net_device *dev)
+static void stmmac_init_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	/* Create per netdev entries */
 	priv->dbgfs_dir = debugfs_create_dir(dev->name, stmmac_fs_dir);
 
-	if (!priv->dbgfs_dir || IS_ERR(priv->dbgfs_dir)) {
-		netdev_err(priv->dev, "ERROR failed to create debugfs directory\n");
-
-		return -ENOMEM;
-	}
-
 	/* Entry to report DMA RX/TX rings */
-	priv->dbgfs_rings_status =
-		debugfs_create_file("descriptors_status", 0444,
-				    priv->dbgfs_dir, dev,
-				    &stmmac_rings_status_fops);
-
-	if (!priv->dbgfs_rings_status || IS_ERR(priv->dbgfs_rings_status)) {
-		netdev_err(priv->dev, "ERROR creating stmmac ring debugfs file\n");
-		debugfs_remove_recursive(priv->dbgfs_dir);
-
-		return -ENOMEM;
-	}
+	debugfs_create_file("descriptors_status", 0444, priv->dbgfs_dir, dev,
+			    &stmmac_rings_status_fops);
 
 	/* Entry to report the DMA HW features */
-	priv->dbgfs_dma_cap = debugfs_create_file("dma_cap", 0444,
-						  priv->dbgfs_dir,
-						  dev, &stmmac_dma_cap_fops);
-
-	if (!priv->dbgfs_dma_cap || IS_ERR(priv->dbgfs_dma_cap)) {
-		netdev_err(priv->dev, "ERROR creating stmmac MMC debugfs file\n");
-		debugfs_remove_recursive(priv->dbgfs_dir);
-
-		return -ENOMEM;
-	}
-
-	return 0;
+	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
+			    &stmmac_dma_cap_fops);
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
@@ -4366,10 +4341,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 #ifdef CONFIG_DEBUG_FS
-	ret = stmmac_init_fs(ndev);
-	if (ret < 0)
-		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
-			    __func__);
+	stmmac_init_fs(ndev);
 #endif
 
 	return ret;
@@ -4615,16 +4587,8 @@ static int __init stmmac_init(void)
 {
 #ifdef CONFIG_DEBUG_FS
 	/* Create debugfs main directory if it doesn't exist yet */
-	if (!stmmac_fs_dir) {
+	if (!stmmac_fs_dir)
 		stmmac_fs_dir = debugfs_create_dir(STMMAC_RESOURCE_NAME, NULL);
-
-		if (!stmmac_fs_dir || IS_ERR(stmmac_fs_dir)) {
-			pr_err("ERROR %s, debugfs create directory failed\n",
-			       STMMAC_RESOURCE_NAME);
-
-			return -ENOMEM;
-		}
-	}
 #endif
 
 	return 0;
-- 
2.22.0


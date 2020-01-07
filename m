Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D609F131FDE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgAGGhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:37:11 -0500
Received: from mail5.windriver.com ([192.103.53.11]:33546 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgAGGhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 01:37:11 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 0076Z4Kv025631
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 6 Jan 2020 22:35:24 -0800
Received: from pek-lpggp2 (128.224.153.75) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.468.0; Mon, 6 Jan 2020
 22:34:58 -0800
Received: by pek-lpggp2 (Postfix, from userid 20544)    id 7937D721550; Tue,  7
 Jan 2020 14:34:00 +0800 (CST)
From:   Jiping Ma <jiping.ma2@windriver.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>
CC:     <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <jiping.ma2@windriver.com>
Subject: [PATCH net V5] stmmac: debugfs entry name is not be changed when udev rename device name.
Date:   Tue, 7 Jan 2020 14:34:00 +0800
Message-ID: <20200107063400.41666-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add one notifier for udev changes net device name.
Fixes: b6601323ef9e ("net: stmmac: debugfs entry name is not be changed when udev rename")

Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6f51a265459d..80d59b775907 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -106,6 +106,7 @@ MODULE_PARM_DESC(chain_mode, "To use chain instead of ring mode");
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id);
 
 #ifdef CONFIG_DEBUG_FS
+static const struct net_device_ops stmmac_netdev_ops;
 static void stmmac_init_fs(struct net_device *dev);
 static void stmmac_exit_fs(struct net_device *dev);
 #endif
@@ -4256,6 +4257,34 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
 
+/* Use network device events to rename debugfs file entries.
+ */
+static int stmmac_device_event(struct notifier_block *unused,
+			       unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (dev->netdev_ops != &stmmac_netdev_ops)
+		goto done;
+
+	switch (event) {
+	case NETDEV_CHANGENAME:
+		if (priv->dbgfs_dir)
+			priv->dbgfs_dir = debugfs_rename(stmmac_fs_dir,
+							 priv->dbgfs_dir,
+							 stmmac_fs_dir,
+							 dev->name);
+		break;
+	}
+done:
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block stmmac_notifier = {
+	.notifier_call = stmmac_device_event,
+};
+
 static void stmmac_init_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -4270,12 +4299,15 @@ static void stmmac_init_fs(struct net_device *dev)
 	/* Entry to report the DMA HW features */
 	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
 			    &stmmac_dma_cap_fops);
+
+	register_netdevice_notifier(&stmmac_notifier);
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(priv->dbgfs_dir);
 }
 #endif /* CONFIG_DEBUG_FS */
-- 
2.18.1


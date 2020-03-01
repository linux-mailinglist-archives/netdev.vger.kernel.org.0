Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8202D174DC3
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCAOpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:25 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5714524672;
        Sun,  1 Mar 2020 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073923;
        bh=t24Xq3v1lJaSY2EA38e4hBMk+qV2vgMJgrQFzOkDWOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8fkPoNSdqvU30Q2e6u0QjBVEdWLrbUXGkKVzjBXENJqQP6FXrPi4OlC/TPmQEpDY
         d7jRZN2j4i72eE2Ka+tVkM9vtWyLO8d07Kv5qdavRBZj8mQSdG7S3qRzTmM5Vg9e/v
         ZCr4z/Gcax1sOlSKYYFm2aZBxGHB8H7jv3kgiiqk=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Casey Leedom <leedom@chelsio.com>, netdev@vger.kernel.org,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 08/23] net/chelsio: Delete drive and  module versions
Date:   Sun,  1 Mar 2020 16:44:41 +0200
Message-Id: <20200301144457.119795-9-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Clean the code related to various versions: driver and module.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/chelsio/cxgb/common.h          |  1 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c           |  3 ---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c     |  4 ----
 drivers/net/ethernet/chelsio/cxgb3/version.h        |  2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h          |  3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c  |  2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     | 10 ----------
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c |  9 ---------
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c  |  2 --
 9 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/common.h b/drivers/net/ethernet/chelsio/cxgb/common.h
index 94b9482f14a5..6475060649e9 100644
--- a/drivers/net/ethernet/chelsio/cxgb/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb/common.h
@@ -55,7 +55,6 @@
 
 #define DRV_DESCRIPTION "Chelsio 10Gb Ethernet Driver"
 #define DRV_NAME "cxgb"
-#define DRV_VERSION "2.2"
 
 #define CH_DEVICE(devid, ssid, idx) \
 	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, ssid, 0, 0, idx }
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0ccdde366ae1..4b8461103dda 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -429,7 +429,6 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct adapter *adapter = dev->ml_priv;
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
@@ -984,8 +983,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adapter *adapter = NULL;
 	struct port_info *pi;
 
-	pr_info_once("%s - version %s\n", DRV_DESCRIPTION, DRV_VERSION);
-
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 883cfa9c4b6d..ba3631f8cfe8 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -105,7 +105,6 @@ static const struct pci_device_id cxgb3_pci_tbl[] = {
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb3_pci_tbl);
 
 static int dflt_msg_enable = DFLT_MSG_ENABLE;
@@ -1629,7 +1628,6 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	spin_unlock(&adapter->stats_lock);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	if (fw_vers)
@@ -3210,8 +3208,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adapter *adapter = NULL;
 	struct port_info *pi;
 
-	pr_info_once("%s - version %s\n", DRV_DESC, DRV_VERSION);
-
 	if (!cxgb3_wq) {
 		cxgb3_wq = create_singlethread_workqueue(DRV_NAME);
 		if (!cxgb3_wq) {
diff --git a/drivers/net/ethernet/chelsio/cxgb3/version.h b/drivers/net/ethernet/chelsio/cxgb3/version.h
index 165bfb91487a..b4b2547efc86 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/version.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/version.h
@@ -34,8 +34,6 @@
 #define __CHELSIO_VERSION_H
 #define DRV_DESC "Chelsio T3 Network Driver"
 #define DRV_NAME "cxgb3"
-/* Driver version */
-#define DRV_VERSION "1.1.5-ko"
 
 /* Firmware version */
 #define FW_VERSION_MAJOR 7
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 8b7d156f79d3..5e9a5b09381f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1485,9 +1485,8 @@ static inline unsigned int qtimer_val(const struct adapter *adap,
 	return idx < SGE_NTIMERS ? adap->sge.timer_val[idx] : 0;
 }
 
-/* driver version & name used for ethtool_drvinfo */
+/* driver name used for ethtool_drvinfo */
 extern char cxgb4_driver_name[];
-extern const char cxgb4_driver_version[];
 
 void t4_os_portmod_changed(struct adapter *adap, int port_id);
 void t4_os_link_changed(struct adapter *adap, int port_id, int link_stat);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index c837382ee522..f3acdce74d43 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -170,8 +170,6 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	u32 exprom_vers;
 
 	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->version, cxgb4_driver_version,
-		sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 	info->regdump_len = get_regs_len(dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 649842a8aa28..3da25a2b5cc7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -90,11 +90,6 @@
 
 char cxgb4_driver_name[] = KBUILD_MODNAME;
 
-#ifdef DRV_VERSION
-#undef DRV_VERSION
-#endif
-#define DRV_VERSION "2.0.0-ko"
-const char cxgb4_driver_version[] = DRV_VERSION;
 #define DRV_DESC "Chelsio T4/T5/T6 Network Driver"
 
 #define DFLT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK | \
@@ -137,7 +132,6 @@ const char cxgb4_driver_version[] = DRV_VERSION;
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb4_pci_tbl);
 MODULE_FIRMWARE(FW4_FNAME);
 MODULE_FIRMWARE(FW5_FNAME);
@@ -3626,8 +3620,6 @@ static void cxgb4_mgmt_get_drvinfo(struct net_device *dev,
 	struct adapter *adapter = netdev2adap(dev);
 
 	strlcpy(info->driver, cxgb4_driver_name, sizeof(info->driver));
-	strlcpy(info->version, cxgb4_driver_version,
-		sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
@@ -6081,8 +6073,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, err;
 	u32 whoami;
 
-	printk_once(KERN_INFO "%s - version %s\n", DRV_DESC, DRV_VERSION);
-
 	err = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (err) {
 		/* Just info, some other driver may have claimed the device. */
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index f4d41f968afa..f4558be0ff05 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -55,7 +55,6 @@
 /*
  * Generic information about the driver.
  */
-#define DRV_VERSION "2.0.0-ko"
 #define DRV_DESC "Chelsio T4/T5/T6 Virtual Function (VF) Network Driver"
 
 /*
@@ -1556,7 +1555,6 @@ static void cxgb4vf_get_drvinfo(struct net_device *dev,
 	struct adapter *adapter = netdev2adap(dev);
 
 	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
@@ -2933,12 +2931,6 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	unsigned int pf;
 
-	/*
-	 * Print our driver banner the first time we're called to initialize a
-	 * device.
-	 */
-	pr_info_once("%s - version %s\n", DRV_DESC, DRV_VERSION);
-
 	/*
 	 * Initialize generic PCI device state.
 	 */
@@ -3454,7 +3446,6 @@ static void cxgb4vf_pci_shutdown(struct pci_dev *pdev)
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Chelsio Communications");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, cxgb4vf_pci_tbl);
 
 static struct pci_driver cxgb4vf_driver = {
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
index 21034536c9c5..854d87e1125c 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
@@ -35,7 +35,6 @@
  */
 
 #define DRV_NAME "libcxgb"
-#define DRV_VERSION "1.0.0-ko"
 #define pr_fmt(fmt) DRV_NAME ": " fmt
 
 #include <linux/kernel.h>
@@ -530,5 +529,4 @@ EXPORT_SYMBOL(cxgbi_tagmask_set);
 
 MODULE_AUTHOR("Chelsio Communications");
 MODULE_DESCRIPTION("Chelsio common library");
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.24.1


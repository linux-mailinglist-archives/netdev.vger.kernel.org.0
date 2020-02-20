Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DD016603B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgBTO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:36 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C17A206F4;
        Thu, 20 Feb 2020 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210775;
        bh=478JYQAq5DM74aZWlGZPKUL0SToYz0SRD5F6N2VwYmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/fo83wwR3ygMVCAZ1r7lfLbaO+he0ZRzCyYmIPORdN40PeCQmyMPdgYwTIaC427D
         DLdpyHQFuIOzsR9Yg2jnJx5b29IC3A/lqr0qWX8YDuLBmH/UA1LWRa2+9+l/+ksZR0
         vH9S90aoAKJ5ZW8mVxokStTl9Xc5SSp8sbMDpmVE=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 11/16] net/amazon: Ensure that driver version is aligned to the linux kernel
Date:   Thu, 20 Feb 2020 16:58:50 +0200
Message-Id: <20200220145855.255704-12-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>


Upstream drivers are managed inside global repository and released all
together, this ensure that driver version is the same as linux kernel,
so update amazon drivers to properly reflect it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++---------------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 -----------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index ced1d577b62a..19262f37db84 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
 	struct ena_adapter *adapter = netdev_priv(dev);

 	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0b2fd96b93d7..4faf81c456d8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -49,12 +49,9 @@
 #include <linux/bpf_trace.h>
 #include "ena_pci_id_tbl.h"

-static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
-
 MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
 MODULE_DESCRIPTION(DEVICE_NAME);
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);

 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5 * HZ)
@@ -3093,11 +3090,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
 		sizeof(host_info->os_dist_str) - 1);
-	host_info->driver_version =
-		(DRV_MODULE_VER_MAJOR) |
-		(DRV_MODULE_VER_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
-		(DRV_MODULE_VER_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
-		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
+	host_info->driver_version = LINUX_VERSION_CODE;
 	host_info->num_cpus = num_online_cpus();

 	host_info->driver_supported_features =
@@ -3476,9 +3469,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		netif_carrier_on(adapter->netdev);

 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
-	dev_err(&pdev->dev,
-		"Device reset completed successfully, Driver info: %s\n",
-		version);
+	dev_err(&pdev->dev, "Device reset completed successfully\n");

 	return rc;
 err_disable_msix:
@@ -4116,8 +4107,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)

 	dev_dbg(&pdev->dev, "%s\n", __func__);

-	dev_info_once(&pdev->dev, "%s", version);
-
 	rc = pci_enable_device_mem(pdev);
 	if (rc) {
 		dev_err(&pdev->dev, "pci_enable_device_mem() failed!\n");
@@ -4429,8 +4418,6 @@ static struct pci_driver ena_pci_driver = {

 static int __init ena_init(void)
 {
-	pr_info("%s", version);
-
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 8795e0b1dc3c..74c7f10b60dd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -45,18 +45,7 @@
 #include "ena_com.h"
 #include "ena_eth_com.h"

-#define DRV_MODULE_VER_MAJOR	2
-#define DRV_MODULE_VER_MINOR	1
-#define DRV_MODULE_VER_SUBMINOR 0
-
 #define DRV_MODULE_NAME		"ena"
-#ifndef DRV_MODULE_VERSION
-#define DRV_MODULE_VERSION \
-	__stringify(DRV_MODULE_VER_MAJOR) "."	\
-	__stringify(DRV_MODULE_VER_MINOR) "."	\
-	__stringify(DRV_MODULE_VER_SUBMINOR) "K"
-#endif
-
 #define DEVICE_NAME	"Elastic Network Adapter (ENA)"

 /* 1 for AENQ + ADMIN */
--
2.24.1


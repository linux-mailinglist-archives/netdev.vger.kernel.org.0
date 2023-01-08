Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CEE661484
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjAHKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHKfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:35:48 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD95E099
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673174148; x=1704710148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jmMFhHcQzWvtylhhO2ZZKHohq5cIvThpGTZA9jpMnx4=;
  b=Fek9kL15xUziBR5IXcNjhkZM/jcdATpDOtHQK4oyDyg1ZufseRh3bN7b
   EfJkUvxSHFShifjEprYKSx98CxGGJjrgTFoJt1/qaMGITbFs/8Uc5o8L0
   pRNveIZR9lnMr5jXtWDNJYSDgVaXKXjnRHrCIGU9qcDXtX2bhazX32MGn
   I=;
X-IronPort-AV: E=Sophos;i="5.96,310,1665446400"; 
   d="scan'208";a="168928150"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 10:35:45 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 871BABF7F2;
        Sun,  8 Jan 2023 10:35:43 +0000 (UTC)
Received: from EX19D002UWA002.ant.amazon.com (10.13.138.246) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 8 Jan 2023 10:35:42 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA002.ant.amazon.com (10.13.138.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sun, 8 Jan 2023 10:35:42 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Sun, 8 Jan 2023 10:35:40 +0000
From:   David Arinzon <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net-next 1/5] net: ena: Register ena device to devlink
Date:   Sun, 8 Jan 2023 10:35:29 +0000
Message-ID: <20230108103533.10104-2-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch registers ena as a device that supports devlink.
This makes it listed when running
        $ devlink dev show

The patch lands the base upon which the driver's devlink callbacks will
be added.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/Kconfig           |  1 +
 drivers/net/ethernet/amazon/ena/Makefile      |  2 +-
 drivers/net/ethernet/amazon/ena/ena_devlink.c | 42 +++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_devlink.h | 20 +++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 24 ++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 6 files changed, 88 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/amazon/ena/ena_devlink.c
 create mode 100644 drivers/net/ethernet/amazon/ena/ena_devlink.h

diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
index c37fa393b99e..8f1b3302a89e 100644
--- a/drivers/net/ethernet/amazon/Kconfig
+++ b/drivers/net/ethernet/amazon/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_AMAZON
 
 config ENA_ETHERNET
 	tristate "Elastic Network Adapter (ENA) support"
+	select NET_DEVLINK
 	depends on PCI_MSI && !CPU_BIG_ENDIAN
 	select DIMLIB
 	help
diff --git a/drivers/net/ethernet/amazon/ena/Makefile b/drivers/net/ethernet/amazon/ena/Makefile
index f1f752a8f7bb..34abcedd9132 100644
--- a/drivers/net/ethernet/amazon/ena/Makefile
+++ b/drivers/net/ethernet/amazon/ena/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_ENA_ETHERNET) += ena.o
 
-ena-y := ena_netdev.o ena_com.o ena_eth_com.o ena_ethtool.o
+ena-y := ena_netdev.o ena_com.o ena_eth_com.o ena_ethtool.o ena_devlink.o
diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.c b/drivers/net/ethernet/amazon/ena/ena_devlink.c
new file mode 100644
index 000000000000..6897d60d8376
--- /dev/null
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2015-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+
+#include "linux/pci.h"
+
+#include "ena_devlink.h"
+
+static const struct devlink_ops ena_devlink_ops = {};
+
+struct devlink *ena_devlink_alloc(struct ena_adapter *adapter)
+{
+	struct device *dev = &adapter->pdev->dev;
+	struct devlink *devlink;
+
+	devlink = devlink_alloc(&ena_devlink_ops, sizeof(struct ena_adapter *), dev);
+	if (!devlink) {
+		netdev_err(adapter->netdev, "Failed to allocate devlink struct\n");
+		return NULL;
+	}
+
+	ENA_DEVLINK_PRIV(devlink) = adapter;
+	adapter->devlink = devlink;
+
+	return devlink;
+}
+
+void ena_devlink_free(struct devlink *devlink)
+{
+	devlink_free(devlink);
+}
+
+void ena_devlink_register(struct devlink *devlink, struct device *dev)
+{
+	devlink_register(devlink);
+}
+
+void ena_devlink_unregister(struct devlink *devlink)
+{
+	devlink_unregister(devlink);
+}
diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.h b/drivers/net/ethernet/amazon/ena/ena_devlink.h
new file mode 100644
index 000000000000..6f737884b850
--- /dev/null
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright 2015-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+
+#ifndef DEVLINK_H
+#define DEVLINK_H
+
+#include "ena_netdev.h"
+#include <net/devlink.h>
+
+#define ENA_DEVLINK_PRIV(devlink) \
+	(*(struct ena_adapter **)devlink_priv(devlink))
+
+struct devlink *ena_devlink_alloc(struct ena_adapter *adapter);
+void ena_devlink_free(struct devlink *devlink);
+void ena_devlink_register(struct devlink *devlink, struct device *dev);
+void ena_devlink_unregister(struct devlink *devlink);
+
+#endif /* DEVLINK_H */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e8ad5ea31aff..ce79a0c42e6a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -22,6 +22,8 @@
 #include <linux/bpf_trace.h>
 #include "ena_pci_id_tbl.h"
 
+#include "ena_devlink.h"
+
 MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
 MODULE_DESCRIPTION(DEVICE_NAME);
 MODULE_LICENSE("GPL");
@@ -4243,6 +4245,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ena_adapter *adapter;
 	struct net_device *netdev;
 	static int adapters_found;
+	struct devlink *devlink;
 	u32 max_num_io_queues;
 	bool wd_state;
 	int bars, rc;
@@ -4308,12 +4311,18 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, adapter);
 
-	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
+	devlink = ena_devlink_alloc(adapter);
+	if (!devlink) {
+		netdev_err(netdev, "ena_devlink_alloc failed\n");
+		goto err_netdev_destroy;
+	}
+
+	rc = ena_device_init(adapter, pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
 		dev_err(&pdev->dev, "ENA device init failed\n");
 		if (rc == -ETIME)
 			rc = -EPROBE_DEFER;
-		goto err_netdev_destroy;
+		goto err_devlink_destroy;
 	}
 
 	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
@@ -4362,6 +4371,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"Failed to query interrupt moderation feature\n");
 		goto err_device_destroy;
 	}
+
 	ena_init_io_rings(adapter,
 			  0,
 			  adapter->xdp_num_queues +
@@ -4420,6 +4430,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapters_found++;
 
+	ena_devlink_register(devlink, &pdev->dev);
+
 	return 0;
 
 err_rss:
@@ -4436,6 +4448,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+err_devlink_destroy:
+	ena_devlink_free(devlink);
 err_netdev_destroy:
 	free_netdev(netdev);
 err_free_region:
@@ -4462,10 +4476,15 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 	struct ena_com_dev *ena_dev;
 	struct net_device *netdev;
+	struct devlink *devlink;
 
 	ena_dev = adapter->ena_dev;
 	netdev = adapter->netdev;
 
+	devlink = adapter->devlink;
+	ena_devlink_unregister(devlink);
+	ena_devlink_free(devlink);
+
 #ifdef CONFIG_RFS_ACCEL
 	if ((adapter->msix_vecs >= 1) && (netdev->rx_cpu_rmap)) {
 		free_irq_cpu_rmap(netdev->rx_cpu_rmap);
@@ -4482,6 +4501,7 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 	rtnl_lock(); /* lock released inside the below if-else block */
 	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
 	ena_destroy_device(adapter, true);
+
 	if (shutdown) {
 		netif_device_detach(netdev);
 		dev_close(netdev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 2cb141079474..c6132aa229df 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -313,6 +313,8 @@ struct ena_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
+	struct devlink *devlink;
+
 	/* rx packets that shorter that this len will be copied to the skb
 	 * header
 	 */
-- 
2.38.1


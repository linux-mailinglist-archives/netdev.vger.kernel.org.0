Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F9A2C5D74
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbgKZVUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:20:36 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12207 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732581AbgKZVUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425635; x=1637961635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=CVx90vVKm5SWSznoP7xoV/Cbln6faGZ29j4a7RHkHh4=;
  b=g7br0anKVyt43PJneh3gVYPTuXQ6zRty/UNRnnpS5wiPq4NB4qVDN1ii
   aKpTyyIFgkF9TY78cWdrJK68ea5mUS+qKvedZQEz2v4SBKCVKoJAD4Vwi
   Vc2pBDMphesGjXtPgHzLbrVWJgBwmOlVfjj0Wv4cThsW8/8wdLzi+iAj4
   o=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="67544111"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 26 Nov 2020 21:20:29 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 36909A082B;
        Thu, 26 Nov 2020 21:20:28 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:27 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:24 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RFC PATCH V2 net-next 1/9] net: ena: use constant value for net_device allocation
Date:   Thu, 26 Nov 2020 23:20:09 +0200
Message-ID: <1606425617-13112-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
References: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

The patch changes the maximum number of RX/TX queues it advertises to
the kernel (via alloc_etherdev_mq()) from a value received from the
device to a constant value which is the minimum between 128 and the
number of CPUs in the system.

By allocating the net_device struct with a constant number of queues,
the driver is able to allocate it at a much earlier stage, before
calling any ena_com functions. This would allow to make all log prints in
ena_com to use netdev_* log functions instead or current pr_* ones.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 ++++++++++----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index df1884d57d1a..985dea1870b5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -29,6 +29,8 @@ MODULE_LICENSE("GPL");
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5 * HZ)
 
+#define ENA_MAX_RINGS min_t(unsigned int, ENA_MAX_NUM_IO_QUEUES, num_possible_cpus())
+
 #define ENA_NAPI_BUDGET 64
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | \
@@ -4176,18 +4178,34 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_dev->dmadev = &pdev->dev;
 
+	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), ENA_MAX_RINGS);
+	if (!netdev) {
+		dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
+		rc = -ENOMEM;
+		goto err_free_region;
+	}
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	adapter = netdev_priv(netdev);
+	adapter->ena_dev = ena_dev;
+	adapter->netdev = netdev;
+	adapter->pdev = pdev;
+	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
+
+	pci_set_drvdata(pdev, adapter);
+
 	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
 		dev_err(&pdev->dev, "ENA device init failed\n");
 		if (rc == -ETIME)
 			rc = -EPROBE_DEFER;
-		goto err_free_region;
+		goto err_netdev_destroy;
 	}
 
 	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
 	if (rc) {
 		dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
-		goto err_free_ena_dev;
+		goto err_device_destroy;
 	}
 
 	calc_queue_ctx.ena_dev = ena_dev;
@@ -4207,26 +4225,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_device_destroy;
 	}
 
-	/* dev zeroed in init_etherdev */
-	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), max_num_io_queues);
-	if (!netdev) {
-		dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
-		rc = -ENOMEM;
-		goto err_device_destroy;
-	}
-
-	SET_NETDEV_DEV(netdev, &pdev->dev);
-
-	adapter = netdev_priv(netdev);
-	pci_set_drvdata(pdev, adapter);
-
-	adapter->ena_dev = ena_dev;
-	adapter->netdev = netdev;
-	adapter->pdev = pdev;
-
 	ena_set_conf_feat_params(adapter, &get_feat_ctx);
 
-	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
 
 	adapter->requested_tx_ring_size = calc_queue_ctx.tx_queue_size;
@@ -4257,7 +4257,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc) {
 		dev_err(&pdev->dev,
 			"Failed to query interrupt moderation feature\n");
-		goto err_netdev_destroy;
+		goto err_device_destroy;
 	}
 	ena_init_io_rings(adapter,
 			  0,
@@ -4335,11 +4335,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_disable_msix(adapter);
 err_worker_destroy:
 	del_timer(&adapter->timer_service);
-err_netdev_destroy:
-	free_netdev(netdev);
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+err_netdev_destroy:
+	free_netdev(netdev);
 err_free_region:
 	ena_release_bars(ena_dev, pdev);
 err_free_ena_dev:
-- 
2.23.3


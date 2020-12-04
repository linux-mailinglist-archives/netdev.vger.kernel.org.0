Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33402CEDCF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgLDMMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:12:16 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:52193 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgLDMMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083935; x=1638619935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5GDVpAx4OZTO3JNMzfYrHSsAoHyqbjzilS9nHEmOqo8=;
  b=XqQIsC05nJPO8kBy6XPFUmbdqT2dZzUHwa6MrDyp9GrVG4T7obMtZyiq
   oLgioWpAG7uTy+Xxf2uVMTfz0+lnSQE9bY/+DRWm0oIleB5ar9rbz7XA6
   94mwDglPhgR1on0XHmhXZze8aI32wPiis98NIEZqPrYA6cw11Gc9/ogni
   g=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="900598203"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 04 Dec 2020 12:11:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 628B0A2173;
        Fri,  4 Dec 2020 12:11:27 +0000 (UTC)
Received: from EX13D02UWC001.ant.amazon.com (10.43.162.243) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:26 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC001.ant.amazon.com (10.43.162.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:26 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:21 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V4 net-next 1/9] net: ena: use constant value for net_device allocation
Date:   Fri, 4 Dec 2020 14:11:07 +0200
Message-ID: <1607083875-32134-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
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
calling any ena_com functions. This would allow to make all log prints
in ena_com to use netdev_* log functions instead or current pr_* ones.

Note:
netdev_* prints in ena_com functions that are called before
net_device registration in ena_probe() might print messages that are
a bit ugly (with strings like "(unnamed net_device) (uninitialized)").
However we decided to use netdev_* prints in these functions anyway,
for the sake of getting better messages later, when ena_com functions
are called after ena_probe() form other parts of the driver.
See discussion about this decision in [1].

[1] http://www.mail-archive.com/netdev@vger.kernel.org/msg353590.html

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


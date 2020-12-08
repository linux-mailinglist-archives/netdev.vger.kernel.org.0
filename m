Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EED2D31A9
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgLHSD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:03:58 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:40722 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgLHSD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450637; x=1638986637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w6Scah2WdhqwpBEzk84qg2Cis/Z4CquqqMLMjFy1Avk=;
  b=usOUX3d9Fs/kpDHVBjsaRxBvr3Q3hPfpopoNwyq//m4y81Mz8VIqnnKi
   DirlNUEnx6BNcqwuJRyWp262y8hLPhfl8QMm6SeQo1wRf4F4J/kxY6IiQ
   O+Mv9zIh7NP8nRMJ6nCeU/VW1clbbIxpR/Ph5VYV8uMfGyiMna8xCwgzL
   k=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="901489877"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 08 Dec 2020 18:03:07 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id D3AF3120E78;
        Tue,  8 Dec 2020 18:03:06 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.211) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:02:58 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        David Woodhouse <dwmw@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Bshara Saeed <saeedb@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Nafea Bshara <nafea@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Samih Jubran <sameehj@amazon.com>,
        Noam Dagan <ndagan@amazon.com>
Subject: [PATCH net-next v5 1/9] net: ena: use constant value for net_device allocation
Date:   Tue, 8 Dec 2020 20:02:00 +0200
Message-ID: <20201208180208.26111-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
References: <20201208180208.26111-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 ++++++++++----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0e98f45c2b22..31c196c8c000 100644
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
2.17.1


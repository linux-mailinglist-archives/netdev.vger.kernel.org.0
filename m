Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00799271E22
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIUIjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:39:09 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56658 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUIjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600677549; x=1632213549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E1ta+faXL5E/RsdkVFwjll6Bfpuvbydxh8/VCcCZ9Kc=;
  b=EFgXf/DIpAbHPLi17f3Y7tFAPiKkeAeTtYcU9oYjERsT3+ebBrKJrRBi
   eEKaaasQuBRJe8iTWD/zGKB2xnBmgWXJYOMdJ5QUeGTrRBUvoqWoIvSF0
   1Vk1CNTG/skRbavcbQyfim01VYdYLig9Wy+ZbnciGm23ip2emdRl4J0le
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55200451"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Sep 2020 08:39:07 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id D0422A17C8;
        Mon, 21 Sep 2020 08:39:05 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.38) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 08:38:57 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net-next 4/7] net: ena: Remove redundant print of placement policy
Date:   Mon, 21 Sep 2020 11:37:39 +0300
Message-ID: <20200921083742.6454-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921083742.6454-1-shayagr@amazon.com>
References: <20200921083742.6454-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D31UWC003.ant.amazon.com (10.43.162.34) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The placement policy is printed in the process of queue creation in
ena_up(). No need to print it in ena_probe().

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index cab83a9de651..97e701222226 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4156,7 +4156,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	static int adapters_found;
 	u32 max_num_io_queues;
-	char *queue_type_str;
 	bool wd_state;
 	int bars, rc;
 
@@ -4334,15 +4333,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	timer_setup(&adapter->timer_service, ena_timer_service, 0);
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 
-	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
-		queue_type_str = "Regular";
-	else
-		queue_type_str = "Low Latency";
-
 	dev_info(&pdev->dev,
-		 "%s found at mem %lx, mac addr %pM, Placement policy: %s\n",
+		 "%s found at mem %lx, mac addr %pM\n",
 		 DEVICE_NAME, (long)pci_resource_start(pdev, 0),
-		 netdev->dev_addr, queue_type_str);
+		 netdev->dev_addr);
 
 	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 
-- 
2.17.1


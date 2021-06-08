Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD5A39FBA3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhFHQFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:05:10 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:20763 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhFHQFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168194; x=1654704194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wLm58nh7lUVu/rzNdyCp7xQHbWkZZPBhdmD1mKPlH0U=;
  b=QeIY36f44K6fAoKPRQhs7EOdjjgiX5/2/vTBqKBZm6o/ez8UE1O/LLYX
   Q108aAnzTC1/v7oB6/BWl4W/+eJ5dd3pVWeDYhsziyVoh6Iyn6csFX3AA
   y802Y7GuZTVp4Us16gd27HJA2gUKUinkAzRTiWGfXVj3xtl+5xh7ao5ai
   s=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="118846865"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 08 Jun 2021 16:03:07 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 57072A117E;
        Tue,  8 Jun 2021 16:03:06 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.160.137) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:02:58 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 06/10] net: ena: Remove module param and change message severity
Date:   Tue, 8 Jun 2021 19:01:14 +0300
Message-ID: <20210608160118.3767932-7-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the module param 'debug' which allows to specify the message
level of the driver. This value can be specified using ethtool command.
Also reduce the message level of LLQ support to be a warning since it is
not an indication of an error.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f013fa312937..6e648b6882b7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -35,9 +35,6 @@ MODULE_LICENSE("GPL");
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | \
 		NETIF_MSG_TX_DONE | NETIF_MSG_TX_ERR | NETIF_MSG_RX_ERR)
-static int debug = -1;
-module_param(debug, int, 0);
-MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 static struct ena_aenq_handlers aenq_handlers;
 
@@ -3360,7 +3357,7 @@ static int ena_set_queues_placement_policy(struct pci_dev *pdev,
 
 	llq_feature_mask = 1 << ENA_ADMIN_LLQ;
 	if (!(ena_dev->supported_features & llq_feature_mask)) {
-		dev_err(&pdev->dev,
+		dev_warn(&pdev->dev,
 			"LLQ is not supported Fallback to host mode policy.\n");
 		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
 		return 0;
@@ -4271,7 +4268,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->ena_dev = ena_dev;
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
+	adapter->msg_enable = DEFAULT_MSG_ENABLE;
 
 	ena_dev->net_device = netdev;
 
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D1C2D97B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfE2JvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:17 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36236 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfE2JvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123476; x=1590659476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IGG3biMdygMtK8dRlH6zaLVEiJjQWX1+vBe0RRdhCMU=;
  b=DG0pWhwAvMHtKIR09dFxt5/TkvH+0gSXUDMKTqf6uFE0NFjbpGCq664w
   iK7F7yJIKWCCWRwZ4LQeLCdT509Pwo7Au3DTdlCf8XxCxKKUrCMmmOwdC
   xNFWh/ubS106flZ+zXiKgv+dvQomuylGYWaKJDYoqjC/9DrR0eVTJx4jj
   4=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="735189397"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 May 2019 09:51:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 17D00A232B;
        Wed, 29 May 2019 09:51:15 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:59 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:55 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 11/11] net: ena: use dev_info_once instead of static variable
Date:   Wed, 29 May 2019 12:50:04 +0300
Message-ID: <20190529095004.13341-12-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index cff297e19..68bed2417 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3287,7 +3287,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
-	static int version_printed;
 	int io_queue_num, bars, rc;
 	struct net_device *netdev;
 	static int adapters_found;
@@ -3299,8 +3298,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
-	if (version_printed++ == 0)
-		dev_info(&pdev->dev, "%s", version);
+	dev_info_once(&pdev->dev, "%s", version);
 
 	rc = pci_enable_device_mem(pdev);
 	if (rc) {
-- 
2.17.1


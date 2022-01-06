Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF8486A7D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbiAFT3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:29:45 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:33213 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbiAFT3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497381; x=1673033381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J+RF6N6+W6lC57U9gBWE/L5Bh3664sV2GNEzb7Y0E4s=;
  b=PpR+lfRy8htu4KoEBDTG55RW/CYLT9CfuR0ZPR3Y5waMRcTQeOzBQisu
   QNWoh2GUFbjFJj1ur+9YfHeHHrNJjTOInJR6+XOXOc36nsLVDqtQdNCbL
   HJIlfBDUT1yIQu2W0qba4/STMyIY6LSdy0iLI5YIPl8uMIOMEXlBO2dFT
   s=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="53260855"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-b168f70e.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Jan 2022 19:29:41 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-b168f70e.us-west-2.amazon.com (Postfix) with ESMTPS id 0BE9B43113;
        Thu,  6 Jan 2022 19:29:41 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:40 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:38 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net-next 06/10] net: ena: Move reset completion print to the reset function
Date:   Thu, 6 Jan 2022 19:29:11 +0000
Message-ID: <20220106192915.22616-7-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The print that indicates that device reset has finished is
currently called from ena_restore_device().

Move it to ena_fw_reset_device() as it is the more natural
location for it.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2dfb1ee378e5..b4e10f7082e2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3654,8 +3654,6 @@ static int ena_restore_device(struct ena_adapter *adapter)
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 	adapter->last_keep_alive_jiffies = jiffies;
 
-	dev_err(&pdev->dev, "Device reset completed successfully\n");
-
 	return rc;
 err_disable_msix:
 	ena_free_mgmnt_irq(adapter);
@@ -3685,6 +3683,8 @@ static void ena_fw_reset_device(struct work_struct *work)
 	if (likely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
 		ena_destroy_device(adapter, false);
 		ena_restore_device(adapter);
+
+		dev_err(&adapter->pdev->dev, "Device reset completed successfully\n");
 	}
 
 	rtnl_unlock();
-- 
2.32.0


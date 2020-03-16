Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA6E186B36
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgCPMjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:39:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7873 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731050AbgCPMjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362372; x=1615898372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=fj7cT0ZSRv/x7oialbU0QAL0t519Tk7FW+jv5hR/uyo=;
  b=RciP9pYLmUt2FXuzqswUcUN8wh4MzdmMK5c+tbeCMYdo1NKBsZ2lGCdJ
   SnxusH5rTHVWq6Sh7B6DqSHwTCNYFqQ8MMhz1RCecNagAUAvH77JdpkQT
   JYdIGb8GO9nYkxX1i4Un0g8ThiUWTtxGce2HRhdiCDI9GW6vXKJqbWnLG
   c=;
IronPort-SDR: QSOSTNlKu1t6pOp0XZMn3N6kUE9beRgzDDN7fXkM4Ojo7A8tqvV8bCJjkeqeRkbS4Cu8XO7gMi
 f/dJ0wEl157g==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="31410944"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Mar 2020 12:39:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 6AE39C12AE;
        Mon, 16 Mar 2020 12:39:30 +0000 (UTC)
Received: from EX13D21UWA001.ant.amazon.com (10.43.160.154) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:39:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA001.ant.amazon.com (10.43.160.154) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:39:07 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:39:03 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 7/7] net: ena: fix continuous keep-alive resets
Date:   Mon, 16 Mar 2020 14:38:24 +0200
Message-ID: <1584362304-274-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584362304-274-1-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

last_keep_alive_jiffies is updated in probe and when a keep-alive
event is received.  In case the driver times-out on a keep-alive event,
it has high chances of continuously timing-out on keep-alive events.
This is because when the driver recovers from the keep-alive-timeout reset
the value of last_keep_alive_jiffies is very old, and if a keep-alive
event is not received before the next timer expires, the value of
last_keep_alive_jiffies will cause another keep-alive-timeout reset
and so forth in a loop.

Solution:
Update last_keep_alive_jiffies whenever the device is restored after
reset.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Noam Dagan <ndagan@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 51333a05c14d..4647d7656761 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3486,6 +3486,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		netif_carrier_on(adapter->netdev);
 
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
+	adapter->last_keep_alive_jiffies = jiffies;
 	dev_err(&pdev->dev,
 		"Device reset completed successfully, Driver info: %s\n",
 		version);
-- 
2.17.1


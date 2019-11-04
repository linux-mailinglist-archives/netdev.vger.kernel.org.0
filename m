Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2963EDF6A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 12:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKDL7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 06:59:03 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:31230 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKDL7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 06:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572868743; x=1604404743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=T5dGZvgdNLwwlfcyRiL4mpIIneAISMENAPI5lf25P10=;
  b=amh/nK0VOAmrJQox9Lhc2UHf9b3IdDkRGseOTbbDc3LGBOnIkBwKpZyo
   GBEBz8rPzP/XSXQN4F/nhD0Ts8umJEFoc0NfIv17tQNbefRyo9lFvZ52Z
   t+bjo7rIqm9yRTDJhJ+Huvas50SBvRpeNk0T0Ttide+FhHNl71NvBC29n
   s=;
IronPort-SDR: nNnhDUVwrObThNVxXm6sAzX0sP73z7KXImLjAuiVbM5+0EWoaYZIFRmtlsu0xsEskwAyJrqPSL
 lYlNCSkuTN9Q==
X-IronPort-AV: E=Sophos;i="5.68,267,1569283200"; 
   d="scan'208";a="3829685"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Nov 2019 11:59:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 19C5EA21F6;
        Mon,  4 Nov 2019 11:59:00 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:58:59 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:58:58 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.87) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 4 Nov 2019 11:58:54 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>
Subject: [PATCH V1 net 1/2] net: ena: fix issues in setting interrupt moderation params in ethtool
Date:   Mon, 4 Nov 2019 13:58:47 +0200
Message-ID: <1572868728-5211-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Issue 1:
--------
Reproduction steps:
1. sudo ethtool -C eth0 rx-usecs 128
2. sudo ethtool -C eth0 adaptive-rx on
3. sudo ethtool -C eth0 adaptive-rx off
4. ethtool -c eth0

expected output: rx-usecs 128
actual output: rx-usecs 0

Reason for issue:
In stage 3, ethtool userspace calls first the ena_get_coalesce() handler
to get the current value of all properties, and then the ena_set_coalesce()
handler. When ena_get_coalesce() is called the adaptive interrupt
moderation is still on. There is an if in the code that returns the
rx_coalesce_usecs only if the adaptive interrupt moderation is off.
And since it is still on, rx_coalesce_usecs is not set, meaning it
stays 0.

Solution to issue:
Remove this if static interrupt moderation intervals have nothing to do with
dynamic ones.

Issue 2:
--------
Reproduction steps:
1. sudo ethtool -C eth0 rx-usecs 128
2. sudo ethtool -C eth0 adaptive-rx on
3. sudo ethtool -C eth0 rx-usecs 128
4. ethtool -c eth0

expected output: rx-usecs 128
actual output: rx-usecs 0

Reason for issue:
In stage 3, when ena_set_coalesce() is called, the handler tests if
rx adaptive interrupt moderation is on, and if it is, it returns before
getting to the part in the function that sets the rx non-adaptive
interrupt moderation interval.

Solution to issue:
Remove the return from the function when rx adaptive interrupt moderation
is on.

Additional small fixes in this commit:
--------------------------------------
1. Remove 2 unnecessary comments.
2. Remove 4 unnecesary "{}" in single row if statements.
3. Reorder ena_set_coalesce() to make sense.
4. Change the names of ena_update_tx/rx_rings_intr_moderation()
   functions to ena_update_tx/rx_rings_nonadaptive_intr_moderation() for
   clarity.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 40 ++++++++-----------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 16553d92fad2..b042c70504cd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -306,19 +306,16 @@ static int ena_get_coalesce(struct net_device *net_dev,
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 
-	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
-		/* the devie doesn't support interrupt moderation */
+	if (!ena_com_interrupt_moderation_supported(ena_dev))
 		return -EOPNOTSUPP;
-	}
 
 	coalesce->tx_coalesce_usecs =
 		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) *
 			ena_dev->intr_delay_resolution;
 
-	if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
-		coalesce->rx_coalesce_usecs =
-			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
-			* ena_dev->intr_delay_resolution;
+	coalesce->rx_coalesce_usecs =
+		ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
+		* ena_dev->intr_delay_resolution;
 
 	coalesce->use_adaptive_rx_coalesce =
 		ena_com_get_adaptive_moderation_enabled(ena_dev);
@@ -326,7 +323,7 @@ static int ena_get_coalesce(struct net_device *net_dev,
 	return 0;
 }
 
-static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
+static void ena_update_tx_rings_nonadaptive_intr_moderation(struct ena_adapter *adapter)
 {
 	unsigned int val;
 	int i;
@@ -337,7 +334,7 @@ static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
 		adapter->tx_ring[i].smoothed_interval = val;
 }
 
-static void ena_update_rx_rings_intr_moderation(struct ena_adapter *adapter)
+static void ena_update_rx_rings_nonadaptive_intr_moderation(struct ena_adapter *adapter)
 {
 	unsigned int val;
 	int i;
@@ -355,35 +352,30 @@ static int ena_set_coalesce(struct net_device *net_dev,
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc;
 
-	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
-		/* the devie doesn't support interrupt moderation */
+	if (!ena_com_interrupt_moderation_supported(ena_dev))
 		return -EOPNOTSUPP;
-	}
 
 	rc = ena_com_update_nonadaptive_moderation_interval_tx(ena_dev,
 							       coalesce->tx_coalesce_usecs);
 	if (rc)
 		return rc;
 
-	ena_update_tx_rings_intr_moderation(adapter);
-
-	if (coalesce->use_adaptive_rx_coalesce) {
-		if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_enable_adaptive_moderation(ena_dev);
-		return 0;
-	}
+	ena_update_tx_rings_nonadaptive_intr_moderation(adapter);
 
 	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
 							       coalesce->rx_coalesce_usecs);
 	if (rc)
 		return rc;
 
-	ena_update_rx_rings_intr_moderation(adapter);
+	ena_update_rx_rings_nonadaptive_intr_moderation(adapter);
 
-	if (!coalesce->use_adaptive_rx_coalesce) {
-		if (ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_disable_adaptive_moderation(ena_dev);
-	}
+	if ((coalesce->use_adaptive_rx_coalesce) &&
+	    (!ena_com_get_adaptive_moderation_enabled(ena_dev)))
+		ena_com_enable_adaptive_moderation(ena_dev);
+
+	if ((!coalesce->use_adaptive_rx_coalesce) &&
+	    (ena_com_get_adaptive_moderation_enabled(ena_dev)))
+		ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
 }
-- 
2.17.1


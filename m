Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299621265EB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:41:22 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:35667 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfLSPlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576770081; x=1608306081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jRCUA+UHbztDohooaM0Gl+KdJOND5kGgEsV7EVHHmb0=;
  b=XQ+YpgLSlHjv8KEllbKUdwl2tWYVhBvpfttOQYI0exdTWUciiJN3CrxD
   j0jUvPs8SfhqYJYvdtYdgwuly6djpqICLc88bKv05XMrT42e+YfxteeCz
   HbMQeUH73DRsD12JiMFP62nrsbL9OVug/Lrs///72JveJkCntD/qK+PGC
   Q=;
IronPort-SDR: 6eJKImWsgzyZTqXE5fYr5gKFuFQgKc9z9IySlNYsUgbEyFPQIoqii1bhX+g3i1tufpPour+xBp
 +NdK0pHSrNOQ==
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="9801803"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Dec 2019 15:41:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 598A91A1DA7;
        Thu, 19 Dec 2019 15:41:18 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:12 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.74) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Dec 2019 15:41:08 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 2/2] net: ena: fix issues in setting interrupt moderation params in ethtool
Date:   Thu, 19 Dec 2019 17:40:56 +0200
Message-ID: <1576770056-1304-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
References: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
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
Remove this if static interrupt moderation intervals have nothing to do
with dynamic ones.

Issue 2:
--------
Reproduction steps:
1. sudo ethtool -C eth0 adaptive-rx on
2. sudo ethtool -C eth0 rx-usecs 128
3. ethtool -c eth0

expected output: rx-usecs 128
actual output: rx-usecs 0

Reason for issue:
In stage 2, when ena_set_coalesce() is called, the handler tests if
rx adaptive interrupt moderation is on, and if it is, it returns before
getting to the part in the function that sets the rx non-adaptive
interrupt moderation interval.

Solution to issue:
Remove the return from the function when rx adaptive interrupt moderation
is on.

Also cleaned up the fixed code in ena_set_coalesce by grouping together
adaptive interrupt moderation toggling, and using && instead of nested
ifs.

Fixes: b3db86dc4b82 ("net: ena: reimplement set/get_coalesce()")
Fixes: 0eda847953d8 ("net: ena: fix retrieval of nonadaptive interrupt moderation intervals")
Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index a3250dc..fc96c66 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -315,10 +315,9 @@ static int ena_get_coalesce(struct net_device *net_dev,
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
@@ -367,12 +366,6 @@ static int ena_set_coalesce(struct net_device *net_dev,
 
 	ena_update_tx_rings_intr_moderation(adapter);
 
-	if (coalesce->use_adaptive_rx_coalesce) {
-		if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_enable_adaptive_moderation(ena_dev);
-		return 0;
-	}
-
 	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
 							       coalesce->rx_coalesce_usecs);
 	if (rc)
@@ -380,10 +373,13 @@ static int ena_set_coalesce(struct net_device *net_dev,
 
 	ena_update_rx_rings_intr_moderation(adapter);
 
-	if (!coalesce->use_adaptive_rx_coalesce) {
-		if (ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_disable_adaptive_moderation(ena_dev);
-	}
+	if (coalesce->use_adaptive_rx_coalesce &&
+	    !ena_com_get_adaptive_moderation_enabled(ena_dev))
+		ena_com_enable_adaptive_moderation(ena_dev);
+
+	if (!coalesce->use_adaptive_rx_coalesce &&
+	    ena_com_get_adaptive_moderation_enabled(ena_dev))
+		ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
 }
-- 
2.7.4


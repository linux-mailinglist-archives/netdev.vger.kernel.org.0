Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A7B1628
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfILWK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:59 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58453 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326258; x=1599862258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nPXZHS/gfQ4czuyReyzXmr1VESdR2NuD7GFm+a7RjTE=;
  b=hXl0ec4LbzzDbIG2qITrvHWPelUntR4t6y13NOTMFtGERykw6MBin+0y
   bd+88O6ek3CSm0HjoSSUPpnl2AcOIejiO1Tto/aj786I7VGWxB4PqR6A/
   KUMF4EdEiX5leZuF+9nyecDudFKuq2HYICHusDwI438khen7onmP3kfCx
   o=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="784692885"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Sep 2019 22:10:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 50461A1E58;
        Thu, 12 Sep 2019 22:10:57 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:30 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:10:20 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 10/11] net: ena: fix retrieval of nonadaptive interrupt moderation intervals
Date:   Fri, 13 Sep 2019 01:08:47 +0300
Message-ID: <1568326128-4057-11-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Nonadaptive interrupt moderation intervals are assigned the value set
by the user in ethtool -C divided by ena_dev->intr_delay_resolution.

Therefore when the user tries to get the nonadaptive interrupt moderation
intervals with ethtool -c the code needs to multiply the saved value
by ena_dev->intr_delay_resolution.

The current code erroneously divides instead of multiplying in ethtool -c.
This patch fixes this.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 0f90e2296630..16553d92fad2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -310,14 +310,15 @@ static int ena_get_coalesce(struct net_device *net_dev,
 		/* the devie doesn't support interrupt moderation */
 		return -EOPNOTSUPP;
 	}
+
 	coalesce->tx_coalesce_usecs =
-		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) /
+		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) *
 			ena_dev->intr_delay_resolution;
 
 	if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
 		coalesce->rx_coalesce_usecs =
 			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
-			/ ena_dev->intr_delay_resolution;
+			* ena_dev->intr_delay_resolution;
 
 	coalesce->use_adaptive_rx_coalesce =
 		ena_com_get_adaptive_moderation_enabled(ena_dev);
-- 
2.17.2


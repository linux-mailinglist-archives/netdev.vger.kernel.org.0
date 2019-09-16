Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D974B3976
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbfIPLfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:35:00 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:38274 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfIPLfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633699; x=1600169699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nPXZHS/gfQ4czuyReyzXmr1VESdR2NuD7GFm+a7RjTE=;
  b=MKikxRGKzoOZvtA0wa4KXjevkGLzb0J9mAjV5iBGx76VYVMCQOI0Rhvj
   aQOuN8CbRV5UpEygw3glW6JprDWka56Qd0+m8P4GA1Vuglu4JtbckdnLs
   ZO7OgBv0Lvr5HzhiJGo0P7TUa2eSpwn7UMILionsubc0W/WUSfk70iKfm
   g=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="832629171"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Sep 2019 11:32:39 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id B93A7A261A;
        Mon, 16 Sep 2019 11:32:38 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:15 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:14 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:32:11 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 10/11] net: ena: fix retrieval of nonadaptive interrupt moderation intervals
Date:   Mon, 16 Sep 2019 14:31:35 +0300
Message-ID: <1568633496-4143-11-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
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


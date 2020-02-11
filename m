Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FF91592C5
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgBKPS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:26 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1800 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbgBKPSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434306; x=1612970306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6xzgtDORqyJNBW10jla/yglZJRoJoP3XhY0M/+WBJig=;
  b=K2esDYT5w8Gp3Ob6IPNRHgu9pGz+0RbTXmsriohgJCrFDecS6Ml9uOKe
   UbTp9sJG4017GXabW8LVirzAcpJh5Wmb0AZhMbZ6piuiEbAirD+Eae0+6
   fCJvAOxrC0E9D5Qk3j/s0KFLEX8ijr1mpDJtkFFh3Jw+0+PkBqwSCkaqm
   M=;
IronPort-SDR: A0veJMkwlKQF7NljqOYUqPrc5K/TN1/gptUWaraF2uppwxrVoqp66OQ9ehG/LHhxXvV7wBnnI7
 mDWc/8ZdRAqw==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="17206418"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Feb 2020 15:17:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 0CDDCA1FE9;
        Tue, 11 Feb 2020 15:17:58 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id A6FB581D36; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>,
        "Ezequiel Lara Gomez" <ezegomez@amazon.com>
Subject: [PATCH V2 net 03/12] net: ena: add missing ethtool TX timestamping indication
Date:   Tue, 11 Feb 2020 15:17:42 +0000
Message-ID: <20200211151751.29718-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Current implementation of the driver calls skb_tx_timestamp()to add a
software tx timestamp to the skb, however the software-transmit capability
is not reported in ethtool -T.

This commit updates the ethtool structure to report the software-transmit
capability in ethtool -T using the standard ethtool_op_get_ts_info().
This function reports all software timestamping capabilities (tx and rx),
as well as setting phc_index = -1. phc_index is the index of the PTP
hardware clock device that will be used for hardware timestamps. Since we
don't have such a device in ENA, using the default -1 value is the correct
setting.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Ezequiel Lara Gomez <ezegomez@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index fc96c66b4..8b56383b6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -812,6 +812,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.set_channels		= ena_set_channels,
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
+	.get_ts_info            = ethtool_op_get_ts_info,
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev)
-- 
2.24.1.AMZN


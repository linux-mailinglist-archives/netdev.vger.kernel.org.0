Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D651086F
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEANsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:48:04 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:44388 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfEANsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718483; x=1588254483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=J+KRfGPDRC8LegERfrvtkGpZm3Z9m2dwilAL9Q6eGec=;
  b=DlS3YPHc5j4IpuWYv/4dk2fHli+xOBEx0G9k9SiqXfyyI5lmmHtVPkVq
   /Es46ORTQtc8guzjfcpqMWiC0kSh/WbV4WDSKNfhki5vS8RO6lj+/wjiP
   t5FrKqz3uChPHP3lk/LolViR3DihLd41ZDtWSDAGOOKADW82Es1y4SSH+
   4=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="797293783"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:48:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41Dm1Kx124046
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:48:02 GMT
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:43 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:39 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 6/8] net: ena: improve latency by disabling adaptive interrupt moderation by default
Date:   Wed, 1 May 2019 16:47:08 +0300
Message-ID: <20190501134710.8938-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501134710.8938-1-sameehj@amazon.com>
References: <20190501134710.8938-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Adaptive interrupt moderation was erroneously enabled by default
in the driver.

In case the device supports adaptive interrupt moderation it will
be automatically used, which may potentially increase latency.

The adaptive moderation can be enabled from ethtool command in
case the feature is supported by the device.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Guy Tzalik <gtzalik@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 4fe437fe771b..677d31abf214 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2802,7 +2802,11 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 	/* if moderation is supported by device we set adaptive moderation */
 	delay_resolution = get_resp.u.intr_moderation.intr_delay_resolution;
 	ena_com_update_intr_delay_resolution(ena_dev, delay_resolution);
-	ena_com_enable_adaptive_moderation(ena_dev);
+
+	/* Disable adaptive moderation by default - can be enabled from
+	 * ethtool
+	 */
+	ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
 err:
-- 
2.17.1


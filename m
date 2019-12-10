Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAE611895D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLJNNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:13:08 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:45622 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfLJNNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575983587; x=1607519587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MEAT3hNa72Rku+n5BgNYhiLwovi4qo0Y+j2EMDgCXhM=;
  b=FfNOBgK5zNbSa/alI2SPkkZiXcArJHFminEb0hCl3Ig5UvN2spLhKCm/
   j+LGzWeSOXupSpgCud3xDC08SJcEVpfHEHUJkJmvVTatsC87P/RJWgDTr
   Z/0FvkpTOWToWricvDKuKyZd54FlCmC2L9Wjy5WlPm3u5nQT+eCIaoG0Q
   c=;
IronPort-SDR: ydWYYig49xTbc1eQSaGviV08f1KIebUHRNRhflU3bheLgBWlav9hwtqXb5fgZHi7cegeY2LIRV
 wk2bnf+8WKVg==
X-IronPort-AV: E=Sophos;i="5.69,299,1571702400"; 
   d="scan'208";a="6977715"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Dec 2019 13:13:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 0BCFFA20A7;
        Tue, 10 Dec 2019 13:13:04 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 13:12:44 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 13:12:44 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 13:12:40 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next v3 3/3] net: ena: Add first_interrupt field to napi struct
Date:   Tue, 10 Dec 2019 15:12:14 +0200
Message-ID: <20191210131214.3887-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210131214.3887-1-sameehj@amazon.com>
References: <20191210131214.3887-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The first_interrupt field is accessed in ena_intr_msix_io() upon
receiving an interrupt.The rx_ring and tx_ring fields of napi can
be NULL when receiving interrupt for xdp queues. This patch fixes
the issue by moving the field to the ena_napi struct.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 7 +++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 55eeaab79..d161537e2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -219,6 +219,7 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	int ret;
 
 	xdp_ring = ena_napi->xdp_ring;
+	xdp_ring->first_interrupt = ena_napi->first_interrupt;
 
 	xdp_budget = budget;
 
@@ -1869,6 +1870,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
+	tx_ring->first_interrupt = ena_napi->first_interrupt;
+	rx_ring->first_interrupt = ena_napi->first_interrupt;
+
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -1940,8 +1944,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 {
 	struct ena_napi *ena_napi = data;
 
-	ena_napi->tx_ring->first_interrupt = true;
-	ena_napi->rx_ring->first_interrupt = true;
+	ena_napi->first_interrupt = true;
 
 	napi_schedule_irqoff(&ena_napi->napi);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 9bfb275b2..094324fd0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -169,6 +169,7 @@ struct ena_napi {
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	struct ena_ring *xdp_ring;
+	bool first_interrupt;
 	u32 qid;
 	struct dim dim;
 };
-- 
2.17.1


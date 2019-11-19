Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6753102579
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfKSNfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:35:03 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49340 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfKSNfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574170503; x=1605706503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mhc5OofYTu/usEDwmE0G0JeX0vBMwlhoeIndrMFCONk=;
  b=BepJcri3IMfZ5RyOL04lAJHubHk6OhRhxier4Vz7Q526NSXVrsx1CFzd
   UF099QVaZWQnFiJkyHxPmAiHj/B+JDjZDxnrE33u/KUeUrfI4N7+OoKrS
   61uxE4nqUSHp3LBJORZg9jR32BmoQr00+pim4RuHX3AcLu9JyUzs4rDuH
   s=;
IronPort-SDR: WavDt2XRp9t3DlrkdByeqARMnNLkJOLhMpBt6m1D1TIDhBqPuLiMilWTkLAS1SDvLvGZ470nGJ
 RhZ1OF551SWQ==
X-IronPort-AV: E=Sophos;i="5.68,324,1569283200"; 
   d="scan'208";a="4720095"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Nov 2019 13:35:02 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 5EE52C0C02;
        Tue, 19 Nov 2019 13:35:01 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:41 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:41 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 13:34:39 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next v2 3/3] net: ena: Add first_interrupt field to napi struct
Date:   Tue, 19 Nov 2019 15:34:19 +0200
Message-ID: <20191119133419.9734-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119133419.9734-1-sameehj@amazon.com>
References: <20191119133419.9734-1-sameehj@amazon.com>
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
index 087f132e0..d000b13ba 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -219,6 +219,7 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	int ret;
 
 	xdp_ring = ena_napi->xdp_ring;
+	xdp_ring->first_interrupt = ena_napi->first_interrupt;
 
 	xdp_budget = budget;
 
@@ -1858,6 +1859,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
+	tx_ring->first_interrupt = ena_napi->first_interrupt;
+	rx_ring->first_interrupt = ena_napi->first_interrupt;
+
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -1929,8 +1933,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 {
 	struct ena_napi *ena_napi = data;
 
-	ena_napi->tx_ring->first_interrupt = true;
-	ena_napi->rx_ring->first_interrupt = true;
+	ena_napi->first_interrupt = true;
 
 	napi_schedule_irqoff(&ena_napi->napi);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 504aab9af..1e75cb3d9 100644
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


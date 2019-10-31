Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B45DEB4C8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfJaQgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:36:09 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:2789 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbfJaQgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572539768; x=1604075768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WCHjHhMWtmw3SUZ1ZeiWQ8q/m1l8Nzjm1mtSLYDIUos=;
  b=Nru4fAEkIQR8murRdFrea9cNfXB/BLZutvJiHxYJjexp7GCrNo8DuNdZ
   7bgCwN18eoYOgeR51ylWRz6gXJIhSG0BDNVG6BYIYjQND8vxIfxVXpI8E
   hb4gs8mYBSbu32JhrwCtxSBPAtghD23xNvYu2JdHov8+3d6CBFLjH5auc
   0=;
IronPort-SDR: 4qHy0wK9rca/k0EcpnRu83ey2mPrjyd1fIL4wg0AxcWhr7VhPLKgUACCIqoGaJfVMbmd9/hTd9
 Ad7mIvWfVe7g==
X-IronPort-AV: E=Sophos;i="5.68,252,1569283200"; 
   d="scan'208";a="1442691"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 31 Oct 2019 16:36:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id D0571A2B3D;
        Thu, 31 Oct 2019 16:36:05 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:54 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:54 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 31 Oct 2019 16:35:51 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V2 net-next v2 3/3] net: ena: Add first_interrupt field to napi struct
Date:   Thu, 31 Oct 2019 18:35:39 +0200
Message-ID: <20191031163539.12539-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191031163539.12539-1-sameehj@amazon.com>
References: <20191031163539.12539-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 ++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5a90163fa..97b333d07 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1809,6 +1809,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
+	tx_ring->first_interrupt = ena_napi->first_interrupt;
+	rx_ring->first_interrupt = ena_napi->first_interrupt;
+
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -1880,8 +1883,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 {
 	struct ena_napi *ena_napi = data;
 
-	ena_napi->tx_ring->first_interrupt = true;
-	ena_napi->rx_ring->first_interrupt = true;
+	ena_napi->first_interrupt = true;
 
 	napi_schedule_irqoff(&ena_napi->napi);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index cb0804947..c666a9cac 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -168,6 +168,7 @@ struct ena_napi {
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	struct ena_ring *xdp_ring;
+	bool first_interrupt;
 	u32 qid;
 	struct dim dim;
 };
-- 
2.17.1


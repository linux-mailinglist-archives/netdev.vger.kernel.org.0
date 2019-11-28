Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FBB10CC63
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfK1QC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:02:28 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:64197 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfK1QC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574956947; x=1606492947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nwvR+C4XfLhuNF3S4wOm3eRwGqam+kc91gpvitn3r2A=;
  b=Q98aOGfwCniwkoS0F0BDkOD54AhjaiwfsjfVZiaGOZyVWeTJV5WORmce
   zyzcTAF5UcZX1X6cypNcWCcFBj7OckfQQLj+smX4UFEEgu892BLFd4Y+G
   KaF7uigWT6Ow4hDOcAMt2zgL1pUvezFbafNDlQ2AHTkVaqTgNauYBA2Ph
   M=;
IronPort-SDR: Up4VijMSenHrNK5I6op+iEDyyYliejM1OD5lNroNBuTBULzSNGew6bdM4zBRtWUibhu0t4V2xH
 JWmRlD6wIQxg==
X-IronPort-AV: E=Sophos;i="5.69,253,1571702400"; 
   d="scan'208";a="6191877"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 28 Nov 2019 16:02:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 97101A228F;
        Thu, 28 Nov 2019 16:02:25 +0000 (UTC)
Received: from EX13D10UWB001.ant.amazon.com (10.43.161.111) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:02:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB001.ant.amazon.com (10.43.161.111) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:02:04 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 28 Nov 2019 16:02:00 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next v3 3/3] net: ena: Add first_interrupt field to napi struct
Date:   Thu, 28 Nov 2019 18:01:46 +0200
Message-ID: <20191128160146.16109-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128160146.16109-1-sameehj@amazon.com>
References: <20191128160146.16109-1-sameehj@amazon.com>
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
index ba24b6314..3955fe9af 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -221,6 +221,7 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	int ret;
 
 	xdp_ring = ena_napi->xdp_ring;
+	xdp_ring->first_interrupt = ena_napi->first_interrupt;
 
 	xdp_budget = budget;
 
@@ -1873,6 +1874,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring = ena_napi->tx_ring;
 	rx_ring = ena_napi->rx_ring;
 
+	tx_ring->first_interrupt = ena_napi->first_interrupt;
+	rx_ring->first_interrupt = ena_napi->first_interrupt;
+
 	tx_budget = tx_ring->ring_size / ENA_TX_POLL_BUDGET_DIVIDER;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags) ||
@@ -1944,8 +1948,7 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
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


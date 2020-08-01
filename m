Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA972352B3
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgHAOVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:21:37 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54587 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgHAOVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 10:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596291696; x=1627827696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=deCe5YIuZXagMqnZLZFLs//xbXAuKfQv3z+cKhjoVgQ=;
  b=r25WmkdqVZA8Cnlga7Uf88KAyGPJAFjcimxqQDo12VeMYMFxM0kONufo
   1scbZ014aX644W9FPnDUOEXwpwnjTyBBlquOXtByeS7r4kRw5XAT75ped
   Xy1jK7tK+nmGcBxGrJlxULsO/Kolezscl3vcP2o+c0WcnpziNRogwyoaD
   c=;
IronPort-SDR: 7Q7PC2Erd70U2aqdqiD6PTa7xTloSH0WbxMZxb7gOtwqJaK+jejYX0SXCOeYfC4HKEJ63Q1VfV
 9PkNJxuPflbQ==
X-IronPort-AV: E=Sophos;i="5.75,422,1589241600"; 
   d="scan'208";a="63479523"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 01 Aug 2020 14:21:35 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 93320A1E2F;
        Sat,  1 Aug 2020 14:21:33 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sat, 1 Aug 2020 14:21:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 574348C9C6; Sat,  1 Aug 2020 14:21:32 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net-next 3/3] net: ena: xdp: add queue counters for xdp actions
Date:   Sat, 1 Aug 2020 14:21:30 +0000
Message-ID: <20200801142130.6537-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200801142130.6537-1-sameehj@amazon.com>
References: <20200801142130.6537-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

When using XDP every ingress packet is passed to an eBPF (xdp) program
which returns an action for this packet.

This patch adds counters for the number of times each such action was
received. It also counts all the invalid actions received from the eBPF
program.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  5 +++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 27 +++++++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  5 +++++
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 1713abe79..b25114a21 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -116,6 +116,11 @@ static const struct ena_stats ena_stats_rx_strings[] = {
 	ENA_STAT_RX_ENTRY(bad_req_id),
 	ENA_STAT_RX_ENTRY(empty_rx_ring),
 	ENA_STAT_RX_ENTRY(csum_unchecked),
+	ENA_STAT_RX_ENTRY(xdp_aborted),
+	ENA_STAT_RX_ENTRY(xdp_drop),
+	ENA_STAT_RX_ENTRY(xdp_pass),
+	ENA_STAT_RX_ENTRY(xdp_tx),
+	ENA_STAT_RX_ENTRY(xdp_invalid),
 };
 
 static const struct ena_stats ena_stats_ena_com_strings[] = {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 01c195177..87265e3c5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -365,6 +365,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
 {
 	struct bpf_prog *xdp_prog;
 	u32 verdict = XDP_PASS;
+	u64 *xdp_stat;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
@@ -374,17 +375,31 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
 
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
-	if (verdict == XDP_TX)
+	if (verdict == XDP_TX) {
 		ena_xdp_xmit_buff(rx_ring->netdev,
-				  xdp,
-				  rx_ring->qid + rx_ring->adapter->num_io_queues,
-				  rx_info);
-	else if (unlikely(verdict == XDP_ABORTED))
+				xdp,
+				rx_ring->qid + rx_ring->adapter->num_io_queues,
+				rx_info);
+
+		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+	} else if (unlikely(verdict == XDP_ABORTED)) {
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
-	else if (unlikely(verdict > XDP_TX))
+		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+	} else if (unlikely(verdict == XDP_DROP)) {
+		xdp_stat = &rx_ring->rx_stats.xdp_drop;
+	} else if (unlikely(verdict == XDP_PASS)) {
+		xdp_stat = &rx_ring->rx_stats.xdp_pass;
+	} else {
 		bpf_warn_invalid_xdp_action(verdict);
+		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
+	}
+
+	u64_stats_update_begin(&rx_ring->syncp);
+	(*xdp_stat)++;
+	u64_stats_update_end(&rx_ring->syncp);
 out:
 	rcu_read_unlock();
+
 	return verdict;
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 4c95a4d93..52abb6a4f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -261,6 +261,11 @@ struct ena_stats_rx {
 	u64 bad_req_id;
 	u64 empty_rx_ring;
 	u64 csum_unchecked;
+	u64 xdp_aborted;
+	u64 xdp_drop;
+	u64 xdp_pass;
+	u64 xdp_tx;
+	u64 xdp_invalid;
 };
 
 struct ena_ring {
-- 
2.16.6


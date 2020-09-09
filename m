Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7938326274E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 08:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgIIGqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 02:46:34 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:47062 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIGqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 02:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599633993; x=1631169993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=vqxCvFFhjDKi/wBSn3KghTQK9dvRz1KBTV4MDBi2L/Q=;
  b=sHXWmYGfsYW0rvluOcINK48eMStbHrSK2Yf0Tmk3CyNcPkY7SdRNhQPZ
   MENsFZWWMGkjmYtHmmy1Y0oybYEHyNoSU9fDbX/cXqvEpyiSoIzvpEcfd
   v7G/TkL54+A5xdybR5ssZH+d80WN9M0qPnioiIbsJQSqubXkvIxIjHOCu
   U=;
X-IronPort-AV: E=Sophos;i="5.76,408,1592870400"; 
   d="scan'208";a="54287643"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Sep 2020 06:46:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 77289282066;
        Wed,  9 Sep 2020 06:46:30 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:29 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 9 Sep 2020 06:46:29 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 4F11081B42; Wed,  9 Sep 2020 06:46:29 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V3 net-next 4/4] net: ena: xdp: add queue counters for xdp actions
Date:   Wed, 9 Sep 2020 06:46:27 +0000
Message-ID: <20200909064627.30104-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200909064627.30104-1-sameehj@amazon.com>
References: <20200909064627.30104-1-sameehj@amazon.com>
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
index c4b35068f..9e2ab2a03 100644
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
index 08474db75..cedb41ead 100644
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


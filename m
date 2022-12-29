Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0714A6589F1
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiL2Hak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiL2Hah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:37 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213CB120AE
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299037; x=1703835037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jiWJidZUhkZLjb7RZcBmZ62FIYEb04zKtgoRT7SR41A=;
  b=UZ13DVEukqymmAOXvT+Mqd/C6nYPRNXcfR3QQGk9ji6kDOUNMZDnwvA2
   OzxJ86TnymrDNYVApKTBzePJzmdldkQBbjEwWlG7tuIjqJPyFnAHCKumR
   8H66Zfv9ip7JeXfHRSiJ202s+IIGOjGHOKiPsPOQQihqW6G2qhpy8Ahkx
   8=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="295143325"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id 181D382804;
        Thu, 29 Dec 2022 07:30:31 +0000 (UTC)
Received: from EX19D002UWC001.ant.amazon.com (10.13.138.148) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC001.ant.amazon.com (10.13.138.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:30 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:28
 +0000
From:   <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net 4/7] net: ena: Use bitmask to indicate packet redirection
Date:   Thu, 29 Dec 2022 07:30:08 +0000
Message-ID: <20221229073011.19687-5-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229073011.19687-1-darinzon@amazon.com>
References: <20221229073011.19687-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

Redirecting packets with XDP Redirect is done in two phases:
1. A packet is passed by the driver to the kernel using
   xdp_do_redirect().
2. After finishing polling for new packets the driver lets the kernel
   know that it can now process the redirected packet using
   xdp_do_flush_map().
   The packets' redirection is handled in the napi context of the
   queue that called xdp_do_redirect()

To avoid calling xdp_do_flush_map() each time the driver first checks
whether any packets were redirected, using
	xdp_flags |= xdp_verdict;
and
	if (xdp_flags & XDP_REDIRECT)
	    xdp_do_flush_map()

essentially treating XDP instructions as a bitmask, which isn't the case:
    enum xdp_action {
	    XDP_ABORTED = 0,
	    XDP_DROP,
	    XDP_PASS,
	    XDP_TX,
	    XDP_REDIRECT,
    };

Given the current possible values of xdp_action, the current design
doesn't have a bug (since XDP_REDIRECT = 100b), but it is still
flawed.

This patch makes the driver use a bitmask instead, to avoid future
issues.

Fixes: a318c70ad152 ("net: ena: introduce XDP redirect implementation")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 26 ++++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  9 +++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 9ae86bd3d457..a67f55e5f755 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -374,9 +374,9 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
+	u32 verdict = ENA_XDP_PASS;
 	struct bpf_prog *xdp_prog;
 	struct ena_ring *xdp_ring;
-	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
@@ -393,7 +393,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-			verdict = XDP_ABORTED;
+			verdict = ENA_XDP_DROP;
 			break;
 		}
 
@@ -409,29 +409,35 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 		spin_unlock(&xdp_ring->xdp_tx_lock);
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		verdict = ENA_XDP_TX;
 		break;
 	case XDP_REDIRECT:
 		if (likely(!xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog))) {
 			xdp_stat = &rx_ring->rx_stats.xdp_redirect;
+			verdict = ENA_XDP_REDIRECT;
 			break;
 		}
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-		verdict = XDP_ABORTED;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_DROP:
 		xdp_stat = &rx_ring->rx_stats.xdp_drop;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_PASS:
 		xdp_stat = &rx_ring->rx_stats.xdp_pass;
+		verdict = ENA_XDP_PASS;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
+		verdict = ENA_XDP_DROP;
 	}
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
@@ -1621,12 +1627,12 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	 * we expect, then we simply drop it
 	 */
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
-		return XDP_DROP;
+		return ENA_XDP_DROP;
 
 	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
-	if (ret == XDP_PASS) {
+	if (ret == ENA_XDP_PASS) {
 		rx_info->page_offset = xdp->data - xdp->data_hard_start;
 		rx_ring->ena_bufs[0].len = xdp->data_end - xdp->data;
 	}
@@ -1665,7 +1671,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
 
 	do {
-		xdp_verdict = XDP_PASS;
+		xdp_verdict = ENA_XDP_PASS;
 		skb = NULL;
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
@@ -1693,7 +1699,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
 
 		/* allocate skb and fill it */
-		if (xdp_verdict == XDP_PASS)
+		if (xdp_verdict == ENA_XDP_PASS)
 			skb = ena_rx_skb(rx_ring,
 					 rx_ring->ena_bufs,
 					 ena_rx_ctx.descs,
@@ -1711,13 +1717,13 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 				/* Packets was passed for transmission, unmap it
 				 * from RX side.
 				 */
-				if (xdp_verdict == XDP_TX || xdp_verdict == XDP_REDIRECT) {
+				if (xdp_verdict & ENA_XDP_FORWARDED) {
 					ena_unmap_rx_buff(rx_ring,
 							  &rx_ring->rx_buffer_info[req_id]);
 					rx_ring->rx_buffer_info[req_id].page = NULL;
 				}
 			}
-			if (xdp_verdict != XDP_PASS) {
+			if (xdp_verdict != ENA_XDP_PASS) {
 				xdp_flags |= xdp_verdict;
 				total_len += ena_rx_ctx.ena_bufs[0].len;
 				res_budget--;
@@ -1763,7 +1769,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_refill_rx_bufs(rx_ring, refill_required);
 	}
 
-	if (xdp_flags & XDP_REDIRECT)
+	if (xdp_flags & ENA_XDP_REDIRECT)
 		xdp_do_flush_map();
 
 	return work_done;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 1bdce99bf688..290ae9bf47ee 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -409,6 +409,15 @@ enum ena_xdp_errors_t {
 	ENA_XDP_NO_ENOUGH_QUEUES,
 };
 
+enum ENA_XDP_ACTIONS {
+	ENA_XDP_PASS		= 0,
+	ENA_XDP_TX		= BIT(0),
+	ENA_XDP_REDIRECT	= BIT(1),
+	ENA_XDP_DROP		= BIT(2)
+};
+
+#define ENA_XDP_FORWARDED (ENA_XDP_TX | ENA_XDP_REDIRECT)
+
 static inline bool ena_xdp_present(struct ena_adapter *adapter)
 {
 	return !!adapter->xdp_bpf_prog;
-- 
2.38.1


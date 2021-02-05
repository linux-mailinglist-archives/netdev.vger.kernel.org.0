Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90D931119B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhBESMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:12:01 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:6859 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhBESK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 13:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612554771; x=1644090771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=s0RVMC7moj7XAc9xY06hEmpqDNwhkg+vk88oaTh7fz4=;
  b=PW1yqyS0VRKOEd8mHzqod5b1jVaYu2h3nJ5UqMi3OaGr5zlhhCKGBNH7
   mXuhYC92nz4dfQwFFuzX9gDOqr6g1+nACY6dVZX4L31uVxjAoCdBkRMea
   bSQIrW48i1U/DIIF6j6yv5mtJ4eHlJ2bLvi6XX6+pIiYKK+gr2FyG3wbT
   w=;
X-IronPort-AV: E=Sophos;i="5.81,156,1610409600"; 
   d="scan'208";a="915967961"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 05 Feb 2021 19:52:01 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id DABA1A204C;
        Fri,  5 Feb 2021 19:51:59 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.244) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 5 Feb 2021 19:51:51 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH net V1 1/1] net: ena: Update XDP verdict upon failure
Date:   Fri, 5 Feb 2021 21:51:14 +0200
Message-ID: <20210205195114.10007-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205195114.10007-1-shayagr@amazon.com>
References: <20210205195114.10007-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verdict returned from ena_xdp_execute() is used to determine the
fate of the RX buffer's page. In case of XDP Redirect/TX error the
verdict should be set to XDP_ABORTED, otherwise the page won't be freed.

Fixes: a318c70ad152 ("net: ena: introduce XDP redirect implementation")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 06596fa1f..a0596c073 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -404,6 +404,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+			verdict = XDP_ABORTED;
 			break;
 		}
 
@@ -424,7 +425,10 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 			xdp_stat = &rx_ring->rx_stats.xdp_redirect;
 			break;
 		}
-		fallthrough;
+		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
+		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+		verdict = XDP_ABORTED;
+		break;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-- 
2.17.1


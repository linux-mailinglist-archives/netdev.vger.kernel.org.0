Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD5421CBE3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgGLWg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:28 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:32500 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593386; x=1626129386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=N7nICK7RQ4ZF6EkZCqxyyd5Tqn4vCMEg08dZm5sMI6g=;
  b=Jnty4RQZaxPUE/jbavv4jr6X9cUG83mK07vpoWPnSvs0QP94ARu82a9V
   q67s/GGOLNtNITw96U4pI6UH/capxltM3CMx7xeSYmnRdtl3jowVGVH41
   BHCF22PMei76LYF+ATFC/1WTxG+tZPiiQAdM43plpvKEVID2mqNzwC56y
   0=;
IronPort-SDR: 5LuhC4WQQwUfnRFay4LSfFhSBRPOuf/h9G8W9I+qL3+h8MxwdX4ku2Ixn4IWbqnmvkn/NSpPSg
 pUO+zANspMww==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="41374726"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 12 Jul 2020 22:36:25 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 8C3F4A0688;
        Sun, 12 Jul 2020 22:36:24 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:23 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:22 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:18 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of interrupt vector when busy-polling
Date:   Mon, 13 Jul 2020 01:36:05 +0300
Message-ID: <1594593371-14045-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

In napi busy-poll mode, the kernel invokes the napi handler of the
device repeatedly to poll the NIC's receive queues. This process
repeats until a timeout, specific for each connection, is up.
By polling packets in busy-poll mode the user may gain lower latency
and higher throughput (since the kernel no longer waits for interrupts
to poll the queues) in expense of CPU usage.

Upon completing a napi routine, the driver checks whether
the routine was called by an interrupt handler. If so, the driver
re-enables interrupts for the device. This is needed since an
interrupt routine invocation disables future invocations until
explicitly re-enabled.

The driver avoids re-enabling the interrupts if they were not disabled
in the first place (e.g. if driver in busy mode).
Originally, the driver checked whether interrupt re-enabling is needed
by reading the 'ena_napi->unmask_interrupt' variable. This atomic
variable was set upon interrupt and cleared after re-enabling it.

In the 4.10 Linux version, the 'napi_complete_done' call was changed
so that it returns 'false' when device should not re-enable
interrupts, and 'true' otherwise. The change includes reading the
"NAPIF_STATE_IN_BUSY_POLL" flag to check if the napi call is in
busy-poll mode, and if so, return 'false'.
The driver was changed to re-enable interrupts according to this
routine's return value.
The Linux community rejected the use of the
'ena_napi->unmaunmask_interrupt' variable to determine whether
unmasking is needed, and urged to use napi_napi_complete_done()
return value solely.
See https://lore.kernel.org/patchwork/patch/741149/ for more details

As explained, a busy-poll session exists for a specified timeout
value, after which it exits the busy-poll mode and re-enters it later.
This leads to many invocations of the napi handler where
napi_complete_done() false indicates that interrupts should be
re-enabled.
This creates a bug in which the interrupts are re-enabled
unnecessarily.
To reproduce this bug:
    1) echo 50 | sudo tee /proc/sys/net/core/busy_poll
    2) echo 50 | sudo tee /proc/sys/net/core/busy_read
    3) Add counters that check whether
    'ena_unmask_interrupt(tx_ring, rx_ring);'
    is called without disabling the interrupts in the first
    place (i.e. with calling the interrupt routine
    ena_intr_msix_io())

Steps 1+2 enable busy-poll as the default mode for new connections.

The busy poll routine rearms the interrupts after every session by
design, and so we need to add an extra check that the interrupts were
masked in the first place.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 7 ++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 91be3ffa1c5c..90c0fe15cd23 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1913,7 +1913,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 		/* Update numa and unmask the interrupt only when schedule
 		 * from the interrupt context (vs from sk_busy_loop)
 		 */
-		if (napi_complete_done(napi, rx_work_done)) {
+		if (napi_complete_done(napi, rx_work_done) &&
+		    READ_ONCE(ena_napi->interrupts_masked)) {
+			WRITE_ONCE(ena_napi->interrupts_masked, false);
 			/* We apply adaptive moderation on Rx path only.
 			 * Tx uses static interrupt moderation.
 			 */
@@ -1961,6 +1963,9 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 
 	ena_napi->first_interrupt = true;
 
+	WRITE_ONCE(ena_napi->interrupts_masked, true);
+	smp_wmb(); /* write interrupts_masked before calling napi */
+
 	napi_schedule_irqoff(&ena_napi->napi);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index ba030d260940..89304b403995 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -167,6 +167,7 @@ struct ena_napi {
 	struct ena_ring *rx_ring;
 	struct ena_ring *xdp_ring;
 	bool first_interrupt;
+	bool interrupts_masked;
 	u32 qid;
 	struct dim dim;
 };
-- 
2.23.1


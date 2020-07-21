Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B76228114
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGUNik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:38:40 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:60693 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgGUNij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338718; x=1626874718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=egBdsnHEraDan82CcwdhE/oaVE/pRMq2noZgJ89tJLY=;
  b=DD1989Lo5guiZEoZQWfQoDbmDqW3Q/Wotu8j7OCe3QQehYq63m8Wyg22
   g+nyzP1arHoVUr0JX1DG19GWI5y5VL4JlXH+g/xlwUnbpReT9SRib80Rx
   dNtAoOG+SzZVL4byNEefX1iXMtVFbiAlIDJHdmsZ3CbmBmIAICxIU5NEw
   0=;
IronPort-SDR: 6YG6uemkpRr8mar91GAhamdwCw6Htjbo4R1XIIX/DToZL/eEc7qaPxgaQAbE1CfdZy7zDFYjT1
 EHWm8m0NNGFw==
X-IronPort-AV: E=Sophos;i="5.75,378,1589241600"; 
   d="scan'208";a="61581847"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Jul 2020 13:38:36 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 046F1A2007;
        Tue, 21 Jul 2020 13:38:34 +0000 (UTC)
Received: from EX13D21UWA001.ant.amazon.com (10.43.160.154) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA001.ant.amazon.com (10.43.160.154) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:33 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:29 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V3 net-next 1/8] net: ena: avoid unnecessary rearming of interrupt vector when busy-polling
Date:   Tue, 21 Jul 2020 16:38:04 +0300
Message-ID: <1595338691-3130-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

For an overview of the race created by this patch goto synchronization
label.

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

synchronization:
This patch introduces a race between the interrupt handler
ena_intr_msix_io() and the napi routine ena_io_poll().
Some macros and instruction were added to prevent this race from leaving
the interrupts masked. The following specifies the different race
scenarios in this patch:

1) interrupt handler and napi routine run sequentially
    i) interrupt handler is called, sets 'interrupts_masked' flag and
	successfully schedules the napi handler via softirq.

    In this scenario the napi routine might not see the flag change
    for several reasons:
	a) The flag is stored in a register by the compiler. For this
	case the WRITE_ONCE macro which prevents this.
	b) The compiler might reorder the instruction. For this the
	smp_wmb() instruction was used which implies a compiler memory
	barrier.
	c) On archs with weak consistency model (like ARM64) the napi
	routine might be scheduled and start running before the flag
	STORE instruction is committed to cache/memory. To ensure this
	doesn't happen, the smp_wmb() instruction was added. It ensures
	that the flag set instruction is committed before scheduling
	napi.

    ii) compiler reorders the flag's value check in the 'if' with
    the flag set in the napi routine.

    This scenario is prevented by smp_rmb() call after the flag check.

2) interrupt handler and napi routine run in parallel (can happen when
busy poll routine invokes the napi handler)

    i) interrupt handler sets the flag in one core, while the napi
    routine reads it in another core.

    This scenario also is divided into two cases:
	a) napi_complete_done() doesn't finish running, in which case
	napi_sched() would just set NAPIF_STATE_MISSED and the napi
	routine would reschedule itself without changing the flag's value.

	b) napi_complete_done() finishes running. In this case the
	napi routine might override the flag's value.
	This doesn't present any rise since it later unmasks the
	interrupt vector.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3eb63b12dd68..e453542c9e94 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1913,7 +1913,10 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 		/* Update numa and unmask the interrupt only when schedule
 		 * from the interrupt context (vs from sk_busy_loop)
 		 */
-		if (napi_complete_done(napi, rx_work_done)) {
+		if (napi_complete_done(napi, rx_work_done) &&
+		    READ_ONCE(ena_napi->interrupts_masked)) {
+			smp_rmb(); /* make sure interrupts_masked is read */
+			WRITE_ONCE(ena_napi->interrupts_masked, false);
 			/* We apply adaptive moderation on Rx path only.
 			 * Tx uses static interrupt moderation.
 			 */
@@ -1961,6 +1964,9 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
 
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
2.23.3


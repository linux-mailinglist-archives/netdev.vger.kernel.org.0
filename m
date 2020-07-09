Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC0421A779
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGITFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:05:20 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50325 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321518; x=1625857518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=N7nICK7RQ4ZF6EkZCqxyyd5Tqn4vCMEg08dZm5sMI6g=;
  b=fy5Xe/veCN09oSPyFxgDbeJ5A4kigTVKzbEKlCro+zqQKMRfQY1daqlt
   k+cN2iaeS7v8nZcuu9aBn9UAJDjSmarHgjaSpjlccQpH+9kwKnGfmzWj+
   jbfzzlCiiqEGjJ3ZKfT3fauJh9BJKlUCvLoTlxqvZRoDV9nb2pRcN9WLm
   U=;
IronPort-SDR: BP56WI8SKw84PR7cViElOdeuxERSsuRUYt8DlI66vcCEDQVTrrXcE5QbtpWb+B7uVyekPPMQnK
 Jpnejvvu0ByQ==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="41136517"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Jul 2020 19:05:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 364A4A2323;
        Thu,  9 Jul 2020 19:05:16 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:16 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:11 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 1/8] net: ena: avoid unnecessary rearming of interrupt vector when busy-polling
Date:   Thu, 9 Jul 2020 22:04:56 +0300
Message-ID: <1594321503-12256-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
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


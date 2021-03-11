Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B833810A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCKXBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:01:15 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46547 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhCKXA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:00:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615503658; x=1647039658;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EelXUHyPTnNZzAoNgrkrCTVUBcXgQAjuKcfSXbijb4s=;
  b=cUVZC9CUwv9WkxjEtLrjwCp9UUbNZaLKuFE4m5UEaMHjaC5fwlHoIdDH
   dMqpLEZCifuDWCIFm+umLIx7ACtfuAYM7rRWpnKdeNeVYa82RSdK9HTjH
   jw1SiMFPRbI5cv0ORh+K5ManOsavsRZMxvD75S77JucO6F4ZP0u9w/nYE
   k=;
IronPort-HdrOrdr: A9a23:qg3et6sX97996S7pax9t1/hP7skDyNV00zAX/kB9WHVpW+az/v
 rAoN0w0xjohDENHEw6kdebN6WaBV/a/5h54Y4eVI3SOTXOkm2uMY1k8M/e0yTtcheOktJ1+K
 98f8FFaeHYIkN9ia/BjTWQN/YF7J25/LuzheHYpk0dLz1CT6179Q92BkK6PyRNJDVuPIE0Hp
 aQ6s1Mq1ObCA0qR/+2DHUEQOTPzuej/PmNXTc9GxUl5AOS5AnH1JfGFXGjsis2YndkxLcv9n
 X9iArp5qmvmOHT8G6760bjq7BfmN7s0bJ4da+xo/lQDC7thAaubJlgXLPHnAldmpDJ1GoX
X-IronPort-AV: E=Sophos;i="5.81,241,1610409600"; 
   d="scan'208";a="98053995"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Mar 2021 23:00:50 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 9067DC09A4;
        Thu, 11 Mar 2021 23:00:48 +0000 (UTC)
Received: from dev-dsk-andyhsu-1c-d6833dcf.eu-west-1.amazon.com (10.43.161.87)
 by EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 23:00:44 +0000
From:   ChiaHao Hsu <andyhsu@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     <wei.liu@kernel.org>, <paul@xen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andyhsu@amazon.com>,
        <xen-devel@lists.xenproject.org>
Subject: [net-next 2/2] xen-netback: add module parameter to disable dynamic multicast control
Date:   Thu, 11 Mar 2021 23:00:35 +0000
Message-ID: <20210311230035.24450-1-andyhsu@amazon.com>
X-Mailer: git-send-email 2.23.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.87]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support live migration of guests between kernels
that do and do not support 'feature-dynamic-multicast-control',
we add a module parameter that allows the feature to be disabled
at run time, instead of using hardcode value.
The default value is enable.

Signed-off-by: ChiaHao Hsu <andyhsu@amazon.com>
---
 drivers/net/xen-netback/common.h  |  1 +
 drivers/net/xen-netback/netback.c |  7 +++++++
 drivers/net/xen-netback/xenbus.c  | 14 ++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index bfb7a3054917..c166ebb5a81f 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -415,6 +415,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 irqreturn_t xenvif_interrupt(int irq, void *dev_id);
 
 extern bool control_ring;
+extern bool dynamic_multicast_control;
 extern bool separate_tx_rx_irq;
 extern bool provides_xdp_headroom;
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a119ae673862..d369428ea5bb 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -54,6 +54,13 @@
 bool control_ring = true;
 module_param(control_ring, bool, 0644);
 
+/* Provide an option to extend multicast control protocol. This allows
+ * request-multicast-control to be set by the frontend at any time,
+ * the backend will watch the value and re-sample on watch events.
+ */
+bool dynamic_multicast_control = true;
+module_param(dynamic_multicast_control, bool, 0644);
+
 /* Provide an option to disable split event channels at load time as
  * event channels are limited resource. Split event channels are
  * enabled by default.
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 9801b8d10239..a7f487289bec 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -1094,12 +1094,14 @@ static int netback_probe(struct xenbus_device *dev,
 			goto abort_transaction;
 		}
 
-		err = xenbus_printf(xbt, dev->nodename,
-				    "feature-dynamic-multicast-control",
-				    "%d", 1);
-		if (err) {
-			message = "writing feature-dynamic-multicast-control";
-			goto abort_transaction;
+		if (dynamic_multicast_control) {
+			err = xenbus_printf(xbt, dev->nodename,
+					    "feature-dynamic-multicast-control",
+					    "%d", 1);
+			if (err) {
+				message = "writing feature-dynamic-multicast-control";
+				goto abort_transaction;
+			}
 		}
 
 		err = xenbus_transaction_end(xbt, 0);
-- 
2.23.3


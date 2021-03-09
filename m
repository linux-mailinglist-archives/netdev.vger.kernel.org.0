Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D744A332CF0
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhCIRLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:11:25 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:5962 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhCIRLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615309863; x=1646845863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Br3wf+yV9cZZ1j437eog6xP25N5hhJkCIT2ZHqWR88=;
  b=fZRBjGBZeXikpDSzqN3vB6swtHLPgAACzRL7LZ4iRi9AAvv7vatycPeQ
   Bth7P3f+bOw3mUaoxG5v9sZyqRgN37HNBAQXma9ohItGc5sJuPl/ag251
   yLb+64YkGcJZIJEuWO9UBuB91/YCpdSAtr7EZzKnBQ530BesajPH0oLw0
   Y=;
X-IronPort-AV: E=Sophos;i="5.81,236,1610409600"; 
   d="scan'208";a="91423006"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Mar 2021 17:11:03 +0000
Received: from EX13D28EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id BA156A2B3C;
        Tue,  9 Mar 2021 17:11:01 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.161.244) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Mar 2021 17:10:53 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [RFC Patch v1 2/3] net: ena: update README file with a description about LPC
Date:   Tue, 9 Mar 2021 19:10:13 +0200
Message-ID: <20210309171014.2200020-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309171014.2200020-1-shayagr@amazon.com>
References: <20210309171014.2200020-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D10UWA001.ant.amazon.com (10.43.160.216) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description for local page cache system to the ENA driver readme
file.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 3561a8a29fd2..d3423a2f472c 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -222,6 +222,31 @@ If the frame length is larger than rx_copybreak, napi_get_frags()
 is used, otherwise netdev_alloc_skb_ip_align() is used, the buffer
 content is copied (by CPU) to the SKB, and the buffer is recycled.
 
+Local Page Cache (LPC)
+======================
+ENA Linux driver allows to reduce lock contention and improve CPU usage by
+allocating RX buffers from a page cache rather than from Linux memory system
+(PCP or buddy allocator). The cache is created and binded per RX queue, and
+pages allocated for the queue are stored in the cache (up to cache maximum
+size).
+
+When enabled, LPC cache size is ENA_LPC_DEFAULT_MULTIPLIER * 1024 (2048 by
+default) pages.
+
+The cache usage for each queue can be monitored using ``ethtool -S`` counters. Where:
+
+- *rx_queue#_lpc_warm_up* - number of pages that were allocated and stored in
+  the cache
+- *rx_queue#_lpc_full* - number of pages that were allocated without using the
+  cache because it didn't have free pages
+- *rx_queue#_lpc_wrong_numa* -  number of pages from the cache that belong to a
+  different NUMA node than the CPU which runs the NAPI routine. In this case,
+  the driver would try to allocate a new page from the same NUMA node instead
+
+LPC is disabled when using XDP or when using less than 16 queue pairs. Note that
+cache usage might increase the memory footprint of the driver (depending on the
+traffic).
+
 Statistics
 ==========
 The user can obtain ENA device and driver statistics using ethtool.
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6815C362991
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbhDPUnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:45469 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhDPUni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:38 -0400
IronPort-SDR: m5DBWogC98g28L5A+KKi2vybnJ5IMEDCHdP+UisDv7Budiq6/JuqNkcwqq5TKXVD4GLjVkBFaS
 8JcqTJUV+tRw==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234174"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234174"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:12 -0700
IronPort-SDR: xahCD5GDz+oXnzGCBEjg0bQdeX1Bn1WKAsxdneG6wJQEYNGzZypNgQsaIYX0ZnJl9oUOmS9KzA
 eczztBdsVksw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425602"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ederson de Souza <ederson.desouza@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/6] igb: Redistribute memory for transmit packet buffers when in Qav mode
Date:   Fri, 16 Apr 2021 13:44:55 -0700
Message-Id: <20210416204500.2012073-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ederson de Souza <ederson.desouza@intel.com>

i210 has a total of 24KB of transmit packet buffer. When in Qav mode,
this buffer is divided into four pieces, one for each Tx queue.
Currently, 8KB are given to each of the two SR queues and 4KB are given
to each of the two SP queues.

However, it was noticed that such distribution can make best effort
traffic (which would usually go to the SP queues when Qav is enabled, as
the SR queues would be used by ETF or CBS qdiscs for TSN-aware traffic)
perform poorly. Using iperf3 to measure, one could see the performance
of best effort traffic drop by nearly a third (from 935Mbps to 578Mbps),
with no TSN traffic competing.

This patch redistributes the 24KB to each queue equally: 6KB each. On
tests, there was no notable performance reduction of best effort traffic
performance when there was no TSN traffic competing.

Below, more details about the data collected:

All experiments were run using the following qdisc setup:

qdisc taprio 100: root refcnt 9 tc 4 map 3 3 3 2 3 0 0 3 3 3 3 3 3 3 3 3
    queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 1
    clockid TAI base-time 0 cycle-time 10000000 cycle-time-extension 0
    index 0 cmd S gatemask 0xf interval 10000000

qdisc etf 8045: parent 100:1 clockid TAI delta 1000000 offload on
    deadline_mode off skip_sock_check off

TSN traffic, when enabled, had this characteristics:
 Packet size: 1500 bytes
 Transmission interval: 125us

----------------------------------
Without this patch:
----------------------------------
- TCP data:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.35 GBytes   578 Mbits/sec    0

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.07 GBytes   460 Mbits/sec    1

- TCP data limiting iperf3 buffer size to 4K:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.35 GBytes   579 Mbits/sec    0

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.08 GBytes   462 Mbits/sec    0

- TCP data limiting iperf3 buffer size to 192 bytes (smallest size without
 serious performance degradation):
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.34 GBytes   577 Mbits/sec    0

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.07 GBytes   461 Mbits/sec    1

- UDP data at 1000Mbit/sec:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
        [  5]   0.00-20.00  sec  1.36 GBytes   586 Mbits/sec  0.000 ms  0/1011407 (0%)

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
        [  5]   0.00-20.00  sec  1.05 GBytes   451 Mbits/sec  0.000 ms  0/778672 (0%)

----------------------------------
With this patch:
----------------------------------

- TCP data:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  2.17 GBytes   932 Mbits/sec    0

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.50 GBytes   646 Mbits/sec    1

- TCP data limiting iperf3 buffer size to 4K:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  2.17 GBytes   931 Mbits/sec    0

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.50 GBytes   645 Mbits/sec    0

- TCP data limiting iperf3 buffer size to 192 bytes (smallest size without
 serious performance degradation):
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  2.17 GBytes   932 Mbits/sec    1

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Retr
        [  5]   0.00-20.00  sec  1.50 GBytes   645 Mbits/sec    0

- UDP data at 1000Mbit/sec:
    - No TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
        [  5]   0.00-20.00  sec  2.23 GBytes   956 Mbits/sec  0.000 ms  0/1650226 (0%)

    - With TSN traffic:
        [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
        [  5]   0.00-20.00  sec  1.51 GBytes   649 Mbits/sec  0.000 ms  0/1120264 (0%)

Signed-off-by: Ederson de Souza <ederson.desouza@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_defines.h | 8 ++++----
 drivers/net/ethernet/intel/igb/igb_main.c      | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index d2e2c50ce257..ca5429774994 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -340,10 +340,10 @@
 #define I210_RXPBSIZE_PB_32KB		0x00000020
 #define I210_TXPBSIZE_DEFAULT		0x04000014 /* TXPBSIZE default */
 #define I210_TXPBSIZE_MASK		0xC0FFFFFF
-#define I210_TXPBSIZE_PB0_8KB		(8 << 0)
-#define I210_TXPBSIZE_PB1_8KB		(8 << 6)
-#define I210_TXPBSIZE_PB2_4KB		(4 << 12)
-#define I210_TXPBSIZE_PB3_4KB		(4 << 18)
+#define I210_TXPBSIZE_PB0_6KB		(6 << 0)
+#define I210_TXPBSIZE_PB1_6KB		(6 << 6)
+#define I210_TXPBSIZE_PB2_6KB		(6 << 12)
+#define I210_TXPBSIZE_PB3_6KB		(6 << 18)
 
 #define I210_DTXMXPKTSZ_DEFAULT		0x00000098
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c9e8c65a3cfe..038a9fd1af44 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1921,8 +1921,8 @@ static void igb_setup_tx_mode(struct igb_adapter *adapter)
 		 */
 		val = rd32(E1000_TXPBS);
 		val &= ~I210_TXPBSIZE_MASK;
-		val |= I210_TXPBSIZE_PB0_8KB | I210_TXPBSIZE_PB1_8KB |
-			I210_TXPBSIZE_PB2_4KB | I210_TXPBSIZE_PB3_4KB;
+		val |= I210_TXPBSIZE_PB0_6KB | I210_TXPBSIZE_PB1_6KB |
+			I210_TXPBSIZE_PB2_6KB | I210_TXPBSIZE_PB3_6KB;
 		wr32(E1000_TXPBS, val);
 
 		val = rd32(E1000_RXPBS);
-- 
2.26.2


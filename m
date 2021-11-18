Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B324559C8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbhKRLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:15:18 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:37043 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343811AbhKRLNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:13:20 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 805AD92273F;
        Thu, 18 Nov 2021 11:02:12 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-99-57.trex.outbound.svc.cluster.local [100.96.99.57])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id C7983922724;
        Thu, 18 Nov 2021 11:02:10 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.99.57 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:12 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Blushing-Illegal: 4c0bfcba7972089e_1637233332123_3903458196
X-MC-Loop-Signature: 1637233332123:3542535461
X-MC-Ingress-Time: 1637233332123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vLso+6HFTsJzA2szGFiwzjSimGu3miLiZ/+p/yH7jrA=; b=YlLNkuqD6ROtgfJ4BQbmFIlKiK
        nAf0Slf02lz5UJTCVmdtXKIsNEyRIBjn/4HEuBcKSRKP+K3lDM+JXv9X5BlwMZhY7Gb3uK+QZX4T7
        6A2UnDy1ArbTspp6+rdYMreRro2vMguPn69AFuW6SKyqYh2HIG98MJeSQKjsuo3MtZtqr7pLqDf5z
        WSEYypQJc3gJK62NA5lm/Hh5gxfuFetloWgfj+AcVUcZ5DAOLZcHjM5zr+g7oqNJqLBQV3+mjnYS/
        jLNhqKoD/M3/slKKDeefExndcMqhxtDdsMZeguYI5HFOY1p7dbXpWVCa7ki5gZkNcWbVGCH5yU0H4
        4PehpiOA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBC-004NG9-Q4; Thu, 18 Nov 2021 11:02:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 0/6] lan78xx NAPI Performance Improvements
Date:   Thu, 18 Nov 2021 11:01:33 +0000
Message-Id: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a set of changes to the lan78xx driver
that were originally developed as part of an investigation into
the performance of TCP and UDP transfers on an Android system.
The changes increase the throughput of both UDP and TCP transfers
and reduce the overall CPU load.

These improvements are also seen on a standard Linux kernel. Typical
results are included at the end of this document.

The changes to the driver evolved over time. The patches presented
here attempt to organise the changes in to coherent blocks that
affect logically connected parts of the driver. The patches do not
reflect the way in which the code evolved during the performance
investigation.

Each patch produces a working driver that has an incremental
improvement but patches 2, 3 and 6 should be considered a single
update.

The changes affect the following parts of the driver:

1. Deferred URB processing

The deferred URB processing that was originally done by a tasklet
is now done by a NAPI polling routine. The NAPI cycle has a fixed
work budget that controls how many received frames are passed to
the network stack.

Patch 6 introduces the NAPI polling but depends on preceding patches.

The new NAPI polling routine is also responsible for submitting
Rx and Tx URBs to the USB host controller.

Moving the URB processing to a NAPI-based system "smoothed"
incoming and outgoing data flows on the Android system under
investigation. However, taken in isolation, moving from a tasklet
approach to a NAPI approach made little or no difference to the
overall performance.

2. URB buffer management

The driver creates a pool of Tx and a pool of Rx URB buffers. Each
buffer is large enough to accommodate a packet with the maximum MTU
data. URBs are allocated from these pools as required.

Patch 2 introduces the new Tx buffer pool.
Patch 3 introduces the new Rx buffer pool.

3. Tx pending data

SKBs containing data to be transmitted are added to a queue. The
driver tracks free Tx URBs and the corresponding free Tx URB space.
When new Tx URBs are submitted, pending data is copied into the
URB buffer until the URB buffer is filled or there is no more
pending data. This maximises utilisation the LAN78xx internal
USB and network frame buffers.

New Tx URBs are submitted to the USB host controller as part of the
NAPI polling cycle.

Patch 2 introduces these changes.

4. Rx URB completion

A new URB is no longer submitted as part of the URB completion
callback.
New URBs are submitted during the NAPI polling cycle.

Patch 3 introduces these changes.

5. Rx URB processing

Completed URBs are put on to queue for processing (as is done in the
current driver). Network packets in completed URBs are copied from
the URB buffer in to dynamically allocated SKBs and passed to
the network stack.

The emptied URBs are resubmitted to the USB host controller.

Patch 3 introduces this change. Patch 6 updates the change to use
NAPI SKBs.

Each packet passed to the network stack is a single NAPI work item.
If the NAPI work budget is exhausted the remaining packets in the
URB are put onto an overflow queue that is processed at the start
of the next NAPI cycle.

Patch 6 introduces this change.

6. Driver-specific hard_header_len

The driver-specific hard_header_len adjustment was removed as it
broke generic receive offload (GRO) processing. Moreover, it was no
longer required due the change in Tx pending data management (see
point 3. above).

Patch 5 introduces this change.

The modification has been tested on four different target machines:

Target           |    CPU     |   ARCH  | cores | kernel |  RAM  |
-----------------+------------+---------+-------+--------+-------|
Raspberry Pi 4B  | Cortex-A72 | aarch64 |   4   | 64-bit |  2 GB |
Nitrogen8M SBC   | Cortex-A53 | aarch64 |   4   | 64-bit |  2 GB |
Compaq Pressario | Pentium D  | i686    |   2   | 32-bit |  4 GB |
Dell T3620       | Core i3    | x86_64  |  2+2  | 64-bit | 16 GB |

The targets, apart from the Compaq, each have an on-chip USB3 host
controller. A PCIe-based USB3 host controller card was added to the
Compaq to provide the necessary USB3 host interface.

The network throughput was measured using iperf3. The peer device was
a second Dell T3620 fitted with an Intel i210 network interface. The
target machine and the peer device were connected via a Netgear GS105
gigabit switch.

The CPU load was measured using mpstat running on the target machine.

The tables below summarise the throughput and CPU load improvements
achieved by the updated driver.

The bandwidth is the average bandwidth reported by iperf3 at the end
of a 60-second test.

The percentage idle figure is the average idle reported across all
CPU cores on the target machine for the duration of the test.

TCP Rx (target receiving, peer transmitting)

                 |   Standard Driver  |   NAPI Driver      |
Target           | Bandwidth | % Idle | Bandwidth | % Idle |
-----------------+-----------+--------+--------------------|
RPi4 Model B     |    941    |  74.9  |    941    |  91.5  |
Nitrogen8M       |    941    |  76.2  |    941    |  92.7  |
Compaq Pressario |    941    |  44.5  |    941    |  82.1  |
Dell T3620       |    941    |  88.9  |    941    |  98.3  |

TCP Tx (target transmitting, peer receiving)

                 |   Standard Driver  |   NAPI Driver      |
Target           | Bandwidth | % Idle | Bandwidth | % Idle |
-----------------+-----------+--------+--------------------|
RPi4 Model B     |    683    |  80.1  |    942    |  97.6  |
Nitrogen8M       |    942    |  97.8  |    942    |  97.3  |
Compaq Pressario |    939    |  80.0  |    942    |  91.2  |
Dell T3620       |    942    |  95.3  |    942    |  97.6  |

UDP Rx (target receiving, peer transmitting)

                 |   Standard Driver  |   NAPI Driver      |
Target           | Bandwidth | % Idle | Bandwidth | % Idle |
-----------------+-----------+--------+--------------------|
RPi4 Model B     |     -     |    -   | 958 (0%)  |  76.2  |
Nitrogen8M       | 690 (25%) |  57.7  | 937 (0%)  |  68.5  |
Compaq Pressario | 958 (0%)  |  50.2  | 958 (0%)  |  61.6  |
Dell T3620       | 958 (0%)  |  89.6  | 958 (0%)  |  85.3  |

The figure in brackets is the percentage packet loss.

UDP Tx (target transmitting, peer receiving)

                 |   Standard Driver  |   NAPI Driver      |
Target           | Bandwidth | % Idle | Bandwidth | % Idle |
-----------------+-----------+--------+--------------------|
RPi4 Model B     |    370    |  75.0  |    886    |  78.9  |
Nitrogen8M       |    710    |  75.0  |    958    |  85.3  |
Compaq Pressario |    958    |  65.5  |    958    |  76.6  |
Dell T3620       |    958    |  97.0  |    958    |  97.3  |


John Efstathiades (6):
  lan78xx: Fix memory allocation bug
  lan78xx: Introduce Tx URB processing improvements
  lan78xx: Introduce Rx URB processing improvements
  lan78xx: Re-order rx_submit() to remove forward declaration
  lan78xx: Remove hardware-specific header update
  lan78xx: Introduce NAPI polling support

 drivers/net/usb/lan78xx.c | 1211 +++++++++++++++++++++++--------------
 1 file changed, 769 insertions(+), 442 deletions(-)

-- 
2.25.1


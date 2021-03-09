Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B90332CE9
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCIRKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:10:52 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:43021 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhCIRKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615309844; x=1646845844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=haFn1f73pgKjgHf3KT43PZsgHzOafDlPYA0vouf0DHE=;
  b=jn5we219npz3hAgdQa/dYpvYjj1F1X+jakYzqtr2YZYtydzsVmZgcdm/
   qf+nOE0EACJcZ1tam8qEof581vn/UJ9IQ5jjkE2AfY+sy9VsdIof3HEMh
   jov01VVZ2wqYAas9BneOqA4QLjvXELmoFLO2E7zBO7xlCFlimgGrRnhjx
   w=;
X-IronPort-AV: E=Sophos;i="5.81,236,1610409600"; 
   d="scan'208";a="119336534"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 09 Mar 2021 17:10:43 +0000
Received: from EX13D28EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id E53D3C0148;
        Tue,  9 Mar 2021 17:10:41 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.161.244) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Mar 2021 17:10:33 +0000
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
Subject: [RFC Patch v1 0/3] Introduce ENA local page cache
Date:   Tue, 9 Mar 2021 19:10:11 +0200
Message-ID: <20210309171014.2200020-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D10UWA001.ant.amazon.com (10.43.160.216) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

High incoming pps rate leads to frequent memory allocations by the napi
routine to refill the pages of the incoming packets.

On several new instances in AWS fleet, with high pps rates, these
frequent allocations create a contention between the different napi
routines.
The contention happens because the routines end up accessing the
buddy allocator which is a shared resource and requires lock-based
synchronization (also, when freeing a page the same lock is held). In
our tests we observed that that this contention causes the CPUs that
serve the RX queues to reach 100% and damage network performance.
While this contention can be relieved by making sure that pages are
allocated and freed on the same core, which would allow the driver to
take advantage of PCP, this solution is not always available or easy to
maintain.

This patchset implements a page cache local to each RX queue. When the
napi routine allocates a page, it first checks whether the cache has a
previously allocated page that isn't used. If so, this page is fetched
instead of allocating a new one. Otherwise, if the cache is out of free
pages, a page is allocated using normal allocation path (PCP or buddy
allocator) and returned to the caller.
A page that is allocated outside the cache, is afterwards cached, up
to cache's maximum size (set to 2048 pages in this patchset).

The pages' availability is tracked by checking their refcount. A cached
page has a refcount of 2 when it is passed to the napi routine as an RX
buffer. When a refcount of a page reaches 1, the cache assumes that it is
free to be re-used.

To avoid traversing all pages in the cache when looking for an available
page, we only check the availability of the first page fetched for the
RX queue that wasn't returned to the cache yet (i.e. has a refcount of
more than 1).

For example, for a cache of size 8 from which pages at indices 0-7 were
fetched (and placed in the RX SQ), the next time napi would try to fetch
a page from the cache, the cache would check the availability of the
page at index 0, and if it is available, this page would be fetched for
the napi. The next time napi would try to fetch a page, the cache entry
at index 1 would be checked, and so on.

Memory consumption:

In its maximum occupancy the cache would hold 2048 pages per each
queue. Providing an interface with 32 queues, 32 * 2048 * 4K = 64MB
are being used by the driver for its RX queues.

To avoid choking the system, this feature is only enabled for
instances with more than 16 queues which in AWS come with several tens
Gigs of RAM. Moreover, the feature can be turned off completely using
ethtool.

Having said that, the memory cost of having RX queues with 2K entries
would be the same as with 1K entries queue + LPC in worst case, while
the latter allocates the memory only in case the traffic rate is higher
than the rate of the pages being freed.

Performance results:

4 c5n.18xlarge instances sending iperf TCP traffic to a p4d.24xlarge instance.
Packet size: 1500 bytes

c5n.18xlarge specs:
Intel(R) Xeon(R) Platinum 8124M CPU @ 3.00GHz
with 72 cores. 32 queue pairs.

p4d.24xlarge specs:
Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz
with 96 cores. 4 * 32 = 128 (4 interfaces) queue pairs.

|                     | before | after |
|                     +        +       |
| bandwidth (Gbps)    | 260    | 330   |
| CPU utilization (%) | 100    | 56    |

Shay Agroskin (3):
  net: ena: implement local page cache (LPC) system
  net: ena: update README file with a description about LPC
  net: ena: support ethtool priv-flags and LPC state change

 .../device_drivers/ethernet/amazon/ena.rst    |  28 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  56 ++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 369 +++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  32 ++
 4 files changed, 458 insertions(+), 27 deletions(-)

-- 
2.25.1


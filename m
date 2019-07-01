Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA12130F08
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfEaNkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaNkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 09:40:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5ABA59451;
        Fri, 31 May 2019 13:40:01 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-15.ams2.redhat.com [10.36.117.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 498EE5D719;
        Fri, 31 May 2019 13:39:55 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 0/5] vsock/virtio: optimizations to increase the throughput
Date:   Fri, 31 May 2019 15:39:49 +0200
Message-Id: <20190531133954.122567-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 31 May 2019 13:40:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series tries to increase the throughput of virtio-vsock with slight
changes.
While I was testing the v2 of this series I discovered an huge use of memory,
so I added patch 1 to mitigate this issue. I put it in this series in order
to better track the performance trends.

v3:
- Patch 1: added a threshold to copy only small packets [Jason]

- Patch 1: replaced the allocation of a new buffer with a copy of small packets
           into the buffer of last packed queued. [Jason, Stefan]

- Removed 3 patches from the series:
  - "[PATCH v2 2/8] vsock/virtio: free packets during the socket release"
    Sent as a separate patch. It is already upstream.

  - "[PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB" and
    "[PATCH v2 8/8] vsock/virtio: make the RX buffer size tunable"
    As Jason suggested, we can do the 64KB buffer in the future with the
    conversion of using skb.

- Patches 2, 3, 4, 5 are the same of v2 (change only the index since 2/8 was
  sent as a separated patch)

v2: https://patchwork.kernel.org/cover/10938743

v1: https://patchwork.kernel.org/cover/10885431

Below are the benchmarks step by step. I used iperf3 [1] modified with VSOCK
support. As Micheal suggested in the v1, I booted host and guest with 'nosmap'.
I added two new rows with 32 and 128 bytes, to test small packets.

A brief description of patches:
- Patches 1: limit the memory usage with an extra copy for small packets
- Patches 2+3: fix locking and reduce the number of credit update messages
               sent to the transmitter
- Patches 4+5: allow the host to split packets on multiple buffers and use
               VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max packet size allowed

                    host -> guest [Gbps]
pkt_size before opt   p 1     p 2+3    p 4+5

32         0.035     0.032    0.049    0.051
64         0.069     0.061    0.123    0.126
128        0.138     0.116    0.256    0.252
256        0.247     0.254    0.434    0.444
512        0.498     0.482    0.940    0.931
1K         0.951     0.975    1.878    1.887
2K         1.882     1.872    3.735    3.720
4K         3.603     3.583    6.843    6.842
8K         5.881     5.761   11.841   12.057
16K        8.414     8.352   17.163   17.456
32K       14.020    13.926   19.156   20.883
64K       21.147    20.921   20.601   21.799
128K      21.098    21.027   21.145   23.596
256K      21.617    21.354   21.123   23.464
512K      20.967    21.056   21.236   23.775

                    guest -> host [Gbps]
pkt_size before opt   p 1     p 2+3    p 4+5

32         0.044     0.043    0.059    0.058
64         0.090     0.086    0.110    0.109
128        0.176     0.166    0.217    0.219
256        0.342     0.335    0.431    0.435
512        0.674     0.664    0.843    0.883
1K         1.336     1.315    1.672    1.648
2K         2.613     2.615    3.163    3.173
4K         5.162     5.128    5.638    5.873
8K         8.479     8.913   10.787   10.236
16K       11.617    12.027   12.871   15.840
32K       11.234    11.074   11.643   24.385
64K       10.252    10.655   11.223   37.201
128K      10.101    10.219   10.346   39.340
256K       9.403     9.820   10.040   34.888
512K       8.822     9.911   10.410   34.562

As Stefan suggested in the v1, I measured also the efficiency in this way:
    efficiency = Mbps / (%CPU_Host + %CPU_Guest)

The '%CPU_Guest' is taken inside the VM. I know that it is not the best way,
but it's provided for free from iperf3 and could be an indication.

        host -> guest efficiency [Mbps / (%CPU_Host + %CPU_Guest)]
pkt_size before opt   p 1     p 2+3    p 4+5

32          0.42      0.54     0.92     2.10
64          0.62      0.83     3.55     3.90
128         1.24      1.59     4.30     4.22
256         2.25      2.32     5.81     5.97
512         4.51      4.45    12.04    11.94
1K          8.70      8.93    23.10    23.33
2K         17.24     17.30    44.52    44.13
4K         33.01     32.97    82.45    81.65
8K         57.57     56.57   147.46   157.81
16K        82.36     81.97   214.60   253.35
32K       153.00    151.78   278.84   367.66
64K       236.54    246.02   301.18   454.15
128K      327.02    328.36   331.43   505.09
256K      336.23    331.09   330.05   515.09
512K      323.10    322.61   327.21   513.90

        guest -> host efficiency [Mbps / (%CPU_Host + %CPU_Guest)]
pkt_size before opt   p 1     p 2+3     p 4+5

32          0.42      0.42     0.60     0.606
64          0.86      0.84     1.20     1.187
128         1.69      1.64     2.38     2.393
256         3.31      3.31     4.67     4.723
512         6.50      6.56     9.19     9.454
1K         12.90     12.89    18.04    17.778
2K         25.45     25.92    34.31    34.028
4K         51.13     50.59    62.64    64.609
8K         95.81    100.98   112.95   113.105
16K       139.85    142.83   142.54   181.651
32K       147.43    146.66   146.86   286.545
64K       141.64    145.75   140.82   432.570
128K      148.30    148.87   143.89   490.037
256K      148.90    152.77   149.37   528.606
512K      140.68    153.65   152.64   516.622

[1] https://github.com/stefano-garzarella/iperf/

Stefano Garzarella (5):
  vsock/virtio: limit the memory used per-socket
  vsock/virtio: fix locking for fwd_cnt and buf_alloc
  vsock/virtio: reduce credit update messages
  vhost/vsock: split packets to send using multiple buffers
  vsock/virtio: change the maximum packet size allowed

 drivers/vhost/vsock.c                   |  53 ++++++++++---
 include/linux/virtio_vsock.h            |   4 +-
 net/vmw_vsock/virtio_transport.c        |   1 +
 net/vmw_vsock/virtio_transport_common.c | 101 +++++++++++++++++++-----
 4 files changed, 128 insertions(+), 31 deletions(-)

-- 
2.20.1


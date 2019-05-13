Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF31B2EC
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfEMJdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEMJdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:33:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 727AD3082B44;
        Mon, 13 May 2019 09:33:49 +0000 (UTC)
Received: from [10.72.12.49] (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258576B8D7;
        Mon, 13 May 2019 09:33:41 +0000 (UTC)
Subject: Re: [PATCH v2 0/8] vsock/virtio: optimizations to increase the
 throughput
To:     Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <08c7e0aa-d90d-e0ff-a68c-0e182d077ab2@redhat.com>
Date:   Mon, 13 May 2019 17:33:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510125843.95587-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 13 May 2019 09:33:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> While I was testing this new series (v2) I discovered an huge use of memory
> and a memory leak in the virtio-vsock driver in the guest when I sent
> 1-byte packets to the guest.
>
> These issues are present since the introduction of the virtio-vsock
> driver. I added the patches 1 and 2 to fix them in this series in order
> to better track the performance trends.
>
> v1: https://patchwork.kernel.org/cover/10885431/
>
> v2:
> - Add patch 1 to limit the memory usage
> - Add patch 2 to avoid memory leak during the socket release
> - Add patch 3 to fix locking of fwd_cnt and buf_alloc
> - Patch 4: fix 'free_space' type (u32 instead of s64) [Stefan]
> - Patch 5: Avoid integer underflow of iov_len [Stefan]
> - Patch 5: Fix packet capture in order to see the exact packets that are
>             delivered. [Stefan]
> - Add patch 8 to make the RX buffer size tunable [Stefan]
>
> Below are the benchmarks step by step. I used iperf3 [1] modified with VSOCK
> support.
> As Micheal suggested in the v1, I booted host and guest with 'nosmap', and I
> added a column with virtio-net+vhost-net performance.
>
> A brief description of patches:
> - Patches 1+2: limit the memory usage with an extra copy and avoid memory leak
> - Patches 3+4: fix locking and reduce the number of credit update messages sent
>                 to the transmitter
> - Patches 5+6: allow the host to split packets on multiple buffers and use
>                 VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max packet size allowed
> - Patches 7+8: increase RX buffer size to 64 KiB
>
>                      host -> guest [Gbps]
> pkt_size before opt  p 1+2    p 3+4    p 5+6    p 7+8       virtio-net + vhost
>                                                                       TCP_NODELAY
> 64         0.068     0.063    0.130    0.131    0.128         0.188     0.187
> 256        0.274     0.236    0.392    0.338    0.282         0.749     0.654
> 512        0.531     0.457    0.862    0.725    0.602         1.419     1.414
> 1K         0.954     0.827    1.591    1.598    1.548         2.599     2.640
> 2K         1.783     1.543    3.731    3.637    3.469         4.530     4.754
> 4K         3.332     3.436    7.164    7.124    6.494         7.738     7.696
> 8K         5.792     5.530   11.653   11.787   11.444        12.307    11.850
> 16K        8.405     8.462   16.372   16.855   17.562        16.936    16.954
> 32K       14.208    13.669   18.945   20.009   23.128        21.980    23.015
> 64K       21.082    18.893   20.266   20.903   30.622        27.290    27.383
> 128K      20.696    20.148   20.112   21.746   32.152        30.446    30.990
> 256K      20.801    20.589   20.725   22.685   34.721        33.151    32.745
> 512K      21.220    20.465   20.432   22.106   34.496        36.847    31.096
>
>                      guest -> host [Gbps]
> pkt_size before opt  p 1+2    p 3+4    p 5+6    p 7+8       virtio-net + vhost
>                                                                       TCP_NODELAY
> 64         0.089     0.091    0.120    0.115    0.117         0.274     0.272
> 256        0.352     0.354    0.452    0.445    0.451         1.085     1.136
> 512        0.705     0.704    0.893    0.858    0.898         2.131     1.882
> 1K         1.394     1.433    1.721    1.669    1.691         3.984     3.576
> 2K         2.818     2.874    3.316    3.249    3.303         6.719     6.359
> 4K         5.293     5.397    6.129    5.933    6.082        10.105     9.860
> 8K         8.890     9.151   10.990   10.545   10.519        15.239    14.868
> 16K       11.444    11.018   12.074   15.255   15.577        20.551    20.848
> 32K       11.229    10.875   10.857   24.401   25.227        26.294    26.380
> 64K       10.832    10.545   10.816   39.487   39.616        34.996    32.041
> 128K      10.435    10.241   10.500   39.813   40.012        38.379    35.055
> 256K      10.263     9.866    9.845   34.971   35.143        36.559    37.232
> 512K      10.224    10.060   10.092   35.469   34.627        34.963    33.401
>
> As Stefan suggested in the v1, this time I measured also the efficiency in this
> way:
>      efficiency = Mbps / (%CPU_Host + %CPU_Guest)
>
> The '%CPU_Guest' is taken inside the VM. I know that it is not the best way,
> but it's provided for free from iperf3 and could be an indication.
>
>          host -> guest efficiency [Mbps / (%CPU_Host + %CPU_Guest)]
> pkt_size before opt  p 1+2    p 3+4    p 5+6    p 7+8       virtio-net + vhost
>                                                                       TCP_NODELAY
> 64          0.94      0.59     3.96     4.06     4.09          2.82      2.11
> 256         2.62      2.50     6.45     6.09     5.81          9.64      8.73
> 512         5.16      4.87    13.16    12.39    11.67         17.83     17.76
> 1K          9.16      8.85    24.98    24.97    25.01         32.57     32.04
> 2K         17.41     17.03    49.09    48.59    49.22         55.31     57.14
> 4K         32.99     33.62    90.80    90.98    91.72         91.79     91.40
> 8K         58.51     59.98   153.53   170.83   167.31        137.51    132.85
> 16K        89.32     95.29   216.98   264.18   260.95        176.05    176.05
> 32K       152.94    167.10   285.75   387.02   360.81        215.49    226.30
> 64K       250.38    307.20   317.65   489.53   472.70        238.97    244.27
> 128K      327.99    335.24   335.76   523.71   486.41        253.29    260.86
> 256K      327.06    334.24   338.64   533.76   509.85        267.78    266.22
> 512K      337.36    330.61   334.95   512.90   496.35        280.42    241.43
>
>          guest -> host efficiency [Mbps / (%CPU_Host + %CPU_Guest)]
> pkt_size before opt  p 1+2    p 3+4    p 5+6    p 7+8       virtio-net + vhost
>                                                                       TCP_NODELAY
> 64          0.90      0.91     1.37     1.32     1.35          2.15      2.13
> 256         3.59      3.55     5.23     5.19     5.29          8.50      8.89
> 512         7.19      7.08    10.21     9.95    10.38         16.74     14.71
> 1K         14.15     14.34    19.85    19.06    19.33         31.44     28.11
> 2K         28.44     29.09    37.78    37.18    37.49         53.07     50.63
> 4K         55.37     57.60    71.02    69.27    70.97         81.56     79.32
> 8K        105.58    100.45   111.95   124.68   123.61        120.85    118.66
> 16K       141.63    138.24   137.67   187.41   190.20        160.43    163.00
> 32K       147.56    143.09   138.48   296.41   301.04        214.64    223.94
> 64K       144.81    143.27   138.49   433.98   462.26        298.86    269.71
> 128K      150.14    147.99   146.85   511.36   514.29        350.17    298.09
> 256K      156.69    152.25   148.69   542.19   549.97        326.42    333.32
> 512K      157.29    153.35   152.22   546.52   533.24        315.55    302.27
>
> [1] https://github.com/stefano-garzarella/iperf/


Hi:

Do you have any explanation that vsock is better here? Is this because 
of the mergeable buffer? If you, we need test with mrg_rxbuf=off.

Thanks


>
> Stefano Garzarella (8):
>    vsock/virtio: limit the memory used per-socket
>    vsock/virtio: free packets during the socket release
>    vsock/virtio: fix locking for fwd_cnt and buf_alloc
>    vsock/virtio: reduce credit update messages
>    vhost/vsock: split packets to send using multiple buffers
>    vsock/virtio: change the maximum packet size allowed
>    vsock/virtio: increase RX buffer size to 64 KiB
>    vsock/virtio: make the RX buffer size tunable
>
>   drivers/vhost/vsock.c                   |  53 +++++++--
>   include/linux/virtio_vsock.h            |  14 ++-
>   net/vmw_vsock/virtio_transport.c        |  28 ++++-
>   net/vmw_vsock/virtio_transport_common.c | 144 ++++++++++++++++++------
>   4 files changed, 190 insertions(+), 49 deletions(-)
>

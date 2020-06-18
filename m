Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166441FF8DB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgFRQKY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57928 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731919AbgFRQJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:59 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9lEL004749
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:57 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q653mse9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:57 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:41 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 29E483D44E12F; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 00/21] netgpu: networking between NIC and GPU/CPU.
Date:   Thu, 18 Jun 2020 09:09:20 -0700
Message-ID: <20200618160941.879717-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=903 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a working RFC proof-of-concept that implements DMA
zero-copy between the NIC and a GPU device for the data path, while
keeping the protocol processing on the host CPU.

This also works for zero-copy send/recv to host (CPU) memory.

Current limitations:
  - mlx5 only, header splitting is at a fixed offset.
  - currently only TCP protocol delivery is performed.
  - not optimized (hey, it works!)
  - TX completion notification is planned, but not in this patchset.
  - one socket per device
  - not compatible with xsk (re-uses same datastructures)
  - not compatible with bpf payload inspection
  - x86 !iommu only; liberties are taken with PA addresses.

The next section provides a brief overview of how things work, for this
phase 0 proof of concept.

A transport context is created on a device, which sets up the datapath,
and the device queues.  Only specialized RX queues are needed, the
standard TX queues are used for packet transmission.

Memory areas which participate in zero-copy transmission are registered
with the context.  These areas can be used as either RX packet buffers
or TX data areas (or both).  The memory can come from either malloc/mmap
or cudaMalloc().  The latter call provides a handle to the userspace
application, but the memory region is only accessible to the GPU.

A socket is created and registered with the context, which sets
SOCK_ZEROCOPY, and is bound to the device with SO_BINDTODEVICE.

Asymmetrical data paths are possible (zc TX, normal RX), and vice versa,
but the curreent PoC sets things up for symmetrical transport.  The
application needs to provide the RX buffers to the receive queue,
similar to AF_XDP.

Once things are set up, data is sent to the network with sendmsg().  The
iovecs provided contain an address in the region previously registered.
The normal protocol stack processing constructs the packet, but the data
is not touched by the stack.  In this phase, the application is not
notified when the protocol processing is complete and the data area is
safe to modify again.

For RX, packets undergo the usual protocol processing and are delivered
up to the socket receive queue.  At this point, the skb data fragments
are delivered to the application as iovecs through an AF_XDP style
queue.  The application can poll for readability, but does not use
read() to receive the data.

The initial application used is iperf3, a modified version with the
userspace library is available at:
    https://github.com/jlemon/iperf
    https://github.com/jlemon/netgpu

Running "iperf3 -s -z --dport 8888" (host memory) on a 12Gbps link:
    11.3 Gbit/sec receive
    10.8 Gbit/sec tramsmit

Running "iperf3 -s -z --dport 8888 --gpu" on a 25Gbps link:
    22.5 Gbit/sec receive
    12.6 Gbit/sec transmit  (!!!)

For the GPU runs, the Intel PCI monitoring tools were used to confirm
that the host PCI bus was mostly idle.  The TX performance needs further
investigation.

Comments welcome.  The next phase of the work will clean up the
interface, adding completion notifications, and a flexible queue
creation mechanism.
--
Jonathan


Jonathan Lemon (21):
  mm: add {add|release}_memory_pages
  mm: Allow DMA mapping of pages which are not online
  tcp: Pad TCP options out to a fixed size
  mlx5: add definitions for header split and netgpu
  mlx5/xsk: check that xsk does not conflict with netgpu
  mlx5: add header_split flag
  mlx5: remove the umem parameter from mlx5e_open_channel
  misc: add shqueue.h for prototyping
  include: add definitions for netgpu
  mlx5: add netgpu queue functions
  skbuff: add a zc_netgpu bitflag
  mlx5: hook up the netgpu channel functions
  netdevice: add SETUP_NETGPU to the netdev_bpf structure
  kernel: export free_uid
  netgpu: add network/gpu dma module
  lib: have __zerocopy_sg_from_iter get netgpu pages for a sk
  net/core: add the SO_REGISTER_DMA socket option
  tcp: add MSG_NETDMA flag for sendmsg()
  core: add page recycling logic for netgpu pages
  core/skbuff: use skb_zdata for testing whether skb is zerocopy
  mlx5: add XDP_SETUP_NETGPU hook

 drivers/misc/Kconfig                          |    1 +
 drivers/misc/Makefile                         |    1 +
 drivers/misc/netgpu/Kconfig                   |   10 +
 drivers/misc/netgpu/Makefile                  |   11 +
 drivers/misc/netgpu/nvidia.c                  | 1516 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   22 +-
 .../mellanox/mlx5/core/en/netgpu/setup.c      |  475 ++++++
 .../mellanox/mlx5/core/en/netgpu/setup.h      |   42 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |    3 +
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |    3 +
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.h |    3 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   15 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  118 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   52 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   15 +-
 include/linux/dma-mapping.h                   |    4 +-
 include/linux/memory_hotplug.h                |    4 +
 include/linux/mmzone.h                        |    7 +
 include/linux/netdevice.h                     |    6 +
 include/linux/skbuff.h                        |   27 +-
 include/linux/socket.h                        |    1 +
 include/linux/uio.h                           |    4 +
 include/net/netgpu.h                          |   65 +
 include/uapi/asm-generic/socket.h             |    2 +
 include/uapi/misc/netgpu.h                    |   43 +
 include/uapi/misc/shqueue.h                   |  205 +++
 kernel/user.c                                 |    1 +
 lib/iov_iter.c                                |   45 +
 mm/memory_hotplug.c                           |   65 +-
 net/core/datagram.c                           |    6 +-
 net/core/skbuff.c                             |   44 +-
 net/core/sock.c                               |   26 +
 net/ipv4/tcp.c                                |    8 +
 net/ipv4/tcp_output.c                         |   16 +
 35 files changed, 2828 insertions(+), 41 deletions(-)
 create mode 100644 drivers/misc/netgpu/Kconfig
 create mode 100644 drivers/misc/netgpu/Makefile
 create mode 100644 drivers/misc/netgpu/nvidia.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
 create mode 100644 include/net/netgpu.h
 create mode 100644 include/uapi/misc/netgpu.h
 create mode 100644 include/uapi/misc/shqueue.h

-- 
2.24.1


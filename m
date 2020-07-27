Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D314E22FC5C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgG0Wos convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgG0Wor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:47 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfrVa003687
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:46 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:45 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id B25CC3FAB6F59; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 00/21] netgpu: networking between NIC and GPU/CPU.
Date:   Mon, 27 Jul 2020 15:44:23 -0700
Message-ID: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=0 mlxlogscore=993 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

[ RESENDING, as apparently the initial submission was lost ]

This series is a working RFC proof-of-concept that implements DMA
zero-copy between the NIC and a GPU device for the data path, while
keeping the protocol processing on the host CPU.

This also works for zero-copy send/recv to host (CPU) memory.

Current limitations:
  - mlx5 only, header splitting is at a fixed offset.
  - currently only TCP protocol delivery is performed.
  - TX completion notification is planned, but not in this patchset.
  - not compatible with xsk (re-uses same datastructures)
  - not compatible with bpf payload inspection

Changes since v1:
  - user api restructured to provide more flexibility.
  - iommu issues resolved
  - performance issues fixed.
  - nvidia bits are built as an external module.

The next section provides a brief overview of how things work.

A transport context (aka RSS object) is created for a device, which acts
as a container for a group of queues.  Queues are opened on a context,
these correcpond to hardware queues on the NIC.  There exists the
ability to request a sepcific numbered queue, or "any" queue.  Only RX
queues are needed, the standard TX queues are used for packet
transmission.

Memory regions which participate in zero-copy transmission (either send
or recieve) are registered with a memory object, and then a specific
region can be attached to a context for usage.  This way, multiple
contexts can share the same memory regions.  These areas can be used as
either RX packet buffers or TX data areas (or both).  The memory can
come from either malloc/mmap or cudaMalloc().  The latter call provides
a handle to the userspace application, but the memory region is only
accessible to the GPU.

A socket is created and registered with the context, which sets
SOCK_ZEROCOPY, also creates a per-socket queue for recieving zero-copy
data.

Asymmetrical data paths are possible (zc TX, normal RX), and vice versa,
but the curreent PoC sets things up for symmetrical transport.  The
application needs to provide the RX buffers to the ifq fill queue,
similar to AF_XDP.

Once things are set up, data is sent to the network with sendmsg().  The
iovecs provided contain an address in the region previously registered.
The normal protocol stack processing constructs the packet, but the data
is not touched by the stack.  In this phase, the application is not
notified when the protocol processing is complete and the data area is
safe to modify again.

For RX, packets undergo the usual protocol processing and are delivered
up to the socket receive queue.  At this point, the skb data fragments
are delivered to the application as iovecs through an AF_XDP style queue
which belongs to the socket.  The application can poll for readability,
but does not use read() to receive the data.

The initial application used is iperf3, a modified version with the
userspace library corresponding to this patch is available at:
    https://github.com/jlemon/iperf
    https://github.com/jlemon/netgpu

Running "iperf3 -s -z --dport 8888" (host memory) on a 12Gbps link:
    11.4 Gbit/sec receive
    10.8 Gbit/sec transmit

Running "iperf3 -s -z --dport 8888 --gpu" on a 25Gbps link:
    23.4 Gbit/sec receive
    23.8 Gbit/sec transmit

For the GPU runs, the Intel PCI monitoring tools were used to confirm
that the host PCI bus was mostly idle. 

Patch series:
  1,4    : cleanup & extension
  2,3    : extend mm, allowing allocation of specific memory regions
  5,6,7  : add include support files
  8,9,11 : skbuff core changes for handling zc frags
  10,21  : netgpu and nvidia code
  12-15  : changes to connect up netgpu code
  16-20  : mlx5 driver changes

Comments eagerly solicited.
--
Jonathan


Jonathan Lemon (21):
  linux/log2.h: enclose macro arg in parens
  mm/memory_hotplug: add {add|release}_memory_pages
  mm: Allow DMA mapping of pages which are not online
  kernel/user: export free_uid
  uapi/misc: add shqueue.h for shared queues
  include: add netgpu UAPI and kernel definitions
  netdevice: add SETUP_NETGPU to the netdev_bpf structure
  skbuff: add a zc_netgpu bitflag
  core/skbuff: use skb_zdata for testing whether skb is zerocopy
  netgpu: add network/gpu/host dma module
  core/skbuff: add page recycling logic for netgpu pages
  lib: have __zerocopy_sg_from_iter get netgpu pages for a sk
  net/tcp: Pad TCP options out to a fixed size for netgpu
  net/tcp: add netgpu ioctl setting up zero copy RX queues
  net/tcp: add MSG_NETDMA flag for sendmsg()
  mlx5: remove the umem parameter from mlx5e_open_channel
  mlx5e: add header split ability
  mlx5e: add netgpu entries to mlx5 structures
  mlx5e: add the netgpu driver functions
  mlx5e: hook up the netgpu functions
  netgpu/nvidia: add Nvidia plugin for netgpu

 drivers/misc/Kconfig                          |    1 +
 drivers/misc/Makefile                         |    1 +
 drivers/misc/netgpu/Kconfig                   |   14 +
 drivers/misc/netgpu/Makefile                  |    6 +
 drivers/misc/netgpu/netgpu_host.c             |  284 ++++
 drivers/misc/netgpu/netgpu_main.c             | 1215 +++++++++++++++++
 drivers/misc/netgpu/netgpu_mem.c              |  351 +++++
 drivers/misc/netgpu/netgpu_priv.h             |   88 ++
 drivers/misc/netgpu/netgpu_stub.c             |  166 +++
 drivers/misc/netgpu/netgpu_stub.h             |   19 +
 drivers/misc/netgpu/nvidia/Kbuild             |    9 +
 drivers/misc/netgpu/nvidia/Kconfig            |   10 +
 drivers/misc/netgpu/nvidia/netgpu_cuda.c      |  416 ++++++
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |    1 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   21 +-
 .../mellanox/mlx5/core/en/netgpu/setup.c      |  340 +++++
 .../mellanox/mlx5/core/en/netgpu/setup.h      |   96 ++
 .../ethernet/mellanox/mlx5/core/en/params.c   |    3 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |    9 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |    3 +
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |    4 +
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.h |    3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  121 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   58 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   19 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   16 +-
 include/linux/dma-mapping.h                   |    4 +-
 include/linux/log2.h                          |    2 +-
 include/linux/memory_hotplug.h                |    4 +
 include/linux/mmzone.h                        |    7 +
 include/linux/netdevice.h                     |    6 +
 include/linux/skbuff.h                        |   27 +-
 include/linux/socket.h                        |    1 +
 include/linux/uio.h                           |    4 +
 include/net/netgpu.h                          |   66 +
 include/uapi/misc/netgpu.h                    |   69 +
 include/uapi/misc/shqueue.h                   |  200 +++
 kernel/user.c                                 |    1 +
 lib/iov_iter.c                                |   53 +
 mm/memory_hotplug.c                           |   65 +-
 net/core/datagram.c                           |    9 +-
 net/core/skbuff.c                             |   50 +-
 net/ipv4/tcp.c                                |   13 +
 net/ipv4/tcp_output.c                         |   20 +
 45 files changed, 3827 insertions(+), 49 deletions(-)
 create mode 100644 drivers/misc/netgpu/Kconfig
 create mode 100644 drivers/misc/netgpu/Makefile
 create mode 100644 drivers/misc/netgpu/netgpu_host.c
 create mode 100644 drivers/misc/netgpu/netgpu_main.c
 create mode 100644 drivers/misc/netgpu/netgpu_mem.c
 create mode 100644 drivers/misc/netgpu/netgpu_priv.h
 create mode 100644 drivers/misc/netgpu/netgpu_stub.c
 create mode 100644 drivers/misc/netgpu/netgpu_stub.h
 create mode 100644 drivers/misc/netgpu/nvidia/Kbuild
 create mode 100644 drivers/misc/netgpu/nvidia/Kconfig
 create mode 100644 drivers/misc/netgpu/nvidia/netgpu_cuda.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
 create mode 100644 include/net/netgpu.h
 create mode 100644 include/uapi/misc/netgpu.h
 create mode 100644 include/uapi/misc/shqueue.h

-- 
2.24.1


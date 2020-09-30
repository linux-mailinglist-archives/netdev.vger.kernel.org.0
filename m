Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD827EEE8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgI3QUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50415 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726476AbgI3QUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:32 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:27 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2B032498;
        Wed, 30 Sep 2020 19:20:27 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next RFC v1 00/10] nvme-tcp receive offloads
Date:   Wed, 30 Sep 2020 19:20:00 +0300
Message-Id: <20200930162010.21610-1-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for nvme-tcp receive offloads
which do not mandate the offload of the network stack to the device.
Instead, these work together with TCP to offload:
1. copy from SKB to the block layer buffers
2. CRC verification for received PDU

The series implements these as a generic offload infrastructure for storage
protocols, which we call TCP Direct Data Placement (TCP_DDP) and TCP DDP CRC,
respectively. We use this infrastructure to implement NVMe-TCP offload for copy
and CRC. Future implementations can reuse the same infrastructure for other
protcols such as iSCSI.

Note:
These offloads are similar in nature to the packet-based NIC TLS offloads,
which are already upstream (see net/tls/tls_device.c).
You can read more about TLS offload here:
https://www.kernel.org/doc/html/latest/networking/tls-offload.html

Initialization and teardown:
=========================================
The offload for IO queues is initialized after the handshake of the
NVMe-TCP protocol is finished by calling `nvme_tcp_offload_socket`
with the tcp socket of the nvme_tcp_queue:
This operation sets all relevant hardware contexts in
hardware. If it fails, then the IO queue proceeds as usually with no offload.
If it succeeds then `nvme_tcp_setup_ddp` and `nvme_tcp_teardown_ddp` may be
called to perform copy offload, and crc offload will be used.
This initialization does not change the normal operation of nvme-tcp in any
way besides adding the option to call the above mentioned NDO operations.

For the admin queue, nvme-tcp does not initialize the offload.
Instead, nvme-tcp calls the driver to configure limits for the controller,
such as max_hw_sectors and max_segments; these must be limited to accomodate
potential HW resource limits, and to improve performance.

If some error occured, and the IO queue must be closed or reconnected, then
offload is teardown and initialized again. Additionally, we handle netdev
down events via the existing error recovery flow.

Copy offload works as follows:
=========================================
The nvme-tcp layer calls the NIC drive to map block layer buffers to ccid using
`nvme_tcp_setup_ddp` before sending the read request. When the repsonse is
received, then the NIC HW will write the PDU payload directly into the
designated buffer, and build an SKB such that it points into the destination
buffer; this SKB represents the entire packet received on the wire, but it
points to the block layer buffers. Once nvme-tcp attempts to copy data from
this SKB to the block layer buffer it can skip the copy by checking in the
copying function (memcpy_to_page):
if (src == dst) -> skip copy
Finally, when the PDU has been processed to completion, the nvme-tcp layer
releases the NIC HW context be calling `nvme_tcp_teardown_ddp` which
asynchronously unmaps the buffers from NIC HW.

As the last change is to a sensative function, we are careful to place it under
static_key which is only enabled when this functionality is actually used for
nvme-tcp copy offload.

Asynchronous completion:
=========================================
The NIC must release its mapping between command IDs and the target buffers.
This mapping is released when NVMe-TCP calls the NIC
driver (`nvme_tcp_offload_socket`).
As completing IOs is performance criticial, we introduce asynchronous
completions for NVMe-TCP, i.e. NVMe-TCP calls the NIC, which will later
call NVMe-TCP to complete the IO (`nvme_tcp_ddp_teardown_done`).

An alternative approach is to move all the functions related to coping from
SKBs to the block layer buffers inside the nvme-tcp code - about 200 LOC.

CRC offload works as follows:
=========================================
After offload is initialized, we use the SKB's ddp_crc bit to indicate that:
"there was no problem with the verification of all CRC fields in this packet's
payload". The bit is set to zero if there was an error, or if HW skipped
offload for some reason. If *any* SKB in a PDU has (ddp_crc != 1), then software
must compute the CRC, and check it. We perform this check, and
accompanying software fallback at the end of the processing of a received PDU.

SKB changes:
=========================================
The CRC offload requires an additional bit in the SKB, which is useful for
preventing the coalescing of SKB with different crc offload values. This bit
is similar in concept to the "decrypted" bit. 

Performance:
=========================================
The expected performance gain from this offload varies with the block size.
We perform a CPU cycles breakdown of the copy/CRC operations in nvme-tcp
fio random read workloads:
For 4K blocks we see up to 11% improvement for a 100% read fio workload,
while for 128K blocks we see upto 52%. If we run nvme-tcp, and skip these
operations, then we observe a gain of about 1.1x and 2x respectively.

Resynchronization:
=========================================
The resynchronization flow is performed to reset the hardware tracking of
NVMe-TCP PDUs within the TCP stream. The flow consists of a request from
the driver, regarding a possible location of a PDU header. Followed by
a response from the nvme-tcp driver.

This flow is rare, and it should happen only after packet loss or
reordering events that involve nvme-tcp PDU headers.

The patches are organized as follows:
=========================================
Patch 1         the iov_iter change to skip copy if (src == dst)
Patches 2-3     the infrastructure for all TCP DDP
                and TCP DDP CRC offloads, respectively.
Patch 4         exposes the get_netdev_for_sock function from TLS
Patch 5         NVMe-TCP changes to call NIC driver on queue init/teardown
Patches 6       NVMe-TCP changes to call NIC driver on IO operation
                setup/teardown, and support async completions.
Patches 7       NVMe-TCP changes to support CRC offload on receive.
                Also, this patch moves CRC calculation to the end of PDU
                in case offload requires software fallback.
Patches 8       NVMe-TCP handling of netdev events: stop the offload if
                netdev is going down
Patches 9-10    implement support for NVMe-TCP copy and CRC offload in
                the mlx5 NIC driver

Testing:
=========================================
This series was tested using fio with various configurations of IO sizes,
depths, MTUs, and with both the SPDK and kernel NVMe-TCP targets.

Future work:
=========================================
A follow-up series will introduce support for transmit side CRC. Then,
we will work on adding support for TLS in NVMe-TCP and combining the
two offloads.


Boris Pismenny (8):
  iov_iter: Skip copy in memcpy_to_page if src==dst
  net: Introduce direct data placement tcp offload
  net: Introduce crc offload for tcp ddp ulp
  net/tls: expose get_netdev_for_sock
  nvme-tcp: Add DDP offload control path
  nvme-tcp: Add DDP data-path
  net/mlx5e: Add NVMEoTCP offload
  net/mlx5e: NVMEoTCP, data-path for DDP offload

Or Gerlitz (1):
  nvme-tcp: Deal with netdevice DOWN events

Yoray Zack (1):
  nvme-tcp : Recalculate crc in the end of the capsule

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  12 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  13 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   9 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |  10 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 894 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 116 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 256 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |  25 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  79 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  73 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  76 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  38 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  24 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 drivers/nvme/host/tcp.c                       | 410 +++++++-
 include/linux/mlx5/device.h                   |  38 +-
 include/linux/mlx5/mlx5_ifc.h                 | 121 ++-
 include/linux/mlx5/qp.h                       |   1 +
 include/linux/netdev_features.h               |   4 +
 include/linux/netdevice.h                     |   5 +
 include/linux/nvme-tcp.h                      |   2 +
 include/linux/skbuff.h                        |   4 +
 include/linux/uio.h                           |   2 +
 include/net/inet_connection_sock.h            |   4 +
 include/net/sock.h                            |  17 +
 include/net/tcp_ddp.h                         |  90 ++
 lib/iov_iter.c                                |  11 +-
 net/Kconfig                                   |  17 +
 net/core/skbuff.c                             |   9 +-
 net/ethtool/common.c                          |   2 +
 net/ipv4/tcp_input.c                          |   7 +
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/tcp_offload.c                        |   3 +
 net/tls/tls_device.c                          |  20 +-
 40 files changed, 2375 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
 create mode 100644 include/net/tcp_ddp.h


base-commit: 300fd579b2e8608586b002207e906ac95c74b911
prerequisite-patch-id: b3079fa1f4c0e3d6d4a92f59e70981e8a28f3b83
-- 
2.24.1


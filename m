Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6571CA8F9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHLJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:09:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21515 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHLJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3yMG1Zv3/Y8v60jXKd4/nIr8ZDG5S6QTeqMuCOAWkfw=;
        b=UC5GiXDqwCoXi7OpF+z1UpHndRYvhkyNMd74rITcbAf9aV1p4g4C9yglgMnTZhktEpnRUC
        dgGutdv89Nt6MdVyGrRUHDEDWTIrhjXAFlLCnZmr2wnuuew52fnDDn0oopsgjQb/9LmniG
        FHXcY9wd7G5Krf5kN29dd2P42LADGrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-8GtleJ_HOWOtEMXrhUDEHA-1; Fri, 08 May 2020 07:08:55 -0400
X-MC-Unique: 8GtleJ_HOWOtEMXrhUDEHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DEE7835B48;
        Fri,  8 May 2020 11:08:53 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30C2310013BD;
        Fri,  8 May 2020 11:08:47 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CF507300020FB;
        Fri,  8 May 2020 13:08:45 +0200 (CEST)
Subject: [PATCH net-next v3 00/33] XDP extend with knowledge of frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 May 2020 13:08:45 +0200
Message-ID: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Send for net-next due to all the driver updates)

V3:
- Fix issue on virtio_net patch spotted by Jason Wang
- Adjust name for variable in mlx5 patch
- Collected more ACKs

V2:
- Fix bug in mlx5 for XDP_PASS case
- Collected nitpicks and ACKs from mailing list

V1:
- Fix bug in dpaa2

XDP have evolved to support several frame sizes, but xdp_buff was not
updated with this information. This have caused the side-effect that
XDP frame data hard end is unknown. This have limited the BPF-helper
bpf_xdp_adjust_tail to only shrink the packet. This patchset address
this and add packet tail extend/grow.

The purpose of the patchset is ALSO to reserve a memory area that can be
used for storing extra information, specifically for extending XDP with
multi-buffer support. One proposal is to use same layout as
skb_shared_info, which is why this area is currently 320 bytes.

When converting xdp_frame to SKB (veth and cpumap), the full tailroom
area can now be used and SKB truesize is now correct. For most
drivers this result in a much larger tailroom in SKB "head" data
area. The network stack can now take advantage of this when doing SKB
coalescing. Thus, a good driver test is to use xdp_redirect_cpu from
samples/bpf/ and do some TCP stream testing.

Use-cases for tail grow/extend:
(1) IPsec / XFRM needs a tail extend[1][2].
(2) DNS-cache responses in XDP.
(3) HAProxy ALOHA would need it to convert to XDP.
(4) Add tail info e.g. timestamp and collect via tcpdump

[1] http://vger.kernel.org/netconf2019_files/xfrm_xdp.pdf
[2] http://vger.kernel.org/netconf2019.html

---

Ilias Apalodimas (1):
      net: netsec: Add support for XDP frame size

Jesper Dangaard Brouer (32):
      xdp: add frame size to xdp_buff
      bnxt: add XDP frame size to driver
      sfc: add XDP frame size
      mvneta: add XDP frame size to driver
      net: XDP-generic determining XDP frame size
      xdp: xdp_frame add member frame_sz and handle in convert_to_xdp_frame
      xdp: cpumap redirect use frame_sz and increase skb_tailroom
      veth: adjust hard_start offset on redirect XDP frames
      veth: xdp using frame_sz in veth driver
      dpaa2-eth: add XDP frame size
      hv_netvsc: add XDP frame size to driver
      qlogic/qede: add XDP frame size to driver
      net: ethernet: ti: add XDP frame size to driver cpsw
      ena: add XDP frame size to amazon NIC driver
      mlx4: add XDP frame size and adjust max XDP MTU
      net: thunderx: add XDP frame size
      nfp: add XDP frame size to netronome driver
      tun: add XDP frame size
      vhost_net: also populate XDP frame size
      virtio_net: add XDP frame size in two code paths
      ixgbe: fix XDP redirect on archs with PAGE_SIZE above 4K
      ixgbe: add XDP frame size to driver
      ixgbevf: add XDP frame size to VF driver
      i40e: add XDP frame size to driver
      ice: add XDP frame size to driver
      xdp: for Intel AF_XDP drivers add XDP frame_sz
      mlx5: rx queue setup time determine frame_sz for XDP
      xdp: allow bpf_xdp_adjust_tail() to grow packet size
      xdp: clear grow memory in bpf_xdp_adjust_tail()
      bpf: add xdp.frame_sz in bpf_prog_test_run_xdp().
      selftests/bpf: adjust BPF selftest for xdp_adjust_tail
      selftests/bpf: xdp_adjust_tail add grow tail tests


 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    1 
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |    5 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    1 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    1 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    7 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   30 ++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    2 
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   34 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   33 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |    2 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   34 ++++--
 drivers/net/ethernet/marvell/mvneta.c              |   25 ++--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    3 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    2 
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    6 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    1 
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    2 
 drivers/net/ethernet/sfc/rx.c                      |    1 
 drivers/net/ethernet/socionext/netsec.c            |   30 +++--
 drivers/net/ethernet/ti/cpsw.c                     |    1 
 drivers/net/ethernet/ti/cpsw_new.c                 |    1 
 drivers/net/hyperv/netvsc_bpf.c                    |    1 
 drivers/net/hyperv/netvsc_drv.c                    |    2 
 drivers/net/tun.c                                  |    2 
 drivers/net/veth.c                                 |   28 +++--
 drivers/net/virtio_net.c                           |   15 ++
 drivers/vhost/net.c                                |    1 
 include/net/xdp.h                                  |   27 ++++
 include/net/xdp_sock.h                             |   11 ++
 include/uapi/linux/bpf.h                           |    4 -
 kernel/bpf/cpumap.c                                |   21 ---
 net/bpf/test_run.c                                 |   16 ++-
 net/core/dev.c                                     |   14 +-
 net/core/filter.c                                  |   15 ++
 net/core/xdp.c                                     |    7 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |  123 +++++++++++++++++++-
 .../testing/selftests/bpf/progs/test_adjust_tail.c |   30 -----
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |   33 +++++
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |   30 +++++
 44 files changed, 474 insertions(+), 139 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/test_adjust_tail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c

--


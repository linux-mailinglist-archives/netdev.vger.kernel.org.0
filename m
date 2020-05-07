Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF971C8710
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGKnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgEGKnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:43:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E84C061A10;
        Thu,  7 May 2020 03:43:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s18so2341214pgl.12;
        Thu, 07 May 2020 03:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1egyuSINNSTTaOrqc4Xih94IzvES/v8BLU25z1rtww=;
        b=ua6piP9tpHhhZQlpj4CEBpNwJ5Kfgwuw3dHji+jIhrwoMJeSQSpqhpK+JqwjzqZjHi
         f6xQC9Tr4jY4FShU15z7MCz4qZRJzDLrKnqcw53E0i9T//BrMwKwpII0wK27gR+CUppR
         O3rH9C3Bz0/tDbYERbYjUR0rOS4saWhHx9wKaEex+zbVBiBaP8TWFNNGdgsYyI5ZJfl/
         3buKbVcktKM48a8Sta1T56e0y7DmV7oNnSALTdB4jUuggup8zBbhzEzckJXVVWvOH9Tg
         7iASzz9kK/6+918nyvtUAg85RFo1en2JzUOm5lS42VOjS0fBiEqpAzn71kPqAC10o/l+
         8/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1egyuSINNSTTaOrqc4Xih94IzvES/v8BLU25z1rtww=;
        b=qTwSrepmnYSsRdfE0s9bHdNxf/hR8yaO/iwr27bYHQF+vj1fM+QiCTnCJKAUKV/JCI
         s2zy+rVIoyoBfXnQFB9iKzZLtVOkF2GPZGys/W12CRtC4XAFb3qwzUh1t1IocDLncyaw
         1gxud/arIRx8lo1zDzP/waoWDToCjUXCrsrMk3lJvyMJG5f81M2gTMPszZz6Qnqa/7PO
         NymBYX3Np+C4K+aJ37WFnV36iuXbYQXMwbKEP+n3iDCYIkmjAHWblIl5S7oit3Fidfh1
         h/6U1h6B6U6nUKWFRboGcmpqvMl5gz0MjluDQYqETVtY7vdaxXymyrJdlcvFuWLbbwnr
         xlZA==
X-Gm-Message-State: AGi0Pubm35nGRCn5COzhI3KafkzMnGFi/hUeJAvHSXgfLcbo/f5Gs7C/
        gMznPSHV1MOpfgBqTLOOrR0=
X-Google-Smtp-Source: APiQypIscyuqpg1BpQbjHv2wHomdc2n/L+Titc4WOzrRSFBlkU4tnyYkE/BQXCAUekdhPoS5YOKEig==
X-Received: by 2002:aa7:82d4:: with SMTP id f20mr13319745pfn.253.1588848193614;
        Thu, 07 May 2020 03:43:13 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:43:12 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: [PATCH bpf-next 00/14] Introduce AF_XDP buffer allocation API
Date:   Thu,  7 May 2020 12:42:38 +0200
Message-Id: <20200507104252.544114-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

Driver adoption for AF_XDP has been slow. The amount of code required
to proper support AF_XDP is substantial and the driver/core APIs are
vague or even non-existing. Drivers have to manually adjust data
offsets, updating AF_XDP handles differently for different modes
(aligned/unaligned).

This series attempts to improve the situation by introducing an AF_XDP
buffer allocation API. The implementation is based on a single core
(single producer/consumer) buffer pool for the AF_XDP UMEM.
    
A buffer is allocated using the xsk_buff_alloc() function, and
returned using xsk_buff_free(). If a buffer is disassociated with the
pool, e.g. when a buffer is passed to an AF_XDP socket, a buffer is
said to be released. Currently, the release function is only used by
the AF_XDP internals and not visible to the driver.
    
Drivers using this API should register the XDP memory model with the
new MEM_TYPE_XSK_BUFF_POOL type, which will supersede the
MEM_TYPE_ZERO_COPY type.

The buffer type is struct xdp_buff, and follows the lifetime of
regular xdp_buffs, i.e.  the lifetime of an xdp_buff is restricted to
a NAPI context. In other words, the API is not replacing xdp_frames.

DMA mapping/synching is folded into the buffer handling as well.

@JeffK The Intel drivers changes should go through the bpf-next tree,
       and not your regular Intel tree, since multiple (non-Intel)
       drivers are affected.

The outline of the series is as following:

Patch 1 to 3 are restructures/clean ups. The XSKMAP implementation is
moved to net/xdp/. Functions/defines/enums that are only used by the
AF_XDP internals are moved from the global include/net/xdp_sock.h to
net/xdp/xsk.h. We are also introducing a new "driver include file",
include/net/xdp_sock_drv.h, which is the only file NIC driver
developers adding AF_XDP zero-copy support should care about.

Patch 4 adds the new API, and migrates the "copy-mode"/skb-mode AF_XDP
path to the new API.

Patch 5 to 10 migrates the existing zero-copy drivers to the new API.

Patch 11 removes the MEM_TYPE_ZERO_COPY memory type, and the "handle"
member of struct xdp_buff.

Patch 12 simplifies the xdp_return_{frame,frame_rx_napi,buff}
functions.

Patch 13 is a performance patch, where some functions are inlined.

Finally, patch 14 updates the MAINTAINERS file to correctly mirror the
new file layout.

Note that this series removes the "handle" member from struct
xdp_buff, which reduces the xdp_buff size.

After this series, the diff stat of drivers/net/ is:
  27 files changed, 378 insertions(+), 1264 deletions(-)

This series is a first step of simplifying the driver side of
AF_XDP. I think more of the AF_XDP logic can be moved from the drivers
to the AF_XDP core, e.g. the "need wakeup" set/clear functionality.

Statistics when allocation fails can now be added to the socket
statistics via the XDP_STATISTICS getsockopt(). This will be added in
a follow up series.


Performance
===========

As a nice side effect, performance is up a bit as well (40 GbE, 64B
packets, i40e):

rxdrop, zero-copy, aligned:
  baseline: 20.4
  new API : 21.3

rxdrop, zero-copy, unaligned:
  baseline: 19.5
  new API : 21.2


Changelog
=========

  * Fixed build errors/warnings for m68k and riscv. (kbuild test
    robot)
  * Added headroom/chunk size getter. (Maxim/Björn)
  * mlx5: Put back the sanity check for XSK params, use XSK API to get
    the total headroom size. (Maxim)
  * Fixed spelling in commit message. (Björn)
  * Make sure xp_validate_desc() is inlined for Tx perf. (Maxim)
  * Sorted file entries. (Joe)
  * Added xdp_return_{frame,frame_rx_napi,buff} simplification (Björn)


Thanks for all the comments/input/help!

Cheers,
Björn


Björn Töpel (13):
  xsk: move xskmap.c to net/xdp/
  xsk: move defines only used by AF_XDP internals to xsk.h
  xsk: introduce AF_XDP buffer allocation API
  i40e: refactor rx_bi accesses
  i40e: separate kernel allocated rx_bi rings from AF_XDP rings
  i40e, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  ice, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  ixgbe, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  mlx5, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  xsk: remove MEM_TYPE_ZERO_COPY and corresponding code
  xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
  xsk: explicitly inline functions and move definitions
  MAINTAINERS, xsk: update AF_XDP section after moves/adds

Magnus Karlsson (1):
  xsk: move driver interface to xdp_sock_drv.h

 MAINTAINERS                                   |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 134 +++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  17 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  40 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 376 +++---------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 374 ++---------------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  15 +-
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 307 +++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 111 +-----
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   8 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  51 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  43 +-
 drivers/net/hyperv/netvsc_bpf.c               |   1 -
 include/net/xdp.h                             |   9 +-
 include/net/xdp_sock.h                        | 276 +------------
 include/net/xdp_sock_drv.h                    | 220 ++++++++++
 include/net/xsk_buff_pool.h                   | 134 +++++++
 include/trace/events/xdp.h                    |   2 +-
 kernel/bpf/Makefile                           |   3 -
 net/core/xdp.c                                |  51 +--
 net/ethtool/channels.c                        |   2 +-
 net/ethtool/ioctl.c                           |   2 +-
 net/xdp/Makefile                              |   3 +-
 net/xdp/xdp_umem.c                            |  55 +--
 net/xdp/xdp_umem.h                            |   2 +-
 net/xdp/xsk.c                                 | 204 ++++------
 net/xdp/xsk.h                                 |  30 ++
 net/xdp/xsk_buff_pool.c                       | 337 ++++++++++++++++
 net/xdp/xsk_diag.c                            |   2 +-
 net/xdp/xsk_queue.c                           |  62 ---
 net/xdp/xsk_queue.h                           | 117 ++----
 {kernel/bpf => net/xdp}/xskmap.c              |   2 +
 47 files changed, 1249 insertions(+), 1912 deletions(-)
 create mode 100644 include/net/xdp_sock_drv.h
 create mode 100644 include/net/xsk_buff_pool.h
 create mode 100644 net/xdp/xsk_buff_pool.c
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)

-- 
2.25.1


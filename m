Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BFD1C384F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgEDLht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728270AbgEDLht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:37:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D2C061A0E;
        Mon,  4 May 2020 04:37:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so5352693pfx.7;
        Mon, 04 May 2020 04:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dMyCMH5wgveswbK/u4bcaVKFhOCbQHqmAoefFSH1wC8=;
        b=tw8OOnEGwviga6qTwN5YM9C+5sBdMO1ejOe04w9g6I4cQ7FfrfkUnpIPpOgnmtMovF
         DSxS+FZ60rQn4d57otO5LJA4Het+3V24ZAGlfGV2vxzCruiakPey200Bb0WJiloICsnq
         33EICZVEQCeRUkZZCdW58tgGflkuIuh1scYVP33RHuqDhaL3lfU3CsM0PS5ae+QVD1F4
         6AnAOoUmVoTiTF8mZZKSTUP23RA5qDIBGfOtwwPmcvv1w6tmGO35qpADJ6eAh8Y2jv5X
         G7vbJA7jnvJGCvyQ9NCeiQiAsLQBbI3MNiaJ6UfqJEILYLIJyN5GP5A903HuvH7X89EC
         9Bkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dMyCMH5wgveswbK/u4bcaVKFhOCbQHqmAoefFSH1wC8=;
        b=pBXdbDPI1Ir+RYJThhA5wXzEAqCcX5ngM9glEqURA9nHZWC4QF+CnuYJf1Ml8zaQf3
         B0xiMWol9hQHuCXTz2wjKcK5yiMIMY3QDN4FeWomnD7u5MpBtX2cFH/NtIa1rwvr7d/w
         pIcvXuBtC1c8UlrveySLd+5cAxaPu0EX/XhdyP+mZ6RTrcdUSq8J+f+DlnIibzU3/7pb
         dN7yajUlo4wfx/oQMOtUa6iMLXH6OLa8VWqNmvyijrTNRRQNmw5c5c8t/FkKeZ+GZ9Ji
         Vaq8ws64tFlK0odUTG5qJhaReGpY/P6Rhh5BkjWHK4NPaenXJrpzan5czgMrJ+bj3Zgo
         MycQ==
X-Gm-Message-State: AGi0PuahPrgXHGS7uSZZW9oZwUNLFRTZw7uDSKcdqq5dv9L4BZ8RwUUO
        LJj4wCyLbjnuKBrJlvad4QG/0jd+lVgwvw==
X-Google-Smtp-Source: APiQypL3p8WhaN1cuJqSfcRpZ/04FdhLwbhum9qniM/SU3nqzkzzYoYuwMaXIB8j/+PxaPMAYz+Fkw==
X-Received: by 2002:aa7:8b15:: with SMTP id f21mr17133835pfd.72.1588592268657;
        Mon, 04 May 2020 04:37:48 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:37:47 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: [RFC PATCH bpf-next 00/13] Introduce AF_XDP buffer allocation API
Date:   Mon,  4 May 2020 13:37:02 +0200
Message-Id: <20200504113716.7930-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

The reasons for sending the series as an RFC, and not as a proper one,
are:

* Mellanox and Intel need to finish the validation tests, prior merging.

* An additional API is (maybe) needed to let a NIC driver change the
  headroom/data alignment. Some hardware have specific DMA alignment
  requirements. Further; Should the headroom be adjusted for
  NET_IP_ALIGN?

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

Patch 12 is a performance patch, where some functions are inlined.

Finally, patch 13 updates the MAINTAINERS file to correctly mirror the
new file layout.

Note that this series removes the "handle" member from struct
xdp_buff.

After this series, the amount of code in drivers/net/ is reduced by:
  27 files changed, 371 insertions(+), 1265 deletions(-)

As a nice side effect, performance is up a bit as well (40 GbE, 64B
packets, i40e):

rxdrop, zero-copy, aligned:
baseline: 20.4 Mpps
new API : 21.3 Mpps

rxdrop, zero-copy, unaligned:
baseline: 19.5 Mpps
new API : 21.2 Mpps

All input are welcome -- especially ideas/thoughts on buffer alignment
(bullet #2 above).

Big thanks to Max, Magnus and Maciej for all (offlist) input, and
help!


Cheers,
Björn

Björn Töpel (12):
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
  xsk: explicitly inline functions and move definitions
  MAINTAINERS, xsk: update AF_XDP section after moves/adds

Magnus Karlsson (1):
  xsk: move driver interface to xdp_sock_drv.h

 MAINTAINERS                                   |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 134 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  17 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  40 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 376 +++-------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 374 ++--------------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  15 +-
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 307 +++----------
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 111 +----
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   8 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  54 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  43 +-
 drivers/net/hyperv/netvsc_bpf.c               |   1 -
 include/net/xdp.h                             |   9 +-
 include/net/xdp_sock.h                        | 276 +-----------
 include/net/xdp_sock_drv.h                    | 200 +++++++++
 include/net/xsk_buff_pool.h                   |  94 ++++
 include/trace/events/xdp.h                    |   2 +-
 kernel/bpf/Makefile                           |   3 -
 net/core/xdp.c                                |  44 +-
 net/ethtool/channels.c                        |   2 +-
 net/ethtool/ioctl.c                           |   2 +-
 net/xdp/Makefile                              |   3 +-
 net/xdp/xdp_umem.c                            |  55 +--
 net/xdp/xdp_umem.h                            |   2 +-
 net/xdp/xsk.c                                 | 204 +++------
 net/xdp/xsk.h                                 |  30 ++
 net/xdp/xsk_buff_pool.c                       | 410 ++++++++++++++++++
 net/xdp/xsk_diag.c                            |   2 +-
 net/xdp/xsk_queue.c                           |  62 ---
 net/xdp/xsk_queue.h                           |  94 +---
 {kernel/bpf => net/xdp}/xskmap.c              |   2 +
 47 files changed, 1219 insertions(+), 1919 deletions(-)
 create mode 100644 include/net/xdp_sock_drv.h
 create mode 100644 include/net/xsk_buff_pool.h
 create mode 100644 net/xdp/xsk_buff_pool.c
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)

-- 
2.25.1


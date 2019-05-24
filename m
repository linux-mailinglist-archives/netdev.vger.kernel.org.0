Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC72529593
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390049AbfEXKSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:18:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:4032 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389448AbfEXKSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 06:18:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 03:18:38 -0700
X-ExtLoop1: 1
Received: from nisrael1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.255.41.138])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2019 03:18:33 -0700
Subject: Re: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
Date:   Fri, 24 May 2019 12:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524093431.20887-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-24 11:35, Maxim Mikityanskiy wrote:
> This series contains improvements to the AF_XDP kernel infrastructure
> and AF_XDP support in mlx5e. The infrastructure improvements are
> required for mlx5e, but also some of them benefit to all drivers, and
> some can be useful for other drivers that want to implement AF_XDP.
> 
> The performance testing was performed on a machine with the following
> configuration:
> 
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
> 
> The results with retpoline disabled, single stream:
> 
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
> 
> The results with retpoline enabled, single stream:
> 
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
> rxdrop: 9.9 Mpps
> l2fwd: 6.8 Mpps
> 
> v2 changes:
> 
> Added patches for mlx5e and addressed the comments for v1. Rebased for
> bpf-next.
> 
> v3 changes:
> 
> Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
> Björn's comments for coding style. Fixed a bug in error handling flow in
> mlx5e_open_xsk.
>

Maxim, this doesn't address the uapi concern we had on your v2.
Please refer to Magnus' comment here [1].

Please educate me why you cannot publish AF_XDP without the uapi change?
It's an extension, right? If so, then existing XDP/AF_XDP program can
use Mellanox ZC without your addition? It's great that Mellanox has a ZC
capable driver, but the uapi change is a NAK.

To reiterate; We'd like to get the queue setup/steering for AF_XDP
correct. I, and Magnus, dislike this approach. It requires a more
complicated XDP program, and is hard for regular users to understand.


Thanks,
Björn

[1] 
https://lore.kernel.org/bpf/CAJ8uoz2UHk+5xPwz-STM9gkQZdm7r_=jsgaB0nF+mHgch=axPg@mail.gmail.com/


> Maxim Mikityanskiy (16):
>    xsk: Add API to check for available entries in FQ
>    xsk: Add getsockopt XDP_OPTIONS
>    libbpf: Support getsockopt XDP_OPTIONS
>    xsk: Extend channels to support combined XSK/non-XSK traffic
>    xsk: Change the default frame size to 4096 and allow controlling it
>    xsk: Return the whole xdp_desc from xsk_umem_consume_tx
>    net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
>    net/mlx5e: Calculate linear RX frag size considering XSK
>    net/mlx5e: Allow ICO SQ to be used by multiple RQs
>    net/mlx5e: Refactor struct mlx5e_xdp_info
>    net/mlx5e: Share the XDP SQ for XDP_TX between RQs
>    net/mlx5e: XDP_TX from UMEM support
>    net/mlx5e: Consider XSK in XDP MTU limit calculation
>    net/mlx5e: Encapsulate open/close queues into a function
>    net/mlx5e: Move queue param structs to en/params.h
>    net/mlx5e: Add XSK support
> 
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  12 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  15 +-
>   .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  | 147 +++-
>   .../ethernet/mellanox/mlx5/core/en/params.c   | 108 ++-
>   .../ethernet/mellanox/mlx5/core/en/params.h   |  87 ++-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 231 ++++--
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  36 +-
>   .../mellanox/mlx5/core/en/xsk/Makefile        |   1 +
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 192 +++++
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  27 +
>   .../mellanox/mlx5/core/en/xsk/setup.c         | 223 ++++++
>   .../mellanox/mlx5/core/en/xsk/setup.h         |  25 +
>   .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 108 +++
>   .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |  15 +
>   .../ethernet/mellanox/mlx5/core/en/xsk/umem.c | 252 +++++++
>   .../ethernet/mellanox/mlx5/core/en/xsk/umem.h |  34 +
>   .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +-
>   .../mellanox/mlx5/core/en_fs_ethtool.c        |  44 +-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c | 680 +++++++++++-------
>   .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  12 +-
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 104 ++-
>   .../ethernet/mellanox/mlx5/core/en_stats.c    | 115 ++-
>   .../ethernet/mellanox/mlx5/core/en_stats.h    |  30 +
>   .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  42 +-
>   .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  14 +-
>   drivers/net/ethernet/mellanox/mlx5/core/wq.h  |   5 -
>   include/net/xdp_sock.h                        |  27 +-
>   include/uapi/linux/if_xdp.h                   |  19 +
>   net/xdp/xsk.c                                 |  41 +-
>   net/xdp/xsk_queue.h                           |  14 +
>   samples/bpf/xdpsock_user.c                    |  52 +-
>   tools/include/uapi/linux/if_xdp.h             |  19 +
>   tools/lib/bpf/xsk.c                           | 131 +++-
>   tools/lib/bpf/xsk.h                           |   6 +-
>   35 files changed, 2389 insertions(+), 502 deletions(-)
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
>   create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
> 

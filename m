Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EF191347
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfHQV3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:29:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:56630 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfHQV3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:29:21 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6GB-0001cP-Gj; Sat, 17 Aug 2019 23:29:15 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6GB-000KEK-8O; Sat, 17 Aug 2019 23:29:15 +0200
Subject: Re: [PATCH bpf-next v4 0/8] add need_wakeup flag to the AF_XDP rings
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        kiran.patil@intel.com, axboe@kernel.dk,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aca27354-0418-7add-57af-cb0d411e537a@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:29:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 9:27 AM, Magnus Karlsson wrote:
> This patch set adds support for a new flag called need_wakeup in the
> AF_XDP Tx and fill rings. When this flag is set by the driver, it
> means that the application has to explicitly wake up the kernel Rx
> (for the bit in the fill ring) or kernel Tx (for bit in the Tx ring)
> processing by issuing a syscall. Poll() can wake up both and sendto()
> will wake up Tx processing only.
> 
> The main reason for introducing this new flag is to be able to
> efficiently support the case when application and driver is executing
> on the same core. Previously, the driver was just busy-spinning on the
> fill ring if it ran out of buffers in the HW and there were none to
> get from the fill ring. This approach works when the application and
> driver is running on different cores as the application can replenish
> the fill ring while the driver is busy-spinning. Though, this is a
> lousy approach if both of them are running on the same core as the
> probability of the fill ring getting more entries when the driver is
> busy-spinning is zero. With this new feature the driver now sets the
> need_wakeup flag and returns to the application. The application can
> then replenish the fill queue and then explicitly wake up the Rx
> processing in the kernel using the syscall poll(). For Tx, the flag is
> only set to one if the driver has no outstanding Tx completion
> interrupts. If it has some, the flag is zero as it will be woken up by
> a completion interrupt anyway. This flag can also be used in other
> situations where the driver needs to be woken up explicitly.
> 
> As a nice side effect, this new flag also improves the Tx performance
> of the case where application and driver are running on two different
> cores as it reduces the number of syscalls to the kernel. The kernel
> tells user space if it needs to be woken up by a syscall, and this
> eliminates many of the syscalls. The Rx performance of the 2-core case
> is on the other hand slightly worse, since there is a need to use a
> syscall now to wake up the driver, instead of the driver
> busy-spinning. It does waste less CPU cycles though, which might lead
> to better overall system performance.
> 
> This new flag needs some simple driver support. If the driver does not
> support it, the Rx flag is always zero and the Tx flag is always
> one. This makes any application relying on this feature default to the
> old behavior of not requiring any syscalls in the Rx path and always
> having to call sendto() in the Tx path.
> 
> For backwards compatibility reasons, this feature has to be explicitly
> turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
> that you always turn it on as it has a large positive performance
> impact for the one core case and does not degrade 2 core performance
> and actually improves it for Tx heavy workloads.
> 
> Here are some performance numbers measured on my local,
> non-performance optimized development system. That is why you are
> seeing numbers lower than the ones from Björn and Jesper. 64 byte
> packets at 40Gbit/s line rate. All results in Mpps. Cores == 1 means
> that both application and driver is executing on the same core. Cores
> == 2 that they are on different cores.
> 
>                                Applications
> need_wakeup  cores    txpush    rxdrop      l2fwd
> ---------------------------------------------------------------
>       n         1       0.07      0.06        0.03
>       y         1       21.6      8.2         6.5
>       n         2       32.3      11.7        8.7
>       y         2       33.1      11.7        8.7
> 
> Overall, the need_wakeup flag provides the same or better performance
> in all the micro-benchmarks. The reduction of sendto() calls in txpush
> is large. Only a few per second is needed. For l2fwd, the drop is 50%
> for the 1 core case and more than 99.9% for the 2 core case. Do not
> know why I am not seeing the same drop for the 1 core case yet.
> 
> The name and inspiration of the flag has been taken from io_uring by
> Jens Axboe. Details about this feature in io_uring can be found in
> http://kernel.dk/io_uring.pdf, section 8.3. It also addresses most of
> the denial of service and sendto() concerns raised by Maxim
> Mikityanskiy in https://www.spinics.net/lists/netdev/msg554657.html.
> 
> The typical Tx part of an application will have to change from:
> 
> ret = sendto(fd,....)
> 
> to:
> 
> if (xsk_ring_prod__needs_wakeup(&xsk->tx))
>         ret = sendto(fd,....)
> 
> and th Rx part from:
> 
> rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> if (!rcvd)
>         return;
> 
> to:
> 
> rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> if (!rcvd) {
>         if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
>                ret = poll(fd,.....);
>         return;
> }
> 
> v3 -> v4:
> * Maxim found a possible race in the Tx part of the driver. The
>    setting of the flag needs to happen before the sending, otherwise it
>    might trigger this race. Fixed in ixgbe and i40e driver.
> * Mellanox support contributed by Maxim
> * Removed the XSK_DRV_CAN_SLEEP flag as it was not used
>    anymore. Thanks to Sridhar for discovering this.
> * For consistency the feature is now always called need_wakeup. There
>    were some places where it was referred to as might_sleep, but they
>    have been removed. Thanks to Sridhar for spotting.
> * Fixed some typos in the commit messages
> 
> v2 -> v3:
> * Converted the Mellanox driver to the new ndo in patch 1 as pointed out
>    by Maxim
> * Fixed the compatibility code of XDP_MMAP_OFFSETS so it now works.
> 
> v1 -> v2:
> * Fixed bisectability problem pointed out by Jakub
> * Added missing initiliztion of the Tx need_wakeup flag to 1
> 
> This patch has been applied against commit b753c5a7f99f ("Merge branch 'r8152-RX-improve'")
> 
> Structure of the patch set:
> 
> Patch 1: Replaces the ndo_xsk_async_xmit with ndo_xsk_wakeup to
>           support waking up both Rx and Tx processing
> Patch 2: Implements the need_wakeup functionality in common code
> Patch 3-4: Add need_wakeup support to the i40e and ixgbe drivers
> Patch 5: Add need_wakeup support to libbpf
> Patch 6: Add need_wakeup support to the xdpsock sample application
> Patch 7-8: Add need_wakeup support to the Mellanox mlx5 driver
> 
> Thanks: Magnus
> 
> Magnus Karlsson (6):
>    xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
>    xsk: add support for need_wakeup flag in AF_XDP rings
>    i40e: add support for AF_XDP need_wakeup feature
>    ixgbe: add support for AF_XDP need_wakeup feature
>    libbpf: add support for need_wakeup flag in AF_XDP part
>    samples/bpf: add use of need_wakeup flag in xdpsock
> 
> Maxim Mikityanskiy (2):
>    net/mlx5e: Move the SW XSK code from NAPI poll to a separate function
>    net/mlx5e: Add AF_XDP need_wakeup support
> 
>   drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  25 ++-
>   drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
>   .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  22 ++-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  14 ++
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |  14 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  27 ++-
>   include/linux/netdevice.h                          |  14 +-
>   include/net/xdp_sock.h                             |  33 +++-
>   include/uapi/linux/if_xdp.h                        |  13 ++
>   net/xdp/xdp_umem.c                                 |  12 +-
>   net/xdp/xsk.c                                      | 149 +++++++++++++---
>   net/xdp/xsk.h                                      |  13 ++
>   net/xdp/xsk_queue.h                                |   1 +
>   samples/bpf/xdpsock_user.c                         | 192 +++++++++++++--------
>   tools/include/uapi/linux/if_xdp.h                  |  13 ++
>   tools/lib/bpf/xsk.c                                |   4 +
>   tools/lib/bpf/xsk.h                                |   6 +
>   23 files changed, 462 insertions(+), 115 deletions(-)
> 
> --
> 2.7.4
> 

Series applied, thanks everyone!

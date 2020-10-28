Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5507129D2C2
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgJ1Vem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:34:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42927 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgJ1Vei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:34:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id s22so571852pga.9
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=smW0Uu5AYT0CbDiMXTsNP0m2Ye5AeJ3ok8/XC5RGM+Y=;
        b=Lei/xwIULrLyJ4qK1cvb3RKgISU958FgpCNryrAPHyJ48fBNRXFrVy/VN8BRnyBTQV
         LQPSP3lIBSfFZsan+T3i8Cbiyy1/vGBJLAzO5358TGkFggRQ/GuU6s3FqjhnlXHsRGR3
         aJAmx3w+i7zcVKNLEjYbb5GD8aej8hzmYXLWwbBvrmzf2WjZ8yCPHa7UTOFd++lR8fJt
         XuK1OktkYuYbadBKPTjNMXvJJYr0TO83b8lQ09unT3ih0UClReu6MNvwFyv55UiniaLv
         LiUbFEvYvjRLySHhNxH0+9ic+5wgBmP1nZzEtcr3rW8dvDCA3I0EyS6nrHkVvNWm8ozO
         UWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=smW0Uu5AYT0CbDiMXTsNP0m2Ye5AeJ3ok8/XC5RGM+Y=;
        b=bGTRVhddRG2IkkiL0s4crTcxOvkQfLy7eNfuaMIQ/aGbWm7AqNmPG0F5DAEJiYxQTp
         1MwxmZ8BlVfhEBpaINmuzmG2XnaS8wJ3dhKdkyVawQvjzdj52dHpCUJzqJ2vsK8lmRaw
         cdTl2ly+mgNZ0qoKar+jm2L/PfjkdOsJUT59fGSRsbZ0re0dk1nd5pxwnKmnjocwaj3L
         mJKRCW/q9JLKH9v3C3ERWx3sG4Ndfrz3COCd70BE3t16k1xlJNmM4NlwBH9RPzu/zy8M
         vM6UOHrMc/7bwI40HFRHbWsu+msL9kCGT9mh183cDm5iNXVrcnSEhi0tFNJwVXrvmzbW
         Tcjw==
X-Gm-Message-State: AOAM532Wm0AW/21QnB1Fmi+fki7e+LtIWhwiTITlWaLnD6BHYyqOhdSi
        q9mUPA6jo+ZMFYmgIHFLiOI8zdq3EdFYktvOHcYag0jSdOo7mA==
X-Google-Smtp-Source: ABdhPJzJO0N2+hIbIX+FF7H3RMPaSMzS1HRK/UtcpDxwLJHdhBI5zyOxHDIUXPzDykjjitziGQR4phJvJbOviEInlNE=
X-Received: by 2002:a05:6e02:14c9:: with SMTP id o9mr6031068ilk.137.1603894395447;
 Wed, 28 Oct 2020 07:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Oct 2020 15:13:04 +0100
Message-ID: <CANn89iLpwne8P+E4p+wD92xB0LP4WridLUhPQTx1CeDF-D+LdA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/9] Introduce biased busy-polling
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        maciej.fijalkowski@intel.com,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        qi.z.zhang@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 2:35 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> Jakub suggested in [1] a "strict busy-polling mode with out
> interrupts". This is a first stab at that.
>
> This series adds a new NAPI mode, called biased busy-polling, which is
> an extension to the existing busy-polling mode. The new mode is
> enabled on the socket layer, where a socket setting this option
> "promisies" to busy-poll the NAPI context via a system call. When this
> mode is enabled, the NAPI context will operate in a mode with
> interrupts disabled. The kernel monitors that the busy-polling promise
> is fulfilled by an internal watchdog. If the socket fail/stop
> performing the busy-polling, the mode will be disabled.
>
> Biased busy-polling follows the same mechanism as the existing
> busy-poll; The napi_id is reported to the socket via the skbuff. Later
> commits will extend napi_id reporting to XDP, in order to work
> correctly with XDP sockets.
>
> Let us walk through a flow of execution:
>
> 1. A socket sets the new SO_BIAS_BUSY_POLL socket option to true. The
>    socket now shows an intent of doing busy-polling. No data has been
>    received to the socket, so the napi_id of the socket is still 0
>    (non-valid). As usual for busy-polling, the SO_BUSY_POLL option
>    also has to be non-zero for biased busy-polling.
>
> 2. Data is received on the socket changing the napi_id to non-zero.
>
> 3. The socket does a system call that has the busy-polling logic wired
>    up, e.g. recvfrom() for UDP sockets. The NAPI context is now marked
>    as biased busy-poll. The kernel watchdog is armed. If the NAPI
>    context is already running, it will try to finish as soon as
>    possible and move to busy-polling. If the NAPI context is not
>    running, it will execute the NAPI poll function for the
>    corresponding napi_id.
>
> 4. Goto 3, or wait until the watchdog timeout.
>
> The series is outlined as following:
>   Patch 1-2: Biased busy-polling, and option to set busy-poll budget.
>   Patch 3-6: Busy-poll plumbing for XDP sockets
>   Patch 7-9: Add busy-polling support to the xdpsock sample
>
> Performance UDP sockets:
>
> I hacked netperf to use non-blocking sockets, and looping over
> recvfrom(). The following command-line was used:
>   $ netperf -H 192.168.1.1 -l 30 -t UDP_RR -v 2 -- \
>       -o min_latency,mean_latency,max_latency,stddev_latency,transaction_=
rate
>
> Non-blocking:
>   16,18.45,195,0.94,54070.369
> Non-blocking with biased busy-polling:
>   15,16.59,38,0.70,60086.313
>

But a fair comparison should be done using current busy-polling mode,
which does not require netperf to use non-blocking mode in the first place =
?

Would disabling/rearming interrupts about 60,000 times per second
bring any benefit ?


Additional questions :

- What happens to the gro_flush_timeout and accumulated TCP segments
in GRO engine
while the biased busy-polling is in use ?

- What mechanism would avoid a potential 200 ms latency when the
application wants to exit cleanly ?
  Presumably when/if SO_BIAS_BUSY_POLL is used to clear
sk->sk_bias_busy_poll we need
 to make sure device interrupts are re-enabled.


> Performance XDP sockets:
>
> Today, running XDP sockets sample on the same core as the softirq
> handling, performance tanks mainly because we do not yield to
> user-space when the XDP socket Rx queue is full.
>   # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r
>   Rx: 64Kpps
>
>   # # biased busy-polling, budget 8
>   # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 8
>   Rx 9.9Mpps
>   # # biased busy-polling, budget 64
>   # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 64
>   Rx: 19.3Mpps
>   # # biased busy-polling, budget 256
>   # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 256
>   Rx: 21.4Mpps
>   # # biased busy-polling, budget 512
>   # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 512
>   Rx: 21.4Mpps
>
> Compared to the two-core case:
>   # taskset -c 4 ./xdpsock -i ens785f1 -q 20 -n 1 -r
>   Rx: 20.7Mpps
>
> We're getting better single-core performance than two, for this na=C3=AFv=
e
> drop scenario.
>
> The above tests was done for the 'ice' driver.
>
> Some outstanding questions:
>
> * Does biased busy-polling make sense for non-XDP sockets? For a
>   dedicated queue, biased busy-polling has a strong case. When the
>   NAPI is shared with other sockets, it can affect the latencies of
>   sockets that were not explicity busy-poll enabled. Note that this
>   true for regular busy-polling as well, but the biased version is
>   stricter.
>
> * Currently busy-polling for UDP/TCP is only wired up in the recvmsg()
>   path. Does it make sense to extend that to sendmsg() as well?
>
> * Biased busy-polling only makes sense for non-blocking sockets. Reject
>   enabling of biased busy-polling unless the socket is non-blocking?
>
> * The watchdog is 200 ms. Should it be configurable?
>
> * Extending xdp_rxq_info_reg() with napi_id touches a lot of drivers,
>   and I've only verified the Intel ones. Some drivers initialize NAPI
>   (generating the napi_id) after the xdp_rxq_info_reg() call, which
>   maybe would open up for another API? I did not send this RFC to all
>   the driver authors. I'll do that for a patch proper series.
>
> * Today, enabling busy-polling require CAP_NET_ADMIN. For a NAPI
>   context that services multiple socket, this makes sense because one
>   socket can affect performance of other sockets. Now, for a
>   *dedicated* queue for say XDP socket, would it be OK to drop
>   CAP_NET_ADMIN, because it cannot affect other sockets/users?
>
> @Jakub Thanks for the early comments. I left the check in
> napi_schedule_prep(), because I hit that for the Intel i40e driver;
> forcing busy-polling on a core outside the interrupt affinity mask.
>
> [1] https://lore.kernel.org/netdev/20200925120652.10b8d7c5@kicinski-fedor=
a-pc1c0hjn.dhcp.thefacebook.com/
>
> Bj=C3=B6rn T=C3=B6pel (9):
>   net: introduce biased busy-polling
>   net: add SO_BUSY_POLL_BUDGET socket option
>   xsk: add support for recvmsg()
>   xsk: check need wakeup flag in sendmsg()
>   xsk: add busy-poll support for {recv,send}msg()
>   xsk: propagate napi_id to XDP socket Rx path
>   samples/bpf: use recvfrom() in xdpsock
>   samples/bpf: add busy-poll support to xdpsock
>   samples/bpf: add option to set the busy-poll budget
>
>  arch/alpha/include/uapi/asm/socket.h          |   3 +
>  arch/mips/include/uapi/asm/socket.h           |   3 +
>  arch/parisc/include/uapi/asm/socket.h         |   3 +
>  arch/sparc/include/uapi/asm/socket.h          |   3 +
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +-
>  .../ethernet/cavium/thunder/nicvf_queues.c    |   2 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   2 +-
>  drivers/net/ethernet/intel/ice/ice_base.c     |   4 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   2 +-
>  drivers/net/ethernet/marvell/mvneta.c         |   2 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   4 +-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   2 +-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   2 +-
>  drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +-
>  drivers/net/ethernet/sfc/rx_common.c          |   2 +-
>  drivers/net/ethernet/socionext/netsec.c       |   2 +-
>  drivers/net/ethernet/ti/cpsw_priv.c           |   2 +-
>  drivers/net/hyperv/netvsc.c                   |   2 +-
>  drivers/net/tun.c                             |   2 +-
>  drivers/net/veth.c                            |   2 +-
>  drivers/net/virtio_net.c                      |   2 +-
>  drivers/net/xen-netfront.c                    |   2 +-
>  fs/eventpoll.c                                |   3 +-
>  include/linux/netdevice.h                     |  33 +++---
>  include/net/busy_poll.h                       |  42 +++++--
>  include/net/sock.h                            |   4 +
>  include/net/xdp.h                             |   3 +-
>  include/uapi/asm-generic/socket.h             |   3 +
>  net/core/dev.c                                | 111 +++++++++++++++---
>  net/core/sock.c                               |  19 +++
>  net/core/xdp.c                                |   3 +-
>  net/xdp/xsk.c                                 |  36 +++++-
>  net/xdp/xsk_buff_pool.c                       |  13 +-
>  samples/bpf/xdpsock_user.c                    |  53 +++++++--
>  37 files changed, 296 insertions(+), 85 deletions(-)
>
>
> base-commit: 3cb12d27ff655e57e8efe3486dca2a22f4e30578
> --
> 2.27.0
>

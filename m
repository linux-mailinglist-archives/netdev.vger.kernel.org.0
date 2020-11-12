Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556B92B0424
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgKLLoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgKLLlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:20 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740EBC0617A7;
        Thu, 12 Nov 2020 03:41:07 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i7so3956159pgh.6;
        Thu, 12 Nov 2020 03:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6LuKh6kG4aKhAzeTlN40C2duY0X2X5x4aMnN8eJt1mo=;
        b=YVxA/lDJRqWKsE4EP1OGQNaVwjxrZp2nIO3G6n2eSMBYeV1o5Si+KeLNSlUH5Ze3cQ
         Lc8SLuDqv3TzFM1ZP4HjJbY5syd/SMu1ytvu5hv2WWjQmBxY5mszqr2kCcFts/7iGcqr
         sfrKmjh8EvnoZaGvMQBiC7dF6SlZ3xEfQcPIyP9DPat22WYhd7Tr+rTWYM0XzrYiZpX4
         VDbO7i3OP9mPAcQ9CLFBCy2S6kmyihLu9hpEVx5YQCDiLuybzIDYFeTFskHbuEr4wIvy
         KtByU20WpZ+xBik46k4KnEcD9zffJrYb5gud4Q9H0gi2ih/qziQazqH8P2RKZvNLHhbp
         2dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6LuKh6kG4aKhAzeTlN40C2duY0X2X5x4aMnN8eJt1mo=;
        b=EyHcTeR0ZNiQimbJI3s/ZrvRBWah0rP1CNTKxsRqcpBl0apS58y76+4RZAkUQzpioO
         rGChxHA0rQtn4UTH40jl0Fu/iSDJipNc55hWdz7djkG/Ic6S3NjwWY+nXsPwD35qWHdN
         rtWWoDpBKNkNu8EJX6jBlD4uAhcM2bPtj+gb0XLedVe9N4UbYoDkF/QNU87NPdzSpLQZ
         jbzFDDqRodRU6UE75msHXwHT696IcK6/UVa0TsXEHT5AMcg62Bk4NO7Vi1fvT6wTGe3e
         JAaBy+Qizm6a6+dYBHo2T0TmPaWOpLKKjiyWWR5xn+/vMvZa73M0ipgcEnNbuho5n/z8
         KaJQ==
X-Gm-Message-State: AOAM531OawhcJH5E1h7fi/QvgrG8h8nIOU2Zi4yfjYS9r6VMdnkhNB2C
        wvKrH4Jx7I/dMGrTJ+GEDzlUqrSCbNr9Ig==
X-Google-Smtp-Source: ABdhPJxj1Dj5DweLkn0tqxD1FwCT7yLFJZ1ImMS0YHGcI0bhB4zUjigGYXMeNryD3y/GYscHZnm4Yg==
X-Received: by 2002:a63:41c1:: with SMTP id o184mr5358504pga.221.1605181266004;
        Thu, 12 Nov 2020 03:41:06 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:04 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, maciej.fijalkowski@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        qi.z.zhang@intel.com, kuba@kernel.org, edumazet@google.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 0/9] Introduce preferred busy-polling
Date:   Thu, 12 Nov 2020 12:40:32 +0100
Message-Id: <20201112114041.131998-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces three new features:

1. A new "heavy traffic" busy-polling variant that works in concert
   with the existing napi_defer_hard_irqs and gro_flush_timeout knobs.

2. A new socket option that let a user change the busy-polling NAPI
   budget.

3. Allow busy-polling to be performed on XDP sockets.

The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
option or system-wide using the /proc/sys/net/core/busy_read knob, is
an opportunistic. That means that if the NAPI context is not
scheduled, it will poll it. If, after busy-polling, the budget is
exceeded the busy-polling logic will schedule the NAPI onto the
regular softirq handling.

One implication of the behavior above is that a busy/heavy loaded NAPI
context will never enter/allow for busy-polling. Some applications
prefer that most NAPI processing would be done by busy-polling.

This series adds a new socket option, SO_PREFER_BUSY_POLL, that works
in concert with the napi_defer_hard_irqs and gro_flush_timeout
knobs. The napi_defer_hard_irqs and gro_flush_timeout knobs were
introduced in commit 6f8b12d661d0 ("net: napi: add hard irqs deferral
feature"), and allows for a user to defer interrupts to be enabled and
instead schedule the NAPI context from a watchdog timer. When a user
enables the SO_PREFER_BUSY_POLL, again with the other knobs enabled,
and the NAPI context is being processed by a softirq, the softirq NAPI
processing will exit early to allow the busy-polling to be performed.

If the application stops performing busy-polling via a system call,
the watchdog timer defined by gro_flush_timeout will timeout, and
regular softirq handling will resume.

In summary; Heavy traffic applications that prefer busy-polling over
softirq processing should use this option.

Patch 6 touches a lot of drivers, so the Cc: list is grossly long.


Example usage:

  $ echo 2 | sudo tee /sys/class/net/ens785f1/napi_defer_hard_irqs
  $ echo 200000 | sudo tee /sys/class/net/ens785f1/gro_flush_timeout

Note that the timeout should be larger than the userspace processing
window, otherwise the watchdog will timeout and fall back to regular
softirq processing.

Enable the SO_BUSY_POLL/SO_PREFER_BUSY_POLL options on your socket.


Performance simple UDP ping-pong:

A packet generator blasts UDP packets from a packet generator to a
certain {src,dst}IP/port, so a dedicated ksoftirq will be busy
handling the packets at a certain core.

A simple UDP test program that simply does recvfrom/sendto is running
at the host end. Throughput in pps and RTT latency is measured at the
packet generator.

/proc/sys/net/core/busy_read is set (20).

Min       Max       Avg (usec)

1. Blocking 2-cores:                       490Kpps
 1218.192  1335.427  1271.083

2. Blocking, 1-core:                       155Kpps
 1327.195 17294.855  4761.367

3. Non-blocking, 2-cores:                  475Kpps
 1221.197  1330.465  1270.740

4. Non-blocking, 1-core:                     3Kpps
29006.482 37260.465 33128.367

5. Non-blocking, prefer busy-poll, 1-core: 420Kpps
 1202.535  5494.052  4885.443 

Scenario 2 and 5 shows when the new option should be used. Throughput
go from 155 to 420Kpps, average latency are similar, but the tail
latencies are much better for the latter.


Performance XDP sockets:

Again, a packet generator blasts UDP packets from a packet generator
to a certain {src,dst}IP/port.

Today, running XDP sockets sample on the same core as the softirq
handling, performance tanks mainly because we do not yield to
user-space when the XDP socket Rx queue is full.

  # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r
  Rx: 64Kpps
  
  # # biased busy-polling, budget 8
  # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 8
  Rx 9.9Mpps
  # # biased busy-polling, budget 64
  # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 64
  Rx: 19.3Mpps
  # # biased busy-polling, budget 256
  # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 256
  Rx: 21.4Mpps
  # # biased busy-polling, budget 512
  # taskset -c 5 ./xdpsock -i ens785f1 -q 5 -n 1 -r -B -b 512
  Rx: 21.7Mpps

Compared to the two-core case:
  # taskset -c 4 ./xdpsock -i ens785f1 -q 20 -n 1 -r
  Rx: 20.7Mpps

We're getting better single-core performance than two, for this naïve
drop scenario.


Performance netperf UDP_RR:

Note that netperf UDP_RR is not a heavy traffic tests, and preferred
busy-polling is not typically something we want to use here.

  $ echo 20 | sudo tee /proc/sys/net/core/busy_read
  $ netperf -H 192.168.1.1 -l 30 -t UDP_RR -v 2 -- \
      -o min_latency,mean_latency,max_latency,stddev_latency,transaction_rate

busy-polling blocking sockets:            12,13.33,224,0.63,74731.177

I hacked netperf to use non-blocking sockets and re-ran:

busy-polling non-blocking sockets:        12,13.46,218,0.72,73991.172
prefer busy-polling non-blocking sockets: 12,13.62,221,0.59,73138.448

Using the preferred busy-polling mode does not impact performance.

The above tests was done for the 'ice' driver.

Thanks to Jakub for suggesting this busy-polling addition [1], and
Eric for the input on the v1 RFC.


Changes:

rfc-v1 [2] -> rfc-v2:
  * Changed name from bias to prefer.
  * Base the work on Eric's/Luigi's defer irq/gro timeout work.
  * Proper GRO flushing.
  * Build issues for some XDP drivers.

rfc-v2 [3] -> v1:
  * Fixed broken qlogic build.
  * Do not trigger an IPI (XDP socket wakeup) when busy-polling is
    enabled.

[1] https://lore.kernel.org/netdev/20200925120652.10b8d7c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
[2] https://lore.kernel.org/bpf/20201028133437.212503-1-bjorn.topel@gmail.com/
[3] https://lore.kernel.org/bpf/20201105102812.152836-1-bjorn.topel@gmail.com/


Björn Töpel (9):
  net: introduce preferred busy-polling
  net: add SO_BUSY_POLL_BUDGET socket option
  xsk: add support for recvmsg()
  xsk: check need wakeup flag in sendmsg()
  xsk: add busy-poll support for {recv,send}msg()
  xsk: propagate napi_id to XDP socket Rx path
  samples/bpf: use recvfrom() in xdpsock
  samples/bpf: add busy-poll support to xdpsock
  samples/bpf: add option to set the busy-poll budget

 arch/alpha/include/uapi/asm/socket.h          |  3 +
 arch/mips/include/uapi/asm/socket.h           |  3 +
 arch/parisc/include/uapi/asm/socket.h         |  3 +
 arch/sparc/include/uapi/asm/socket.h          |  3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 drivers/net/ethernet/sfc/rx_common.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.c           |  2 +-
 drivers/net/hyperv/netvsc.c                   |  2 +-
 drivers/net/tun.c                             |  2 +-
 drivers/net/veth.c                            |  2 +-
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 fs/eventpoll.c                                |  3 +-
 include/linux/netdevice.h                     | 35 +++++---
 include/net/busy_poll.h                       | 27 ++++--
 include/net/sock.h                            |  4 +
 include/net/xdp.h                             |  3 +-
 include/uapi/asm-generic/socket.h             |  3 +
 net/core/dev.c                                | 89 ++++++++++++++-----
 net/core/sock.c                               | 19 ++++
 net/core/xdp.c                                |  3 +-
 net/xdp/xsk.c                                 | 52 ++++++++++-
 net/xdp/xsk_buff_pool.c                       | 13 ++-
 samples/bpf/xdpsock_user.c                    | 53 ++++++++---
 40 files changed, 278 insertions(+), 90 deletions(-)


base-commit: 09a3dac7b579e57e7ef2d875b9216c845ae8a0e5
-- 
2.27.0


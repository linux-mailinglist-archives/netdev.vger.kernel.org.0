Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB7B2B8D43
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKSIas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgKSIas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:30:48 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19307C0613CF;
        Thu, 19 Nov 2020 00:30:48 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b3so2538629pls.11;
        Thu, 19 Nov 2020 00:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lf/YP/DrOzPY2GJdVq4s42FbGv9vrKF5wYwDfV0jpPw=;
        b=hPgjrgT2kJFwKNj8jvl/x2/MCAxprra9RxXAHh/0koj3rV1+G7+177zVbMwuqdYsgy
         vnoSUgoB3rzTiqcRkXPbfhP5NeUteJ8pNdZVUj6GDX/tEw8uLymjcI5ITwChT5tRoOpQ
         aLDCCt9a0dy1Z7H1GlRfk/ZYC6b58ZQ0LREzYCGD9zn8dPV0ycOV6DT2c27pL17OFxGm
         PwDEkvoh930fWd/enPzO1swnnZ3g6ijOCJW2XP1VXG9RIVHL/UQXVoTvOzXQOCl4HrFf
         gVbDXjLZCINDfzkkrBzE1p4o53+Gsfx6a1eUjS5iQC85JHhTkpfESgoluP0/xW2HYkRx
         Whsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lf/YP/DrOzPY2GJdVq4s42FbGv9vrKF5wYwDfV0jpPw=;
        b=CqFS4d0VBwfRZwVt5kH4mSZkPjb/3ZfgEVxsFfQwua7/xoY7EPL6aDQJ8AdgcezLMC
         O82EtzuaeUJfx6H8P6AK0F2+J36PU916SNhF2OHFggGaVvNwRv3NnPYRdbzKfEMebziI
         UaZ2HpeVB3w0Uf9SNzC8OkoqC7FslLihawrtE2pUQjF5Weqg3I4vkBsovApKsN82by0n
         v+qlyMXhTqxFhmkTMFeA0bEN4nn82ON3T6NEki9fcfsYWGQeZ2J8NiMlsE7RBez10PpC
         WCi8PY3jtKLTxjC9uQB5rxRcu6pOnrDKjqyesc0Ea3lsbydN9R/rp5eWhwN6mp/C/q5C
         YTNw==
X-Gm-Message-State: AOAM533nEh1RyZ3z1nwqDpIs9iKBfhSU0YSQ3vTRtI67yJ5If6xhN84N
        d/QFJGIArU1rHZy79mdu9tjpm+zRA434xp7V
X-Google-Smtp-Source: ABdhPJy0KuIBUzdTKS9P3e+CgrPEQEpftTyLgFwXH6aW3MAsbbgNDRm9QS8lZ4SOLKfDIf14wLTRDg==
X-Received: by 2002:a17:902:7785:b029:d6:cf21:69ef with SMTP id o5-20020a1709027785b02900d6cf2169efmr8188923pll.58.1605774646796;
        Thu, 19 Nov 2020 00:30:46 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:30:45 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, maciej.fijalkowski@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        qi.z.zhang@intel.com, kuba@kernel.org, edumazet@google.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 00/10] Introduce preferred busy-polling
Date:   Thu, 19 Nov 2020 09:30:14 +0100
Message-Id: <20201119083024.119566-1-bjorn.topel@gmail.com>
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
Eric for all input/review!


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

v1 [4] -> v2:
  * Added napi_id to socionext driver, and added Ilias Acked-by:. (Ilias)
  * Added a samples patch to improve busy-polling for xdpsock/l2fwd.
  * Correctly mark atomic operations with {WRITE,READ}_ONCE, to make
    KCSAN and the code readers happy. (Eric)
  * Check NAPI budget not to exceed U16_MAX. (Eric)
  * Added kdoc.

v2 [5] -> v3:
  * Collected Acked-by:.
  * Check NAPI disable prior prefer busy-polling. (Jakub)
  * Added napi_id registration for virtio-net. (Michael)
  * Added napi_id registration for veth.

[1] https://lore.kernel.org/netdev/20200925120652.10b8d7c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
[2] https://lore.kernel.org/bpf/20201028133437.212503-1-bjorn.topel@gmail.com/
[3] https://lore.kernel.org/bpf/20201105102812.152836-1-bjorn.topel@gmail.com/
[4] https://lore.kernel.org/bpf/20201112114041.131998-1-bjorn.topel@gmail.com/
[5] https://lore.kernel.org/bpf/20201116110416.10719-1-bjorn.topel@gmail.com/

Björn Töpel (10):
  net: introduce preferred busy-polling
  net: add SO_BUSY_POLL_BUDGET socket option
  xsk: add support for recvmsg()
  xsk: check need wakeup flag in sendmsg()
  xsk: add busy-poll support for {recv,send}msg()
  xsk: propagate napi_id to XDP socket Rx path
  samples/bpf: use recvfrom() in xdpsock/rxdrop
  samples/bpf: use recvfrom() in xdpsock/l2fwd
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
 drivers/net/veth.c                            | 12 ++-
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 fs/eventpoll.c                                |  3 +-
 include/linux/netdevice.h                     | 35 +++++---
 include/net/busy_poll.h                       | 27 ++++--
 include/net/sock.h                            |  6 ++
 include/net/xdp.h                             |  3 +-
 include/uapi/asm-generic/socket.h             |  3 +
 net/core/dev.c                                | 89 ++++++++++++++-----
 net/core/sock.c                               | 19 ++++
 net/core/xdp.c                                |  3 +-
 net/xdp/xsk.c                                 | 53 ++++++++++-
 net/xdp/xsk_buff_pool.c                       | 13 ++-
 samples/bpf/xdpsock_user.c                    | 78 ++++++++++------
 40 files changed, 299 insertions(+), 107 deletions(-)


base-commit: 4e99d115d865d45e17e83478d757b58d8fa66d3c
-- 
2.27.0


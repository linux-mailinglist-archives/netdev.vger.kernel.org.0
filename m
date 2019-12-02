Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF44B10E401
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 01:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfLBAFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 19:05:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfLBAFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 19:05:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E27DD15008C80;
        Sun,  1 Dec 2019 16:05:20 -0800 (PST)
Date:   Sun, 01 Dec 2019 16:05:18 -0800 (PST)
Message-Id: <20191201.160518.50010694947236666.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 16:05:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix several scatter gather list issues in kTLS code, from Jakub
   Kicinski.

2) macb driver device remove has to kill the hresp_err_tasklet.  From
   Chuhong Yuan.

3) Several memory leak and reference count bug fixes in tipc, from
   Tung Nguyen.

4) Fix mlx5 build error w/o ipv6, from Yue Haibing.

5) Fix jumbo frame and other regressions in r8169, from Heiner
   Kallweit.

6) Undo some BUG_ON()'s and replace them with WARN_ON_ONCE and
   proper error propagation/handling.  From Paolo Abeni.

Please pull, thanks a lot!

The following changes since commit 81b6b96475ac7a4ebfceae9f16fb3758327adbfe:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux; tag 'dma-mapping-5.5' of git://git.infradead.org/users/hch/dma-mapping (2019-11-28 11:16:43 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to c5d728113532c695c894c2a88a10453ac83b0f3b:

  Merge branch 'openvswitch-remove-a-couple-of-BUG_ON' (2019-12-01 13:21:24 -0800)

----------------------------------------------------------------
Chuhong Yuan (1):
      net: macb: add missed tasklet_kill

David S. Miller (3):
      Merge branch 'net-tls-fix-scatter-gather-list-issues'
      Merge branch 'tipc-Fix-some-bugs-at-socket-layer'
      Merge branch 'openvswitch-remove-a-couple-of-BUG_ON'

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Grygorii Strashko (1):
      net: ethernet: ti: ale: ensure vlan/mdb deleted when no members

Heiner Kallweit (3):
      r8169: fix jumbo configuration for RTL8168evl
      r8169: fix resume on cable plug-in
      net: phy: realtek: fix using paged operations with RTL8105e / RTL8208

Jakub Kicinski (8):
      net/tls: take into account that bpf_exec_tx_verdict() may free the record
      net/tls: free the record on encryption error
      net: skmsg: fix TLS 1.3 crash with full sk_msg
      selftests/tls: add a test for fragmented messages
      net/tls: remove the dead inplace_crypto code
      net/tls: use sg_next() to walk sg entries
      selftests: bpf: test_sockmap: handle file creation failures gracefully
      selftests: bpf: correct perror strings

Jiri Pirko (1):
      selftests: forwarding: fix race between packet receive and tc check

Paolo Abeni (2):
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Randy Dunlap (1):
      net: emulex: benet: indent a Kconfig depends continuation line

Thadeu Lima de Souza Cascardo (1):
      selftests: pmtu: use -oneline for ip route list cache

Tung Nguyen (4):
      tipc: fix potential memory leak in __tipc_sendmsg()
      tipc: fix wrong socket reference counter after tipc_sk_timeout() returns
      tipc: fix wrong timeout input for tipc_wait_for_cond()
      tipc: fix duplicate SYN messages under link congestion

YueHaibing (1):
      net/mlx5e: Fix build error without IPV6

 drivers/net/ethernet/cadence/macb_main.c            |  1 +
 drivers/net/ethernet/emulex/benet/Kconfig           |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 74 ++++++++++++++++++++++++++++++++++++++------------------------------------
 drivers/net/ethernet/realtek/r8169_main.c           |  3 ++-
 drivers/net/ethernet/ti/cpsw_ale.c                  | 12 +++++++++---
 drivers/net/phy/realtek.c                           |  9 +++++++++
 include/linux/skmsg.h                               | 28 ++++++++++++++--------------
 include/net/tls.h                                   |  3 +--
 net/core/filter.c                                   |  8 ++++----
 net/core/skmsg.c                                    |  2 +-
 net/ipv4/tcp_bpf.c                                  |  2 +-
 net/openvswitch/datapath.c                          | 11 +++++++++--
 net/sched/sch_mq.c                                  |  3 ++-
 net/sched/sch_mqprio.c                              |  4 ++--
 net/sched/sch_multiq.c                              |  2 +-
 net/sched/sch_prio.c                                |  2 +-
 net/tipc/socket.c                                   | 24 +++++++++++++++---------
 net/tls/tls_main.c                                  | 13 ++-----------
 net/tls/tls_sw.c                                    | 32 +++++++++++++++++++-------------
 tools/testing/selftests/bpf/test_sockmap.c          | 47 ++++++++++++++++++++++++++++-------------------
 tools/testing/selftests/bpf/xdping.c                |  2 +-
 tools/testing/selftests/net/forwarding/tc_common.sh | 39 +++++++++++++++++++++++++++++++--------
 tools/testing/selftests/net/pmtu.sh                 |  5 ++---
 tools/testing/selftests/net/tls.c                   | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 24 files changed, 254 insertions(+), 134 deletions(-)

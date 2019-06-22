Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8784F30D
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 03:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFVBVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 21:21:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFVBVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 21:21:39 -0400
Received: from localhost (unknown [50.234.174.228])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4758153B136F;
        Fri, 21 Jun 2019 18:21:38 -0700 (PDT)
Date:   Fri, 21 Jun 2019 21:21:37 -0400 (EDT)
Message-Id: <20190621.212137.1249209897243384684.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Jun 2019 18:21:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix leak of unqueued fragments in ipv6 nf_defrag, from Guillaume
   Nault.

2) Don't access the DDM interface unless the transceiver implements
   it in bnx2x, from Mauro S. M. Rodrigues.

3) Don't double fetch 'len' from userspace in sock_getsockopt(), from
   JingYi Hou.

4) Sign extension overflow in lio_core, from Colin Ian King.

5) Various netem bug fixes wrt. corrupted packets from Jakub
   Kicinski.

6) Fix epollout hang in hvsock, from Sunil Muthuswamy.

7) Fix regression in default fib6_type, from David Ahern.

8) Handle memory limits in tcp_fragment more appropriately,
   from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 29f785ff76b65696800b75c3d8e0b58e603bb1d0:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2019-06-17 16:28:28 -0700)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to b6653b3629e5b88202be3c9abc44713973f5c4b4:

  tcp: refine memory limit test in tcp_fragment() (2019-06-21 20:58:42 -0400)

----------------------------------------------------------------
Colin Ian King (1):
      net: lio_core: fix potential sign-extension overflow on large shift

David Ahern (1):
      ipv6: Default fib6_type to RTN_UNICAST when not set

David S. Miller (4):
      Merge branch 'net-fix-quite-a-few-dst_cache-crashes-reported-by-syzbot'
      Merge branch 'net-netem-fix-issues-with-corrupting-GSO-frames'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'af_iucv-fixes'

Eric Dumazet (2):
      inet: clear num_timeout reqsk_alloc()
      tcp: refine memory limit test in tcp_fragment()

Fei Li (1):
      tun: wake up waitqueues after IFF_UP is set

Fred Klassen (1):
      net/udp_gso: Allow TX timestamp with UDP GSO

Guillaume Nault (2):
      netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
      netfilter: ipv6: nf_defrag: accept duplicate fragments again

Jakub Kicinski (2):
      net: netem: fix backlog accounting for corrupted GSO frames
      net: netem: fix use after free and double free with packet corruption

JingYi Hou (1):
      net: remove duplicate fetch in sock_getsockopt

Julian Wiedmann (3):
      net/af_iucv: remove GFP_DMA restriction for HiperTransport
      net/af_iucv: build proper skbs for HiperTransport
      net/af_iucv: always register net_device notifier

Krzysztof Kozlowski (1):
      net: hns3: Fix inconsistent indenting

Mauro S. M. Rodrigues (1):
      bnx2x: Check if transceiver implements DDM before access

Nathan Huckleberry (1):
      net: mvpp2: debugfs: Add pmap to fs dump

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix module autoload with inet family

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: fix shift of FID bits in mv88e6185_g1_vtu_loadpurge()

Sunil Muthuswamy (1):
      hvsock: fix epollout hang from race condition

Tuong Lien (1):
      tipc: fix issues with early FAILOVER_MSG from peer

Xin Long (3):
      ip_tunnel: allow not to count pkts on tstats by setting skb's dev to NULL
      ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL
      tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

 drivers/net/dsa/mv88e6xxx/global1_vtu.c             |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c |  3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h    |  1 +
 drivers/net/ethernet/cavium/liquidio/lio_core.c     |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c     |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c  |  3 +++
 drivers/net/tun.c                                   | 19 +++++++++----------
 include/net/ip6_tunnel.h                            |  9 ++++++---
 include/net/request_sock.h                          |  3 +++
 net/core/sock.c                                     |  3 ---
 net/ipv4/inet_connection_sock.c                     |  4 ----
 net/ipv4/ip_tunnel_core.c                           |  9 ++++++---
 net/ipv4/tcp_fastopen.c                             |  4 ----
 net/ipv4/tcp_output.c                               |  3 ++-
 net/ipv4/udp_offload.c                              |  5 +++++
 net/ipv6/netfilter/nf_conntrack_reasm.c             | 22 ++++++++++++----------
 net/ipv6/route.c                                    |  2 +-
 net/iucv/af_iucv.c                                  | 49 ++++++++++++++++++++++++++++++++++++-------------
 net/netfilter/nft_masq.c                            |  3 +--
 net/netfilter/nft_redir.c                           |  3 +--
 net/sched/sch_netem.c                               | 26 ++++++++++++++------------
 net/tipc/link.c                                     |  1 -
 net/tipc/node.c                                     | 10 +++++++---
 net/tipc/udp_media.c                                |  8 +++-----
 net/vmw_vsock/hyperv_transport.c                    | 39 ++++++++-------------------------------
 25 files changed, 123 insertions(+), 112 deletions(-)

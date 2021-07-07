Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5783BEBE7
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGGQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55096 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhGGQV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:29 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C3FA61836;
        Wed,  7 Jul 2021 18:18:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 00/11] Netfilter fixes for net
Date:   Wed,  7 Jul 2021 18:18:33 +0200
Message-Id: <20210707161844.20827-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Do not refresh timeout in SYN_SENT for syn retransmissions.
   Add selftest for unreplied TCP connection, from Florian Westphal.

2) Fix null dereference from error path with hardware offload
   in nftables.

3) Remove useless nf_ct_gre_keymap_flush() from netns exit path,
   from Vasily Averin.

4) Missing rcu read-lock side in ctnetlink helper info dump,
   also from Vasily.

5) Do not mark RST in the reply direction coming after SYN packet
   for an out-of-sync entry, from Ali Abdallah and Florian Westphal.

6) Add tcp_ignore_invalid_rst sysctl to allow to disable out of
   segment RSTs, from Ali.

7) KCSAN fix for nf_conntrack_all_lock(), from Manfred Spraul.

8) Honor NFTA_LAST_SET in nft_last.

9) Fix incorrect arithmetics when restore last_jiffies in nft_last.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5140aaa4604ba96685dc04b4d2dde3384bbaecef:

  s390: iucv: Avoid field over-reading memcpy() (2021-07-01 15:54:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d322957ebfb9c21c2c72b66680f7c3ccd724e081:

  netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h (2021-07-07 17:39:15 +0200)

----------------------------------------------------------------
Ali Abdallah (2):
      netfilter: conntrack: improve RST handling when tuple is re-used
      netfilter: conntrack: add new sysctl to disable RST check

Colin Ian King (1):
      netfilter: nf_tables: Fix dereference of null pointer flow

Duncan Roe (1):
      netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h

Florian Westphal (2):
      selftest: netfilter: add test case for unreplied tcp connections
      netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

Manfred Spraul (1):
      netfilter: conntrack: Mark access for KCSAN

Pablo Neira Ayuso (2):
      netfilter: nft_last: honor NFTA_LAST_SET on restoration
      netfilter: nft_last: incorrect arithmetics when restoring last used

Vasily Averin (2):
      netfilter: conntrack: nf_ct_gre_keymap_flush() removal
      netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

 Documentation/networking/nf_conntrack-sysctl.rst   |   6 +
 include/net/netfilter/nf_conntrack_core.h          |   1 -
 include/net/netns/conntrack.h                      |   1 +
 include/uapi/linux/netfilter/nfnetlink_log.h       |   2 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h     |   4 +-
 net/netfilter/nf_conntrack_core.c                  |  11 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +
 net/netfilter/nf_conntrack_proto.c                 |   7 -
 net/netfilter/nf_conntrack_proto_gre.c             |  13 --
 net/netfilter/nf_conntrack_proto_tcp.c             |  69 ++++++---
 net/netfilter/nf_conntrack_standalone.c            |  10 ++
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/netfilter/nft_last.c                           |  12 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_tcp_unreplied.sh | 167 +++++++++++++++++++++
 15 files changed, 262 insertions(+), 49 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh

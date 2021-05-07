Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9F37699D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEGRsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49084 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhEGRso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:44 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 67A456414B;
        Fri,  7 May 2021 19:46:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] Netfilter fixes for net
Date:   Fri,  7 May 2021 19:47:31 +0200
Message-Id: <20210507174739.1850-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for your net tree:

1) Add SECMARK revision 1 to fix incorrect layout that prevents
   from remove rule with this target, from Phil Sutter.

2) Fix pernet exit path spat in arptables, from Florian Westphal.

3) Missing rcu_read_unlock() for unknown nfnetlink callbacks,
   reported by syzbot, from Eric Dumazet.

4) Missing check for skb_header_pointer() NULL pointer in
   nfnetlink_osf.

5) Remove BUG_ON() after skb_header_pointer() from packet path
   in several conntrack helper and the TCP tracker.

6) Fix memleak in the new object error path of userdata.

7) Avoid overflows in nft_hash_buckets(), reported by syzbot,
   also from Eric.

8) Avoid overflows in 32bit arches, from Eric.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit bd1af6b5fffd36c12997bd48d61d39dc5796fa7b:

  Documentation: ABI: sysfs-class-net-qmi: document pass-through file (2021-05-03 13:40:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 6c8774a94e6ad26f29ef103c8671f55c255c6201:

  netfilter: nftables: avoid potential overflows on 32bit arches (2021-05-07 10:01:39 +0200)

----------------------------------------------------------------
Eric Dumazet (3):
      netfilter: nfnetlink: add a missing rcu_read_unlock()
      netfilter: nftables: avoid overflows in nft_hash_buckets()
      netfilter: nftables: avoid potential overflows on 32bit arches

Florian Westphal (1):
      netfilter: arptables: use pernet ops struct during unregister

Pablo Neira Ayuso (4):
      netfilter: xt_SECMARK: add new revision to fix structure layout
      netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
      netfilter: remove BUG_ON() after skb_header_pointer()
      netfilter: nftables: Fix a memleak from userdata error path in new objects

 include/linux/netfilter_arp/arp_tables.h  |  3 +-
 include/uapi/linux/netfilter/xt_SECMARK.h |  6 +++
 net/ipv4/netfilter/arp_tables.c           |  5 +-
 net/ipv4/netfilter/arptable_filter.c      |  2 +-
 net/netfilter/nf_conntrack_ftp.c          |  5 +-
 net/netfilter/nf_conntrack_h323_main.c    |  3 +-
 net/netfilter/nf_conntrack_irc.c          |  5 +-
 net/netfilter/nf_conntrack_pptp.c         |  4 +-
 net/netfilter/nf_conntrack_proto_tcp.c    |  6 ++-
 net/netfilter/nf_conntrack_sane.c         |  5 +-
 net/netfilter/nf_tables_api.c             | 11 ++--
 net/netfilter/nfnetlink.c                 |  1 +
 net/netfilter/nfnetlink_osf.c             |  2 +
 net/netfilter/nft_set_hash.c              | 20 ++++---
 net/netfilter/xt_SECMARK.c                | 88 ++++++++++++++++++++++++-------
 15 files changed, 124 insertions(+), 42 deletions(-)

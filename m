Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EECD4AF2DD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiBINgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiBINgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:22 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36EA3C0613CA;
        Wed,  9 Feb 2022 05:36:23 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E1316601C9;
        Wed,  9 Feb 2022 14:36:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/14] Netfilter updates for net-next
Date:   Wed,  9 Feb 2022 14:36:02 +0100
Message-Id: <20220209133616.165104-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Conntrack sets on CHECKSUM_UNNECESSARY for UDP packet with no checksum,
   from Kevin Mitchell.

2) skb->priority support for nfqueue, from Nicolas Dichtel.

3) Remove conntrack extension register API, from Florian Westphal.

4) Move nat destroy hook to nf_nat_hook instead, to remove
   nf_ct_ext_destroy(), also from Florian.

5) Wrap pptp conntrack NAT hooks into single structure, from Florian Westphal.

6) Support for tcp option set to noop for nf_tables, also from Florian.

7) Do not run x_tables comment match from packet path in nf_tables,
   from Florian Westphal.

8) Replace spinlock by cmpxchg() loop to update missed ct event,
   from Florian Westphal.

9) Wrap cttimeout hooks into single structure, from Florian.

10) Add fast nft_cmp expression for up to 16-bytes.

11) Use cb->ctx to store context in ctnetlink dump, instead of using
    cb->args[], from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 41414c9bdbb87cc5fbeee7dfc33137a96710fcac:

  net: lan966x: use .mac_select_pcs() interface (2022-02-03 19:11:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 5948ed297eefe927628e43b5142ccde691a130fd:

  netfilter: ctnetlink: use dump structure instead of raw args (2022-02-09 12:07:16 +0100)

----------------------------------------------------------------
Florian Westphal (10):
      netfilter: conntrack: make all extensions 8-byte alignned
      netfilter: conntrack: move extension sizes into core
      netfilter: conntrack: handle ->destroy hook via nat_ops instead
      netfilter: conntrack: remove extension register api
      netfilter: conntrack: pptp: use single option structure
      netfilter: exthdr: add support for tcp option removal
      netfilter: nft_compat: suppress comment match
      netfilter: ecache: don't use nf_conn spinlock
      netfilter: cttimeout: use option structure
      netfilter: ctnetlink: use dump structure instead of raw args

Kevin Mitchell (1):
      netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY

Nicolas Dichtel (2):
      netfilter: nfqueue: enable to get skb->priority
      nfqueue: enable to set skb->priority

Pablo Neira Ayuso (1):
      netfilter: nft_cmp: optimize comparison for 16-bytes

 include/linux/netfilter.h                      |   1 +
 include/linux/netfilter/nf_conntrack_pptp.h    |  38 ++++---
 include/net/netfilter/nf_conntrack_acct.h      |   1 -
 include/net/netfilter/nf_conntrack_ecache.h    |  15 +--
 include/net/netfilter/nf_conntrack_extend.h    |  18 +---
 include/net/netfilter/nf_conntrack_labels.h    |   3 -
 include/net/netfilter/nf_conntrack_seqadj.h    |   3 -
 include/net/netfilter/nf_conntrack_timeout.h   |  20 ++--
 include/net/netfilter/nf_conntrack_timestamp.h |  13 ---
 include/net/netfilter/nf_tables_core.h         |   9 ++
 include/uapi/linux/netfilter/nfnetlink_queue.h |   1 +
 net/ipv4/netfilter/nf_nat_pptp.c               |  24 ++---
 net/netfilter/nf_conntrack_acct.c              |  19 ----
 net/netfilter/nf_conntrack_core.c              |  94 +++---------------
 net/netfilter/nf_conntrack_ecache.c            |  47 +++------
 net/netfilter/nf_conntrack_extend.c            | 132 ++++++++++++++-----------
 net/netfilter/nf_conntrack_helper.c            |  17 ----
 net/netfilter/nf_conntrack_labels.c            |  20 +---
 net/netfilter/nf_conntrack_netlink.c           |  36 ++++---
 net/netfilter/nf_conntrack_pptp.c              |  60 ++++-------
 net/netfilter/nf_conntrack_proto_udp.c         |   4 +-
 net/netfilter/nf_conntrack_seqadj.c            |  16 ---
 net/netfilter/nf_conntrack_timeout.c           |  50 +++-------
 net/netfilter/nf_conntrack_timestamp.c         |  20 ----
 net/netfilter/nf_nat_core.c                    |  28 +-----
 net/netfilter/nf_synproxy_core.c               |  24 +----
 net/netfilter/nf_tables_core.c                 |  16 +++
 net/netfilter/nfnetlink_cttimeout.c            |  11 ++-
 net/netfilter/nfnetlink_queue.c                |  13 +++
 net/netfilter/nft_cmp.c                        | 102 ++++++++++++++++++-
 net/netfilter/nft_compat.c                     |   9 ++
 net/netfilter/nft_exthdr.c                     |  96 +++++++++++++++++-
 net/sched/act_ct.c                             |  13 ---
 33 files changed, 449 insertions(+), 524 deletions(-)

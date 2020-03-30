Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E162F197142
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgC3AhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:17 -0400
Received: from correo.us.es ([193.147.175.20]:57102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgC3AhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4376DEF42D
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3497B100A4E
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A438100A48; Mon, 30 Mar 2020 02:37:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 319AC100A42;
        Mon, 30 Mar 2020 02:37:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0BEF642EF42A;
        Mon, 30 Mar 2020 02:37:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/26] Netfilter/IPVS updates for net-next
Date:   Mon, 30 Mar 2020 02:36:42 +0200
Message-Id: <20200330003708.54017-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Add support to specify a stateful expression in set definitions,
   this allows users to specify e.g. counters per set elements.

2) Flowtable software counter support.

3) Flowtable hardware offload counter support, from wenxu.

3) Parallelize flowtable hardware offload requests, from Paul Blakey.
   This includes a patch to add one work entry per offload command.

4) Several patches to rework nf_queue refcount handling, from Florian
   Westphal.

4) A few fixes for the flowtable tunnel offload: Fix crash if tunneling
   information is missing and set up indirect flow block as TC_SETUP_FT,
   patch from wenxu.

5) Stricter netlink attribute sanity check on filters, from Romain Bellan
   and Florent Fourcot.

5) Annotations to make sparse happy, from Jules Irenge.

6) Improve icmp errors in debugging information, from Haishuang Yan.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 79e28519ac78dde6d38fe6ea22286af574f5c7db:

  Merge tag 'mlx5-updates-2020-03-17' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2020-03-18 19:13:37 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to ef803b3cf96a26e2a601755b237585a23e6bc30c:

  netfilter: flowtable: add counter support in HW offload (2020-03-30 02:05:40 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nf_queue: make nf_queue_entry_release_refs static
      netfilter: nf_queue: place bridge physports into queue_entry struct
      netfilter: nf_queue: do not release refcouts until nf_reinject is done
      netfilter: nf_queue: prefer nf_queue_entry_free

Haishuang Yan (1):
      ipvs: optimize tunnel dumps for icmp errors

Jules Irenge (2):
      netfilter: ctnetlink: Add missing annotation for ctnetlink_parse_nat_setup()
      netfilter: conntrack: Add missing annotations for nf_conntrack_all_lock() and nf_conntrack_all_unlock()

Pablo Neira Ayuso (11):
      netfilter: nf_tables: move nft_expr_clone() to nf_tables_api.c
      netfilter: nf_tables: pass context to nft_set_destroy()
      netfilter: nf_tables: allow to specify stateful expression in set definition
      netfilter: nf_tables: fix double-free on set expression from the error path
      netfilter: nf_tables: add nft_set_elem_expr_destroy() and use it
      netfilter: conntrack: export nf_ct_acct_update()
      netfilter: nf_tables: add enum nft_flowtable_flags to uapi
      netfilter: flowtable: add counter support
      netfilter: nft_set_bitmap: initialize set element extension in lookups
      netfilter: nft_dynset: validate set expression definition
      netfilter: nf_tables: skip set types that do not support for expressions

Paul Blakey (2):
      netfilter: flowtable: Use rw sem as flow block lock
      netfilter: flowtable: Use work entry per offload command

Qian Cai (1):
      netfilter: nf_tables: silence a RCU-list warning in nft_table_lookup()

Romain Bellan (1):
      netfilter: ctnetlink: be more strict when NF_CONNTRACK_MARK is not set

wenxu (4):
      netfilter: flowtable: fix NULL pointer dereference in tunnel offload support
      netfilter: flowtable: Fix incorrect tc_setup_type type
      netfilter: conntrack: add nf_ct_acct_add()
      netfilter: flowtable: add counter support in HW offload

 include/net/flow_offload.h                |   3 +-
 include/net/netfilter/nf_conntrack_acct.h |  11 +++
 include/net/netfilter/nf_flow_table.h     |   5 +-
 include/net/netfilter/nf_queue.h          |   7 +-
 include/net/netfilter/nf_tables.h         |   5 ++
 include/uapi/linux/netfilter/nf_tables.h  |  15 ++++
 net/core/flow_offload.c                   |   6 +-
 net/netfilter/ipvs/ip_vs_core.c           |  46 ++++++-----
 net/netfilter/nf_conntrack_core.c         |  18 +++--
 net/netfilter/nf_conntrack_netlink.c      |   3 +-
 net/netfilter/nf_flow_table_core.c        |  11 ++-
 net/netfilter/nf_flow_table_ip.c          |   7 ++
 net/netfilter/nf_flow_table_offload.c     |  70 ++++++++---------
 net/netfilter/nf_queue.c                  |  96 ++++++++++-------------
 net/netfilter/nf_tables_api.c             | 125 +++++++++++++++++++++++-------
 net/netfilter/nf_tables_offload.c         |   2 +-
 net/netfilter/nfnetlink_queue.c           |  10 +--
 net/netfilter/nft_dynset.c                |  26 ++-----
 net/netfilter/nft_set_bitmap.c            |   3 +
 net/sched/cls_api.c                       |   2 +-
 20 files changed, 278 insertions(+), 193 deletions(-)

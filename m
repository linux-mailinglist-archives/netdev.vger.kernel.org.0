Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596493FB33C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhH3Jj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:39:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42584 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhH3Jj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:39:57 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B7B76003C;
        Mon, 30 Aug 2021 11:38:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/8] Netfilter updates for net-next
Date:   Mon, 30 Aug 2021 11:38:44 +0200
Message-Id: <20210830093852.21654-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Clean up and consolidate ct ecache infrastructure by merging ct and
   expect notifiers, from Florian Westphal.

2) Missing counters and timestamp in nfnetlink_queue and _log conntrack
   information.

3) Missing error check for xt_register_template() in iptables mangle,
   as a incremental fix for the previous pull request, also from
   Florian Westphal.

4) Add netfilter hooks for the SRv6 lightweigh tunnel driver, from
   Ryoga Sato. The hooks are enabled via nf_hooks_lwtunnel sysctl
   to make sure existing netfilter rulesets do not break. There is
   a static key to disable the hooks by default.

   The pktgen_bench_xmit_mode_netif_receive.sh shows no noticeable
   impact in the seg6_input path for non-netfilter users: similar
   numbers with and without this patch.

   This is a sample of the perf report output:

    11.67%  kpktgend_0       [ipv6]                    [k] ipv6_get_saddr_eval
     7.89%  kpktgend_0       [ipv6]                    [k] __ipv6_addr_label
     7.52%  kpktgend_0       [ipv6]                    [k] __ipv6_dev_get_saddr
     6.63%  kpktgend_0       [kernel.vmlinux]          [k] asm_exc_nmi
     4.74%  kpktgend_0       [ipv6]                    [k] fib6_node_lookup_1
     3.48%  kpktgend_0       [kernel.vmlinux]          [k] pskb_expand_head
     3.33%  kpktgend_0       [ipv6]                    [k] ip6_rcv_core.isra.29
     3.33%  kpktgend_0       [ipv6]                    [k] seg6_do_srh_encap
     2.53%  kpktgend_0       [ipv6]                    [k] ipv6_dev_get_saddr
     2.45%  kpktgend_0       [ipv6]                    [k] fib6_table_lookup
     2.24%  kpktgend_0       [kernel.vmlinux]          [k] ___cache_free
     2.16%  kpktgend_0       [ipv6]                    [k] ip6_pol_route
     2.11%  kpktgend_0       [kernel.vmlinux]          [k] __ipv6_addr_type

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 87e5ef4b19cec86c861e3ebab3a5d840ecc2f4a4:

  mctp: Remove the repeated declaration (2021-08-25 11:23:14 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 7a3f5b0de3647c854e34269c3332d7a1e902901a:

  netfilter: add netfilter hooks to SRv6 data plane (2021-08-30 01:51:36 +0200)

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: ecache: remove one indent level
      netfilter: ecache: remove another indent level
      netfilter: ecache: add common helper for nf_conntrack_eventmask_report
      netfilter: ecache: prepare for event notifier merge
      netfilter: ecache: remove nf_exp_event_notifier structure

Lukas Bulwahn (1):
      netfilter: x_tables: handle xt_register_template() returning an error value

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: missing counters and timestamp in nfnetlink_{log,queue}

Ryoga Saito (1):
      netfilter: add netfilter hooks to SRv6 data plane

 Documentation/networking/nf_conntrack-sysctl.rst |   7 +
 include/net/lwtunnel.h                           |   3 +
 include/net/netfilter/nf_conntrack_ecache.h      |  32 ++--
 include/net/netfilter/nf_hooks_lwtunnel.h        |   7 +
 include/net/netns/conntrack.h                    |   1 -
 net/core/lwtunnel.c                              |   3 +
 net/ipv4/netfilter/iptable_mangle.c              |   2 +
 net/ipv6/seg6_iptunnel.c                         |  75 +++++++-
 net/ipv6/seg6_local.c                            | 111 ++++++++----
 net/netfilter/Makefile                           |   3 +
 net/netfilter/nf_conntrack_ecache.c              | 211 +++++++++--------------
 net/netfilter/nf_conntrack_netlink.c             |  56 ++----
 net/netfilter/nf_conntrack_standalone.c          |  15 ++
 net/netfilter/nf_hooks_lwtunnel.c                |  53 ++++++
 14 files changed, 345 insertions(+), 234 deletions(-)
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c

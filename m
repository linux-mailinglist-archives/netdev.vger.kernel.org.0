Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225533204E
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfFASYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:05 -0400
Received: from mail.us.es ([193.147.175.20]:39994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfFASYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3205EB60DC
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CFB3DA708
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6829ADA714; Sat,  1 Jun 2019 20:23:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FE02FC3FE;
        Sat,  1 Jun 2019 20:23:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BE4194265A32;
        Sat,  1 Jun 2019 20:23:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/15] Netfilter/IPVS updates for net-next
Date:   Sat,  1 Jun 2019 20:23:25 +0200
Message-Id: <20190601182340.2662-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following patchset container Netfilter/IPVS update for net-next:

1) Add UDP tunnel support for ICMP errors in IPVS.

Julian Anastasov says:

This patchset is a followup to the commit that adds UDP/GUE tunnel:
"ipvs: allow tunneling with gue encapsulation".

What we do is to put tunnel real servers in hash table (patch 1),
add function to lookup tunnels (patch 2) and use it to strip the
embedded tunnel headers from ICMP errors (patch 3).

2) Extend xt_owner to match for supplementary groups, from
   Lukasz Pawelczyk.

3) Remove unused oif field in flow_offload_tuple object, from
   Taehee Yoo.

4) Release basechain counters from workqueue to skip synchronize_rcu()
   call. From Florian Westphal.

5) Replace skb_make_writable() by skb_ensure_writable(). Patchset
   from Florian Westphal.

6) Checksum support for gue encapsulation in IPVS, from Jacky Hu.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 7b3ed2a137b077bc0967352088b0adb6049eed20:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue (2019-05-30 15:17:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 29930e314da3833437a2ddc7b17f6a954f38d8fb:

  ipvs: add checksum support for gue encapsulation (2019-05-31 18:23:52 +0200)

----------------------------------------------------------------
Florian Westphal (9):
      netfilter: nf_tables: free base chain counters from worker
      netfilter: bridge: convert skb_make_writable to skb_ensure_writable
      netfilter: ipvs: prefer skb_ensure_writable
      netfilter: conntrack, nat: prefer skb_ensure_writable
      netfilter: ipv4: prefer skb_ensure_writable
      netfilter: nf_tables: prefer skb_ensure_writable
      netfilter: xt_HL: prefer skb_ensure_writable
      netfilter: tcpmss, optstrip: prefer skb_ensure_writable
      netfilter: replace skb_make_writable with skb_ensure_writable

Jacky Hu (1):
      ipvs: add checksum support for gue encapsulation

Julian Anastasov (3):
      ipvs: allow rs_table to contain different real server types
      ipvs: add function to find tunnels
      ipvs: strip udp tunnel headers from icmp errors

Lukasz Pawelczyk (1):
      netfilter: xt_owner: Add supplementary groups option

Taehee Yoo (1):
      netfilter: nf_flow_table: remove unnecessary variable in flow_offload_tuple

 include/linux/netfilter.h                   |   5 -
 include/net/ip_vs.h                         |   8 ++
 include/net/netfilter/nf_flow_table.h       |   2 -
 include/uapi/linux/ip_vs.h                  |   7 ++
 include/uapi/linux/netfilter/xt_owner.h     |   7 +-
 net/bridge/netfilter/ebt_dnat.c             |   2 +-
 net/bridge/netfilter/ebt_redirect.c         |   2 +-
 net/bridge/netfilter/ebt_snat.c             |   2 +-
 net/ipv4/netfilter/arpt_mangle.c            |   2 +-
 net/ipv4/netfilter/ipt_ECN.c                |   4 +-
 net/ipv4/netfilter/nf_nat_h323.c            |   2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |   2 +-
 net/netfilter/core.c                        |  22 ----
 net/netfilter/ipvs/ip_vs_app.c              |   4 +-
 net/netfilter/ipvs/ip_vs_core.c             |  72 ++++++++++++-
 net/netfilter/ipvs/ip_vs_ctl.c              |  83 +++++++++++++--
 net/netfilter/ipvs/ip_vs_ftp.c              |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c       |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c        |   4 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c        |   4 +-
 net/netfilter/ipvs/ip_vs_xmit.c             | 155 ++++++++++++++++++++++++----
 net/netfilter/nf_conntrack_proto_sctp.c     |   2 +-
 net/netfilter/nf_conntrack_seqadj.c         |   4 +-
 net/netfilter/nf_flow_table_core.c          |   1 -
 net/netfilter/nf_nat_helper.c               |   4 +-
 net/netfilter/nf_nat_proto.c                |  24 ++---
 net/netfilter/nf_nat_sip.c                  |   2 +-
 net/netfilter/nf_synproxy_core.c            |   2 +-
 net/netfilter/nf_tables_api.c               |  26 ++---
 net/netfilter/nfnetlink_queue.c             |   2 +-
 net/netfilter/nft_exthdr.c                  |   3 +-
 net/netfilter/nft_payload.c                 |   6 +-
 net/netfilter/xt_DSCP.c                     |   8 +-
 net/netfilter/xt_HL.c                       |   4 +-
 net/netfilter/xt_TCPMSS.c                   |   2 +-
 net/netfilter/xt_TCPOPTSTRIP.c              |  28 +++--
 net/netfilter/xt_owner.c                    |  23 ++++-
 37 files changed, 389 insertions(+), 149 deletions(-)

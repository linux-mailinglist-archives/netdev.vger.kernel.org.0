Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D842100E38
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKRVt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:29 -0500
Received: from correo.us.es ([193.147.175.20]:45688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKRVt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DFA0EB470
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F4177D2B1E
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F286D21FE5; Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF93BDA4D0;
        Mon, 18 Nov 2019 22:49:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A278142EE38F;
        Mon, 18 Nov 2019 22:49:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/18] Netfilter updates for net-next
Date:   Mon, 18 Nov 2019 22:48:56 +0100
Message-Id: <20191118214914.142794-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Wildcard support for the net,iface set from Kristian Evensen.

2) Offload support for matching on the input interface.

3) Simplify matching on vlan header fields.

4) Add nft_payload_rebuild_vlan_hdr() function to rebuild the vlan
   header from the vlan sk_buff metadata.

5) Pass extack to nft_flow_cls_offload_setup().

6) Add C-VLAN matching support.

7) Use time64_t in xt_time to fix y2038 overflow, from Arnd Bergmann.

8) Use time_t in nft_meta to fix y2038 overflow, also from Arnd.

9) Add flow_action_entry_next() helper function to flowtable offload
   infrastructure.

10) Add IPv6 support to the flowtable offload infrastructure.

11) Support for input interface matching from postrouting,
    from Phil Sutter.

12) Missing check for ndo callback in flowtable offload, from wenxu.

13) Remove conntrack parameter from flow_offload_fill_dir(), from wenxu.

14) Do not pass flow_rule object for rule removal, cookie is sufficient
    to achieve this.

15) Release flow_rule object in case of error from the offload commit
    path.

16) Undo offload ruleset updates if transaction fails.

17) Check for error when binding flowtable callbacks, from wenxu.

18) Always unbind flowtable callbacks when unregistering hooks.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 90bc72b13c08eedf73b7c0bd94ef23c467800c4a:

  Merge branch 'ARM-Enable-GENET-support-for-RPi-4' (2019-11-12 20:08:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to ff4bf2f42a40e7dff28379f085b64df322c70b45:

  netfilter: nf_tables: add nft_unregister_flowtable_hook() (2019-11-15 23:44:54 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      netfilter: xt_time: use time64_t
      netfilter: nft_meta: use 64-bit time arithmetic

Kristian Evensen (1):
      netfilter: ipset: Add wildcard support to net,iface

Pablo Neira Ayuso (12):
      netfilter: nft_meta: offload support for interface index
      netfilter: nft_payload: simplify vlan header handling
      netfilter: nf_tables: add nft_payload_rebuild_vlan_hdr()
      netfilter: nf_tables_offload: pass extack to nft_flow_cls_offload_setup()
      netfilter: nft_payload: add C-VLAN support
      Merge branch 'master' of git://blackhole.kfki.hu/nf-next
      netfilter: nf_flow_table_offload: add flow_action_entry_next() and use it
      netfilter: nf_flow_table_offload: add IPv6 support
      netfilter: nf_tables_offload: remove reference to flow rule from deletion path
      netfilter: nf_tables_offload: release flow_rule on error from commit path
      netfilter: nf_tables_offload: undo updates if transaction fails
      netfilter: nf_tables: add nft_unregister_flowtable_hook()

Phil Sutter (1):
      netfilter: Support iif matches in POSTROUTING

wenxu (3):
      netfilter: nf_flow_table_offload: Fix check ndo_setup_tc when setup_block
      netfilter: nf_flow_table: remove unnecessary parameter in flow_offload_fill_dir
      netfilter: nf_tables: check if bind callback fails and unbind if hook registration fails

 include/net/netfilter/nf_flow_table.h       |   9 +-
 include/net/netfilter/nf_tables_offload.h   |   1 +
 include/uapi/linux/netfilter/ipset/ip_set.h |   2 +
 net/ipv4/ip_output.c                        |   4 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c     |   2 +-
 net/ipv4/xfrm4_output.c                     |   2 +-
 net/ipv6/ip6_output.c                       |   4 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c     |   2 +-
 net/ipv6/xfrm6_output.c                     |   2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c  |  23 +++-
 net/netfilter/nf_flow_table_core.c          |   8 +-
 net/netfilter/nf_flow_table_inet.c          |  25 +++-
 net/netfilter/nf_flow_table_offload.c       | 179 +++++++++++++++++++++-------
 net/netfilter/nf_tables_api.c               |  49 ++++++--
 net/netfilter/nf_tables_offload.c           |  95 +++++++++++++--
 net/netfilter/nft_meta.c                    |  14 ++-
 net/netfilter/nft_payload.c                 |  56 +++++----
 net/netfilter/xt_time.c                     |  19 +--
 18 files changed, 370 insertions(+), 126 deletions(-)

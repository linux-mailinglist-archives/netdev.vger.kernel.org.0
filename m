Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF551496EC
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 18:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgAYReZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from correo.us.es ([193.147.175.20]:35448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgAYReZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4224C12C1E4
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 354C4DA713
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 29BB2DA710; Sat, 25 Jan 2020 18:34:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 189DFDA702;
        Sat, 25 Jan 2020 18:34:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E962342EE38E;
        Sat, 25 Jan 2020 18:34:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Sat, 25 Jan 2020 18:34:08 +0100
Message-Id: <20200125173415.191571-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Missing netlink attribute sanity check for NFTA_OSF_DREG,
   from Florian Westphal.

2) Use bitmap infrastructure in ipset to fix KASAN slab-out-of-bounds
   reads, from Jozsef Kadlecsik.

3) Missing initial CLOSED state in new sctp connection through
   ctnetlink events, from Jiri Wiesner.

4) Missing check for NFT_CHAIN_HW_OFFLOAD in nf_tables offload
   indirect block infrastructure, from wenxu.

5) Add __nft_chain_type_get() to sanity check family and chain type.

6) Autoload modules from the nf_tables abort path to fix races
   reported by syzbot.

7) Remove unnecessary skb->csum update on inet_proto_csum_replace16(),
   from Praveen Chaudhary.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit e02d9c4c68dc0ca08ded9487720bba775c09669b:

  Merge branch 'bnxt_en-fixes' (2020-01-18 14:38:30 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 189c9b1e94539b11c80636bc13e9cf47529e7bba:

  net: Fix skb->csum update in inet_proto_csum_replace16(). (2020-01-24 20:54:30 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_osf: add missing check for DREG attribute

Jiri Wiesner (1):
      netfilter: conntrack: sctp: use distinct states for new SCTP connections

Kadlecsik József (1):
      netfilter: ipset: use bitmap infrastructure completely

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add __nft_chain_type_get()
      netfilter: nf_tables: autoload modules from the abort path

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

wenxu (1):
      netfilter: nf_tables_offload: fix check the chain offload flag

 include/linux/netfilter/ipset/ip_set.h    |   7 --
 include/linux/netfilter/nfnetlink.h       |   2 +-
 include/net/netns/nftables.h              |   1 +
 net/core/utils.c                          |  20 +++-
 net/netfilter/ipset/ip_set_bitmap_gen.h   |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c    |   6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  |   6 +-
 net/netfilter/nf_conntrack_proto_sctp.c   |   6 +-
 net/netfilter/nf_tables_api.c             | 155 +++++++++++++++++++++---------
 net/netfilter/nf_tables_offload.c         |   2 +-
 net/netfilter/nfnetlink.c                 |   6 +-
 net/netfilter/nft_osf.c                   |   3 +
 13 files changed, 146 insertions(+), 76 deletions(-)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4AB13F9F7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732378AbgAPTvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:20 -0500
Received: from correo.us.es ([193.147.175.20]:56006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgAPTux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 169FD807E0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09144DA71F
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F107BDA705; Thu, 16 Jan 2020 20:50:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 997BDDA714;
        Thu, 16 Jan 2020 20:50:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7A11E42EF9E1;
        Thu, 16 Jan 2020 20:50:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/9] Netfilter updates for net
Date:   Thu, 16 Jan 2020 20:50:35 +0100
Message-Id: <20200116195044.326614-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The following patchset contains Netfilter fixes for net:

1) Fix use-after-free in ipset bitmap destroy path, from Cong Wang.

2) Missing init netns in entry cleanup path of arp_tables,
   from Florian Westphal.

3) Fix WARN_ON in set destroy path due to missing cleanup on
   transaction error.

4) Incorrect netlink sanity check in tunnel, from Florian Westphal.

5) Missing sanity check for erspan version netlink attribute, also
   from Florian.

6) Remove WARN in nft_request_module() that can be triggered from
   userspace, from Florian Westphal.

7) Memleak in NFTA_HOOK_DEVS netlink parser, from Dan Carpenter.

8) List poison from commit path for flowtables that are added and
   deleted in the same batch, from Florian Westphal.

9) Fix NAT ICMP packet corruption, from Eyal Birger.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit c9f53049d4a842db6bcd76f597759a0ef5f65c86:

  MAINTAINERS: update my email address (2020-01-11 14:33:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 61177e911dad660df86a4553eb01c95ece2f6a82:

  netfilter: nat: fix ICMP header corruption on ICMP errors (2020-01-16 15:08:25 +0100)

----------------------------------------------------------------
Cong Wang (1):
      netfilter: fix a use-after-free in mtype_destroy()

Dan Carpenter (1):
      netfilter: nf_tables: fix memory leak in nf_tables_parse_netdev_hooks()

Eyal Birger (1):
      netfilter: nat: fix ICMP header corruption on ICMP errors

Florian Westphal (5):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
      netfilter: nft_tunnel: fix null-attribute check
      netfilter: nft_tunnel: ERSPAN_VERSION must not be null
      netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
      netfilter: nf_tables: fix flowtable list del corruption

Pablo Neira Ayuso (1):
      netfilter: nf_tables: store transaction list locally while requesting module

 net/ipv4/netfilter/arp_tables.c         | 19 ++++++++--------
 net/netfilter/ipset/ip_set_bitmap_gen.h |  2 +-
 net/netfilter/nf_nat_proto.c            | 13 +++++++++++
 net/netfilter/nf_tables_api.c           | 39 ++++++++++++++++++++++-----------
 net/netfilter/nft_tunnel.c              |  5 ++++-
 5 files changed, 54 insertions(+), 24 deletions(-)

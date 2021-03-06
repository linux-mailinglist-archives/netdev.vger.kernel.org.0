Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC732FA77
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 13:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCFMMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 07:12:51 -0500
Received: from correo.us.es ([193.147.175.20]:45962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhCFMMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47FCCC5169
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36165DA72F
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2ACCCDA78F; Sat,  6 Mar 2021 13:12:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4BA1DA72F;
        Sat,  6 Mar 2021 13:12:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A594242DC6E5;
        Sat,  6 Mar 2021 13:12:26 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/9] Netfilter fixes for net
Date:   Sat,  6 Mar 2021 13:12:14 +0100
Message-Id: <20210306121223.28711-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix incorrect enum type definition in nfnetlink_cthelper UAPI,
   from Dmitry V. Levin.

2) Remove extra space in deprecated automatic helper assignment
   notice, from Klemen Košir.

3) Drop early socket demux socket after NAT mangling, from
   Florian Westphal. Add a test to exercise this bug.

4) Fix bogus invalid packet report in the conntrack TCP tracker,
   also from Florian.

5) Fix access to xt[NFPROTO_UNSPEC] list with no mutex
   in target/match_revfn(), from Vasily Averin.

6) Disallow updates on the table ownership flag.

7) Fix double hook unregistration of tables with owner.

8) Remove bogus check on the table owner in __nft_release_tables().

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit eee7ede695cfbb19fefdeb14992535b605448f35:

  Merge branch 'bnxt_en-error-recovery-bug-fixes' (2021-02-26 15:50:25 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to bd1777b3a88f98e223392221b330668458aac7f1:

  netfilter: nftables: bogus check for netlink portID with table owner (2021-03-04 04:02:54 +0100)

----------------------------------------------------------------
Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Florian Westphal (3):
      netfilter: nf_nat: undo erroneous tcp edemux lookup
      netfilter: conntrack: avoid misleading 'invalid' in log message
      selftests: netfilter: test nat port clash resolution interaction with tcp early demux

Klemen Košir (1):
      netfilter: conntrack: Remove a double space in a log message

Pablo Neira Ayuso (3):
      netfilter: nftables: disallow updates on table ownership
      netfilter: nftables: fix possible double hook unregistration with table owner
      netfilter: nftables: bogus check for netlink portID with table owner

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

 include/uapi/linux/netfilter/nfnetlink_cthelper.h  |  2 +-
 net/netfilter/nf_conntrack_helper.c                |  3 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  6 +-
 net/netfilter/nf_nat_proto.c                       | 25 +++++-
 net/netfilter/nf_tables_api.c                      | 19 +++--
 net/netfilter/x_tables.c                           |  6 +-
 tools/testing/selftests/netfilter/Makefile         |  2 +-
 tools/testing/selftests/netfilter/nf_nat_edemux.sh | 99 ++++++++++++++++++++++
 8 files changed, 145 insertions(+), 17 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nf_nat_edemux.sh

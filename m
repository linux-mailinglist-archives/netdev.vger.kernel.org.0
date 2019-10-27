Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD9E624D
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 13:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJ0MCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 08:02:39 -0400
Received: from correo.us.es ([193.147.175.20]:60104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfJ0MCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC9EE7FC3D
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE17666DD
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3633DA7B6; Sun, 27 Oct 2019 13:02:33 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71624DA801;
        Sun, 27 Oct 2019 13:02:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F53142EE395;
        Sun, 27 Oct 2019 13:02:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter/IPVS fixes for net
Date:   Sun, 27 Oct 2019 13:02:16 +0100
Message-Id: <20191027120221.2884-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix crash on flowtable due to race between garbage collection
   and insertion.

2) Restore callback unbinding in netfilter offloads.

3) Fix races on IPVS module removal, from Davide Caratti.

4) Make old_secure_tcp per-netns to fix sysbot report,
   from Eric Dumazet.

5) Validate matching length in netfilter offloads, from wenxu.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 6c5d9c2a6bedbb3c3c14253776320c0ee564f064:

  ipv6: include <net/addrconf.h> for missing declarations (2019-10-22 15:17:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 52b33b4f8186669ab88b56cf5b2812e3996ef289:

  Merge tag 'ipvs-fixes-for-v5.4' of https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs (2019-10-26 12:42:45 +0200)

----------------------------------------------------------------
Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Eric Dumazet (1):
      ipvs: move old_secure_tcp into struct netns_ipvs

Pablo Neira Ayuso (3):
      netfilter: nf_flow_table: set timeout before insertion into hashes
      netfilter: nf_tables_offload: restore basechain deletion
      Merge tag 'ipvs-fixes-for-v5.4' of https://git.kernel.org/.../horms/ipvs

wenxu (1):
      netfilter: nft_payload: fix missing check for matching length in offloads

 include/net/ip_vs.h                |  1 +
 net/netfilter/ipvs/ip_vs_app.c     | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c     | 29 +++++++++++------------------
 net/netfilter/ipvs/ip_vs_pe.c      |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c   |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c    | 13 ++++++++++---
 net/netfilter/nf_flow_table_core.c |  3 ++-
 net/netfilter/nf_tables_offload.c  |  2 +-
 net/netfilter/nft_payload.c        | 38 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 77 insertions(+), 27 deletions(-)

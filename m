Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52D2C6C1B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgK0Tnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:43:49 -0500
Received: from correo.us.es ([193.147.175.20]:53118 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbgK0TD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:03:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8257BAEE0
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A86D4DA73F
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9DEF2DA704; Fri, 27 Nov 2020 20:03:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F71BDA73F;
        Fri, 27 Nov 2020 20:03:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Nov 2020 20:03:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 41E8D4301DE0;
        Fri, 27 Nov 2020 20:03:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Fri, 27 Nov 2020 20:03:08 +0100
Message-Id: <20201127190313.24947-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix insufficient validation of IPSET_ATTR_IPADDR_IPV6 reported
   by syzbot.

2) Remove spurious reports on nf_tables when lockdep gets disabled,
   from Florian Westphal.

3) Fix memleak in the error path of error path of
   ip_vs_control_net_init(), from Wang Hai.

4) Fix missing control data in flow dissector, otherwise IP address
   matching in hardware offload infra does not work.

5) Fix hardware offload match on prefix IP address when userspace
   does not send a bitwise expression to represent the prefix.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks Jakub.

----------------------------------------------------------------

The following changes since commit 90cf87d16bd566cff40c2bc8e32e6d4cd3af23f0:

  enetc: Let the hardware auto-advance the taprio base-time of 0 (2020-11-25 12:36:27 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to a5d45bc0dc50f9dd83703510e9804d813a9cac32:

  netfilter: nftables_offload: build mask based from the matching bytes (2020-11-27 12:10:47 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: ipset: prevent uninit-value in hash_ip6_add

Florian Westphal (1):
      netfilter: nf_tables: avoid false-postive lockdep splat

Pablo Neira Ayuso (2):
      netfilter: nftables_offload: set address type in control dissector
      netfilter: nftables_offload: build mask based from the matching bytes

Wang Hai (1):
      ipvs: fix possible memory leak in ip_vs_control_net_init

 include/net/netfilter/nf_tables_offload.h |  7 ++++
 net/netfilter/ipset/ip_set_core.c         |  3 +-
 net/netfilter/ipvs/ip_vs_ctl.c            | 31 +++++++++++---
 net/netfilter/nf_tables_api.c             |  3 +-
 net/netfilter/nf_tables_offload.c         | 17 ++++++++
 net/netfilter/nft_cmp.c                   |  8 ++--
 net/netfilter/nft_meta.c                  | 16 +++----
 net/netfilter/nft_payload.c               | 70 +++++++++++++++++++++++--------
 8 files changed, 117 insertions(+), 38 deletions(-)

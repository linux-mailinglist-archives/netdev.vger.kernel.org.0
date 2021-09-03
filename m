Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DDE40034E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349941AbhICQb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:31:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58752 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbhICQb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:31:29 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id E2AF4600A8;
        Fri,  3 Sep 2021 18:29:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Fri,  3 Sep 2021 18:30:15 +0200
Message-Id: <20210903163020.13741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Protect nft_ct template with global mutex, from Pavel Skripkin.

2) Two recent commits switched inet rt and nexthop exception hashes
   from jhash to siphash. If those two spots are problematic then
   conntrack is affected as well, so switch voer to siphash too.
   While at it, add a hard upper limit on chain lengths and reject
   insertion if this is hit. Patches from Florian Westphal.

3) Fix use-after-scope in nf_socket_ipv6 reported by KASAN,
   from Benjamin Hesmans.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 519133debcc19f5c834e7e28480b60bdc234fe02:

  net: bridge: fix memleak in br_add_if() (2021-08-10 13:25:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 730affed24bffcd1eebd5903171960f5ff9f1f22:

  netfilter: socket: icmp6: fix use-after-scope (2021-09-03 18:25:31 +0200)

----------------------------------------------------------------
Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Florian Westphal (3):
      netfilter: conntrack: sanitize table size default settings
      netfilter: conntrack: switch to siphash
      netfilter: refuse insertion if chain has grown too large

Pavel Skripkin (1):
      netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

 Documentation/networking/nf_conntrack-sysctl.rst   |  13 ++-
 include/linux/netfilter/nf_conntrack_common.h      |   1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 net/ipv6/netfilter/nf_socket_ipv6.c                |   4 +-
 net/netfilter/nf_conntrack_core.c                  | 103 ++++++++++++++-------
 net/netfilter/nf_conntrack_expect.c                |  25 +++--
 net/netfilter/nf_conntrack_netlink.c               |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   4 +-
 net/netfilter/nf_nat_core.c                        |  18 +++-
 net/netfilter/nft_ct.c                             |   9 +-
 10 files changed, 123 insertions(+), 59 deletions(-)

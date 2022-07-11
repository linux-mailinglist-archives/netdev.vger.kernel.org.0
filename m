Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DB56FE8F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiGKKOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiGKKOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:14:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B5D84A825;
        Mon, 11 Jul 2022 02:34:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Mon, 11 Jul 2022 11:33:54 +0200
Message-Id: <20220711093357.107260-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) refcount_inc_not_zero() is not semantically equivalent to
   atomic_int_not_zero(), from Florian Westphal. My understanding was
   that refcount_*() API provides a wrapper to easier debugging of
   reference count leaks, however, there are semantic differences
   between these two APIs, where refcount_inc_not_zero() needs a barrier.
   Reason for this subtle difference to me is unknown.

2) packet logging is not correct for ARP and IP packets, from the
   ARP family and netdev/egress respectively. Use skb_network_offset()
   to reach the headers accordingly.

3) set element extension length have been growing over time, replace
   a BUG_ON by EINVAL which might be triggerable from userspace.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 280e3a857d96f9ca8e24632788e1e7a0fec4e9f7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-07-03 12:29:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c39ba4de6b0a843bec5d46c2b6f2064428dada5e:

  netfilter: nf_tables: replace BUG_ON by element length check (2022-07-09 16:25:09 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix crash due to confirmed bit load reordering

Pablo Neira Ayuso (2):
      netfilter: nf_log: incorrect offset to network header
      netfilter: nf_tables: replace BUG_ON by element length check

 include/net/netfilter/nf_tables.h       | 14 ++++---
 net/netfilter/nf_conntrack_core.c       | 22 ++++++++++
 net/netfilter/nf_conntrack_netlink.c    |  1 +
 net/netfilter/nf_conntrack_standalone.c |  3 ++
 net/netfilter/nf_log_syslog.c           |  8 ++--
 net/netfilter/nf_tables_api.c           | 72 +++++++++++++++++++++++----------
 6 files changed, 90 insertions(+), 30 deletions(-)

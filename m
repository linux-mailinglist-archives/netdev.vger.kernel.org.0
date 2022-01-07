Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1A48719E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346002AbiAGEDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345764AbiAGEDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:03:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F84C061245;
        Thu,  6 Jan 2022 20:03:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n5gTZ-0005OI-8Q; Fri, 07 Jan 2022 05:03:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: conntrack related cleanups
Date:   Fri,  7 Jan 2022 05:03:21 +0100
Message-Id: <20220107040326.28038-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains cleanups to conntrack and related
users such as ovs and act_ct.

First patch converts conntrack reference counting to refcount_t api.
Second patch gets rid of ip_ct_attach hook, we can use existing
nf_ct_hook for this.

Third patch constifies a couple of structures that don't need to be
writeable.

Last two patches splits nf_ct_put and nf_conntrack_put.
These functions still do the same thing, but now only nf_conntrack_put
uses the nf_ct_hook indirection, nf_ct_put uses a direct call.
Virtually all places should use nf_ct_put -- only core kernel code
needs to use the indirection.

Before this change, nf_ct_put was merely an alias for nf_conntrack_put
so even conntrack itself did additional indirection.

Florian Westphal (5):
  netfilter: conntrack: convert to refcount_t api
  netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
  netfilter: make function op structures const
  netfilter: conntrack: avoid useless indirection during conntrack
    destruction
  net: prefer nf_ct_put instead of nf_conntrack_put

 include/linux/netfilter.h                     | 10 ++--
 include/linux/netfilter/nf_conntrack_common.h | 10 ++--
 include/net/netfilter/nf_conntrack.h          |  8 ++-
 net/netfilter/core.c                          | 29 +++++------
 net/netfilter/nf_conntrack_core.c             | 50 +++++++++----------
 net/netfilter/nf_conntrack_expect.c           |  4 +-
 net/netfilter/nf_conntrack_netlink.c          | 10 ++--
 net/netfilter/nf_conntrack_standalone.c       |  4 +-
 net/netfilter/nf_flow_table_core.c            |  2 +-
 net/netfilter/nf_nat_core.c                   |  2 +-
 net/netfilter/nf_synproxy_core.c              |  1 -
 net/netfilter/nfnetlink_queue.c               |  8 +--
 net/netfilter/nft_ct.c                        |  4 +-
 net/netfilter/xt_CT.c                         |  3 +-
 net/openvswitch/conntrack.c                   | 15 ++++--
 net/sched/act_ct.c                            |  7 ++-
 16 files changed, 84 insertions(+), 83 deletions(-)

-- 
2.34.1


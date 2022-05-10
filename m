Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223B252151C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbiEJMZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241291AbiEJMZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC3F8E1BC;
        Tue, 10 May 2022 05:21:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/17] Netfilter updates for net-next
Date:   Tue, 10 May 2022 14:21:33 +0200
Message-Id: <20220510122150.92533-1-pablo@netfilter.org>
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

The following patchset contains Netfilter updates for net-next,
mostly updates to conntrack from Florian Westphal:

1) Add a dedicated list for conntrack event redelivery.

2) Include event redelivery list in conntrack dumps of dying type.

3) Remove per-cpu dying list for event redelivery, not used anymore.

4) Add netns .pre_exit to cttimeout to zap timeout objects before
   synchronize_rcu() call.

5) Remove nf_ct_unconfirmed_destroy.

6) Add generation id for conntrack extensions for conntrack
   timeout and helpers.

7) Detach timeout policy from conntrack on cttimeout module removal.

8) Remove __nf_ct_unconfirmed_destroy.

9) Remove unconfirmed list.

10) Remove unconditional local_bh_disable in init_conntrack().

11) Consolidate conntrack iterator nf_ct_iterate_cleanup().

12) Detect if ctnetlink listeners exist to short-circuit event
    path early.

13) Un-inline nf_ct_ecache_ext_add().

14) Add nf_conntrack_events autodetect ctnetlink listener mode
    and make it default.

15) Add nf_ct_ecache_exist() to check for event cache extension.

16) Extend flowtable reverse route lookup to include source, iif,
    tos and mark, from Sven Auhagen.

17) Do not verify zero checksum UDP packets in nf_reject,
    from Kevin Mitchell.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit a997157e42e3119b13c644549a3d8381a1d825d6:

  docs: net: dsa: describe issues with checksum offload (2022-04-18 13:29:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 69e21978509140d837881bcd87a1135905cd9cc6:

  netfilter: conntrack: skip verification of zero UDP checksum (2022-05-09 08:21:08 +0200)

----------------------------------------------------------------
Florian Westphal (14):
      netfilter: ecache: use dedicated list for event redelivery
      netfilter: conntrack: include ecache dying list in dumps
      netfilter: conntrack: remove the percpu dying list
      netfilter: cttimeout: decouple unlink and free on netns destruction
      netfilter: remove nf_ct_unconfirmed_destroy helper
      netfilter: extensions: introduce extension genid count
      netfilter: cttimeout: decouple unlink and free on netns destruction
      netfilter: conntrack: remove __nf_ct_unconfirmed_destroy
      netfilter: conntrack: remove unconfirmed list
      netfilter: conntrack: avoid unconditional local_bh_disable
      netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
      netfilter: conntrack: un-inline nf_ct_ecache_ext_add
      netfilter: conntrack: add nf_conntrack_events autodetect mode
      netfilter: prefer extension check to pointer check

Kevin Mitchell (1):
      netfilter: conntrack: skip verification of zero UDP checksum

Pablo Neira Ayuso (1):
      netfilter: conntrack: add nf_ct_iter_data object for nf_ct_iterate_cleanup*()

Sven Auhagen (1):
      netfilter: flowtable: nft_flow_route use more data for reverse route

 Documentation/networking/nf_conntrack-sysctl.rst |   5 +-
 include/net/netfilter/nf_conntrack.h             |  17 +-
 include/net/netfilter/nf_conntrack_core.h        |   2 +-
 include/net/netfilter/nf_conntrack_ecache.h      |  53 ++--
 include/net/netfilter/nf_conntrack_extend.h      |  31 +--
 include/net/netfilter/nf_conntrack_labels.h      |  10 +-
 include/net/netfilter/nf_conntrack_timeout.h     |   8 -
 include/net/netfilter/nf_reject.h                |  21 +-
 include/net/netns/conntrack.h                    |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c              |  10 +-
 net/ipv6/netfilter/nf_reject_ipv6.c              |   4 +-
 net/netfilter/nf_conntrack_core.c                | 301 ++++++++++-------------
 net/netfilter/nf_conntrack_ecache.c              | 166 ++++++++-----
 net/netfilter/nf_conntrack_extend.c              |  32 ++-
 net/netfilter/nf_conntrack_helper.c              |   5 -
 net/netfilter/nf_conntrack_netlink.c             |  86 ++++---
 net/netfilter/nf_conntrack_proto.c               |  10 +-
 net/netfilter/nf_conntrack_standalone.c          |   2 +-
 net/netfilter/nf_conntrack_timeout.c             |   7 +-
 net/netfilter/nf_nat_masquerade.c                |   5 +-
 net/netfilter/nfnetlink.c                        |  40 ++-
 net/netfilter/nfnetlink_cttimeout.c              |  47 +++-
 net/netfilter/nft_flow_offload.c                 |   8 +
 23 files changed, 495 insertions(+), 383 deletions(-)
